/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UICompanyVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo.resultset
 * @File : UICompanyRS.java
 * @Title : 소속
 * @date : 2013. 9. 2.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICompanyRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UICompanyVO company;

	public UICompanyVO getCompany() {
		return company;
	}

	public void setCompany(UICompanyVO company) {
		this.company = company;
	}

}
