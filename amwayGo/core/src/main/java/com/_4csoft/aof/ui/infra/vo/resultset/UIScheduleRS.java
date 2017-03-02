/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIScheduleVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo.resultset
 * @File : UIScheduleRS.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 6. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIScheduleRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UIScheduleVO schedule;

	public UIScheduleVO getSchedule() {
		return schedule;
	}

	public void setSchedule(UIScheduleVO schedule) {
		this.schedule = schedule;
	}

}
