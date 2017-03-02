/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseHomeworkAnswerVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseHomeworkAnswerVO.java
 * @Title : 과제 제출 vo
 * @date : 2014. 3. 4.
 * @author : 김현우
 * @descrption : UnivCourseHomeworkAnswerVO.class 를 상속받아 사용
 */
public class UIUnivCourseHomeworkAnswerVO extends UnivCourseHomeworkAnswerVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 과제 수 */
	private Long homeworkCount;

	/** 환산 점수 */
	private Long scaledScore;

	/** 과제응답 첨부파일 개수 */
	private Long attachCount;

	/** 이름 */
	private String memberName;
	/** 아이디 */
	private String memberId;

	/** 과제 점수 Array */
	private Double[] homeworkScores;

	/** old 과제 점수 Array */
	private Double[] oldHomeworkScores;

	/** 개설과목 팀 일련번호 Array */
	private Long[] courseTeamSeqs;

	/** 바로가기 개설과목일련번호 파라미터 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 파라미터 */
	private String shortcutCategoryTypeCd;

	/**
	 * 바로가기 값 복사(
	 */
	public void copyShortcut() {
		super.setCourseActiveSeq(this.getShortcutCourseActiveSeq());
	}

	public Long getScaledScore() {
		return scaledScore;
	}

	public void setScaledScore(Long scaledScore) {
		this.scaledScore = scaledScore;
	}

	public Long getAttachCount() {
		return attachCount;
	}

	public void setAttachCount(Long attachCount) {
		this.attachCount = attachCount;
	}

	public Long getHomeworkCount() {
		return homeworkCount;
	}

	public void setHomeworkCount(Long homeworkCount) {
		this.homeworkCount = homeworkCount;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public Double[] getHomeworkScores() {
		return homeworkScores;
	}

	public void setHomeworkScores(Double[] homeworkScores) {
		this.homeworkScores = homeworkScores;
	}

	public Double[] getOldHomeworkScores() {
		return oldHomeworkScores;
	}

	public void setOldHomeworkScores(Double[] oldHomeworkScores) {
		this.oldHomeworkScores = oldHomeworkScores;
	}

	public Long[] getCourseTeamSeqs() {
		return courseTeamSeqs;
	}

	public void setCourseTeamSeqs(Long[] courseTeamSeqs) {
		this.courseTeamSeqs = courseTeamSeqs;
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

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

}
