/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.ui.board.dto.SystemBoardDTO;
import com._4csoft.aof.ui.infra.vo.condition.UIAgreementCondition;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : CourseActiveDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 26.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class CourseActiveDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/** cs_course_active_seq : 개설과목 일련번호 */
	private Long courseActiveSeq;

	/** cs_yesrterm : 년도학기 */
	private String yearTerm;

	/** cs_course_master_seq : 교과목 일련번호 */
	private Long courseMasterSeq;

	/** cs_course_active_title : 개설과목명 */
	private String courseActiveTitle;

	/** cs_introduction : 소개 */
	private String introduction;

	/** cs_goal : 목표 */
	private String goal;

	/** 시간표 */
	private String timeTableUrl;

	/** cs_study_start_date : 학습시작일 */
	private String studyStartDate;

	/** cs_study_end_date : 학습종료일 */
	private String studyEndDate;

	/** 과목분류 */
	private String categoryString;

	/** 과정 분류 */
	private Long categorySeq;

	/** cs_course_active_status_cd : 개설과목 상태코드 */
	private String courseActiveStatusCd;

	/** 평일을 제외한 일수 */
	private Long workDay;

	/** 수업 일 (박) */
	private Long workDay1;

	/** 수업 일 (일) */
	private Long workDay2;

	/** 평일을 제외한 일수 */
	private Long fullDay;

	/** 마스터 과정명 */
	private String courseTitle;

	private String categoryTypeCd;
	private String categoryType;
	private String courseTypeCd;
	private String courseType;

	/** 시간표 1 */
	private String timetable1;

	/** 시간표 2 */
	private String timetable2;

	/** 시간표 3 */
	private String timetable3;

	/** 시간표 4 */
	private String timetable4;

	/** 시간표 5 */
	private String timetable5;

	/** 시간표 6 */
	private String timetable6;

	private Long dDay;

	private List<MyCourseLecturerDTO> lecturerList;

	private List<SystemBoardDTO> boardList;
	
	private List<UIAgreementCondition> agreeList;

	private String hrPractice;
	private String externelPractice;
	private String panelDiscussion;
	
	/** 썸네일 */
	private String thumNail;
	
	private String applyType;

	public Long getdDay() {
		return dDay;
	}

	public void setdDay(Long dDay) {
		this.dDay = dDay;
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

	public String getCourseActiveTitle() {
		return courseActiveTitle;
	}

	public void setCourseActiveTitle(String courseActiveTitle) {
		this.courseActiveTitle = courseActiveTitle;
	}

	public String getIntroduction() {
		return introduction;
	}

	public void setIntroduction(String introduction) {
		this.introduction = introduction;
	}

	public String getGoal() {
		return goal;
	}

	public void setGoal(String goal) {
		this.goal = goal;
	}

	public List<MyCourseLecturerDTO> getLecturerList() {
		return lecturerList;
	}

	public void setLecturerList(List<MyCourseLecturerDTO> lecturerList) {
		this.lecturerList = lecturerList;
	}

	public String getTimeTableUrl() {
		return timeTableUrl;
	}

	public void setTimeTableUrl(String timeTableUrl) {
		this.timeTableUrl = timeTableUrl;
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

	public String getCategoryString() {
		return categoryString;
	}

	public void setCategoryString(String categoryString) {
		this.categoryString = categoryString;
	}

	public String getCourseActiveStatusCd() {
		return courseActiveStatusCd;
	}

	public void setCourseActiveStatusCd(String courseActiveStatusCd) {
		this.courseActiveStatusCd = courseActiveStatusCd;
	}

	public Long getCategorySeq() {
		return categorySeq;
	}

	public void setCategorySeq(Long categorySeq) {
		this.categorySeq = categorySeq;
	}

	public String getCourseTitle() {
		return courseTitle;
	}

	public void setCourseTitle(String courseTitle) {
		this.courseTitle = courseTitle;
	}

	public List<SystemBoardDTO> getBoardList() {
		return boardList;
	}

	public void setBoardList(List<SystemBoardDTO> boardList) {
		this.boardList = boardList;
	}

	public Long getFullDay() {
		return fullDay;
	}

	public void setFullDay(Long fullDay) {
		this.fullDay = fullDay;
	}

	public Long getWorkDay1() {
		return workDay1;
	}

	public void setWorkDay1(Long workDay1) {
		this.workDay1 = workDay1;
	}

	public Long getWorkDay2() {
		return workDay2;
	}

	public void setWorkDay2(Long workDay2) {
		this.workDay2 = workDay2;
	}

	public Long getWorkDay() {
		return workDay;
	}

	public void setWorkDay(Long workDay) {
		this.workDay = workDay;
	}

	public String getCategoryTypeCd() {
		return categoryTypeCd;
	}

	public void setCategoryTypeCd(String categoryTypeCd) {
		this.categoryTypeCd = categoryTypeCd;
	}

	public String getCategoryType() {
		return categoryType;
	}

	public void setCategoryType(String categoryType) {
		this.categoryType = categoryType;
	}

	public String getCourseTypeCd() {
		return courseTypeCd;
	}

	public void setCourseTypeCd(String courseTypeCd) {
		this.courseTypeCd = courseTypeCd;
	}

	public String getCourseType() {
		return courseType;
	}

	public void setCourseType(String courseType) {
		this.courseType = courseType;
	}

	public String getTimetable1() {
		return timetable1;
	}

	public void setTimetable1(String timetable1) {
		this.timetable1 = timetable1;
	}

	public String getTimetable2() {
		return timetable2;
	}

	public void setTimetable2(String timetable2) {
		this.timetable2 = timetable2;
	}

	public String getTimetable3() {
		return timetable3;
	}

	public void setTimetable3(String timetable3) {
		this.timetable3 = timetable3;
	}

	public String getTimetable4() {
		return timetable4;
	}

	public void setTimetable4(String timetable4) {
		this.timetable4 = timetable4;
	}

	public String getTimetable5() {
		return timetable5;
	}

	public void setTimetable5(String timetable5) {
		this.timetable5 = timetable5;
	}

	public String getTimetable6() {
		return timetable6;
	}

	public void setTimetable6(String timetable6) {
		this.timetable6 = timetable6;
	}

	public String getHrPractice() {
		return hrPractice;
	}

	public void setHrPractice(String hrPractice) {
		this.hrPractice = hrPractice;
	}

	public String getExternelPractice() {
		return externelPractice;
	}

	public void setExternelPractice(String externelPractice) {
		this.externelPractice = externelPractice;
	}

	public String getPanelDiscussion() {
		return panelDiscussion;
	}

	public void setPanelDiscussion(String panelDiscussion) {
		this.panelDiscussion = panelDiscussion;
	}

	public String getThumNail() {
		return thumNail;
	}

	public void setThumNail(String thumNail) {
		this.thumNail = thumNail;
	}

	public List<UIAgreementCondition> getAgreeList() {
		return agreeList;
	}

	public void setAgreeList(List<UIAgreementCondition> agreeList) {
		this.agreeList = agreeList;
	}

	public String getApplyType() {
		return applyType;
	}

	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}

}
