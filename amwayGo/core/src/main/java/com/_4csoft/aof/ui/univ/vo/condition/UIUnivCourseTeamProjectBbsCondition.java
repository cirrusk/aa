/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.condition;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.vo.condition
 * @File : UIUnivCourseTeamProjectBbsCondition.java
 * @Title :
 * @date : 2014. 3. 11.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseTeamProjectBbsCondition extends SearchConditionVO {

	private static final long serialVersionUID = 1L;

	/** 게시판 일련번호 */
	private Long srchBoardSeq;

	/** 게시글 구분 */
	private String srchBbsTypeCd;

	/** 최상위 공지 여부 */
	private String srchAlwaysTopYn;

	/** 검색 실시 여부 */
	private String srchSearchYn;

	/** 부모글 일련번호 */
	private Long srchParentSeq;

	/** 대상자 구분 */
	private String srchTargetRolegroup;

	/** 등록자 일련번호 */
	private Long srchRegMemberSeq;

	/** 팀프로젝트 일련번호 */
	private Long srchCourseTeamProjectseq;

	/** 개설 과목 일련번호 */
	private Long srchCourseActiveSeq;

	/** 팀 일련번호 */
	private Long srchCourseTeamSeq;
	/** 비밀글 여부 */
	private String srchSecretYn;

	public Long getSrchBoardSeq() {
		return srchBoardSeq;
	}

	public void setSrchBoardSeq(Long srchBoardSeq) {
		this.srchBoardSeq = srchBoardSeq;
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

	public Long getSrchRegMemberSeq() {
		return srchRegMemberSeq;
	}

	public void setSrchRegMemberSeq(Long srchRegMemberSeq) {
		this.srchRegMemberSeq = srchRegMemberSeq;
	}

	public Long getSrchCourseTeamProjectseq() {
		return srchCourseTeamProjectseq;
	}

	public void setSrchCourseTeamProjectseq(Long srchCourseTeamProjectseq) {
		this.srchCourseTeamProjectseq = srchCourseTeamProjectseq;
	}

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public Long getSrchCourseTeamSeq() {
		return srchCourseTeamSeq;
	}

	public void setSrchCourseTeamSeq(Long srchCourseTeamSeq) {
		this.srchCourseTeamSeq = srchCourseTeamSeq;
	}

	public String getSrchSecretYn() {
		return srchSecretYn;
	}

	public void setSrchSecretYn(String srchSecretYn) {
		this.srchSecretYn = srchSecretYn;
	}

}
