/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseMasterVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseMasterVO.java
 * @Title : 교과목
 * @date : 2014. 2. 20.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseMasterVO extends UnivCourseMasterVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 교과목 일련번호 Array */
	private Long[] courseMasterSeqs;

	/** 소속학과 Array */
	private Long[] categoryOrganizationSeqs;

	public Long[] getCourseMasterSeqs() {
		return courseMasterSeqs;
	}

	public void setCourseMasterSeqs(Long[] courseMasterSeqs) {
		this.courseMasterSeqs = courseMasterSeqs;
	}

	public Long[] getCategoryOrganizationSeqs() {
		return categoryOrganizationSeqs;
	}

	public void setCategoryOrganizationSeqs(Long[] categoryOrganizationSeqs) {
		this.categoryOrganizationSeqs = categoryOrganizationSeqs;
	}

}
