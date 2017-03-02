/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com._4csoft.aof.univ.vo.UnivSurveyVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivSurveyVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 19.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivSurveyVO extends UnivSurveyVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 보기 목록 */
	private List<UIUnivSurveyExampleVO> listUISurveyExample = new ArrayList<UIUnivSurveyExampleVO>();

	public List<UIUnivSurveyExampleVO> getListUISurveyExample() {
		return listUISurveyExample;
	}

	public void setListUISurveyExample(List<UIUnivSurveyExampleVO> listUISurveyExample) {
		this.listUISurveyExample = listUISurveyExample;
	}

}
