/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivSurveyExampleVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivSurveyExampleVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 19.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivSurveyExampleVO extends UnivSurveyExampleVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 복수 저장 및 삭제시 사용할 변수 */
	private Long[] surveyExampleSeqs;

	/** 복수 저장 및 삭제시 사용할 변수 */
	private Long[] surveySeqs;

	/** 복수 저장 및 삭제시 사용할 변수 */
	private String[] surveyExampleTitles;

	/** 복수 저장 및 삭제시 사용할 변수 */
	private Long[] sortOrders;

	/** 복수 저장 및 삭제시 사용할 변수 */
	private Long[] measureScores;

	public Long[] getSurveyExampleSeqs() {
		return surveyExampleSeqs;
	}

	public void setSurveyExampleSeqs(Long[] surveyExampleSeqs) {
		this.surveyExampleSeqs = surveyExampleSeqs;
	}

	public Long[] getSurveySeqs() {
		return surveySeqs;
	}

	public void setSurveySeqs(Long[] surveySeqs) {
		this.surveySeqs = surveySeqs;
	}

	public String[] getSurveyExampleTitles() {
		return surveyExampleTitles;
	}

	public void setSurveyExampleTitles(String[] surveyExampleTitles) {
		this.surveyExampleTitles = surveyExampleTitles;
	}

	public Long[] getSortOrders() {
		return sortOrders;
	}

	public void setSortOrders(Long[] sortOrders) {
		this.sortOrders = sortOrders;
	}

	public Long[] getMeasureScores() {
		return measureScores;
	}

	public void setMeasureScores(Long[] measureScores) {
		this.measureScores = measureScores;
	}

}
