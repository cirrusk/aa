package amway.com.academy.reservation.expCulture.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import framework.com.cmm.lib.RequestBox;

/**
 * 체험_문화체험
 * @author KR620225
 *
 */
public interface ExpCultureService {

	/**
	 * 문화 체험에 속한 pp정보 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> ppRsvCodeList(RequestBox requestBox) throws Exception;

	/**
	 * 년, 월  조회(jsp에서 클래스 명으로 사용)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCultureYearMonth(RequestBox requestBox) throws Exception;

	/**
	 * 해당 pp, 해당 년, 월 의 예약가능한 프로그램이 있는 날짜 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCultureDayInfoList(RequestBox requestBox) throws Exception;

	/**
	 * 문화체험 pp별 해당 날짜의 예약 가능한 프로그램 목록 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCultureProgramList(RequestBox requestBox) throws Exception;

	/**
	 * 문화체험 예약 요청 데이터 랩핑
	 * @param requestBox
	 * @return
	 */
	List<Map<String, String>> expCultureRsvRequest(RequestBox requestBox) throws Exception;

	/**
	 * 문화체험 예약 등록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCultureRsvInsert(RequestBox requestBox) throws Exception;

	/**
	 * 문화체험 해당 pp별 프로그램 목록 조회(2달)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCulturePpProgramList(RequestBox requestBox) throws Exception;

	/**
	 * 문화체험 해당 pp 프로그램별 세션 정보 조회(2달)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCultureSessionList(RequestBox requestBox) throws Exception;

	/**
	 * 문화체험 본인 예약 현황 목록 카운트(페이징)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int expCultureInfoListCount(RequestBox requestBox) throws Exception;

	/**
	 * 문화체험 본인 예약 현황 목록 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCultureInfoList(RequestBox requestBox) throws Exception;

	/**
	 * 해당 프로그램 예약 가능 참석자 수 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	String expCultureSeatCountSelect(RequestBox requestBox) throws Exception;

	/**
	 * 문화체험 해당 예약 정보 참석자 수 수정
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int expCultureVisitNumberUpdate(RequestBox requestBox) throws Exception;

	/**
	 * 문화체험 예약 취소
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	int expCultureCancelUpdate(RequestBox requestBox) throws Exception;

	/**
	 * 문화체험 비회원 정보 확인 폼 데이터 정렬
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCultureNonmemberIdCheckForm(RequestBox requestBox) throws Exception;
	
	
	/**
	 * 문화체험 소개 팝업 정보 목록 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCultureIntroduceList(RequestBox requestBox) throws Exception;

	/**
	 * 문화체험 오늘날짜 조회
	 * @return
	 * @throws Exception
	 */
	Map<String, String> expCultureToday() throws Exception;

	/**
	 * 문화체험 예약현황 확인 모바일
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCultureInfoListMobile(RequestBox requestBox) throws Exception;

	/**
	 * 문화체험 비회원 본인 인증 발송
	 * @param requestBox
	 * @throws Exception
	 */
	Map<String, String> expCultureAuthenticationNumberSend(RequestBox requestBox, HttpServletRequest request) throws Exception;

	/**
	 * 문화체험 비회원 인증 번호 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	Map<String, String> expCultureAuthenticationNumberCheck(RequestBox requestBox) throws Exception;

	/**
	 * 비회원 예약 완료
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCultureNonmemberComplete(RequestBox requestBox) throws Exception;

	/**
	 * 예약 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCultureDuplicateCheck(RequestBox requestBox) throws Exception;

	/**
	 * 예약 불가 알림 팝업
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> expCultureDisablePop(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약 대기자 조회[같은 세션을 선점할 경우 늦게 insert한 사용자는  다른 사용자가 먼저 선점하여 등록이 불가 하다라는 메세지를 뿌려줌]
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	Map<String, String> expCultureStandByNumberAdvanceChecked(RequestBox requestBox) throws Exception;
}
