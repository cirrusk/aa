/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.MenuVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UIMenuVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIMenuVO extends MenuVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 멀티 수정 처리 */
	private Long[] menuSeqs;

	/** 메뉴아이디 변경시 사용됨 */
	private String newMenuId;

	public Long[] getMenuSeqs() {
		return menuSeqs;
	}

	public void setMenuSeqs(Long[] menuSeqs) {
		this.menuSeqs = menuSeqs;
	}

	public String getNewMenuId() {
		return newMenuId;
	}

	public void setNewMenuId(String newMenuId) {
		this.newMenuId = newMenuId;
	}

}
