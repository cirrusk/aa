/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.lcms.vo.resultset.UILcmsLearnerDatamodelRS;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseActiveElementRS.java
 * @Title : 주차관리
 * @date : 2014. 2. 26.
 * @author : 장용기
 * @descrption :
 * 
 */
public class UIUnivCourseActiveElementRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UIUnivCourseActiveElementVO element;

	private List<UILcmsLearnerDatamodelRS> itemResultList;

	public UIUnivCourseActiveElementVO getElement() {
		return element;
	}

	public void setElement(UIUnivCourseActiveElementVO element) {
		this.element = element;
	}

	public List<UILcmsLearnerDatamodelRS> getItemResultList() {
		return itemResultList;
	}

	public void setItemResultList(List<UILcmsLearnerDatamodelRS> itemResultList) {
		this.itemResultList = itemResultList;
	}

}
