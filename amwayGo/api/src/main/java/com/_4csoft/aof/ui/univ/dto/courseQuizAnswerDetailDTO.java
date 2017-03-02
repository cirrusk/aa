package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;



/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : courseQuizAnswerDetailDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 6. 22.
 * @author : 조경재
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class courseQuizAnswerDetailDTO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private Long examItemSeq;
	
	private Long examSeq;
	
	private Long examExampleSeq;
	
	private Long sortOrder;
	
	private String examItemExampleTitle;
	
	private Long answerCount; 
	
	private Long memberCount;

	
	
	public Long getExamItemSeq() {
		return examItemSeq;
	}

	public void setExamItemSeq(Long examItemSeq) {
		this.examItemSeq = examItemSeq;
	}

	public Long getExamSeq() {
		return examSeq;
	}

	public void setExamSeq(Long examSeq) {
		this.examSeq = examSeq;
	}

	public Long getExamExampleSeq() {
		return examExampleSeq;
	}

	public void setExamExampleSeq(Long examExampleSeq) {
		this.examExampleSeq = examExampleSeq;
	}

	public Long getSortOrder() {
		return sortOrder;
	}

	public void setSortOrder(Long sortOrder) {
		this.sortOrder = sortOrder;
	}

	public String getExamItemExampleTitle() {
		return examItemExampleTitle;
	}

	public void setExamItemExampleTitle(String examItemExampleTitle) {
		this.examItemExampleTitle = examItemExampleTitle;
	}

	public Long getAnswerCount() {
		return answerCount;
	}

	public void setAnswerCount(Long answerCount) {
		this.answerCount = answerCount;
	}

	public Long getMemberCount() {
		return memberCount;
	}

	public void setMemberCount(Long memberCount) {
		this.memberCount = memberCount;
	}
}
