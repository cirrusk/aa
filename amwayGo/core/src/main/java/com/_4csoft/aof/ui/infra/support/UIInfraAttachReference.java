/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.support;

import org.springframework.stereotype.Component;

import com._4csoft.aof.infra.support.InfraAttachReference;
import com._4csoft.aof.infra.vo.base.AttachReferenceVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.infra.support
 * @File : UIInfraAttachReference.java
 * @Title : 첨부파일 정보
 * @date : 2014. 3. 11.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Component ("UIInfraAttachReference")
public class UIInfraAttachReference implements InfraAttachReference {

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.InfraAttachReference#getAttachReference(com._4csoft.aof.infra.support.InfraAttachReference.AttachType)
	 */
	public AttachReferenceVO getAttachReference(AttachType type) {
		switch (type) {
		case MESSAGE_SEND :
			return new AttachReferenceVO("messageSend", "cs_message_send", "messageSend");
		case MEMBER :
			return new AttachReferenceVO("member", "cs_member", "member");
		default :
			return null;
		}
	}
}
