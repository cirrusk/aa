/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseActiveExamPaperTargetVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseActiveExamPaperTargetVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 6.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveExamPaperTargetVO extends UnivCourseActiveExamPaperTargetVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 다중 삭제할 체크키 */
	private Long[] targetApplyCheckkeys;

	/** 다중 등록 할 체크키 */
	private Long[] nonTargetApplyCheckkeys;

	/** 오프라인 결과 입력용 변수 */
	private Double[] takeScores;

	/** 오프라인 결과 입력용 변수 */
	private Long[] courseApplySeqs;

	/** 오프라인 결과 입력용 변수 */
	private String[] scoreYns;

	/** 첨부파일 업로드 정보 (멀티 파일이면 콤마로 구분한다) */
	private String[] attachUploadInfos;

	/** 첨부파일 삭제 정보 (멀티 파일이면 콤마로 구분한다) */
	private String[] attachDeleteInfos;

	/** 오프라인 결과 입력용 변수 */
	private Long[] activeExamPaperTargetSeqs;

	/** 결과상세보기용 변수 */
	private Long courseActiveSeq;

	/** 결과상세보기용 변수 */
	private Long activeElementSeq;

	/** 결과상세보기용 변수 */
	private Long courseApplySeq;

	public Long[] getTargetApplyCheckkeys() {
		return targetApplyCheckkeys;
	}

	public void setTargetApplyCheckkeys(Long[] targetApplyCheckkeys) {
		this.targetApplyCheckkeys = targetApplyCheckkeys;
	}

	public Long[] getNonTargetApplyCheckkeys() {
		return nonTargetApplyCheckkeys;
	}

	public void setNonTargetApplyCheckkeys(Long[] nonTargetApplyCheckkeys) {
		this.nonTargetApplyCheckkeys = nonTargetApplyCheckkeys;
	}

	public Double[] getTakeScores() {
		return takeScores;
	}

	public void setTakeScores(Double[] takeScores) {
		this.takeScores = takeScores;
	}

	public Long[] getCourseApplySeqs() {
		return courseApplySeqs;
	}

	public void setCourseApplySeqs(Long[] courseApplySeqs) {
		this.courseApplySeqs = courseApplySeqs;
	}

	public String[] getScoreYns() {
		return scoreYns;
	}

	public void setScoreYns(String[] scoreYns) {
		this.scoreYns = scoreYns;
	}

	public String[] getAttachUploadInfos() {
		return attachUploadInfos;
	}

	public void setAttachUploadInfos(String[] attachUploadInfos) {
		this.attachUploadInfos = attachUploadInfos;
	}

	public String[] getAttachDeleteInfos() {
		return attachDeleteInfos;
	}

	public void setAttachDeleteInfos(String[] attachDeleteInfos) {
		this.attachDeleteInfos = attachDeleteInfos;
	}

	public Long[] getActiveExamPaperTargetSeqs() {
		return activeExamPaperTargetSeqs;
	}

	public void setActiveExamPaperTargetSeqs(Long[] activeExamPaperTargetSeqs) {
		this.activeExamPaperTargetSeqs = activeExamPaperTargetSeqs;
	}

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}

	public Long getActiveElementSeq() {
		return activeElementSeq;
	}

	public void setActiveElementSeq(Long activeElementSeq) {
		this.activeElementSeq = activeElementSeq;
	}

	public Long getCourseApplySeq() {
		return courseApplySeq;
	}

	public void setCourseApplySeq(Long courseApplySeq) {
		this.courseApplySeq = courseApplySeq;
	}

}
