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
 * @File : CourseHomeWorkDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 20.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class CourseHomeWorkDTO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/** cs_homework_seq : 과제 일련번호 */
	private Long homeworkSeq;

	/** cs_reference_seq : 관련모듈 일련번호 */
	private Long referenceSeq;

	/** cs_reference_type : 관련모듈 일련번호에 대한 구분값 (EXAM: 시험, HOMEWORK: 과제) */
	private String referenceType;

	/** cs_homework_title : 과제명 */
	private String homeworkTitle;

	/** cs_homework_type_cd : 과제구분 : 일반, 대체, 보충 */
	private String homeworkTypeCd;

	/** cs_description : 과제내용 */
	private String description;

	/** cs_start_dtime : 1차 시작일시 */
	private String startDtime;

	/** cs_end_dtime : 1차 종료일시 */
	private String endDtime;

	/** cs_start2_dtime : 2차 시작일시 */
	private String start2Dtime;

	/** cs_end2_dtime : 2차 종료일시 */
	private String end2Dtime;

	/** cs_rate : 비율 */
	private Double rate;

	/** cs_rate2 : 1차 대비비율 */
	private Double rate2;

	/** cs_use_yn : 사용여부 */
	private String useYn;

	/** cs_onoff_cd : 온오프 구분 */
	private String onoffCd;

	/** cs_open_yn : 공개여부 */
	private String openYn;

	/** cs_replace_yn : 대체여부 */
	private String replaceYn;

	/** cs_course_master_seq : 과목마스터 시퀀스 */
	private Long courseMasterSeq;

	/** 상시제 학습시작 일 */
	private Long startDay;

	/** 상시제 학습종료 일 */
	private Long endDay;

	public Long getHomeworkSeq() {
		return homeworkSeq;
	}

	public void setHomeworkSeq(Long homeworkSeq) {
		this.homeworkSeq = homeworkSeq;
	}

	public Long getReferenceSeq() {
		return referenceSeq;
	}

	public void setReferenceSeq(Long referenceSeq) {
		this.referenceSeq = referenceSeq;
	}

	public String getReferenceType() {
		return referenceType;
	}

	public void setReferenceType(String referenceType) {
		this.referenceType = referenceType;
	}

	public String getHomeworkTitle() {
		return homeworkTitle;
	}

	public void setHomeworkTitle(String homeworkTitle) {
		this.homeworkTitle = homeworkTitle;
	}

	public String getHomeworkTypeCd() {
		return homeworkTypeCd;
	}

	public void setHomeworkTypeCd(String homeworkTypeCd) {
		this.homeworkTypeCd = homeworkTypeCd;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
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

	public String getStart2Dtime() {
		return start2Dtime;
	}

	public void setStart2Dtime(String start2Dtime) {
		this.start2Dtime = start2Dtime;
	}

	public String getEnd2Dtime() {
		return end2Dtime;
	}

	public void setEnd2Dtime(String end2Dtime) {
		this.end2Dtime = end2Dtime;
	}

	public Double getRate() {
		return rate;
	}

	public void setRate(Double rate) {
		this.rate = rate;
	}

	public Double getRate2() {
		return rate2;
	}

	public void setRate2(Double rate2) {
		this.rate2 = rate2;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getOnoffCd() {
		return onoffCd;
	}

	public void setOnoffCd(String onoffCd) {
		this.onoffCd = onoffCd;
	}

	public String getOpenYn() {
		return openYn;
	}

	public void setOpenYn(String openYn) {
		this.openYn = openYn;
	}

	public String getReplaceYn() {
		return replaceYn;
	}

	public void setReplaceYn(String replaceYn) {
		this.replaceYn = replaceYn;
	}

	public Long getCourseMasterSeq() {
		return courseMasterSeq;
	}

	public void setCourseMasterSeq(Long courseMasterSeq) {
		this.courseMasterSeq = courseMasterSeq;
	}

	public Long getStartDay() {
		return startDay;
	}

	public void setStartDay(Long startDay) {
		this.startDay = startDay;
	}

	public Long getEndDay() {
		return endDay;
	}

	public void setEndDay(Long endDay) {
		this.endDay = endDay;
	}

}
