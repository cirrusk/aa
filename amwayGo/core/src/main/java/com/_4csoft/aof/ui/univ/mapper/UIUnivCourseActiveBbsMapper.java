/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.mapper;

import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;
import com._4csoft.aof.univ.mapper.UnivCourseActiveBbsMapper;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.mapper
 * @File : UIUnivCourseActiveBbsMapper.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 7.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Mapper ("UIUnivCourseActiveBbsMapper")
public interface UIUnivCourseActiveBbsMapper extends UnivCourseActiveBbsMapper {

	/**
	 * 게시물 통계 목록
	 * 
	 * @param condition
	 * @return
	 */
	List<ResultSet> getListBbsStatistics(SearchConditionVO condition);

	/**
	 * 게시물 통계수
	 * 
	 * @param condition
	 * @return
	 */
	int countListBbsStatistics(SearchConditionVO condition);
}
