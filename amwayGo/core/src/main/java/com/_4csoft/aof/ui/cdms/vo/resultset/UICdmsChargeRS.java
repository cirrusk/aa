/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsChargeVO;
import com._4csoft.aof.ui.infra.vo.UICompanyMemberVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo.resultset
 * @File : UICdmsChargeRS.java
 * @Title : CDMS 담당자
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsChargeRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UICdmsChargeVO charge;
	private UIMemberVO member;
	private UICompanyMemberVO companyMember;

	public UICdmsChargeVO getCharge() {
		return charge;
	}

	public void setCharge(UICdmsChargeVO charge) {
		this.charge = charge;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

	public UICompanyMemberVO getCompanyMember() {
		return companyMember;
	}

	public void setCompanyMember(UICompanyMemberVO companyMember) {
		this.companyMember = companyMember;
	}

}
