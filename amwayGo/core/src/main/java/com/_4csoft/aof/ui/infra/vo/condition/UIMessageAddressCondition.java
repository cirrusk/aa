/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.infra.vo.condition
 * @File : UIMessageAddressGroupMemberCondition.java
 * @Title : 쪽지 주소록 그룹 구성원
 * @date : 2014. 1. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMessageAddressCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 검색 주소록 그룹 */
	private Long srchMessageAddressGroupSeq;
	
	/** 검색 주소록 그룹 */
	private Long addressGroupSeq;
	
	/** cs_reg_member_seq */
	private Long regMemberSeq;
	
	public Long getSrchMessageAddressGroupSeq() {
		return srchMessageAddressGroupSeq;
	}

	public void setSrchMessageAddressGroupSeq(Long srchMessageAddressGroupSeq) {
		this.srchMessageAddressGroupSeq = srchMessageAddressGroupSeq;
	}

	public Long getAddressGroupSeq() {
		return addressGroupSeq;
	}

	public void setAddressGroupSeq(Long addressGroupSeq) {
		this.addressGroupSeq = addressGroupSeq;
	}

	public Long getRegMemberSeq() {
		return regMemberSeq;
	}

	public void setRegMemberSeq(Long regMemberSeq) {
		this.regMemberSeq = regMemberSeq;
	}
}
