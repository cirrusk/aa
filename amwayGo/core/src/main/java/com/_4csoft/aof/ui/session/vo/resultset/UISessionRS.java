/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.session.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.session.vo.UISessionVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.session.vo.resultset
 * @File    : UISessionRS.java
 * @Title   : {간단한 프로그램의 명칭을 기록}
 * @date    : 2015. 8. 17.
 * @author  : 조성훈
 * @descrption :
 * {상세한 프로그램의 용도를 기록}
 */
public class UISessionRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private UISessionVO session;

	public UISessionVO getSession() {
		return session;
	}

	public void setSession(UISessionVO session) {
		this.session = session;
	}
	
}
