/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UICategoryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivCourseMasterRS.java
 * @Title : 교과목
 * @date : 2014. 2. 20.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseMasterRS extends ResultSet implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 교과목 */
	private UIUnivCourseMasterVO courseMaster;
	/** 분류 */
	private UICategoryVO category;

	public UIUnivCourseMasterVO getCourseMaster() {
		return courseMaster;
	}

	public void setCourseMaster(UIUnivCourseMasterVO courseMaster) {
		this.courseMaster = courseMaster;
	}

	public UICategoryVO getCategory() {
		return category;
	}

	public void setCategory(UICategoryVO category) {
		this.category = category;
	}

}
