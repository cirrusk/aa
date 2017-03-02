/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.dto;

import java.io.Serializable;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.infra.dto
 * @File : MemberDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 24.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class MemberDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** cs_member_seq : 멤버 일련번호 */
	private Long memberSeq;

	/** cs_member_id : 멤버 ID */
	private String memberId;

	/** cs_member_name : 멤버명 */
	private String memberName;

	/** cs_member_status_cd : 계정 상태코드 */
	private String memberStatusCd;
	/** 계정 상태 */
	private String memberStatus;

	/** cs_nickname : 닉네임 */
	private String nickname;

	/** cs_email : 이메일 */
	private String email;

	/** cs_photo : 사진 */
	private String photo;

	/** cs_phone_mobile : 전화번호 모바일 */
	private String phoneMobile;

	/** cs_sex_cd : 성별 코드 */
	private String sexCd;
	private String sex;

	/** cs_sms_yn : sms 수신여부 */
	private String smsYn;

	/** cs_email_yn : email 수신여부 */
	private String emailYn;

	/** cs_birthday : 생년월일 */
	private String birthday;

	/** cs_password_upd_dtime : 비밀번호 변경일시 */
	private String passwordUpdDtime;

	/** cs_plan_password_upd_dtime : 비밀번호변경 예정일시 */
	private String planPasswordUpdDtime;

	private String categoryString;

	private String categoryName;

	private String studentStatusCd;
	private String studentStatus;

	private String jobTypeCd;
	private String jobType;

	private String profTypeCd;
	private String profType;

	private String cdmsTaskTypeCd;
	private String cdmsTaskType;
	private String companyName;
	private String motto;
	private String position;
	private String positionName;

	private String organizationString;

	/** 개인정보 동의 여부 */
	private String agreementYn;

	/** 개인정보 동의 일시 */
	private String agreementDtime;

	public Long getMemberSeq() {
		return memberSeq;
	}

	public void setMemberSeq(Long memberSeq) {
		this.memberSeq = memberSeq;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getMemberStatusCd() {
		return memberStatusCd;
	}

	public void setMemberStatusCd(String memberStatusCd) {
		this.memberStatusCd = memberStatusCd;
	}

	public String getMemberStatus() {
		return memberStatus;
	}

	public void setMemberStatus(String memberStatus) {
		this.memberStatus = memberStatus;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

	public String getPhoneMobile() {
		return phoneMobile;
	}

	public void setPhoneMobile(String phoneMobile) {
		this.phoneMobile = phoneMobile;
	}

	public String getSexCd() {
		return sexCd;
	}

	public void setSexCd(String sexCd) {
		this.sexCd = sexCd;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getSmsYn() {
		return smsYn;
	}

	public void setSmsYn(String smsYn) {
		this.smsYn = smsYn;
	}

	public String getEmailYn() {
		return emailYn;
	}

	public void setEmailYn(String emailYn) {
		this.emailYn = emailYn;
	}

	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}

	public String getPasswordUpdDtime() {
		return passwordUpdDtime;
	}

	public void setPasswordUpdDtime(String passwordUpdDtime) {
		this.passwordUpdDtime = passwordUpdDtime;
	}

	public String getPlanPasswordUpdDtime() {
		return planPasswordUpdDtime;
	}

	public void setPlanPasswordUpdDtime(String planPasswordUpdDtime) {
		this.planPasswordUpdDtime = planPasswordUpdDtime;
	}

	public String getCategoryString() {
		return categoryString;
	}

	public void setCategoryString(String categoryString) {
		this.categoryString = categoryString;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	public String getStudentStatusCd() {
		return studentStatusCd;
	}

	public void setStudentStatusCd(String studentStatusCd) {
		this.studentStatusCd = studentStatusCd;
	}

	public String getJobTypeCd() {
		return jobTypeCd;
	}

	public void setJobTypeCd(String jobTypeCd) {
		this.jobTypeCd = jobTypeCd;
	}

	public String getProfTypeCd() {
		return profTypeCd;
	}

	public void setProfTypeCd(String profTypeCd) {
		this.profTypeCd = profTypeCd;
	}

	public String getCdmsTaskTypeCd() {
		return cdmsTaskTypeCd;
	}

	public void setCdmsTaskTypeCd(String cdmsTaskTypeCd) {
		this.cdmsTaskTypeCd = cdmsTaskTypeCd;
	}

	public String getStudentStatus() {
		return studentStatus;
	}

	public void setStudentStatus(String studentStatus) {
		this.studentStatus = studentStatus;
	}

	public String getJobType() {
		return jobType;
	}

	public void setJobType(String jobType) {
		this.jobType = jobType;
	}

	public String getProfType() {
		return profType;
	}

	public void setProfType(String profType) {
		this.profType = profType;
	}

	public String getCdmsTaskType() {
		return cdmsTaskType;
	}

	public void setCdmsTaskType(String cdmsTaskType) {
		this.cdmsTaskType = cdmsTaskType;
	}

	public String getOrganizationString() {
		return organizationString;
	}

	public void setOrganizationString(String organizationString) {
		this.organizationString = organizationString;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getMotto() {
		return motto;
	}

	public void setMotto(String motto) {
		this.motto = motto;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getPositionName() {
		return positionName;
	}

	public void setPositionName(String positionName) {
		this.positionName = positionName;
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

}
