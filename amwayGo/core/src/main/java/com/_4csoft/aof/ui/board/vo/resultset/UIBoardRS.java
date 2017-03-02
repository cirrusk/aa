/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.board.vo.UIBoardVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.board.vo.resultset
 * @File : UIBoardRS.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 1. 27.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIBoardRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UIBoardVO board;

	public UIBoardVO getBoard() {
		return board;
	}

	public void setBoard(UIBoardVO board) {
		this.board = board;
	}

}
