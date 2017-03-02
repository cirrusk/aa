/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File    : UIUnivCourseActiveEvaluateRS.java
 * @Title   : 평가기준
 * @date    : 2014. 2. 26.
 * @author  : 장용기
 * @descrption :
 * 
 */
public class UIUnivCourseActiveEvaluateRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private UIUnivCourseActiveEvaluateVO evaluate;

	public UIUnivCourseActiveEvaluateVO getEvaluate() {
		return evaluate;
	}

	public void setEvaluate(UIUnivCourseActiveEvaluateVO evaluate) {
		this.evaluate = evaluate;
	}

}
