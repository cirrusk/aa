/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo.resultset;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyPaperElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.resultset
 * @File : UIUnivSurveyPaperElementRS.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 21.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivSurveyPaperElementRS extends ResultSet implements Serializable {
	private static final long serialVersionUID = 1L;

	private UIUnivSurveyPaperElementVO univSurveyPaperElement;

	private UIUnivSurveyVO univSurvey;

	private List<UIUnivSurveyExampleRS> listSurveyExample;

	public UIUnivSurveyPaperElementVO getUnivSurveyPaperElement() {
		return univSurveyPaperElement;
	}

	public void setUnivSurveyPaperElement(UIUnivSurveyPaperElementVO univSurveyPaperElement) {
		this.univSurveyPaperElement = univSurveyPaperElement;
	}

	public UIUnivSurveyVO getUnivSurvey() {
		return univSurvey;
	}

	public void setUnivSurvey(UIUnivSurveyVO univSurvey) {
		this.univSurvey = univSurvey;
	}

	public List<UIUnivSurveyExampleRS> getListSurveyExample() {
		return listSurveyExample;
	}

	public void setListSurveyExample(List<UIUnivSurveyExampleRS> listSurveyExample) {
		this.listSurveyExample = listSurveyExample;
	}

}
