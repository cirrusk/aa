/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;
import java.util.Map;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCategoryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBoardVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.vo.resultset
 * @File : UIUnivCourseActiveBbsRS.java
 * @Title : 참여결과
 * @date : 2014. 03. 17.
 * @author : 류정희
 * @descrption : 참여결과
 */
public class UIUnivCourseBbsResultRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/** 과정 게시판 정보 vo */
	private UIUnivCourseActiveBoardVO board;
	
	/** 작성 대상 학과 정보 vo */
	private UIUnivCategoryVO category;
	
	/** 작성 대상 정보 vo */
	private  UIMemberVO member;
	
	/** 작성 게시판 정보 */
	private String bbsEvaluateData;
	
	/** 게시물 취득 점수 */
	private Long bbsScore;
	
	/** 작성 게시판 정보 */
	private Map<String, UIUnivCourseActiveBoardVO> evaluateData;

	public Map<String, UIUnivCourseActiveBoardVO> getEvaluateData() {
		return evaluateData;
	}

	public void setEvaluateData(Map<String, UIUnivCourseActiveBoardVO> evaluateData) {
		this.evaluateData = evaluateData;
	}

	public String getBbsEvaluateData() {
		return bbsEvaluateData;
	}

	public void setBbsEvaluateData(String bbsEvaluateData) {
		this.bbsEvaluateData = bbsEvaluateData;
	}

	public Long getBbsScore() {
		return bbsScore;
	}

	public void setBbsScore(Long bbsScore) {
		this.bbsScore = bbsScore;
	}

	public UIUnivCourseActiveBoardVO getBoard() {
		return board;
	}

	public void setBoard(UIUnivCourseActiveBoardVO board) {
		this.board = board;
	}

	public UIUnivCategoryVO getCategory() {
		return category;
	}

	public void setCategory(UIUnivCategoryVO category) {
		this.category = category;
	}

	public UIMemberVO getMember() {
		return member;
	}

	public void setMember(UIMemberVO member) {
		this.member = member;
	}

}
