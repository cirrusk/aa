/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo;

import java.io.Serializable;

import com._4csoft.aof.cdms.vo.CdmsOutputVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo
 * @File : UICdmsOutputVO.java
 * @Title : CDMS 산출물
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsOutputVO extends CdmsOutputVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private String[] outputCds;
	private String[] outputNames;
	private Long[] outputIndexs;
	private Long[] outputSectionIndexs;
	private String[] endDates;
	private String[] moduleYns;
	private String autoDescription;

	// 산출물 수정 가능 여부(수정화면에서)
	private String outputEditableYn;

	// 산출물 수정 가능 여부(수정화면에서)
	private String[] outputEditableYns;

	// 산출물 개발 가능 여부(개발대상 상세에서)
	private String outputWorkYn;

	// 산출물 개발 시작일(개발대상 상세에서)
	private String startDate;

	public String[] getOutputCds() {
		return outputCds;
	}

	public void setOutputCds(String[] outputCds) {
		this.outputCds = outputCds;
	}

	public String[] getOutputNames() {
		return outputNames;
	}

	public void setOutputNames(String[] outputNames) {
		this.outputNames = outputNames;
	}

	public Long[] getOutputIndexs() {
		return outputIndexs;
	}

	public void setOutputIndexs(Long[] outputIndexs) {
		this.outputIndexs = outputIndexs;
	}

	public Long[] getOutputSectionIndexs() {
		return outputSectionIndexs;
	}

	public void setOutputSectionIndexs(Long[] outputSectionIndexs) {
		this.outputSectionIndexs = outputSectionIndexs;
	}

	public String[] getEndDates() {
		return endDates;
	}

	public void setEndDates(String[] endDates) {
		this.endDates = endDates;
	}

	public String[] getModuleYns() {
		return moduleYns;
	}

	public void setModuleYns(String[] moduleYns) {
		this.moduleYns = moduleYns;
	}

	public String getAutoDescription() {
		return autoDescription;
	}

	public void setAutoDescription(String autoDescription) {
		this.autoDescription = autoDescription;
	}

	public String getOutputEditableYn() {
		return outputEditableYn;
	}

	public void setOutputEditableYn(String outputEditableYn) {
		this.outputEditableYn = outputEditableYn;
	}

	public String[] getOutputEditableYns() {
		return outputEditableYns;
	}

	public void setOutputEditableYns(String[] outputEditableYns) {
		this.outputEditableYns = outputEditableYns;
	}

	public String getOutputWorkYn() {
		return outputWorkYn;
	}

	public void setOutputWorkYn(String outputWorkYn) {
		this.outputWorkYn = outputWorkYn;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

}
