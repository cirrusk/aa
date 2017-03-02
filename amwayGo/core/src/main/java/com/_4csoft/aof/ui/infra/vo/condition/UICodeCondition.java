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
 * @Package : com._4csoft.aof.ui.infra.vo.search
 * @File : UICodeCondition.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICodeCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;
	private String srchCodeGroup;
	private String srchCode;

	public String getSrchCodeGroup() {
		return srchCodeGroup;
	}

	public void setSrchCodeGroup(String srchCodeGroup) {
		this.srchCodeGroup = srchCodeGroup;
	}

	public String getSrchCode() {
		return srchCode;
	}

	public void setSrchCode(String srchCode) {
		this.srchCode = srchCode;
	}
}
