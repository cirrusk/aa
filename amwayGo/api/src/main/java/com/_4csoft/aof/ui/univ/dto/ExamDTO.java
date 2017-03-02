/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

/**
 * @Project : lgaca-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : ExamDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 28.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class ExamDTO extends ExamListDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/** 문제저장시 사용할 변수 examItemVO */
	private String examItemAlignCd;
	private String examItemAlign;

	/** 문제저장시 사용할 변수 examItemVO */
	private String correctAnswer;

	/** 문제저장시 사용할 변수 examItemVO */
	private String similarAnswer;

	/** 문제저장시 사용할 변수 examItemVO */
	private String examItemFileTypeCd;

	/** 문제저장시 사용할 변수 examItemVO */
	private String examItemFilePath;

	/** 문제저장시 사용할 변수 examItemVO */
	private String examItemFilePathType;

	/** 문제저장시 사용할 변수 examItemVO */
	private Long examItemSortOrder;

	/** 문제저장시 사용할 변수 examItemVO */
	private Double examItemScore;

	/** 문제저장시 사용할 변수 examItemVO */
	private Long examItemExampleCount;

	/** 문제저장시 사용할 변수 examItemVO */
	private String examItemDescription;

	/** 문제저장시 사용할 변수 examItemVO */
	private String examItemComment;

	public String getExamItemAlignCd() {
		return examItemAlignCd;
	}

	public void setExamItemAlignCd(String examItemAlignCd) {
		this.examItemAlignCd = examItemAlignCd;
	}

	public String getCorrectAnswer() {
		return correctAnswer;
	}

	public void setCorrectAnswer(String correctAnswer) {
		this.correctAnswer = correctAnswer;
	}

	public String getSimilarAnswer() {
		return similarAnswer;
	}

	public void setSimilarAnswer(String similarAnswer) {
		this.similarAnswer = similarAnswer;
	}

	public String getExamItemFileTypeCd() {
		return examItemFileTypeCd;
	}

	public void setExamItemFileTypeCd(String examItemFileTypeCd) {
		this.examItemFileTypeCd = examItemFileTypeCd;
	}

	public String getExamItemFilePath() {
		return examItemFilePath;
	}

	public void setExamItemFilePath(String examItemFilePath) {
		this.examItemFilePath = examItemFilePath;
	}

	public String getExamItemFilePathType() {
		return examItemFilePathType;
	}

	public void setExamItemFilePathType(String examItemFilePathType) {
		this.examItemFilePathType = examItemFilePathType;
	}

	public Long getExamItemSortOrder() {
		return examItemSortOrder;
	}

	public void setExamItemSortOrder(Long examItemSortOrder) {
		this.examItemSortOrder = examItemSortOrder;
	}

	public Double getExamItemScore() {
		return examItemScore;
	}

	public void setExamItemScore(Double examItemScore) {
		this.examItemScore = examItemScore;
	}

	public Long getExamItemExampleCount() {
		return examItemExampleCount;
	}

	public void setExamItemExampleCount(Long examItemExampleCount) {
		this.examItemExampleCount = examItemExampleCount;
	}

	public String getExamItemDescription() {
		return examItemDescription;
	}

	public void setExamItemDescription(String examItemDescription) {
		this.examItemDescription = examItemDescription;
	}

	public String getExamItemComment() {
		return examItemComment;
	}

	public void setExamItemComment(String examItemComment) {
		this.examItemComment = examItemComment;
	}

	public String getExamItemAlign() {
		return examItemAlign;
	}

	public void setExamItemAlign(String examItemAlign) {
		this.examItemAlign = examItemAlign;
	}

}
