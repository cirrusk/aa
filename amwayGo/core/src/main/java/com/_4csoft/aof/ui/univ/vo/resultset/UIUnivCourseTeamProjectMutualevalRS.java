/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectMutualevalVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseTeamProjectMutualevalRS.java
 * @Title : 개설과목 팀프로젝트 상호평가
 * @date : 2014. 3. 12.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseTeamProjectMutualevalRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 개설과목 팀프로젝트 상호평가 */
	private UIUnivCourseTeamProjectMutualevalVO courseTeamProjectMutualeval;

	/** 개설과목 팀프로젝트 */
	private UIUnivCourseTeamProjectVO courseTeamProject;

	/** 개설과목 팀프로젝트 팀원 */
	private UIUnivCourseTeamProjectMemberVO courseTeamProjectMember;

	/** 회원 정보 */
	private UIMemberVO member;

	public UIUnivCourseTeamProjectVO getCourseTeamProject() {
		return courseTeamProject;
	}

	public void setCourseTeamProject(UIUnivCourseTeamProjectVO courseTeamProject) {
		this.courseTeamProject = courseTeamProject;
	}

	public UIUnivCourseTeamProjectMutualevalVO getCourseTeamProjectMutualeval() {
		return courseTeamProjectMutualeval;
	}

	public void setCourseTeamProjectMutualeval(UIUnivCourseTeamProjectMutualevalVO courseTeamProjectMutualeval) {
		this.courseTeamProjectMutualeval = courseTeamProjectMutualeval;
	}

	public UIUnivCourseTeamProjectMemberVO getCourseTeamProjectMember() {
		return courseTeamProjectMember;
	}

	public void setCourseTeamProjectMember(UIUnivCourseTeamProjectMemberVO courseTeamProjectMember) {
		this.courseTeamProjectMember = courseTeamProjectMember;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

}
