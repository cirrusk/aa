package amway.com.academy.manager.lms.common.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsCommonMapper {
	
	/**
	 * 공통코드 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsCommonCodeList(RequestBox requestBox) throws Exception;


	/**
	 * 교육분류 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsCategoryCodeList(RequestBox requestBox) throws Exception;

	/**
	 * 교육분류 3단 가져오기
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	DataBox selectLmsCategoryCode3Depth(RequestBox requestBox) throws Exception;

	/**
	 * 교육장소 코드 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsApCodeList(RequestBox requestBox) throws Exception;

	/**
	 * 교육장소강의실 코드 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsRoomCodeList(RequestBox requestBox) throws Exception;
	
	/**
	 * 쪽지 등록
	 * @param Map
	 * @return
	 */
	public int insertLmsNoteSend(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 쪽지 등록 구독 카테 고리
	 * @param Map
	 * @return
	 */
	public int insertLmsNoteSendLmsSubsribe(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 현재 날짜 가져오기 2016년 9월 25일(일) 10:00:00
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	DataBox selectNowDate(RequestBox requestBox) throws Exception;
	
	/**
	 * 현재 날짜 가져오기 YYYYMMDDHHMMSS
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	DataBox selectYYYYMMDDHHMISS(RequestBox requestBox) throws Exception;

	/**
	 * 하루전 날짜 가져오기 YYYYMMDDHHMMSSMINUS
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	DataBox selectYYYYMMDDHHMISSMINUS(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 회원정보 가져오기
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	DataBox selectLmsMemberInfo(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 오프라인 교육 1일전 안내 쪽지 발송
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	void lmsSchedulerOffLineNoteSend(Map<String, Object> map) throws Exception;
	
	/**
	 * GLMS 데이타 연동
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	void lmsSchedulerGLMSInterface(Map<String, Object> map) throws Exception;
	
	/**
	 * MEMBER DW 연동
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	void lmsSchedulerMemberDwInterface(Map<String, Object> map) throws Exception;
	
	/**
	 * 개인화 컨텐츠 푸시 대상자 가져오기
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsPushSendSubsribeMember(RequestBox requestBox) throws Exception;
	
	
	/**
	 * AmwayGo 그룹방 동기화 procedure 
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	void lmsAmwayGoDataSynch(RequestBox requestBox) throws Exception;
}