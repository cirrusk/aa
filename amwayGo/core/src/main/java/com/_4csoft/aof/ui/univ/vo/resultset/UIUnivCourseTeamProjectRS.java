/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBbsVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSummaryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTeamVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseTeamProjectRS.java
 * @Title : 개설과목 팀프로젝트 팀
 * @date : 2014. 2. 25.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseTeamProjectRS extends ResultSet implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 개설과목 팀프로젝트 */
	private UIUnivCourseTeamProjectVO courseTeamProject;

	/** 개설과목 게시글 */
	private UIUnivCourseActiveBbsVO courseActiveBbs;

	/** 개설과목 과제응답 */
	private UIUnivCourseHomeworkAnswerVO courseHomeworkAnswer;

	/** 개설 과목 집계 */
	private UIUnivCourseActiveSummaryVO courseActiveSummary;

	/** 개설과목 팀프로젝트 팀 */
	private UIUnivCourseTeamProjectTeamVO courseTeamProjectTeam;

	public UIUnivCourseTeamProjectVO getCourseTeamProject() {
		return courseTeamProject;
	}

	public void setCourseTeamProject(UIUnivCourseTeamProjectVO courseTeamProject) {
		this.courseTeamProject = courseTeamProject;
	}

	public UIUnivCourseActiveBbsVO getCourseActiveBbs() {
		return courseActiveBbs;
	}

	public void setCourseActiveBbs(UIUnivCourseActiveBbsVO courseActiveBbs) {
		this.courseActiveBbs = courseActiveBbs;
	}

	public UIUnivCourseHomeworkAnswerVO getCourseHomeworkAnswer() {
		return courseHomeworkAnswer;
	}

	public void setCourseHomeworkAnswer(UIUnivCourseHomeworkAnswerVO courseHomeworkAnswer) {
		this.courseHomeworkAnswer = courseHomeworkAnswer;
	}

	public UIUnivCourseActiveSummaryVO getCourseActiveSummary() {
		return courseActiveSummary;
	}

	public void setCourseActiveSummary(UIUnivCourseActiveSummaryVO courseActiveSummary) {
		this.courseActiveSummary = courseActiveSummary;
	}

	public UIUnivCourseTeamProjectTeamVO getCourseTeamProjectTeam() {
		return courseTeamProjectTeam;
	}

	public void setCourseTeamProjectTeam(UIUnivCourseTeamProjectTeamVO courseTeamProjectTeam) {
		this.courseTeamProjectTeam = courseTeamProjectTeam;
	}

}
