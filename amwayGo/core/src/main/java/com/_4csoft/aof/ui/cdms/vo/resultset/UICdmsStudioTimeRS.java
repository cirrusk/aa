/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioTimeVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo.resultset
 * @File : UICdmsStudioTimeRS.java
 * @Title : CDMS 스튜디오 시간
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsStudioTimeRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UICdmsStudioTimeVO studioTime;

	public UICdmsStudioTimeVO getStudioTime() {
		return studioTime;
	}

	public void setStudioTime(UICdmsStudioTimeVO studioTime) {
		this.studioTime = studioTime;
	}

}
