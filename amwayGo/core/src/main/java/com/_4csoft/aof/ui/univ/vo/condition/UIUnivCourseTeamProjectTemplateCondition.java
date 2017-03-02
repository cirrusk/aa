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
 * @File : UIUnivCourseTeamProjectTemplateCondition.java
 * @Title : 토론 템플릿 검색 condition
 * @date : 2014. 2. 20.
 * @author : 김현우
 * @descrption : 토론 템플릿 검색 condition
 */
public class UIUnivCourseTeamProjectTemplateCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 검색 사용여부 */
	private String srchUseYn;

	/** 검색 교강사이름 */
	private String srchProfMemberName;

	/** 검색 교강사 멤버키 */
	private Long srchProfMemberSeq;

	/** 교강사로 들어왔을때 멤버키 */
	private Long srchProfSessionMemberSeq;

	/** 검색 교과목명 */
	private String srchCourseTitle;

	/** 템플릿 검색 팝업에서 최초 호출인지 아닌지를 구분합니다. */
	private String popupFirstYn;

	/** 템플릿 검색 팝업에서 사용될 교과목 키. */
	private Long srchCourseMasterSeq;

	/** 템플릿 검색 팝업에서 사용될 개설과목 키. */
	private Long srchCourseActiveSeq;

	/** 해당 조교를 지정한 교강사만 출력되게 하기위한 변수 */
	private Long srchAssistMemberSeq;

	public String getSrchUseYn() {
		return srchUseYn;
	}

	public void setSrchUseYn(String srchUseYn) {
		this.srchUseYn = srchUseYn;
	}

	public String getSrchProfMemberName() {
		return srchProfMemberName;
	}

	public void setSrchProfMemberName(String srchProfMemberName) {
		this.srchProfMemberName = srchProfMemberName;
	}

	public Long getSrchProfMemberSeq() {
		return srchProfMemberSeq;
	}

	public void setSrchProfMemberSeq(Long srchProfMemberSeq) {
		this.srchProfMemberSeq = srchProfMemberSeq;
	}

	public String getSrchCourseTitle() {
		return srchCourseTitle;
	}

	public void setSrchCourseTitle(String srchCourseTitle) {
		this.srchCourseTitle = srchCourseTitle;
	}

	public String getPopupFirstYn() {
		return popupFirstYn;
	}

	public void setPopupFirstYn(String popupFirstYn) {
		this.popupFirstYn = popupFirstYn;
	}

	public Long getSrchCourseMasterSeq() {
		return srchCourseMasterSeq;
	}

	public void setSrchCourseMasterSeq(Long srchCourseMasterSeq) {
		this.srchCourseMasterSeq = srchCourseMasterSeq;
	}

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public Long getSrchAssistMemberSeq() {
		return srchAssistMemberSeq;
	}

	public void setSrchAssistMemberSeq(Long srchAssistMemberSeq) {
		this.srchAssistMemberSeq = srchAssistMemberSeq;
	}

	public Long getSrchProfSessionMemberSeq() {
		return srchProfSessionMemberSeq;
	}

	public void setSrchProfSessionMemberSeq(Long srchProfSessionMemberSeq) {
		this.srchProfSessionMemberSeq = srchProfSessionMemberSeq;
	}

}
