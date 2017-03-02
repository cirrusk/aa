/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCoursePostEvaluateVO;
/**
 * 
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCoursePostEvaluateVO.java
 * @Title : 게시글 평가기준
 * @date : 2014. 2. 26.
 * @author : 김영학
 * @descrption : 대학 게시글 평가기준 VO
 */
public class UIUnivCoursePostEvaluateVO extends UnivCoursePostEvaluateVO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	/** 게시글 평가기준 일련번호 Array */
	private Long[] postEvaluateSeqs;

	/** 게시글 평가기준 갯수 Array */
	private Long[] fromCounts;
	
	/** 게시글 평가기준 갯수 Array */
	private Long[] toCounts;
	
	/** 게시글 평가기준 점수 Array */
	private Double[] scores;
	
	/** 게시글 평가기준 상중하 Array*/
	private Long[] sortOrders;

	/** 바로가기 개설과목일련번호 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류그룹 일련번호 */
	private Long shortcutCategoryGroupSeq;
	
	/**
	 * 바로가기 값 복사(
	 */
	public void copyShortcut() {
		super.setCourseActiveSeq(this.getShortcutCourseActiveSeq());
	}
	
	public Long[] getPostEvaluateSeqs() {
		return postEvaluateSeqs;
	}

	public void setPostEvaluateSeqs(Long[] postEvaluateSeqs) {
		this.postEvaluateSeqs = postEvaluateSeqs;
	}

	public Long[] getFromCounts() {
		return fromCounts;
	}

	public void setFromCounts(Long[] fromCounts) {
		this.fromCounts = fromCounts;
	}

	public Long[] getToCounts() {
		return toCounts;
	}

	public void setToCounts(Long[] toCounts) {
		this.toCounts = toCounts;
	}

	public Double[] getScores() {
		return scores;
	}

	public void setScores(Double[] scores) {
		this.scores = scores;
	}

	public Long[] getSortOrders() {
		return sortOrders;
	}

	public void setSortOrders(Long[] sortOrders) {
		this.sortOrders = sortOrders;
	}

	public Long getShortcutCourseActiveSeq() {
		return shortcutCourseActiveSeq;
	}

	public void setShortcutCourseActiveSeq(Long shortcutCourseActiveSeq) {
		this.shortcutCourseActiveSeq = shortcutCourseActiveSeq;
	}

	public Long getShortcutCategoryGroupSeq() {
		return shortcutCategoryGroupSeq;
	}

	public void setShortcutCategoryGroupSeq(Long shortcutCategoryGroupSeq) {
		this.shortcutCategoryGroupSeq = shortcutCategoryGroupSeq;
	}
	
}
