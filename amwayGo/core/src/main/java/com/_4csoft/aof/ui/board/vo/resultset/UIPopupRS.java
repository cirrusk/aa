/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.board.vo.UIPopupVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.vo.resultset
 * @File : UIBbsRS.java
 * @Title : UIBbsRS
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIPopupRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/** */
	private UIPopupVO popup;

	public UIPopupVO getPopup() {
		return popup;
	}

	public void setPopup(UIPopupVO popup) {
		this.popup = popup;
	}
	
	
}
