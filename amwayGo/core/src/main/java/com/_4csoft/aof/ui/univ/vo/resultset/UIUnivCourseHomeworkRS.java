/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCategoryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSummaryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseHomeworkRS.java
 * @Title : 과제 ResultSet
 * @date : 2014. 3. 3.
 * @author : 김현우
 * @descrption : 과제 ResultSet
 */
public class UIUnivCourseHomeworkRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 과제 vo */
	private UIUnivCourseHomeworkVO courseHomework;

	/** 카운트 vo */
	private UIUnivCourseActiveSummaryVO summary;
	
	/** 과제 결과 vo */
	private UIUnivCourseHomeworkAnswerVO answer;
	
	/** 과제 대상 vo */
	private UIUnivCourseApplyVO apply;
	
	/** 과제 대상 학과 정보 vo */
	private UIUnivCategoryVO category;
	
	/** 과제 대상 정보 vo */
	private  UIMemberVO member;

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

	public UIUnivCourseApplyVO getApply() {
		return apply;
	}

	public void setApply(UIUnivCourseApplyVO apply) {
		this.apply = apply;
	}

	public UIUnivCategoryVO getCategory() {
		return category;
	}

	public void setCategory(UIUnivCategoryVO category) {
		this.category = category;
	}

	public UIUnivCourseHomeworkAnswerVO getAnswer() {
		return answer;
	}

	public void setAnswer(UIUnivCourseHomeworkAnswerVO answer) {
		this.answer = answer;
	}

	public UIUnivCourseHomeworkVO getCourseHomework() {
		return courseHomework;
	}

	public void setCourseHomework(UIUnivCourseHomeworkVO courseHomework) {
		this.courseHomework = courseHomework;
	}

	public UIUnivCourseActiveSummaryVO getSummary() {
		return summary;
	}

	public void setSummary(UIUnivCourseActiveSummaryVO summary) {
		this.summary = summary;
	}

}
