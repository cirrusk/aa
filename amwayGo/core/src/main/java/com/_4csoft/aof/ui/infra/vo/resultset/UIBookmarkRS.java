/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIBookmarkVO;
import com._4csoft.aof.ui.infra.vo.UIMenuVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.infra.vo.resultset
 * @File    : UIFavoriteRS.java
 * @Title   : 즐겨찾기
 * @date    : 2014. 4. 4.
 * @author  : 김영학
 * @descrption : 즐겨찾기
 */
public class UIBookmarkRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private UIBookmarkVO bookMark;
	
	private UIMenuVO menu;

	public UIBookmarkVO getBookMark() {
		return bookMark;
	}

	public void setBookMark(UIBookmarkVO bookMark) {
		this.bookMark = bookMark;
	}

	public UIMenuVO getMenu() {
		return menu;
	}

	public void setMenu(UIMenuVO menu) {
		this.menu = menu;
	}

}
