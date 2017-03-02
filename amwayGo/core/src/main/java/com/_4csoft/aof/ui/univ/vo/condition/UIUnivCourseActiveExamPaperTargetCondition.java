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
 * @File : UIUnivCourseActiveExamPaperTargetCondition.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 6.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveExamPaperTargetCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 검색 보충과제 부모 키 */
	private Long referenceSeq;

	/** 검색 보충과제 부모 타입(시험인지 과제인지) */
	private String referenceType;

	/** 검색 개설과목 키 */
	private Long courseActiveSeq;

	/** 검색 시험 키 */
	private Long courseActiveExamPaperSeq;

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

	/** 시험결과용 변수 */
	private Long srchReferenceSeq;

	/** 시험결과용 변수 */
	private String srchReferenceTypeCd;

	/** 시험결과용 변수 */
	private String srchCourseWeekTypeCd;

	/** 시험결과용 변수 */
	private Long srchCourseActiveSeq;

	/** 시험결과용 변수 */
	private String srchMemberStatusCd;

	/** 시험결과용 변수 */
	private String srchApplyStatusCd;

	/** 시험결과용 변수 */
	private String srchMemberName;

	/** 시험결과용 변수 */
	private String srchMemberId;

	/** 시험결과용 변수 */
	private String srchBasicSupplementCd;

	/** 시험결과 검색용 변수 */
	private String srchCategoryName;

	/**
	 * 바로가기 값 복사(
	 */
	public void copyShortcut() {
		this.setCourseActiveSeq(this.getShortcutCourseActiveSeq());
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

	public Long getCourseActiveExamPaperSeq() {
		return courseActiveExamPaperSeq;
	}

	public void setCourseActiveExamPaperSeq(Long courseActiveExamPaperSeq) {
		this.courseActiveExamPaperSeq = courseActiveExamPaperSeq;
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

	public Long getSrchReferenceSeq() {
		return srchReferenceSeq;
	}

	public void setSrchReferenceSeq(Long srchReferenceSeq) {
		this.srchReferenceSeq = srchReferenceSeq;
	}

	public String getSrchReferenceTypeCd() {
		return srchReferenceTypeCd;
	}

	public void setSrchReferenceTypeCd(String srchReferenceTypeCd) {
		this.srchReferenceTypeCd = srchReferenceTypeCd;
	}

	public String getSrchCourseWeekTypeCd() {
		return srchCourseWeekTypeCd;
	}

	public void setSrchCourseWeekTypeCd(String srchCourseWeekTypeCd) {
		this.srchCourseWeekTypeCd = srchCourseWeekTypeCd;
	}

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public String getSrchMemberStatusCd() {
		return srchMemberStatusCd;
	}

	public void setSrchMemberStatusCd(String srchMemberStatusCd) {
		this.srchMemberStatusCd = srchMemberStatusCd;
	}

	public String getSrchApplyStatusCd() {
		return srchApplyStatusCd;
	}

	public void setSrchApplyStatusCd(String srchApplyStatusCd) {
		this.srchApplyStatusCd = srchApplyStatusCd;
	}

	public String getSrchMemberId() {
		return srchMemberId;
	}

	public void setSrchMemberId(String srchMemberId) {
		this.srchMemberId = srchMemberId;
	}

	public String getSrchMemberName() {
		return srchMemberName;
	}

	public void setSrchMemberName(String srchMemberName) {
		this.srchMemberName = srchMemberName;
	}

	public String getSrchBasicSupplementCd() {
		return srchBasicSupplementCd;
	}

	public void setSrchBasicSupplementCd(String srchBasicSupplementCd) {
		this.srchBasicSupplementCd = srchBasicSupplementCd;
	}

	public String getSrchCategoryName() {
		return srchCategoryName;
	}

	public void setSrchCategoryName(String srchCategoryName) {
		this.srchCategoryName = srchCategoryName;
	}

	public String getSrchCategoryNameDB() {
		return srchCategoryName.replaceAll("%", "\\\\%");
	}

}
