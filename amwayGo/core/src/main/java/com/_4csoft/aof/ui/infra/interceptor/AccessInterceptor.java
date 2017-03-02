/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.LogUtil;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.interceptor
 * @File : AccessInterceptor.java
 * @Title : Access Interceptor
 * @date : 2013. 5. 2.
 * @author : 김종규
 * @descrption : Controller가 실행되기 전 접근성을 검사한다.
 */
@Component
public class AccessInterceptor extends HandlerInterceptorAdapter {
	protected final LogUtil logger = new LogUtil("TRACE_LOGGER");
	protected List<String> historyUrl;
	protected List<String> excludeUrl;
	protected List<String> allowRolegroup;
	protected List<String> allowIp;
	protected List<String> denyIp;

	public void setHistoryUrl(List<String> historyUrl) {
		this.historyUrl = historyUrl;
	}
	
	public void setExcludeUrl(List<String> excludeUrl) {
		this.excludeUrl = excludeUrl;
	}

	public void setAllowRolegroup(List<String> allowRolegroup) {
		this.allowRolegroup = allowRolegroup;
	}

	public void setAllowIp(List<String> allowIp) {
		this.allowIp = allowIp;
	}

	public void setDenyIp(List<String> denyIp) {
		this.denyIp = denyIp;
	}

	public void accessDeny(HttpServletRequest request) throws Exception {
		throw new AofException(Errors.ACCESS_DENIED.desc);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.web.servlet.handler.HandlerInterceptorAdapter#preHandle(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, java.lang.Object)
	 */
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		accessible(request);
		return super.preHandle(request, response, handler);
	}

	/**
	 * 접근성을 검사하고 현재 rolegroup을 setAttribute한다
	 * 
	 * @param request
	 * @throws Exception
	 */
	public void accessible(HttpServletRequest request) throws Exception {
		boolean accessible = true;
		String requestUri = request.getServletPath();
		String remoteAddr = HttpUtil.getRemoteAddr(request);

		// [1].deny Ip
		if (denyIp != null) {
			PathMatcher matcher = new AntPathMatcher();
			for (String pattern : denyIp) {
				if (matcher.match(pattern, remoteAddr)) {
					logger.trace(request, "|AccessInterceptor:pattern:" + pattern + ":ip access denied");
					accessible = false;
					break;
				}
			}
			if (accessible == false) {
				accessDeny(request);
			}
		}

		// [2].allow Ip
		if (allowIp != null) {
			accessible = false;
			PathMatcher matcher = new AntPathMatcher();
			for (String pattern : allowIp) {
				if (matcher.match(pattern, remoteAddr)) {
					logger.trace(request, "|AccessInterceptor:pattern:" + pattern + ":allow ip");
					accessible = true;
					break;
				}
			}
			if (accessible == false) {
				accessDeny(request);
			}
		}

		// [3].검사 생략할 url
		if (excludeUrl != null) {
			PathMatcher matcher = new AntPathMatcher();
			for (String pattern : excludeUrl) {
				if (matcher.match(pattern, requestUri)) {
					request.setAttribute("excludeUrl", "true");
					logger.trace(request, "|AccessInterceptor:pattern:" + pattern + ":url excludes");
					return;
				}
			}
		}

	}
}
