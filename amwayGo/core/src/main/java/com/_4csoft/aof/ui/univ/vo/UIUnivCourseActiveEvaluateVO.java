/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import com._4csoft.aof.univ.vo.UnivCourseActiveEvaluateVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseActiveEvaluateVO.java
 * @Title : 평가기준
 * @date : 2014. 2. 26.
 * @author : 장용기
 * @descrption :
 * 
 */
public class UIUnivCourseActiveEvaluateVO extends UnivCourseActiveEvaluateVO {
	private static final long serialVersionUID = 1L;

	/** 평가기준 일련번호 복수 */
	private Long[] evaluateSeqs;

	/** 평가구분 복수 */
	private String[] evaluateTypeCds;

	/** 평가점수 복수 */
	private Double[] scores;

	/** 과락점수 복수 */
	private Double[] limitScores;

	/** 바로가기 개설과목일련번호 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 파라미터 */
	private String shortcutCategoryTypeCd;
	
	/** 등록 수 */
	private Long basicCount;
	/** 보충 등록 수 */
	private Long supplementCount;
	
	public Long[] getEvaluateSeqs() {
		return evaluateSeqs;
	}

	/**
	 * 바로가기 값 복사(
	 */
	public void copyShortcut() {
		super.setCourseActiveSeq(this.getShortcutCourseActiveSeq());
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

	public void setEvaluateSeqs(Long[] evaluateSeqs) {
		this.evaluateSeqs = evaluateSeqs;
	}

	public String[] getEvaluateTypeCds() {
		return evaluateTypeCds;
	}

	public void setEvaluateTypeCds(String[] evaluateTypeCds) {
		this.evaluateTypeCds = evaluateTypeCds;
	}

	public Double[] getScores() {
		return scores;
	}

	public void setScores(Double[] scores) {
		this.scores = scores;
	}

	public Double[] getLimitScores() {
		return limitScores;
	}

	public void setLimitScores(Double[] limitScores) {
		this.limitScores = limitScores;
	}

	public Long getBasicCount() {
		return basicCount;
	}

	public void setBasicCount(Long basicCount) {
		this.basicCount = basicCount;
	}

	public Long getSupplementCount() {
		return supplementCount;
	}

	public void setSupplementCount(Long supplementCount) {
		this.supplementCount = supplementCount;
	}

}
