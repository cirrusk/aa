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
 * @File : UIUnivCourseExamCondition.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 25.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseExamCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 교과목 검색 */
	private Long srchCourseMasterSeq;

	/** 교과목 제목 검색 */
	private String srchCourseMasterTitle;

	/** 사용유무 검색 */
	private String srchUseYn;

	/** 문제종류(세트,단일) 검색 */
	private String srchExamCount;

	/** 시험문제 구분 */
	private String srchExamItemTypeCd;

	/** 시험지에 선택되지 않은 시험문제 검색 */
	private Long srchNotInExamPaperSeq;

	/** 교수 검색 */
	private Long srchProfMemberSeq;

	/** 전체공개 검색 */
	private String srchOpenYn;

	/** 해당 조교를 지정한 교강사만 출력되게 하기위한 변수 */
	private Long srchAssistMemberSeq;

	/** 교강사로 들어왔을때 멤버키 */
	private Long srchProfSessionMemberSeq;

	/** 검색 교강사이름 */
	private String srchProfMemberName;

	/** 교과목 검색용 */
	private String srchCourseTitle;

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

	public String getSrchUseYn() {
		return srchUseYn;
	}

	public void setSrchUseYn(String srchUseYn) {
		this.srchUseYn = srchUseYn;
	}

	public String getSrchExamCount() {
		return srchExamCount;
	}

	public void setSrchExamCount(String srchExamCount) {
		this.srchExamCount = srchExamCount;
	}

	public String getSrchExamItemTypeCd() {
		return srchExamItemTypeCd;
	}

	public void setSrchExamItemTypeCd(String srchExamItemTypeCd) {
		this.srchExamItemTypeCd = srchExamItemTypeCd;
	}

	public Long getSrchNotInExamPaperSeq() {
		return srchNotInExamPaperSeq;
	}

	public void setSrchNotInExamPaperSeq(Long srchNotInExamPaperSeq) {
		this.srchNotInExamPaperSeq = srchNotInExamPaperSeq;
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

}
