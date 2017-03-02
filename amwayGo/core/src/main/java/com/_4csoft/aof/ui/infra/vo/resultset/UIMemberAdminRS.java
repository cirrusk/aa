/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UICompanyVO;
import com._4csoft.aof.ui.infra.vo.UIMemberAdminVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCategoryVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo.resultset
 * @File : UIMemberAdminRS.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMemberAdminRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UIMemberVO member;
	private UIMemberAdminVO admin;
	private UICompanyVO company;
	private UIUnivCategoryVO category;

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

	public UICompanyVO getCompany() {
		return company;
	}

	public void setCompany(UICompanyVO company) {
		this.company = company;
	}

	public UIUnivCategoryVO getCategory() {
		return category;
	}

	public void setCategory(UIUnivCategoryVO category) {
		this.category = category;
	}

}
