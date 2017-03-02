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
 * @File : UIUnivCourseActiveCondition.java
 * @Title : 개설과목
 * @date : 2014. 3. 4.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveCondition extends SearchConditionVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 검색 학위 구분 - 학위 : CATEGORY_TYPE::DEGREE, 비학위 : CATEGORY_TYPE::NONDEGREE */
	private String srchCategoryTypeCd;

	/** 검색 년도 */
	private String srchYear;

	/** 검색 년도학기 */
	private String srchYearTerm;

	/** 검색 소속학과 */
	private Long srchCategoryOrganizationSeq;

	/** 검색 개설 교과목 상태 */
	private String srchCourseActiveStatusCd;

	/** 검색 회원 일련번호 */
	private Long srchMemberSeq;

	/** 검색 분류명 */
	private String srchCategoryName;

	/** 검색 분반 */
	private Long srchDivision;

	/** 검색 교과목일련번호 */
	private Long srchCourseMasterSeq;

	/** 검색 타겟 개설과목 일련번호 */
	private Long srchTargetCourseActiveSeq;

	/** 검색 과정 유형 */
	private String srchCourseTypeCd;

	/** 기간 체크 */
	private String srchApplyType;

	/** 합반 포함 유무 */
	private String srchCombinedClassYn;

	private String srchCompetitionYn;

	public String getSrchYear() {
		return srchYear;
	}

	public void setSrchYear(String srchYear) {
		this.srchYear = srchYear;
	}

	public Long getSrchCategoryOrganizationSeq() {
		return srchCategoryOrganizationSeq;
	}

	public void setSrchCategoryOrganizationSeq(Long srchCategoryOrganizationSeq) {
		this.srchCategoryOrganizationSeq = srchCategoryOrganizationSeq;
	}

	public String getSrchCourseActiveStatusCd() {
		return srchCourseActiveStatusCd;
	}

	public void setSrchCourseActiveStatusCd(String srchCourseActiveStatusCd) {
		this.srchCourseActiveStatusCd = srchCourseActiveStatusCd;
	}

	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}

	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}

	public String getSrchCategoryTypeCd() {
		return srchCategoryTypeCd;
	}

	public void setSrchCategoryTypeCd(String srchCategoryTypeCd) {
		this.srchCategoryTypeCd = srchCategoryTypeCd;
	}

	public String getSrchYearTerm() {
		return srchYearTerm;
	}

	public void setSrchYearTerm(String srchYearTerm) {
		this.srchYearTerm = srchYearTerm;
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

	public Long getSrchDivision() {
		return srchDivision;
	}

	public void setSrchDivision(Long srchDivision) {
		this.srchDivision = srchDivision;
	}

	public Long getSrchCourseMasterSeq() {
		return srchCourseMasterSeq;
	}

	public void setSrchCourseMasterSeq(Long srchCourseMasterSeq) {
		this.srchCourseMasterSeq = srchCourseMasterSeq;
	}

	public Long getSrchTargetCourseActiveSeq() {
		return srchTargetCourseActiveSeq;
	}

	public void setSrchTargetCourseActiveSeq(Long srchTargetCourseActiveSeq) {
		this.srchTargetCourseActiveSeq = srchTargetCourseActiveSeq;
	}

	public String getSrchCourseTypeCd() {
		return srchCourseTypeCd;
	}

	public void setSrchCourseTypeCd(String srchCourseTypeCd) {
		this.srchCourseTypeCd = srchCourseTypeCd;
	}

	public String getSrchApplyType() {
		return srchApplyType;
	}

	public void setSrchApplyType(String srchApplyType) {
		this.srchApplyType = srchApplyType;
	}

	public String getSrchCombinedClassYn() {
		return srchCombinedClassYn;
	}

	public void setSrchCombinedClassYn(String srchCombinedClassYn) {
		this.srchCombinedClassYn = srchCombinedClassYn;
	}

	public String getSrchCompetitionYn() {
		return srchCompetitionYn;
	}

	public void setSrchCompetitionYn(String srchCompetitionYn) {
		this.srchCompetitionYn = srchCompetitionYn;
	}

}
