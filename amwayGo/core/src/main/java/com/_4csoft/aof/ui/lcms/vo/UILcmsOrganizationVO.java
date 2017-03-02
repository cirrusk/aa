/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo;

import java.io.Serializable;

import com._4csoft.aof.lcms.vo.LcmsOrganizationVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo
 * @File : UILcmsOrganizationVO.java
 * @Title : 학습구조(차시)
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsOrganizationVO extends LcmsOrganizationVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private String memberName; // 소유자명

	/** */
	private Long[] organizationSeqs;

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public Long[] getOrganizationSeqs() {
		return organizationSeqs;
	}

	public void setOrganizationSeqs(Long[] organizationSeqs) {
		this.organizationSeqs = organizationSeqs;
	}

}
