/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo.search
 * @File : UIUnivCategoryCondition.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCategoryCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;
	private String srchCategoryTypeCd;
	private String srchYearTerm;
	private Long srchParentSeq;
	private Long srchGroupLevel;
	private Long srchGroupSeq;
	private Long srchStudentYear;
	private Long srchCategorySeq;
	private String srchCategoryName;

	public String getSrchCategoryTypeCd() {
		return srchCategoryTypeCd;
	}

	public void setSrchCategoryTypeCd(String srchCategoryTypeCd) {
		this.srchCategoryTypeCd = srchCategoryTypeCd;
	}

	public Long getSrchParentSeq() {
		return srchParentSeq;
	}

	public void setSrchParentSeq(Long srchParentSeq) {
		this.srchParentSeq = srchParentSeq;
	}

	public Long getSrchGroupLevel() {
		return srchGroupLevel;
	}

	public void setSrchGroupLevel(Long srchGroupLevel) {
		this.srchGroupLevel = srchGroupLevel;
	}

	public Long getSrchGroupSeq() {
		return srchGroupSeq;
	}

	public void setSrchGroupSeq(Long srchGroupSeq) {
		this.srchGroupSeq = srchGroupSeq;
	}

	public Long getSrchStudentYear() {
		return srchStudentYear;
	}

	public void setSrchStudentYear(Long srchStudentYear) {
		this.srchStudentYear = srchStudentYear;
	}

	public Long getSrchCategorySeq() {
		return srchCategorySeq;
	}

	public void setSrchCategorySeq(Long srchCategorySeq) {
		this.srchCategorySeq = srchCategorySeq;
	}

	public String getSrchYearTerm() {
		return srchYearTerm;
	}

	public void setSrchYearTerm(String srchYearTerm) {
		this.srchYearTerm = srchYearTerm;
	}
	
	public String getSrchCategoryName() {
		return srchCategoryName;
	}

	public void setSrchCategoryName(String srchCategoryName) {
		this.srchCategoryName = srchCategoryName;
	}

	public String getSrchCategoryNameDB() {
		return srchCategoryName.replaceAll("%", "\\\\%");
	}

}
