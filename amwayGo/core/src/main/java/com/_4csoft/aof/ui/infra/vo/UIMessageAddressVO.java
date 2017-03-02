/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.MessageAddressVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UIMessageAddressVO.java
 * @Title : 메시지 주소록 그룹 구성원
 * @date : 2014. 1. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMessageAddressVO extends MessageAddressVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 맴버 seq ARRAY */
	private Long[] memberSeqs;

	/** 맴버 이름 ARRAY */
	private String[] memberNames;

	/** 주소록 그룹 seq */
	private Long[] addressGroupSeqs;

	/** 맴버 이름 */
	private String memberName;

	public Long[] getMemberSeqs() {
		return memberSeqs;
	}

	public void setMemberSeqs(Long[] memberSeqs) {
		this.memberSeqs = memberSeqs;
	}

	public String[] getMemberNames() {
		return memberNames;
	}

	public void setMemberNames(String[] memberNames) {
		this.memberNames = memberNames;
	}

	public Long[] getAddressGroupSeqs() {
		return addressGroupSeqs;
	}

	public void setAddressGroupSeqs(Long[] addressGroupSeqs) {
		this.addressGroupSeqs = addressGroupSeqs;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

}
