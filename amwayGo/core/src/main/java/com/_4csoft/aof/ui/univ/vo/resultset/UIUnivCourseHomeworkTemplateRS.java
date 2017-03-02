/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkTemplateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseHomeworkTemplateRS.java
 * @Title : 과제 템플릿 ResultSet
 * @date : 2014. 2. 20.
 * @author : 김현우
 * @descrption : 과제 템플릿 ResultSet
 */
public class UIUnivCourseHomeworkTemplateRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 과제 템플릿 vo */
	private UIUnivCourseHomeworkTemplateVO homeworkTemplate;

	/** 멤버 vo */
	private UIMemberVO member;

	/** 과목 마스터 vo */
	private UIUnivCourseMasterVO courseMaster;

	public UIUnivCourseHomeworkTemplateVO getHomeworkTemplate() {
		return homeworkTemplate;
	}

	public void setHomeworkTemplate(UIUnivCourseHomeworkTemplateVO homeworkTemplate) {
		this.homeworkTemplate = homeworkTemplate;
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

}
