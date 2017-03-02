package amway.com.academy.lms.myAcademy.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsMyAcademyService {

	
	/**
	 *  통합교육 신청현황 캘린더 보기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsRequestMonthDate(RequestBox requestBox) throws Exception;
	
	/**
	 *  통합교육 신청현황 캘린더 과정 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsMyAcademyCourseCalendar(RequestBox requestBox) throws Exception;


	/**
	 *  통합교육 신청현황 페이징 과정 목록 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int selectLmsMyAcademyCourseListCount(RequestBox requestBox) throws Exception;
	
	/**
	 *  통합교육 신청현황 페이징 과정 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsMyAcademyCourseList(RequestBox requestBox) throws Exception;
	
	/**
	 *  통합교육 신청현황 정규과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox selectLmsMyAcademyRegular(RequestBox requestBox) throws Exception;
	
	/**
	 *  통합교육 신청 정규과정 상세 구성강좌 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsMyAcademyRegularUnit(RequestBox requestBox) throws Exception;
	
	/**
	 *  통합교육 신청현황 오프라인강의 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox selectLmsMyAcademyOffline(RequestBox requestBox) throws Exception;
	
	/**
	 *  통합교육 신청현황 라이브교육 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox selectLmsMyAcademyLive(RequestBox requestBox) throws Exception;

	/**
	 *  신청현황 교육신청 취소
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox updateLmsMyAcademyCancel(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 해당월의 정규과정, 오프라인강의, 라이브교육의 갯수 읽어오기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsMyAcademyDayCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당일자의 모든 교육정보 읽어오기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsMyAcademyCourseCalendarDay(RequestBox requestBox) throws Exception;
	
	/**
	 *  신청현황 기본 정보 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox selectLmsMyAcademyListView(RequestBox requestBox) throws Exception;
	
}
