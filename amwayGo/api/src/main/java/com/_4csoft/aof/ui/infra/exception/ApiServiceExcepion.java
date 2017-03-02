/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.exception;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.infra.exception
 * @File : ApiServiceExcepion.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 13.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class ApiServiceExcepion extends RuntimeException {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String errorCode;
	private String errorMessage;

	public ApiServiceExcepion(String errorCode) {
		setErrorCode(errorCode);
	}

	public ApiServiceExcepion(String errorCode, String errorMessage) {
		setErrorCode(errorCode);
		setErrorMessage(errorMessage);
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
}
