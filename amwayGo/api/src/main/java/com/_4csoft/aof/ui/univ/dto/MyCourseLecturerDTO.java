/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

/**
 * @Project : lgaca-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : MyCourseLecturerDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 27.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class MyCourseLecturerDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** cs_active_lecturer_type_cd : 개설과목 안에서 교수자구분 코드 */
	private String activeLecturerTypeCd;

	private String activeLecturerType;

	/** cs_prof_president_yn : 대표교수 여부 */
	private String profPresidentYn;

	/** cs_member_seq : 멤버일련번호 */
	private Long memberSeq;

	/** cs_course_active_seq : 개설과목 일련번호 */
	private Long courseActiveSeq;

	/** cs_use_yn : 사용여부 */
	private String useYn;

	/** cs_prof_member_seq : 교수자 일련번호 */
	private Long profMemberSeq;

	/** 조교나 튜더에 권한을 지정한 교수명 */
	private String profMemberName;

	/** 사진 */
	private String photo;

	/** 전화번호 모바일 */
	private String phoneMobile;

	/** 좌우명 */
	private String motto;

	/** 아이디 */
	private String memberId;

	/** 직급 */
	private String position;

	private String positionName;

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

	public String getActiveLecturerTypeCd() {
		return activeLecturerTypeCd;
	}

	public void setActiveLecturerTypeCd(String activeLecturerTypeCd) {
		this.activeLecturerTypeCd = activeLecturerTypeCd;
	}

	public String getProfPresidentYn() {
		return profPresidentYn;
	}

	public void setProfPresidentYn(String profPresidentYn) {
		this.profPresidentYn = profPresidentYn;
	}

	public Long getMemberSeq() {
		return memberSeq;
	}

	public void setMemberSeq(Long memberSeq) {
		this.memberSeq = memberSeq;
	}

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public Long getProfMemberSeq() {
		return profMemberSeq;
	}

	public void setProfMemberSeq(Long profMemberSeq) {
		this.profMemberSeq = profMemberSeq;
	}

	public String getProfMemberName() {
		return profMemberName;
	}

	public void setProfMemberName(String profMemberName) {
		this.profMemberName = profMemberName;
	}

	public String getActiveLecturerType() {
		return activeLecturerType;
	}

	public void setActiveLecturerType(String activeLecturerType) {
		this.activeLecturerType = activeLecturerType;
	}

	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

	public String getMotto() {
		return motto;
	}

	public void setMotto(String motto) {
		this.motto = motto;
	}

	public String getPhoneMobile() {
		return phoneMobile;
	}

	public void setPhoneMobile(String phoneMobile) {
		this.phoneMobile = phoneMobile;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

}
