package com._4csoft.aof.ui.board.dto;

import java.io.Serializable;

public class SystemBoardDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long boardSeq;
	private String boardTypeCd;
	private Long referenceSeq;
	private String referenceType;
	private String boardTitle;
	private String useYn;
	private Long sortOrder;
	private String secretYn;
	private String commentYn;
	private String replyTypeCd;
	private Long attachCount;
	private Long attachSize;
	private Long newsCnt;

	public Long getBoardSeq() {
		return boardSeq;
	}

	public void setBoardSeq(Long boardSeq) {
		this.boardSeq = boardSeq;
	}

	public String getBoardTypeCd() {
		return boardTypeCd;
	}

	public void setBoardTypeCd(String boardTypeCd) {
		this.boardTypeCd = boardTypeCd;
	}

	public Long getReferenceSeq() {
		return referenceSeq;
	}

	public void setReferenceSeq(Long referenceSeq) {
		this.referenceSeq = referenceSeq;
	}

	public String getReferenceType() {
		return referenceType;
	}

	public void setReferenceType(String referenceType) {
		this.referenceType = referenceType;
	}

	public String getBoardTitle() {
		return boardTitle;
	}

	public void setBoardTitle(String boardTitle) {
		this.boardTitle = boardTitle;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public Long getSortOrder() {
		return sortOrder;
	}

	public void setSortOrder(Long sortOrder) {
		this.sortOrder = sortOrder;
	}

	public String getSecretYn() {
		return secretYn;
	}

	public void setSecretYn(String secretYn) {
		this.secretYn = secretYn;
	}

	public String getCommentYn() {
		return commentYn;
	}

	public void setCommentYn(String commentYn) {
		this.commentYn = commentYn;
	}

	public String getReplyTypeCd() {
		return replyTypeCd;
	}

	public void setReplyTypeCd(String replyTypeCd) {
		this.replyTypeCd = replyTypeCd;
	}

	public Long getAttachCount() {
		return attachCount;
	}

	public void setAttachCount(Long attachCount) {
		this.attachCount = attachCount;
	}

	public Long getAttachSize() {
		return attachSize;
	}

	public void setAttachSize(Long attachSize) {
		this.attachSize = attachSize;
	}

	public Long getNewsCnt() {
		return newsCnt;
	}

	public void setNewsCnt(Long newsCnt) {
		this.newsCnt = newsCnt;
	}

}