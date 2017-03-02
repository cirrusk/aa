package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;



/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : courseQuizShortAnswerDetailDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 6. 24.
 * @author : 조경재
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class courseQuizShortAnswerDetailDTO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private Long memberSeq;
	
	private String memberName;
	
	private String shortAnswer;

	public Long getMemberSeq() {
		return memberSeq;
	}

	public void setMemberSeq(Long memberSeq) {
		this.memberSeq = memberSeq;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getShortAnswer() {
		return shortAnswer;
	}

	public void setShortAnswer(String shortAnswer) {
		this.shortAnswer = shortAnswer;
	}
}
