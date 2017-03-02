/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivGradeLevelVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File    : UIUnivGradeLevelVO.java
 * @Title   : 성적등급관리
 * @date    : 2014. 2. 20.
 * @author  : 장용기
 * @descrption :
 * 
 */
public class UIUnivGradeLevelVO extends UnivGradeLevelVO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/** 성적등급 카운트 */
	private Long gradeLevelCount;
	
	/** 평점 카운트 */
	private Long ratingScoreCount;
	
	/** 절대평가점수 카운트 */
	private Long evalAbsoluteScoreCount;
	
	/** 상대평가점수 카운트 */
	private Long evalRelativeScoreCount;
	
	/** 지난학기 */
	private String beforeYearTerm;
	
	/** 성적등급 수정변수 */
	private String [] yearTerms;
	
	/** 성적등급 수정변수 */
	private String [] gradeLevelCds;
	
	/** 평점 수정변수 */
	private Double [] ratingScores;

	/** 절대평가점수 수정변수 */
	private Double [] evalAbsoluteScores;

	/** 상대평가점수 수정변수 */
	private Double [] evelRelativeScores;

	public Long getGradeLevelCount() {
		return gradeLevelCount;
	}

	public void setGradeLevelCount(Long gradeLevelCount) {
		this.gradeLevelCount = gradeLevelCount;
	}

	public Long getRatingScoreCount() {
		return ratingScoreCount;
	}

	public void setRatingScoreCount(Long ratingScoreCount) {
		this.ratingScoreCount = ratingScoreCount;
	}

	public Long getEvalAbsoluteScoreCount() {
		return evalAbsoluteScoreCount;
	}

	public void setEvalAbsoluteScoreCount(Long evalAbsoluteScoreCount) {
		this.evalAbsoluteScoreCount = evalAbsoluteScoreCount;
	}

	public Long getEvalRelativeScoreCount() {
		return evalRelativeScoreCount;
	}

	public void setEvalRelativeScoreCount(Long evalRelativeScoreCount) {
		this.evalRelativeScoreCount = evalRelativeScoreCount;
	}

	public String getBeforeYearTerm() {
		return beforeYearTerm;
	}

	public void setBeforeYearTerm(String beforeYearTerm) {
		this.beforeYearTerm = beforeYearTerm;
	}

	public String[] getYearTerms() {
		return yearTerms;
	}

	public void setYearTerms(String[] yearTerms) {
		this.yearTerms = yearTerms;
	}

	public String[] getGradeLevelCds() {
		return gradeLevelCds;
	}

	public void setGradeLevelCds(String[] gradeLevelCds) {
		this.gradeLevelCds = gradeLevelCds;
	}

	public Double[] getRatingScores() {
		return ratingScores;
	}

	public void setRatingScores(Double[] ratingScores) {
		this.ratingScores = ratingScores;
	}

	public Double[] getEvalAbsoluteScores() {
		return evalAbsoluteScores;
	}

	public void setEvalAbsoluteScores(Double[] evalAbsoluteScores) {
		this.evalAbsoluteScores = evalAbsoluteScores;
	}

	public Double[] getEvelRelativeScores() {
		return evelRelativeScores;
	}

	public void setEvelRelativeScores(Double[] evelRelativeScores) {
		this.evelRelativeScores = evelRelativeScores;
	}

}
