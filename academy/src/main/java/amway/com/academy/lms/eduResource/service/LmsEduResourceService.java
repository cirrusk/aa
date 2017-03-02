package amway.com.academy.lms.eduResource.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface LmsEduResourceService {

	/**
	 * 교육과정 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectEduResourceListCount(RequestBox requestBox);
	
	/**
	 *  교육과정 조회 - 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectEduResourceList(RequestBox requestBox) throws Exception;

	/**
	 *  교육과정 상세보기 - 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectEduResourceView(RequestBox requestBox) throws Exception;

	/**
	 *  교육과정 이전, 다음  - 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectEduResourceViewPrevNext(RequestBox requestBox) throws Exception;

	/**
	 *  교육과정 이전, 다음상세보기  - 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectEduResourceViewList(RequestBox requestBox) throws Exception;
	
	public List<Map<String, Object>> selectEduResourceViewPrevNextList(RequestBox requestBox) throws Exception;
	
}
