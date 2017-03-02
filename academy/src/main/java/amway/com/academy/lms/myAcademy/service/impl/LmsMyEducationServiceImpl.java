package amway.com.academy.lms.myAcademy.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.lms.myAcademy.service.LmsMyEducationService;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsMyEducationServiceImpl implements LmsMyEducationService {
	@Autowired
	private LmsMyEducationMapper lmsMyEducationMapper;

	/**
	 * 통합교육 - 월 접속 일수 -전체
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectLmsConnectLogTot(RequestBox requestBox) {
		
		return (int) lmsMyEducationMapper.selectLmsConnectLogTot(requestBox);
	}

	/**
	 * 통합교육 - 월 접속 일수 -설정달
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectLmsConnectLogCnt(RequestBox requestBox) {
		
		return (int) lmsMyEducationMapper.selectLmsConnectLogCnt(requestBox);
	}

	/**
	 * 통합교육 - 개근주 -전체
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectLmsConnectLogWeekTot(RequestBox requestBox) {
		
		return (int) lmsMyEducationMapper.selectLmsConnectLogWeekTot(requestBox);
	}

	/**
	 * 통합교육 - 개근주 -전체 연속
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectLmsConnectLogWeekTot2(RequestBox requestBox) {
		
		return (int) lmsMyEducationMapper.selectLmsConnectLogWeekTot2(requestBox);
	}
	
	/**
	 * 통합교육 - 개근주 -설정달
	 * @param requestBox
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectLmsConnectLogWeekList(RequestBox requestBox)  throws Exception {
		
		return lmsMyEducationMapper.selectLmsConnectLogWeekList(requestBox);
	}
	
	/**
	 * 통합교육 - 개근주 -설정달
	 * @param requestBox
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectLmsConnectLogWeekList2(RequestBox requestBox)  throws Exception {
		
		return lmsMyEducationMapper.selectLmsConnectLogWeekList2(requestBox);
	}

	/**
	 * 통합교육 - 수료건수 -전체
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectLmsCourseStudentFinshTot(RequestBox requestBox) {
		
		return (int) lmsMyEducationMapper.selectLmsCourseStudentFinshTot(requestBox);
	}

	/**
	 * 통합교육 - 수료건수 -설정달
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectLmsCourseStudentFinshCnt(RequestBox requestBox) {
		
		return (int) lmsMyEducationMapper.selectLmsCourseStudentFinshCnt(requestBox);
	}

	/**
	 * 통합교육 - 과정갯수(SNS공유, 조회) -전체
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectLmsCourseViewlogTot(RequestBox requestBox) {
		
		return (int) lmsMyEducationMapper.selectLmsCourseViewlogTot(requestBox);
	}

	/**
	 * 통합교육 - 과정갯수(SNS공유, 조회) -설정달
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectLmsCourseViewlogCnt(RequestBox requestBox) {
		
		return (int) lmsMyEducationMapper.selectLmsCourseViewlogCnt(requestBox);
	}

	/**
	 * 통합교육 - SNS공유, 조회건수 -전체
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectLmsViewlogTot(RequestBox requestBox) {
		
		return (int) lmsMyEducationMapper.selectLmsViewlogTot(requestBox);
	}

	/**
	 * 통합교육 - SNS공유, 조회건수 -설정달
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectLmsViewlogCnt(RequestBox requestBox) {
		
		return (int) lmsMyEducationMapper.selectLmsViewlogCnt(requestBox);
	}

	
	/**
	 * 통합교육 - 정규과정 스템프 발행건수
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectLmsStampRegularCnt(RequestBox requestBox) {
		
		return (int) lmsMyEducationMapper.selectLmsStampRegularCnt(requestBox);
	}

	/**
	 * 통합교육 - 스템프 발행 조회
	 * @param requestBox
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectLmsStampobtain(RequestBox requestBox)  throws Exception {
		
		return lmsMyEducationMapper.selectLmsStampobtain(requestBox);
	}

	/**
	 * 통합교육 - 정규과정 스템프 발행 조회
	 * @param requestBox
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectLmsStampRegular(RequestBox requestBox)  throws Exception {
		
		return lmsMyEducationMapper.selectLmsStampRegular(requestBox);
	}

	/**
	 * 통합교육 - 스템프 항목 조회
	 * @param requestBox
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectLmsStampIdList(RequestBox requestBox)  throws Exception {
		
		return lmsMyEducationMapper.selectLmsStampIdList(requestBox);
	}
	
	/**
	 * 현재 연도 가져오기
	 * @param requestBox
	 * @return
	 */
	@Override
	public Map<String, Object> selectLmsStampNowYear(RequestBox requestBox)  throws Exception {
		
		return lmsMyEducationMapper.selectLmsStampNowYear(requestBox);
	}
	
}
