/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.DeviceVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UIDeviceVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 24.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIDeviceVO extends DeviceVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 운영과목 일련번호 */
	private Long courseActiveSeq;

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}
}
