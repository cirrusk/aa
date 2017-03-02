/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.lcms.vo.UILcmsLearnerDatamodelDataVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo.resultset
 * @File : UILcmsLearnerDatamodelDataRS.java
 * @Title : 학습자 데이터 모델 추가 데이터
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsLearnerDatamodelDataRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private UILcmsLearnerDatamodelDataVO learnerDatamodelData;

	public UILcmsLearnerDatamodelDataVO getLearnerDatamodelData() {
		return learnerDatamodelData;
	}

	public void setLearnerDatamodelData(UILcmsLearnerDatamodelDataVO learnerDatamodelData) {
		this.learnerDatamodelData = learnerDatamodelData;
	}

}
