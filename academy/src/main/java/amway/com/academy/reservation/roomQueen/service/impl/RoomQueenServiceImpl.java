package amway.com.academy.reservation.roomQueen.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.reservation.roomEdu.service.impl.RoomEduMapper;
import amway.com.academy.reservation.roomQueen.service.RoomQueenService;
import framework.com.cmm.lib.RequestBox;

@Service
public class RoomQueenServiceImpl implements RoomQueenService {
	
	@Autowired
	private RoomEduMapper roomEduDAO;
	
	@Autowired
	private RoomQueenMapper roomQueenDAO;

	@Override
	public List<Map<String, String>> ppRsvRoomQueenCodeList(RequestBox requestBox) throws Exception {
		/** 시설 키 값 조회 */
		requestBox.put("rsvTypeName", "퀸룸");
		Map<String, Integer> searchRsvRoomTypeSeq = roomEduDAO.searchRsvRoomTypeSeq(requestBox);
		
		/** 얻어온 시설 키값 셋팅  */
		requestBox.put("typeseq", searchRsvRoomTypeSeq.get("typeseq"));
		
		/** 해당 pp조회 */
		return roomEduDAO.ppRsvRoomCodeList(requestBox);
	}

	@Override
	public Map<String, String> getCookMasterCoupon(RequestBox requestBox) throws Exception {
		return roomQueenDAO.getCookMasterCoupon(requestBox);
	}
	
}
