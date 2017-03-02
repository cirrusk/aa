package amway.com.academy.manager.lms.course.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsKeywordMapper {
	
	
	/**
	 * SEARCHLMS 삭제
	 * @param requestBox
	 */
	void deleteLmsKeyword(RequestBox requestBox) throws Exception;
	
	
	/**
	 * //SEARCHLMS INSERT용 데이터
	 * @param requestBox
	 * @return
	 */
	String selectLmsKeywordCourseName(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 스탬프 SEARCHLMS 삭제
	 * @param requestBox
	 * @throws Exception
	 */
	void deleteLmsKeywordStamp(RequestBox requestBox) throws Exception;
	
	/**
	 * searchLms merge문
	 * @param requestBox
	 */
	void mergeKeywordSearchLms(RequestBox requestBox) throws Exception;
	
	/**
	 * searchLms Stamp merge무
	 * @param requestBox
	 */
	void mergeKeywordSearchLmsStamp(RequestBox requestBox) throws Exception;
	
}