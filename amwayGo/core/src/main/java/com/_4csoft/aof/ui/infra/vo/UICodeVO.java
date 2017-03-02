/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.CodeVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UICodeVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICodeVO extends CodeVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 코드그룹 배열 */
	private String[] codeGroups;

	/** 코드 배열 */
	private String[] codes;
	
	/** 정렬기준 배열 */
	private Long[] sortOrders;

	/**
	 * @return the codeGroups
	 */
	public String[] getCodeGroups() {
		return codeGroups;
	}

	/**
	 * @param codeGroups the codeGroups to set
	 */
	public void setCodeGroups(String[] codeGroups) {
		this.codeGroups = codeGroups;
	}

	/**
	 * @return the codes
	 */
	public String[] getCodes() {
		return codes;
	}

	/**
	 * @param codes the codes to set
	 */
	public void setCodes(String[] codes) {
		this.codes = codes;
	}

	/**
	 * @return the sortOrders
	 */
	public Long[] getSortOrders() {
		return sortOrders;
	}

	/**
	 * @param sortOrders the sortOrders to set
	 */
	public void setSortOrders(Long[] sortOrders) {
		this.sortOrders = sortOrders;
	}

}
