/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo;

import java.io.Serializable;

import com._4csoft.aof.cdms.vo.CdmsChargeVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo
 * @File : UICdmsChargeVO.java
 * @Title : CDMS 담당자
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsChargeVO extends CdmsChargeVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long[] sectionIndexs;
	private Long[] outputIndexs;
	private Long[] moduleIndexs;
	private Long[] memberSeqs;
	private String[] memberCdmsTypeCds;
	private String[] chargeEditableYns;

	public Long[] getSectionIndexs() {
		return sectionIndexs;
	}

	public void setSectionIndexs(Long[] sectionIndexs) {
		this.sectionIndexs = sectionIndexs;
	}

	public Long[] getOutputIndexs() {
		return outputIndexs;
	}

	public void setOutputIndexs(Long[] outputIndexs) {
		this.outputIndexs = outputIndexs;
	}

	public Long[] getModuleIndexs() {
		return moduleIndexs;
	}

	public void setModuleIndexs(Long[] moduleIndexs) {
		this.moduleIndexs = moduleIndexs;
	}

	public Long[] getMemberSeqs() {
		return memberSeqs;
	}

	public void setMemberSeqs(Long[] memberSeqs) {
		this.memberSeqs = memberSeqs;
	}

	public String[] getMemberCdmsTypeCds() {
		return memberCdmsTypeCds;
	}

	public void setMemberCdmsTypeCds(String[] memberCdmsTypeCds) {
		this.memberCdmsTypeCds = memberCdmsTypeCds;
	}

	public String[] getChargeEditableYns() {
		return chargeEditableYns;
	}

	public void setChargeEditableYns(String[] chargeEditableYns) {
		this.chargeEditableYns = chargeEditableYns;
	}

}
