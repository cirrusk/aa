/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseActiveSurveyPaperAnswerVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseActiveSurveyPaperAnswerVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 20.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveSurveyPaperAnswerVO extends UnivCourseActiveSurveyPaperAnswerVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 저장용 변수 */
	private Long[] surveySeqs;

	/** 저장용 변수 */
	private String[] surveyItemTypeCds;

	/** 저장용 변수 */
	private String[] essayAnswers;

	/** 저장용 변수 */
	private String[] surveyAnswer1Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer2Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer3Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer4Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer5Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer6Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer7Yns;

	/** 저장용 변수 */
	private Long[] profMemberSeqs;

	/** 저장용 변수 */
	private Long memberSeq;

	/** 설문 제출 유무 */
	private String surveyYn;

	/** 저장용 변수 */
	private String[] surveyAnswer8Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer9Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer10Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer11Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer12Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer13Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer14Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer15Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer16Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer17Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer18Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer19Yns;

	/** 저장용 변수 */
	private String[] surveyAnswer20Yns;

	/** 결과용 변수 */
	private Long surveyAnswer8Count;

	/** 결과용 변수 */
	private Long surveyAnswer9Count;

	/** 결과용 변수 */
	private Long surveyAnswer10Count;

	/** 결과용 변수 */
	private Long surveyAnswer11Count;

	/** 결과용 변수 */
	private Long surveyAnswer12Count;

	/** 결과용 변수 */
	private Long surveyAnswer13Count;

	/** 결과용 변수 */
	private Long surveyAnswer14Count;

	/** 결과용 변수 */
	private Long surveyAnswer15Count;

	/** 결과용 변수 */
	private Long surveyAnswer16Count;

	/** 결과용 변수 */
	private Long surveyAnswer17Count;

	/** 결과용 변수 */
	private Long surveyAnswer18Count;

	/** 결과용 변수 */
	private Long surveyAnswer19Count;

	/** 결과용 변수 */
	private Long surveyAnswer20Count;

	public Long[] getSurveySeqs() {
		return surveySeqs;
	}

	public void setSurveySeqs(Long[] surveySeqs) {
		this.surveySeqs = surveySeqs;
	}

	public String[] getSurveyItemTypeCds() {
		return surveyItemTypeCds;
	}

	public void setSurveyItemTypeCds(String[] surveyItemTypeCds) {
		this.surveyItemTypeCds = surveyItemTypeCds;
	}

	public String[] getEssayAnswers() {
		return essayAnswers;
	}

	public void setEssayAnswers(String[] essayAnswers) {
		this.essayAnswers = essayAnswers;
	}

	public String[] getSurveyAnswer1Yns() {
		return surveyAnswer1Yns;
	}

	public void setSurveyAnswer1Yns(String[] surveyAnswer1Yns) {
		this.surveyAnswer1Yns = surveyAnswer1Yns;
	}

	public String[] getSurveyAnswer2Yns() {
		return surveyAnswer2Yns;
	}

	public void setSurveyAnswer2Yns(String[] surveyAnswer2Yns) {
		this.surveyAnswer2Yns = surveyAnswer2Yns;
	}

	public String[] getSurveyAnswer3Yns() {
		return surveyAnswer3Yns;
	}

	public void setSurveyAnswer3Yns(String[] surveyAnswer3Yns) {
		this.surveyAnswer3Yns = surveyAnswer3Yns;
	}

	public String[] getSurveyAnswer4Yns() {
		return surveyAnswer4Yns;
	}

	public void setSurveyAnswer4Yns(String[] surveyAnswer4Yns) {
		this.surveyAnswer4Yns = surveyAnswer4Yns;
	}

	public String[] getSurveyAnswer5Yns() {
		return surveyAnswer5Yns;
	}

	public void setSurveyAnswer5Yns(String[] surveyAnswer5Yns) {
		this.surveyAnswer5Yns = surveyAnswer5Yns;
	}

	public String[] getSurveyAnswer6Yns() {
		return surveyAnswer6Yns;
	}

	public void setSurveyAnswer6Yns(String[] surveyAnswer6Yns) {
		this.surveyAnswer6Yns = surveyAnswer6Yns;
	}

	public String[] getSurveyAnswer7Yns() {
		return surveyAnswer7Yns;
	}

	public void setSurveyAnswer7Yns(String[] surveyAnswer7Yns) {
		this.surveyAnswer7Yns = surveyAnswer7Yns;
	}

	public Long[] getProfMemberSeqs() {
		return profMemberSeqs;
	}

	public void setProfMemberSeqs(Long[] profMemberSeqs) {
		this.profMemberSeqs = profMemberSeqs;
	}

	public Long getMemberSeq() {
		return memberSeq;
	}

	public void setMemberSeq(Long memberSeq) {
		this.memberSeq = memberSeq;
	}

	public String getSurveyYn() {
		return surveyYn;
	}

	public void setSurveyYn(String surveyYn) {
		this.surveyYn = surveyYn;
	}

	public String[] getSurveyAnswer8Yns() {
		return surveyAnswer8Yns;
	}

	public void setSurveyAnswer8Yns(String[] surveyAnswer8Yns) {
		this.surveyAnswer8Yns = surveyAnswer8Yns;
	}

	public String[] getSurveyAnswer9Yns() {
		return surveyAnswer9Yns;
	}

	public void setSurveyAnswer9Yns(String[] surveyAnswer9Yns) {
		this.surveyAnswer9Yns = surveyAnswer9Yns;
	}

	public String[] getSurveyAnswer10Yns() {
		return surveyAnswer10Yns;
	}

	public void setSurveyAnswer10Yns(String[] surveyAnswer10Yns) {
		this.surveyAnswer10Yns = surveyAnswer10Yns;
	}

	public String[] getSurveyAnswer11Yns() {
		return surveyAnswer11Yns;
	}

	public void setSurveyAnswer11Yns(String[] surveyAnswer11Yns) {
		this.surveyAnswer11Yns = surveyAnswer11Yns;
	}

	public String[] getSurveyAnswer12Yns() {
		return surveyAnswer12Yns;
	}

	public void setSurveyAnswer12Yns(String[] surveyAnswer12Yns) {
		this.surveyAnswer12Yns = surveyAnswer12Yns;
	}

	public String[] getSurveyAnswer13Yns() {
		return surveyAnswer13Yns;
	}

	public void setSurveyAnswer13Yns(String[] surveyAnswer13Yns) {
		this.surveyAnswer13Yns = surveyAnswer13Yns;
	}

	public String[] getSurveyAnswer14Yns() {
		return surveyAnswer14Yns;
	}

	public void setSurveyAnswer14Yns(String[] surveyAnswer14Yns) {
		this.surveyAnswer14Yns = surveyAnswer14Yns;
	}

	public String[] getSurveyAnswer15Yns() {
		return surveyAnswer15Yns;
	}

	public void setSurveyAnswer15Yns(String[] surveyAnswer15Yns) {
		this.surveyAnswer15Yns = surveyAnswer15Yns;
	}

	public String[] getSurveyAnswer16Yns() {
		return surveyAnswer16Yns;
	}

	public void setSurveyAnswer16Yns(String[] surveyAnswer16Yns) {
		this.surveyAnswer16Yns = surveyAnswer16Yns;
	}

	public String[] getSurveyAnswer17Yns() {
		return surveyAnswer17Yns;
	}

	public void setSurveyAnswer17Yns(String[] surveyAnswer17Yns) {
		this.surveyAnswer17Yns = surveyAnswer17Yns;
	}

	public String[] getSurveyAnswer18Yns() {
		return surveyAnswer18Yns;
	}

	public void setSurveyAnswer18Yns(String[] surveyAnswer18Yns) {
		this.surveyAnswer18Yns = surveyAnswer18Yns;
	}

	public String[] getSurveyAnswer19Yns() {
		return surveyAnswer19Yns;
	}

	public void setSurveyAnswer19Yns(String[] surveyAnswer19Yns) {
		this.surveyAnswer19Yns = surveyAnswer19Yns;
	}

	public String[] getSurveyAnswer20Yns() {
		return surveyAnswer20Yns;
	}

	public void setSurveyAnswer20Yns(String[] surveyAnswer20Yns) {
		this.surveyAnswer20Yns = surveyAnswer20Yns;
	}

	public Long getSurveyAnswer8Count() {
		return surveyAnswer8Count;
	}

	public void setSurveyAnswer8Count(Long surveyAnswer8Count) {
		this.surveyAnswer8Count = surveyAnswer8Count;
	}

	public Long getSurveyAnswer9Count() {
		return surveyAnswer9Count;
	}

	public void setSurveyAnswer9Count(Long surveyAnswer9Count) {
		this.surveyAnswer9Count = surveyAnswer9Count;
	}

	public Long getSurveyAnswer10Count() {
		return surveyAnswer10Count;
	}

	public void setSurveyAnswer10Count(Long surveyAnswer10Count) {
		this.surveyAnswer10Count = surveyAnswer10Count;
	}

	public Long getSurveyAnswer11Count() {
		return surveyAnswer11Count;
	}

	public void setSurveyAnswer11Count(Long surveyAnswer11Count) {
		this.surveyAnswer11Count = surveyAnswer11Count;
	}

	public Long getSurveyAnswer12Count() {
		return surveyAnswer12Count;
	}

	public void setSurveyAnswer12Count(Long surveyAnswer12Count) {
		this.surveyAnswer12Count = surveyAnswer12Count;
	}

	public Long getSurveyAnswer13Count() {
		return surveyAnswer13Count;
	}

	public void setSurveyAnswer13Count(Long surveyAnswer13Count) {
		this.surveyAnswer13Count = surveyAnswer13Count;
	}

	public Long getSurveyAnswer14Count() {
		return surveyAnswer14Count;
	}

	public void setSurveyAnswer14Count(Long surveyAnswer14Count) {
		this.surveyAnswer14Count = surveyAnswer14Count;
	}

	public Long getSurveyAnswer15Count() {
		return surveyAnswer15Count;
	}

	public void setSurveyAnswer15Count(Long surveyAnswer15Count) {
		this.surveyAnswer15Count = surveyAnswer15Count;
	}

	public Long getSurveyAnswer16Count() {
		return surveyAnswer16Count;
	}

	public void setSurveyAnswer16Count(Long surveyAnswer16Count) {
		this.surveyAnswer16Count = surveyAnswer16Count;
	}

	public Long getSurveyAnswer17Count() {
		return surveyAnswer17Count;
	}

	public void setSurveyAnswer17Count(Long surveyAnswer17Count) {
		this.surveyAnswer17Count = surveyAnswer17Count;
	}

	public Long getSurveyAnswer18Count() {
		return surveyAnswer18Count;
	}

	public void setSurveyAnswer18Count(Long surveyAnswer18Count) {
		this.surveyAnswer18Count = surveyAnswer18Count;
	}

	public Long getSurveyAnswer19Count() {
		return surveyAnswer19Count;
	}

	public void setSurveyAnswer19Count(Long surveyAnswer19Count) {
		this.surveyAnswer19Count = surveyAnswer19Count;
	}

	public Long getSurveyAnswer20Count() {
		return surveyAnswer20Count;
	}

	public void setSurveyAnswer20Count(Long surveyAnswer20Count) {
		this.surveyAnswer20Count = surveyAnswer20Count;
	}

}
