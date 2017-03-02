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
 * @File : UILoginCondition.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILoginHistoryCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;
	private String srchStartRegDate;
	private String srchEndRegDate;
	private String srchStatisticsType;
	private String srchYn;

	public String getSrchStartRegDate() {
		return srchStartRegDate;
	}

	public void setSrchStartRegDate(String srchStartRegDate) {
		this.srchStartRegDate = srchStartRegDate;
	}

	public String getSrchEndRegDate() {
		return srchEndRegDate;
	}

	public void setSrchEndRegDate(String srchEndRegDate) {
		this.srchEndRegDate = srchEndRegDate;
	}

	public String getSrchStatisticsType() {
		return srchStatisticsType;
	}

	public void setSrchStatisticsType(String srchStatisticsType) {
		this.srchStatisticsType = srchStatisticsType;
	}

	public String getSrchYn() {
		return srchYn;
	}

	public void setSrchYn(String srchYn) {
		this.srchYn = srchYn;
	}

}
