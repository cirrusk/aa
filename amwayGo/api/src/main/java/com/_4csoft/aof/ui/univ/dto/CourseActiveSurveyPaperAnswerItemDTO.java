/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : CourseActiveSurveyPaperAnswerItemDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 25.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class CourseActiveSurveyPaperAnswerItemDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** cs_survey_seq */
	private Long surveySeq;

	/** cs_essay_answer */
	private String essayAnswer;

	/** cs_survey_answer1_yn */
	private String surveyAnswer;

	private String surveyItemTypeCd;

	public Long getSurveySeq() {
		return surveySeq;
	}

	public void setSurveySeq(Long surveySeq) {
		this.surveySeq = surveySeq;
	}

	public String getEssayAnswer() {
		return essayAnswer;
	}

	public void setEssayAnswer(String essayAnswer) {
		this.essayAnswer = essayAnswer;
	}

	public String getSurveyAnswer() {
		return surveyAnswer;
	}

	public void setSurveyAnswer(String surveyAnswer) {
		this.surveyAnswer = surveyAnswer;
	}

	public String getSurveyItemTypeCd() {
		return surveyItemTypeCd;
	}

	public void setSurveyItemTypeCd(String surveyItemTypeCd) {
		this.surveyItemTypeCd = surveyItemTypeCd;
	}

}
