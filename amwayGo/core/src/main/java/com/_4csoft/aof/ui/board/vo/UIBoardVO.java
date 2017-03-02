/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.vo;

import java.io.Serializable;
import java.util.ArrayList;

import com._4csoft.aof.board.vo.BoardVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.board.vo
 * @File : UIBoardVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 1. 27.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIBoardVO extends BoardVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 멀티 수정 시 */
	private ArrayList<Long> boardSeqList;
	/** 멀티 수정 시 */
	private ArrayList<String> useYnList;
	/** 멀티 수정 시 */
	private ArrayList<String> secretYnList;
	/** 멀티 수정 시 */
	private ArrayList<String> editorYnList;
	/** 멀티 수정 시 */
	private ArrayList<String> commentYnList;
	/** 멀티 수정 시 */
	private ArrayList<String> replyTypeCdList;
	/** 멀티 수정 시 */
	private ArrayList<Long> attachCountList;
	/** 멀티 수정 시 */
	private ArrayList<Long> attachSizeList;
	
	/** 참여 여부 수정 시  */
	private Long[] boardSeqs;

	/** 참여 여부*/
	private String[] joinYns;
	
	/** 새소식 카운트 */
	private String newsCnt;

	public ArrayList<Long> getBoardSeqList() {
		return boardSeqList;
	}

	public void setBoardSeqList(ArrayList<Long> boardSeqList) {
		this.boardSeqList = boardSeqList;
	}

	public ArrayList<String> getUseYnList() {
		return useYnList;
	}

	public void setUseYnList(ArrayList<String> useYnList) {
		this.useYnList = useYnList;
	}

	public ArrayList<String> getSecretYnList() {
		return secretYnList;
	}

	public void setSecretYnList(ArrayList<String> secretYnList) {
		this.secretYnList = secretYnList;
	}

	public ArrayList<String> getEditorYnList() {
		return editorYnList;
	}

	public void setEditorYnList(ArrayList<String> editorYnList) {
		this.editorYnList = editorYnList;
	}

	public ArrayList<String> getCommentYnList() {
		return commentYnList;
	}

	public void setCommentYnList(ArrayList<String> commentYnList) {
		this.commentYnList = commentYnList;
	}

	public ArrayList<String> getReplyTypeCdList() {
		return replyTypeCdList;
	}

	public void setReplyTypeCdList(ArrayList<String> replyTypeCdList) {
		this.replyTypeCdList = replyTypeCdList;
	}

	public ArrayList<Long> getAttachCountList() {
		return attachCountList;
	}

	public void setAttachCountList(ArrayList<Long> attachCountList) {
		this.attachCountList = attachCountList;
	}

	public ArrayList<Long> getAttachSizeList() {
		return attachSizeList;
	}

	public void setAttachSizeList(ArrayList<Long> attachSizeList) {
		this.attachSizeList = attachSizeList;
	}

	public Long[] getBoardSeqs() {
		return boardSeqs;
	}

	public void setBoardSeqs(Long[] boardSeqs) {
		this.boardSeqs = boardSeqs;
	}

	public String[] getJoinYns() {
		return joinYns;
	}

	public void setJoinYns(String[] joinYns) {
		this.joinYns = joinYns;
	}

	public String getNewsCnt() {
		return newsCnt;
	}

	public void setNewsCnt(String newsCnt) {
		this.newsCnt = newsCnt;
	}
	
}
