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
 * @File : UIUnivSurveyCondition.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 19.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivSurveyCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 사용하지 않은 문제 검색 */
	private String srchNotInSurveyPaperSeq;

	/** 설문유형 검색 */
	private String srchSurveyTypeCd;

	/** 설문보기유형 검색 */
	private String srchSurveyItemTypeCd;

	/** 사용유무 검색 */
	private String srchUseYn;

	/** 온라인오프라인 검색 */
	private String srchOnOffCd;

	/** 설문지구분 검색 */
	private String srchSurveyPaperTypeCd;

	public String getSrchNotInSurveyPaperSeq() {
		return srchNotInSurveyPaperSeq;
	}

	public void setSrchNotInSurveyPaperSeq(String srchNotInSurveyPaperSeq) {
		this.srchNotInSurveyPaperSeq = srchNotInSurveyPaperSeq;
	}

	public String getSrchSurveyTypeCd() {
		return srchSurveyTypeCd;
	}

	public void setSrchSurveyTypeCd(String srchSurveyTypeCd) {
		this.srchSurveyTypeCd = srchSurveyTypeCd;
	}

	public String getSrchSurveyItemTypeCd() {
		return srchSurveyItemTypeCd;
	}

	public void setSrchSurveyItemTypeCd(String srchSurveyItemTypeCd) {
		this.srchSurveyItemTypeCd = srchSurveyItemTypeCd;
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

	public String getSrchSurveyPaperTypeCd() {
		return srchSurveyPaperTypeCd;
	}

	public void setSrchSurveyPaperTypeCd(String srchSurveyPaperTypeCd) {
		this.srchSurveyPaperTypeCd = srchSurveyPaperTypeCd;
	}

}
