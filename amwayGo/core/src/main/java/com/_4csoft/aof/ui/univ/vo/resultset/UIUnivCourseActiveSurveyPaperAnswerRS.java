/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyPaperAnswerVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseActiveSurveyPaperAnswerRS.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 20.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveSurveyPaperAnswerRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UIUnivCourseActiveSurveyPaperAnswerVO courseActiveSurveyPaperAnswer;

	public UIUnivCourseActiveSurveyPaperAnswerVO getCourseActiveSurveyPaperAnswer() {
		return courseActiveSurveyPaperAnswer;
	}

	public void setCourseActiveSurveyPaperAnswer(UIUnivCourseActiveSurveyPaperAnswerVO courseActiveSurveyPaperAnswer) {
		this.courseActiveSurveyPaperAnswer = courseActiveSurveyPaperAnswer;
	}

}
