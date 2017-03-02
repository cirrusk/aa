package amway.com.academy.manager.lms.offline.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsOfflineMapper {

	/**
	 * 오프라인 카운트
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsOfflineCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsOfflineList(RequestBox requestBox) throws Exception;

	/**
	 * 오프라인 리스트 엑셀다운
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<Map<String, String>> selectLmsOfflineListExcelDown(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인 개별정보 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsOffline(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인 개별 정보
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsOffline(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인 개별 정보 등록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int insertLmsOffline(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인 개별 정보 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsOffline(RequestBox requestBox) throws Exception;
}