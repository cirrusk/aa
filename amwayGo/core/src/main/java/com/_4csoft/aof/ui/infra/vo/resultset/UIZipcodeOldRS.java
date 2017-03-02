/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIZipcodeOldVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo.resultset
 * @File : UIZipcodeOldRS.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIZipcodeOldRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	private UIZipcodeOldVO zipcode;

	public UIZipcodeOldVO getZipcode() {
		return zipcode;
	}

	public void setZipcode(UIZipcodeOldVO zipcode) {
		this.zipcode = zipcode;
	}

}
