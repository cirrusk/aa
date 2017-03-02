/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo;

import java.io.Serializable;

import com._4csoft.aof.lcms.vo.LcmsContentsVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo
 * @File : UILcmsContentsVO.java
 * @Title : 콘텐츠 그룹
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsContentsVO extends LcmsContentsVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private String memberName; // 소유자명

	/** */
	private Long[] contentsSeqs;

	/** */
	private Long[] categorySeqs;

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public Long[] getContentsSeqs() {
		return contentsSeqs;
	}

	public void setContentsSeqs(Long[] contentsSeqs) {
		this.contentsSeqs = contentsSeqs;
	}

	public Long[] getCategorySeqs() {
		return categorySeqs;
	}

	public void setCategorySeqs(Long[] categorySeqs) {
		this.categorySeqs = categorySeqs;
	}

}
