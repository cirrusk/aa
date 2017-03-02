/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseActiveSurveyVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseActiveSurveyVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 14.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveSurveyVO extends UnivCourseActiveSurveyVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 바로가기 개설과목일련번호 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 파라미터 */
	private String shortcutCategoryTypeCd;

	/** 바로가기 분류 구분 파라미터 */
	private String shortcutCourseTypeCd;

	/** 삭제용 변수 */
	private Long[] courseActiveSurveySeqs;

	/** 삭제용 변수 */
	private Long[] surveyPaperSeqs;

	/** 삭제용 변수 */
	private Long[] surveySubjectSeqs;

	/** 화면표시용 카운트 변수 */
	private Long totalMemberCount;

	/** 화면표시용 카운트 변수 */
	private Long totalAnswerCount;

	/** 강의실 메인용 변수 */
	private Long courseApplySeq;

	/** 완료여부 확인용 변수 */
	private Long completeCount;

	/** 학습자 D-day */
	private Long dDayCount;
	
	/** 제출일 */
	private String sendDtime;
	
	/**
	 * 바로가기 값 복사(
	 */
	public void copyShortcut() {
		super.setCourseActiveSeq(this.getShortcutCourseActiveSeq());
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

	public Long[] getCourseActiveSurveySeqs() {
		return courseActiveSurveySeqs;
	}

	public void setCourseActiveSurveySeqs(Long[] courseActiveSurveySeqs) {
		this.courseActiveSurveySeqs = courseActiveSurveySeqs;
	}

	public Long[] getSurveyPaperSeqs() {
		return surveyPaperSeqs;
	}

	public void setSurveyPaperSeqs(Long[] surveyPaperSeqs) {
		this.surveyPaperSeqs = surveyPaperSeqs;
	}

	public Long[] getSurveySubjectSeqs() {
		return surveySubjectSeqs;
	}

	public void setSurveySubjectSeqs(Long[] surveySubjectSeqs) {
		this.surveySubjectSeqs = surveySubjectSeqs;
	}

	public Long getTotalMemberCount() {
		return totalMemberCount;
	}

	public void setTotalMemberCount(Long totalMemberCount) {
		this.totalMemberCount = totalMemberCount;
	}

	public Long getTotalAnswerCount() {
		return totalAnswerCount;
	}

	public void setTotalAnswerCount(Long totalAnswerCount) {
		this.totalAnswerCount = totalAnswerCount;
	}

	public Long getCourseApplySeq() {
		return courseApplySeq;
	}

	public void setCourseApplySeq(Long courseApplySeq) {
		this.courseApplySeq = courseApplySeq;
	}

	public Long getCompleteCount() {
		return completeCount;
	}

	public void setCompleteCount(Long completeCount) {
		this.completeCount = completeCount;
	}

	public Long getdDayCount() {
		return dDayCount;
	}

	public void setdDayCount(Long dDayCount) {
		this.dDayCount = dDayCount;
	}

	public String getShortcutCourseTypeCd() {
		return shortcutCourseTypeCd;
	}

	public void setShortcutCourseTypeCd(String shortcutCourseTypeCd) {
		this.shortcutCourseTypeCd = shortcutCourseTypeCd;
	}

	public String getSendDtime() {
		return sendDtime;
	}

	public void setSendDtime(String sendDtime) {
		this.sendDtime = sendDtime;
	}

}