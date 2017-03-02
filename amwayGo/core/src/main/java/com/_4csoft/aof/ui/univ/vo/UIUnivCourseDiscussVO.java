/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseDiscussVO;

/**
 * 
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseDiscussVO.java
 * @Title : 토론
 * @date : 2014. 2. 26.
 * @author : 김영학
 * @descrption : 대학 교과목구성정보 토론
 */
public class UIUnivCourseDiscussVO extends UnivCourseDiscussVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/** cs_course_active_seq : 토론 일련번호 */
	private Long[] discussSeqs;

	/** 수강생일련번호 다중 채점 변수 */
	private Long[] courseApplySeqs;

	/** 회원일련번호 다중 채점 변수 */
	private Long[] memberSeqs;

	/** cs_rate : 비율 */
	private Double[] rates;

	/** 교과목 일련번호 */
	private Long courseMasterSeq;

	/** 해당 토론의 전체 게시글수 */
	private Long bbsCount;

	/** 해당 토론의 나의 게시글수 */
	private Long bbsMemberCount;

	/** 참여자 인원수 */
	private Long regMemberCount;

	/** 대상인원수 */
	private Long memberCount;

	/** 미참여 인원수 */
	private Long nonMemberCount;

	/** 토론 게시판 일련번호 (토론자 목록에서 사용) */
	private Long boardSeq;

	/** 평가대상 게시물 수 */
	private Long evaluateCount;

	/** 바로가기 개설과목일련번호 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 파라미터 */
	private String shortcutCategoryTypeCd;

	/** 수강시작일 다중 채점 변수 */
	private String[] startDtimes;

	/** 수강종료일 다중 채점 변수 */
	private String[] endDtimes;

	/**
	 * 바로가기 값 복사(
	 */
	public void copyShortcut() {
		super.setCourseActiveSeq(this.getShortcutCourseActiveSeq());
	}

	public Long[] getDiscussSeqs() {
		return discussSeqs;
	}

	public void setDiscussSeqs(Long[] discussSeqs) {
		this.discussSeqs = discussSeqs;
	}

	public Double[] getRates() {
		return rates;
	}

	public void setRates(Double[] rates) {
		this.rates = rates;
	}

	public Long getCourseMasterSeq() {
		return courseMasterSeq;
	}

	public void setCourseMasterSeq(Long courseMasterSeq) {
		this.courseMasterSeq = courseMasterSeq;
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

	public Long getBbsCount() {
		return bbsCount;
	}

	public void setBbsCount(Long bbsCount) {
		this.bbsCount = bbsCount;
	}

	public Long getBbsMemberCount() {
		return bbsMemberCount;
	}

	public void setBbsMemberCount(Long bbsMemberCount) {
		this.bbsMemberCount = bbsMemberCount;
	}

	public Long getRegMemberCount() {
		return regMemberCount;
	}

	public void setRegMemberCount(Long regMemberCount) {
		this.regMemberCount = regMemberCount;
	}

	public Long getMemberCount() {
		return memberCount;
	}

	public void setMemberCount(Long memberCount) {
		this.memberCount = memberCount;
	}

	public Long getNonMemberCount() {
		return nonMemberCount;
	}

	public void setNonMemberCount(Long nonMemberCount) {
		this.nonMemberCount = nonMemberCount;
	}

	public Long getBoardSeq() {
		return boardSeq;
	}

	public void setBoardSeq(Long boardSeq) {
		this.boardSeq = boardSeq;
	}

	public Long getEvaluateCount() {
		return evaluateCount;
	}

	public void setEvaluateCount(Long evaluateCount) {
		this.evaluateCount = evaluateCount;
	}

	public Long[] getCourseApplySeqs() {
		return courseApplySeqs;
	}

	public void setCourseApplySeqs(Long[] courseApplySeqs) {
		this.courseApplySeqs = courseApplySeqs;
	}

	public Long[] getMemberSeqs() {
		return memberSeqs;
	}

	public void setMemberSeqs(Long[] memberSeqs) {
		this.memberSeqs = memberSeqs;
	}

	public String[] getStartDtimes() {
		return startDtimes;
	}

	public void setStartDtimes(String[] startDtimes) {
		this.startDtimes = startDtimes;
	}

	public String[] getEndDtimes() {
		return endDtimes;
	}

	public void setEndDtimes(String[] endDtimes) {
		this.endDtimes = endDtimes;
	}

}
