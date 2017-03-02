package amway.com.academy.manager.lms.offlineMg.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface LmsOfflineMgService {

	// 오프라인Mg 목록 카운트
	public int selectLmsOfflineMgCount(RequestBox requestBox) throws Exception;
	
	// 오프라인Mg 목록
	public List<DataBox> selectLmsOfflineMgList(RequestBox requestBox) throws Exception;

	//교육상태 코드 리스트
	public List<DataBox> selectLmsEduStatusCodeList(RequestBox requestBox) throws Exception;
	
	//오프라인Mg 목록 엑셀 다운로드
	public List<Map<String, String>> selectLmsOfflineMgListExcelDown(RequestBox requestBox) throws Exception;
	
	//오프라인Mg 상세 applicant 목록 카운트
	public int selectLmsOfflineMgDetailApplicantCount(RequestBox requestBox) throws Exception;
	
	//오프라인 Mg 상세 applicant 목록
	public List<DataBox> selectLmsOfflineMgApplicantListAjax(RequestBox requestBox) throws Exception;
	
	//오프라인Mg 상세
	public DataBox selectLmsOfflineDetail(RequestBox requestBox) throws Exception;
	
	//신청 취소
	public int deleteLmsOfflineMgApplicant(RequestBox requestBox) throws Exception;
	
	//오프라인 Mg 상세 applicant Pop 목록
	public List<DataBox> selectLmsOfflineMgDetailApplicantPop(RequestBox requestBox) throws Exception;
	
	//오프라인 Mg 상세 applicant Pop Count
	public int selectLmsOfflineMgDetailApplicantPopCount(RequestBox requestBox) throws Exception;
	
	//PINCODE LIST 조회
	public List<DataBox> selectLmsPinCodeList(RequestBox requestBox) throws Exception;
	
	//멤버테이블에 해당 uid 존재하는지 check
	public String lmsOfflineMgAddApplicantCheck(RequestBox requestBox) throws Exception;
	
	//엑셀로 수강생 등록하기
	public int lmsOfflineMgAddApplicantExcelAjax(RequestBox requestBox, List<Map<String, String>> retSuccessList) throws Exception;
	
	//오프라인Mg 상세 seat 목록 카운트
	public int selectLmsOfflineMgDetailSeatCount(RequestBox requestBox) throws Exception;
	
	//오프라인Mg 상세 seat 목록
	public List<DataBox> selectLmsOfflineMgDetailSeat(RequestBox requestBox) throws Exception;
	
	//오프라인Mg Seat Update
	public int lmsOfflineMgSeatUpdate(RequestBox requestBox) throws Exception;
	
	//해당 과정 좌석 배정 여부 확인
	public String lmsOfflineMgSeatAssignCheck(RequestBox requestBox) throws Exception;
	
	//좌석 재등록일 경우 해당 과정 좌석 삭제
	public int deleteLmsOfflineMgSeatExcelAjax(RequestBox requestBox) throws Exception;
	
	//엑셀로 좌석 등록 
	public int lmsOfflineMgSeatRegisterExcelAjax(RequestBox requestBox,List<Map<String, String>> retSuccessList) throws Exception;
	
	//Attend List 카운트 조회
	public int selectLmsOfflineMgAttendListCount(RequestBox requestBox) throws Exception;
	
	//Attend List 조회
	public List<DataBox> selectLmsOfflineMgAttendListAjax(RequestBox requestBox) throws Exception;
	
	//출석처리 Update
	public int updateLmsOfflineMgAttendHandle(RequestBox requestBox) throws Exception;
	
	//출석처리 엑셀등록
	public int insertLmsOfflineMgAttendHandle(RequestBox requestBox,List<Map<String, String>> retSuccessList) throws Exception;
	
	//수강생테이블에 uid 있는지 조회
	public String lmsOfflineMgAttendRegisterCheck(RequestBox requestBox) throws Exception;

	//교육과정 마감 페널티처리
	public String lmsOfflineMgAttendFinishPenaltyAjax(RequestBox requestBox) throws Exception;
	
	//페널티대상자 리스트 카운트 조회
	public int selectLmsOfflineMgPenaltyListCount(RequestBox requestBox) throws Exception;
	
	//페널티대상자 리스트 조회
	public List<DataBox> selectLmsOfflineMgPenaltyListAjax(RequestBox requestBox) throws Exception;
	
	//동반신청과정이면서 동반신청인 경우 CHECK
	public String lmsOfflineMgAttendBarcodeTogetherCheck(RequestBox requestBox) throws Exception;
	
	//바코드 팝업 창  confirm구역에 보여줄 리스트 조회하기
	public DataBox lmsOfflineMgAttendBarcodeConfirmInfo(RequestBox requestBox) throws Exception;
	
	//출석 처리하고 좌석배정한뒤 회원정보 조회
	public DataBox lmsOfflineMgAttendBarcodeMemberInfo(RequestBox requestBox,int step) throws Exception;
	
	//현장접수 가능 과정인지 조회
	public String lmsOfflineMgAttendBarcodePlaceFlagCheck(RequestBox requestBox) throws Exception;
	
	//수강신청하고 좌석 등록 하고 정보가져오기
	public DataBox lmsOfflineMgAttendBarcodePlaceAsk(RequestBox requestBox,int step) throws Exception;
	public DataBox lmsOfflineMgAttendBarcodePlaceAsk2(RequestBox requestBox,int step) throws Exception;
	
	//alert용 회원정보 조회
	public DataBox lmsOfflineMgAttendBarcodeNoAppllicantInfo(RequestBox requestBox) throws Exception;
	
	//교육신청자 추가
	public Map<String, Object> lmsOfflineMgApplicantAddAjax(RequestBox requestBox) throws Exception;
	
	//부사업자신청 허용 flag가져오기
	public String selectLmsOfflineMgTogetherFlag(RequestBox requestBox) throws Exception;
	
	
}
