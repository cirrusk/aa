package amway.com.academy.manager.lms.regularMg.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;


public interface LmsRegularMgService {
	
	//정규과정 운영 List 카운트
	int selectLmsRegularMgCount(RequestBox requestBox) throws Exception;
	
	//정규과정 운영 List
	List<DataBox> selectLmsRegularMgList(RequestBox requestBox) throws Exception;
	
	//교육상태 코드 리스트
	List<DataBox> selectLmsEduStatusCodeList(RequestBox requestBox) throws Exception;
	
	//정규과정Mg 목록 엑셀 다운로드
	List<Map<String, String>> selectLmsRegularMgListExcelDown(RequestBox requestBox) throws Exception;
	
	//정규과정Mg 상세 Info
	DataBox lmsRegularMgDetail(RequestBox requestBox) throws Exception;
	
	//교육현황 탭 리스트 가져오기
	List<DataBox> lmsRegularMgDetailEduStatusListAjax(RequestBox requestBox) throws Exception;
	
	//교육신청자 탭 리스트 가져오기
	List<DataBox>lmsRegularMgApplicantListAjax(RequestBox requestBox) throws Exception;
	
	//교육신청자 탭 리스트 카운트 가져오기
	int lmsRegularMgApplicantListCount(RequestBox requestBox) throws Exception;

	//PINCODE LIST 조회
	public List<DataBox> selectLmsPinCodeList(RequestBox requestBox) throws Exception;
	
	//정규과정 신청 취소
	int lmsRegularMgApplicantDeleteAjax(RequestBox requestBox) throws Exception;
	
	 //정규과정 내에 오프라인 과정이 있을 경우 apList가져오기
	List<DataBox> lmsRegularMgApplicantPopApList(RequestBox requestBox) throws Exception;
	
	//교육장소 리스트
	//List<DataBox> selectLmsRegularMgPPSVINFO() throws Exception;
	
	//applicant팝용 정보
	Map<String, Object> selectLmsRegularMgApplicantPopDetail(RequestBox requestBox) throws Exception;
	
	//정규과정Mg 상세 applicant pop Count
	int selectLmsRegularMgDetailApplicantPopCount(RequestBox requestBox) throws Exception;
	
	//정규과정Mg 상세 applicant Pop 목록
	List<DataBox> selectLmsRegularMgDetailApplicantPop(RequestBox requestBox) throws Exception;
	
	//정규과정Mg 신청자 추가
	Map<String, Object> lmsRegularMgApplicantAddAjax(RequestBox requestBox) throws Exception;
	
	//member테이블에 해당 uid가 있는지 Check하기
	String lmsRegularMgAboNumberCheck(RequestBox requestBox) throws Exception;
	
	//교육장소 존재 여부 Check
	String lmsRegularMgAddApplicantCheckApseq(RequestBox requestBox) throws Exception;
	
	//EXCEL로 수강신청
	Map<String, Object> lmsRegularMgAddApplicantExcelAjax(RequestBox requestBox,List<Map<String, String>> retSuccessList) throws Exception;
	
	//단계명리스트 조회
	List<DataBox> lmsRegularMgDetailStepList(RequestBox requestBox) throws Exception;
	
	//하위과정 조회
	List<DataBox> lmsRegularMgDetailStepCourseList(RequestBox requestBox) throws Exception;
	
	//courseType 조회
	String lmsRegularMgChagedCourseType(RequestBox requestBox) throws Exception;
	
	//과정 정보 조히
	DataBox lmsRegularMgOnlineLiveDataInfo(RequestBox requestBox) throws Exception;
	
	//단계정보 조회
	DataBox lmsRegularMgDetailStepInfo(RequestBox requestBox) throws Exception;
	
	// step Student 리스트
	List<DataBox> lmsRegularMgDetailStepStudentListAjax(RequestBox requestBox) throws Exception;
	
	// step Student 리스트 카운트
	int lmsRegularMgDetailStepStudentListCount(RequestBox requestBox) throws Exception;
	
	// 교육과정 탭 Online Course Student리스트
	List<DataBox> lmsRegularMgOnlineLiveDataStudentListAjax(RequestBox requestBox) throws Exception;
	
	// 교육과정 탭 Online Course Student리스트 카운트
	int lmsRegularMgOnlineLiveDataStudentListAjaxCount(RequestBox requestBox) throws Exception;
	
	//정규과정Mg Detail 온라인,라이브,교육자료 과정 수료 처리
	int lmsRegularMgOnlineLiveDataFinishUpdateAjax(RequestBox requestBox) throws Exception ;
	
	//오프라인 고정 정보 조회
	DataBox lmsRegularMgOfflineCourseInfo(RequestBox requestBox) throws Exception ;
	
	//출석처리 Update
	int lmsRegularMgOfflineAttendUpdateAjax(RequestBox requestBox) throws Exception ;

	//attend팝업용 Info
	Map<String, Object> lmsRegularMgDetailOfflineAttendPopInfo(RequestBox requestBox) throws Exception ;
	
	//과정 정보 조회
	DataBox lmsRegularMgTestCourseInfo(RequestBox requestBox) throws Exception ;
	
	// 교육과정 탭 Test Student리스트 카운트
	int lmsRegularMgTestListAjaxCount(RequestBox requestBox) throws Exception ;
	
	// 교육과정 탭 Test Student리스트
	List<DataBox> lmsRegularMgTestListAjax(RequestBox requestBox) throws Exception ;
	
	//스텝 하위  Test 과정 수료 처리
	int lmsRegularMgTestFinishUpdateAjax(RequestBox requestBox) throws Exception ;
	
	 //시험 정보 가져오기
	DataBox lmsRegularMgDetailTestStudentInfo(RequestBox requestBox) throws Exception ;
	
	//문제 리스트 가져오기
	Map<String, Object> lmsRegularMgDetailTestList(RequestBox requestBox) throws Exception ;
	
	//동반자신청이 아닌 경우 출석 처리하고 좌석배정한뒤 회원정보 조회
	DataBox lmsRegularMgAttendBarcodeMemberInfo(RequestBox requestBox, int step) throws Exception ;
	
	//주관식 점수 엑설 Popup호출
	String lmsRegularMgDetailTestSubjectExcelPop(RequestBox requestBox) throws Exception ;

	Map<String, Object> lmsRegularMgTestSubjectExcelAjax(RequestBox requestBox, List<Map<String, String>> retSuccessList) throws Exception ;
	
	//객관식 재채점
	int lmsRegularMgTestObjectRemarking(RequestBox requestBox) throws Exception ;
	
	//시험 개인별 정보 가져오기
	DataBox lmsRegularMgDetailTestSubjectAnswerPop(RequestBox requestBox) throws Exception ;
	
	//개인별 주관식 답안지
	List<DataBox> lmsRegularMgDetailEachTestSubjectAnswer(RequestBox requestBox) throws Exception ;
	
	 //주관식 개별 채점
	int lmsRegularMgDetailEachSubjectPointUpdate(RequestBox requestBox) throws Exception ;
	
	//출석처리 엑셀등록
	void insertLmsRegularMgAttendHandle(RequestBox requestBox,List<Map<String, String>> retSuccessList) throws Exception ;
	
	//교육신청자인지 아닌지 확인하기
	String lmsRegularMgAttendRegisterCheck(RequestBox requestBox) throws Exception ;
	
	//동반신청과정이면서 동반신청인 경우 CHECK
	String lmsRegularMgAttendBarcodeTogetherCheck(RequestBox requestBox) throws Exception ;
	
	//바코드 팝업 창  confirm구역에 보여줄 리스트 조회하기
	DataBox lmsRegularMgAttendBarcodeConfirmInfo(RequestBox requestBox) throws Exception ;
	
	//alert용 회원정보 조회
	DataBox lmsRegularMgAttendBarcodeNoAppllicantInfo(RequestBox requestBox) throws Exception ;
	
	//설문용 정보 조회
	DataBox lmsRegularMgServeyCourseInfo(RequestBox requestBox) throws Exception;
	
	//설문결과 가져오기
	Map<String, Object> lmsRegularMgDetailSurveyList(RequestBox requestBox) throws Exception;
	
	// 설문대상자 탭  Student리스트
	List<DataBox> lmsRegularMgDetailSurveyCourseListAjax(RequestBox requestBox) throws Exception;
	
	//// 설문대상자 탭  Student리스트 카운트
	int lmsRegularMgDetailSurveyCourseListCount(RequestBox requestBox) throws Exception;
	
	//정규과정 스탭 리스트
	 List<DataBox> selectLmsStepList(RequestBox requestBox) throws Exception;
	 
	 //정규과정 수료 합계 읽기
	 DataBox selectRegularMgFinishTotal(RequestBox requestBox) throws Exception ;
	 
	 // 수료자 갯수 읽기
	 int lmsRegularMgFinishListCount(RequestBox requestBox) throws Exception ;
	 
	 //수료자 정보 읽기
	 List<DataBox> lmsRegularMgFinishListAjax(RequestBox requestBox) throws Exception;
	 
	 //수료자의 스탶별 이수현황
	 List<DataBox> lmsRegularMgFinishStepList(RequestBox requestBox) throws Exception;
	 
	 //개인별 설문지 호출
	Map<String, Object> lmsRegularMgDetailSurveyResponsePop(RequestBox requestBox) throws Exception;
	
	//회원정보
	DataBox lmsRegularMgDetailSurveyResponsePopInfo(RequestBox requestBox) throws Exception;
	
	//정규과정 수료 처리
	int lmsRegularMgFinishUpdateAjax(RequestBox requestBox) throws Exception;
	
	//정규과정Mg Survey Result Excel  다운로드
	List<Map<String, String>> lmsRegularMgSurveyExcelDownload(RequestBox requestBox) throws Exception;
	
	//부사업자신청 허용 flag가져오기
	String selectLmsRegularMgOfflineTogetherFlag(RequestBox requestBox) throws Exception;
	 
	
}
