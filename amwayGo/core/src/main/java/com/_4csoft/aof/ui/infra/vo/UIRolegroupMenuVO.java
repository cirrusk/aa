/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.RolegroupMenuVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UIRolegroupMenuVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIRolegroupMenuVO extends RolegroupMenuVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 멀티 수정 처리 : 롤그룹 시퀀스*/
	private Long[] rolegroupSeqs;

	/** 멀티 수정 처리 : 메뉴시퀀스*/
	private Long[] menuSeqs;

	/** 멀티 수정 처리 : 변경된 CRUD 데이터*/
	private String[] cruds;

	/** 멀티 수정 처리 : 구 CRUD 데이터*/
	private String[] oldCruds;
	
	/** 멀티 수정 처리 : 변경된 필수여부 데이터*/
	private String[] mandatoryYns;
	
	/** 멀티 수정 처리 : 구 필수여부 데이터*/
	private String[] oldMandatoryYns;

	public Long[] getRolegroupSeqs() {
		return rolegroupSeqs;
	}

	public void setRolegroupSeqs(Long[] rolegroupSeqs) {
		this.rolegroupSeqs = rolegroupSeqs;
	}

	public Long[] getMenuSeqs() {
		return menuSeqs;
	}

	public void setMenuSeqs(Long[] menuSeqs) {
		this.menuSeqs = menuSeqs;
	}

	public String[] getCruds() {
		return cruds;
	}

	public void setCruds(String[] cruds) {
		this.cruds = cruds;
	}

	public String[] getOldCruds() {
		return oldCruds;
	}

	public void setOldCruds(String[] oldCruds) {
		this.oldCruds = oldCruds;
	}

	public String[] getMandatoryYns() {
		return mandatoryYns;
	}

	public void setMandatoryYns(String[] mandatoryYns) {
		this.mandatoryYns = mandatoryYns;
	}

	public String[] getOldMandatoryYns() {
		return oldMandatoryYns;
	}

	public void setOldMandatoryYns(String[] oldMandatoryYns) {
		this.oldMandatoryYns = oldMandatoryYns;
	}

}
