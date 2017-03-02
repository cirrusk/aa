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
 * @Package : com._4csoft.aof.ui.univ.vo.condition
 * @File : UIUnivCourseBbsResultCondition.java
 * @Title : 참여결과 검색 조건
 * @date : 2014. 03. 17.
 * @author : 류정희
 * @descrption : 참여결과 검색 조건
 */
public class UIUnivCourseBbsResultCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 과정 시퀀스 */
	private Long srchCourseActiveSeq;

	/** 게시판 시퀀스 */
	private Long srchBoardSeq;

	/** 검색 실시 여부 */
	private String srchSearchYn;

	/** 게시글 구분 */
	private String srchBbsTypeCd;

	/** 최상위 공지 여부 */
	private String srchAlwaysTopYn;

	/** 부모글 일련번호 */
	private Long srchParentSeq;

	/** 대상자 구분 */
	private String srchTargetRolegroup;

	/** 게시자 일련번호 */
	private String srchRegMemberSeq;

	/** 학부 검색 필드 */
	private String srchCategoryString;

	/** 학과 검색 필드 */
	private String srchCategoryName;

	/** 게시판 구분 */
	private String srchBoardTypeCd;

	/** 복사 여부 */
	private String srchCopyYn;

	public String getSrchBoardTypeCd() {
		return srchBoardTypeCd;
	}

	public void setSrchBoardTypeCd(String srchBoardTypeCd) {
		this.srchBoardTypeCd = srchBoardTypeCd;
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

	public String getSrchRegMemberSeq() {
		return srchRegMemberSeq;
	}

	public void setSrchRegMemberSeq(String srchRegMemberSeq) {
		this.srchRegMemberSeq = srchRegMemberSeq;
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

	public Long getSrchBoardSeq() {
		return srchBoardSeq;
	}

	public void setSrchBoardSeq(Long srchBoardSeq) {
		this.srchBoardSeq = srchBoardSeq;
	}

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public String getSrchCopyYn() {
		return srchCopyYn;
	}

	public void setSrchCopyYn(String srchCopyYn) {
		this.srchCopyYn = srchCopyYn;
	}

}
