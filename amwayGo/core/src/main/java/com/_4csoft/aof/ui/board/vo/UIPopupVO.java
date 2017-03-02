/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.vo;

import java.io.Serializable;

import com._4csoft.aof.board.vo.PopupVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.vo
 * @File : UIBbsVO.java
 * @Title : UIBbsVO
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIPopupVO extends PopupVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 첨부파일 수 */
	private Long attachCount;

	private Long[] popupSeqs;

	public Long getAttachCount() {
		return attachCount;
	}

	public void setAttachCount(Long attachCount) {
		this.attachCount = attachCount;
	}

	public Long[] getPopupSeqs() {
		return popupSeqs;
	}

	public void setPopupSeqs(Long[] popupSeqs) {
		this.popupSeqs = popupSeqs;
	}

}
