/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivWeekTemplateVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivWeekTemplateRS.java
 * @Title : 주차 템플릿
 * @date : 2014. 2. 20.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivWeekTemplateRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 주차템플릿 */
	private UIUnivWeekTemplateVO univWeekTemplate;

	public UIUnivWeekTemplateVO getUnivWeekTemplate() {
		return univWeekTemplate;
	}

	public void setUnivWeekTemplate(UIUnivWeekTemplateVO univWeekTemplate) {
		this.univWeekTemplate = univWeekTemplate;
	}

}
