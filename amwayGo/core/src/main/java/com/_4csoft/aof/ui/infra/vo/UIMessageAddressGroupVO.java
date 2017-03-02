/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.MessageAddressGroupVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UIMessageAddressGroupVO.java
 * @Title : 메시지 주소록 그룹
 * @date : 2014. 1. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMessageAddressGroupVO extends MessageAddressGroupVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 각 그룹에 인원 숫자 */
	private int memberCount;

	/** 주소록그룹 일련번호 */
	private Long[] addressGroupSeqs;

	/** 주소록그룹 이름 */
	private String[] groupNames;

	public int getMemberCount() {
		return memberCount;
	}

	public void setMemberCount(int memberCount) {
		this.memberCount = memberCount;
	}

	public Long[] getAddressGroupSeqs() {
		return addressGroupSeqs;
	}

	public void setAddressGroupSeqs(Long[] addressGroupSeqs) {
		this.addressGroupSeqs = addressGroupSeqs;
	}

	public String[] getGroupNames() {
		return groupNames;
	}

	public void setGroupNames(String[] groupNames) {
		this.groupNames = groupNames;
	}

}
