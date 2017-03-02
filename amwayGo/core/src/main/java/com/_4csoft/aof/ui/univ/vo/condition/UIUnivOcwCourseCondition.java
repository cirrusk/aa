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
 * @File : UIUnivOcwCourseCondition.java
 * @Title : ocw 개설과목
 * @date : 2014. 5. 8.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivOcwCourseCondition extends SearchConditionVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 검색 학위 구분 - 학위 : CATEGORY_TYPE::DEGREE, 비학위 : CATEGORY_TYPE::NONDEGREE */
	private String srchCategoryTypeCd;

	/** 검색 소속학과 */
	private Long srchCategoryOrganizationSeq;

	/** 검색 개설 교과목 상태 */
	private String srchCourseActiveStatusCd;

	/** 검색 회원 일련번호 */
	private Long srchMemberSeq;

	/** 검색 분류명 */
	private String srchCategoryName;

	/** 검색 교과목일련번호 */
	private Long srchCourseMasterSeq;

	/** 검색 타겟 개설과목 일련번호 */
	private Long srchTargetCourseActiveSeq;

	/** 검색 카테고리 그룹 오더 */
	private String srchGroupOrder;

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

	public String getSrchCategoryNameDB() {
		return srchCategoryName.replaceAll("%", "\\\\%");
	}

	public String getSrchCategoryName() {
		return srchCategoryName;
	}

	public void setSrchCategoryName(String srchCategoryName) {
		this.srchCategoryName = srchCategoryName;
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

	public String getSrchGroupOrder() {
		return srchGroupOrder;
	}

	public void setSrchGroupOrder(String srchGroupOrder) {
		this.srchGroupOrder = srchGroupOrder;
	}

}
