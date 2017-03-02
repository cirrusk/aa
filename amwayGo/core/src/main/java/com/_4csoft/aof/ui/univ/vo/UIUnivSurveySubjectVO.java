/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivSurveySubjectVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivSurveySubjectVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 4. 28.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivSurveySubjectVO extends UnivSurveySubjectVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 바로가기 개설과목일련번호 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 파라미터 */
	private String shortcutCategoryTypeCd;

	/** 삭제용 변수 */
	private Long[] surveySubjectSeqs;

	/** 사용여부 */
	private String useYn;
	
	/** 현재 상태 값 */
	private String statusCd;

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

	public Long[] getSurveySubjectSeqs() {
		return surveySubjectSeqs;
	}

	public void setSurveySubjectSeqs(Long[] surveySubjectSeqs) {
		this.surveySubjectSeqs = surveySubjectSeqs;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getStatusCd() {
		return statusCd;
	}

	public void setStatusCd(String statusCd) {
		this.statusCd = statusCd;
	}
}
