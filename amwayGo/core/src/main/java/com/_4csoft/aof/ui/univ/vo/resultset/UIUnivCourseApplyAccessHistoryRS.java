/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UICategoryVO;
import com._4csoft.aof.ui.infra.vo.UICodeVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyAccessHistoryVO;

/**
 * 
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File    : UIUnivCourseApplyAccessHistoryRS.java
 * @Title   : 교과목 접속통계
 * @date    : 2014. 4. 14.
 * @author  : 김영학
 * @descrption :
 * {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseApplyAccessHistoryRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 교과목 접속히스토리 vo */
	private UIUnivCourseApplyAccessHistoryVO accessHistory;
	
	/** 교과목 정보 vo */
	private UIUnivCourseActiveVO courseActive;
	
	/** 카테고리 vo */
	private UICategoryVO cate;
	
	/** 코드 vo */
	private UICodeVO code;
	
	public UICategoryVO getCate() {
		return cate;
	}

	public void setCate(UICategoryVO cate) {
		this.cate = cate;
	}

	public UIUnivCourseApplyAccessHistoryVO getAccessHistory() {
		return accessHistory;
	}

	public void setAccessHistory(UIUnivCourseApplyAccessHistoryVO accessHistory) {
		this.accessHistory = accessHistory;
	}

	public UIUnivCourseActiveVO getCourseActive() {
		return courseActive;
	}

	public void setCourseActive(UIUnivCourseActiveVO courseActive) {
		this.courseActive = courseActive;
	}

	public UICodeVO getCode() {
		return code;
	}

	public void setCode(UICodeVO code) {
		this.code = code;
	}

}
