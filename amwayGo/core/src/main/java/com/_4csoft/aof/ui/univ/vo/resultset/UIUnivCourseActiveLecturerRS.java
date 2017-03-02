/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberAdminVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCategoryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveLecturerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyElementVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseActiveLecturerRS.java
 * @Title : 개설과목 교강사 ResultSet
 * @date : 2014. 2. 26.
 * @author : 김현우
 * @descrption : 개설과목 교강사 ResultSet
 */
public class UIUnivCourseActiveLecturerRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 개설과목 교강사 */
	private UIUnivCourseActiveLecturerVO univCourseActiveLecturer;

	/** 멤버 */
	private UIMemberVO member;

	/** 멤버 어드민 */
	private UIMemberAdminVO admin;
	
	/** 개설과목 구성정보*/
	private UIUnivCourseActiveElementVO element;
	
	/** 개설과목 */
	private UIUnivCourseActiveVO active;
	
	/** 카테고리 */
	private UIUnivCategoryVO category;
	
	/** 수강요소 */
	private UIUnivCourseApplyElementVO applyElement;
	
	public UIUnivCourseActiveLecturerVO getUnivCourseActiveLecturer() {
		return univCourseActiveLecturer;
	}

	public void setUnivCourseActiveLecturer(UIUnivCourseActiveLecturerVO univCourseActiveLecturer) {
		this.univCourseActiveLecturer = univCourseActiveLecturer;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

	public UIMemberAdminVO getAdmin() {
		return admin;
	}

	public void setAdmin(UIMemberAdminVO admin) {
		this.admin = admin;
	}

	public UIUnivCourseActiveElementVO getElement() {
		return element;
	}

	public void setElement(UIUnivCourseActiveElementVO element) {
		this.element = element;
	}

	public UIUnivCourseActiveVO getActive() {
		return active;
	}

	public void setActive(UIUnivCourseActiveVO active) {
		this.active = active;
	}

	public UIUnivCategoryVO getCategory() {
		return category;
	}

	public void setCategory(UIUnivCategoryVO category) {
		this.category = category;
	}

	public UIUnivCourseApplyElementVO getApplyElement() {
		return applyElement;
	}

	public void setApplyElement(UIUnivCourseApplyElementVO applyElement) {
		this.applyElement = applyElement;
	}

}
