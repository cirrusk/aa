/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussTemplateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseDiscussTemplateRS.java
 * @Title : 토론템플릿
 * @date : 2014. 2. 23.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseDiscussTemplateRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 토론 템플릿 vo */
	private UIUnivCourseDiscussTemplateVO discussTemplate;

	/** 멤버 vo */
	private UIMemberVO member;

	/** 과목 마스터 vo */
	private UIUnivCourseMasterVO courseMaster;

	public UIUnivCourseDiscussTemplateVO getDiscussTemplate() {
		return discussTemplate;
	}

	public void setDiscussTemplate(UIUnivCourseDiscussTemplateVO discussTemplate) {
		this.discussTemplate = discussTemplate;
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
