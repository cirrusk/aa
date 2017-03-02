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
 * @File : CourseApplyMemberDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 23.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class CourseApplyMemberDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/** cs_course_apply_seq : 수강생 일련번호 */
	private Long courseApplySeq;

	/** cs_course_active_seq : 개설과목 일련번호 */
	private Long courseActiveSeq;

	/** cs_yearterm : 년도학기 */
	private String yearTerm;

	/** cs_course_master_seq : 교과목 일련번호 */
	private Long courseMasterSeq;

	/** cs_division : 분반 */
	private Long division;

	/** cs_member_seq : 맴버일련번호 */
	private Long memberSeq;

	/** cs_apply_status_dtime : 상태변경일 */
	private String applyStatusDtime;

	/** cs_study_start_date : 학습시작일 */
	private String studyStartDate;

	/** cs_study_end_date : 학습종료일 */
	private String studyEndDate;
	/** 수강생 이름 */
	private String memberName;

	public Long getCourseApplySeq() {
		return courseApplySeq;
	}

	public void setCourseApplySeq(Long courseApplySeq) {
		this.courseApplySeq = courseApplySeq;
	}

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}

	public String getYearTerm() {
		return yearTerm;
	}

	public void setYearTerm(String yearTerm) {
		this.yearTerm = yearTerm;
	}

	public Long getCourseMasterSeq() {
		return courseMasterSeq;
	}

	public void setCourseMasterSeq(Long courseMasterSeq) {
		this.courseMasterSeq = courseMasterSeq;
	}

	public Long getDivision() {
		return division;
	}

	public void setDivision(Long division) {
		this.division = division;
	}

	public Long getMemberSeq() {
		return memberSeq;
	}

	public void setMemberSeq(Long memberSeq) {
		this.memberSeq = memberSeq;
	}

	public String getApplyStatusDtime() {
		return applyStatusDtime;
	}

	public void setApplyStatusDtime(String applyStatusDtime) {
		this.applyStatusDtime = applyStatusDtime;
	}

	public String getStudyStartDate() {
		return studyStartDate;
	}

	public void setStudyStartDate(String studyStartDate) {
		this.studyStartDate = studyStartDate;
	}

	public String getStudyEndDate() {
		return studyEndDate;
	}

	public void setStudyEndDate(String studyEndDate) {
		this.studyEndDate = studyEndDate;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

}
