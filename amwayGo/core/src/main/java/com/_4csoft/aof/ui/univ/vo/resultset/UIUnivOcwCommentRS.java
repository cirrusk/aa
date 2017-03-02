/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivOcwCommentVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivOcwCommentRS.java
 * @Title : ocw 댓글 ResultSet
 * @date : 2014. 5. 15.
 * @author : 김현우
 * @descrption : ocw 댓글 ResultSet
 */
public class UIUnivOcwCommentRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** ocw 과목 vo */
	private UIUnivOcwCommentVO ocwComment;

	public UIUnivOcwCommentVO getOcwComment() {
		return ocwComment;
	}

	public void setOcwComment(UIUnivOcwCommentVO ocwComment) {
		this.ocwComment = ocwComment;
	}

}
