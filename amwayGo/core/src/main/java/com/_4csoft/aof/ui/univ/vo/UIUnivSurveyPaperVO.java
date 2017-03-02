/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivSurveyPaperVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivSurveyPaperVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 21.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivSurveyPaperVO extends UnivSurveyPaperVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 복수 저장 및 삭제시 사용할 변수 */
	private Long[] surveyPaperSeqs;

	private Long surveyCount;

	public Long[] getSurveyPaperSeqs() {
		return surveyPaperSeqs;
	}

	public void setSurveyPaperSeqs(Long[] surveyPaperSeqs) {
		this.surveyPaperSeqs = surveyPaperSeqs;
	}

	public Long getSurveyCount() {
		return surveyCount;
	}

	public void setSurveyCount(Long surveyCount) {
		this.surveyCount = surveyCount;
	}

}
