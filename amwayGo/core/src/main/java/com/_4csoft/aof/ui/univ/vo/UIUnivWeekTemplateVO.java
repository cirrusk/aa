/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivWeekTemplateVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivWeekTemplateVO.java
 * @Title : 주차템플릿 VO
 * @date : 2014. 2. 19.
 * @author : 김현우
 * @descrption : 주차템플릿 VO
 */
public class UIUnivWeekTemplateVO extends UnivWeekTemplateVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 시작일시 다중등록 변수 */
	private String[] startDtimes;

	/** 종료일시 다중등록 변수 */
	private String[] endDtimes;

	public String[] getStartDtimes() {
		return startDtimes;
	}

	public void setStartDtimes(String[] startDtimes) {
		this.startDtimes = startDtimes;
	}

	public String[] getEndDtimes() {
		return endDtimes;
	}

	public void setEndDtimes(String[] endDtimes) {
		this.endDtimes = endDtimes;
	}

}
