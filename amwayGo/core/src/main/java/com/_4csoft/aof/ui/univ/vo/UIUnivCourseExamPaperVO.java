/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseExamPaperVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseExamPaperVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 24.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseExamPaperVO extends UnivCourseExamPaperVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 문제수 */
	private Long examCount;

	public Long getExamCount() {
		return examCount;
	}

	public void setExamCount(Long examCount) {
		this.examCount = examCount;
	}

}
