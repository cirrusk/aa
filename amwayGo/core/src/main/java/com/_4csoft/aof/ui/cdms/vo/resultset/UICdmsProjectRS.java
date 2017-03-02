/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.resultset;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsOutputVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectGroupVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsSectionVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo.resultset
 * @File : UICdmsProjectRS.java
 * @Title : CDMS 프로젝트(과목)
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsProjectRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UICdmsProjectVO project;
	private UICdmsSectionVO currentSection;
	private UICdmsOutputVO currentOutput;
	private UICdmsSectionVO nextSection;
	private UICdmsOutputVO nextOutput;
	private UICdmsProjectGroupVO projectGroup;
	private List<UICdmsSectionRS> listSection;
	private List<UICdmsProjectCompanyRS> listCompany;
	private List<UICdmsProjectMemberRS> listProjectMember;
	private List<UICdmsProjectMemberRS> listProjectGroupMember;
	private List<UICdmsCommentRS> listComment;

	public UICdmsProjectVO getProject() {
		return project;
	}

	public void setProject(UICdmsProjectVO project) {
		this.project = project;
	}

	public UICdmsSectionVO getCurrentSection() {
		return currentSection;
	}

	public void setCurrentSection(UICdmsSectionVO currentSection) {
		this.currentSection = currentSection;
	}

	public UICdmsOutputVO getCurrentOutput() {
		return currentOutput;
	}

	public void setCurrentOutput(UICdmsOutputVO currentOutput) {
		this.currentOutput = currentOutput;
	}

	public UICdmsSectionVO getNextSection() {
		return nextSection;
	}

	public void setNextSection(UICdmsSectionVO nextSection) {
		this.nextSection = nextSection;
	}

	public UICdmsOutputVO getNextOutput() {
		return nextOutput;
	}

	public void setNextOutput(UICdmsOutputVO nextOutput) {
		this.nextOutput = nextOutput;
	}

	public UICdmsProjectGroupVO getProjectGroup() {
		return projectGroup;
	}

	public void setProjectGroup(UICdmsProjectGroupVO projectGroup) {
		this.projectGroup = projectGroup;
	}

	public List<UICdmsSectionRS> getListSection() {
		return listSection;
	}

	public void setListSection(List<UICdmsSectionRS> listSection) {
		this.listSection = listSection;
	}

	public List<UICdmsProjectCompanyRS> getListCompany() {
		return listCompany;
	}

	public void setListCompany(List<UICdmsProjectCompanyRS> listCompany) {
		this.listCompany = listCompany;
	}

	public List<UICdmsProjectMemberRS> getListProjectMember() {
		return listProjectMember;
	}

	public void setListProjectMember(List<UICdmsProjectMemberRS> listProjectMember) {
		this.listProjectMember = listProjectMember;
	}

	public List<UICdmsProjectMemberRS> getListProjectGroupMember() {
		return listProjectGroupMember;
	}

	public void setListProjectGroupMember(List<UICdmsProjectMemberRS> listProjectGroupMember) {
		this.listProjectGroupMember = listProjectGroupMember;
	}

	public List<UICdmsCommentRS> getListComment() {
		return listComment;
	}

	public void setListComment(List<UICdmsCommentRS> listComment) {
		this.listComment = listComment;
	}

}
