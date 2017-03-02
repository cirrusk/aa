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
import com._4csoft.aof.ui.univ.vo.UIUnivCategoryVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.infra.vo.resultset
 * @File : UIMessageAddressRS.java
 * @Title : 메시지주소록 그룹 구성원
 * @date : 2014. 1. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMessageAddressRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 주소록 구성원 */
	private UIMessageAddressVO messageAddress;

	/** 주소록 */
	private UIMessageAddressGroupVO messageAddressGroup;

	/** 회원 */
	private UIMemberVO member;
	
	/** 소속학과 */
	private UIUnivCategoryVO category;

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

	public UIUnivCategoryVO getCategory() {
		return category;
	}

	public void setCategory(UIUnivCategoryVO category) {
		this.category = category;
	}

}
