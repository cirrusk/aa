/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;
import java.util.List;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : CourseTeamProjectDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 20.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class CourseTeamProjectDTO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/** 개설과목 일련번호 */
	private Long courseActiveSeq;

	/** cs_course_teamproject_seq : 개설과목 팀프로젝트 일련번호 */
	private Long courseTeamProjectSeq;

	private Long courseTeamSeq;

	private String teamProjectTitle;

	private String teamTitle;

	/** 나의 팀여부 */
	private String myTeamYn;

	/** 공개여부 */
	private String openYn;

	private Long bbsCount;

	private Long newsCnt;

	private List<CourseTeamProjectTeamDTO> memberlist;

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}

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

	public String getTeamProjectTitle() {
		return teamProjectTitle;
	}

	public void setTeamProjectTitle(String teamProjectTitle) {
		this.teamProjectTitle = teamProjectTitle;
	}

	public String getTeamTitle() {
		return teamTitle;
	}

	public void setTeamTitle(String teamTitle) {
		this.teamTitle = teamTitle;
	}

	public List<CourseTeamProjectTeamDTO> getMemberlist() {
		return memberlist;
	}

	public void setMemberlist(List<CourseTeamProjectTeamDTO> memberlist) {
		this.memberlist = memberlist;
	}

	public String getMyTeamYn() {
		return myTeamYn;
	}

	public void setMyTeamYn(String myTeamYn) {
		this.myTeamYn = myTeamYn;
	}

	public String getOpenYn() {
		return openYn;
	}

	public void setOpenYn(String openYn) {
		this.openYn = openYn;
	}

	public Long getBbsCount() {
		return bbsCount;
	}

	public void setBbsCount(Long bbsCount) {
		this.bbsCount = bbsCount;
	}

	public Long getNewsCnt() {
		return newsCnt;
	}

	public void setNewsCnt(Long newsCnt) {
		this.newsCnt = newsCnt;
	}

}
