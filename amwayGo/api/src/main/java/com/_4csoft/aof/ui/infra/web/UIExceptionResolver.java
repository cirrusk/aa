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
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;

/**
 * 
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIExceptionResolver.java
 * @Title : Aof Exception Resolver
 * @date : 2015. 3. 13.
 * @author : 노성용
 * @descrption : Exception 이 발생했을 때, Exception message를 가공한다.
 */
public class UIExceptionResolver extends SimpleMappingExceptionResolver {

	protected final LogUtil logger = new LogUtil("ERROR_LOGGER");

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.web.servlet.handler.SimpleMappingExceptionResolver#doResolveException(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, java.lang.Object, java.lang.Exception)
	 */
	protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception) {

		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);
		exception.printStackTrace(pw);

		String detail = sw.toString().replaceAll("\\n", "<br/>").replaceAll("\\r", "");

		StringBuffer buffer = new StringBuffer();

		if (request.getAttribute(Constants.CONTROLLER_STARTTIME) == null) {
			buffer.append("NotStartTime|0 milliseconds");
		} else {
			long startTime = ((Long)request.getAttribute(Constants.CONTROLLER_STARTTIME)).longValue();
			long excuteTime = System.currentTimeMillis() - startTime;
			buffer.append("|" + excuteTime + " milliseconds");
		}
		buffer.append("|" + HttpUtil.getRequestParametersToString(request));
		buffer.append("|" + exception.getStackTrace()[0]);
		buffer.append("|" + detail);
		logger.error(request, buffer.toString());

		if (exception instanceof ApiServiceExcepion) {
			ApiServiceExcepion e = (ApiServiceExcepion)exception;
			ModelAndView mav = new ModelAndView();
			mav.addObject("resultCode", e.getErrorCode());
			if (!StringUtil.isEmpty(e.getErrorMessage())) {
				mav.addObject("resultMessage", e.getErrorMessage());
			}
			mav.setViewName("jsonView");
			return mav;
		} else {

			if (request.getServletPath().startsWith("/api")) {
				ModelAndView mav = new ModelAndView();
				mav.addObject("resultCode", UIApiConstant._SYSTEM_ERROR);
				mav.addObject("resultMessage", exception.getMessage());
				mav.setViewName("jsonView");
				return mav;
			} else {
				return super.doResolveException(request, response, handler, exception);

			}
		}
	}

}
