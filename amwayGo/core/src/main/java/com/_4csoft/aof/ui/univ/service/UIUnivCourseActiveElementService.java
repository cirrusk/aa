package com._4csoft.aof.ui.univ.service;

import java.util.List;

import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.vo.UnivCourseActiveElementVO;

/**
 * @Project : aof5-univ-core
 * @Package : com._4csoft.aof.ui.univ.service
 * @File : UIUnivCourseActiveElementService.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 7. 7.
 * @author : 장용기
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UIUnivCourseActiveElementService extends UnivCourseActiveElementService {

	/**
	 * 운영과정구성정보 목록 카운트
	 * 
	 * @param vo
	 * @return List<ResultSet>
	 * @throws Exception
	 */
	List<UIUnivCourseActiveElementVO> getListElementCount(UnivCourseActiveElementVO vo) throws Exception;

}
