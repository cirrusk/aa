/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.resultset;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo.resultset
 * @File : UICdmsStudioRS.java
 * @Title : CDMS 스튜디오
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsStudioRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UICdmsStudioVO studio;
	private List<UICdmsStudioRS> listStudioMember;

	public UICdmsStudioVO getStudio() {
		return studio;
	}

	public void setStudio(UICdmsStudioVO studio) {
		this.studio = studio;
	}

	public List<UICdmsStudioRS> getListStudioMember() {
		return listStudioMember;
	}

	public void setListStudioMember(List<UICdmsStudioRS> listStudioMember) {
		this.listStudioMember = listStudioMember;
	}

}
