/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.condition;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.condition
 * @File : UIUnivCourseDiscussBbsCondition.java
 * @Title : 토론 토론자목록 용도 condition
 * @date : 2014. 3. 19.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseDiscussApplyCondition extends SearchConditionVO {

	private static final long serialVersionUID = 1L;

	/** 게시판 일련번호 */
	private Long srchBoardSeq;

	/** 토론 일련번호 */
	private Long discussSeq;

	/** 개설과목 일련번호 */
	private Long courseActiveSeq;

	/** 주차요소 일련번호 */
	private Long activeElementSeq;

	/** 검색 분류문자열(학부) */
	private String srchCategoryName;

	/** 과정 분류 */
	private String courseTypeCd;

	public Long getSrchBoardSeq() {
		return srchBoardSeq;
	}

	public void setSrchBoardSeq(Long srchBoardSeq) {
		this.srchBoardSeq = srchBoardSeq;
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

	public String getSrchCategoryName() {
		return srchCategoryName;
	}

	public void setSrchCategoryName(String srchCategoryName) {
		this.srchCategoryName = srchCategoryName;
	}

	public Long getActiveElementSeq() {
		return activeElementSeq;
	}

	public void setActiveElementSeq(Long activeElementSeq) {
		this.activeElementSeq = activeElementSeq;
	}

	public String getSrchCategoryNameDB() {
		return srchCategoryName.replaceAll("%", "\\\\%");
	}

	public String getCourseTypeCd() {
		return courseTypeCd;
	}

	public void setCourseTypeCd(String courseTypeCd) {
		this.courseTypeCd = courseTypeCd;
	}

}
