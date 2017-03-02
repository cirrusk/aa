/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.LogUtil;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.interceptor
 * @File : StopwatchInterceptor.java
 * @Title : Stopwatch Interceptor
 * @date : 2013. 4. 17.
 * @author : 김종규
 * @descrption : Controller의 실행 시간을 logging한다
 */
@Component
public class StopwatchInterceptor extends HandlerInterceptorAdapter {
	protected final LogUtil logger = new LogUtil("TRACE_LOGGER");
	protected long startTime = 0;

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.web.servlet.handler.HandlerInterceptorAdapter#preHandle(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, java.lang.Object)
	 */
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		startTime = System.currentTimeMillis();
		request.setAttribute(Constants.CONTROLLER_STARTTIME, startTime);
		logger.trace(request, "|start");
		return super.preHandle(request, response, handler);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.web.servlet.handler.HandlerInterceptorAdapter#postHandle(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, java.lang.Object, org.springframework.web.servlet.ModelAndView)
	 */
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

		super.postHandle(request, response, handler, modelAndView);
		long executeTime = System.currentTimeMillis() - startTime;
		logger.trace(request, "|end|" + executeTime + " milliseconds");
	}
}
