package com._4csoft.aof.ui.infra.dto;

import java.io.Serializable;

public class UICategoryDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long categorySeq;
	private String categoryName;
	private Long childCount;

	public UICategoryDTO(Long categorySeq, String categoryName, Long childCount) {
		this.categorySeq = categorySeq;
		this.categoryName = categoryName;
		this.childCount = childCount;
	}

	public Long getCategorySeq() {
		return categorySeq;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public Long getChildCount() {
		return childCount;
	}

}
