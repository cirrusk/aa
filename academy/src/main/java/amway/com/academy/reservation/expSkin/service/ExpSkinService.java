package amway.com.academy.reservation.expSkin.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

/**
 * 체험_피부측정 체험
 * @author KR620225
 *
 */
public interface ExpSkinService {

	/**
	 * 피부측정 체험이 있는 pp조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> ppRsvCodeList(RequestBox  requestBox) throws Exception;
	
	/**
	 * 해당 pp의 피부측정 체험 상세 정보(정원, 이용시간, 예약자격, 준비물 등)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> expSkinDetailInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * 선택 날짜에 세션 시간 상세보기 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchSkinSeesionListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 피부 측정 정보 확인(팝업)
	 * 		- 부모창에서 받은 데이터를 list형식으로 변경후 return 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expSkinRsvRequestPop(RequestBox requestBox) throws Exception;
	
	/**
	 * 피부 측정 예약 정보 등록(팝업)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> expSkinInsertAjax (RequestBox requestBox) throws Exception;
	
	/**
	 * 해당 pp의 휴무를 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> searchExpSkinHoliDay(RequestBox requestBox) throws Exception;

	public List<Map<String, String>> searchRsvAbleSessionTotalCount(RequestBox requestBox) throws Exception;

	public List<Map<String, String>> expSkinDuplicateCheck(RequestBox requestBox) throws Exception;

	public List<Map<String, String>> expSkinDisablePop(RequestBox requestBox) throws Exception;
	
	/**
	 * 예약 대기자 조회[같은 세션을 선점할 경우 늦게 insert한 사용자는  다른 사용자가 먼저 선점하여 등록이 불가 하다라는 메세지를 뿌려줌]
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> expSkinStandByNumberAdvanceChecked(RequestBox requestBox) throws Exception;
	
}
