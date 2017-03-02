package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

public class LearnerDatamodelDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long itemSeq;
	private String title;
	private String attempt;
	private String sessionTime;
	private String progressMeasure;
	private String attendTypeCd;
	private String fileName;
	private String fileUrl;
	private String mobileYn;
	private String androidUrl;
	private String iosUrl;
	
	public Long getItemSeq() {
		return itemSeq;
	}
	public void setItemSeq(Long itemSeq) {
		this.itemSeq = itemSeq;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getAttempt() {
		return attempt;
	}
	public void setAttempt(String attempt) {
		this.attempt = attempt;
	}
	public String getSessionTime() {
		return sessionTime;
	}
	public void setSessionTime(String sessionTime) {
		this.sessionTime = sessionTime;
	}
	public String getProgressMeasure() {
		return progressMeasure;
	}
	public void setProgressMeasure(String progressMeasure) {
		this.progressMeasure = progressMeasure;
	}
	public String getAttendTypeCd() {
		return attendTypeCd;
	}
	public void setAttendTypeCd(String attendTypeCd) {
		this.attendTypeCd = attendTypeCd;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFileUrl() {
		return fileUrl;
	}
	public void setFileUrl(String fileUrl) {
		this.fileUrl = fileUrl;
	}
	public String getMobileYn() {
		return mobileYn;
	}
	public void setMobileYn(String mobileYn) {
		this.mobileYn = mobileYn;
	}
	public String getAndroidUrl() {
		return androidUrl;
	}
	public void setAndroidUrl(String androidUrl) {
		this.androidUrl = androidUrl;
	}
	public String getIosUrl() {
		return iosUrl;
	}
	public void setIosUrl(String iosUrl) {
		this.iosUrl = iosUrl;
	}

}