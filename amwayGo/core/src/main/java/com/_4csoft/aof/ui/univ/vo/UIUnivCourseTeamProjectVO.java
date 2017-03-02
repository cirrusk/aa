/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseTeamProjectVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseTeamProjectVO.java
 * @Title : 개설과목 팀프로젝트
 * @date : 2014. 2. 24.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseTeamProjectVO extends UnivCourseTeamProjectVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 프로젝트팀 수 */
	private Long projectTeamCount;

	/** 개설과목 팀프로젝트 일련번호 일련변호 Array */
	private Long[] courseTeamProjectSeqs;

	/** 비율 Array */
	private Double[] rates;

	/** 팀프로젝트 상태 - 대기 : R(ready), 진행: D(doing), 종료: E(end) */
	private String teamProjectStatusCd;

	/** 팀프로젝트 과제 제출 상태 - 대기 : R(ready), 진행: D(doing), 종료: E(end) */
	private String homeworkStatusCd;

	/** 교과목 일련번호 */
	private Long courseMasterSeq;

	/** 바로가기 개설과목일련번호 파라미터 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 파라미터 */
	private String shortcutCategoryTypeCd;

	/** D-day */
	private Long dDayCount;

	/** 다운로드 가능 여부 */
	private String downloadYn;

	/** 쿼리 조건에 사용 api에서 사용 */
	private String srchTotalTeamYn = "N";

	/**
	 * 바로가기 값 복사(copy ShortcutCourseActiveSeq to CourseActiveSeq)
	 */
	public void copyShortcut() {
		super.setCourseActiveSeq(this.getShortcutCourseActiveSeq());
	}

	public Long getProjectTeamCount() {
		return projectTeamCount;
	}

	public void setProjectTeamCount(Long projectTeamCount) {
		this.projectTeamCount = projectTeamCount;
	}

	public Long[] getCourseTeamProjectSeqs() {
		return courseTeamProjectSeqs;
	}

	public void setCourseTeamProjectSeqs(Long[] courseTeamProjectSeqs) {
		this.courseTeamProjectSeqs = courseTeamProjectSeqs;
	}

	public String getTeamProjectStatusCd() {
		return teamProjectStatusCd;
	}

	public void setTeamProjectStatusCd(String teamProjectStatusCd) {
		this.teamProjectStatusCd = teamProjectStatusCd;
	}

	public Long getCourseMasterSeq() {
		return courseMasterSeq;
	}

	public void setCourseMasterSeq(Long courseMasterSeq) {
		this.courseMasterSeq = courseMasterSeq;
	}

	public Long getShortcutCourseActiveSeq() {
		return shortcutCourseActiveSeq;
	}

	public void setShortcutCourseActiveSeq(Long shortcutCourseActiveSeq) {
		this.shortcutCourseActiveSeq = shortcutCourseActiveSeq;
	}

	public Double[] getRates() {
		return rates;
	}

	public void setRates(Double[] rates) {
		this.rates = rates;
	}

	public String getShortcutCategoryTypeCd() {
		return shortcutCategoryTypeCd;
	}

	public void setShortcutCategoryTypeCd(String shortcutCategoryTypeCd) {
		this.shortcutCategoryTypeCd = shortcutCategoryTypeCd;
	}

	public String getHomeworkStatusCd() {
		return homeworkStatusCd;
	}

	public void setHomeworkStatusCd(String homeworkStatusCd) {
		this.homeworkStatusCd = homeworkStatusCd;
	}

	public Long getdDayCount() {
		return dDayCount;
	}

	public void setdDayCount(Long dDayCount) {
		this.dDayCount = dDayCount;
	}

	public String getDownloadYn() {
		return downloadYn;
	}

	public void setDownloadYn(String downloadYn) {
		this.downloadYn = downloadYn;
	}

	public String getSrchTotalTeamYn() {
		return srchTotalTeamYn;
	}

	public void setSrchTotalTeamYn(String srchTotalTeamYn) {
		this.srchTotalTeamYn = srchTotalTeamYn;
	}

}
