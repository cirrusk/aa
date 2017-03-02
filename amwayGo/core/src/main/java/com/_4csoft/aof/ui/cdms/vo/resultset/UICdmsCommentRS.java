/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsCommentVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsOutputVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsSectionVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo.resultset
 * @File : UICdmsCommentRS.java
 * @Title : CDMS 산출물 댓글
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsCommentRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UICdmsCommentVO comment;
	private UICdmsSectionVO section;
	private UICdmsOutputVO output;
	private UIMemberVO member;

	public UICdmsCommentVO getComment() {
		return comment;
	}

	public void setComment(UICdmsCommentVO comment) {
		this.comment = comment;
	}

	public UICdmsSectionVO getSection() {
		return section;
	}

	public void setSection(UICdmsSectionVO section) {
		this.section = section;
	}

	public UICdmsOutputVO getOutput() {
		return output;
	}

	public void setOutput(UICdmsOutputVO output) {
		this.output = output;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

}
