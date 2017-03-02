/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.support;

import org.springframework.stereotype.Component;

import com._4csoft.aof.board.support.BoardAttachReference;
import com._4csoft.aof.infra.vo.base.AttachReferenceVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.board.support
 * @File : UIBoardAttachReference.java
 * @Title : 첨부파일 정보
 * @date : 2014. 3. 11.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Component ("UIBoardAttachReference")
public class UIBoardAttachReference implements BoardAttachReference {

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.board.support.BoardAttachReference#getAttachReferenceBbs(com._4csoft.aof.board.support.BoardAttachReference.AttachType,
	 * java.lang.String)
	 */
	public AttachReferenceVO getAttachReferenceBbs(AttachType type, String boardTypeCd) {
		switch (type) {
		case BBS :
			String boardType = boardTypeCd.replaceFirst("BOARD_TYPE::", "").toLowerCase();
			return new AttachReferenceVO("system-" + boardType, "cs_bbs", "system/" + boardType);
		case POPUP :
		default :
			return null;
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.board.support.BoardAttachReference#getAttachReference(com._4csoft.aof.board.support.BoardAttachReference.AttachType)
	 */
	public AttachReferenceVO getAttachReference(AttachType type) {
		switch (type) {
		case POPUP :
			return new AttachReferenceVO("system-popup", "cs_popup", "system/popup");
		case BBS :
		default :
			return null;
		}
	}

}
