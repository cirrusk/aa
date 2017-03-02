/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo.search
 * @File : UIRolegroupCondition.java
 * @Title : 롤그룹 검색 키워드
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIRolegroupCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private Long srchCompanySeq;
	
	private String srchCompanyName;
	
	private String srchGroupOrder;
	
	private String srchMemberStatusCd;
	
	private String srchRoleCd;
	
	private Long srchRolegroupSeq;
	
	private String srchCfString;

	public Long getSrchCompanySeq() {
		return srchCompanySeq;
	}

	public void setSrchCompanySeq(Long srchCompanySeq) {
		this.srchCompanySeq = srchCompanySeq;
	}

	public String getSrchCompanyName() {
		return srchCompanyName;
	}

	public void setSrchCompanyName(String srchCompanyName) {
		this.srchCompanyName = srchCompanyName;
	}

	public String getSrchGroupOrder() {
		return srchGroupOrder;
	}

	public void setSrchGroupOrder(String srchGroupOrder) {
		this.srchGroupOrder = srchGroupOrder;
	}

	public String getSrchMemberStatusCd() {
		return srchMemberStatusCd;
	}

	public void setSrchMemberStatusCd(String srchMemberStatusCd) {
		this.srchMemberStatusCd = srchMemberStatusCd;
	}

	public String getSrchRoleCd() {
		return srchRoleCd;
	}

	public void setSrchRoleCd(String srchRoleCd) {
		this.srchRoleCd = srchRoleCd;
	}

	public Long getSrchRolegroupSeq() {
		return srchRolegroupSeq;
	}

	public void setSrchRolegroupSeq(Long srchRolegroupSeq) {
		this.srchRolegroupSeq = srchRolegroupSeq;
	}

	public String getSrchCfString() {
		return srchCfString;
	}

	public void setSrchCfString(String srchCfString) {
		this.srchCfString = srchCfString;
	}

}
