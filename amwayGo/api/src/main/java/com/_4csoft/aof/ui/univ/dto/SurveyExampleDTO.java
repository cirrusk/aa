package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

public class SurveyExampleDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/** cs_survey_example_seq */
	private Long surveyExampleSeq;

	/** cs_survey_seq */
	private Long surveySeq;

	/** cs_survey_example_title */
	private String surveyExampleTitle;

	public Long getSurveyExampleSeq() {
		return surveyExampleSeq;
	}

	public void setSurveyExampleSeq(Long surveyExampleSeq) {
		this.surveyExampleSeq = surveyExampleSeq;
	}

	public Long getSurveySeq() {
		return surveySeq;
	}

	public void setSurveySeq(Long surveySeq) {
		this.surveySeq = surveySeq;
	}

	public String getSurveyExampleTitle() {
		return surveyExampleTitle;
	}

	public void setSurveyExampleTitle(String surveyExampleTitle) {
		this.surveyExampleTitle = surveyExampleTitle;
	}

}
