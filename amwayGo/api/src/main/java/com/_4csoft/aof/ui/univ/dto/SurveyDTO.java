/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;
import java.util.List;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : SurveyDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 24.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class SurveyDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/** cs_survey_seq */
	private Long surveySeq;

	/** cs_survey_title */
	private String surveyTitle;

	/** cs_survey_type_cd */
	private String surveyTypeCd;
	private String surveyType;

	/** cs_survey_item_type_cd */
	private String surveyItemTypeCd;
	private String surveyItemType;

	/** cs_use_count */
	private Long useCount;

	/** cs_use_yn */
	private String useYn;

	private List<SurveyExampleDTO> examples;

	public Long getSurveySeq() {
		return surveySeq;
	}

	public void setSurveySeq(Long surveySeq) {
		this.surveySeq = surveySeq;
	}

	public String getSurveyTitle() {
		return surveyTitle;
	}

	public void setSurveyTitle(String surveyTitle) {
		this.surveyTitle = surveyTitle;
	}

	public String getSurveyTypeCd() {
		return surveyTypeCd;
	}

	public void setSurveyTypeCd(String surveyTypeCd) {
		this.surveyTypeCd = surveyTypeCd;
	}

	public String getSurveyItemTypeCd() {
		return surveyItemTypeCd;
	}

	public void setSurveyItemTypeCd(String surveyItemTypeCd) {
		this.surveyItemTypeCd = surveyItemTypeCd;
	}

	public Long getUseCount() {
		return useCount;
	}

	public void setUseCount(Long useCount) {
		this.useCount = useCount;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public List<SurveyExampleDTO> getExamples() {
		return examples;
	}

	public void setExamples(List<SurveyExampleDTO> examples) {
		this.examples = examples;
	}

	public String getSurveyType() {
		return surveyType;
	}

	public void setSurveyType(String surveyType) {
		this.surveyType = surveyType;
	}

	public String getSurveyItemType() {
		return surveyItemType;
	}

	public void setSurveyItemType(String surveyItemType) {
		this.surveyItemType = surveyItemType;
	}

}
