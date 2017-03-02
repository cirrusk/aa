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
 * @File : CourseActiveSurveyDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 24.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class CourseActiveSurveyDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** cs_course_active_survey_seq */
	private Long courseActiveSurveySeq;

	/** cs_survey_subject_seq */
	private Long surveySubjectSeq;

	/** cs_survey_paper_seq */
	private Long surveyPaperSeq;

	/** cs_course_active_seq */
	private Long courseActiveSeq;

	/** 등록, 수정, 삭제용 변수 */
	private String surveyPaperTitle;

	private String surveyTitle;

	/** cs_start_dtime */
	private String startDtime;

	/** cs_end_dtime */
	private String endDtime;

	/** 사용여부 */
	private String useYn;

	/** 설문 제출유무 */
	private String statusYn;
	
	/** 제출일 */
	private String sendDtime;
	/** 제출여부 */
	private String surveyYn;

	public Long getCourseActiveSurveySeq() {
		return courseActiveSurveySeq;
	}

	public void setCourseActiveSurveySeq(Long courseActiveSurveySeq) {
		this.courseActiveSurveySeq = courseActiveSurveySeq;
	}

	public Long getSurveySubjectSeq() {
		return surveySubjectSeq;
	}

	public void setSurveySubjectSeq(Long surveySubjectSeq) {
		this.surveySubjectSeq = surveySubjectSeq;
	}

	public Long getSurveyPaperSeq() {
		return surveyPaperSeq;
	}

	public void setSurveyPaperSeq(Long surveyPaperSeq) {
		this.surveyPaperSeq = surveyPaperSeq;
	}

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}

	public String getSurveyPaperTitle() {
		return surveyPaperTitle;
	}

	public void setSurveyPaperTitle(String surveyPaperTitle) {
		this.surveyPaperTitle = surveyPaperTitle;
	}

	public String getStartDtime() {
		return startDtime;
	}

	public void setStartDtime(String startDtime) {
		this.startDtime = startDtime;
	}

	public String getEndDtime() {
		return endDtime;
	}

	public void setEndDtime(String endDtime) {
		this.endDtime = endDtime;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getSurveyYn() {
		return surveyYn;
	}

	public void setSurveyYn(String surveyYn) {
		this.surveyYn = surveyYn;
	}

	public String getSendDtime() {
		return sendDtime;
	}

	public void setSendDtime(String sendDtime) {
		this.sendDtime = sendDtime;
	}

	public String getSurveyTitle() {
		return surveyTitle;
	}

	public void setSurveyTitle(String surveyTitle) {
		this.surveyTitle = surveyTitle;
	}

	public String getStatusYn() {
		return statusYn;
	}

	public void setStatusYn(String statusYn) {
		this.statusYn = statusYn;
	}
}
