/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo;

import java.io.Serializable;

import com._4csoft.aof.lcms.vo.LcmsItemVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo
 * @File : UILcmsItemVO.java
 * @Title : 학습요소(강)
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsItemVO extends LcmsItemVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private Long[] itemSeqs;

	/** */
	private Long[] sortOrders;

	/** */
	private String[] titles;

	/** */
	private Long[] resourceSeqs;

	/** */
	private String[] hrefs;

	/** */
	private String[] completionThresholds;

	/** */
	private String[] completionTypes;

	public Long[] getItemSeqs() {
		return itemSeqs;
	}

	public void setItemSeqs(Long[] itemSeqs) {
		this.itemSeqs = itemSeqs;
	}

	public Long[] getSortOrders() {
		return sortOrders;
	}

	public void setSortOrders(Long[] sortOrders) {
		this.sortOrders = sortOrders;
	}

	public String[] getTitles() {
		return titles;
	}

	public void setTitles(String[] titles) {
		this.titles = titles;
	}

	public Long[] getResourceSeqs() {
		return resourceSeqs;
	}

	public void setResourceSeqs(Long[] resourceSeqs) {
		this.resourceSeqs = resourceSeqs;
	}

	public String[] getHrefs() {
		return hrefs;
	}

	public void setHrefs(String[] hrefs) {
		this.hrefs = hrefs;
	}

	public String[] getCompletionThresholds() {
		return completionThresholds;
	}

	public void setCompletionThresholds(String[] completionThresholds) {
		this.completionThresholds = completionThresholds;
	}

	public String[] getCompletionTypes() {
		return completionTypes;
	}

	public void setCompletionTypes(String[] completionTypes) {
		this.completionTypes = completionTypes;
	}

}
