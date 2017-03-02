package amway.com.academy.reservation.roomQueen.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;

/**
 * 시설예약_퀸룸/파티룸
 * @author KR620225
 *
 */
public interface RoomQueenService {

	public List<Map<String, String>> ppRsvRoomQueenCodeList(RequestBox  requestBox) throws Exception;

	public Map<String, String> getCookMasterCoupon(RequestBox requestBox) throws Exception;
	
}
