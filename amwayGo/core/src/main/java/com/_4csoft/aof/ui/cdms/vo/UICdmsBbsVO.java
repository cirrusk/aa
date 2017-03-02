/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo;

import java.io.Serializable;

import com._4csoft.aof.cdms.vo.CdmsBbsVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo
 * @File : UICdmsBbsVO.java
 * @Title : CDMS 개발게시판
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsBbsVO extends CdmsBbsVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 첨부파일 수 */
	private Long attachCount;

	/** 답변 수 */
	private Long replyCount;

	/** 멀티 삭제 처리 */
	private Long[] bbsSeqs;

	public Long getAttachCount() {
		return attachCount;
	}

	public void setAttachCount(Long attachCount) {
		this.attachCount = attachCount;
	}

	public Long getReplyCount() {
		return replyCount;
	}

	public void setReplyCount(Long replyCount) {
		this.replyCount = replyCount;
	}

	public Long[] getBbsSeqs() {
		return bbsSeqs;
	}

	public void setBbsSeqs(Long[] bbsSeqs) {
		this.bbsSeqs = bbsSeqs;
	}

}
