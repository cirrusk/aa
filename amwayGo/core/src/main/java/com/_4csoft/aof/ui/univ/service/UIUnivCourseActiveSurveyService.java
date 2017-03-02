/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyVO;
import com._4csoft.aof.univ.service.UnivCourseActiveSurveyService;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.service
 * @File : UIUnivCourseActiveSurveyService.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 2.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UIUnivCourseActiveSurveyService extends UnivCourseActiveSurveyService {

	/**
	 * 개설 과목 설문 상세
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	ResultSet getDetailSurvey(UIUnivCourseActiveSurveyVO vo) throws Exception;
}
