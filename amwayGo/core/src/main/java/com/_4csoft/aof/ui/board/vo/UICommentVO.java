/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.vo;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.board.vo.CommentVO;
import com._4csoft.aof.infra.vo.AttachVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.vo
 * @File : UICommentVO.java
 * @Title : UICommentVO
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICommentVO extends CommentVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 등록자 사진 */
	private String regMemberPhoto;

	/** 등록자 닉네임 */
	private String regMemberNickname;

	/** 게시글 작성자 일련번호 */
	private String bbsRegMemberSeq;
	/** 교강사 타입 */
	private String activeLecturerTypeCd;
	
	/** 댓글 첨부 사진 */
	private String commentPhoto;
	
	/** 첨부파일 목록 */
	private List<AttachVO> attachList;
	
	

	public String getBbsRegMemberSeq() {
		return bbsRegMemberSeq;
	}

	public void setBbsRegMemberSeq(String bbsRegMemberSeq) {
		this.bbsRegMemberSeq = bbsRegMemberSeq;
	}

	public String getRegMemberPhoto() {
		return regMemberPhoto;
	}

	public void setRegMemberPhoto(String regMemberPhoto) {
		this.regMemberPhoto = regMemberPhoto;
	}

	public String getRegMemberNickname() {
		return regMemberNickname;
	}

	public void setRegMemberNickname(String regMemberNickname) {
		this.regMemberNickname = regMemberNickname;
	}

	public String getActiveLecturerTypeCd() {
		return activeLecturerTypeCd;
	}

	public void setActiveLecturerTypeCd(String activeLecturerTypeCd) {
		this.activeLecturerTypeCd = activeLecturerTypeCd;
	}

	public String getCommentPhoto() {
		return commentPhoto;
	}

	public void setCommentPhoto(String commentPhoto) {
		this.commentPhoto = commentPhoto;
	}

	public List<AttachVO> getAttachList() {
		return attachList;
	}

	public void setAttachList(List<AttachVO> attachList) {
		this.attachList = attachList;
	}
	
}
