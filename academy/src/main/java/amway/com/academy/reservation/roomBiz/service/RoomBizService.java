package amway.com.academy.reservation.roomBiz.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

/**
 * 시설예약_비즈룸 예약
 * @author KR620225
 *
 */
public interface RoomBizService {

	public List<Map<String, String>> ppRsvRoomBizCodeList(RequestBox  requestBox) throws Exception;
	
	/**
	 * <pre>
	 * 비즈룸 최종 예약 요청 팝업
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomBizPaymentInfoPop(RequestBox requestBox) throws Exception;

	/**
	 * 예약불가 팝업(예약 충돌)
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomBizDisablePop(RequestBox requestBox) throws Exception;

	/**
	 * 예약 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomBizPaymentCheck(RequestBox requestBox) throws Exception;
	
}
