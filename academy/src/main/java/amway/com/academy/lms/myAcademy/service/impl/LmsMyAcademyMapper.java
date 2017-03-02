package amway.com.academy.lms.myAcademy.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsMyAcademyMapper {

	/**
	 * 통합교육 신청현황 강좌 달력 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsMyAcademyCourseCalendar(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 통합교육 신청현황 강좌 페이징 목록 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int selectLmsMyAcademyCourseListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 신청현황 강좌 페이징 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsMyAcademyCourseList(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 신청현황 강좌 정규과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsMyAcademyRegular(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 신청현황 강좌 정규과정 상세 구성강좌 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsMyAcademyRegularUnit(RequestBox requestBox) throws Exception;

	
	/**
	 * 신청현황 정규과정 오프라인 좌석 목록 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsMyAcademyRegularSeat(RequestBox requestBox) throws Exception;
	
	/**
	 * 통합교육 신청현황 강좌 오프라인강좌 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsMyAcademyOffline(RequestBox requestBox) throws Exception;

	/**
	 * 통합교육 신청현황 강좌 라이브교육 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsMyAcademyLive(RequestBox requestBox) throws Exception;
	
	/**
	 * 신청현황 취소 가능 여부 검색
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsMyAcademyCancelPossible(RequestBox requestBox) throws Exception;
	
	/**
	 * 신청현황 교육신청 취소
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int updateLmsMyAcademyCancel(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당월의 교육정보 읽어오기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsMyAcademyDayCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당일의 정보 읽어오기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsMyAcademyCourseCalendarDay(RequestBox requestBox) throws Exception;
	
	/**
	 * 신청현황 기본 정보 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox selectLmsMyAcademyListView(RequestBox requestBox) throws Exception;
	
}
