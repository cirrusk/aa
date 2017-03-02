/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCompanyVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UICompanyVO.java
 * @Title : 소속
 * @date : 2013. 9. 2.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UXCompetitionVO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String competitionYn;
	
	private String competitionStatusCd;
	
	private String nowTime;
	
	public String getCompetitionYn() {
		return competitionYn;
	}

	public void setCompetitionYn(String competitionYn) {
		this.competitionYn = competitionYn;
	}

	public String getCompetitionStatusCd() {
		return competitionStatusCd;
	}

	public void setCompetitionStatusCd(String competitionStatusCd) {
		this.competitionStatusCd = competitionStatusCd;
	}

	public String getNowTime() {
		return nowTime;
	}

	public void setNowTime(String nowTime) {
		this.nowTime = nowTime;
	}
	
	
}
