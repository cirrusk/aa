/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.dto;

import java.io.Serializable;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.infra.dto
 * @File : AgentHeaderDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 24.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class AgentHeaderDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 단말기 가로 사이즈 */
	private String screen_width;

	/** 단말기 세로 사이즈 */
	private String screen_height;

	/** android or ios */
	private String os;

	/** tablet or mobile */
	private String device;

	/** deviceId */
	private String deviceId;

	public String getScreen_width() {
		return screen_width;
	}

	public void setScreen_width(String screen_width) {
		this.screen_width = screen_width;
	}

	public String getScreen_height() {
		return screen_height;
	}

	public void setScreen_height(String screen_height) {
		this.screen_height = screen_height;
	}

	public String getOs() {
		return os;
	}

	public void setOs(String os) {
		this.os = os;
	}

	public String getDevice() {
		return device;
	}

	public void setDevice(String device) {
		this.device = device;
	}

	public String getDeviceId() {
		return deviceId;
	}

	public void setDeviceId(String deviceId) {
		this.deviceId = deviceId;
	}

}
