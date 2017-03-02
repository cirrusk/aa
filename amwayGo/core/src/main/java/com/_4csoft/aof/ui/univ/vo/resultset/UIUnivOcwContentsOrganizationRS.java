/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.lcms.vo.UILcmsItemVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsOrganizationVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveOrganizationItemVO;
import com._4csoft.aof.ui.univ.vo.UIUnivOcwContentsOrganizationVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivOcwContentsOrganizationRS.java
 * @Title : ocw 학습구성요소 ResultSet
 * @date : 2014. 5. 15.
 * @author : 김현우
 * @descrption : ocw 학습구성요소 ResultSet
 */
public class UIUnivOcwContentsOrganizationRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** ocw 과목 vo */
	private UIUnivOcwContentsOrganizationVO ocwContents;

	/** 주차요소 vo */
	private UIUnivCourseActiveElementVO element;

	/** 학습요소 교시 학습보조자료 */
	private UIUnivCourseActiveOrganizationItemVO activeItem;

	/** lcms 주차 정보 */
	private UILcmsOrganizationVO organization;

	/** lcms 강 정보 */
	private UILcmsItemVO item;

	public UIUnivOcwContentsOrganizationVO getOcwContents() {
		return ocwContents;
	}

	public void setOcwContents(UIUnivOcwContentsOrganizationVO ocwContents) {
		this.ocwContents = ocwContents;
	}

	public UIUnivCourseActiveElementVO getElement() {
		return element;
	}

	public void setElement(UIUnivCourseActiveElementVO element) {
		this.element = element;
	}

	public UIUnivCourseActiveOrganizationItemVO getActiveItem() {
		return activeItem;
	}

	public void setActiveItem(UIUnivCourseActiveOrganizationItemVO activeItem) {
		this.activeItem = activeItem;
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
