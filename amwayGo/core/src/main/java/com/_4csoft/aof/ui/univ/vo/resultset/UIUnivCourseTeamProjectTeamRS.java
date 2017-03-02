/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBbsVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTeamVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseTeamProjectTeamRS.java
 * @Title : 개설과목 팀프로젝트 팀
 * @date : 2014. 2. 28.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseTeamProjectTeamRS extends ResultSet implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 개설과목 팀프로젝트 */
	private UIUnivCourseTeamProjectVO courseTeamProject;

	/** 개설과목 팀프로젝트 팀 */
	private UIUnivCourseTeamProjectTeamVO courseTeamProjectTeam;

	/** 개설과목 팀프로젝트 팀원 */
	private UIUnivCourseTeamProjectMemberVO courseTeamProjectMember;

	/** 개설과목 과제 */
	private UIUnivCourseHomeworkVO courseHomework;

	/** 개설과목 과제응답 */
	private UIUnivCourseHomeworkAnswerVO courseHomeworkAnswer;

	/** 개설 과목 게시글 */
	private UIUnivCourseActiveBbsVO courseActiveBbs;

	private UIMemberVO member;

	/** 개설과목 구성정보 */
	private UIUnivCourseActiveElementVO courseActiveElement;

	/** 프로젝트 팀원 목록 */
	private List<UIUnivCourseTeamProjectMemberVO> teamMemberList;

	public UIUnivCourseTeamProjectTeamVO getCourseTeamProjectTeam() {
		return courseTeamProjectTeam;
	}

	public void setCourseTeamProjectTeam(UIUnivCourseTeamProjectTeamVO courseTeamProjectTeam) {
		this.courseTeamProjectTeam = courseTeamProjectTeam;
	}

	public UIUnivCourseActiveBbsVO getCourseActiveBbs() {
		return courseActiveBbs;
	}

	public void setCourseActiveBbs(UIUnivCourseActiveBbsVO courseActiveBbs) {
		this.courseActiveBbs = courseActiveBbs;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

	public UIUnivCourseTeamProjectMemberVO getCourseTeamProjectMember() {
		return courseTeamProjectMember;
	}

	public void setCourseTeamProjectMember(UIUnivCourseTeamProjectMemberVO courseTeamProjectMember) {
		this.courseTeamProjectMember = courseTeamProjectMember;
	}

	public UIUnivCourseHomeworkVO getCourseHomework() {
		return courseHomework;
	}

	public void setCourseHomework(UIUnivCourseHomeworkVO courseHomework) {
		this.courseHomework = courseHomework;
	}

	public List<UIUnivCourseTeamProjectMemberVO> getTeamMemberList() {
		return teamMemberList;
	}

	public void setTeamMemberList(List<UIUnivCourseTeamProjectMemberVO> teamMemberList) {
		this.teamMemberList = teamMemberList;
	}

	public UIUnivCourseTeamProjectVO getCourseTeamProject() {
		return courseTeamProject;
	}

	public void setCourseTeamProject(UIUnivCourseTeamProjectVO courseTeamProject) {
		this.courseTeamProject = courseTeamProject;
	}

	public UIUnivCourseHomeworkAnswerVO getCourseHomeworkAnswer() {
		return courseHomeworkAnswer;
	}

	public void setCourseHomeworkAnswer(UIUnivCourseHomeworkAnswerVO courseHomeworkAnswer) {
		this.courseHomeworkAnswer = courseHomeworkAnswer;
	}

	public UIUnivCourseActiveElementVO getCourseActiveElement() {
		return courseActiveElement;
	}

	public void setCourseActiveElement(UIUnivCourseActiveElementVO courseActiveElement) {
		this.courseActiveElement = courseActiveElement;
	}
}
