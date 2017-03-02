/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTemplateVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseHomeworkTemplateRS.java
 * @Title : 과제 템플릿 ResultSet
 * @date : 2014. 2. 20.
 * @author : 김현우
 * @descrption : 과제 템플릿 ResultSet
 */
public class UIUnivCourseTeamProjectTemplateRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 과제 템플릿 vo */
	private UIUnivCourseTeamProjectTemplateVO teamProjectTemplate;

	/** 멤버 vo */
	private UIMemberVO member;

	/** 과목 마스터 vo */
	private UIUnivCourseMasterVO courseMaster;

	public UIUnivCourseTeamProjectTemplateVO getTeamProjectTemplate() {
		return teamProjectTemplate;
	}

	public void setTeamProjectTemplate(UIUnivCourseTeamProjectTemplateVO teamProjectTemplate) {
		this.teamProjectTemplate = teamProjectTemplate;
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
