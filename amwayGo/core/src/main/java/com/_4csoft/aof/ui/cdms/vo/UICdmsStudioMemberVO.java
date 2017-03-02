/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo;

import java.io.Serializable;

import com._4csoft.aof.cdms.vo.CdmsStudioMemberVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo
 * @File : UICdmsStudioMemberVO.java
 * @Title : CDMS 스튜디오 담당자
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsStudioMemberVO extends CdmsStudioMemberVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long[] memberSeqs;
	private Long[] oldMemberSeqs;
	private Long[] deleteMemberSeqs;

	public Long[] getMemberSeqs() {
		return memberSeqs;
	}

	public void setMemberSeqs(Long[] memberSeqs) {
		this.memberSeqs = memberSeqs;
	}

	public Long[] getOldMemberSeqs() {
		return oldMemberSeqs;
	}

	public void setOldMemberSeqs(Long[] oldMemberSeqs) {
		this.oldMemberSeqs = oldMemberSeqs;
	}

	public Long[] getDeleteMemberSeqs() {
		return deleteMemberSeqs;
	}

	public void setDeleteMemberSeqs(Long[] deleteMemberSeqs) {
		this.deleteMemberSeqs = deleteMemberSeqs;
	}

}
