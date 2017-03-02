package amway.com.academy.lms.online.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface LmsOnlineService {

	/**
	 * 온라인강의 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectOnlineListCount(RequestBox requestBox);
	
	/**
	 * 온라인강의 조회 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectOnlineList(RequestBox requestBox) throws Exception;

	/**
	 * 온라인강의 상세보기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectOnlineView(RequestBox requestBox) throws Exception;
	
	public int selectOnlineViewCount(RequestBox requestBox) throws Exception;
}
