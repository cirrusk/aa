/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.BaseVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseQuizAnswer.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 10.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseQuizAnswerVO extends BaseVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/** */
	private Long courseQuizAnswerSeq;
	/** */
	private Long courseActiveSeq;
	/** */
	private Long memberSeq;
	/** */
	private Long courseApplySeq;
	/** */
	private String quizDtime;
	/** */
	private Long courseActiveProfSeq;
	/** */
	private Long examItemSeq;
	/** */
	private Long examExampleSeq;
	/** */
	private String shortAnswer;
	/** */
	private Long answerCount;
	/** */
	private Long memberCount;

	private String classificationCode;

	public Long getAnswerCount() {
		return answerCount;
	}

	public void setAnswerCount(Long answerCount) {
		this.answerCount = answerCount;
	}

	public Long getCourseQuizAnswerSeq() {
		return courseQuizAnswerSeq;
	}

	public void setCourseQuizAnswerSeq(Long courseQuizAnswerSeq) {
		this.courseQuizAnswerSeq = courseQuizAnswerSeq;
	}

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}

	public Long getMemberSeq() {
		return memberSeq;
	}

	public void setMemberSeq(Long memberSeq) {
		this.memberSeq = memberSeq;
	}

	public Long getCourseApplySeq() {
		return courseApplySeq;
	}

	public void setCourseApplySeq(Long courseApplySeq) {
		this.courseApplySeq = courseApplySeq;
	}

	public String getQuizDtime() {
		return quizDtime;
	}

	public void setQuizDtime(String quizDtime) {
		this.quizDtime = quizDtime;
	}

	public Long getCourseActiveProfSeq() {
		return courseActiveProfSeq;
	}

	public void setCourseActiveProfSeq(Long courseActiveProfSeq) {
		this.courseActiveProfSeq = courseActiveProfSeq;
	}

	public Long getExamItemSeq() {
		return examItemSeq;
	}

	public void setExamItemSeq(Long examItemSeq) {
		this.examItemSeq = examItemSeq;
	}

	public Long getExamExampleSeq() {
		return examExampleSeq;
	}

	public void setExamExampleSeq(Long examExampleSeq) {
		this.examExampleSeq = examExampleSeq;
	}

	public String getShortAnswer() {
		return shortAnswer;
	}

	public void setShortAnswer(String shortAnswer) {
		this.shortAnswer = shortAnswer;
	}

	public Long getMemberCount() {
		return memberCount;
	}

	public void setMemberCount(Long memberCount) {
		this.memberCount = memberCount;
	}

	public String getClassificationCode() {
		return classificationCode;
	}

	public void setClassificationCode(String classificationCode) {
		this.classificationCode = classificationCode;
	}

}
