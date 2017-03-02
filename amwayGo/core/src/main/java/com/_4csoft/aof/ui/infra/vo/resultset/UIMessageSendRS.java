/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.UIMessageReceiveVO;
import com._4csoft.aof.ui.infra.vo.UIMessageSendVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.infra.vo.resultset
 * @File : UIMessageSendRS.java
 * @Title : 보낸메시지
 * @date : 2014. 1. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMessageSendRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private UIMessageSendVO messageSend;

	/** */
	private UIMessageReceiveVO messageReceive;

	/** */
	private UIMemberVO sendMember;

	/** */
	private UIMemberVO receiveMember;

	public UIMessageSendVO getMessageSend() {
		return messageSend;
	}

	public void setMessageSend(UIMessageSendVO messageSend) {
		this.messageSend = messageSend;
	}

	public UIMessageReceiveVO getMessageReceive() {
		return messageReceive;
	}

	public void setMessageReceive(UIMessageReceiveVO messageReceive) {
		this.messageReceive = messageReceive;
	}

	public UIMemberVO getSendMember() {
		return sendMember;
	}

	public void setSendMember(UIMemberVO sendMember) {
		this.sendMember = sendMember;
	}

	public UIMemberVO getReceiveMember() {
		return receiveMember;
	}

	public void setReceiveMember(UIMemberVO receiveMember) {
		this.receiveMember = receiveMember;
	}

}
