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
 * @File : UIUnivCourseActiveLecturerCondition.java
 * @Title : 개설과목 교강사 condition
 * @date : 2014. 2. 26.
 * @author : 김현우
 * @descrption : 개설과목 교강사 condition
 */
public class UIUnivCourseActiveLecturerCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 개설과목 키 */
	private Long srchCourseActiveSeq;

	/** 교강사 권한 검색조건 (ACTIVE_LECTURER_TYPE::PROF : 교강사, ACTIVE_LECTURER_TYPE::ASSIST : 조교, ACTIVE_LECTURER_TYPE::TUTOR : 튜터) */
	private String srchActiveLecturerTypeCd;

	/** 회원 일련번호 */
	private Long srchMemberSeq;

	/** 롤그룹 일련번호 */
	private Long srchRoleGroupSeq;

	/** 강의 구분 */
	private String shortcutCourseTypeCd;

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public String getSrchActiveLecturerTypeCd() {
		return srchActiveLecturerTypeCd;
	}

	public void setSrchActiveLecturerTypeCd(String srchActiveLecturerTypeCd) {
		this.srchActiveLecturerTypeCd = srchActiveLecturerTypeCd;
	}

	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}

	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}

	public Long getSrchRoleGroupSeq() {
		return srchRoleGroupSeq;
	}

	public void setSrchRoleGroupSeq(Long srchRoleGroupSeq) {
		this.srchRoleGroupSeq = srchRoleGroupSeq;
	}

	public String getShortcutCourseTypeCd() {
		return shortcutCourseTypeCd;
	}

	public void setShortcutCourseTypeCd(String shortcutCourseTypeCd) {
		this.shortcutCourseTypeCd = shortcutCourseTypeCd;
	}

}
