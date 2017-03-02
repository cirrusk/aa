package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;
import java.util.List;

public class YearDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String nowYearTerm;
	private List<YearSetDTO> codeList;
	
	public String getNowYearTerm() {
		return nowYearTerm;
	}
	public void setNowYearTerm(String nowYearTerm) {
		this.nowYearTerm = nowYearTerm;
	}
	public List<YearSetDTO> getCodeList() {
		return codeList;
	}
	public void setCodeList(List<YearSetDTO> codeList) {
		this.codeList = codeList;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}
