/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivMemberVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UIMemberVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMemberVO extends UnivMemberVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 멀티 수정 처리 */
	private Long[] memberSeqs;

	/** 통계일 */
	private String statisticsDate;

	/** 통계수 */
	private Long statisticsCount;

	/** 통계 전체수 */
	private Long totalCount;

	/** 통계 오늘수 */
	private Long todayCount;

	/** 통계 어제수 */
	private Long yesterdayCount;

	/** 통계 이번달 수 */
	private Long thisMonthCount;

	/** user agent */
	private String userAgent;

	/** ip */
	private String ip;

	/** 맴버 이름 ARRAY */
	private String[] memberNames;
	
	/** 맴버 아이디 ARRAY */
	private String[] memberIds;

	/** 맴버 전화번호 ARRAY */
	private String[] phoneMobiles;

	/** 직급 */
	private String position;

	/** 교강사 구분 */
	private String profTypeCd;

	/** 업무코드 */
	private String jobTypeCd;

	/** CDMS 업무구분 */
	private String cdmsTaskTypeCd;

	/** 좌우명 */
	private String motto;

	/** 회사명 */
	private String companyName;

	/** 개인정보 동의 여부 */
	private String agreementYn;

	/** 개인정보 동의 일시 */
	private String agreementDtime;
	
	/** LMS 핀번호 코드 */
	private String pincode;
	
	/** LMS 핀번호 네임 */
	private String pinName;

	public Long[] getMemberSeqs() {
		return memberSeqs;
	}

	public void setMemberSeqs(Long[] memberSeqs) {
		this.memberSeqs = memberSeqs;
	}

	public String getStatisticsDate() {
		return statisticsDate;
	}

	public void setStatisticsDate(String statisticsDate) {
		this.statisticsDate = statisticsDate;
	}

	public Long getStatisticsCount() {
		return statisticsCount;
	}

	public void setStatisticsCount(Long statisticsCount) {
		this.statisticsCount = statisticsCount;
	}

	public Long getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(Long totalCount) {
		this.totalCount = totalCount;
	}

	public Long getTodayCount() {
		return todayCount;
	}

	public void setTodayCount(Long todayCount) {
		this.todayCount = todayCount;
	}

	public Long getYesterdayCount() {
		return yesterdayCount;
	}

	public void setYesterdayCount(Long yesterdayCount) {
		this.yesterdayCount = yesterdayCount;
	}

	public Long getThisMonthCount() {
		return thisMonthCount;
	}

	public void setThisMonthCount(Long thisMonthCount) {
		this.thisMonthCount = thisMonthCount;
	}

	public String getUserAgent() {
		return userAgent;
	}

	public void setUserAgent(String userAgent) {
		this.userAgent = userAgent;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String[] getMemberIds() {
		return memberIds;
	}

	public void setMemberIds(String[] memberIds) {
		this.memberIds = memberIds;
	}

	public String[] getMemberNames() {
		return memberNames;
	}

	public void setMemberNames(String[] memberNames) {
		this.memberNames = memberNames;
	}

	public String[] getPhoneMobiles() {
		return phoneMobiles;
	}

	public void setPhoneMobiles(String[] phoneMobiles) {
		this.phoneMobiles = phoneMobiles;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getProfTypeCd() {
		return profTypeCd;
	}

	public void setProfTypeCd(String profTypeCd) {
		this.profTypeCd = profTypeCd;
	}

	public String getJobTypeCd() {
		return jobTypeCd;
	}

	public void setJobTypeCd(String jobTypeCd) {
		this.jobTypeCd = jobTypeCd;
	}

	public String getCdmsTaskTypeCd() {
		return cdmsTaskTypeCd;
	}

	public void setCdmsTaskTypeCd(String cdmsTaskTypeCd) {
		this.cdmsTaskTypeCd = cdmsTaskTypeCd;
	}

	public String getMotto() {
		return motto;
	}

	public void setMotto(String motto) {
		this.motto = motto;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getAgreementYn() {
		return agreementYn;
	}

	public void setAgreementYn(String agreementYn) {
		this.agreementYn = agreementYn;
	}

	public String getAgreementDtime() {
		return agreementDtime;
	}

	public void setAgreementDtime(String agreementDtime) {
		this.agreementDtime = agreementDtime;
	}

	public String getPincode() {
		return pincode;
	}

	public void setPincode(String pincode) {
		this.pincode = pincode;
	}

	public String getPinName() {
		return pinName;
	}

	public void setPinName(String pinName) {
		this.pinName = pinName;
	}

}
