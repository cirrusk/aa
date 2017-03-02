package amway.com.academy.manager.lms.live.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsLiveMapper {

	/**
	 * 라이브 카운트
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsLiveCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 라이브 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsLiveList(RequestBox requestBox) throws Exception;

	/**
	 * 라이브 리스트 엑셀다운
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<Map<String, String>> selectLmsLiveListExcelDown(RequestBox requestBox) throws Exception;
	
	/**
	 * 라이브 개별정보 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsLive(RequestBox requestBox) throws Exception;
	
	/**
	 * 라이브 개별 정보
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsLive(RequestBox requestBox) throws Exception;
	
	/**
	 * 라이브 개별 정보 등록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int insertLmsLive(RequestBox requestBox) throws Exception;
	
	/**
	 * 라이브 개별 정보 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsLive(RequestBox requestBox) throws Exception;
	
}