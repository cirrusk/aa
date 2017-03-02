/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.vo.condition
 * @File : UICommentCondition.java
 * @Title : UICommentCondition
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICommentCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private Long srchBbsSeq;

	/** */
	private Long srchCourseActiveSeq;

	public Long getSrchBbsSeq() {
		return srchBbsSeq;
	}

	public void setSrchBbsSeq(Long srchBbsSeq) {
		this.srchBbsSeq = srchBbsSeq;
	}

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

}
