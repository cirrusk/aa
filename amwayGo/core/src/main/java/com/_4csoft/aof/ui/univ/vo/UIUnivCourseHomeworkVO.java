/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseHomeworkVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseHomeworkVO.java
 * @Title : 과제 vo
 * @date : 2014. 2. 20.
 * @author : 김현우
 * @descrption : UnivCourseHomeworkVO.class 를 상속받아 사용
 */
public class UIUnivCourseHomeworkVO extends UnivCourseHomeworkVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 대상인원 카운트 수 */
	private Long targetCount;

	/** 보충과제가 있는지 확인을 위한 카운트수 */
	private Long referenceCount;

	/** 보충과제 출제 가능여부 */
	private String supplementUseYn;

	/** 다중삭제 과제 일련번호 */
	private Long[] homeworkSeqs;

	/** 다중삭제 과제 참조 일련번호 */
	private Long[] referenceSeqs;

	/** 다중삭제 과제 일반,보충 여부 */
	private String[] basicSupplementCds;

	/** 보충과제의 일련번호 (평가 비율수정시 사용) */
	private Long[] supplementSeqs;

	/** 다중삭제 과제 첨부파일 */
	private String attachDeleteInfos;

	/** 평가비율 저장용 비율 */
	private Double[] rates;

	/** 평가비율 저장용 과제 일련번호 */
	private Long[] rateHomeworkSeqs;

	/** 교과목 일련번호 */
	private Long courseMasterSeq;

	/** 바로가기 개설과목일련번호 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 파라미터 */
	private String shortcutCategoryTypeCd;

	/** 보충 수정시 일반과정의 끝나는 날짜 값 셋팅용 */
	private String finalEndDtime;

	/** 과제 제출 카운트 */
	private Long answerSubmitCount;

	/** 과제 채점 완료 카운트 */
	private Long answerScoreCount;

	/** 다중수정 과제결과 일련번호 */
	private Long[] homeworkAnswerSeqs;

	/** 다중수정 과제 일련번호 */
	private Long[] courseActiveSeqs;

	/** 다중수정 학습자 일련번호 */
	private Long[] courseApplySeqs;

	/** 다중수정 과제결과 공개 여부 */
	private String[] openYns;

	/** 다중수정 과제점수 */
	private Double[] homeworkScores;

	/** 다중수정 과제점수 비교용도 */
	private Double[] oldHomeworkScores;

	/** 다중수정 제출일자 */
	private String[] sendDtimes;

	/** 메인 학습 리스트에서 출력 여부 */
	private String displayYn;

	/**
	 * 바로가기 값 복사(
	 */
	public void copyShortcut() {
		super.setCourseActiveSeq(this.getShortcutCourseActiveSeq());
	}

	public String[] getSendDtimes() {
		return sendDtimes;
	}

	public void setSendDtimes(String[] sendDtimes) {
		this.sendDtimes = sendDtimes;
	}

	public Long[] getHomeworkAnswerSeqs() {
		return homeworkAnswerSeqs;
	}

	public void setHomeworkAnswerSeqs(Long[] homeworkAnswerSeqs) {
		this.homeworkAnswerSeqs = homeworkAnswerSeqs;
	}

	public Long[] getCourseActiveSeqs() {
		return courseActiveSeqs;
	}

	public void setCourseActiveSeqs(Long[] courseActiveSeqs) {
		this.courseActiveSeqs = courseActiveSeqs;
	}

	public Long[] getReferenceSeqs() {
		return referenceSeqs;
	}

	public void setReferenceSeqs(Long[] referenceSeqs) {
		this.referenceSeqs = referenceSeqs;
	}

	public Long[] getCourseApplySeqs() {
		return courseApplySeqs;
	}

	public void setCourseApplySeqs(Long[] courseApplySeqs) {
		this.courseApplySeqs = courseApplySeqs;
	}

	public String[] getOpenYns() {
		return openYns;
	}

	public void setOpenYns(String[] openYns) {
		this.openYns = openYns;
	}

	public Double[] getHomeworkScores() {
		return homeworkScores;
	}

	public void setHomeworkScores(Double[] homeworkScores) {
		this.homeworkScores = homeworkScores;
	}

	public Long getAnswerSubmitCount() {
		return answerSubmitCount;
	}

	public void setAnswerSubmitCount(Long answerSubmitCount) {
		this.answerSubmitCount = answerSubmitCount;
	}

	public Long getAnswerScoreCount() {
		return answerScoreCount;
	}

	public void setAnswerScoreCount(Long answerScoreCount) {
		this.answerScoreCount = answerScoreCount;
	}

	public Long getTargetCount() {
		return targetCount;
	}

	public void setTargetCount(Long targetCount) {
		this.targetCount = targetCount;
	}

	public Long getReferenceCount() {
		return referenceCount;
	}

	public void setReferenceCount(Long referenceCount) {
		this.referenceCount = referenceCount;
	}

	public String getSupplementUseYn() {
		return supplementUseYn;
	}

	public void setSupplementUseYn(String supplementUseYn) {
		this.supplementUseYn = supplementUseYn;
	}

	public Long[] getHomeworkSeqs() {
		return homeworkSeqs;
	}

	public void setHomeworkSeqs(Long[] homeworkSeqs) {
		this.homeworkSeqs = homeworkSeqs;
	}

	public String getAttachDeleteInfos() {
		return attachDeleteInfos;
	}

	public void setAttachDeleteInfos(String attachDeleteInfos) {
		this.attachDeleteInfos = attachDeleteInfos;
	}

	public Double[] getRates() {
		return rates;
	}

	public void setRates(Double[] rates) {
		this.rates = rates;
	}

	public Long[] getRateHomeworkSeqs() {
		return rateHomeworkSeqs;
	}

	public void setRateHomeworkSeqs(Long[] rateHomeworkSeqs) {
		this.rateHomeworkSeqs = rateHomeworkSeqs;
	}

	public Long getCourseMasterSeq() {
		return courseMasterSeq;
	}

	public void setCourseMasterSeq(Long courseMasterSeq) {
		this.courseMasterSeq = courseMasterSeq;
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

	public String getFinalEndDtime() {
		return finalEndDtime;
	}

	public void setFinalEndDtime(String finalEndDtime) {
		this.finalEndDtime = finalEndDtime;
	}

	public String[] getBasicSupplementCds() {
		return basicSupplementCds;
	}

	public void setBasicSupplementCds(String[] basicSupplementCds) {
		this.basicSupplementCds = basicSupplementCds;
	}

	public Long[] getSupplementSeqs() {
		return supplementSeqs;
	}

	public void setSupplementSeqs(Long[] supplementSeqs) {
		this.supplementSeqs = supplementSeqs;
	}

	public Double[] getOldHomeworkScores() {
		return oldHomeworkScores;
	}

	public void setOldHomeworkScores(Double[] oldHomeworkScores) {
		this.oldHomeworkScores = oldHomeworkScores;
	}

	public String getDisplayYn() {
		return displayYn;
	}

	public void setDisplayYn(String displayYn) {
		this.displayYn = displayYn;
	}

}
