/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo.resultset;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.lcms.vo.UILcmsContentsVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo.resultset
 * @File : UILcmsContentsRS.java
 * @Title : 콘텐츠 그룹
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsContentsRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private UILcmsContentsVO contents;

	/** */
	private List<UILcmsOrganizationRS> listOrganization;

	public UILcmsContentsVO getContents() {
		return contents;
	}

	public void setContents(UILcmsContentsVO contents) {
		this.contents = contents;
	}

	public List<UILcmsOrganizationRS> getListOrganization() {
		return listOrganization;
	}

	public void setListOrganization(List<UILcmsOrganizationRS> listOrganization) {
		this.listOrganization = listOrganization;
	}

}
