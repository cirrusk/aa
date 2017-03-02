/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.mapper.UIUnivCourseActiveSurveyMapper;
import com._4csoft.aof.ui.univ.service.UIUnivCourseActiveSurveyService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyVO;
import com._4csoft.aof.univ.service.impl.UnivCourseActiveSurveyServiceImpl;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.service.impl
 * @File : UIUnivCourseActiveSurveyServiceImpl.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 2.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UIUnivCourseActiveSurveyService")
public class UIUnivCourseActiveSurveyServiceImpl extends UnivCourseActiveSurveyServiceImpl implements UIUnivCourseActiveSurveyService {

	@Resource (name = "UIUnivCourseActiveSurveyMapper")
	private UIUnivCourseActiveSurveyMapper courseActiveSurveyMapper;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.ui.univ.service.UIUnivCourseActiveSurveyService#getDetailSurvey(com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyVO)
	 */
	public ResultSet getDetailSurvey(UIUnivCourseActiveSurveyVO vo) throws Exception {
		return courseActiveSurveyMapper.getDetailSurvey(vo);
	}

}
