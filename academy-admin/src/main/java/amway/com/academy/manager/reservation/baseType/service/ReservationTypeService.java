package amway.com.academy.manager.reservation.baseType.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

/**
 * 
 * 예약 타입 정보 관리
 * @author KR620207
 *
 */
public interface ReservationTypeService {

	/**
	 * 목록 조회 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> reservationTypeListAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 목록 갯수 조회 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int reservationTypeListCountAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 신규 생성 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int reservationTypeInsertAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 수정 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int reservationTypeUpdateAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * 상세 조회 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox reservationTypeDetailAjax(RequestBox requestBox) throws Exception;
	
	
}
