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
 * @File : UIRolegroupCondition.java
 * @Title : 롤그룹 검색 키워드
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIAgreementCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/** 약관정보관리 필드*/
	private Long agreementSeq;
	private String agreementType;
	private String agreementCodeName;
	private String agreementTitle;
	private Long agreementChek;
	private Long agreementVersion;
	private String agreementText;
	private Long agreementMemberSeq;
	private String agreementMemberName;
	private String agreementDtime;
	
	/** 약관정보관리 동의*/
	private Long agreementApplySeq;
	private Long courseActiveSeqs;
	private Long applyCheck;
	private String regApplyDtime;
	private String updApplyDtime;
	private String myAgreeDtime;
	private String courseAgreementYn;
	
	/** 검색 : 과정키값*/
	private Long srchCourseActiveSeq;
	/** 검색 : 버전*/
	private Long srchVersion;
	/** 검색 : 여부(1:필수, 2:선택)*/
	private Long srchCheck;
	
	/** 검색 : 약관동의키값*/
	private String srchAgreeSeq1;
	private String srchAgreeSeq2;
	private String srchAgreeSeq3;
	
	/** 검색 : 약관동의여부*/
	private String srchApplyCheck1;
	private String srchApplyCheck2;
	private String srchApplyCheck3;
	
	private Long srchMemberSeq;
	
	public Long getAgreementSeq() {
		return agreementSeq;
	}
	public void setAgreementSeq(Long agreementSeq) {
		this.agreementSeq = agreementSeq;
	}
	public String getAgreementType() {
		return agreementType;
	}
	public void setAgreementType(String agreementType) {
		this.agreementType = agreementType;
	}
	public String getAgreementCodeName() {
		return agreementCodeName;
	}
	public void setAgreementCodeName(String agreementCodeName) {
		this.agreementCodeName = agreementCodeName;
	}
	public String getAgreementTitle() {
		return agreementTitle;
	}
	public void setAgreementTitle(String agreementTitle) {
		this.agreementTitle = agreementTitle;
	}
	public Long getAgreementChek() {
		return agreementChek;
	}
	public void setAgreementChek(Long agreementChek) {
		this.agreementChek = agreementChek;
	}
	public Long getAgreementVersion() {
		return agreementVersion;
	}
	public void setAgreementVersion(Long agreementVersion) {
		this.agreementVersion = agreementVersion;
	}
	public Long getAgreementMemberSeq() {
		return agreementMemberSeq;
	}
	public void setAgreementMemberSeq(Long agreementMemberSeq) {
		this.agreementMemberSeq = agreementMemberSeq;
	}
	public String getAgreementMemberName() {
		return agreementMemberName;
	}
	public void setAgreementMemberName(String agreementMemberName) {
		this.agreementMemberName = agreementMemberName;
	}
	public String getAgreementDtime() {
		return agreementDtime;
	}
	public void setAgreementDtime(String agreementDtime) {
		this.agreementDtime = agreementDtime;
	}
	public String getAgreementText() {
		return agreementText;
	}
	public void setAgreementText(String agreementText) {
		this.agreementText = agreementText;
	}
	public Long getAgreementApplySeq() {
		return agreementApplySeq;
	}
	public void setAgreementApplySeq(Long agreementApplySeq) {
		this.agreementApplySeq = agreementApplySeq;
	}
	public Long getApplyCheck() {
		return applyCheck;
	}
	public void setApplyCheck(Long applyCheck) {
		this.applyCheck = applyCheck;
	}
	public String getRegApplyDtime() {
		return regApplyDtime;
	}
	public void setRegApplyDtime(String regApplyDtime) {
		this.regApplyDtime = regApplyDtime;
	}
	public String getUpdApplyDtime() {
		return updApplyDtime;
	}
	public void setUpdApplyDtime(String updApplyDtime) {
		this.updApplyDtime = updApplyDtime;
	}
	public Long getCourseActiveSeqs() {
		return courseActiveSeqs;
	}
	public void setCourseActiveSeqs(Long courseActiveSeqs) {
		this.courseActiveSeqs = courseActiveSeqs;
	}
	
	public Long getSrchVersion() {
		return srchVersion;
	}
	public void setSrchVersion(Long srchVersion) {
		this.srchVersion = srchVersion;
	}
	
	public Long getSrchCheck() {
		return srchCheck;
	}
	public void setSrchCheck(Long srchCheck) {
		this.srchCheck = srchCheck;
	}
	
	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}
	
	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public String getSrchAgreeSeq1() {
		return srchAgreeSeq1;
	}
	public void setSrchAgreeSeq1(String srchAgreeSeq1) {
		this.srchAgreeSeq1 = srchAgreeSeq1;
	}
	public String getSrchAgreeSeq2() {
		return srchAgreeSeq2;
	}
	public void setSrchAgreeSeq2(String srchAgreeSeq2) {
		this.srchAgreeSeq2 = srchAgreeSeq2;
	}
	public String getSrchAgreeSeq3() {
		return srchAgreeSeq3;
	}
	public void setSrchAgreeSeq3(String srchAgreeSeq3) {
		this.srchAgreeSeq3 = srchAgreeSeq3;
	}
	public String getSrchApplyCheck1() {
		return srchApplyCheck1;
	}
	public void setSrchApplyCheck1(String srchApplyCheck1) {
		this.srchApplyCheck1 = srchApplyCheck1;
	}
	public String getSrchApplyCheck2() {
		return srchApplyCheck2;
	}
	public void setSrchApplyCheck2(String srchApplyCheck2) {
		this.srchApplyCheck2 = srchApplyCheck2;
	}
	public String getSrchApplyCheck3() {
		return srchApplyCheck3;
	}
	public void setSrchApplyCheck3(String srchApplyCheck3) {
		this.srchApplyCheck3 = srchApplyCheck3;
	}
	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}
	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}
	public String getMyAgreeDtime() {
		return myAgreeDtime;
	}
	public void setMyAgreeDtime(String myAgreeDtime) {
		this.myAgreeDtime = myAgreeDtime;
	}
	public String getCourseAgreementYn() {
		return courseAgreementYn;
	}
	public void setCourseAgreementYn(String courseAgreementYn) {
		this.courseAgreementYn = courseAgreementYn;
	}
}
