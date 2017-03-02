package amway.com.academy.reservation.basicPackage.service;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import framework.com.cmm.lib.RequestBox;

/**
 * <pre>
 * </pre>
 * Program Name  : ReservationPurchaseService.java
 * Author : KR620207
 * Creation Date : 2016. 10. 6.
 */
public interface ReservationPurchaseService {

	/**
	 * 시설 예약 등록
	 * @param map
	 * @throws Exception
	 */
	public void roomReservationInsert(HashMap<String, String> map) throws Exception;
	
	/**
	 * 결제정보 등록
	 * @param map
	 * @throws Exception
	 */
	public void roomPaymentInsert(HashMap<String, String> map) throws Exception;
	
	/**
	 * 주문정보 유무 체크
	 * @param map
	 * @throws Exception
	 */
	public int selectRoomPurchase(HashMap<String, String> map) throws Exception;
	
	/**
	 * 주문정보 등록
	 * @param map
	 * @throws Exception
	 */
	public void roomPurchaseInsert(HashMap<String, String> map) throws Exception;
	
	/**
	 * 카드 추적번호 증가
	 * @throws Exception
	 */
	public void increaseCardTraceNumber() throws Exception;
	
	/**
	 * 카드 추적번호 취득
	 * @return
	 * @throws Exception
	 */
	public int getCurrentCardTraceNumber() throws Exception;

	/**
	 * KICC 결제 이후  STEP1 상자에 노출 할 정보
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public EgovMap selectKiccCompleteStep1(RequestBox requestBox) throws Exception;
	
	/**
	 * KICC 결제 이후  STEP2 상자에 노출 할 정보
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> selectKiccCompleteStep2(RequestBox requestBox) throws Exception;
	
	/**
	 * KICC 결제 이후  STEP3 상자에 노출 할 정보
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public EgovMap selectKiccCompleteStep3(RequestBox requestBox) throws Exception;
	
}
