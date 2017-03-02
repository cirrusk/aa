/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivGradeLevelVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File    : UIUnivGradeLevelRS.java
 * @Title   : 성적등급관리
 * @date    : 2014. 2. 20.
 * @author  : 장용기
 * @descrption :
 * 
 */
public class UIUnivGradeLevelRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/** 성적등급관리 */
	private UIUnivGradeLevelVO univGradeLevel;

	public UIUnivGradeLevelVO getUnivGradeLevel() {
		return univGradeLevel;
	}

	public void setUnivGradeLevel(UIUnivGradeLevelVO univGradeLevel) {
		this.univGradeLevel = univGradeLevel;
	}
	
}
