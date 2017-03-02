/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseTeamProjectBbsVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseTeamProjectBbsVO.java
 * @Title : 팀프로젝트 게시글
 * @date : 2014. 3. 14.
 * @author : 서진철
 * @descrption :
 */
public class UIUnivCourseTeamProjectBbsVO extends UnivCourseTeamProjectBbsVO implements Serializable {

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

	/** 바로가기 개설과목일련번호 파라미터 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 파라미터 */
	private String shortcutCategoryTypeCd;

	/** 다운로드 가능 여부 */
	private String downloadYn;

	/** 푸시발송 여부 */
	private String pushYn;

	/** 푸시메시지 타입 */
	private String pushMessageType;

	/**
	 * 게시판 구분
	 */
	private String boardTypeCd;
	
	/**
	 * 신규 게시물 수
	 */
	private Long teamBbsNewCnt;

	
	
	
	public Long getTeamBbsNewCnt() {
		return teamBbsNewCnt;
	}

	public void setTeamBbsNewCnt(Long teamBbsNewCnt) {
		this.teamBbsNewCnt = teamBbsNewCnt;
	}

	/**
	 * 바로가기 값 복사(
	 */
	public void copyShortcut() {
		super.setCourseActiveSeq(this.getShortcutCourseActiveSeq());
	}

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

	public Long getShortcutCourseActiveSeq() {
		return shortcutCourseActiveSeq;
	}

	public void setShortcutCourseActiveSeq(Long shortcutCourseActiveSeq) {
		this.shortcutCourseActiveSeq = shortcutCourseActiveSeq;
	}

	public String getShortcutCategoryTypeCd() {
		return shortcutCategoryTypeCd;
	}

	public void setShortcutCategoryTypeCd(String shortcutCategoryTypeCd) {
		this.shortcutCategoryTypeCd = shortcutCategoryTypeCd;
	}

	public String getDownloadYn() {
		return downloadYn;
	}

	public void setDownloadYn(String downloadYn) {
		this.downloadYn = downloadYn;
	}

	public String getPushYn() {
		return pushYn;
	}

	public void setPushYn(String pushYn) {
		this.pushYn = pushYn;
	}

	public String getBoardTypeCd() {
		return boardTypeCd;
	}

	public void setBoardTypeCd(String boardTypeCd) {
		this.boardTypeCd = boardTypeCd;
	}

	public String getPushMessageType() {
		return pushMessageType;
	}

	public void setPushMessageType(String pushMessageType) {
		this.pushMessageType = pushMessageType;
	}
}
