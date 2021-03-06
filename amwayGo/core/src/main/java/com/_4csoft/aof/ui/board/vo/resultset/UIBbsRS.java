/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.board.vo.UIBbsVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.vo.resultset
 * @File : UIBbsRS.java
 * @Title : UIBbsRS
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIBbsRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private UIBbsVO bbs;

	public UIBbsVO getBbs() {
		return bbs;
	}

	public void setBbs(UIBbsVO bbs) {
		this.bbs = bbs;
	}

}
