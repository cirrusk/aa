/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.CategoryVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UICategoryVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICategoryVO extends CategoryVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 하위분류수 */
	private Long childCount;

	/** 멀티 수정/삭제 처리 */
	private Long[] categorySeqs;

	/** 멀티 수정 처리 */
	private String[] groupOrders;

	/** 멀티 수정 처리 */
	private String[] sortOrders;

	/** 멀티 수정 처리 */
	private String[] categoryNames;

	public Long getChildCount() {
		return childCount;
	}

	public void setChildCount(Long childCount) {
		this.childCount = childCount;
	}

	public Long[] getCategorySeqs() {
		return categorySeqs;
	}

	public void setCategorySeqs(Long[] categorySeqs) {
		this.categorySeqs = categorySeqs;
	}

	public String[] getGroupOrders() {
		return groupOrders;
	}

	public void setGroupOrders(String[] groupOrders) {
		this.groupOrders = groupOrders;
	}

	public String[] getSortOrders() {
		return sortOrders;
	}

	public void setSortOrders(String[] sortOrders) {
		this.sortOrders = sortOrders;
	}

	public String[] getCategoryNames() {
		return categoryNames;
	}

	public void setCategoryNames(String[] categoryNames) {
		this.categoryNames = categoryNames;
	}

}
