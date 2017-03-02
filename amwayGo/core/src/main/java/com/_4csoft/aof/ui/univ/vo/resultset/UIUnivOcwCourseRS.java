/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCategoryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;
import com._4csoft.aof.ui.univ.vo.UIUnivOcwCourseVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivOcwCourseRS.java
 * @Title : ocw 과목 ResultSet
 * @date : 2014. 5. 08.
 * @author : 김현우
 * @descrption : 과제 템플릿 ResultSet
 */
public class UIUnivOcwCourseRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** ocw 과목 vo */
	private UIUnivOcwCourseVO ocwCourse;

	/** 멤버 vo */
	private UIMemberVO member;

	/** 과목 마스터 vo */
	private UIUnivCourseMasterVO courseMaster;

	/** 개설과목 vo */
	private UIUnivCourseActiveVO courseActive;

	/** 카테고리 vo */
	private UIUnivCategoryVO cate;

	public UIUnivOcwCourseVO getOcwCourse() {
		return ocwCourse;
	}

	public void setOcwCourse(UIUnivOcwCourseVO ocwCourse) {
		this.ocwCourse = ocwCourse;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

	public UIUnivCourseMasterVO getCourseMaster() {
		return courseMaster;
	}

	public void setCourseMaster(UIUnivCourseMasterVO courseMaster) {
		this.courseMaster = courseMaster;
	}

	public UIUnivCourseActiveVO getCourseActive() {
		return courseActive;
	}

	public void setCourseActive(UIUnivCourseActiveVO courseActive) {
		this.courseActive = courseActive;
	}

	public UIUnivCategoryVO getCate() {
		return cate;
	}

	public void setCate(UIUnivCategoryVO cate) {
		this.cate = cate;
	}

}
