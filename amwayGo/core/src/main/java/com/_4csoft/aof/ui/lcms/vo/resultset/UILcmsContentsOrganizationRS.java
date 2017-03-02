/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.lcms.vo.UILcmsContentsOrganizationVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsContentsVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsItemVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsOrganizationVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo.resultset
 * @File : UILcmsContentsOrganizationRS.java
 * @Title : 콘텐츠 그룹 구성요소
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsContentsOrganizationRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private UILcmsContentsOrganizationVO contentsOrganization;

	/** */
	private UILcmsContentsVO contents;

	/** */
	private UILcmsOrganizationVO organization;

	/** */
	private UILcmsItemVO item;

	public UILcmsContentsOrganizationVO getContentsOrganization() {
		return contentsOrganization;
	}

	public void setContentsOrganization(UILcmsContentsOrganizationVO contentsOrganization) {
		this.contentsOrganization = contentsOrganization;
	}

	public UILcmsContentsVO getContents() {
		return contents;
	}

	public void setContents(UILcmsContentsVO contents) {
		this.contents = contents;
	}

	public UILcmsOrganizationVO getOrganization() {
		return organization;
	}

	public void setOrganization(UILcmsOrganizationVO organization) {
		this.organization = organization;
	}

	public UILcmsItemVO getItem() {
		return item;
	}

	public void setItem(UILcmsItemVO item) {
		this.item = item;
	}

}
