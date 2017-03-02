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
 * @File : UILcmsMetadataCondition.java
 * @Title : 메타데이타
 * @date : 2014. 3. 7.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsMetadataCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 검색 방법 : like or equals */
	private String srchMethod;

	/** 데이타 주제 */
	private String srchMetadataPath;

	/** 참조 일련번호 */
	private Long srchReferenceSeq;

	/** 참조구분 */
	private String srchReferenceType;

	public String getSrchMethod() {
		return srchMethod;
	}

	public void setSrchMethod(String srchMethod) {
		this.srchMethod = srchMethod;
	}

	public String getSrchMetadataPath() {
		return srchMetadataPath;
	}

	public void setSrchMetadataPath(String srchMetadataPath) {
		this.srchMetadataPath = srchMetadataPath;
	}

	public Long getSrchReferenceSeq() {
		return srchReferenceSeq;
	}

	public void setSrchReferenceSeq(Long srchReferenceSeq) {
		this.srchReferenceSeq = srchReferenceSeq;
	}

	public String getSrchReferenceType() {
		return srchReferenceType;
	}

	public void setSrchReferenceType(String srchReferenceType) {
		this.srchReferenceType = srchReferenceType;
	}

}
