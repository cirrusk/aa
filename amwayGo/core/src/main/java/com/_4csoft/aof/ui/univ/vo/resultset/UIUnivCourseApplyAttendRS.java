/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UICategoryVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyAttendVO;

/**
 * 
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseApplyAttendRS.java
 * @Title : 수강생 출석 ResultSet
 * @date : 2014. 3. 13.
 * @author : 김현우
 * @descrption : 수강생 출석 ResultSet
 */
public class UIUnivCourseApplyAttendRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 출석 평가기준 vo */
	private UIUnivCourseApplyAttendVO applyAttend;

	/** 개설과목 구성정보 vo */
	private UIUnivCourseActiveElementVO element;
	
	/** 멤버 vo */
	private UIMemberVO member;

	/** 카테고리 vo */
	private UICategoryVO cate;

	public UIUnivCourseApplyAttendVO getApplyAttend() {
		return applyAttend;
	}

	public void setApplyAttend(UIUnivCourseApplyAttendVO applyAttend) {
		this.applyAttend = applyAttend;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

	public UICategoryVO getCate() {
		return cate;
	}

	public void setCate(UICategoryVO cate) {
		this.cate = cate;
	}

	public UIUnivCourseActiveElementVO getElement() {
		return element;
	}

	public void setElement(UIUnivCourseActiveElementVO element) {
		this.element = element;
	}

}
