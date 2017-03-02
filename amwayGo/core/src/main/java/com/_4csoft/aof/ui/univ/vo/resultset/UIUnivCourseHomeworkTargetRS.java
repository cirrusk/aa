/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkTargetVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseHomeworkTargetRS.java
 * @Title : 과제 대상자 ResultSet
 * @date : 2014. 3. 4.
 * @author : 김현우
 * @descrption : 과제 대상자 ResultSet
 */
public class UIUnivCourseHomeworkTargetRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 과제 제출 vo */
	private UIUnivCourseHomeworkTargetVO target;

	/** 멤버 vo */
	private UIMemberVO member;

	public UIUnivCourseHomeworkTargetVO getTarget() {
		return target;
	}

	public void setTarget(UIUnivCourseHomeworkTargetVO target) {
		this.target = target;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

}
