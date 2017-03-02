/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.infra.support.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.security.web.authentication.session.SessionAuthenticationException;

import com._4csoft.aof.infra.support.util.HttpUtil;

/**
 * @Project : aof5-infra
 * @Package : com._4csoft.aof.infra.support.security
 * @File : AuthenticationFailureHandler.java
 * @Title : Authentication Failure Handler
 * @date : 2013. 4. 17.
 * @author : 김종규
 * @descrption : 인증 실패 처리
 */
public class AuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {
	protected final Log log = LogFactory.getLog(getClass());
	private String defaultFailureUrl;
	/** 로그인 실패시 defaultFailureUrl 에 포함되지 않아야 하는 파라미터 지정(복수시 콤마로 구분) **/
	private String exceptReturnParameter;
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();

	public void setDefaultFailureUrl(String defaultFailureUrl) {
		this.defaultFailureUrl = defaultFailureUrl;
	}

	public void setExceptReturnParameter(String exceptReturnParameter) {
		this.exceptReturnParameter = exceptReturnParameter;
	}

	/*
	 * 인증처리가 실패 하였을 때, 보내지는 url 을 결정한다. type 파라미터에 json, xml, html 등의 값을 담아서 응답페이지의 형태를 구분할 수 있다.
	 * 
	 * @see org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler#onAuthenticationFailure(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, org.springframework.security.core.AuthenticationException)
	 */
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException,
			ServletException {
		String url = defaultFailureUrl;
		String[] exceptParam = { "j_username", "j_password" };
		if (exceptReturnParameter != null && exceptReturnParameter.length() > 0 && !exceptReturnParameter.trim().equals("")) {
			String[] excepts = exceptReturnParameter.split(",");
			for (String except : excepts) {
				if (!except.trim().equals("")) {
					exceptParam = (String[])ArrayUtils.add(exceptParam, except.trim());
				}
			}
		}

		String param = HttpUtil.getRequestParametersToQueryString(request, exceptParam);
		String type = HttpUtil.getParameter(request, "type", "");

		if (exception instanceof SessionAuthenticationException) {
			// org.springframework.security.web.authentication.session.SessionAuthenticationException: Maximum sessions of 1 for this principal exceeded
			param += "&param=concurrent";
		} else if (exception instanceof ConcurrentConfirmException) {
			// 처음 user 의 세션을 끊고 로그인 할 것인지 확인하는 페이지
			param += "&param=concurrentConfirm";
		} else if (exception instanceof PreviousAuthenticationException) {
			// 인증 처리 전 수행 시 발생하는 Exception
			param += "&param=previous";
		} else if (exception instanceof AccessRoleException) {
			// 접근 가능 롤그룹 Exception
			param += "&param=accessRole";
		} else {
			// org.springframework.security.authentication.BadCredentialsException: Bad credentials
			param += "&param=failure";
		}

		if (url.indexOf('?') == -1) {
			url += "?";
		}
		super.setDefaultFailureUrl(url + param);
		if ("json".equals(type)) {
			super.setUseForward(true);
		}
		super.onAuthenticationFailure(request, response, exception);
	}
}
