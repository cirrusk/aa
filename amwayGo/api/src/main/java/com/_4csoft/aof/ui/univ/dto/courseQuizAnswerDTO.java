package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : courseQuizAnswerDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 6. 22.
 * @author : 조경재
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class courseQuizAnswerDTO implements Serializable {

	private static final long serialVersionUID = 1L;

	private Long examItemSeq;

	private String examItemTitle;

	private String examItemTypeCd;

	private Long courseActiveProfSeq;

	private String memberName;

	private Long courseActiveSeq;

	private String quizDtime;

	private String classificationCode;

	public Long getExamItemSeq() {
		return examItemSeq;
	}

	public void setExamItemSeq(Long examItemSeq) {
		this.examItemSeq = examItemSeq;
	}

	public String getExamItemTitle() {
		return examItemTitle;
	}

	public void setExamItemTitle(String examItemTitle) {
		this.examItemTitle = examItemTitle;
	}

	public String getExamItemTypeCd() {
		return examItemTypeCd;
	}

	public void setExamItemTypeCd(String examItemTypeCd) {
		this.examItemTypeCd = examItemTypeCd;
	}

	public Long getCourseActiveProfSeq() {
		return courseActiveProfSeq;
	}

	public void setCourseActiveProfSeq(Long courseActiveProfSeq) {
		this.courseActiveProfSeq = courseActiveProfSeq;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}

	public String getClassificationCode() {
		return classificationCode;
	}

	public void setClassificationCode(String classificationCode) {
		this.classificationCode = classificationCode;
	}

	public String getQuizDtime() {
		return quizDtime;
	}

	public void setQuizDtime(String quizDtime) {
		this.quizDtime = quizDtime;
	}

}
