/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.session.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.session.vo.condition
 * @File    : UISessionCondition.java
 * @Title   : {간단한 프로그램의 명칭을 기록}
 * @date    : 2015. 8. 17.
 * @author  : 조성훈
 * @descrption :
 * {상세한 프로그램의 용도를 기록}
 */
public class UISessionCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 분류코드 */
	private String srchClassificationCode;
	
	/** 세션코드 */
	private String srchSessionCode;

	public String getSrchClassificationCode() {
		return srchClassificationCode;
	}

	public void setSrchClassificationCode(String srchClassificationCode) {
		this.srchClassificationCode = srchClassificationCode;
	}

	public String getSrchSessionCode() {
		return srchSessionCode;
	}

	public void setSrchSessionCode(String srchSessionCode) {
		this.srchSessionCode = srchSessionCode;
	}
	
}
