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
 * @File : UIUnivCourseDiscussBbsCondition.java
 * @Title : 토론 게시판 condition
 * @date : 2014. 3. 19.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseDiscussBbsCondition extends SearchConditionVO {

	private static final long serialVersionUID = 1L;

	/** 게시판 일련번호 */
	private Long srchBoardSeq;

	/** 토론 일련번호 */
	private Long discussSeq;

	/** 개설과목 일련번호 */
	private Long courseActiveSeq;

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

	public Long getDiscussSeq() {
		return discussSeq;
	}

	public void setDiscussSeq(Long discussSeq) {
		this.discussSeq = discussSeq;
	}

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}

}
