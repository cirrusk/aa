/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.UIMessageAddressGroupVO;
import com._4csoft.aof.ui.infra.vo.UIMessageAddressVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.infra.vo.resultset
 * @File : UIMessageAddressGroupRS.java
 * @Title : 메시지주소록 그룹
 * @date : 2014. 1. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMessageAddressGroupRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 주소록 구성원 */
	private UIMessageAddressVO messageAddress;

	/** 주소록 */
	private UIMessageAddressGroupVO messageAddressGroup;

	/** 회원 */
	private UIMemberVO member;

	public UIMessageAddressVO getMessageAddress() {
		return messageAddress;
	}

	public void setMessageAddress(UIMessageAddressVO messageAddress) {
		this.messageAddress = messageAddress;
	}

	public UIMessageAddressGroupVO getMessageAddressGroup() {
		return messageAddressGroup;
	}

	public void setMessageAddressGroup(UIMessageAddressGroupVO messageAddressGroup) {
		this.messageAddressGroup = messageAddressGroup;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}
}
