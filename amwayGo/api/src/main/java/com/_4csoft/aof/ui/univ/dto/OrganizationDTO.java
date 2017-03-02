package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;
import java.util.List;

public class OrganizationDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private Long sortOrder;
	private String activeElementTitle ;
	private String startDtime;
	private String endDtime;
	private List<LearnerDatamodelDTO> itemList;

	public Long getSortOrder() {
		return sortOrder;
	}

	public void setSortOrder(Long sortOrder) {
		this.sortOrder = sortOrder;
	}

	public String getActiveElementTitle() {
		return activeElementTitle;
	}

	public void setActiveElementTitle(String activeElementTitle) {
		this.activeElementTitle = activeElementTitle;
	}

	public String getStartDtime() {
		return startDtime;
	}

	public void setStartDtime(String startDtime) {
		this.startDtime = startDtime;
	}

	public String getEndDtime() {
		return endDtime;
	}

	public void setEndDtime(String endDtime) {
		this.endDtime = endDtime;
	}

	public List<LearnerDatamodelDTO> getItemList() {
		return itemList;
	}

	public void setItemList(List<LearnerDatamodelDTO> itemList) {
		this.itemList = itemList;
	}

}
