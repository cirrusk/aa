/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseTeamProjectMemberVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseTeamProjectMemberVO.java
 * @Title : 개설과목 팀프로젝트 팀원
 * @date : 2014. 2. 27.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseTeamProjectMemberVO extends UnivCourseTeamProjectMemberVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 자기가 속한 팀 일련번호 */
	private Long myCourseTeamSeq;

	/** 개설과목 팀 일련번호 */
	private Long[] courseTeamSeqs;

	public Long getMyCourseTeamSeq() {
		return myCourseTeamSeq;
	}

	public void setMyCourseTeamSeq(Long myCourseTeamSeq) {
		this.myCourseTeamSeq = myCourseTeamSeq;
	}

	public Long[] getCourseTeamSeqs() {
		return courseTeamSeqs;
	}

	public void setCourseTeamSeqs(Long[] courseTeamSeqs) {
		this.courseTeamSeqs = courseTeamSeqs;
	}
}
