package com._4csoft.aof.ui.board.dto;

import java.io.Serializable;

public class SystemBoardCategoryDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String categoryName;
	private String categoryCode;
	
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getCategoryCode() {
		return categoryCode;
	}
	public void setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
	}
	
}