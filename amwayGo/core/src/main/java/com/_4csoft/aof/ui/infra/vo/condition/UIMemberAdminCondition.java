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
 * @File : UIMemberAdminCondition.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMemberAdminCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;
	private Long srchCompanySeq;
	private Long[] srchInCompanySeqs;
	private String srchCompanyName;
	private String srchTaskCd;
	private String srchMemberStatusCd;
	private Long srchNotInRolegroupSeq;
	private Long srchNotInCourseActiveSeq;
	private String srchStartRegDate;
	private String srchEndRegDate;
	private String srchStatisticsType;

	public Long getSrchCompanySeq() {
		return srchCompanySeq;
	}

	public void setSrchCompanySeq(Long srchCompanySeq) {
		this.srchCompanySeq = srchCompanySeq;
	}

	public Long[] getSrchInCompanySeqs() {
		return srchInCompanySeqs;
	}

	public void setSrchInCompanySeqs(Long[] srchInCompanySeqs) {
		this.srchInCompanySeqs = srchInCompanySeqs;
	}

	public String getSrchCompanyName() {
		return srchCompanyName;
	}

	public void setSrchCompanyName(String srchCompanyName) {
		this.srchCompanyName = srchCompanyName;
	}

	public String getSrchTaskCd() {
		return srchTaskCd;
	}

	public void setSrchTaskCd(String srchTaskCd) {
		this.srchTaskCd = srchTaskCd;
	}

	public String getSrchMemberStatusCd() {
		return srchMemberStatusCd;
	}

	public void setSrchMemberStatusCd(String srchMemberStatusCd) {
		this.srchMemberStatusCd = srchMemberStatusCd;
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

	public String getSrchStatisticsType() {
		return srchStatisticsType;
	}

	public void setSrchStatisticsType(String srchStatisticsType) {
		this.srchStatisticsType = srchStatisticsType;
	}

}
