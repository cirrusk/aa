/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.condition
 * @File : UIUnivYearTermCondition.java
 * @Title : 년도학기
 * @date : 2014. 2. 18.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivYearTermCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 검색 년도학기 */
	private String srchYearTerm;

	/** 검색 시작 년도학기 */
	private String srchStartYearTerm;

	/** 검색 종료 년도학기 */
	private String srchEndYearTerm;

	public String getSrchYearTerm() {
		return srchYearTerm;
	}

	public void setSrchYearTerm(String srchYearTerm) {
		this.srchYearTerm = srchYearTerm;
	}

	public String getSrchStartYearTerm() {
		return srchStartYearTerm;
	}

	public void setSrchStartYearTerm(String srchStartYearTerm) {
		this.srchStartYearTerm = srchStartYearTerm;
	}

	public String getSrchEndYearTerm() {
		return srchEndYearTerm;
	}

	public void setSrchEndYearTerm(String srchEndYearTerm) {
		this.srchEndYearTerm = srchEndYearTerm;
	}
}
