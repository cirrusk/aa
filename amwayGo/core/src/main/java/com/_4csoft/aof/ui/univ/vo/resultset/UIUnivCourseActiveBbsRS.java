/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCategoryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBbsVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.vo.resultset
 * @File : UIUnivCourseActiveBbsRS.java
 * @Title : 게시글
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveBbsRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private UIUnivCourseActiveBbsVO bbs;

	/** */
	private UIUnivCourseActiveVO courseActive;

	private UIMemberVO member;

	/** */
	private UIUnivCategoryVO category;

	public UIUnivCourseActiveBbsVO getBbs() {
		return bbs;
	}

	public void setBbs(UIUnivCourseActiveBbsVO bbs) {
		this.bbs = bbs;
	}

	public UIUnivCourseActiveVO getCourseActive() {
		return courseActive;
	}

	public void setCourseActive(UIUnivCourseActiveVO courseActive) {
		this.courseActive = courseActive;
	}

	public UIUnivCategoryVO getCategory() {
		return category;
	}

	public void setCategory(UIUnivCategoryVO category) {
		this.category = category;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

}
