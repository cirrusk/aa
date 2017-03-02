/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UICompanyVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.UIMenuVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupMemberVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupMenuVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo.resultset
 * @File : UIRolegroupRS.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIRolegroupRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UIRolegroupVO rolegroup;
	private UIRolegroupMenuVO rolegroupMenu;
	private UIRolegroupMemberVO rolegroupMember;
	private UIMenuVO menu;
	private UIMemberVO member;
	private UICompanyVO company;

	public UIRolegroupVO getRolegroup() {
		return rolegroup;
	}

	public void setRolegroup(UIRolegroupVO rolegroup) {
		this.rolegroup = rolegroup;
	}

	public UIRolegroupMenuVO getRolegroupMenu() {
		return rolegroupMenu;
	}

	public void setRolegroupMenu(UIRolegroupMenuVO rolegroupMenu) {
		this.rolegroupMenu = rolegroupMenu;
	}

	public UIRolegroupMemberVO getRolegroupMember() {
		return rolegroupMember;
	}

	public void setRolegroupMember(UIRolegroupMemberVO rolegroupMember) {
		this.rolegroupMember = rolegroupMember;
	}

	public UIMenuVO getMenu() {
		return menu;
	}

	public void setMenu(UIMenuVO menu) {
		this.menu = menu;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

	public UICompanyVO getCompany() {
		return company;
	}

	public void setCompany(UICompanyVO company) {
		this.company = company;
	}

}
