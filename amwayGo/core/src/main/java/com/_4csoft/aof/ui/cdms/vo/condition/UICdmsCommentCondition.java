/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo.condition
 * @File : UICdmsCommentCondition.java
 * @Title : CDMS 산출물 댓글
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsCommentCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;
	private Long srchProjectSeq;
	private Long srchSectionIndex;
	private Long srchOutputIndex;
	private Long srchMemberSeq;
	private String srchMemberCdmsTypeCd;

	public Long getSrchProjectSeq() {
		return srchProjectSeq;
	}

	public void setSrchProjectSeq(Long srchProjectSeq) {
		this.srchProjectSeq = srchProjectSeq;
	}

	public Long getSrchSectionIndex() {
		return srchSectionIndex;
	}

	public void setSrchSectionIndex(Long srchSectionIndex) {
		this.srchSectionIndex = srchSectionIndex;
	}

	public Long getSrchOutputIndex() {
		return srchOutputIndex;
	}

	public void setSrchOutputIndex(Long srchOutputIndex) {
		this.srchOutputIndex = srchOutputIndex;
	}

	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}

	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}

	public String getSrchMemberCdmsTypeCd() {
		return srchMemberCdmsTypeCd;
	}

	public void setSrchMemberCdmsTypeCd(String srchMemberCdmsTypeCd) {
		this.srchMemberCdmsTypeCd = srchMemberCdmsTypeCd;
	}

}
