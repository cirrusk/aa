/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyElementVO;

/**
 * 
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseApplyElementRS.java
 * @Title : 수강생 수강요소 ResultSet
 * @date : 2014. 3. 24.
 * @author : 김현우
 * @descrption : 수강생 수강요소 ResultSet
 */
public class UIUnivCourseApplyElementRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 수강생 요소 */
	private UIUnivCourseApplyElementVO applyElement;
	
	/** 개설과목 요소 */
	private UIUnivCourseActiveElementVO activeElement;
	
	/** 회원 */
	private UIMemberVO member;

	public UIUnivCourseApplyElementVO getApplyElement() {
		return applyElement;
	}

	public void setApplyElement(UIUnivCourseApplyElementVO applyElement) {
		this.applyElement = applyElement;
	}

	public UIUnivCourseActiveElementVO getActiveElement() {
		return activeElement;
	}

	public void setActiveElement(UIUnivCourseActiveElementVO activeElement) {
		this.activeElement = activeElement;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}
	
}
