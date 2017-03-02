/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.condition
 * @File    : UIUnivGradeLevelCondition.java
 * @Title   : 성적등급관리
 * @date    : 2014. 2. 20.
 * @author  : 장용기
 * @descrption :
 * 
 */
public class UIUnivGradeLevelCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/** 검색 년도학기 */
	private String srchYearTerm;
	
	/** 개설과목 일련번호 */
	private Long srchCourseActiveSeq;

	public String getSrchYearTerm() {
		return srchYearTerm;
	}

	public void setSrchYearTerm(String srchYearTerm) {
		this.srchYearTerm = srchYearTerm;
	}

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

}
