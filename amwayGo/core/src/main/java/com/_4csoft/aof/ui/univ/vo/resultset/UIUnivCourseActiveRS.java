/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCategoryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveLecturerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSummaryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;
import com._4csoft.aof.ui.univ.vo.UIUnivYearTermVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseActiveRS.java
 * @Title : 개설과목
 * @date : 2014. 2. 26.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveRS extends ResultSet implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 개설과목 */
	private UIUnivCourseActiveVO courseActive;
	
	/** 과목마스터 */
	private UIUnivCourseMasterVO courseMaster;

	/** 년도학기 */
	private UIUnivYearTermVO yearTerm;

	/** 개설과목 집계 */
	private UIUnivCourseActiveSummaryVO courseActiveSummary;

	/** 분류 */
	private UIUnivCategoryVO category;

	/** 교수자정보 */
	private UIUnivCourseActiveLecturerVO lecturer;

	/** 교수자들 정보 (해당과정의 교수를 모두 뽑을 경우 사용) */
	private List<UIUnivCourseActiveLecturerRS> lecturerList;

	public UIUnivCourseActiveVO getCourseActive() {
		return courseActive;
	}

	public void setCourseActive(UIUnivCourseActiveVO courseActive) {
		this.courseActive = courseActive;
	}

	public UIUnivCourseMasterVO getCourseMaster() {
		return courseMaster;
	}

	public void setCourseMaster(UIUnivCourseMasterVO courseMaster) {
		this.courseMaster = courseMaster;
	}

	public UIUnivYearTermVO getYearTerm() {
		return yearTerm;
	}

	public void setYearTerm(UIUnivYearTermVO yearTerm) {
		this.yearTerm = yearTerm;
	}

	public UIUnivCourseActiveSummaryVO getCourseActiveSummary() {
		return courseActiveSummary;
	}

	public void setCourseActiveSummary(UIUnivCourseActiveSummaryVO courseActiveSummary) {
		this.courseActiveSummary = courseActiveSummary;
	}

	public UIUnivCourseActiveLecturerVO getLecturer() {
		return lecturer;
	}

	public void setLecturer(UIUnivCourseActiveLecturerVO lecturer) {
		this.lecturer = lecturer;
	}

	public UIUnivCategoryVO getCategory() {
		return category;
	}

	public void setCategory(UIUnivCategoryVO category) {
		this.category = category;
	}

	public List<UIUnivCourseActiveLecturerRS> getLecturerList() {
		return lecturerList;
	}

	public void setLecturerList(List<UIUnivCourseActiveLecturerRS> lecturerList) {
		this.lecturerList = lecturerList;
	}

}
