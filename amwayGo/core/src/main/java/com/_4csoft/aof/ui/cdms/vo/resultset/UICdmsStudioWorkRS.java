/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioWorkVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo.resultset
 * @File : UICdmsStudioWorkRS.java
 * @Title : CDMS 스튜디오 작업
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsStudioWorkRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UICdmsStudioWorkVO studioWork;
	private UICdmsStudioVO studio;
	private UICdmsProjectVO project;
	private UIMemberVO resultMember;
	private UIMemberVO cancelMember;
	private UIMemberVO regMember;

	public UICdmsStudioWorkVO getStudioWork() {
		return studioWork;
	}

	public void setStudioWork(UICdmsStudioWorkVO studioWork) {
		this.studioWork = studioWork;
	}

	public UICdmsStudioVO getStudio() {
		return studio;
	}

	public void setStudio(UICdmsStudioVO studio) {
		this.studio = studio;
	}

	public UICdmsProjectVO getProject() {
		return project;
	}

	public void setProject(UICdmsProjectVO project) {
		this.project = project;
	}

	public UIMemberVO getResultMember() {
		return resultMember;
	}

	public void setResultMember(UIMemberVO resultMember) {
		this.resultMember = resultMember;
	}

	public UIMemberVO getCancelMember() {
		return cancelMember;
	}

	public void setCancelMember(UIMemberVO cancelMember) {
		this.cancelMember = cancelMember;
	}

	public UIMemberVO getRegMember() {
		return regMember;
	}

	public void setRegMember(UIMemberVO regMember) {
		this.regMember = regMember;
	}

}
