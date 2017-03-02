/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivOcwEvaluateVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivOcwEvaluateRS.java
 * @Title : ocw 과목 ResultSet
 * @date : 2014. 5. 19.
 * @author : 김현우
 * @descrption : 과제 템플릿 ResultSet
 */
public class UIUnivOcwEvaluateRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** ocw 과목 vo */
	private UIUnivOcwEvaluateVO ocwEvaluate;

	public UIUnivOcwEvaluateVO getOcwEvaluate() {
		return ocwEvaluate;
	}

	public void setOcwEvaluate(UIUnivOcwEvaluateVO ocwEvaluate) {
		this.ocwEvaluate = ocwEvaluate;
	}

}
