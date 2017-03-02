package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.lcms.vo.UILcmsItemVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveOrganizationItemVO;

public class UIUnivCourseActiveOrganizationItemRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/** 학습요소 교시 */
	private UILcmsItemVO item;
	
	/** 학습요소 교시 학습보조자료 */
	private UIUnivCourseActiveOrganizationItemVO activeItem;

	public UILcmsItemVO getItem() {
		return item;
	}

	public void setItem(UILcmsItemVO item) {
		this.item = item;
	}

	public UIUnivCourseActiveOrganizationItemVO getActiveItem() {
		return activeItem;
	}

	public void setActiveItem(UIUnivCourseActiveOrganizationItemVO activeItem) {
		this.activeItem = activeItem;
	}
	
}