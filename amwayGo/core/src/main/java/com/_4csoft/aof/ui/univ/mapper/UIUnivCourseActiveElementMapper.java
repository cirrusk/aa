package com._4csoft.aof.ui.univ.mapper;

import java.util.List;

import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveElementVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Project : aof5-univ-3
 * @Package : com._4csoft.aof.ui.univ.mapper
 * @File : UIUnivCourseActiveElementMapper.java
 * @Title : 개설과목 구성정보
 * @date : 2014. 7. 7.
 * @author : 장용기
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Mapper ("UIUnivCourseActiveElementMapper")
public interface UIUnivCourseActiveElementMapper {

	/**
	 * 운영과정구성정보 목록 카운트
	 * 
	 * @param vo
	 * @return List<vo>
	 */
	List<UIUnivCourseActiveElementVO> getListElementCount(UnivCourseActiveElementVO vo);

}
