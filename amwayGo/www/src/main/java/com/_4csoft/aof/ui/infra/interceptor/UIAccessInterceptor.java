/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;

/**
 * @Project : aof5-demo-www
 * @Package : com._4csoft.aof.ui.infra.interceptor
 * @File : UIAccessInterceptor.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : Access Interceptor
 * @descrption : Controller가 실행되기 전 해당 메뉴의 CRUD 권한을 검사한다 required : session(roleGroupSeq), menuId or requestUri
 */
@Component
public class UIAccessInterceptor extends AccessInterceptor {

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.web.servlet.handler.HandlerInterceptorAdapter#preHandle(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, java.lang.Object)
	 */
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		super.preHandle(request, response, handler);

		return true;
	}

}
