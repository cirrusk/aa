/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIBatchHistoryVO;
import com._4csoft.aof.ui.infra.vo.UIBatchVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.infra.vo.resultset
 * @File : UIBatchRS.java
 * @Title : 배치 관리 Resultset
 * @date : 2014. 06. 09
 * @author : 류정희
 * @descrption : 배치 관리 Resultset
 */
public class UIBatchRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UIBatchVO batch;
	private UIBatchHistoryVO history;

	public UIBatchVO getBatch() {
		return batch;
	}
	
	public void setBatch(UIBatchVO batch) {
		this.batch = batch;
	}
	
	public UIBatchHistoryVO getHistory() {
		return history;
	}
	
	public void setHistory(UIBatchHistoryVO history) {
		this.history = history;
	}

}
