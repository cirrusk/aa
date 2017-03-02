package amway.com.academy.lms.myAcademy.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsMyEducationMapper {

	/**
	 * 통합교육 - 월 접속 일수 -전체
	 * @param requestBox
	 * @return
	 */
	int selectLmsConnectLogTot(RequestBox requestBox);
	
	/**
	 * 통합교육 - 월 접속 일수 -설정달
	 * @param requestBox
	 * @return
	 */
	int selectLmsConnectLogCnt(RequestBox requestBox);
	
	/**
	 * 통합교육 - 개근주 -전체
	 * @param requestBox
	 * @return
	 */
	int selectLmsConnectLogWeekTot(RequestBox requestBox);
	
	/**
	 * 통합교육 - 개근주 - 연속
	 * @param requestBox
	 * @return
	 */
	int selectLmsConnectLogWeekTot2(RequestBox requestBox);
	
	/**
	 * 통합교육 - 개근주 -설정달
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectLmsConnectLogWeekList(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 - 월 개근주 단순 출석 주
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectLmsConnectLogWeekList2(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 - 수료건수 -전체
	 * @param requestBox
	 * @return
	 */
	int selectLmsCourseStudentFinshTot(RequestBox requestBox);
	
	/**
	 * 통합교육 - 수료건수 -설정달
	 * @param requestBox
	 * @return
	 */
	int selectLmsCourseStudentFinshCnt(RequestBox requestBox);

	/**
	 * 통합교육 - 과정갯수(SNS공유, 조회) -전체
	 * @param requestBox
	 * @return
	 */
	int selectLmsCourseViewlogTot(RequestBox requestBox);
	
	/**
	 * 통합교육 - 과정갯수(SNS공유, 조회) -설정달
	 * @param requestBox
	 * @return
	 */
	int selectLmsCourseViewlogCnt(RequestBox requestBox);

	/**
	 * 통합교육 - SNS공유, 조회건수 -전체
	 * @param requestBox
	 * @return
	 */
	int selectLmsViewlogTot(RequestBox requestBox);
	
	/**
	 * 통합교육 - SNS공유, 조회건수 -설정달
	 * @param requestBox
	 * @return
	 */
	int selectLmsViewlogCnt(RequestBox requestBox);

	/**
	 * 통합교육 - 정규과정 스템프 발행건수
	 * @param requestBox
	 * @return
	 */
	int selectLmsStampRegularCnt(RequestBox requestBox);

	/**
	 * 통합교육 - 스템프 발행 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectLmsStampobtain(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 - 정규과정 스템프 발행 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectLmsStampRegular(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 - 스템프 항목 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectLmsStampIdList(RequestBox requestBox) throws Exception;

	/**
	 * 현재 연도 가져오기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectLmsStampNowYear(RequestBox requestBox) throws Exception;
	
	
	

}
