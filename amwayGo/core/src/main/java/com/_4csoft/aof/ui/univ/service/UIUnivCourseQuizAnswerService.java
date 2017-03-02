/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service;

import java.util.List;

import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseQuizAnswerVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.service
 * @File : UIUnivCourseQuizAnswerService.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 10.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UIUnivCourseQuizAnswerService {

	/**
	 * 수강생 퀴즈 저장
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	int insertCourseQuizAnswer(UIUnivCourseQuizAnswerVO vo) throws Exception;

	/**
	 * 퀴즈 목록
	 * 
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	public Paginate<ResultSet> getListQuiz(SearchConditionVO conditionVO) throws Exception;

	/**
	 * 퀴즈 답변 목록
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	List<ResultSet> getListQuizAnswer(UIUnivCourseQuizAnswerVO vo) throws Exception;
	
	/**
	 * 퀴즈 답변 목록(주관식)
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	List<ResultSet> getListQuizShortAnswer(UIUnivCourseQuizAnswerVO vo) throws Exception;
	
	/**
	 * 퀴즈 상세보기
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	ResultSet getDetailQuiz(UIUnivCourseQuizAnswerVO vo) throws Exception;
	
	

}
