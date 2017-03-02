/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.infra.support.security;

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com._4csoft.aof.infra.support.Constants;

/**
 * @Project : aof5-infra
 * @Package : com._4csoft.aof.infra.support.security
 * @File : AuthenticationProcessingFilter.java
 * @Title : Authentication Processing Filter
 * @date : 2013. 4. 17.
 * @author : 김종규
 * @descrption : 인증 처리
 */
public class AuthenticationProcessingFilter extends UsernamePasswordAuthenticationFilter {

	private PreviousAuthenticationProcessing previousAuthenticationProcessing;
	private AfterAuthenticationProcessing afterAuthenticationProcessing;
	private int previousAuthentication = -1; // 1 : 인증성공, 0: 인증실패, -1: 로컬인증.

	/**
	 * PreviousAuthenticationProcessing setter
	 * 
	 * @param previousAuthenticationProcessing
	 */
	public void setPreviousAuthenticationProcessing(PreviousAuthenticationProcessing previousAuthenticationProcessing) {
		this.previousAuthenticationProcessing = previousAuthenticationProcessing;
	}

	/**
	 * AfterAuthenticationProcessing setter
	 * 
	 * @param afterAuthenticationProcessing
	 */
	public void setAfterAuthenticationProcessing(AfterAuthenticationProcessing afterAuthenticationProcessing) {
		this.afterAuthenticationProcessing = afterAuthenticationProcessing;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter#doFilter(javax.servlet.ServletRequest,
	 * javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest)req;
		if ("https".equalsIgnoreCase(req.getScheme())) {
			HttpsRequestWrapper httpsRequest = new HttpsRequestWrapper(request);
			httpsRequest.setResponse((HttpServletResponse)res);
			super.doFilter(httpsRequest, res, chain);
		} else {
			super.doFilter(req, res, chain);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter#obtainPassword(javax.servlet.http.HttpServletRequest)
	 */
	protected String obtainPassword(HttpServletRequest request) {
		if (previousAuthentication == 1) {
			return previousAuthenticationProcessing.obtainPassword();
		} else {
			String retry = (String)request.getParameter("retryConcurrent"); // 확인 메시지 출력후 다시 로그인을 시도한 경우.
			if ("Y".equals(retry)) {
				String password = (String)request.getSession().getAttribute("retryConcurrent");
				request.getSession().removeAttribute("retryConcurrent");
				return password;
			} else {
				return super.obtainPassword(request);
			}
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter#attemptAuthentication(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse)
	 */
	public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
		if (previousAuthenticationProcessing != null) {
			previousAuthentication = previousAuthenticationProcessing.authenticate(request, response);
		}

		if (previousAuthentication == 0) {
			throw new PreviousAuthenticationException("Invalid user previous");
		} else {
			Authentication authentication = super.attemptAuthentication(request, response);

			// 접근가능 role 검사.
			Map<String, Boolean> map = new HashMap<String, Boolean>();
			for (String role : Constants.ACCESS_ROLES) {
				map.put(role, false);
			}
			Collection<GrantedAuthority> authorities = authentication.getAuthorities();
			Iterator<GrantedAuthority> iteratorAuth = authorities.iterator();
			while (iteratorAuth.hasNext()) {
				GrantedAuthority auth = iteratorAuth.next();
				if (map.containsKey(auth.getAuthority())) {
					map.put(auth.getAuthority(), true);
				}
			}

			Iterator<String> iterator = map.keySet().iterator();
			if ("AND".equals(Constants.ACCESS_ROLES_TYPE)) { // 해당 ROLE이 모두 존재해야 로그인 가능
				while (iterator.hasNext()) {
					String key = (String)iterator.next();
					Boolean match = map.get(key);
					if (!match) {
						throw new AccessRoleException("required role [" + key + "]");
					}
				}

			} else if ("OR".equals(Constants.ACCESS_ROLES_TYPE)) { // 해당 ROLE이 하나만 존재해도 로그인 가능
				boolean possible = false;
				while (iterator.hasNext()) {
					String key = (String)iterator.next();
					Boolean match = map.get(key);
					if (match) {
						possible = true;
					}
				}
				if (!possible) {
					throw new AccessRoleException("required role");
				}

			} else if ("XAND".equals(Constants.ACCESS_ROLES_TYPE)) { // 해당 ROLE이 모두 존재하면 로그인 불가능
				boolean possible = false;
				while (iterator.hasNext()) {
					String key = (String)iterator.next();
					Boolean match = map.get(key);
					if (!match) {
						possible = true;
					}
				}
				if (!possible) {
					throw new AccessRoleException("access denied role");
				}

			} else if ("XOR".equals(Constants.ACCESS_ROLES_TYPE)) { // 해당 ROLE이 하나만 존재해도 로그인 불가능
				while (iterator.hasNext()) {
					String key = (String)iterator.next();
					Boolean match = map.get(key);
					if (match) {
						throw new AccessRoleException("access denied role [" + key + "]");
					}
				}
			}

			if (afterAuthenticationProcessing != null) {
				afterAuthenticationProcessing.process(request, response, authentication);
			}
			return authentication;
		}
	}

}
