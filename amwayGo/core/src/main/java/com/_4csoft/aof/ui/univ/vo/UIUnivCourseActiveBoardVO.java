/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.ui.board.vo.UIBoardVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseActiveBoardVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 1. 27.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveBoardVO extends UIBoardVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 개설과목 바로가기 파라미터 */
	private String shortcutYearTerm;

	/** 개설과목 바로가기 파라미터 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 파라미터 */
	private String shortcutCategoryTypeCd;
	
	/** 평가 대상 게시물 개수 */
	private Long evaluateYesCount;
	
	/** 평가 비 대상 게시물 개수 */
	private Long evaluateNoCount;

	public Long getEvaluateYesCount() {
		return evaluateYesCount;
	}

	public void setEvaluateYesCount(Long evaluateYesCount) {
		this.evaluateYesCount = evaluateYesCount;
	}

	public Long getEvaluateNoCount() {
		return evaluateNoCount;
	}

	public void setEvaluateNoCount(Long evaluateNoCount) {
		this.evaluateNoCount = evaluateNoCount;
	}

	public String getShortcutYearTerm() {
		return shortcutYearTerm;
	}

	public void setShortcutYearTerm(String shortcutYearTerm) {
		this.shortcutYearTerm = shortcutYearTerm;
	}

	public Long getShortcutCourseActiveSeq() {
		return shortcutCourseActiveSeq;
	}

	public void setShortcutCourseActiveSeq(Long shortcutCourseActiveSeq) {
		this.shortcutCourseActiveSeq = shortcutCourseActiveSeq;
	}

	public String getShortcutCategoryTypeCd() {
		return shortcutCategoryTypeCd;
	}

	public void setShortcutCategoryTypeCd(String shortcutCategoryTypeCd) {
		this.shortcutCategoryTypeCd = shortcutCategoryTypeCd;
	}

}
