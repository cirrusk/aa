/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.mapper;

import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyPaperAnswerVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.mapper
 * @File : UIUnivCourseQuizAnswerMapper.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 10.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Mapper ("UIUnivCourseActiveSurveyPaperAnswerMapper")
public interface UIUnivCourseActiveSurveyPaperAnswerMapper {

	/**
	 * 수강생 설문 삭제
	 * 
	 * @param vo
	 * @return
	 */
	int delete(UIUnivCourseActiveSurveyPaperAnswerVO vo);

	
}
