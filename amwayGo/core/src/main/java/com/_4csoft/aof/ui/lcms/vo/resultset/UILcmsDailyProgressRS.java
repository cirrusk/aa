/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.lcms.vo.UILcmsDailyProgressVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo.resultset
 * @File : UILcmsDailyProgressRS.java
 * @Title : 일일진도율
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsDailyProgressRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private UILcmsDailyProgressVO dailyProgress;

	public UILcmsDailyProgressVO getDailyProgress() {
		return dailyProgress;
	}

	public void setDailyProgress(UILcmsDailyProgressVO dailyProgress) {
		this.dailyProgress = dailyProgress;
	}

}
