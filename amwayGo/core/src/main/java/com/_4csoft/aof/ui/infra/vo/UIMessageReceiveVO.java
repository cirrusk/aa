/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.MessageReceiveVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UIMessageReceiveVO.java
 * @Title : 받은메시지
 * @date : 2014. 1. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMessageReceiveVO extends MessageReceiveVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private Long[] messageSendSeqs;

	/** */
	private Long[] messageReceiveSeqs;

	/** */
	private Long[] receiveMemberSeqs;

	/** 맴버 seq ARRAY */
	private Long[] memberSeqs;

	/** 주소록 그룹 seq */
	private Long[] addressGroupSeqs;
	
	/** 맴버 이름 ARRAY */
	private	String[] memberNames;
	
	/** 맴버 이름 */
	private String memberName;

	public Long[] getMessageSendSeqs() {
		return messageSendSeqs;
	}

	public void setMessageSendSeqs(Long[] messageSendSeqs) {
		this.messageSendSeqs = messageSendSeqs;
	}

	public Long[] getMessageReceiveSeqs() {
		return messageReceiveSeqs;
	}

	public void setMessageReceiveSeqs(Long[] messageReceiveSeqs) {
		this.messageReceiveSeqs = messageReceiveSeqs;
	}

	public Long[] getReceiveMemberSeqs() {
		return receiveMemberSeqs;
	}

	public void setReceiveMemberSeqs(Long[] receiveMemberSeqs) {
		this.receiveMemberSeqs = receiveMemberSeqs;
	}

	public Long[] getMemberSeqs() {
		return memberSeqs;
	}

	public void setMemberSeqs(Long[] memberSeqs) {
		this.memberSeqs = memberSeqs;
	}

	public Long[] getAddressGroupSeqs() {
		return addressGroupSeqs;
	}

	public void setAddressGroupSeqs(Long[] addressGroupSeqs) {
		this.addressGroupSeqs = addressGroupSeqs;
	}

	public String[] getMemberNames() {
		return memberNames;
	}

	public void setMemberNames(String[] memberNames) {
		this.memberNames = memberNames;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
}
