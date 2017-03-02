/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo;

import java.io.Serializable;

import com._4csoft.aof.cdms.vo.CdmsSectionVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo
 * @File : UICdmsSectionVO.java
 * @Title : CDMS 개발단계
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsSectionVO extends CdmsSectionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long[] sectionIndexs;

	private String[] sectionNames;

	// 개발단계 수정 가능 여부(수정화면에서)
	private String sectionEditableYn;

	// 개발단계 수정 가능 여부(수정화면에서)
	private String[] sectionEditableYns;

	// 개발단계 완료 여부(개발대상 상세에서)
	private String sectionCompleteYn;

	public Long[] getSectionIndexs() {
		return sectionIndexs;
	}

	public void setSectionIndexs(Long[] sectionIndexs) {
		this.sectionIndexs = sectionIndexs;
	}

	public String[] getSectionNames() {
		return sectionNames;
	}

	public void setSectionNames(String[] sectionNames) {
		this.sectionNames = sectionNames;
	}

	public String getSectionEditableYn() {
		return sectionEditableYn;
	}

	public void setSectionEditableYn(String sectionEditableYn) {
		this.sectionEditableYn = sectionEditableYn;
	}

	public String[] getSectionEditableYns() {
		return sectionEditableYns;
	}

	public void setSectionEditableYns(String[] sectionEditableYns) {
		this.sectionEditableYns = sectionEditableYns;
	}

	public String getSectionCompleteYn() {
		return sectionCompleteYn;
	}

	public void setSectionCompleteYn(String sectionCompleteYn) {
		this.sectionCompleteYn = sectionCompleteYn;
	}

}
