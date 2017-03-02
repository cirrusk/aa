/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamItemVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseExamAnswerRS.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 25.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseExamAnswerRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UIUnivCourseExamAnswerVO courseExamAnswer;

	private UIUnivCourseExamItemVO courseExamItem;

	private UIUnivCourseExamVO courseExam;

	private List<UIUnivCourseExamExampleRS> listCourseExamExample;

	public UIUnivCourseExamAnswerVO getCourseExamAnswer() {
		return courseExamAnswer;
	}

	public void setCourseExamAnswer(UIUnivCourseExamAnswerVO courseExamAnswer) {
		this.courseExamAnswer = courseExamAnswer;
	}

	public UIUnivCourseExamItemVO getCourseExamItem() {
		return courseExamItem;
	}

	public void setCourseExamItem(UIUnivCourseExamItemVO courseExamItem) {
		this.courseExamItem = courseExamItem;
	}

	public UIUnivCourseExamVO getCourseExam() {
		return courseExam;
	}

	public void setCourseExam(UIUnivCourseExamVO courseExam) {
		this.courseExam = courseExam;
	}

	public List<UIUnivCourseExamExampleRS> getListCourseExamExample() {
		return listCourseExamExample;
	}

	public void setListCourseExamExample(List<UIUnivCourseExamExampleRS> listCourseExamExample) {
		this.listCourseExamExample = listCourseExamExample;
	}

}
