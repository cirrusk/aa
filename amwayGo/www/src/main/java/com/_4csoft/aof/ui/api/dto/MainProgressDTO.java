package com._4csoft.aof.ui.api.dto;

import java.io.Serializable;

public class MainProgressDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private Double averagePercent;
	private Double averagePoint;
	private Long averageMaxPoint;
	private Double myPercent;
	private Double myPoint;
	private Long myMaxPoint;
	
	public Double getAveragePercent() {
		return averagePercent;
	}
	public void setAveragePercent(Double averagePercent) {
		this.averagePercent = averagePercent;
	}
	public Double getAveragePoint() {
		return averagePoint;
	}
	public void setAveragePoint(Double averagePoint) {
		this.averagePoint = averagePoint;
	}
	public Long getAverageMaxPoint() {
		return averageMaxPoint;
	}
	public void setAverageMaxPoint(Long averageMaxPoint) {
		this.averageMaxPoint = averageMaxPoint;
	}
	public Double getMyPercent() {
		return myPercent;
	}
	public void setMyPercent(Double myPercent) {
		this.myPercent = myPercent;
	}
	public Double getMyPoint() {
		return myPoint;
	}
	public void setMyPoint(Double myPoint) {
		this.myPoint = myPoint;
	}
	public Long getMyMaxPoint() {
		return myMaxPoint;
	}
	public void setMyMaxPoint(Long myMaxPoint) {
		this.myMaxPoint = myMaxPoint;
	}
	
}