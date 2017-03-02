package amway.com.academy.manager.lms.offlineMg.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsOfflineMgMapper {

	/**
	 * 오프라인Mg 카운트
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsOfflineMgCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인Mg 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsOfflineMgList(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육상태 코드 리스트
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<DataBox> selectLmsEduStatusCodeList(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인Mg 리스트 엑셀다운
	 * @param requestBox
	 * @return List
	 * @throws Exception
	 */
	List<Map<String, String>> selectLmsOfflineMgListExcelDown(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 오프라인Mg Detail Applicant 카운트
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsOfflineMgDetailApplicantCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인Mg Detail Applicant 목록
	 * @param requestBox
	 * @return List<DataBox>
	 * @throws Exception
	 */
	List<DataBox> selectLmsOfflineMgApplicantListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인Mg Detail Applicant 목록
	 * @param requestBox
	 * @return DataBox
	 * @throws Exception
	 */
	DataBox selectLmsOfflineDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * applicant 신청 취소
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsOfflineMgApplicant(RequestBox requestBox) throws Exception;
	
	/**
	 * add applicant pop
	 * @param requestBox
	 * @return List<DataBox>
	 * @throws Exception
	 */
	List<DataBox> selectLmsOfflineMgDetailApplicantPop(RequestBox requestBox) throws Exception;
	
	/**
	 * add applicant pop totalCount
	 * @param requestBox
	 * @return
	 */
	int selectLmsOfflineMgDetailApplicantPopCount(RequestBox requestBox) throws Exception;
	
	/**
	 * PINCODE LIST 조회
	 * @param requestBox
	 * @return
	 */
	List<DataBox> selectLmsPinCodeList(RequestBox requestBox) throws Exception;

	
	/**
	 * applicant 신청(부사업자 신청허용)
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int insertLmsOfflineMgApplicant(RequestBox requestBox) throws Exception;
	
	/**
	 * applicant 신청(부사업자 신청 비허용)
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int insertLmsOfflineMgApplicant2(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 
	 * member uid Check
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String lmsOfflineMgAddApplicantCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * 엑셀로 수강생 등록하기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int lmsOfflineMgAddApplicantExcelAjax(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 오프라인Mg Detail Seat Count 목록
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int selectLmsOfflineMgDetailSeatCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인Mg Detail Seat 목록
	 * @param requestBox
	 * @return List<DataBox>
	 * @throws Exception
	 */
	List<DataBox> selectLmsOfflineMgDetailSeat(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인Mg Seat Update
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int lmsOfflineMgSeatUpdate(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 해당 과정 좌석 배정여부 확인
	 * @param requestBox
	 * @return String
	 * @throws Exception
	 */
	String lmsOfflineMgSeatAssignCheck(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 해당 과정 좌석등록 삭제
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int deleteLmsOfflineMgSeatExcelAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 엑셀로 좌석 등록하기
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int lmsOfflineMgSeatRegisterExcelAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * Attend LMSTUDENT List 조회
	 * @param requestBox
	 * @return List<DataBox>
	 * @throws Exception
	 */
	List<DataBox> selectLmsOfflineMgAttendListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * AttendList Count
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int selectLmsOfflineMgAttendListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * Attend LMSSEATSTUDENT List조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsOfflineMgAttendList2Ajax(RequestBox requestBox) throws Exception;
	
	/**
	 * 출석처리업데이트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int updateLmsOfflineMgAttendHandle(RequestBox requestBox) throws Exception;
	
	/**
	 * 부사업자 출석처리업데이트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int updateLmsOfflineMgAttendHandleTogether(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 수강생테이블에 해당 UID 존재여부 확인
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String lmsOfflineMgAttendRegisterCheck(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 교육과정 마감일 CHECK하기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String lmsOfflineMgAttendEndDateCheck(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 마감(페널티처리)하기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int lmsOfflineMgAttendFinishPenaltyAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 교육과정 패널티허용여부 CHECK
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String lmsOfflineMgAttendPenaltyFlagCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * 미출석자 리스트 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> lmsOfflineMgAttendNoFinishStudentList(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 해당 교육과정의 해당 회원이 이미 페널티 처리 되었는지 확인하기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String lmsOfflineMgAttendAlreadyPenaltyCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * 페널티대상자 리스트 카운트 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int selectLmsOfflineMgPenaltyListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 페널티대상자 리스트 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<DataBox> selectLmsOfflineMgPenaltyListAjax(RequestBox requestBox) throws Exception;

	/**
	 * 동반자허용과정인지 CHECK
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String lmsOfflineMgAttendBarcodeTogetherFlagCheck(RequestBox requestBox) throws Exception;

	/**
	 * 동반자신청여부 CHECK
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String lmsOffineMgAttendBarcodeTogetherFinalCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * 바코드 팝업 창 confirm구역에 보여줄 리스트 조회하기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox lmsOfflineMgAttendBarcodeConfirmInfo(RequestBox requestBox) throws Exception;

	/**
	 * //VIP회원인지 CHECK
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String lmsOfflneMgAttendBarcodePinlevelGet(RequestBox requestBox) throws Exception;
	
	
	/**
	 * //좌석 배정
	 * @param requestBox
	 * @throws Exception
	 */
	void lmsOfflineMgAttendBarcodeSeatRegister(RequestBox requestBox) throws Exception;
	
	/**
	 * //좌석배정 안 된 좌석중 가장 작은 SEATSEQ 가져오기
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String lmsOfflineMgAttendBarcodeNoAssignSeatGet(RequestBox requestBox) throws Exception;
	
	
	/**
	 * //회원정보 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox lmsOfflineMgAttendBarcodeMemberInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * Seat Register Count 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int lmsOfflineMgAttendBarcodeSeatRegisterCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //현장접수 가능 과정인지 조회
	 * @param requestBox
	 * @return
	 */
	String lmsOfflineMgAttendBarcodePlaceFlagCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * //수강신청하고 출석처리하기
	 * @param requestBox
	 */
	void lmsOfflineMgAttendBarcodePlaceAskRegister(RequestBox requestBox) throws Exception;
	
	/**
	 * //alert용 회원정보 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	DataBox lmsOfflineMgAttendBarcodeAlertInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * 좌석삭제
	 * @param requestBox
	 * @throws Exception
	 */
	void deleteLmsOfflineMgSeat(RequestBox requestBox) throws Exception;

	/**
	 * 좌석 개별 삭제
	 * @param requestBox
	 * @throws Exception
	 */
	void deleteLmsOfflineMgSeatEach(RequestBox requestBox) throws Exception;
	
	/**
	 * //수료날짜 있는지 조회하기
	 * @param requestBox
	 * @return
	 */
	String lmsOfflineMgExistFinishDateCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * 좌석등록이 되었는지 체크하기
	 * @param requestBox
	 * @return String
	 */
	String lmsOfflineMgAttendBarcodeCheckSeatRegister(RequestBox requestBox) throws Exception;
	
	/**
	 * //출석자인지 아닌지 확인하기
	 * @param requestBox
	 * @return String
	 */
	String selectLmsOfflineMgFinishFlag(RequestBox requestBox) throws Exception;
	
	/**
	 * //부사업자 출석자인지 아닌지 확인하기
	 * @param requestBox
	 * @return String
	 */
	String selectLmsOfflineMgTestFlag(RequestBox requestBox) throws Exception;
	
	/**
	 * //부사업자신청 허용 flag가져오기
	 * @param requestBox
	 * @return String
	 */
	String selectLmsOfflineMgTogetherFlag(RequestBox requestBox) throws Exception;
	
	/**
	 * 오프라인 스탬프 처리
	 * @param requestBox
	 */
	void lmsOfflineMgStampInsert(RequestBox requestBox) throws Exception;
	
	List<DataBox> lmsOfflneMgAttendBarcodePinList(RequestBox requestBox) throws Exception;
}

























