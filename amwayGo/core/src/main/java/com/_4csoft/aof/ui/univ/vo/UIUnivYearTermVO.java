/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivYearTermVO;

/**
 * 
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivYearTermVO.java
 * @Title : 년도 학기
 * @date : 2014. 2. 18.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivYearTermVO extends UnivYearTermVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 년도학기 Array */
	private String[] yearTerms;

	/** 복습입장여부 */
	private String[] reviewOpenYns;
	
	private String competitionYn;

	public String[] getYearTerms() {
		return yearTerms;
	}

	public void setYearTerms(String[] yearTerms) {
		this.yearTerms = yearTerms;
	}

	public String[] getReviewOpenYns() {
		return reviewOpenYns;
	}

	public void setReviewOpenYns(String[] reviewOpenYns) {
		this.reviewOpenYns = reviewOpenYns;
	}

	public String getCompetitionYn() {
		return competitionYn;
	}

	public void setCompetitionYn(String competitionYn) {
		this.competitionYn = competitionYn;
	}
}
