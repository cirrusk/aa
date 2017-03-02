/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo;

import java.io.Serializable;

import com._4csoft.aof.lcms.vo.LcmsLearnerDatamodelDataVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo
 * @File : UILcmsLearnerDatamodelDataVO.java
 * @Title : 학습자 데이터모델 추가 데이터
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsLearnerDatamodelDataVO extends LcmsLearnerDatamodelDataVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private String learnerId;

	/** */
	private String learnerName;

	/** */
	private String updDtime;

	public String getLearnerId() {
		return learnerId;
	}

	public void setLearnerId(String learnerId) {
		this.learnerId = learnerId;
	}

	public String getLearnerName() {
		return learnerName;
	}

	public void setLearnerName(String learnerName) {
		this.learnerName = learnerName;
	}

	public String getUpdDtime() {
		return updDtime;
	}

	public void setUpdDtime(String updDtime) {
		this.updDtime = updDtime;
	}

}
