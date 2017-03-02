/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

/**
 * @Project : lgaca-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : CourseTeamProjectTeamDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 27.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class CourseTeamProjectTeamDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/** 개설과목 팀프로젝트 일련번호 */
	private Long courseTeamProjectSeq;

	/** cs_course_team : 개설과목 팀 일련번호 */
	private Long courseTeamSeq;

	/** cs_team_member_seq : 팀원 일련번호 */
	private Long teamMemberSeq;

	/** 팀원 이름 */
	private String teamMemberName;

	/** cs_chief_yn : 팀장 여부 */
	private String chiefYn;

	/** 회사명 */
	private String companyName;

	public Long getCourseTeamProjectSeq() {
		return courseTeamProjectSeq;
	}

	public void setCourseTeamProjectSeq(Long courseTeamProjectSeq) {
		this.courseTeamProjectSeq = courseTeamProjectSeq;
	}

	public Long getCourseTeamSeq() {
		return courseTeamSeq;
	}

	public void setCourseTeamSeq(Long courseTeamSeq) {
		this.courseTeamSeq = courseTeamSeq;
	}

	public Long getTeamMemberSeq() {
		return teamMemberSeq;
	}

	public void setTeamMemberSeq(Long teamMemberSeq) {
		this.teamMemberSeq = teamMemberSeq;
	}

	public String getTeamMemberName() {
		return teamMemberName;
	}

	public void setTeamMemberName(String teamMemberName) {
		this.teamMemberName = teamMemberName;
	}

	public String getChiefYn() {
		return chiefYn;
	}

	public void setChiefYn(String chiefYn) {
		this.chiefYn = chiefYn;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
}
