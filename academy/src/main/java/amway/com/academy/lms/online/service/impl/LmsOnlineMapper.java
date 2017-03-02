package amway.com.academy.lms.online.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsOnlineMapper {


	/**
	 * 온라인강의 리스트 count
	 * @param requestBox
	 * @return
	 */
	int selectOnlineListCount(RequestBox requestBox);
	
	/**
	 * 온라인강의 조회 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectOnlineList(RequestBox requestBox) throws Exception;

	/**
	 * 온라인강의 상세보기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectOnlineView(RequestBox requestBox) throws Exception;
	
	int selectOnlineViewCount(RequestBox requestBox);
}
