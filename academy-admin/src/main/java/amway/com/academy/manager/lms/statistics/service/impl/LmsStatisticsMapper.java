package amway.com.academy.manager.lms.statistics.service.impl;



import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsStatisticsMapper {
	
	/**
	 * //회계년도 가져오기
	 * @return int
	 */
	int selectLmsYear() throws Exception;
	
	/**
	 * 월별 접속(누적)
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox lmsStatisticsConnectPerMonth(RequestBox requestBox) throws Exception;
	
	/**
	 * //월별 순수접속(UV)
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox lmsStatisticsConnectUVPerMonth(RequestBox requestBox) throws Exception;
	
	/**
	 * //콘텐츠 조회
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox lmsStatisticsContentsViewCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //온라인 수료
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox lmsStatisticsOnlineFinishCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //오프라인 출석
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox lmsStatisticsOfflineFinishCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //스탬프 획득
	 * @param requestBox
	 * @return DataBox
	 */ 
	DataBox lmsStatisticsStampObtainCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육자료,온라인 조회수 상위 20
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsStatisticsPerMonthTop20(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육자료,온라인 조회수 상위 20 엑셀 다운
	 * @param requestBox
	 * @return List
	 */
	List<Map<String,String>> lmsStatisticsPerMonthTop20ExcelDown(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인과정 참석자 상위 10
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsStatistisOfflineAttendPerMonthTop10(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인과정 참석자 상위 10 엑셀다운
	 * @param requestBox
	 * @return List
	 */
	List<Map<String, String>> lmsStatistisOfflineAttendPerMonthTop10ExcelDown(RequestBox requestBox) throws Exception;
	
	/**
	 * 온라인,라이브과정 보고서 목록
	 * @param requestBox
	 * @return
	 */
	List<DataBox> lmsReportListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 온라인,라이브 과정보고서 목록 카운트
	 * @param requestBox
	 * @return
	 */
	int lmsReportListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //보고서 팝업용 Data
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox selectLmsReportPopData(RequestBox requestBox) throws Exception;
	
	/**
	 *	핀코드리스트 조회
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> selectLmsPinCodeList(RequestBox requestBox) throws Exception;
	
	/**
	 * // 레이어팝업 리스트 카운트
	 * @param requestBox
	 * @return int
	 */
	int lmsReportPopListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * // 레이어팝업 리스트
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsReportPopListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * //과정보고서 엑셀용 데이터
	 * @param requestBox
	 * @return List
	 */
	List<Map<String, String>> lmsReportExcelDownload(RequestBox requestBox) throws Exception;
	
	/**
	 * //단계수 조회
	 * @param requestBox
	 * @return int
	 */
	int selectLmsRegularStepCount(RequestBox requestBox) throws Exception;
	
	/**
	 * // 정규과정보고서 리스트 카운트
	 * @param requestBox
	 * @return int
	 */
	int lmsReportRegularCourseListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * // 정규과정보고서 리스트
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsReportRegularCourseListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * //정규과정보고서 엑셀용 데이터
	 * @param requestBox
	 * @return List
	 */
	List<Map<String, String>> lmsReportRegularCurseExcelDownload(RequestBox requestBox) throws Exception;
	
}

























