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
 * @Title : ocw 댓글
 * @date : 2014. 5. 15.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivOcwCommentCondition extends SearchConditionVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/** */
	private String srchCommentTypeCd;

	/** */
	private Long srchCourseActiveSeq;

	/**  */
	private Long srchItemSeq;

	public String getSrchCommentTypeCd() {
		return srchCommentTypeCd;
	}

	public void setSrchCommentTypeCd(String srchCommentTypeCd) {
		this.srchCommentTypeCd = srchCommentTypeCd;
	}

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public Long getSrchItemSeq() {
		return srchItemSeq;
	}

	public void setSrchItemSeq(Long srchItemSeq) {
		this.srchItemSeq = srchItemSeq;
	}

}
