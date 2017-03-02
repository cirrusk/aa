package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

public class YearTermSetDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String yearTerm;
	private String yearTermName;
	private String yearTermDate;
	private String competitionYn;
	
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
	public String getYearTermDate() {
		return yearTermDate;
	}
	public void setYearTermDate(String yearTermDate) {
		this.yearTermDate = yearTermDate;
	}
	public String getCompetitionYn() {
		return competitionYn;
	}
	public void setCompetitionYn(String competitionYn) {
		this.competitionYn = competitionYn;
	}
	
}
