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
 * @File : UIUnivCourseExamPaperCondition.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 25.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseExamPaperCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 시험지 구분 검색 */
	private String srchExamPaperTypeCd;

	/** 사용 유무 */
	private String srchUseYn;

	/** 교과목 검색 */
	private Long srchCourseMasterSeq;

	/** 교과목 제목 검색 */
	private String srchCourseMasterTitle;

	/** 온오프라인 검색 */
	private String srchOnOffCd;

	/** 시험지 팝업에서 최초 호출인지 아닌지를 구분합니다. */
	private String popupFirstYn;

	/** 팝업 검색 시 사용 */
	private Long srchCourseActiveSeq;

	/** 팝업 검색 시 사용 */
	private Long srchProfSessionMemberSeq;

	/** 팝업 검색 시 사용 */
	private String srchProfMemberName;

	/** 팝업 검색 시 사용 */
	private String srchCourseTitle;

	/** 팝업 검색 시 사용 */
	private Long srchProfMemberSeq;

	/** 전체공개 검색 */
	private String srchOpenYn;

	/** 해당 조교를 지정한 교강사만 출력되게 하기위한 변수 */
	private Long srchAssistMemberSeq;

	public String getSrchExamPaperTypeCd() {
		return srchExamPaperTypeCd;
	}

	public void setSrchExamPaperTypeCd(String srchExamPaperTypeCd) {
		this.srchExamPaperTypeCd = srchExamPaperTypeCd;
	}

	public String getSrchUseYn() {
		return srchUseYn;
	}

	public void setSrchUseYn(String srchUseYn) {
		this.srchUseYn = srchUseYn;
	}

	public Long getSrchCourseMasterSeq() {
		return srchCourseMasterSeq;
	}

	public void setSrchCourseMasterSeq(Long srchCourseMasterSeq) {
		this.srchCourseMasterSeq = srchCourseMasterSeq;
	}

	public String getSrchCourseMasterTitle() {
		return srchCourseMasterTitle;
	}

	public void setSrchCourseMasterTitle(String srchCourseMasterTitle) {
		this.srchCourseMasterTitle = srchCourseMasterTitle;
	}

	public String getSrchOnOffCd() {
		return srchOnOffCd;
	}

	public void setSrchOnOffCd(String srchOnOffCd) {
		this.srchOnOffCd = srchOnOffCd;
	}

	public String getPopupFirstYn() {
		return popupFirstYn;
	}

	public void setPopupFirstYn(String popupFirstYn) {
		this.popupFirstYn = popupFirstYn;
	}

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public Long getSrchProfSessionMemberSeq() {
		return srchProfSessionMemberSeq;
	}

	public void setSrchProfSessionMemberSeq(Long srchProfSessionMemberSeq) {
		this.srchProfSessionMemberSeq = srchProfSessionMemberSeq;
	}

	public String getSrchProfMemberName() {
		return srchProfMemberName;
	}

	public void setSrchProfMemberName(String srchProfMemberName) {
		this.srchProfMemberName = srchProfMemberName;
	}

	public String getSrchCourseTitle() {
		return srchCourseTitle;
	}

	public void setSrchCourseTitle(String srchCourseTitle) {
		this.srchCourseTitle = srchCourseTitle;
	}

	public Long getSrchProfMemberSeq() {
		return srchProfMemberSeq;
	}

	public void setSrchProfMemberSeq(Long srchProfMemberSeq) {
		this.srchProfMemberSeq = srchProfMemberSeq;
	}

	public String getSrchOpenYn() {
		return srchOpenYn;
	}

	public void setSrchOpenYn(String srchOpenYn) {
		this.srchOpenYn = srchOpenYn;
	}

	public Long getSrchAssistMemberSeq() {
		return srchAssistMemberSeq;
	}

	public void setSrchAssistMemberSeq(Long srchAssistMemberSeq) {
		this.srchAssistMemberSeq = srchAssistMemberSeq;
	}

}
