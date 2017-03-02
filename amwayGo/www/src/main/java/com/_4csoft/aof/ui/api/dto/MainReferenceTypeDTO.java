package com._4csoft.aof.ui.api.dto;

import java.io.Serializable;

public class MainReferenceTypeDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String referenceTypeName;
	private Long totalCount;
	
	public String getReferenceTypeName() {
		return referenceTypeName;
	}
	public void setReferenceTypeName(String referenceTypeName) {
		this.referenceTypeName = referenceTypeName;
	}
	public Long getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(Long totalCount) {
		this.totalCount = totalCount;
	}

}
