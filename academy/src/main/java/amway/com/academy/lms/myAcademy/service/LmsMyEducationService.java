package amway.com.academy.lms.myAcademy.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

public interface LmsMyEducationService {
	
	/**
	 * 통합교육 - 월 접속 일수 -전체
	 * @param requestBox
	 * @return
	 */
	public int selectLmsConnectLogTot(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 - 월 접속 일수 -설정달
	 * @param requestBox
	 * @return
	 */
	public int selectLmsConnectLogCnt(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 - 개근주 -전체
	 * @param requestBox
	 * @return
	 */
	public int selectLmsConnectLogWeekTot(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 - 개근주 -전체 연속
	 * @param requestBox
	 * @return
	 */
	public int selectLmsConnectLogWeekTot2(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 - 개근주 -설정달
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectLmsConnectLogWeekList(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 - 월 개근주 단순 출석 주
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectLmsConnectLogWeekList2(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 - 수료건수 -전체
	 * @param requestBox
	 * @return
	 */
	public int selectLmsCourseStudentFinshTot(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 - 수료건수 -설정달
	 * @param requestBox
	 * @return
	 */
	public int selectLmsCourseStudentFinshCnt(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 - 과정갯수(SNS공유, 조회)  -전체
	 * @param requestBox
	 * @return
	 */
	public int selectLmsCourseViewlogTot(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 - 과정갯수(SNS공유, 조회)  -설정달
	 * @param requestBox
	 * @return
	 */
	public int selectLmsCourseViewlogCnt(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 - SNS공유, 조회건수 -전체
	 * @param requestBox
	 * @return
	 */
	public int selectLmsViewlogTot(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 - SNS공유, 조회건수 -설정달
	 * @param requestBox
	 * @return
	 */
	public int selectLmsViewlogCnt(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 - 정규과정 스템프 발행건수
	 * @param requestBox
	 * @return
	 */
	public int selectLmsStampRegularCnt(RequestBox requestBox) throws Exception;


	/**
	 * 통합교육 - 스템프 발행 조회
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectLmsStampobtain(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 - 정규과정 스템프 발행 조회
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectLmsStampRegular(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 - 스템프 항목 조회
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, Object>> selectLmsStampIdList(RequestBox requestBox) throws Exception;
	
	/**
	 * 현재 연도 가져오기
	 * @param requestBox
	 * @return
	 */
	public Map<String, Object> selectLmsStampNowYear(RequestBox requestBox) throws Exception;
	

}
