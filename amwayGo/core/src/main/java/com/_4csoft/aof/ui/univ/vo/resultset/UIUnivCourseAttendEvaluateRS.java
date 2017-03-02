/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UICodeVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseAttendEvaluateVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseAttendEvaluateRS.java
 * @Title : 출석 평가기준 ResultSet
 * @date : 2014. 3. 3.
 * @author : 김현우
 * @descrption : 출석 평가기준 ResultSet
 */
public class UIUnivCourseAttendEvaluateRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 출석 평가기준 vo */
	private UIUnivCourseAttendEvaluateVO attendEvaluate;

	private UICodeVO code;

	public UIUnivCourseAttendEvaluateVO getAttendEvaluate() {
		return attendEvaluate;
	}

	public void setAttendEvaluate(UIUnivCourseAttendEvaluateVO attendEvaluate) {
		this.attendEvaluate = attendEvaluate;
	}

	public UICodeVO getCode() {
		return code;
	}

	public void setCode(UICodeVO code) {
		this.code = code;
	}

}
