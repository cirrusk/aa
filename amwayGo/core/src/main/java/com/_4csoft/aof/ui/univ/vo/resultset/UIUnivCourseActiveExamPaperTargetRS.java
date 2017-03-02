/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UICategoryVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperTargetVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamPaperVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseActiveExamPaperTargetRS.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 6.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveExamPaperTargetRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UIUnivCourseActiveExamPaperTargetVO courseActiveExamPaperTarget;

	private UIMemberVO member;

	private UICategoryVO category;

	private UIUnivCourseApplyElementVO courseApplyElement;

	private UIUnivCourseExamPaperVO courseExamPaper;

	public UIUnivCourseActiveExamPaperTargetVO getCourseActiveExamPaperTarget() {
		return courseActiveExamPaperTarget;
	}

	public void setCourseActiveExamPaperTarget(UIUnivCourseActiveExamPaperTargetVO courseActiveExamPaperTarget) {
		this.courseActiveExamPaperTarget = courseActiveExamPaperTarget;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

	public UICategoryVO getCategory() {
		return category;
	}

	public void setCategory(UICategoryVO category) {
		this.category = category;
	}

	public UIUnivCourseApplyElementVO getCourseApplyElement() {
		return courseApplyElement;
	}

	public void setCourseApplyElement(UIUnivCourseApplyElementVO courseApplyElement) {
		this.courseApplyElement = courseApplyElement;
	}

	public UIUnivCourseExamPaperVO getCourseExamPaper() {
		return courseExamPaper;
	}

	public void setCourseExamPaper(UIUnivCourseExamPaperVO courseExamPaper) {
		this.courseExamPaper = courseExamPaper;
	}

}
