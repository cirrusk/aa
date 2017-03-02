package amway.com.academy.reservation.basicPackage.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;
import amway.com.academy.reservation.basicPackage.web.CommonCodeVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BasicReservationService {
	
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
	 * 예약현황_프로그램명
	 * 		-[RSVEXPINFO table - 프로그램명 조회]
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> rervationProgramCodeList() throws Exception;
	
	/**
	 * 행정구역 리스트
	 * 		-[RSVREGIONINFO table - 행정구역 조회(서울시, 경기도, 경상남도 등)]
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
	public List<CommonCodeVO> cityCodeListByRegionCode(String regionCode) throws Exception;
	
	/**
	 * 예약 형태 정보 코드 리스트
	 * 		-[체성분측정, 피부 측정, 브랜드 체험, 문화체험] 
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> expRsvTypeInfoCodeList() throws Exception;
	
	/**
	 * 예약 형태 정보 코드 리스트
	 * 		-[교육장, 퀸룸/파티룸, 비즈룸] 
	 * @return
	 * @throws Exception
	 */
	public List<CommonCodeVO> roomRsvTypeInfoCodeList() throws Exception;
	
	/**
	 *  해당 월의 캘린더
	 * 		-[파라미터값 : 년(getYear), 월(getMonth)] 
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> getCalendarList(RequestBox requestBox) throws Exception;
	
	/**
	 *  다음 월에 대한 년, 월 조회
	 *  	[jsp class명으로 사용]
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> nextYearMonth(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당월에 예약한 체험 프로그램 리스트 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expReservationInfoDetailList(RequestBox requestBox) throws Exception;
	
	/**
	 * 사용자 마지막 예약 pp 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> searchLastRsvPp(RequestBox requestBox) throws Exception;
	
	/**
	 * 사용자 해당 pp 마지막 예약 room 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> searchLastRsvRoom(RequestBox requestBox) throws Exception;
	
	/**
	 * 이전달, 다음달에 예약된 체험 카운트(예약 현황 확인 팝업 에서 사용)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> searchMonthRsvCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 약관 내용 취득
	 * @param clauseKey
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
	 * 사용가능 카드사 목록
	 * @return
	 * @throws Exception
	 */
	public List<?> creditCardCompany() throws Exception;
	
	/**
	 * 결제를 위해 Hybris시스템에 보낼 card정보의 전문 생성
	 * @return
	 * @throws Exception
	 */
	public String createXmlForPaymentCardInfo(Map<String, Object> mappingData) throws Exception;

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
	
	public int insertRsvClauseHistory(RequestBox requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 카드 추적번호 증가후 획득
	 * - 80만번 이상이면 70만번으로 초기화
	 * </pre>
	 * 
	 * @return
	 * @throws Exception
	 */
	public String getCurrentCardTraceNumber() throws Exception;

	/**
	 * <pre>
	 * 예약정보 확인 버튼 클릭시, 넘겨받는 PARAMETER 정리
	 * </pre>
	 * @param requestBox
	 * @param isWithCardInfo
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomPaymentInfo(RequestBox requestBox, boolean isWithCardInfo) throws Exception;
	
	/**
	 * <pre>
	 * 	예약 등록 처리
	 *    - 1. 사용자예약정보 테이블 데이터 입력
	 *    - 2. 결제진행 이력정보 테이블 데이터 입력
	 *    - 3. 주문정보관리 테이블 데이터 입력
	 *        > 
	 *        > 결제 API 호출 후 invoiceQueue 번호를 리턴 받은 후 RSVPURCHASEINFO 테이블에 최종 입력한다.
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomReservationInsert(RequestBox requestBox) throws Exception;

	/**
	 * 
	 * @param virtualPurchaseNumber
	 * @return
	 * @throws Exception
	 */
	public EgovMap selectReservationInfoStepOneByVirtualNumber(String virtualPurchaseNumber) throws Exception;
	
	/**
	 * 
	 * @param virtualPurchaseNumber
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> selectReservationInfoStepTwoByVirtualNumber(String virtualPurchaseNumber) throws Exception;
	
	/**
	 * 
	 * @param virtualPurchaseNumber
	 * @return
	 * @throws Exception
	 */
	public EgovMap selectReservationInfoStepThreeByVirtualNumber(String virtualPurchaseNumber) throws Exception;
	
	/**
	 * 기록된 시간을 키로 조회 해오는 간단 예약 정보
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> simpleReservationDataByTransaction(RequestBox requestBox) throws Exception;

	/**
	 * 체험 프로그램 신청 여부 체크
	 * @param requestBox
	 * @return
	 */
	public int expProgramVailabilityCheckAjax (RequestBox requestBox);
	
}
