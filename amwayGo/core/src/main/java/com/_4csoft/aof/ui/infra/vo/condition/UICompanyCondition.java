/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo.condition
 * @File : UICompanyCondition.java
 * @Title : 소속
 * @date : 2013. 9. 2.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICompanyCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private String srchCompanyTypeCd;

	public String getSrchCompanyTypeCd() {
		return srchCompanyTypeCd;
	}

	public void setSrchCompanyTypeCd(String srchCompanyTypeCd) {
		this.srchCompanyTypeCd = srchCompanyTypeCd;
	}
	
}