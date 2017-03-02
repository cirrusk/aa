/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * 
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.condition
 * @File : UIUnivCourseApplyAttendCondition.java
 * @Title : 수강생 출석 Condition
 * @date : 2014. 3. 13.
 * @author : 김현우
 * @descrption : 수강생 출석 Condition
 */
public class UIUnivCourseApplyAttendCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 개설과목 키 */
	private Long srchCourseActiveSeq;

	/** 수강생 키 */
	private Long srchCourseApplySeq;

	/** 참조 키 */
	private Long srchReferenceSeq;

	/** cs_lesson_seq : 교시 일련번호 */
	private Long lessonSeq;

	/** cs_active_element_seq : 개설과목구성정보 일련번호 */
	private Long activeElementSeq;

	/** 검색 분류문자열(학부) */
	private String srchCategoryName;

	/** 과목분류 (상시제 구분하기 위해 사용) */
	private String courseTypeCd;

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public Long getSrchCourseApplySeq() {
		return srchCourseApplySeq;
	}

	public void setSrchCourseApplySeq(Long srchCourseApplySeq) {
		this.srchCourseApplySeq = srchCourseApplySeq;
	}

	public Long getSrchReferenceSeq() {
		return srchReferenceSeq;
	}

	public void setSrchReferenceSeq(Long srchReferenceSeq) {
		this.srchReferenceSeq = srchReferenceSeq;
	}

	public Long getLessonSeq() {
		return lessonSeq;
	}

	public void setLessonSeq(Long lessonSeq) {
		this.lessonSeq = lessonSeq;
	}

	public Long getActiveElementSeq() {
		return activeElementSeq;
	}

	public void setActiveElementSeq(Long activeElementSeq) {
		this.activeElementSeq = activeElementSeq;
	}

	public String getSrchCategoryName() {
		return srchCategoryName;
	}

	public void setSrchCategoryName(String srchCategoryName) {
		this.srchCategoryName = srchCategoryName;
	}

	public String getSrchCategoryNameDB() {
		return srchCategoryName.replaceAll("%", "\\\\%");
	}

	public String getCourseTypeCd() {
		return courseTypeCd;
	}

	public void setCourseTypeCd(String courseTypeCd) {
		this.courseTypeCd = courseTypeCd;
	}

}
