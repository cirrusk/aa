/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.support;

/**
 * @Project : lgaca-admin
 * @Package : com._4csoft.aof.ui.univ.support
 * @File : UIExcelException.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 13.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public enum UIExcelException {
	INVALID_FILE(1000, "exception.invalid.file"), // 업로드 파일 에러
	INVALID_NONJOIN(2000, "exception.invalid.nonjoin"), // 회원 아님
	INVALID_DUPLICATE_APPLICATION(3000, "exception.invalid.duplicate.application"); // 중복 수강 신청

	/**
	 * 에러 코드값
	 */
	public final int code;

	/**
	 * 에러 설명
	 */
	public final String desc;

	UIExcelException(final int code, final String desc) {
		this.code = code;
		this.desc = desc;
	}

	/**
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Enum#toString()
	 */
	public String toString() {
		return this.code + " : " + this.desc;
	}

}
