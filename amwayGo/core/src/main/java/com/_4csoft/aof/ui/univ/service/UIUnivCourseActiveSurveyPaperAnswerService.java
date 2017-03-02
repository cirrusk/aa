/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service;

import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyPaperAnswerVO;
import com._4csoft.aof.univ.service.UnivCourseActiveSurveyPaperAnswerService;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.service
 * @File : UIUnivCourseTeamProjectBbsService.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 20.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UIUnivCourseActiveSurveyPaperAnswerService extends UnivCourseActiveSurveyPaperAnswerService {

	/**
	 * 수강생 설문 삭제
	 */
	public int delete(UIUnivCourseActiveSurveyPaperAnswerVO vo) throws Exception;
}
