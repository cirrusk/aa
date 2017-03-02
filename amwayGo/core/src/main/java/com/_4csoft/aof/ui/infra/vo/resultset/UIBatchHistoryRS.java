/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIBatchHistoryVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.infra.vo.resultset
 * @File : UIBatchHistoryRS.java
 * @Title : 배치 이력 관리 Resultset
 * @date : 2014. 06. 09
 * @author : 류정희
 * @descrption : 배치 이력 관리 Resultset
 */
public class UIBatchHistoryRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UIBatchHistoryVO history;

	public UIBatchHistoryVO getHistory() {
		return history;
	}

	public void setHistory(UIBatchHistoryVO history) {
		this.history = history;
	}

}
