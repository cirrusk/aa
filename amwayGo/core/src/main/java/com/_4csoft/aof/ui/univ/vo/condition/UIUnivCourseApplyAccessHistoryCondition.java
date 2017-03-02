/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * 
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.condition
 * @File    : UIUnivCourseApplyAccessHistoryCondition.java
 * @Title   : 교과목 접속 통계
 * @date    : 2014. 4. 14.
 * @author  : 김영학
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseApplyAccessHistoryCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private String srchYn;
	private String srchStartRegDate;
	private String srchEndRegDate;
	
	/** 과정 명*/
	private String srchCourseTitle;

	/** 학위,비학위 구분 */
	private String srchCategoryTypeCd;
	
	/** 년도 학기 */
	private String srchYearTerm;
	
	/** 년도 */
	private String srchYear;
	
	
	public String getSrchStartRegDate() {
		return srchStartRegDate;
	}

	public void setSrchStartRegDate(String srchStartRegDate) {
		this.srchStartRegDate = srchStartRegDate;
	}

	public String getSrchEndRegDate() {
		return srchEndRegDate;
	}

	public void setSrchEndRegDate(String srchEndRegDate) {
		this.srchEndRegDate = srchEndRegDate;
	}

	public String getSrchYn() {
		return srchYn;
	}

	public void setSrchYn(String srchYn) {
		this.srchYn = srchYn;
	}

	public String getSrchCourseTitle() {
		return srchCourseTitle;
	}

	public void setSrchCourseTitle(String srchCourseTitle) {
		this.srchCourseTitle = srchCourseTitle;
	}

	public String getSrchCourseTitleDB() {
		return srchCourseTitle.replaceAll("%", "\\\\%");
	}
	
	public String getSrchYearTerm() {
		return srchYearTerm;
	}

	public void setSrchYearTerm(String srchYearTerm) {
		this.srchYearTerm = srchYearTerm;
	}

	public String getSrchYear() {
		return srchYear;
	}

	public void setSrchYear(String srchYear) {
		this.srchYear = srchYear;
	}

	public String getSrchCategoryTypeCd() {
		return srchCategoryTypeCd;
	}

	public void setSrchCategoryTypeCd(String srchCategoryTypeCd) {
		this.srchCategoryTypeCd = srchCategoryTypeCd;
	}
	
}
