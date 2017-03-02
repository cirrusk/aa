/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo;

import java.io.Serializable;

import com._4csoft.aof.cdms.vo.CdmsStudioTimeVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo
 * @File : UICdmsStudioTimeVO.java
 * @Title : CDMS 스튜디오 시간
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsStudioTimeVO extends CdmsStudioTimeVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long[] studioTimeSeqs;
	private Long[] sortOrders;
	private String[] startTimes;
	private String[] endTimes;
	private Long[] deleteStudioTimeSeqs;

	public Long[] getStudioTimeSeqs() {
		return studioTimeSeqs;
	}

	public void setStudioTimeSeqs(Long[] studioTimeSeqs) {
		this.studioTimeSeqs = studioTimeSeqs;
	}

	public Long[] getSortOrders() {
		return sortOrders;
	}

	public void setSortOrders(Long[] sortOrders) {
		this.sortOrders = sortOrders;
	}

	public String[] getStartTimes() {
		return startTimes;
	}

	public void setStartTimes(String[] startTimes) {
		this.startTimes = startTimes;
	}

	public String[] getEndTimes() {
		return endTimes;
	}

	public void setEndTimes(String[] endTimes) {
		this.endTimes = endTimes;
	}

	public Long[] getDeleteStudioTimeSeqs() {
		return deleteStudioTimeSeqs;
	}

	public void setDeleteStudioTimeSeqs(Long[] deleteStudioTimeSeqs) {
		this.deleteStudioTimeSeqs = deleteStudioTimeSeqs;
	}

}
