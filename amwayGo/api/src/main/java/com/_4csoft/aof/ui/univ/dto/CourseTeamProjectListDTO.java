package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;


/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : CourseTeamProjectListDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 5. 6.
 * @author : 조경재
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class CourseTeamProjectListDTO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** cs_course_teamproject_seq : 개설과목 팀프로젝트 일련번호 */
	private Long courseTeamProjectSeq;

	/** cs_course_active_seq : 개설과목 일련번호 */
	private Long courseActiveSeq;
	
	/** cs_teamproject_title : 팀프로젝트 제목 */
	private String teamProjectTitle;
	
	/** cs_description : 팀프로젝트 내용 */
	private String description;
	
	/** 프로젝트팀 수 */
	private Long projectTeamCount;
	
	/** cs_open_yn : 공개여부 */
	private String openYn;
	
	/** 팀프로젝트 상태 - 대기 : R(ready), 진행: D(doing), 종료: E(end) */
	private String teamProjectStatusCd;

	public Long getCourseTeamProjectSeq() {
		return courseTeamProjectSeq;
	}

	public void setCourseTeamProjectSeq(Long courseTeamProjectSeq) {
		this.courseTeamProjectSeq = courseTeamProjectSeq;
	}

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}

	public String getTeamProjectTitle() {
		return teamProjectTitle;
	}

	public void setTeamProjectTitle(String teamProjectTitle) {
		this.teamProjectTitle = teamProjectTitle;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Long getProjectTeamCount() {
		return projectTeamCount;
	}

	public void setProjectTeamCount(Long projectTeamCount) {
		this.projectTeamCount = projectTeamCount;
	}

	public String getOpenYn() {
		return openYn;
	}

	public void setOpenYn(String openYn) {
		this.openYn = openYn;
	}

	public String getTeamProjectStatusCd() {
		return teamProjectStatusCd;
	}

	public void setTeamProjectStatusCd(String teamProjectStatusCd) {
		this.teamProjectStatusCd = teamProjectStatusCd;
	}
	
	
	
}
