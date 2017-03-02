/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.condition
 * @File : UIUnivCourseHomeworkCondition.java
 * @Title : 과제 검색 condition
 * @date : 2014. 2. 20.
 * @author : 김현우
 * @descrption : 과제 검색 condition
 */
public class UIUnivCourseHomeworkCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 검색 보충과제 부모 키 */
	private Long referenceSeq;

	/** 검색 보충과제 부모 타입(시험인지 과제인지) */
	private String referenceType;

	/** 검색 개설과목 키 */
	private Long courseActiveSeq;

	/** 검색 과제 키 */
	private Long homeworkSeq;

	/** 검색 점수 */
	private Long limitScore;

	/** 대상자 보기 팝업시 수정이 가능한 상태인지 구분해 준다. */
	private String editYn;

	/** 비 대상자 목록 점수 검색 필드 */
	private Long srchLimitScore;

	/** 대상자 보기 팝업 비대상자 목록 검색 필드 */
	private String srchNonTargetKey;

	/** 대상자 보기 팝업 대상자 목록 검색 필드 */
	private String srchTargetKey;

	/** 대상자 보기 팝업 비대상자 목록 검색 키워드 */
	private String srchNonTargetWord;

	/** 대상자 보기 팝업 대상자 목록 검색 키워드 */
	private String srchTargetWord;

	/** 대상자 보기 팝업 비 대상자 목록 오더바이 값 */
	private Long orderbyTarget;

	/** 대상자 보기 팝업 대상자 목록 오더바이 값 */
	private Long orderbyNonTarget;

	/** 바로가기 개설과목일련번호 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 */
	private String shortcutCategoryTypeCd;
	
	/** 과제 일반 보충 구분 */
	private String srchBasicSupplementCd;
	
	/** 과제결과 학부 검색 필드 */
	private String srchCategoryString;
	
	/** 과제결과 학과 검색 필드 */
	private String srchCategoryName;

	/**
	 * 바로가기 값 복사(
	 */
	public void copyShortcut() {
		this.setCourseActiveSeq(this.getShortcutCourseActiveSeq());
	}

	public String getSrchCategoryString() {
		return srchCategoryString;
	}
	
	public String getSrchCategoryStringDB() {
		return srchCategoryString.replaceAll("%", "\\\\%");
	}

	public void setSrchCategoryString(String srchCategoryString) {
		this.srchCategoryString = srchCategoryString;
	}

	public String getSrchCategoryName() {
		return srchCategoryName;
	}
	
	public String getSrchCategoryNameDB() {
		return srchCategoryName.replaceAll("%", "\\\\%");
	}

	public void setSrchCategoryName(String srchCategoryName) {
		this.srchCategoryName = srchCategoryName;
	}

	public String getSrchBasicSupplementCd() {
		return srchBasicSupplementCd;
	}

	public void setSrchBasicSupplementCd(String srchBasicSupplementCd) {
		this.srchBasicSupplementCd = srchBasicSupplementCd;
	}

	public Long getReferenceSeq() {
		return referenceSeq;
	}

	public void setReferenceSeq(Long referenceSeq) {
		this.referenceSeq = referenceSeq;
	}

	public String getReferenceType() {
		return referenceType;
	}

	public void setReferenceType(String referenceType) {
		this.referenceType = referenceType;
	}

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}

	public Long getHomeworkSeq() {
		return homeworkSeq;
	}

	public void setHomeworkSeq(Long homeworkSeq) {
		this.homeworkSeq = homeworkSeq;
	}

	public Long getLimitScore() {
		return limitScore;
	}

	public void setLimitScore(Long limitScore) {
		this.limitScore = limitScore;
	}

	public String getEditYn() {
		return editYn;
	}

	public void setEditYn(String editYn) {
		this.editYn = editYn;
	}

	public Long getSrchLimitScore() {
		return srchLimitScore;
	}

	public void setSrchLimitScore(Long srchLimitScore) {
		this.srchLimitScore = srchLimitScore;
	}

	public String getSrchNonTargetKey() {
		return srchNonTargetKey;
	}

	public void setSrchNonTargetKey(String srchNonTargetKey) {
		this.srchNonTargetKey = srchNonTargetKey;
	}

	public String getSrchTargetKey() {
		return srchTargetKey;
	}

	public void setSrchTargetKey(String srchTargetKey) {
		this.srchTargetKey = srchTargetKey;
	}

	public String getSrchNonTargetWord() {
		return srchNonTargetWord;
	}

	public void setSrchNonTargetWord(String srchNonTargetWord) {
		this.srchNonTargetWord = srchNonTargetWord;
	}

	public String getSrchTargetWord() {
		return srchTargetWord;
	}

	public void setSrchTargetWord(String srchTargetWord) {
		this.srchTargetWord = srchTargetWord;
	}

	public Long getOrderbyTarget() {
		return orderbyTarget;
	}

	public void setOrderbyTarget(Long orderbyTarget) {
		this.orderbyTarget = orderbyTarget;
	}

	public Long getOrderbyNonTarget() {
		return orderbyNonTarget;
	}

	public void setOrderbyNonTarget(Long orderbyNonTarget) {
		this.orderbyNonTarget = orderbyNonTarget;
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

	public String getSrchTargetWordDB() {
		return srchTargetWord.replaceAll("%", "\\\\%");
	}

	public String getSrchNonTargetWordDB() {
		return srchNonTargetWord.replaceAll("%", "\\\\%");
	}
}
