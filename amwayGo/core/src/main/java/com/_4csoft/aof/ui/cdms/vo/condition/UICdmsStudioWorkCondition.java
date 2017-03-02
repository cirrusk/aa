/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.vo.condition
 * @File : UICdmsStudioWorkCondition.java
 * @Title : CDMS 프로젝트(과목)
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsStudioWorkCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;
	private Long srchStudioSeq;
	private Long srchProjectSeq;
	private Long srchProjectGroupSeq;
	private String srchProjectGroupName;
	private String srchStartDate;
	private String srchEndDate;

	public Long getSrchStudioSeq() {
		return srchStudioSeq;
	}

	public void setSrchStudioSeq(Long srchStudioSeq) {
		this.srchStudioSeq = srchStudioSeq;
	}

	public Long getSrchProjectSeq() {
		return srchProjectSeq;
	}

	public void setSrchProjectSeq(Long srchProjectSeq) {
		this.srchProjectSeq = srchProjectSeq;
	}

	public Long getSrchProjectGroupSeq() {
		return srchProjectGroupSeq;
	}

	public void setSrchProjectGroupSeq(Long srchProjectGroupSeq) {
		this.srchProjectGroupSeq = srchProjectGroupSeq;
	}

	public String getSrchProjectGroupName() {
		return srchProjectGroupName;
	}

	public void setSrchProjectGroupName(String srchProjectGroupName) {
		this.srchProjectGroupName = srchProjectGroupName;
	}

	public String getSrchStartDate() {
		return srchStartDate;
	}

	public void setSrchStartDate(String srchStartDate) {
		this.srchStartDate = srchStartDate;
	}

	public String getSrchEndDate() {
		return srchEndDate;
	}

	public void setSrchEndDate(String srchEndDate) {
		this.srchEndDate = srchEndDate;
	}

}
