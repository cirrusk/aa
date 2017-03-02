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
 * @File : UIMemoReceiveCondition.java
 * @Title : 받은쪽지
 * @date : 2014. 1. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMessageReceiveCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private Long srchReceiveMemberSeq;
	
	/** */
	private Long srchMemberSeq;
	
	/** */
	private Long srchTargetMemberSeq;

	/** */
	private String srchKeepYn;

	/** cs_message_send_seq : 메시지발송 일련번호 */
	private Long srchMessageSendSeq;
	
	/** cs_message_type_cd : 메세지 형태 */
	private String srchMessageTypeCd;

	public Long getSrchReceiveMemberSeq() {
		return srchReceiveMemberSeq;
	}

	public void setSrchReceiveMemberSeq(Long srchReceiveMemberSeq) {
		this.srchReceiveMemberSeq = srchReceiveMemberSeq;
	}

	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}

	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}

	public Long getSrchTargetMemberSeq() {
		return srchTargetMemberSeq;
	}

	public void setSrchTargetMemberSeq(Long srchTargetMemberSeq) {
		this.srchTargetMemberSeq = srchTargetMemberSeq;
	}

	public String getSrchKeepYn() {
		return srchKeepYn;
	}

	public void setSrchKeepYn(String srchKeepYn) {
		this.srchKeepYn = srchKeepYn;
	}

	public Long getSrchMessageSendSeq() {
		return srchMessageSendSeq;
	}

	public void setSrchMessageSendSeq(Long srchMessageSendSeq) {
		this.srchMessageSendSeq = srchMessageSendSeq;
	}

	public String getSrchMessageTypeCd() {
		return srchMessageTypeCd;
	}

	public void setSrchMessageTypeCd(String srchMessageTypeCd) {
		this.srchMessageTypeCd = srchMessageTypeCd;
	}

}
