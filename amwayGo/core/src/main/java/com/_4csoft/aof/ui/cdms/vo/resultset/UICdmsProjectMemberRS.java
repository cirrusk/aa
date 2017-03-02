/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectMemberVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectVO;
import com._4csoft.aof.ui.infra.vo.UICompanyMemberVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo.resultset
 * @File : UICdmsProjectMemberRS.java
 * @Title : CDMS 프로젝트 참여회원
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsProjectMemberRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UICdmsProjectMemberVO projectMember;
	private UIMemberVO member;
	private UICompanyMemberVO companyMember;
	private UICdmsProjectVO project;

	public UICdmsProjectMemberVO getProjectMember() {
		return projectMember;
	}

	public void setProjectMember(UICdmsProjectMemberVO projectMember) {
		this.projectMember = projectMember;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

	public UICompanyMemberVO getCompanyMember() {
		return companyMember;
	}

	public void setCompanyMember(UICompanyMemberVO companyMember) {
		this.companyMember = companyMember;
	}

	public UICdmsProjectVO getProject() {
		return project;
	}

	public void setProject(UICdmsProjectVO project) {
		this.project = project;
	}

}
