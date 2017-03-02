/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo;

import java.io.Serializable;

import com._4csoft.aof.cdms.vo.CdmsProjectVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo
 * @File : UICdmsProjectVO.java
 * @Title : CDMS 프로젝트(과목)
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsProjectVO extends CdmsProjectVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long[] projectSeqs;
	private String[] completeYns;
	private String[] companyTypeCds;
	private String[] memberCdmsTypeCds;
	private String[] companySeqs;
	private String[] memberSeqs;
	private String[] deleteCompanySeqs;
	private String[] deleteMemberSeqs;
	private Long oldModuleCount; // 수정모드에서 차시수 변경시 이전 차시수
	private Long countCompletedOutput; // 진척률 계산을 위한 완료된 산출물 수
	private Long countTotalOutput; // 진척률 계산을 위한 전체 산출물 수

	public Long[] getProjectSeqs() {
		return projectSeqs;
	}

	public void setProjectSeqs(Long[] projectSeqs) {
		this.projectSeqs = projectSeqs;
	}

	public String[] getCompleteYns() {
		return completeYns;
	}

	public void setCompleteYns(String[] completeYns) {
		this.completeYns = completeYns;
	}

	public String[] getCompanyTypeCds() {
		return companyTypeCds;
	}

	public void setCompanyTypeCds(String[] companyTypeCds) {
		this.companyTypeCds = companyTypeCds;
	}

	public String[] getMemberCdmsTypeCds() {
		return memberCdmsTypeCds;
	}

	public void setMemberCdmsTypeCds(String[] memberCdmsTypeCds) {
		this.memberCdmsTypeCds = memberCdmsTypeCds;
	}

	public String[] getCompanySeqs() {
		return companySeqs;
	}

	public void setCompanySeqs(String[] companySeqs) {
		this.companySeqs = companySeqs;
	}

	public String[] getMemberSeqs() {
		return memberSeqs;
	}

	public void setMemberSeqs(String[] memberSeqs) {
		this.memberSeqs = memberSeqs;
	}

	public String[] getDeleteCompanySeqs() {
		return deleteCompanySeqs;
	}

	public void setDeleteCompanySeqs(String[] deleteCompanySeqs) {
		this.deleteCompanySeqs = deleteCompanySeqs;
	}

	public String[] getDeleteMemberSeqs() {
		return deleteMemberSeqs;
	}

	public void setDeleteMemberSeqs(String[] deleteMemberSeqs) {
		this.deleteMemberSeqs = deleteMemberSeqs;
	}

	public Long getOldModuleCount() {
		return oldModuleCount;
	}

	public void setOldModuleCount(Long oldModuleCount) {
		this.oldModuleCount = oldModuleCount;
	}

	public Long getCountCompletedOutput() {
		return countCompletedOutput;
	}

	public void setCountCompletedOutput(Long countCompletedOutput) {
		this.countCompletedOutput = countCompletedOutput;
	}

	public Long getCountTotalOutput() {
		return countTotalOutput;
	}

	public void setCountTotalOutput(Long countTotalOutput) {
		this.countTotalOutput = countTotalOutput;
	}

}
