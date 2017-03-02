/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.mapper;

import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseQuizAnswerVO;

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
@Mapper ("UIUnivCourseQuizAnswerMapper")
public interface UIUnivCourseQuizAnswerMapper {

	/**
	 * 수강생 퀴즈 저장
	 * 
	 * @param vo
	 * @return
	 */
	int insertCourseQuizAnswer(UIUnivCourseQuizAnswerVO vo);

	/**
	 * 퀴즈 목록
	 * 
	 * @param condition
	 * @return
	 */
	List<ResultSet> getListQuiz(SearchConditionVO condition);

	/**
	 * 퀴즈 목록 수
	 * 
	 * @param condition
	 * @return
	 */
	int countListQuiz(SearchConditionVO condition);

	/**
	 * 퀴즈 답변 목록
	 * 
	 * @param vo
	 * @return
	 */
	List<ResultSet> getListQuizAnswer(UIUnivCourseQuizAnswerVO vo);
	
	/**
	 * 퀴즈 답변 목록(주관식)
	 * 
	 * @param vo
	 * @return
	 */
	List<ResultSet> getListQuizShortAnswer(UIUnivCourseQuizAnswerVO vo);
	
	/**
	 * 퀴즈 상세보기
	 * @param vo
	 * @return
	 */
	ResultSet getDetailQuiz(UIUnivCourseQuizAnswerVO vo);
	
	
}
