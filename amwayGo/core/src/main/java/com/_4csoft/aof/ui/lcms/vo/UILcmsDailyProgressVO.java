/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo;

import java.io.Serializable;

import com._4csoft.aof.lcms.vo.LcmsDailyProgressVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo
 * @File : UILcmsDailyProgressVO.java
 * @Title : 일일진도율
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsDailyProgressVO extends LcmsDailyProgressVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private Long sumSessionTime;

	/** */
	private Long sumAttempt;

	/** */
	private Double sumProgressMeasure;

	public Long getSumSessionTime() {
		return sumSessionTime;
	}

	public void setSumSessionTime(Long sumSessionTime) {
		this.sumSessionTime = sumSessionTime;
	}

	public Long getSumAttempt() {
		return sumAttempt;
	}

	public void setSumAttempt(Long sumAttempt) {
		this.sumAttempt = sumAttempt;
	}

	public Double getSumProgressMeasure() {
		return sumProgressMeasure;
	}

	public void setSumProgressMeasure(Double sumProgressMeasure) {
		this.sumProgressMeasure = sumProgressMeasure;
	}

}
