/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import com._4csoft.aof.infra.vo.PushMessageTargetVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UIPushMessageTargetVO.java
 * @Title : 푸시메지시 전송 대상자
 * @date : 2015. 3. 25.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIPushMessageTargetVO extends PushMessageTargetVO {
	private static final long serialVersionUID = 1L;

	/** 회원일련번호 Arrays */
	private Long[] memberSeqs;

	/** 회원명 Arrays */
	private String[] memberNames;

	/** 푸시 발송 여부 */
	private String[] pushYns;

	/** 운영과정 일련번호 */
	private Long courseActiveSeq;

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

	public String[] getPushYns() {
		return pushYns;
	}

	public void setPushYns(String[] pushYns) {
		this.pushYns = pushYns;
	}

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}
}
