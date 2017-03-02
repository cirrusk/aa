/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussBbsVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseDiscussBbsRS.java
 * @Title : 토론 게시물
 * @date : 2014. 3. 19.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseDiscussBbsRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 팀프로젝트 게시물 */
	private UIUnivCourseDiscussBbsVO bbs;

	public UIUnivCourseDiscussBbsVO getBbs() {
		return bbs;
	}

	public void setBbs(UIUnivCourseDiscussBbsVO bbs) {
		this.bbs = bbs;
	}

}
