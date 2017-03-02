/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectBbsVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseTeamProjectBbsRS.java
 * @Title : 팀프로젝트 게시물
 * @date : 2014. 3. 14.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseTeamProjectBbsRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 팀프로젝트 게시물 */
	private UIUnivCourseTeamProjectBbsVO bbs;

	public UIUnivCourseTeamProjectBbsVO getBbs() {
		return bbs;
	}

	public void setBbs(UIUnivCourseTeamProjectBbsVO bbs) {
		this.bbs = bbs;
	}
}
