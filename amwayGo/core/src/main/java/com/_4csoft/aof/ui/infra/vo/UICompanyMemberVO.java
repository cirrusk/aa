/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.CompanyMemberVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UICompanyMemberVO.java
 * @Title : 소속 멤버
 * @date : 2013. 9. 2.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICompanyMemberVO extends CompanyMemberVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 멀티 삭제 처리 */
	private Long[] memberSeqs;

	public Long[] getMemberSeqs() {
		return memberSeqs;
	}

	public void setMemberSeqs(Long[] memberSeqs) {
		this.memberSeqs = memberSeqs;
	}

}
