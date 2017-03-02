/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.condition;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.vo.condition
 * @File : UIUnivCourseQuizAnswerCondition.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 10.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseQuizAnswerCondition extends SearchConditionVO {

	private static final long serialVersionUID = 8464236678172949861L;

	/** 검색 운영과정 일련번호 */
	private Long srchCourseActiveSeq;

	/** 과정 일련번호 */
	private Long srchMemberSeq;

	private String srchClassificationCode;

	private String srchQuizDtime;

	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}

	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public String getSrchClassificationCode() {
		return srchClassificationCode;
	}

	public void setSrchClassificationCode(String srchClassificationCode) {
		this.srchClassificationCode = srchClassificationCode;
	}

	public String getSrchQuizDtime() {
		return srchQuizDtime;
	}

	public void setSrchQuizDtime(String srchQuizDtime) {
		this.srchQuizDtime = srchQuizDtime;
	}

}
