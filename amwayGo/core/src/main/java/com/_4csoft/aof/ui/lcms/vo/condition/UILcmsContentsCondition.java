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
 * @File : UILcmsContentsCondition.java
 * @Title : 콘텐츠그룹
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsContentsCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 교강사 권한 검색 */
	private Long srchMemberSeq;

	/** 조교, 튜터 권한 검색 */
	private Long srchAssistMemberSeq;

	/** 카테고리 검색 명 */
	private String srchCategoryName;

	/** 상태: 활성, 비활성 */
	private String srchStatusCd;

	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}

	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}

	public String getSrchStatusCd() {
		return srchStatusCd;
	}

	public void setSrchStatusCd(String srchStatusCd) {
		this.srchStatusCd = srchStatusCd;
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

	public Long getSrchAssistMemberSeq() {
		return srchAssistMemberSeq;
	}

	public void setSrchAssistMemberSeq(Long srchAssistMemberSeq) {
		this.srchAssistMemberSeq = srchAssistMemberSeq;
	}

}
