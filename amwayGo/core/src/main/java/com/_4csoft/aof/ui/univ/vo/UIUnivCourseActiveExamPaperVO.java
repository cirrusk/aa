/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseActiveExamPaperVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUInivCourseActiveExamPaperVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 6.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveExamPaperVO extends UnivCourseActiveExamPaperVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 바로가기 개설과목일련번호 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 파라미터 */
	private String shortcutCategoryTypeCd;

	/** 대상자(target) 수 */
	private Long targetCount;

	/** 삭제용 변수 */
	private Long[] courseActiveExamPaperSeqs;

	/** 삭제용 변수 */
	private Long[] examPaperSeqs;

	/** 카운트용 변수 */
	private Long answerCount;

	/** 카운트용 변수 */
	private Long scoredCount;

	/** 카운트용 변수 */
	private Long completeCount;

	/** 학습자 시험지 목록용 변수 */
	private Long courseApplySeq;

	/** 학습자 시험지 목록용 변수 */
	private Long activeElementSeq;

	/** 학습자 시험지 목록용 변수 */
	private String referenceTypeCd;

	/** 학습구성요소에 수정하기 위한 변수 */
	private String[] middleFinalTypeCds;

	/** 기수제 상시제 구분용 변수 */
	private String courseTypeCd;

	/** 학습자 D-day */
	private Long dDayCount;

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

	public Long getTargetCount() {
		return targetCount;
	}

	public void setTargetCount(Long targetCount) {
		this.targetCount = targetCount;
	}

	public Long[] getCourseActiveExamPaperSeqs() {
		return courseActiveExamPaperSeqs;
	}

	public void setCourseActiveExamPaperSeqs(Long[] courseActiveExamPaperSeqs) {
		this.courseActiveExamPaperSeqs = courseActiveExamPaperSeqs;
	}

	public Long[] getExamPaperSeqs() {
		return examPaperSeqs;
	}

	public void setExamPaperSeqs(Long[] examPaperSeqs) {
		this.examPaperSeqs = examPaperSeqs;
	}

	public Long getAnswerCount() {
		return answerCount;
	}

	public void setAnswerCount(Long answerCount) {
		this.answerCount = answerCount;
	}

	public Long getScoredCount() {
		return scoredCount;
	}

	public void setScoredCount(Long scoredCount) {
		this.scoredCount = scoredCount;
	}

	public Long getCompleteCount() {
		return completeCount;
	}

	public void setCompleteCount(Long completeCount) {
		this.completeCount = completeCount;
	}

	public Long getCourseApplySeq() {
		return courseApplySeq;
	}

	public void setCourseApplySeq(Long courseApplySeq) {
		this.courseApplySeq = courseApplySeq;
	}

	public Long getActiveElementSeq() {
		return activeElementSeq;
	}

	public void setActiveElementSeq(Long activeElementSeq) {
		this.activeElementSeq = activeElementSeq;
	}

	public String getReferenceTypeCd() {
		return referenceTypeCd;
	}

	public void setReferenceTypeCd(String referenceTypeCd) {
		this.referenceTypeCd = referenceTypeCd;
	}

	public String[] getMiddleFinalTypeCds() {
		return middleFinalTypeCds;
	}

	public void setMiddleFinalTypeCds(String[] middleFinalTypeCds) {
		this.middleFinalTypeCds = middleFinalTypeCds;
	}

	public String getCourseTypeCd() {
		return courseTypeCd;
	}

	public void setCourseTypeCd(String courseTypeCd) {
		this.courseTypeCd = courseTypeCd;
	}

	public Long getdDayCount() {
		return dDayCount;
	}

	public void setdDayCount(Long dDayCount) {
		this.dDayCount = dDayCount;
	}

}
