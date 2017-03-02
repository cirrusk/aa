/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.RolegroupMemberVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UIRolegroupMemberVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIRolegroupMemberVO extends RolegroupMemberVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 멀티 수정 처리 */
	private Long[] rolegroupSeqs;

	/** 멀티 수정 처리 */
	private Long[] memberSeqs;

	public Long[] getRolegroupSeqs() {
		return rolegroupSeqs;
	}

	public void setRolegroupSeqs(Long[] rolegroupSeqs) {
		this.rolegroupSeqs = rolegroupSeqs;
	}

	public Long[] getMemberSeqs() {
		return memberSeqs;
	}

	public void setMemberSeqs(Long[] memberSeqs) {
		this.memberSeqs = memberSeqs;
	}
}
