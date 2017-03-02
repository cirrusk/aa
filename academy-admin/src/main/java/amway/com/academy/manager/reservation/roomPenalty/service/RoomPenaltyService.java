package amway.com.academy.manager.reservation.roomPenalty.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface RoomPenaltyService {

	/**
	 * 시설 패널티 현황 목록 카운트
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int roomPenaltyListCountAjax(RequestBox requestBox) throws Exception;

	/**
	 * 시설 패널티 현황 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> roomPenaltyListAjax(RequestBox requestBox) throws Exception;

	/**
	 * 시설 패널티 현황 상세
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox roomPenaltyDetailAjax(RequestBox requestBox) throws Exception;

	/**
	 * 시설 패널티 해제
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int roomPenaltyCancelLimitUpdateAjax(RequestBox requestBox) throws Exception;

	/**
	 * 시설 패널티 현황 목록 조회(엑셀 다운로드)
	 * 
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, String>> roomPenaltyExcelListSelect(RequestBox requestBox) throws Exception;

}
