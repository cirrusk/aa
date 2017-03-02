/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo;

import java.io.Serializable;

import com._4csoft.aof.lcms.vo.LcmsContentsOrganizationVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo
 * @File : UILcmsContentsOrganizationVO.java
 * @Title : 콘텐츠 그룹 요소
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsContentsOrganizationVO extends LcmsContentsOrganizationVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private Long[] contentsSeqs;

	/** */
	private Long[] organizationSeqs;

	/** */
	private Long[] sortOrders;

	public Long[] getContentsSeqs() {
		return contentsSeqs;
	}

	public void setContentsSeqs(Long[] contentsSeqs) {
		this.contentsSeqs = contentsSeqs;
	}

	public Long[] getOrganizationSeqs() {
		return organizationSeqs;
	}

	public void setOrganizationSeqs(Long[] organizationSeqs) {
		this.organizationSeqs = organizationSeqs;
	}

	public Long[] getSortOrders() {
		return sortOrders;
	}

	public void setSortOrders(Long[] sortOrders) {
		this.sortOrders = sortOrders;
	}

}
