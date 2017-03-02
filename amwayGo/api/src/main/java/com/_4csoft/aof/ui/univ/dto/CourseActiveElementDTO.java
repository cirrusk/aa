package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;
import java.util.List;

public class CourseActiveElementDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String referenceTypeName;
	private String referenceTypeCd;
	private Long totalCount;
	private List<ReferenceTypeDTO> referenceTypeList;
	
	public String getReferenceTypeName() {
		return referenceTypeName;
	}
	public void setReferenceTypeName(String referenceTypeName) {
		this.referenceTypeName = referenceTypeName;
	}
	public String getReferenceTypeCd() {
		return referenceTypeCd;
	}
	public void setReferenceTypeCd(String referenceTypeCd) {
		this.referenceTypeCd = referenceTypeCd;
	}
	public Long getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(Long totalCount) {
		this.totalCount = totalCount;
	}
	public List<ReferenceTypeDTO> getReferenceTypeList() {
		return referenceTypeList;
	}
	public void setReferenceTypeList(List<ReferenceTypeDTO> referenceTypeList) {
		this.referenceTypeList = referenceTypeList;
	}

}