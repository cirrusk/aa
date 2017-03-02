/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo;

import java.io.Serializable;

import com._4csoft.aof.lcms.vo.LcmsMetadataVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo
 * @File : UILcmsMetadataVO.java
 * @Title : 메타데이터
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsMetadataVO extends LcmsMetadataVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long[] metadataSeqs;

	private Long[] metadataElementSeqs;

	private String[] metadataValues;

	private String[] metadataPaths;

	public Long[] getMetadataSeqs() {
		return metadataSeqs;
	}

	public void setMetadataSeqs(Long[] metadataSeqs) {
		this.metadataSeqs = metadataSeqs;
	}

	public Long[] getMetadataElementSeqs() {
		return metadataElementSeqs;
	}

	public void setMetadataElementSeqs(Long[] metadataElementSeqs) {
		this.metadataElementSeqs = metadataElementSeqs;
	}

	public String[] getMetadataValues() {
		return metadataValues;
	}

	public void setMetadataValues(String[] metadataValues) {
		this.metadataValues = metadataValues;
	}

	public String[] getMetadataPaths() {
		return metadataPaths;
	}

	public void setMetadataPaths(String[] metadataPaths) {
		this.metadataPaths = metadataPaths;
	}

}
