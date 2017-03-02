/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsOutputVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo.resultset
 * @File : UICdmsOutputRS.java
 * @Title : CDMS 산출물
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsOutputRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UICdmsOutputVO output;

	public UICdmsOutputVO getOutput() {
		return output;
	}

	public void setOutput(UICdmsOutputVO output) {
		this.output = output;
	}

}
