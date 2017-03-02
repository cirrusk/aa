/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCategoryVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCategoryVO.java
 * @Title : 교과목 그룹
 * @date : 2014. 2. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCategoryVO extends UnivCategoryVO implements Serializable {
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

	/** 멀티 수정 처리 */
	private String[] categoryStrings;

	/** 멀티 수정 처리 */
	private String[] oldCategoryStrings;

	/** 카테고리 대상인원 (학과) */
	private Long categoryMemberCount;

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

	public String[] getCategoryStrings() {
		return categoryStrings;
	}

	public void setCategoryStrings(String[] categoryStrings) {
		this.categoryStrings = categoryStrings;
	}

	public String[] getOldCategoryStrings() {
		return oldCategoryStrings;
	}

	public void setOldCategoryStrings(String[] oldCategoryStrings) {
		this.oldCategoryStrings = oldCategoryStrings;
	}

	public Long getCategoryMemberCount() {
		return categoryMemberCount;
	}

	public void setCategoryMemberCount(Long categoryMemberCount) {
		this.categoryMemberCount = categoryMemberCount;
	}

}
