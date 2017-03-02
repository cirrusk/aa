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
 * @File : UICdmsProjectCondition.java
 * @Title : CDMS 프로젝트(과목)
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsProjectCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;
	private Long srchProjectGroupSeq;
	private String srchProjectGroupName;
	private Long srchSessionMemberSeq;
	private String srchCompleteYn;
	private String srchProjectTypeCd;
	private Long srchMemberSeq;
	private String srchMemberCdmsTypeCd;

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

	public Long getSrchSessionMemberSeq() {
		return srchSessionMemberSeq;
	}

	public void setSrchSessionMemberSeq(Long srchSessionMemberSeq) {
		this.srchSessionMemberSeq = srchSessionMemberSeq;
	}

	public String getSrchCompleteYn() {
		return srchCompleteYn;
	}

	public void setSrchCompleteYn(String srchCompleteYn) {
		this.srchCompleteYn = srchCompleteYn;
	}

	public String getSrchProjectTypeCd() {
		return srchProjectTypeCd;
	}

	public void setSrchProjectTypeCd(String srchProjectTypeCd) {
		this.srchProjectTypeCd = srchProjectTypeCd;
	}

	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}

	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}

	public String getSrchMemberCdmsTypeCd() {
		return srchMemberCdmsTypeCd;
	}

	public void setSrchMemberCdmsTypeCd(String srchMemberCdmsTypeCd) {
		this.srchMemberCdmsTypeCd = srchMemberCdmsTypeCd;
	}

}
