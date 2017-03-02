/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.io.PrintWriter;
import java.io.StringWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.LogUtil;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : ExceptionResolver.java
 * @Title : Aof Exception Resolver
 * @date : 2013. 5. 3.
 * @author : 김종규
 * @descrption : Exception 이 발생했을 때, Exception message를 가공한다.
 */
public class ExceptionResolver extends SimpleMappingExceptionResolver {
	protected final LogUtil logger = new LogUtil("ERROR_LOGGER");

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.web.servlet.handler.SimpleMappingExceptionResolver#doResolveException(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, java.lang.Object, java.lang.Exception)
	 */
	protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception) {

		long startTime = ((Long)request.getAttribute(Constants.CONTROLLER_STARTTIME)).longValue();
		long excuteTime = System.currentTimeMillis() - startTime;

		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);
		exception.printStackTrace(pw);

		String detail = sw.toString().replaceAll("\\n", "<br/>").replaceAll("\\r", "");

		StringBuffer buffer = new StringBuffer();
		buffer.append("|" + excuteTime + " milliseconds");
		buffer.append("|" + HttpUtil.getRequestParametersToString(request));
		buffer.append("|" + exception.getStackTrace()[0]);
		buffer.append("|" + detail);

		logger.error(request, buffer.toString());

		return super.doResolveException(request, response, handler, exception);
	}
}
