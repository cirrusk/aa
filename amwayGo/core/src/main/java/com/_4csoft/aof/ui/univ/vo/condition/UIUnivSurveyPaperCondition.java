/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.condition
 * @File : UIUnivSurveyPaperCondition.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 21.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivSurveyPaperCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 설문지유형 검색 */
	private String srchSurveyPaperTypeCd;

	/** 사용유무 검색 */
	private String srchUseYn;

	/** 온라인오프라인 검색 */
	private String srchOnOffCd;

	public String getSrchSurveyPaperTypeCd() {
		return srchSurveyPaperTypeCd;
	}

	public void setSrchSurveyPaperTypeCd(String srchSurveyPaperTypeCd) {
		this.srchSurveyPaperTypeCd = srchSurveyPaperTypeCd;
	}

	public String getSrchUseYn() {
		return srchUseYn;
	}

	public void setSrchUseYn(String srchUseYn) {
		this.srchUseYn = srchUseYn;
	}

	public String getSrchOnOffCd() {
		return srchOnOffCd;
	}

	public void setSrchOnOffCd(String srchOnOffCd) {
		this.srchOnOffCd = srchOnOffCd;
	}

}
