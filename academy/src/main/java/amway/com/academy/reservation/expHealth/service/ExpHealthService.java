package amway.com.academy.reservation.expHealth.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

/**
 * 체험_체성분 체험
 * @author KR620225
 *
 */
public interface ExpHealthService {

	/**
	 * 체성분 체험이 있는 pp조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> ppRsvCodeList(RequestBox  requestBox) throws Exception;
	
	/**
	 * 해당 pp의 체성분 체험 상세 정보(정원, 이용시간, 예약자격, 준비물 등)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> expHealthDetailInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * 선택 날짜에 세션 시간 상세보기 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchStartSeesionTimeListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 체성분 측정 정보 확인(팝업)
	 * 		- 부모창에서 받은 데이터를 list형식으로 변경후 return 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expHealthRsvRequestPop(RequestBox requestBox) throws Exception;
	
	/**
	 * 체성분 측정 예약 정보 등록(팝업)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expHealthInsertAjax (RequestBox requestBox) throws Exception;
	
	/**
	 * 해당월에 예약한 체험 프로그램 리스트 조횐
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expReservationInfoDetailList(RequestBox requestBox) throws Exception;
	
	/**
	 * 해당 pp의 휴무를 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchExpHealthHoilDay(RequestBox requestBox) throws Exception;
	
	/**
	 * 달력상에 예약 가능 세션 갯수 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchRsvAbleSessionTotalCount(RequestBox requestBox) throws Exception;

	/**
	 * 예약 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expHealthDuplicateCheck(RequestBox requestBox) throws Exception;

	/**
	 * 예약 불가 알림 팝업
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expHealthDisablePop(RequestBox requestBox) throws Exception;

	public Map<String, String> searchExpPenalty(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약 대기자 조회[같은 세션을 선점할 경우 늦게 insert한 사용자는  다른 사용자가 먼저 선점하여 등록이 불가 하다라는 메세지를 뿌려줌]
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> expHealthStandByNumberAdvanceChecked(RequestBox requestBox) throws Exception;
}
