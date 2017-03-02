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
 * @File : UIUnivWeekTemplateCondition.java
 * @Title : 주차템플릿 컨디션
 * @date : 2014. 2. 20.
 * @author : 김현우
 * @descrption : 검색에 필요한 변수 선언
 */
public class UIUnivWeekTemplateCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 검색 년도학기 */
	private String srchYearTerm;

	/** 개강일 주차 일괄생성시 사용 */
	private String studyStartDate;

	/** 주차 일수 일괄생성시 사용 */
	private Long dayCount;

	/** 주차 갯수 일괄생성시 사용 */
	private Long weekCount;

	/** 일괄 계산되어 나온 리스트 페이지인여부를 파악합니다. */
	private String calculationYn;

	public String getSrchYearTerm() {
		return srchYearTerm;
	}

	public void setSrchYearTerm(String srchYearTerm) {
		this.srchYearTerm = srchYearTerm;
	}

	public String getStudyStartDate() {
		return studyStartDate;
	}

	public void setStudyStartDate(String studyStartDate) {
		this.studyStartDate = studyStartDate;
	}

	public Long getDayCount() {
		return dayCount;
	}

	public void setDayCount(Long dayCount) {
		this.dayCount = dayCount;
	}

	public Long getWeekCount() {
		return weekCount;
	}

	public void setWeekCount(Long weekCount) {
		this.weekCount = weekCount;
	}

	public String getCalculationYn() {
		return calculationYn;
	}

	public void setCalculationYn(String calculationYn) {
		this.calculationYn = calculationYn;
	}

}
