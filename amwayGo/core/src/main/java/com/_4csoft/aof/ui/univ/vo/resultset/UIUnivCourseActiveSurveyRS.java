/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyPaperAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveySubjectVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseActiveSurveyRS.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 14.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveSurveyRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UIUnivCourseActiveSurveyVO courseActiveSurvey;

	private UIUnivSurveyPaperVO surveyPaper;

	private UIUnivSurveySubjectVO surveySubject;

	private UIUnivCourseActiveSurveyPaperAnswerVO surveyPaperAnswer;

	public UIUnivCourseActiveSurveyVO getCourseActiveSurvey() {
		return courseActiveSurvey;
	}

	public void setCourseActiveSurvey(UIUnivCourseActiveSurveyVO courseActiveSurvey) {
		this.courseActiveSurvey = courseActiveSurvey;
	}

	public UIUnivSurveyPaperVO getSurveyPaper() {
		return surveyPaper;
	}

	public void setSurveyPaper(UIUnivSurveyPaperVO surveyPaper) {
		this.surveyPaper = surveyPaper;
	}

	public UIUnivSurveySubjectVO getSurveySubject() {
		return surveySubject;
	}

	public void setSurveySubject(UIUnivSurveySubjectVO surveySubject) {
		this.surveySubject = surveySubject;
	}

	public UIUnivCourseActiveSurveyPaperAnswerVO getSurveyPaperAnswer() {
		return surveyPaperAnswer;
	}

	public void setSurveyPaperAnswer(UIUnivCourseActiveSurveyPaperAnswerVO surveyPaperAnswer) {
		this.surveyPaperAnswer = surveyPaperAnswer;
	}

}
