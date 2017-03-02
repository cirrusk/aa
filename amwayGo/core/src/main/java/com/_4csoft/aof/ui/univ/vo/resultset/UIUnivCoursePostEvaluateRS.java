/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCoursePostEvaluateVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCoursePostEvaluateRS.java
 * @Title : 게시글 평가기준 결과
 * @date : 2014. 2. 25.
 * @author : 김영학
 * @descrption : 게시글 평가기준 결과 VO
 */
public class UIUnivCoursePostEvaluateRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UIUnivCoursePostEvaluateVO coursePostEvaluate;

	public UIUnivCoursePostEvaluateVO getCoursePostEvaluate() {
		return coursePostEvaluate;
	}

	public void setCoursePostEvaluate(UIUnivCoursePostEvaluateVO coursePostEvaluate) {
		this.coursePostEvaluate = coursePostEvaluate;
	}
	
}
