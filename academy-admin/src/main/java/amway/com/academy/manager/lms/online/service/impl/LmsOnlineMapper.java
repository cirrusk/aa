package amway.com.academy.manager.lms.online.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsOnlineMapper {

	/**
	 * 온라인 카운트
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsOnlineCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 온라인 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsOnlineList(RequestBox requestBox) throws Exception;

	/**
	 * 온라인 리스트 엑셀다운
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<Map<String, String>> selectLmsOnlineListExcelDown(RequestBox requestBox) throws Exception;
	
	/**
	 * 온라인 개별정보 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsOnline(RequestBox requestBox) throws Exception;
	
	/**
	 * 온라인 개별 정보
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsOnline(RequestBox requestBox) throws Exception;
	
	/**
	 * 온라인 개별 정보 등록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int insertLmsOnline(RequestBox requestBox) throws Exception;
	
	/**
	 * 온라인 개별 정보 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int updateLmsOnline(RequestBox requestBox) throws Exception;
}