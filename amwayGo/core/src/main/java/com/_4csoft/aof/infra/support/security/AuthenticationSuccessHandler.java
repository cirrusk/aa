/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.infra.support.security;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;

import com._4csoft.aof.infra.support.util.HttpUtil;

/**
 * @Project : aof5-infra
 * @Package : com._4csoft.aof.infra.support.security
 * @File : AuthenticationSuccessHandler.java
 * @Title : Authentication Success Handler
 * @date : 2013. 4. 17.
 * @author : 김종규
 * @descrption : 인증 성공 처리
 */
public class AuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

	/** 로그인 성공시 defaultTargetUrl 에 포함되지 않아야 하는 파라미터 지정(복수시 콤마로 구분) **/
	private String exceptReturnParameter;
	
    public static String DEFAULT_TARGET_PARAMETER = "spring-security-redirect";
    protected final Log logger = LogFactory.getLog(this.getClass());
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();

	public void setExceptReturnParameter(String exceptReturnParameter) {
		this.exceptReturnParameter = exceptReturnParameter;
	}

	/*
	 * 인증처리가 성공하였을 때, 보내지는 url 을 결정한다. type 파라미터에 json, xml, html 등의 값을 담아서 응답페이지의 형태를 구분할 수 있다.
	 * 
	 * @see
	 * org.springframework.security.web.authentication.AbstractAuthenticationTargetUrlRequestHandler#determineTargetUrl(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse)
	 */
	protected String determineTargetUrl(HttpServletRequest request, HttpServletResponse response) {

		StringBuffer targetUrl = new StringBuffer();
		targetUrl.append(super.determineTargetUrl(request, response));
		String[] exceptParam = { "j_username", "j_password" };
		if (exceptReturnParameter != null && exceptReturnParameter.length() > 0 && !exceptReturnParameter.trim().equals("")) {
			String[] excepts = exceptReturnParameter.split(",");
			for (String except : excepts) {
				if (!except.trim().equals("")) {
					exceptParam = (String[])ArrayUtils.add(exceptParam, except.trim());
				}
			}
		}

		StringBuffer param = new StringBuffer();
		param.append(HttpUtil.getRequestParametersToQueryString(request, exceptParam)).append("&param=success");
		if (targetUrl.toString().indexOf('?') == -1) {
			targetUrl.append('?');
		}
		return targetUrl + param.toString();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler#onAuthenticationSuccess(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, org.springframework.security.core.Authentication)
	 */
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException,
			ServletException {
			
			//System.out.println("==========> onAuthenticationSuccess start method");
			super.clearAuthenticationAttributes(request);
			handle(request, response, authentication);
			/*
			System.out.println("defualt 실행");
			request.getSession().removeAttribute(WebAttributes.SAVED_REQUEST);
			super.onAuthenticationSuccess(request, response, authentication);
			*/
	}

	
	/*
	 * forward로 URL을 보내준다.
	 * 
	 * @see
	 * org.springframework.security.web.authentication.AbstractAuthenticationTargetUrlRequestHandler#handle(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, org.springframework.security.core.Authentication)
	 */
	protected void handle(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws ServletException, IOException{
		
		String type = HttpUtil.getParameter(request, "type", "");
		
        String targetUrl = determineTargetUrl(request, response);

        if (response.isCommitted()) {
            logger.debug("Response has already been committed. Unable to redirect to " + targetUrl);
            return;
        }
        
        if ("json".equals(type)) {
        	//System.out.println("==========> handle in json");
	        RequestDispatcher dispatcher = request.getRequestDispatcher(targetUrl);
			dispatcher.forward(request, response);
        }else{
        	redirectStrategy.sendRedirect(request, response, targetUrl);
        }
	}
}