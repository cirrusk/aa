package amway.com.academy.lms.request.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsRequestMapper {
	
	/**
	 * 통합교육 신청 과정 리스트 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int selectLmsRequestListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 신청 과정 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsRequestList(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 신청 과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsRequestDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 신청 정규 과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsRequestRegularDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 신청 정규 과정 상세 교육장 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsRequestCourseApList(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 신청 정규 과정 상세 신청기간 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsRequestDateList(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 신청 정규 과정 유닛 목록 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsRequestStepUnitList(RequestBox requestBox) throws Exception;
	
	/**
	 *  통합교육 신청 오프라인 강의장 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsRequestApList(RequestBox requestBox) throws Exception;

	/**
	 *  통합교육 신청 오프라인 달력
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsRequestMonthDate(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 신청 오프라인 과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsRequestOfflineDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 신청 라이브 과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsRequestLiveDetail(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 신청 수강신청 유효성 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsRequestCheck(RequestBox requestBox) throws Exception;
	
	
	/**
	 *  통합교육 신청 포함된 과정 가져오기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsRequestCourseList(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 신청 입력하기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int insertCourseRequest(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 신청 스탭 입력하기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int insertCourseRequestStep(RequestBox requestBox) throws Exception;
	
	/**
	 * 무권한 페이지 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsCourseShareDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * 무권한 페이지 상세 교육자료
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsCourseShareDetailData(RequestBox requestBox) throws Exception;
	
}
