package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

public class MessageReceiveDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private Long messageSeq;
	private String message;
	private String regDate;
	private String name;
	private String messageType;
	
	public Long getMessageSeq() {
		return messageSeq;
	}
	public void setMessageSeq(Long messageSeq) {
		this.messageSeq = messageSeq;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getMessageType() {
		return messageType;
	}
	public void setMessageType(String messageType) {
		this.messageType = messageType;
	}

}