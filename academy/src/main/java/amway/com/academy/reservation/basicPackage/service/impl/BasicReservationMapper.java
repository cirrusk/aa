package amway.com.academy.reservation.basicPackage.service.impl;

import java.util.List;
import java.util.Map;

import amway.com.academy.reservation.basicPackage.web.CommonCodeVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface BasicReservationMapper {

	/**
	 * 공통 코드 목록 조회 기능
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> commonCodeList(CommonCodeVO codeVO) throws Exception;
	
	/**
	 * 공통 코드명 취득
	 * @param codeVO
	 * @return
	 * @throws Exception
	 */
	public String getCommonCodeName(CommonCodeVO codeVO) throws Exception;
	
	/**
	 * PP(교육장)
	 * 		- 운영자 일 경우 본인의 PP만 조회
	 * 		- 해당 pp 코드를 VO에서 관리를 할것인가?(파라미터값을 어떤걸로 할지)
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> ppCodeList() throws Exception;
	
	/**
	 * 예약 현황_프로그램 타입
	 * 		-[RSVEXPINFO table - 카테고리1 조회]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> rervationProgramTypeCodeList() throws Exception;
	
	/**
	 * 예약 현황_프로그램 명
	 * 		-[RSVEXPINFO table - 프로그램명 조회]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> rervationProgramCodeList() throws Exception;
	
	/**
	 * 행정구역 코드 목록 [서울, 경기, 인천, 세종 ...]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> regionCodeList() throws Exception;
	
	/**
	 * <pre>
	 * 행정구역에 속한 군/구 단위의 도시 목록
	 * parameter [충남cd]
	 * return [서천cd, 서산cd, 태안cd ...]
	 * </pre>
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> cityCodeListByRegionCode(CommonCodeVO codeVO) throws Exception;
	
	public List<CommonCodeVO> expRsvTypeInfoCodeList() throws Exception;
	
	public List<CommonCodeVO> roomRsvTypeInfoCodeList() throws Exception;
	
	/**
	 * 해당월의 캘린더
	 * 		-[파라미터값 : 년(getYear), 월(getMonth)] 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> getCalendarList(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 다음 월에 대한 년, 월 을 조회한다(jsp에서 클래스 명으로 사용)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> nextYearMonth(RequestBox requestBox) throws Exception; 
	
	/**
	 * 해당월에 예약한 체험 프로그램 리스트 조횐
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expReservationInfoDetailList(RequestBox requestBox) throws Exception;
	
	public String searchLastRsvPp(RequestBox requestBox) throws Exception;
	
	public String searchLastRsvRoom(RequestBox requestBox) throws Exception;
	
	/**
	 * 체성분 키 값 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Integer> searchRsvTypeSeq(RequestBox requestBox) throws Exception;

	/**
	 * 해당 예약 타입 PP 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> ppRsvCodeList(RequestBox  requestBox) throws Exception;
	
	/**
	 * 해당 시설 예약 타입 PP 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> ppRsvRoomCodeList(RequestBox  requestBox) throws Exception;
	
	/**
	 * 선택 날짜에 세션 시간 상세보기 조회
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, String>> searchStartSeesionTimeListAjax(RequestBox requestBox);
	
	/**
	 * 해당 pp의 휴무를 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchExpHoliDay(RequestBox requestBox) throws Exception;
	
	/**
	 * 체험/측정 예약 정보 등록(팝업)
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int expInsertAjax (Map<String, String> map) throws Exception;
	
	/**
	 * 결제 이력정보 등록
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int expPayMentInsert(Map<String, String> map) throws Exception;
	
	/**
	 * 해당 pp의 체험 상세 정보(정원, 이용시간, 예약자격, 준비물 등)
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> expDetailInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약 가능 세션 수 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchRsvAbleSessionTotalCount(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 이전달, 다음달에 예약된 체험 카운트(예약 현황 확인 팝업 에서 사용)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> searchMonthRsvCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 약관 내용 취득
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public String getClauseContentsByKeyCode(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약 필수 안내 정보 내용 취득
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public String getReservationInfoByType(RequestBox requestBox) throws Exception;
	
	/**
	 * AI 프로젝트의 PP 코드로 Hybris 의 AP 코드를 얻어오는 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public String getApCodeByPpCode(RequestBox requestBox) throws Exception;
	
	/**
	 * PP-seq 로 PP명을 얻어오는 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public String getPpNameByPpSeq(String ppSeq) throws Exception;

	/**
	 * ABO 번호로 이름(masked)을 조회해 오는 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public String getMemberNameByAbo(RequestBox requestBox) throws Exception;
	
	/**
	 * 시설 이미지 경로 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomImageUrlList(RequestBox requestBox) throws Exception;
	
	/**
	 * 체험 이미지 경로 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchExpImageFileKeyList(RequestBox requestBox) throws Exception;
	 
	public Map<String, String> searchTypeName(RequestBox requestBox) throws Exception;
	
	public Map<String, String> searchClauseSeq(Map<String, String> map) throws Exception;
	
	public int insertRsvClauseHistory(Map<String, String> map) throws Exception;
	
	public Map<String, String> searchFirstSession(RequestBox requestBox) throws Exception;

	/**
	 * 메세지 (push, notice) 처리를 위한 조회 : 세션 seq로 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> getSendMessage(Map<String, String> map) throws Exception;
	
	/**
	 * 메세지 (push, notice) 처리를 위한 [시설] 조회 : 예약 seq로 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> getSendMessageRoomBySeq(Map<String, String> map) throws Exception;
	
	/**
	 * 메세지 (push, notice) 처리를 위한 [체험] 조회 : 예약 seq로 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> getSendMessageExpBySeq(Map<String, String> map) throws Exception;
	
	/**
	 * 브랜드 체험 - 프로그램 우선 선택
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> getSendMessageExpForBrandProgram(Map<String, String> map) throws Exception;
	
	/**
	 * 쪽지 전송
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertReservationNoteSend(Map<String, String> paramMap) throws Exception;

	/**
	 * 측정 체험 중복 예약 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> expDuplicateCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * 브랜드체험 개인, 문화체험 중복 예약 체크- (미적용)
	 * (하나의 세션에 프로그램 설정시 등록된 정원만큼 예약 가능하게 하기 위한 예외 중복 예약 체크)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> expDuplicateExceptCheck(RequestBox requestBox) throws Exception;
	
	public Map<String, String> searchExpReservation(RequestBox requestBox) throws Exception;
	
	public Map<String, String> searchExpExceptReservation(RequestBox requestBox) throws Exception;
	
	/**
	 * 측정체험 패널티 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> searchExpPenalty(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약 대기자 조회[같은 세션을 선점할 경우 늦게 insert한 사용자는  다른 사용자가 먼저 선점하여 등록이 불가 하다라는 메세지를 뿌려줌]
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> expStandByNumberAdvanceChecked(RequestBox requestBox) throws Exception;
	
	/**
	 * 기록된 시간을 키로 조회 해오는 간단 예약 정보
	 * @param requestBox
	 * @throws Exception
	 */
	public List<Map<String, String>> simpleReservationDataByTransaction(RequestBox requestBox) throws Exception;

	public int expProgramVailabilityCheckAjax(
			RequestBox requestBox);

}
