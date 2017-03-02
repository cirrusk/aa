/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.board.vo.UICommentVO;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.vo.resultset
 * @File : UICommentRS.java
 * @Title : UICommentRS
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICommentRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/** 댓글 관련 */
	private UICommentVO comment;
	
	
	public UICommentVO getComment() {
		return comment;
	}

	public void setComment(UICommentVO comment) {
		this.comment = comment;
	}
	
}
