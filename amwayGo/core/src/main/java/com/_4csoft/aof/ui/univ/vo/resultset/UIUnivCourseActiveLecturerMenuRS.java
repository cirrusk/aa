/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMenuVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupMenuVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveLecturerMenuVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseActiveLecturerMenuRS.java
 * @Title : 개설과목 교강사 메뉴 ResultSet
 * @date : 2014. 2. 26.
 * @author : 김현우
 * @descrption : 개설과목 교강사 메뉴 ResultSet
 */
public class UIUnivCourseActiveLecturerMenuRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 개설과목 교강사 메뉴 */
	private UIUnivCourseActiveLecturerMenuVO univCourseActiveLecturerMenu;

	/** 메뉴 */
	private UIMenuVO menu;

	/** 롤그룹 메뉴 */
	private UIRolegroupMenuVO rolegroupMenu;

	public UIUnivCourseActiveLecturerMenuVO getUnivCourseActiveLecturerMenu() {
		return univCourseActiveLecturerMenu;
	}

	public void setUnivCourseActiveLecturerMenu(UIUnivCourseActiveLecturerMenuVO univCourseActiveLecturerMenu) {
		this.univCourseActiveLecturerMenu = univCourseActiveLecturerMenu;
	}

	public UIMenuVO getMenu() {
		return menu;
	}

	public void setMenu(UIMenuVO menu) {
		this.menu = menu;
	}

	public UIRolegroupMenuVO getRolegroupMenu() {
		return rolegroupMenu;
	}

	public void setRolegroupMenu(UIRolegroupMenuVO rolegroupMenu) {
		this.rolegroupMenu = rolegroupMenu;
	}

}
