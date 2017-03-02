/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseActiveBbsVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.vo
 * @File : UnivCourseActiveBbsVO.java
 * @Title : 게시글
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveBbsVO extends UnivCourseActiveBbsVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 첨부파일 수 */
	private Long attachCount;

	/** 답변 수 */
	private Long replyCount;

	/** 멀티 수정/삭제 처리 */
	private Long[] bbsSeqs;

	/** 멀티 수정/삭제 처리 */
	private Long[] boardSeqs;

	/** 멀티 수정 처리 */
	private String[] evaluateYns;

	/** 개설과목 바로가기 파라미터 */
	private String shortcutYearTerm;

	/** 개설과목 바로가기 파라미터 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 */
	private String shortcutCategoryTypeCd;

	/** 게시물 수 */
	private Long bbsCount;
	
	/** 좋아요 여부 */
	private String likeYn;
	
	/** 댓글키값 */
	private String commSeq;
	
	/** 댓글내용 */
	private String commDescription;
	
	/** 댓글날짜 */
	private String commRegDtime;
	
	/** 댓글나만보기 */
	private String commSecretYn;

	/** 최근 게시물 수 */
	private Long newsCnt;

	/** 과목 수 */
	private Long[] courseActiveSeqs;

	/** 푸시 수신여부 */
	private String pushYn;

	/** 다운로드 가능 여부 */
	private String downloadYn;
	
	/** 채팅방 버튼 여부 */
	private String chatYn;
	
	/** 외부링크 명,URL */
	private String linkName;
	private String linkText;

	/** 팀프로젝트 게시물수 */
	private Long teamBbsCount;

	/** 팀프로젝트 게시물 코멘트 수 */
	private Long teamCommentCount;

	/** 자유게시판 게시물 수 */
	private Long freeBbsCount;

	/** 자유게시판 게시물 코멘트 수 */
	private Long freeCommentCount;

	/** 푸시메시지 타입 */
	private String pushMessageType;

	/** 세션코드 */
	private String classificationCode;

	/** 교수공개여부 */
	private String profViewYn;
	
	private String regMemberPhoto;
	
	private String companyName;
	private String position;
	private String activeBbsUpdDtime;

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

	public String getShortcutYearTerm() {
		return shortcutYearTerm;
	}

	public void setShortcutYearTerm(String shortcutYearTerm) {
		this.shortcutYearTerm = shortcutYearTerm;
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

	public Long getBbsCount() {
		return bbsCount;
	}

	public void setBbsCount(Long bbsCount) {
		this.bbsCount = bbsCount;
	}

	public Long[] getCourseActiveSeqs() {
		return courseActiveSeqs;
	}

	public void setCourseActiveSeqs(Long[] courseActiveSeqs) {
		this.courseActiveSeqs = courseActiveSeqs;
	}

	public Long[] getBoardSeqs() {
		return boardSeqs;
	}

	public void setBoardSeqs(Long[] boardSeqs) {
		this.boardSeqs = boardSeqs;
	}

	public String getPushYn() {
		return pushYn;
	}

	public void setPushYn(String pushYn) {
		this.pushYn = pushYn;
	}

	public String getDownloadYn() {
		return downloadYn;
	}

	public void setDownloadYn(String downloadYn) {
		this.downloadYn = downloadYn;
	}

	public Long getTeamBbsCount() {
		return teamBbsCount;
	}

	public void setTeamBbsCount(Long teamBbsCount) {
		this.teamBbsCount = teamBbsCount;
	}

	public Long getTeamCommentCount() {
		return teamCommentCount;
	}

	public void setTeamCommentCount(Long teamCommentCount) {
		this.teamCommentCount = teamCommentCount;
	}

	public Long getFreeBbsCount() {
		return freeBbsCount;
	}

	public void setFreeBbsCount(Long freeBbsCount) {
		this.freeBbsCount = freeBbsCount;
	}

	public Long getFreeCommentCount() {
		return freeCommentCount;
	}

	public void setFreeCommentCount(Long freeCommentCount) {
		this.freeCommentCount = freeCommentCount;
	}

	public String getPushMessageType() {
		return pushMessageType;
	}

	public void setPushMessageType(String pushMessageType) {
		this.pushMessageType = pushMessageType;
	}

	public Long getNewsCnt() {
		return newsCnt;
	}

	public void setNewsCnt(Long newsCnt) {
		this.newsCnt = newsCnt;
	}

	public String getClassificationCode() {
		return classificationCode;
	}

	public void setClassificationCode(String classificationCode) {
		this.classificationCode = classificationCode;
	}

	public String getProfViewYn() {
		return profViewYn;
	}

	public void setProfViewYn(String profViewYn) {
		this.profViewYn = profViewYn;
	}

	public String getRegMemberPhoto() {
		return regMemberPhoto;
	}

	public void setRegMemberPhoto(String regMemberPhoto) {
		this.regMemberPhoto = regMemberPhoto;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getActiveBbsUpdDtime() {
		return activeBbsUpdDtime;
	}

	public void setActiveBbsUpdDtime(String activeBbsUpdDtime) {
		this.activeBbsUpdDtime = activeBbsUpdDtime;
	}

	public String getLikeYn() {
		return likeYn;
	}

	public void setLikeYn(String likeYn) {
		this.likeYn = likeYn;
	}
	
	public String getCommSeq() {
		return commSeq;
	}

	public void setCommSeq(String commSeq) {
		this.commSeq = commSeq;
	}

	public String getCommDescription() {
		return commDescription;
	}

	public void setCommDescription(String commDescription) {
		this.commDescription = commDescription;
	}

	public String getCommRegDtime() {
		return commRegDtime;
	}

	public void setCommRegDtime(String commRegDtime) {
		this.commRegDtime = commRegDtime;
	}

	public String getCommSecretYn() {
		return commSecretYn;
	}

	public void setCommSecretYn(String commSecretYn) {
		this.commSecretYn = commSecretYn;
	}

	public String getChatYn() {
		return chatYn;
	}

	public void setChatYn(String chatYn) {
		this.chatYn = chatYn;
	}

	public String getLinkName() {
		return linkName;
	}

	public void setLinkName(String linkName) {
		this.linkName = linkName;
	}

	public String getLinkText() {
		return linkText;
	}

	public void setLinkText(String linkText) {
		this.linkText = linkText;
	}
}
