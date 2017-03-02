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
 * @File : UIMemoSendCondition.java
 * @Title : 보낸쪽지
 * @date : 2014. 1. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMessageSendCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private Long srchSendMemberSeq;

	/** cs_message_type_cd : 메세지 형태 */
	private String srchMessageTypeCd;
	
	private String srchSendScheduleCd;
	
	private String srchScheduleDtime;

	public Long getSrchSendMemberSeq() {
		return srchSendMemberSeq;
	}

	public void setSrchSendMemberSeq(Long srchSendMemberSeq) {
		this.srchSendMemberSeq = srchSendMemberSeq;
	}

	public String getSrchMessageTypeCd() {
		return srchMessageTypeCd;
	}

	public void setSrchMessageTypeCd(String srchMessageTypeCd) {
		this.srchMessageTypeCd = srchMessageTypeCd;
	}

	public String getSrchSendScheduleCd() {
		return srchSendScheduleCd;
	}

	public void setSrchSendScheduleCd(String srchSendScheduleCd) {
		this.srchSendScheduleCd = srchSendScheduleCd;
	}

	public String getSrchScheduleDtime() {
		return srchScheduleDtime;
	}

	public void setSrchScheduleDtime(String srchScheduleDtime) {
		this.srchScheduleDtime = srchScheduleDtime;
	}

}
