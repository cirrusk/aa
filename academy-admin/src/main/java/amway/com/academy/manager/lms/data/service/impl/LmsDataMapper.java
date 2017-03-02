package amway.com.academy.manager.lms.data.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsDataMapper {

	/**
	 * 교육자료 카운트
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsDataCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육자료 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsDataList(RequestBox requestBox) throws Exception;

	/**
	 * 교육자료 리스트 엑셀다운
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<Map<String, String>> selectLmsDataListExcelDown(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육자료 개별정보 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsData(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육자료 개별 정보
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsData(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육자료 개별 정보 등록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int insertLmsData(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육자료 개별 정보 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsData(RequestBox requestBox) throws Exception;
	
	int copyLmsDataAjax(RequestBox requestBox) throws Exception;
	
}