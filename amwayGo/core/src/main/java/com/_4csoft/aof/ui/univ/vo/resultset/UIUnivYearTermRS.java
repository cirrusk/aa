/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivYearTermVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivYearTermRS.java
 * @Title : 년도학기
 * @date : 2014. 2. 18.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivYearTermRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 년도학기 */
	private UIUnivYearTermVO univYearTerm;

	public UIUnivYearTermVO getUnivYearTerm() {
		return univYearTerm;
	}

	public void setUnivYearTerm(UIUnivYearTermVO univYearTerm) {
		this.univYearTerm = univYearTerm;
	}
}
