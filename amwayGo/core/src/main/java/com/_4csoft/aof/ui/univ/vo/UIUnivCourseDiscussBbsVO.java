/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseDiscussBbsVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseDiscussBbsVO.java
 * @Title : 토론 게시글
 * @date : 2014. 3. 19.
 * @author : 김현우
 * @descrption :
 */
public class UIUnivCourseDiscussBbsVO extends UnivCourseDiscussBbsVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 첨부파일 수 */
	private Long attachCount;

	/** 답변 수 */
	private Long replyCount;

	/** 멀티 수정/삭제 처리 */
	private Long[] bbsSeqs;

	/** 멀티 수정 처리 */
	private String[] evaluateYns;

	/** 게시물 수 */
	private Long bbsCount;

	/** 댁글 수 */
	private Long commentCount;

	/** 등록자 아이디 */
	private String regMemberId;

	/** 다운로드 가능 여부 */
	private String downloadYn;

	public Long getAttachCount() {
		return attachCount;
	}

	public void setAttachCount(Long attachCount) {
		this.attachCount = attachCount;
	}

	public Long getReplyCount() {
		return replyCount;
	}

	public void setReplyCount(Long replyCount) {
		this.replyCount = replyCount;
	}

	public Long[] getBbsSeqs() {
		return bbsSeqs;
	}

	public void setBbsSeqs(Long[] bbsSeqs) {
		this.bbsSeqs = bbsSeqs;
	}

	public String[] getEvaluateYns() {
		return evaluateYns;
	}

	public void setEvaluateYns(String[] evaluateYns) {
		this.evaluateYns = evaluateYns;
	}

	public Long getBbsCount() {
		return bbsCount;
	}

	public void setBbsCount(Long bbsCount) {
		this.bbsCount = bbsCount;
	}

	public String getRegMemberId() {
		return regMemberId;
	}

	public void setRegMemberId(String regMemberId) {
		this.regMemberId = regMemberId;
	}

	public Long getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(Long commentCount) {
		this.commentCount = commentCount;
	}

	public String getDownloadYn() {
		return downloadYn;
	}

	public void setDownloadYn(String downloadYn) {
		this.downloadYn = downloadYn;
	}

}
