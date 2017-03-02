/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.vo.condition
 * @File : UIBbsCondition.java
 * @Title : 게시글
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIBbsCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 검색 실시 여부 */
	private String srchSearchYn;

	/** 게시글 구분 */
	private String srchBbsTypeCd;

	/** 대상자 구분 */
	private String srchTargetRolegroup;

	/** 게시판 일련번호 */
	private Long srchBoardSeq;

	/** 최상위 공지 여부 */
	private String srchAlwaysTopYn;

	/** 부모글 일련번호 */
	private Long srchParentSeq;

	/** 교직원 게시판 구분 */
	private String srchStaffYn;

	/** 작성자 일련번호 */
	private Long srchMemberSeq;

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

	public String getSrchStaffYn() {
		return srchStaffYn;
	}

	public void setSrchStaffYn(String srchStaffYn) {
		this.srchStaffYn = srchStaffYn;
	}

	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}

	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}

}
