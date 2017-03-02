/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActivePlanVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseActivePlanRS.java
 * @Title : 강의계획서 ResultSet
 * @date : 2014. 2. 28.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActivePlanRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 강의계획서 vo */
	private UIUnivCourseActivePlanVO courseActivePlan;

	public UIUnivCourseActivePlanVO getCourseActivePlan() {
		return courseActivePlan;
	}

	public void setCourseActivePlan(UIUnivCourseActivePlanVO courseActivePlan) {
		this.courseActivePlan = courseActivePlan;
	}

}
