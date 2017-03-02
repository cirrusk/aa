/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo;

import java.io.Serializable;

import com._4csoft.aof.cdms.vo.CdmsModuleVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo
 * @File : UICdmsModuleVO.java
 * @Title : CDMS 차시모듈
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsModuleVO extends CdmsModuleVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long[] moduleSeqs;
	private Long[] moduleIndexs;
	private String[] completeYns;
	private String[] autoDescriptions;

	public Long[] getModuleSeqs() {
		return moduleSeqs;
	}

	public void setModuleSeqs(Long[] moduleSeqs) {
		this.moduleSeqs = moduleSeqs;
	}

	public Long[] getModuleIndexs() {
		return moduleIndexs;
	}

	public void setModuleIndexs(Long[] moduleIndexs) {
		this.moduleIndexs = moduleIndexs;
	}

	public String[] getCompleteYns() {
		return completeYns;
	}

	public void setCompleteYns(String[] completeYns) {
		this.completeYns = completeYns;
	}

	public String[] getAutoDescriptions() {
		return autoDescriptions;
	}

	public void setAutoDescriptions(String[] autoDescriptions) {
		this.autoDescriptions = autoDescriptions;
	}

}
