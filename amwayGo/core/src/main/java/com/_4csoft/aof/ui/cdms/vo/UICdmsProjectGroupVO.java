/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo;

import java.io.Serializable;

import com._4csoft.aof.cdms.vo.CdmsProjectGroupVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.cdms.vo
 * @File : UICdmsProjectGroupVO.java
 * @Title : 프로젝트 그룹
 * @date : 2014. 3. 13.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsProjectGroupVO extends CdmsProjectGroupVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private String[] companyTypeCds;
	private String[] companySeqs;
	private String[] deleteCompanySeqs;
	private String[] memberCdmsTypeCds;
	private String[] memberSeqs;
	private String[] deleteMemberSeqs;
	/** 단위개발 수 */
	private Long projectCount;

	public String[] getCompanyTypeCds() {
		return companyTypeCds;
	}

	public void setCompanyTypeCds(String[] companyTypeCds) {
		this.companyTypeCds = companyTypeCds;
	}

	public String[] getCompanySeqs() {
		return companySeqs;
	}

	public void setCompanySeqs(String[] companySeqs) {
		this.companySeqs = companySeqs;
	}

	public String[] getDeleteCompanySeqs() {
		return deleteCompanySeqs;
	}

	public void setDeleteCompanySeqs(String[] deleteCompanySeqs) {
		this.deleteCompanySeqs = deleteCompanySeqs;
	}

	public String[] getMemberCdmsTypeCds() {
		return memberCdmsTypeCds;
	}

	public void setMemberCdmsTypeCds(String[] memberCdmsTypeCds) {
		this.memberCdmsTypeCds = memberCdmsTypeCds;
	}

	public String[] getMemberSeqs() {
		return memberSeqs;
	}

	public void setMemberSeqs(String[] memberSeqs) {
		this.memberSeqs = memberSeqs;
	}

	public String[] getDeleteMemberSeqs() {
		return deleteMemberSeqs;
	}

	public void setDeleteMemberSeqs(String[] deleteMemberSeqs) {
		this.deleteMemberSeqs = deleteMemberSeqs;
	}

	public Long getProjectCount() {
		return projectCount;
	}

	public void setProjectCount(Long projectCount) {
		this.projectCount = projectCount;
	}

}
