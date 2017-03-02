package amway.com.academy.reservation.roomBiz.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.reservation.basicPackage.service.impl.BasicReservationServiceImpl;
import amway.com.academy.reservation.basicPackage.service.impl.CommonReservationService;
import amway.com.academy.reservation.roomBiz.service.RoomBizService;
import amway.com.academy.reservation.roomEdu.service.impl.RoomEduMapper;
import framework.com.cmm.lib.RequestBox;

@Service
public class RoomBizServiceImpl extends CommonReservationService implements RoomBizService {
	
	@Autowired
	private RoomEduMapper roomEduDAO;
	
	@Autowired
	private RoomBizMapper roomBizDAO;

	@Override
	public List<Map<String, String>> ppRsvRoomBizCodeList(RequestBox requestBox) throws Exception {
		
		/** 시설 키 값 조회 */
		requestBox.put("rsvTypeName", "비즈룸");
		Map<String, Integer> searchRsvRoomTypeSeq = roomEduDAO.searchRsvRoomTypeSeq(requestBox);
		
		/** 얻어온 시설 키값 셋팅  */
		requestBox.put("typeseq", searchRsvRoomTypeSeq.get("typeseq"));
		
		/** 해당 pp조회 */
		return roomEduDAO.ppRsvRoomCodeList(requestBox);
	}
	
	@Override
	public List<Map<String, String>> roomBizPaymentInfoPop(RequestBox requestBox) throws Exception {
		return super.roomPaymentInfo(requestBox, false);
	}

	@Override
	public List<Map<String, String>> roomBizDisablePop(RequestBox requestBox) throws Exception {
		/** 시설 정보를 담을 list */
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("typeSeq").size(); i++){
			
			HashMap<String, String> map = new HashMap<String, String>();
			 
			map.put("typeSeq", (String) requestBox.getVector("typeSeq").get(i));
			map.put("ppSeq", (String) requestBox.getVector("ppSeq").get(i));
			map.put("ppName", (String) requestBox.getVector("ppName").get(i));
			map.put("roomSeq", (String) requestBox.getVector("roomSeq").get(i));
			map.put("roomName", (String) requestBox.getVector("roomName").get(i));
			map.put("sessionYmd", (String) requestBox.getVector("sessionYmd").get(i));
			map.put("sessionName", (String) requestBox.getVector("sessionName").get(i));
			map.put("sessionPrice", (String) requestBox.getVector("sessionPrice").get(i));
			map.put("reservationDate", (String) requestBox.getVector("reservationDate").get(i));
			map.put("rsvSessionSeq", (String) requestBox.getVector("rsvSessionSeq").get(i));
			map.put("startDateTime", (String) requestBox.getVector("startDateTime").get(i));
			map.put("endDateTime", (String) requestBox.getVector("endDateTime").get(i));
			map.put("price", (String) requestBox.getVector("price").get(i));
			map.put("standByNumber", (String) requestBox.getVector("standByNumber").get(i));
			
			list.add(map);
		}
		
		return list;
	}

	@Override
	public List<Map<String, String>> roomBizPaymentCheck(RequestBox requestBox) throws Exception {
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("reservationDate").size(); i++){
			
			requestBox.put("tempReservationDate", requestBox.getVector("reservationDate").get(i));
			requestBox.put("tempRsvSessionSeq", requestBox.getVector("rsvSessionSeq").get(i));
			requestBox.put("tempStandByNumber", requestBox.getVector("standByNumber").get(i));
			
			Map<String, String> map = roomBizDAO.roomBizPaymentCheck(requestBox);
			
			if(map != null){
				list.add(map);
			}
			
		}
		
		return list;
	}

	
}
