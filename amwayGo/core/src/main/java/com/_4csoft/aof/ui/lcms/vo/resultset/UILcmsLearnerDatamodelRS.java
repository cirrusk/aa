/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.lcms.vo.UILcmsItemVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsLearnerDatamodelVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsOrganizationVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveOrganizationItemVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyAttendVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo.resultset
 * @File : UILcmsLearnerDatamodelRS.java
 * @Title : 학습자 데이터 모델
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsLearnerDatamodelRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private UILcmsLearnerDatamodelVO learnerDatamodel;

	/** */
	private UILcmsOrganizationVO organization;

	/** */
	private UILcmsItemVO item;

	/** */
	private UIUnivCourseApplyAttendVO attend;

	/** 학습요소 교시 학습보조자료 */
	private UIUnivCourseActiveOrganizationItemVO activeItem;

	public UILcmsLearnerDatamodelVO getLearnerDatamodel() {
		return learnerDatamodel;
	}

	public void setLearnerDatamodel(UILcmsLearnerDatamodelVO learnerDatamodel) {
		this.learnerDatamodel = learnerDatamodel;
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

	public UIUnivCourseApplyAttendVO getAttend() {
		return attend;
	}

	public void setAttend(UIUnivCourseApplyAttendVO attend) {
		this.attend = attend;
	}

	public UIUnivCourseActiveOrganizationItemVO getActiveItem() {
		return activeItem;
	}

	public void setActiveItem(UIUnivCourseActiveOrganizationItemVO activeItem) {
		this.activeItem = activeItem;
	}

}
