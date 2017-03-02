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
 * @File : UICdmsBbsCondition.java
 * @Title : CDMS 게시판
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UICdmsBbsCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 검색 실시 여부 */
	private String srchSearchYn;

	/** 게시글 구분 */
	private String srchBbsTypeCd;

	/** 게시판 일련번호 */
	private Long srchBoardSeq;

	/** 최상위 공지 여부 */
	private String srchAlwaysTopYn;

	/** 부모글 일련번호 */
	private Long srchParentSeq;

	private Long srchProjectSeq;
	private String srchProjectName;

	public String getSrchSearchYn() {
		return srchSearchYn;
	}

	public void setSrchSearchYn(String srchSearchYn) {
		this.srchSearchYn = srchSearchYn;
	}

	public String getSrchBbsTypeCd() {
		return srchBbsTypeCd;
	}

	public void setSrchBbsTypeCd(String srchBbsTypeCd) {
		this.srchBbsTypeCd = srchBbsTypeCd;
	}

	public Long getSrchBoardSeq() {
		return srchBoardSeq;
	}

	public void setSrchBoardSeq(Long srchBoardSeq) {
		this.srchBoardSeq = srchBoardSeq;
	}

	public String getSrchAlwaysTopYn() {
		return srchAlwaysTopYn;
	}

	public void setSrchAlwaysTopYn(String srchAlwaysTopYn) {
		this.srchAlwaysTopYn = srchAlwaysTopYn;
	}

	public Long getSrchParentSeq() {
		return srchParentSeq;
	}

	public void setSrchParentSeq(Long srchParentSeq) {
		this.srchParentSeq = srchParentSeq;
	}

	public Long getSrchProjectSeq() {
		return srchProjectSeq;
	}

	public void setSrchProjectSeq(Long srchProjectSeq) {
		this.srchProjectSeq = srchProjectSeq;
	}

	public String getSrchProjectName() {
		return srchProjectName;
	}

	public void setSrchProjectName(String srchProjectName) {
		this.srchProjectName = srchProjectName;
	}

}
