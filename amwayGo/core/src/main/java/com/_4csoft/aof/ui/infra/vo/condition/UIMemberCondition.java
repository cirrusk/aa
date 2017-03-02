/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo.search
 * @File : UIMemberCondition.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMemberCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 계정상태 */
	private String srchMemberStatusCd;

	/** 카테고리 */
	private Long srchCategoryOrgSeq;

	/** 학적상태 */
	private String srchStudentStatusCd;

	/** 회원구분 */
	private String srchMemberEmsTypeCd;

	/** 권한구분 */
	private String srchMemberType;

	/** 업무구분 */
	private String srchCdmsTaskTypeCd;

	/** */
	private String srchStatisticsType;

	/** */
	private String srchStartRegDate;

	/** */
	private String srchEndRegDate;

	/** */
	private String srchCategoryName;

	/** 해당 롤그룹에 속하지 않은 멤버를 뽐을 때 사용 */
	private Long srchNotInRolegroupSeq;

	/** 개설과목에 속하지 않은 멤버를 뽐을 때 사용 */
	private Long srchNotInCourseActiveSeq;

	/** 해당 콘텐츠회사에 속하지 않은 멤버를 뽐을 때 사용 */
	private Long[] srchInCompanySeqs;

	/** 검색용도 회사 seq */
	private Long srchCompanySeq;

	/** 검색용도 회사명 키워드 */
	private String srchCompanyName;

	/** 주소록 검색용도 사용 */
	private Long srchAddressGroupSeq;

	/** 교강사권한관리 메뉴 용도 해당 개설과목에 등록되지 않은 교강사 목록을 뽐기 위해 사용 */
	private Long srchCourseActiveSeq;

	/** 해당 조교를 지정한 교강사만 출력되게 하기위한 변수 */
	private Long srchAssistMemberSeq;

	/** 강의실 권한 타입 검색조건 변수 코드 : ACTIVE_LECTURER_TYPE */
	private String srchActiveLecturerType;

	/** 메세지발송 타입 */
	private String srchMessageType;

	/** 교강사 구분 */
	private String srchActiveLecturerTypeCd;

	/** 검색 직급 */
	private String srchPosition;

	public String getSrchMemberStatusCd() {
		return srchMemberStatusCd;
	}

	public void setSrchMemberStatusCd(String srchMemberStatusCd) {
		this.srchMemberStatusCd = srchMemberStatusCd;
	}

	public Long getSrchCategoryOrgSeq() {
		return srchCategoryOrgSeq;
	}

	public void setSrchCategoryOrgSeq(Long srchCategoryOrgSeq) {
		this.srchCategoryOrgSeq = srchCategoryOrgSeq;
	}

	public String getSrchStudentStatusCd() {
		return srchStudentStatusCd;
	}

	public void setSrchStudentStatusCd(String srchStudentStatusCd) {
		this.srchStudentStatusCd = srchStudentStatusCd;
	}

	public String getSrchMemberEmsTypeCd() {
		return srchMemberEmsTypeCd;
	}

	public void setSrchMemberEmsTypeCd(String srchMemberEmsTypeCd) {
		this.srchMemberEmsTypeCd = srchMemberEmsTypeCd;
	}

	public String getSrchMemberType() {
		return srchMemberType;
	}

	public void setSrchMemberType(String srchMemberType) {
		this.srchMemberType = srchMemberType;
	}

	public String getSrchCdmsTaskTypeCd() {
		return srchCdmsTaskTypeCd;
	}

	public void setSrchCdmsTaskTypeCd(String srchCdmsTaskTypeCd) {
		this.srchCdmsTaskTypeCd = srchCdmsTaskTypeCd;
	}

	public String getSrchStatisticsType() {
		return srchStatisticsType;
	}

	public void setSrchStatisticsType(String srchStatisticsType) {
		this.srchStatisticsType = srchStatisticsType;
	}

	public String getSrchStartRegDate() {
		return srchStartRegDate;
	}

	public void setSrchStartRegDate(String srchStartRegDate) {
		this.srchStartRegDate = srchStartRegDate;
	}

	public String getSrchEndRegDate() {
		return srchEndRegDate;
	}

	public void setSrchEndRegDate(String srchEndRegDate) {
		this.srchEndRegDate = srchEndRegDate;
	}

	public Long getSrchNotInRolegroupSeq() {
		return srchNotInRolegroupSeq;
	}

	public void setSrchNotInRolegroupSeq(Long srchNotInRolegroupSeq) {
		this.srchNotInRolegroupSeq = srchNotInRolegroupSeq;
	}

	public Long getSrchNotInCourseActiveSeq() {
		return srchNotInCourseActiveSeq;
	}

	public void setSrchNotInCourseActiveSeq(Long srchNotInCourseActiveSeq) {
		this.srchNotInCourseActiveSeq = srchNotInCourseActiveSeq;
	}

	public Long[] getSrchInCompanySeqs() {
		return srchInCompanySeqs;
	}

	public void setSrchInCompanySeqs(Long[] srchInCompanySeqs) {
		this.srchInCompanySeqs = srchInCompanySeqs;
	}

	public Long getSrchCompanySeq() {
		return srchCompanySeq;
	}

	public void setSrchCompanySeq(Long srchCompanySeq) {
		this.srchCompanySeq = srchCompanySeq;
	}

	public String getSrchCompanyName() {
		return srchCompanyName;
	}

	public void setSrchCompanyName(String srchCompanyName) {
		this.srchCompanyName = srchCompanyName;
	}

	public Long getSrchAddressGroupSeq() {
		return srchAddressGroupSeq;
	}

	public void setSrchAddressGroupSeq(Long srchAddressGroupSeq) {
		this.srchAddressGroupSeq = srchAddressGroupSeq;
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

	public String getSrchActiveLecturerType() {
		return srchActiveLecturerType;
	}

	public void setSrchActiveLecturerType(String srchActiveLecturerType) {
		this.srchActiveLecturerType = srchActiveLecturerType;
	}

	public String getSrchCategoryName() {
		return srchCategoryName;
	}

	public void setSrchCategoryName(String srchCategoryName) {
		this.srchCategoryName = srchCategoryName;
	}

	public String getSrchCategoryNameDB() {
		return srchCategoryName.replaceAll("%", "\\\\%");
	}

	public String getSrchMessageType() {
		return srchMessageType;
	}

	public void setSrchMessageType(String srchMessageType) {
		this.srchMessageType = srchMessageType;
	}

	public String getSrchActiveLecturerTypeCd() {
		return srchActiveLecturerTypeCd;
	}

	public void setSrchActiveLecturerTypeCd(String srchActiveLecturerTypeCd) {
		this.srchActiveLecturerTypeCd = srchActiveLecturerTypeCd;
	}

	public String getSrchPosition() {
		return srchPosition;
	}

	public void setSrchPosition(String srchPosition) {
		this.srchPosition = srchPosition;
	}

}
