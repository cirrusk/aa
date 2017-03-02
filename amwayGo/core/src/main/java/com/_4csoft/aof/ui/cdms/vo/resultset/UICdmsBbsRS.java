/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsBbsVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsSectionVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo.resultset
 * @File : UICdmsBbsRS.java
 * @Title : CDMS 개발게시판
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsBbsRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UICdmsBbsVO bbs;
	private UICdmsProjectVO project;
	private UICdmsSectionVO section;

	public UICdmsBbsVO getBbs() {
		return bbs;
	}

	public void setBbs(UICdmsBbsVO bbs) {
		this.bbs = bbs;
	}

	public UICdmsProjectVO getProject() {
		return project;
	}

	public void setProject(UICdmsProjectVO project) {
		this.project = project;
	}

	public UICdmsSectionVO getSection() {
		return section;
	}

	public void setSection(UICdmsSectionVO section) {
		this.section = section;
	}

}
