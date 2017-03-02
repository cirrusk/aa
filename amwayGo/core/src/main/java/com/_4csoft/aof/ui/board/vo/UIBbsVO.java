/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.vo;

import java.io.Serializable;

import com._4csoft.aof.board.vo.BbsVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.vo
 * @File : UIBbsVO.java
 * @Title : 게시글
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIBbsVO extends BbsVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 첨부파일 수 */
	private Long attachCount;

	/** 답변 수 */
	private Long replyCount;

	/** 멀티 삭제 처리 */
	private Long[] bbsSeqs;

	/** 멀티 삭제 처리 */
	private Long[] boardSeqs;

	/** 다운로드 가능여부 */
	private String downloadYn;
	
	private String classificationCode;

	public Long getAttachCount() {
		return attachCount;
	}

	public void setAttachCount(Long attachCount) {
		this.attachCount = attachCount;
	}

	public Long getReplyCount() {
		return replyCount;
	}

	public void setReplyCount(Long replyCount) {
		this.replyCount = replyCount;
	}

	public Long[] getBbsSeqs() {
		return bbsSeqs;
	}

	public void setBbsSeqs(Long[] bbsSeqs) {
		this.bbsSeqs = bbsSeqs;
	}

	public Long[] getBoardSeqs() {
		return boardSeqs;
	}

	public void setBoardSeqs(Long[] boardSeqs) {
		this.boardSeqs = boardSeqs;
	}

	public String getDownloadYn() {
		return downloadYn;
	}

	public void setDownloadYn(String downloadYn) {
		this.downloadYn = downloadYn;
	}

	public String getClassificationCode() {
		return classificationCode;
	}

	public void setClassificationCode(String classificationCode) {
		this.classificationCode = classificationCode;
	}

}