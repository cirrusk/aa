/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.lcms.vo.UILcmsMetadataElementVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsMetadataVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo.resultset
 * @File : UILcmsMetadataRS.java
 * @Title : 메타데이터
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsMetadataRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private UILcmsMetadataVO metadata;

	/** */
	private UILcmsMetadataElementVO metadataElement;

	public UILcmsMetadataVO getMetadata() {
		return metadata;
	}

	public void setMetadata(UILcmsMetadataVO metadata) {
		this.metadata = metadata;
	}

	public UILcmsMetadataElementVO getMetadataElement() {
		return metadataElement;
	}

	public void setMetadataElement(UILcmsMetadataElementVO metadataElement) {
		this.metadataElement = metadataElement;
	}

}
