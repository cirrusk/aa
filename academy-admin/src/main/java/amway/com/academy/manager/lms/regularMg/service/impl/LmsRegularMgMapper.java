package amway.com.academy.manager.lms.regularMg.service.impl;


import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsRegularMgMapper {
	
	/**
	 * //정규과정 운영 List 카운트
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsRegularMgCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //정규과정 운영 List
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsRegularMgList(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육상태 코드 리스트
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> selectLmsEduStatusCodeList(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 운영 리스트 엑셀다운
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<Map<String, String>> selectLmsRegularMgListExcelDown(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정Mg 상세 Info
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox lmsRegularMgDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 스텝 목록
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsRegularMgStepList(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 스텝유닛 목록
	 * @param requestBox
	 * @return List 
	 * @throws Exception
	 */
	List<DataBox> selectLmsRegularStepMgUnitList(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육신청자 탭 리스트 가져오기
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> lmsRegularMgApplicantListAjax(RequestBox requestBox) throws Exception;

	/**
	 * 교육신청자 탭 리스트 카운트 가져오기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int lmsRegularMgApplicantListCount(RequestBox requestBox) throws Exception;

	/**
	 * PINCODE LIST 조회
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> selectLmsPinCodeList(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 취소중 하위 과정에 오프라인이 있을 경우 좌석 제거
	 * @param requestBox
	 * @throws Exception
	 */
	void deleteLmsOfflineMgSeat(RequestBox requestBox) throws Exception;

	/**
	 * 정규과정 취소중 하위 과정에 오프라인이 있을 경우 좌석 제거
	 * @param requestBox
	 * @throws Exception
	 */
	void deleteLmsOfflineMgSeatEach(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 하위 과정 수강 취소 (LMSSTUDENT 테이블)
	 * @param requestBox
	 * @throws Exception
	 */
	void lmsRegularMgApplicantLmsStudentDelete(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 하위 과정 수강 취소 (LMSSTEPUNIT 테이블)
	 * @param requestBox
	 * @throws Exception
	 */
	void lmsRegularMgApplicantLmsStepUnitDelete(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 수강 취소
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int lmsRegularMgApplicantDeleteAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * //정규과정 내에 오프라인 과정이 있을 경우 apList가져오기
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsRegularMgApplicantPopApList(RequestBox requestBox) throws Exception;
	
	/**
	 * //applicant팝용 정보
	 * @param requestBox
	 * @return Map
	 */
	Map<String, Object> selectLmsRegularMgApplicantPopDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * add applicant pop totalCount
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsRegularMgDetailApplicantPopCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //정규과정Mg 상세 applicant Pop 목록
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> selectLmsRegularMgDetailApplicantPop(RequestBox requestBox) throws Exception;
	
	/**
	 * //단계 수료(LMSSTEPFINISH) 추가
	 * @param requestBox
	 */
	void lmsRegularMgApplicantAddStep(RequestBox requestBox) throws Exception;
	
	/**
	 * //하위과정 List
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsRegularMgChildrenCourseList(RequestBox requestBox) throws Exception;
	
	/**
	 * //과정이 오프라인인 하위과정 신청
	 * @param requestBox
	 * @return int
	 */
	int lmsRegularMgApplicantAddOffline(RequestBox requestBox) throws Exception;
	
	/**
	 * //과정이 오프라인이 아닌 하위과정 신청
	 * @param requestBox
	 * @return int
	 */
	int lmsRegularMgApplicantAddNoOffline(RequestBox requestBox) throws Exception;
	
	/**
	 * //member테이블에 해당 uid가 있는지 Check하기
	 * @param requestBox
	 * @return String
	 */
	String lmsRegularMgAboNumberCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * //교육장소 존재 여부 Check
	 * @param requestBox
	 * @return String
	 */
	String lmsRegularMgAddApplicantCheckApseq(RequestBox requestBox) throws Exception;
	
	
	/**
	 * //하위과정 조회
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsRegularMgDetailStepCourseList(RequestBox requestBox) throws Exception;
	
	/**
	 * //courseType 조회
	 * @param requestBox
	 * @return String
	 */
	String lmsRegularMgChagedCourseType(RequestBox requestBox) throws Exception;
	
	/**
	 * //오프라인 과정 정보 조회
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox lmsRegularMgOnlineLiveDataInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * //단계정보 조회
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox lmsRegularMgDetailStepInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * //step Student 리스트
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsRegularMgDetailStepStudentListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * //이수 과정수 조회
	 * @param requestBox
	 * @return int
	 */
	int lmsRegularMgDetailStepStudentFinishCount(RequestBox requestBox) throws Exception;
	
	/**
	 * // step Student 리스트 카운트
	 * @param requestBox
	 * @return int
	 */
	int lmsRegularMgDetailStepStudentListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * // 교육과정 탭 Online,Live,Data Course Student리스트 카운트
	 * @param requestBox
	 * @return int
	 */
	int lmsRegularMgOnlineLiveDataStudentListAjaxCount(RequestBox requestBox) throws Exception;
	
	/**
	 * // 교육과정 탭 Online,Live,Data Student리스트
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsRegularMgOnlineLiveDataStudentListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * //정규과정Mg Detail 온라인,라이브,교육자료 과정 수료 처리
	 * @param requestBox
	 */
	void lmsRegularMgOnlineLiveDataFinishUpdateAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * //하위 과정 수료 할 때 마다 스텝 수료 로직 확인
	 * @param requestBox
	 */
	void lmsRegularMgStepFinishFlagUpdate(RequestBox requestBox) throws Exception;
	
	/**
	 * //오프라인 고정 정보 조회
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox lmsRegularMgOfflineCourseInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * //수료날짜 있는지 조회하기
	 * @param requestBox
	 * @return String
	 */
	String lmsRegularMgExistFinishDateCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * //과정 정보 조회
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox lmsRegularMgTestCourseInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * // 교육과정 탭 Test Student리스트 카운트
	 * @param requestBox
	 * @return
	 */
	int lmsRegularMgTestListAjaxCount(RequestBox requestBox) throws Exception;
	
	/**
	 * // 교육과정 탭 Test Student리스트 
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsRegularMgTestListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 *  //스텝 하위  Test 과정 수료 처리
	 * @param requestBox
	 * @throws Exception
	 */
	void lmsRegularMgTestFinishUpdateAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * //시험 정보 가져오기
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox lmsRegularMgDetailTestStudentInfo(RequestBox requestBox) throws Exception;

	/**
	 * //문제 리스트 가져오기
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsRegularMgDetailTestList(RequestBox requestBox) throws Exception;
	
	/**
	 * //보기,지문 리스트 가져오기
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsRegularMgDetailTestAnswerList(RequestBox requestBox) throws Exception;
	
	/**
	 *정규과정 수료 여부 체크
	 * @param requestBox
	 */
	void lmsRegularMgTotalFinishUpdate(RequestBox requestBox) throws Exception;
	
	/**
	 * //정규과정 스탬프 처리
	 * @param requestBox
	 */
	void lmsRegularMgStampInsert(RequestBox requestBox) throws Exception;
	
	/**
	 * 하위과정 스탬프 처리
	 * @param requestBox
	 */
	void lmsRegularMgOnlineOfflineDataStampInsert(RequestBox requestBox) throws Exception;
	
	/**
	 * 주관식 점수 엑설 Popup호출
	 * @param requestBox
	 * @return String
	 * @throws Exception
	 */
	String lmsRegularMgDetailTestSubjectExcelPop(RequestBox requestBox) throws Exception;
	
	/**
	 * //주관식 점수 등록
	 * @param requestBox
	 */
	void lmsRegularMgTestSubjectExcelAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * //점수 등록한뒤 수료 여부 처리
	 * @param requestBox
	 * @return String
	 */
	String lmsRegularMgTestFinishFlagCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * //test 수료 처리
	 * @param requestBox
	 */
	void lmsRegularMgTestFinishFlagUpdate(RequestBox requestBox) throws Exception;
	
	/**
	 * 시험 신청자 List
	 * @param requestBox
	 * @return String
	 */
	String lmsRegularMgTestStudentList(RequestBox requestBox) throws Exception;
	
	/**
	 * //studyFlag가 Y일때 객관식 재채점
	 * @param requestBox
	 */
	void lmsRegularMgTestObjectRemarkingY(RequestBox requestBox) throws Exception;
	
	/**
	 * //stduyFlag가 N일때 객관식 재채점
	 * @param requestBox
	 */
	void lmsRegularMgTestObjectRemarkingN(RequestBox requestBox) throws Exception;
	
	/**
	 * //시험 개인별 정보 가져오기
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox lmsRegularMgDetailTestSubjectAnswerPop(RequestBox requestBox) throws Exception;
	
	/**
	 * //개인별 주관식 답안지
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> lmsRegularMgDetailEachTestSubjectAnswer(RequestBox requestBox) throws Exception;
	
	/**
	 * //주관식 점수 update
	 * @param requestBox
	 */
	void lmsRegularMgDetailEachSubjectPointUpdate(RequestBox requestBox) throws Exception;
	
	/**
	 * //주관식 합계 점수 LMSSTUDENT테이블에 UPDATE
	 * @param requestBox
	 */
	void lmsRegularMgDetailSubjectPointUpdate(RequestBox requestBox) throws Exception;
	
	/**
	 * 출석처리업데이트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	void updateLmsRegularMgAttendHandle(RequestBox requestBox) throws Exception;

	/**
	 * 부사업자 출석처리업데이트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	void updateLmsRegularMgAttendHandleTogether(RequestBox requestBox) throws Exception;
	
	/**
	 * //교육신청자인지 아닌지 확인하기
	 * @param requestBox
	 * @return
	 */
	String lmsRegularMgAttendRegisterCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * //동반자허용과정인지 CHECK
	 * @param requestBox
	 * @return
	 */
	String lmsRegularMgAttendBarcodeTogetherFlagCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * //동반자신청여부 CHECK
	 * @param requestBox
	 * @return
	 */
	String lmsRegularMgAttendBarcodeTogetherFinalCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * //바코드 팝업 창  confirm구역에 보여줄 리스트 조회하기
	 * @param requestBox
	 * @return
	 */
	DataBox lmsRegularMgAttendBarcodeConfirmInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * //좌석배정 안 된 좌석중 가장 작은 SEATSEQ 가져오기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String lmsRegularMgAttendBarcodeNoAssignSeatGet(RequestBox requestBox) throws Exception;
	
	/**
	 * //VIP회원인지 CHECK
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String lmsRegularMgAttendBarcodePinlevelGet(RequestBox requestBox) throws Exception;
	
	/**
	 * Seat Register Count 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int lmsRegularMgAttendBarcodeSeatRegisterCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //좌석 배정
	 * @param requestBox
	 * @throws Exception
	 */
	void lmsRegularMgAttendBarcodeSeatRegister(RequestBox requestBox) throws Exception;
	
	/**
	 * //회원정보 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox lmsRegularMgAttendBarcodeMemberInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 운영 오프라인 Detail Applicant 목록
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsRegularMgOfflineDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * //alert용 회원정보 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox lmsRegularMgAttendBarcodeNoAppllicantInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * //객관식 점수 합산해서 STUDENT테이블에 넣기
	 * @param requestBox
	 */
	void lmsRegularMgTestObjectPointSum(RequestBox requestBox) throws Exception;
	
	/**
	 * //설문용 정보 조회
	 * @param requestBox
	 * @return
	 */
	DataBox lmsRegularMgServeyCourseInfo(RequestBox requestBox) throws Exception;
	
	//문제 리스트 가져오기
	List<DataBox> lmsRegularMgDetailSurveyList(RequestBox requestBox) throws Exception;
	
	//문제 리스트에 척도 평균 넣기
	List<DataBox> lmsRegularMgDetailSurveyAvgSampleValue(RequestBox requestBox) throws Exception;
	
	//Object 보기,지문 리스트 가져오기
	List<DataBox> lmsRegularMgDetailSurveySampleObjectList(RequestBox requestBox) throws Exception;
	
	//Subject 보기,지문 리스트 가져오기
	List<DataBox> lmsRegularMgDetailSurveySampleSubjectList(RequestBox requestBox) throws Exception;
	
	/**
	 * // 설문대상자 탭  Student리스트
	 * @param requestBox
	 * @return List<DataBox>
	 */
	List<DataBox> lmsRegularMgDetailSurveyCourseListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * // 설문대상자 탭  Student리스트 카운트
	 * @param requestBox
	 * @return  int
	 */
	int lmsRegularMgDetailSurveyCourseListCount(RequestBox requestBox) throws Exception;
	
	//스탭 정보 읽어오기
	 List<DataBox> selectLmsStepList(RequestBox requestBox) throws Exception;
	 
	 // 수료자 및 수강생 정보
	 DataBox selectRegularMgFinishTotal(RequestBox requestBox) throws Exception;
	 
	 // 수료자 갯수 읽기
	 int lmsRegularMgFinishListCount(RequestBox requestBox) throws Exception;
	 
	 //수료 정보 읽어오기
	 List<DataBox> lmsRegularMgFinishListAjax(RequestBox requestBox) throws Exception;
	 //수료자 스탶 수료 정보
	 List<DataBox> lmsRegularMgFinishStepList(RequestBox requestBox) throws Exception;
	 
	//설문 답변 가져오기
	List<DataBox> lmsRegularMgDetailSurveyResponseList1Pop(RequestBox requestBox) throws Exception;
	
	//선다형 답변 가져오기
	List<DataBox> lmsRegularMgDetailSurveyResponseList2Value(RequestBox requestBox) throws Exception;
	
	/**
	 * //회원정보
	 * @param requestBox
	 * @return DataBox
	 */
	DataBox lmsRegularMgDetailSurveyResponsePopInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * 정규과정 수료날짜 있는지 조회하기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String lmsRegularMgExistFinishDateCheckR(RequestBox requestBox) throws Exception;
	
	/**
	 * //정규과정 수료 처리
	 * @param requestBox
	 */
	void lmsRegularMgFinishUpdateAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 좌석등록이 되었는지 체크하기
	 * @param requestBox
	 * @return String
	 */
	String lmsRegularMgAttendBarcodeCheckSeatRegister(RequestBox requestBox) throws Exception;
	
	/**
	 * 부사업자신청 허용 flag가져오기
	 * @param requestBox
	 * @return String
	 */
	String selectLmsRegularMgOfflineTogetherFlag(RequestBox requestBox) throws Exception;
	
	/**
	 * //출석자인지 아닌지 조회하기
	 * @param requestBox
	 * @return String
	 */
	String selectLmsRegularMgOfflineFinishFlag(RequestBox requestBox) throws Exception;
	
}

























