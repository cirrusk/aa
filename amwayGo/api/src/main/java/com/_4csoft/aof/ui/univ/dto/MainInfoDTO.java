package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

public class MainInfoDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String completeDivisionName;
	private Long completeDivisionPoint;
	private String profName;
	
	public String getCompleteDivisionName() {
		return completeDivisionName;
	}
	public void setCompleteDivisionName(String completeDivisionName) {
		this.completeDivisionName = completeDivisionName;
	}
	public Long getCompleteDivisionPoint() {
		return completeDivisionPoint;
	}
	public void setCompleteDivisionPoint(Long completeDivisionPoint) {
		this.completeDivisionPoint = completeDivisionPoint;
	}
	public String getProfName() {
		return profName;
	}
	public void setProfName(String profName) {
		this.profName = profName;
	}
	
	

}
