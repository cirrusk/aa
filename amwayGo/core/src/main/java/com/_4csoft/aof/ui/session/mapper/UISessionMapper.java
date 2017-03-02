/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.session.mapper;

import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.session.vo.condition.UISessionCondition;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.session.mapper
 * @File    : SessionMapper.java
 * @Title   : {간단한 프로그램의 명칭을 기록}
 * @date    : 2015. 8. 17.
 * @author  : 조성훈
 * @descrption :
 * {상세한 프로그램의 용도를 기록}
 */
@Mapper ("UISessionMapper")
public interface UISessionMapper {
	
	/**
	 * Session 상세정보
	 * 
	 * @param classificationCode
	 * @param sessionCode
	 * @return ResultSet
	 */
	ResultSet getDetail(UISessionCondition conditionVO);

	/**
	 * Session 검색 목록
	 * 
	 * @param conditionVO
	 * @return List<ResultSet>
	 */
	List<ResultSet> getList(UISessionCondition conditionVO);

	/**
	 * Session 검색 목록 카운트
	 * 
	 * @param conditionVO
	 * @return int
	 */
	int countList(UISessionCondition conditionVO);

}
