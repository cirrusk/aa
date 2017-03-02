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
 * @File : UIUnivCourseMasterCondition.java
 * @Title : 교과목
 * @date : 2014. 2. 18.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseMasterCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 분류일련번호 */
	private Long srchCategoryOrganizationSeq;

	/** 검색 이수구분 */
	private String srchCompleteDivisionCd;

	/** 검색 교과목 상태 */
	private String srchCourseStatusCd;

	/** 검색 분류문자열(학부) */
	private String srchCategoryName;

	/** 분류 구분 - 학위 : CATEGORY_TYPE::DEGREE, 비학위 : CATEGORY_TYPE::NONDEGREE, OCW : CATEGORY_TYPE::OCW */
	private String srchCategoryTypeCd;

	/** 검색대상에서 제외될 분류 구분 - 학위 : CATEGORY_TYPE::DEGREE, 비학위 : CATEGORY_TYPE::NONDEGREE, OCW : CATEGORY_TYPE::OCW */
	private String srchNotInCategoryTypeCd;

	public String getSrchCourseStatusCd() {
		return srchCourseStatusCd;
	}

	public void setSrchCourseStatusCd(String srchCourseStatusCd) {
		this.srchCourseStatusCd = srchCourseStatusCd;
	}

	public String getSrchCompleteDivisionCd() {
		return srchCompleteDivisionCd;
	}

	public void setSrchCompleteDivisionCd(String srchCompleteDivisionCd) {
		this.srchCompleteDivisionCd = srchCompleteDivisionCd;
	}

	public Long getSrchCategoryOrganizationSeq() {
		return srchCategoryOrganizationSeq;
	}

	public void setSrchCategoryOrganizationSeq(Long srchCategoryOrganizationSeq) {
		this.srchCategoryOrganizationSeq = srchCategoryOrganizationSeq;
	}

	public String getSrchCategoryTypeCd() {
		return srchCategoryTypeCd;
	}

	public void setSrchCategoryTypeCd(String srchCategoryTypeCd) {
		this.srchCategoryTypeCd = srchCategoryTypeCd;
	}

	public String getSrchCategoryNameDB() {
		return srchCategoryName.replaceAll("%", "\\\\%");
	}

	public String getSrchCategoryName() {
		return srchCategoryName;
	}

	public void setSrchCategoryName(String srchCategoryName) {
		this.srchCategoryName = srchCategoryName;
	}

	public String getSrchNotInCategoryTypeCd() {
		return srchNotInCategoryTypeCd;
	}

	public void setSrchNotInCategoryTypeCd(String srchNotInCategoryTypeCd) {
		this.srchNotInCategoryTypeCd = srchNotInCategoryTypeCd;
	}

}
