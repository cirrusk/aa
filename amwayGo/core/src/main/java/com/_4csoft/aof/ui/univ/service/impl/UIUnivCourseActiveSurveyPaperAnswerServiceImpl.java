/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.ui.univ.mapper.UIUnivCourseActiveSurveyPaperAnswerMapper;
import com._4csoft.aof.ui.univ.service.UIUnivCourseActiveSurveyPaperAnswerService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyPaperAnswerVO;
import com._4csoft.aof.univ.service.impl.UnivCourseActiveSurveyPaperAnswerServiceImpl;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.service.impl
 * @File : UIUnivCourseTeamProjectBbsServiceImpl.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 20.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UIUnivCourseActiveSurveyPaperAnswerService")
public class UIUnivCourseActiveSurveyPaperAnswerServiceImpl extends UnivCourseActiveSurveyPaperAnswerServiceImpl implements UIUnivCourseActiveSurveyPaperAnswerService {

	@Resource (name = "UIUnivCourseActiveSurveyPaperAnswerMapper")
	private UIUnivCourseActiveSurveyPaperAnswerMapper courseActiveSurveyPaperAnswerMapper;

	@Resource (name = "CodeService")
	private CodeService codeService;

	public int delete(UIUnivCourseActiveSurveyPaperAnswerVO vo)
			throws Exception {
		// TODO Auto-generated method stub
		return courseActiveSurveyPaperAnswerMapper.delete(vo);
	}

	
}
