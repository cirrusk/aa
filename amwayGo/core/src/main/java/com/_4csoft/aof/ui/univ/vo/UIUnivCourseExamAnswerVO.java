/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseExamAnswerVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseExamAnswerVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 25.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseExamAnswerVO extends UnivCourseExamAnswerVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 응답처리용 변수 */
	private Long[] examAnswerSeqs;

	/** 첨부파일 응답용 변수 */
	private String[] attachUploadInfos;

	/** 첨부파일 응답용 변수 */
	private String[] attachDeleteInfos;

	/** 응답처리용 변수 */
	private String[] examItemTypeCds;

	/** 응답처리용 변수 */
	private String[] correctAnswers;

	/** 응답처리용 변수 */
	private String[] similarAnswers;

	/** 응답처리용 변수 */
	private String[] choiceAnswers;

	/** 응답처리용 변수 */
	private String[] shortAnswers;

	/** 응답처리용 변수 */
	private String[] essayAnswers;

	/** 응답처리용 변수 */
	private Double[] examItemScores;

	private Double[] takeScores;

	private String[] comments;

	public Long[] getExamAnswerSeqs() {
		return examAnswerSeqs;
	}

	public void setExamAnswerSeqs(Long[] examAnswerSeqs) {
		this.examAnswerSeqs = examAnswerSeqs;
	}

	public String[] getAttachUploadInfos() {
		return attachUploadInfos;
	}

	public void setAttachUploadInfos(String[] attachUploadInfos) {
		this.attachUploadInfos = attachUploadInfos;
	}

	public String[] getAttachDeleteInfos() {
		return attachDeleteInfos;
	}

	public void setAttachDeleteInfos(String[] attachDeleteInfos) {
		this.attachDeleteInfos = attachDeleteInfos;
	}

	public String[] getExamItemTypeCds() {
		return examItemTypeCds;
	}

	public void setExamItemTypeCds(String[] examItemTypeCds) {
		this.examItemTypeCds = examItemTypeCds;
	}

	public String[] getCorrectAnswers() {
		return correctAnswers;
	}

	public void setCorrectAnswers(String[] correctAnswers) {
		this.correctAnswers = correctAnswers;
	}

	public String[] getSimilarAnswers() {
		return similarAnswers;
	}

	public void setSimilarAnswers(String[] similarAnswers) {
		this.similarAnswers = similarAnswers;
	}

	public String[] getChoiceAnswers() {
		return choiceAnswers;
	}

	public void setChoiceAnswers(String[] choiceAnswers) {
		this.choiceAnswers = choiceAnswers;
	}

	public String[] getShortAnswers() {
		return shortAnswers;
	}

	public void setShortAnswers(String[] shortAnswers) {
		this.shortAnswers = shortAnswers;
	}

	public String[] getEssayAnswers() {
		return essayAnswers;
	}

	public void setEssayAnswers(String[] essayAnswers) {
		this.essayAnswers = essayAnswers;
	}

	public Double[] getExamItemScores() {
		return examItemScores;
	}

	public void setExamItemScores(Double[] examItemScores) {
		this.examItemScores = examItemScores;
	}

	public Double[] getTakeScores() {
		return takeScores;
	}

	public void setTakeScores(Double[] takeScores) {
		this.takeScores = takeScores;
	}

	public String[] getComments() {
		return comments;
	}

	public void setComments(String[] comments) {
		this.comments = comments;
	}

}
