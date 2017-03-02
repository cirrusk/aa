/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTeamVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseHomeworkAnswerRS.java
 * @Title : 과제 제출 ResultSet
 * @date : 2014. 3. 4.
 * @author : 김현우
 * @descrption : 과제 제출 ResultSet
 */
public class UIUnivCourseHomeworkAnswerRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 과제 제출 */
	private UIUnivCourseHomeworkAnswerVO answer;

	/** 개설과목 팀프로젝트 팀원 */
	private UIUnivCourseTeamProjectMemberVO teamProjectMember;

	private UIUnivCourseTeamProjectTeamVO projectTeam;

	/** 개설과목 구성정보 */
	private UIUnivCourseActiveElementVO courseActiveElement;

	public UIUnivCourseHomeworkAnswerVO getAnswer() {
		return answer;
	}

	public void setAnswer(UIUnivCourseHomeworkAnswerVO answer) {
		this.answer = answer;
	}

	public UIUnivCourseTeamProjectMemberVO getTeamProjectMember() {
		return teamProjectMember;
	}

	public void setTeamProjectMember(UIUnivCourseTeamProjectMemberVO teamProjectMember) {
		this.teamProjectMember = teamProjectMember;
	}

	public UIUnivCourseTeamProjectTeamVO getProjectTeam() {
		return projectTeam;
	}

	public void setProjectTeam(UIUnivCourseTeamProjectTeamVO projectTeam) {
		this.projectTeam = projectTeam;
	}

	public UIUnivCourseActiveElementVO getCourseActiveElement() {
		return courseActiveElement;
	}

	public void setCourseActiveElement(UIUnivCourseActiveElementVO courseActiveElement) {
		this.courseActiveElement = courseActiveElement;
	}

}
