package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

public class MainOnlineDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int totalWeek;
	private int totalLecture;
	private Long totalStudyCount;
	
	public int getTotalWeek() {
		return totalWeek;
	}
	public void setTotalWeek(int totalWeek) {
		this.totalWeek = totalWeek;
	}
	public int getTotalLecture() {
		return totalLecture;
	}
	public void setTotalLecture(int totalLecture) {
		this.totalLecture = totalLecture;
	}
	public Long getTotalStudyCount() {
		return totalStudyCount;
	}
	public void setTotalStudyCount(Long totalStudyCount) {
		this.totalStudyCount = totalStudyCount;
	}
	
}