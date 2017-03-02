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
 * @File : UIScheduleCondition.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIScheduleCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;
	private Long srchMemberSeq;
	private String srchRepeatYn;
	private String srchStartDtime;
	private String srchEndDtime;

	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}

	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}

	public String getSrchRepeatYn() {
		return srchRepeatYn;
	}

	public void setSrchRepeatYn(String srchRepeatYn) {
		this.srchRepeatYn = srchRepeatYn;
	}

	public String getSrchStartDtime() {
		return srchStartDtime;
	}

	public void setSrchStartDtime(String srchStartDtime) {
		this.srchStartDtime = srchStartDtime;
	}

	public String getSrchEndDtime() {
		return srchEndDtime;
	}

	public void setSrchEndDtime(String srchEndDtime) {
		this.srchEndDtime = srchEndDtime;
	}

}
