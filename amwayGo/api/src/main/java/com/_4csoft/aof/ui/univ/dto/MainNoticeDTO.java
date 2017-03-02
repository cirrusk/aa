package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

public class MainNoticeDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String title;
	private String detailUrl;
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDetailUrl() {
		return detailUrl;
	}
	public void setDetailUrl(String detailUrl) {
		this.detailUrl = detailUrl;
	}
	
}