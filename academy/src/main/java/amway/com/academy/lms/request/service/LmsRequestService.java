package amway.com.academy.lms.request.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsRequestService {

	/**
	 *  통합교육 신청 과정 리스트 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int selectLmsRequestListCount(RequestBox requestBox) throws Exception;
	
	/**
	 *  통합교육 신청 과정 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsRequestList(RequestBox requestBox) throws Exception;


	/**
	 *  통합교육 신청 정규과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectLmsRequestRegularDetail(RequestBox requestBox) throws Exception;

	
	/**
	 *  통합교육 오프라인 과정 강의장 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsRequestApList(RequestBox requestBox) throws Exception;

	/**
	 *  통합교육 오프라인 과정 달력 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsRequestMonthDate(RequestBox requestBox) throws Exception;

	
	/**
	 *  통합교육 신청 오프라인 과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectLmsRequestOfflineDetail(RequestBox requestBox) throws Exception;

	/**
	 *  통합교육 신청 라이브 과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectLmsRequestLiveDetail(RequestBox requestBox) throws Exception;
	
	
	/**
	 *  통합교육 신청 수강신청 처리
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> insertCourseRequest(RequestBox requestBox) throws Exception;
	
	
	/**
	 *  무권한 페이지 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectLmsShareCourseDetail(RequestBox requestBox) throws Exception;
	
}
