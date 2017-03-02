/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamExampleVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamItemVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseQuizAnswerVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseQuizAnswerRS.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 10.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseQuizAnswerRS extends ResultSet {

	private static final long serialVersionUID = -3836615719700450123L;

	private UIUnivCourseExamItemVO courseExamItem;

	private UIUnivCourseQuizAnswerVO courseQuizAnswer;

	private UIUnivCourseExamExampleVO courseExamExample;

	private UIMemberVO member;

	public UIUnivCourseExamItemVO getCourseExamItem() {
		return courseExamItem;
	}

	public void setCourseExamItem(UIUnivCourseExamItemVO courseExamItem) {
		this.courseExamItem = courseExamItem;
	}

	public UIUnivCourseQuizAnswerVO getCourseQuizAnswer() {
		return courseQuizAnswer;
	}

	public void setCourseQuizAnswer(UIUnivCourseQuizAnswerVO courseQuizAnswer) {
		this.courseQuizAnswer = courseQuizAnswer;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

	public UIUnivCourseExamExampleVO getCourseExamExample() {
		return courseExamExample;
	}

	public void setCourseExamExample(UIUnivCourseExamExampleVO courseExamExample) {
		this.courseExamExample = courseExamExample;
	}
}
