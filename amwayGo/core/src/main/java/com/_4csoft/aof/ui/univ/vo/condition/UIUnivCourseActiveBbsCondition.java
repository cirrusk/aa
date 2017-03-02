/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.vo.condition
 * @File : UIUnivCourseActiveBbsCondition.java
 * @Title : 게시글
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveBbsCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 검색 실시 여부 */
	private String srchSearchYn;

	/** 게시글 구분 */
	private String srchBbsTypeCd;

	/** 게시판 일련번호 */
	private Long srchBoardSeq;

	/** 최상위 공지 여부 */
	private String srchAlwaysTopYn;

	/** 부모글 일련번호 */
	private Long srchParentSeq;

	/** 대상자 구분 */
	private String srchTargetRolegroup;

	/** 등록자 일련번호 */
	private Long srchRegMemberSeq;

	/** 회원 일련번호 */
	private Long srchMemberSeq;

	/** 게시판 구분 */
	private String srchBoardTypeCd;

	/** 과정 일련번호 */
	private Long srchCourseActiveSeq;

	/** 과정 명 */
	private String srchCourseTitle;

	/** 년도 학기 */
	private String srchYearTerm;

	/** 년도 */
	private String srchYear;

	/** 학위,비학위 구분 */
	private String srchCategoryTypeCd;

	/** 미답변 목록 검색구분 */
	private String srchReplyOnlyCheckYn;

	/** 검색 복사여부 */
	private String srchCopyYn;

	/** 최신 글 일자 */
	private Long srchRecentDay;

	private String srchClassificationCode;

	private String srchProfViewYn;
	
	private String srchBbsSeq;
	
	private String srchBeforeAfter;
	
	private String srchUpdDtime;

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public String getSrchSearchYn() {
		return srchSearchYn;
	}

	public void setSrchSearchYn(String srchSearchYn) {
		this.srchSearchYn = srchSearchYn;
	}

	public String getSrchBbsTypeCd() {
		return srchBbsTypeCd;
	}

	public void setSrchBbsTypeCd(String srchBbsTypeCd) {
		this.srchBbsTypeCd = srchBbsTypeCd;
	}

	public Long getSrchBoardSeq() {
		return srchBoardSeq;
	}

	public void setSrchBoardSeq(Long srchBoardSeq) {
		this.srchBoardSeq = srchBoardSeq;
	}

	public String getSrchAlwaysTopYn() {
		return srchAlwaysTopYn;
	}

	public void setSrchAlwaysTopYn(String srchAlwaysTopYn) {
		this.srchAlwaysTopYn = srchAlwaysTopYn;
	}

	public Long getSrchParentSeq() {
		return srchParentSeq;
	}

	public void setSrchParentSeq(Long srchParentSeq) {
		this.srchParentSeq = srchParentSeq;
	}

	public String getSrchTargetRolegroup() {
		return srchTargetRolegroup;
	}

	public void setSrchTargetRolegroup(String srchTargetRolegroup) {
		this.srchTargetRolegroup = srchTargetRolegroup;
	}

	public Long getSrchRegMemberSeq() {
		return srchRegMemberSeq;
	}

	public void setSrchRegMemberSeq(Long srchRegMemberSeq) {
		this.srchRegMemberSeq = srchRegMemberSeq;
	}

	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}

	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}

	public String getSrchBoardTypeCd() {
		return srchBoardTypeCd;
	}

	public void setSrchBoardTypeCd(String srchBoardTypeCd) {
		this.srchBoardTypeCd = srchBoardTypeCd;
	}

	public String getSrchCourseTitle() {
		return srchCourseTitle;
	}

	public void setSrchCourseTitle(String srchCourseTitle) {
		this.srchCourseTitle = srchCourseTitle;
	}

	public String getSrchYearTerm() {
		return srchYearTerm;
	}

	public void setSrchYearTerm(String srchYearTerm) {
		this.srchYearTerm = srchYearTerm;
	}

	public String getSrchYear() {
		return srchYear;
	}

	public void setSrchYear(String srchYear) {
		this.srchYear = srchYear;
	}

	public String getSrchCategoryTypeCd() {
		return srchCategoryTypeCd;
	}
	
	public void setSrchCategoryTypeCd(String srchCategoryTypeCd) {
		this.srchCategoryTypeCd = srchCategoryTypeCd;
	}
	
	public String getSrchCourseTitleDB() {
		String strReturn = null;
		if(srchCourseTitle != null){
			strReturn = srchCourseTitle.replaceAll("%", "\\\\%");
		}
		return strReturn;
	}

	public String getSrchReplyOnlyCheckYn() {
		return srchReplyOnlyCheckYn;
	}

	public void setSrchReplyOnlyCheckYn(String srchReplyOnlyCheckYn) {
		this.srchReplyOnlyCheckYn = srchReplyOnlyCheckYn;
	}

	public String getSrchCopyYn() {
		return srchCopyYn;
	}

	public void setSrchCopyYn(String srchCopyYn) {
		this.srchCopyYn = srchCopyYn;
	}

	public Long getSrchRecentDay() {
		return srchRecentDay;
	}

	public void setSrchRecentDay(Long srchRecentDay) {
		this.srchRecentDay = srchRecentDay;
	}

	public String getSrchClassificationCode() {
		return srchClassificationCode;
	}

	public void setSrchClassificationCode(String srchClassificationCode) {
		this.srchClassificationCode = srchClassificationCode;
	}

	public String getSrchProfViewYn() {
		return srchProfViewYn;
	}

	public void setSrchProfViewYn(String srchProfViewYn) {
		this.srchProfViewYn = srchProfViewYn;
	}

	public String getSrchBbsSeq() {
		return srchBbsSeq;
	}

	public void setSrchBbsSeq(String srchBbsSeq) {
		this.srchBbsSeq = srchBbsSeq;
	}

	public String getSrchBeforeAfter() {
		return srchBeforeAfter;
	}

	public void setSrchBeforeAfter(String srchBeforeAfter) {
		this.srchBeforeAfter = srchBeforeAfter;
	}

	public String getSrchUpdDtime() {
		return srchUpdDtime;
	}

	public void setSrchUpdDtime(String srchUpdDtime) {
		this.srchUpdDtime = srchUpdDtime;
	}

}
