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
 * @File : UICourseMasterListDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 18.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class CourseMasterListDTO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/** cs_course_master_seq : 교과목 일련번호 */
	private Long courseMasterSeq;

	/** cs_category_organization_seq : 소속학과(분류 일련번호) */
	private Long categoryOrganizationSeq;

	/** cs_category_string : 분류 경로명 */
	private String categoryString;

	/** cs_course_title : 교과목명 */
	private String courseTitle;

	/** cs_use_count : 활용수 */
	private Long useCount;

	/** cs_complete_division_cd : 이수구분 코드 */
	private String completeDivisionCd;

	/** cs_complete_division_cd : 이수구분 */
	private String completeDivision;

	/** cs_complete_division_point : 이수학점 */
	private Long completeDivisionPoint;

	/** cs_course_status_cd : 교과목 상태 코드 */
	private String courseStatusCd;
	/** cs_course_status_cd : 교과목 상태 */
	private String courseStatus;

	/** cs_reg_dtime */
	private String regDtime;

	public Long getCourseMasterSeq() {
		return courseMasterSeq;
	}

	public void setCourseMasterSeq(Long courseMasterSeq) {
		this.courseMasterSeq = courseMasterSeq;
	}

	public Long getCategoryOrganizationSeq() {
		return categoryOrganizationSeq;
	}

	public void setCategoryOrganizationSeq(Long categoryOrganizationSeq) {
		this.categoryOrganizationSeq = categoryOrganizationSeq;
	}

	public String getCourseTitle() {
		return courseTitle;
	}

	public void setCourseTitle(String courseTitle) {
		this.courseTitle = courseTitle;
	}

	public Long getUseCount() {
		return useCount;
	}

	public void setUseCount(Long useCount) {
		this.useCount = useCount;
	}

	public String getCompleteDivisionCd() {
		return completeDivisionCd;
	}

	public void setCompleteDivisionCd(String completeDivisionCd) {
		this.completeDivisionCd = completeDivisionCd;
	}

	public Long getCompleteDivisionPoint() {
		return completeDivisionPoint;
	}

	public void setCompleteDivisionPoint(Long completeDivisionPoint) {
		this.completeDivisionPoint = completeDivisionPoint;
	}

	public String getCourseStatusCd() {
		return courseStatusCd;
	}

	public void setCourseStatusCd(String courseStatusCd) {
		this.courseStatusCd = courseStatusCd;
	}

	public String getCategoryString() {
		return categoryString;
	}

	public void setCategoryString(String categoryString) {
		this.categoryString = categoryString;
	}

	public String getCompleteDivision() {
		return completeDivision;
	}

	public void setCompleteDivision(String completeDivision) {
		this.completeDivision = completeDivision;
	}

	public String getCourseStatus() {
		return courseStatus;
	}

	public void setCourseStatus(String courseStatus) {
		this.courseStatus = courseStatus;
	}

	public String getRegDtime() {
		return regDtime;
	}

	public void setRegDtime(String regDtime) {
		this.regDtime = regDtime;
	}

}
