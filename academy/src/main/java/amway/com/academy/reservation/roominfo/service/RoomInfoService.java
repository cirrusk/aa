package amway.com.academy.reservation.roominfo.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

/**
 * 시설예약_교육장 예약
 * @author KR620225
 *
 */
public interface RoomInfoService {
	
	/**
	 * 시설예약 현황 목록 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomInfoList(RequestBox requestBox) throws Exception;
	
	/**
	 * 시설 예약 현황 목록 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int roomInfoListCount(RequestBox requestBox) throws Exception;

	/**
	 * 시설 예약 현황 상세 보기
	 * @param requestBox
	 * @return
	 */
	public List<Map<String, String>> roomInfoDetailList(RequestBox requestBox) throws Exception;

	/**
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> searchRoomPayPenalty(RequestBox requestBox) throws Exception;
	
	/**
	 * 시설 예약 취소
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int updateRoomCancelCodeAjax(RequestBox requestBox) throws Exception;

	/**
	 * 시설 예약 단일건 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> roomInfoRsvInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * 시설 예약 환불 내역 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> roomInfoRsvPaybackInfo(RequestBox requestBox) throws Exception;

	/**
	 * 시설 예약 현황 목록형 날짜 범위 기본값 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> searchThreeMonthRoom(RequestBox requestBox) throws Exception;

	/**
	 * 해당 예약건에 적용될 취소 수수료 패널티 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> roomInfoRsvCancelPenalty(RequestBox requestBox) throws Exception;
	
}
