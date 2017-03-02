/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo.condition
 * @File : UILcmsLearnerDatamodelCondition.java
 * @Title : 학습자 데이터 모델
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsLearnerDatamodelCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private String srchYn;

	/** */
	private Long srchLearnerId;

	/** */
	private String srchLearnerName;

	/** */
	private String srchStartUpdDate;

	/** */
	private String srchEndUpdDate;

	public String getSrchYn() {
		return srchYn;
	}

	public void setSrchYn(String srchYn) {
		this.srchYn = srchYn;
	}

	public Long getSrchLearnerId() {
		return srchLearnerId;
	}

	public void setSrchLearnerId(Long srchLearnerId) {
		this.srchLearnerId = srchLearnerId;
	}

	public String getSrchLearnerName() {
		return srchLearnerName;
	}

	public void setSrchLearnerName(String srchLearnerName) {
		this.srchLearnerName = srchLearnerName;
	}

	public String getSrchStartUpdDate() {
		return srchStartUpdDate;
	}

	public void setSrchStartUpdDate(String srchStartUpdDate) {
		this.srchStartUpdDate = srchStartUpdDate;
	}

	public String getSrchEndUpdDate() {
		return srchEndUpdDate;
	}

	public void setSrchEndUpdDate(String srchEndUpdDate) {
		this.srchEndUpdDate = srchEndUpdDate;
	}

}
