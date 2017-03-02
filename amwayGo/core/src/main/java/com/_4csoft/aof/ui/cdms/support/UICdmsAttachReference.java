/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.support;

import org.springframework.stereotype.Component;

import com._4csoft.aof.cdms.support.CdmsAttachReference;
import com._4csoft.aof.infra.vo.base.AttachReferenceVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.cdms.support
 * @File : UICdmsAttachReference.java
 * @Title : 첨부파일 정보
 * @date : 2014. 3. 11.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Component ("UICdmsAttachReference")
public class UICdmsAttachReference implements CdmsAttachReference {

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com._4csoft.aof.cdms.support.validator.CdmsAttachReference#getAttachReferenceBbs(com._4csoft.aof.cdms.support.validator.CdmsAttachReference.AttachType,
	 * java.lang.String)
	 */
	public AttachReferenceVO getAttachReferenceBbs(AttachType type, String boardTypeCd) {
		switch (type) {
		case CDMS_BBS :
			String boardType = boardTypeCd.replaceFirst("BOARD_TYPE::", "").toLowerCase();
			return new AttachReferenceVO("cdms-" + boardType, "cs_cdms_bbs", "cdms/" + boardType);
		case STUDIO_WORK :
		default :
			return null;
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.cdms.support.validator.CdmsAttachReference#getAttachReference(com._4csoft.aof.cdms.support.validator.CdmsAttachReference.AttachType)
	 */
	public AttachReferenceVO getAttachReference(AttachType type) {
		switch (type) {
		case STUDIO_WORK :
			return new AttachReferenceVO("studioWork", "cs_cdms_studio_work", "studioWork");
		case CDMS_BBS :
		default :
			return null;
		}
	}

}
