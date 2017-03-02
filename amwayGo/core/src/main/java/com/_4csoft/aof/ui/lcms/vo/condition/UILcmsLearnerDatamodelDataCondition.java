/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo.condition
 * @File : UILcmsLearnerDatamodelDataCondition.java
 * @Title : 학습자데이타모델 데이타
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsLearnerDatamodelDataCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private String srchLearnerId;

	/** */
	private Long srchCourseActiveSeq;

	/** */
	private Long srchCourseApplySeq;

	/** */
	private Long srchOrganizationSeq;

	/** */
	private Long srchItemSeq;

	/** */
	private String srchDataName;

	public String getSrchLearnerId() {
		return srchLearnerId;
	}

	public void setSrchLearnerId(String srchLearnerId) {
		this.srchLearnerId = srchLearnerId;
	}

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public Long getSrchCourseApplySeq() {
		return srchCourseApplySeq;
	}

	public void setSrchCourseApplySeq(Long srchCourseApplySeq) {
		this.srchCourseApplySeq = srchCourseApplySeq;
	}

	public Long getSrchOrganizationSeq() {
		return srchOrganizationSeq;
	}

	public void setSrchOrganizationSeq(Long srchOrganizationSeq) {
		this.srchOrganizationSeq = srchOrganizationSeq;
	}

	public Long getSrchItemSeq() {
		return srchItemSeq;
	}

	public void setSrchItemSeq(Long srchItemSeq) {
		this.srchItemSeq = srchItemSeq;
	}

	public String getSrchDataName() {
		return srchDataName;
	}

	public void setSrchDataName(String srchDataName) {
		this.srchDataName = srchDataName;
	}

}
