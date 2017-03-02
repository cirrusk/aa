/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;

import com._4csoft.aof.infra.support.security.PreviousAuthenticationProcessing;

/**
 * @Project : aof5-admin
 * @Package : com._4csoft.aof.ui.infra.security
 * @File : UIPreviousAuthenticationProcessing.java
 * @Title : Previous Authentication Processing
 * @date : 2013. 4. 23.
 * @author : 김종규
 * @descrption : 인증 처리 전 수행
 */
public class UIPreviousAuthenticationProcessing implements PreviousAuthenticationProcessing {

	private String password;

	public void setPassword(String password) {
		this.password = password;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.security.PreviousAuthenticationProcessing#authenticate(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse)
	 */
	public int authenticate(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {

		// 인증처리를 타서버에서 해야할 경우 구현한다.

		return -1; // 1 : 인증성공, 0: 인증실패, -1: 로컬인증.
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.security.PreviousAuthenticationProcessing#obtainPassword()
	 */
	public String obtainPassword() throws AuthenticationException {

		return password;
	}
}
