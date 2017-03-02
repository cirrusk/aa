/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.MessageSendVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UIMessageSendVO.java
 * @Title : 보낸메시지
 * @date : 2014. 1. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMessageSendVO extends MessageSendVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 첨부파일 수 */
	private Long attachCount;
	
	/** cs_message_send_seq : 메시지발송 일련번호 */
	private Long[] messageSendSeqs;

	public Long getAttachCount() {
		return attachCount;
	}

	public void setAttachCount(Long attachCount) {
		this.attachCount = attachCount;
	}

	public Long[] getMessageSendSeqs() {
		return messageSendSeqs;
	}

	public void setMessageSendSeqs(Long[] messageSendSeqs) {
		this.messageSendSeqs = messageSendSeqs;
	}
	
}
