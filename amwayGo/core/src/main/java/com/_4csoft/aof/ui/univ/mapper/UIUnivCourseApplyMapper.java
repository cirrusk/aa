/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.mapper;

import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.univ.mapper.UnivCourseApplyMapper;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.mapper
 * @File : UIUnivCourseApplyMapper.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 13.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Mapper ("UIUnivCourseApplyMapper")
public interface UIUnivCourseApplyMapper extends UnivCourseApplyMapper {
	/**
	 * 수강생 배치 등록
	 * 
	 * @param vo
	 * @return
	 */
	int insertBatch(UIUnivCourseApplyVO vo);

	/**
	 * 수강 유무
	 * 
	 * @param vo
	 * @return
	 */
	int countCourseApply(UIUnivCourseApplyVO vo);
	
	/**
	 * 개설과목의 수강생 목록(아이디)
	 * 
	 * @param courseActiveSeq
	 * @return List<Long>
	 */
	String[] getListCourseActiveId(Long courseActiveSeq);
	
}
