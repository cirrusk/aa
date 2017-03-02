/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.board.vo.condition
 * @File : UIBoardCondition.java
 * @Title : 게시판
 * @date : 2014. 1. 27.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIBoardCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private Long srchReferenceSeq;

	/** */
	private String srchReferenceType;

	/** */
	private String srchBoardTypeCd;

	/** */
	private String srchUseYn;

	/** */
	private Long srchNotReferenceSeq;

	/** 새소식 설정기간*/
	private String srchNewsLimitNumber;
	
	/** 수강생 일련번호 */
	private Long courseApplySeq;
	
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

	public String getSrchBoardTypeCd() {
		return srchBoardTypeCd;
	}

	public void setSrchBoardTypeCd(String srchBoardTypeCd) {
		this.srchBoardTypeCd = srchBoardTypeCd;
	}

	public String getSrchUseYn() {
		return srchUseYn;
	}

	public void setSrchUseYn(String srchUseYn) {
		this.srchUseYn = srchUseYn;
	}

	public Long getSrchNotReferenceSeq() {
		return srchNotReferenceSeq;
	}

	public void setSrchNotReferenceSeq(Long srchNotReferenceSeq) {
		this.srchNotReferenceSeq = srchNotReferenceSeq;
	}

	public String getSrchNewsLimitNumber() {
		return srchNewsLimitNumber;
	}

	public void setSrchNewsLimitNumber(String srchNewsLimitNumber) {
		this.srchNewsLimitNumber = srchNewsLimitNumber;
	}

	public Long getCourseApplySeq() {
		return courseApplySeq;
	}

	public void setCourseApplySeq(Long courseApplySeq) {
		this.courseApplySeq = courseApplySeq;
	}

}
