/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperTargetVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSummaryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseActiveExamPaperRS.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 6.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveExamPaperRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UIUnivCourseActiveExamPaperVO courseActiveExamPaper;

	private UIUnivCourseActiveExamPaperTargetVO courseActiveExamPaperTarget;

	private UIUnivCourseExamPaperVO courseExamPaper;

	private UIUnivCourseActiveSummaryVO courseActiveSummary;

	private UIUnivCourseHomeworkVO courseHomework;

	public UIUnivCourseActiveExamPaperVO getCourseActiveExamPaper() {
		return courseActiveExamPaper;
	}

	public void setCourseActiveExamPaper(UIUnivCourseActiveExamPaperVO courseActiveExamPaper) {
		this.courseActiveExamPaper = courseActiveExamPaper;
	}

	public UIUnivCourseActiveExamPaperTargetVO getCourseActiveExamPaperTarget() {
		return courseActiveExamPaperTarget;
	}

	public void setCourseActiveExamPaperTarget(UIUnivCourseActiveExamPaperTargetVO courseActiveExamPaperTarget) {
		this.courseActiveExamPaperTarget = courseActiveExamPaperTarget;
	}

	public UIUnivCourseExamPaperVO getCourseExamPaper() {
		return courseExamPaper;
	}

	public void setCourseExamPaper(UIUnivCourseExamPaperVO courseExamPaper) {
		this.courseExamPaper = courseExamPaper;
	}

	public UIUnivCourseActiveSummaryVO getCourseActiveSummary() {
		return courseActiveSummary;
	}

	public void setCourseActiveSummary(UIUnivCourseActiveSummaryVO courseActiveSummary) {
		this.courseActiveSummary = courseActiveSummary;
	}

	public UIUnivCourseHomeworkVO getCourseHomework() {
		return courseHomework;
	}

	public void setCourseHomework(UIUnivCourseHomeworkVO courseHomework) {
		this.courseHomework = courseHomework;
	}

}
