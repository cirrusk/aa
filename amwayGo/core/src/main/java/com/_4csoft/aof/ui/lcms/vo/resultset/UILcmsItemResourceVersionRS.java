/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.lcms.vo.UILcmsItemResourceVersionVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo.resultset
 * @File : UILcmsItemResourceVersionRS.java
 * @Title : 학습요소 리소스 버전
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsItemResourceVersionRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private UILcmsItemResourceVersionVO itemResourceVersion;

	public UILcmsItemResourceVersionVO getItemResourceVersion() {
		return itemResourceVersion;
	}

	public void setItemResourceVersion(UILcmsItemResourceVersionVO itemResourceVersion) {
		this.itemResourceVersion = itemResourceVersion;
	}

}
