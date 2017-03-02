package amway.com.academy.manager.lms.statistics.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;


public interface LmsStatisticsService {
	
	//회계년도 가져오기
	int selectLmsYear() throws Exception;
	
	//월별 아카데미 현황
	List<DataBox> lmsStatisticsAcademyStatusPerMonth(RequestBox requestBox) throws Exception;
	
	//월별 아카데미 현황 엑셀 다운
	List<Map<String, String>> lmsStatisticsAcademyStatusPerMonthExcelDown(RequestBox requestBox) throws Exception;
	
	//교육자료,온라인 조회수 상위 20
	List<DataBox> lmsStatisticsPerMonthTop20(RequestBox requestBox) throws Exception;

	//교육자료,온라인 조회수 상위 20 엑셀 다운
	List<Map<String, String>> lmsStatisticsPerMonthTop20ExcelDown(RequestBox requestBox) throws Exception;
	
	///오프라인과정 참석자 상위 10
	List<DataBox> lmsStatistisOfflineAttendPerMonthTop10(RequestBox requestBox) throws Exception;
	
	///오프라인과정 참석자 상위 10
	List<Map<String, String>> lmsStatistisOfflineAttendPerMonthTop10ExcelDown(RequestBox requestBox) throws Exception;

	//온라인,라이브과정보고서 목록
	List<DataBox> lmsReportListAjax(RequestBox requestBox) throws Exception;
	
	//온라인,라이브과정보고서 목록 카운트
	int lmsReportListCount(RequestBox requestBox) throws Exception;

	//보고서 팝업용 Data
	DataBox selectLmsReportPopData(RequestBox requestBox) throws Exception;
	
	//핀코드리스트 조회
	List<DataBox> selectLmsPinCodeList(RequestBox requestBox) throws Exception;

	// 레이어팝업 리스트
	List<DataBox> lmsReportPopListAjax(RequestBox requestBox) throws Exception;
	
	// 레이어팝업 리스트 카운트
	int lmsReportPopListCount(RequestBox requestBox) throws Exception;
	
	//과정보고서 엑셀용 데이터
	List<Map<String, String>> lmsReportExcelDownload(RequestBox requestBox) throws Exception;
	
	//단계수 조회
	int selectLmsRegularStepCount(RequestBox requestBox) throws Exception;

	// 정규과정보고서 리스트 카운트
	int lmsReportRegularCourseListCount(RequestBox requestBox) throws Exception;
	
	// 정규과정보고서 리스트
	List<DataBox> lmsReportRegularCourseListAjax(RequestBox requestBox) throws Exception;
	
	//정규과정보고서 엑셀용 데이터
	List<Map<String, String>> lmsReportRegularCurseExcelDownload(RequestBox requestBox) throws Exception;
}
