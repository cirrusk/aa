/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioMemberVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo.resultset
 * @File : UICdmsStudioMemberRS.java
 * @Title : CDMS 스튜디오 담당자
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsStudioMemberRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UICdmsStudioMemberVO studioMember;
	private UIMemberVO member;

	public UICdmsStudioMemberVO getStudioMember() {
		return studioMember;
	}

	public void setStudioMember(UICdmsStudioMemberVO studioMember) {
		this.studioMember = studioMember;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

}
