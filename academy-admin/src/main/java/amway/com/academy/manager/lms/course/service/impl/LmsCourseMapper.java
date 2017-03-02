package amway.com.academy.manager.lms.course.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsCourseMapper {
	/**
	 * 과정 기본정보 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsCourse(RequestBox requestBox) throws Exception;
	
	/**
	 * 과정 기본정보 개별 정보
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsCourse(RequestBox requestBox) throws Exception;

	/**
	 * 과정 기본정보 테마 멕스값 가져오기
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsCourseMaxThemeSeq(RequestBox requestBox) throws Exception;
	
	/**
	 * 과정 기본정보 등록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int insertLmsCourse(RequestBox requestBox) throws Exception;
	
	/**
	 * 과정 기본정보 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsCourse(RequestBox requestBox) throws Exception;
	
	int insertLmsCourseCondition(RequestBox requestBox) throws Exception;
	
	int updateLmsCourseRequestDate(RequestBox requestBox) throws Exception;
	
	int deleteLmsCourseCondition(RequestBox requestBox) throws Exception;
	
	int copyLmsCourseAjax(RequestBox requestBox) throws Exception;
	
	int copyLmsConditionAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 과정 테마정보  목록
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	List<DataBox> selectLmsThemeList(RequestBox requestBox) throws Exception;
	
	List<DataBox> selectLmsCourseConditionList(RequestBox requestBox) throws Exception;
	
	List<DataBox> selectLmsCourseConditionDiaList(RequestBox requestBox) throws Exception;
	
	List<DataBox> selectLmsTargetCodeList(RequestBox requestBox) throws Exception;
	
	List<DataBox> selectLmsTargetConditionList(RequestBox requestBox) throws Exception;
	
}