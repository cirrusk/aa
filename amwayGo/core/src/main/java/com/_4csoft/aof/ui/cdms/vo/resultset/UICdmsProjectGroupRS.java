/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.resultset;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectGroupVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.cdms.vo.resultset
 * @File : UICdmsProjectGroupRS.java
 * @Title : 프로젝트 그룹
 * @date : 2014. 3. 13.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsProjectGroupRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UICdmsProjectGroupVO projectGroup;
	private UICdmsProjectVO project;
	private UIMemberVO pmMember;
	private List<UICdmsProjectCompanyRS> listCompany;
	private List<UICdmsProjectMemberRS> listMember;

	public UICdmsProjectGroupVO getProjectGroup() {
		return projectGroup;
	}

	public void setProjectGroup(UICdmsProjectGroupVO projectGroup) {
		this.projectGroup = projectGroup;
	}

	public UICdmsProjectVO getProject() {
		return project;
	}

	public void setProject(UICdmsProjectVO project) {
		this.project = project;
	}

	public UIMemberVO getPmMember() {
		return pmMember;
	}

	public void setPmMember(UIMemberVO pmMember) {
		this.pmMember = pmMember;
	}

	public List<UICdmsProjectCompanyRS> getListCompany() {
		return listCompany;
	}

	public void setListCompany(List<UICdmsProjectCompanyRS> listCompany) {
		this.listCompany = listCompany;
	}

	public List<UICdmsProjectMemberRS> getListMember() {
		return listMember;
	}

	public void setListMember(List<UICdmsProjectMemberRS> listMember) {
		this.listMember = listMember;
	}

}
