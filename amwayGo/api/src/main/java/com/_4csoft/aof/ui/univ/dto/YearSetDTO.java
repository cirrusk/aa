package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

public class YearSetDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String yearTerm;
	private String yearTermName;
	
	public String getYearTerm() {
		return yearTerm;
	}
	public void setYearTerm(String yearTerm) {
		this.yearTerm = yearTerm;
	}
	public String getYearTermName() {
		return yearTermName;
	}
	public void setYearTermName(String yearTermName) {
		this.yearTermName = yearTermName;
	}
}
