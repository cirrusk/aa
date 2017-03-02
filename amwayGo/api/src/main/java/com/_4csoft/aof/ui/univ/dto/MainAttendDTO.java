package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

public class MainAttendDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long attend;
	private Long perception;
	private Long absence;
	
	public Long getAttend() {
		return attend;
	}
	public void setAttend(Long attend) {
		this.attend = attend;
	}
	public Long getPerception() {
		return perception;
	}
	public void setPerception(Long perception) {
		this.perception = perception;
	}
	public Long getAbsence() {
		return absence;
	}
	public void setAbsence(Long absence) {
		this.absence = absence;
	}
}