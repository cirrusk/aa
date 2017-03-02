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
 * @File : UILcmsOrganizationCondition.java
 * @Title : 학습구조(차시)
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsOrganizationCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 검색 방법 : like or equals */
	private String srchMethod;

	/** 메타데이타 요소 일련번호 */
	private Long srchMetadataElementSeq;

	/** 데이타 주제 */
	private String srchMetadataPath;

	/** 데이타 값 */
	private String srchMetadataValue;

	/** 해당 콘텐츠타입 제외 검색 */
	private String srchContentsTypeCd;

	/** 해당 콘텐츠 seq 제외 검색 */
	private Long srchNotInContentsSeq;

	/** 교강사 권한으로 검색 */
	private Long srchMemberSeq;

	/** 조교,튜터 권한으로 검색 */
	private Long srchAssistMemberSeq;

	public String getSrchMethod() {
		return srchMethod;
	}

	public void setSrchMethod(String srchMethod) {
		this.srchMethod = srchMethod;
	}

	public Long getSrchMetadataElementSeq() {
		return srchMetadataElementSeq;
	}

	public void setSrchMetadataElementSeq(Long srchMetadataElementSeq) {
		this.srchMetadataElementSeq = srchMetadataElementSeq;
	}

	public String getSrchMetadataPath() {
		return srchMetadataPath;
	}

	public void setSrchMetadataPath(String srchMetadataPath) {
		this.srchMetadataPath = srchMetadataPath;
	}

	public String getSrchMetadataValue() {
		return srchMetadataValue;
	}

	public String getSrchMetadataValueDB() {
		return srchMetadataValue.replaceAll("%", "\\\\%");
	}

	public void setSrchMetadataValue(String srchMetadataValue) {
		this.srchMetadataValue = srchMetadataValue;
	}

	public String getSrchContentsTypeCd() {
		return srchContentsTypeCd;
	}

	public void setSrchContentsTypeCd(String srchContentsTypeCd) {
		this.srchContentsTypeCd = srchContentsTypeCd;
	}

	public Long getSrchNotInContentsSeq() {
		return srchNotInContentsSeq;
	}

	public void setSrchNotInContentsSeq(Long srchNotInContentsSeq) {
		this.srchNotInContentsSeq = srchNotInContentsSeq;
	}

	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}

	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}

	public Long getSrchAssistMemberSeq() {
		return srchAssistMemberSeq;
	}

	public void setSrchAssistMemberSeq(Long srchAssistMemberSeq) {
		this.srchAssistMemberSeq = srchAssistMemberSeq;
	}

}
