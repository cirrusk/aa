package amway.com.academy.reservation.roomEdu.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.reservation.basicPackage.service.impl.BasicReservationServiceImpl;
import amway.com.academy.reservation.basicPackage.service.impl.CommonReservationService;
import amway.com.academy.reservation.roomEdu.service.RoomEduService;
import amway.com.academy.reservation.roominfo.service.impl.RoomInfoMapper;
import framework.com.cmm.FWMessageSource;
import framework.com.cmm.lib.RequestBox;

@Service
public class RoomEduServiceImpl extends CommonReservationService implements RoomEduService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RoomEduServiceImpl.class);
	
	@Autowired
	private RoomEduMapper roomEduDAO;
	
	@Autowired
	private RoomInfoMapper roomInfoDAO;

	@Resource(name="egovMessageSource")
	private FWMessageSource messageSource;
	
	@Override
	public List<Map<String, String>> ppRsvRoomCodeList(RequestBox requestBox) throws Exception {
		/** 시설 키 값 조회 */
		requestBox.put("rsvTypeName", "교육장");
		Map<String, Integer> searchRsvRoomTypeSeq = roomEduDAO.searchRsvRoomTypeSeq(requestBox);
		
		/** 얻어온 시설 키값 셋팅  */
		requestBox.put("typeseq", searchRsvRoomTypeSeq.get("typeseq"));
		
		/** 해당 pp조회 */
		return roomEduDAO.ppRsvRoomCodeList(requestBox);
	}

	@Deprecated
	@Override
	public Map<String, String> searchLastRsvRoomPp(RequestBox requestBox) throws Exception {
		
		Map<String, String> searchLastRsvRoomPp = new HashMap<String, String>();
		
		String ppSeq = roomEduDAO.searchLastRsvRoomPp(requestBox);
		
		if(ppSeq == null){
			searchLastRsvRoomPp.put("ppseq", "1");
		}else{
			searchLastRsvRoomPp.put("ppseq", ppSeq);
		}
		
		return searchLastRsvRoomPp;
	}

	@Override
	public List<Map<String, String>> rsvRoomInfoList(RequestBox requestBox) throws Exception {
		
		return roomEduDAO.rsvRoomInfoList(requestBox);
	}
	
	@Override
	public Map<String, String> roomEduRsvRoomDetailInfo(RequestBox requestBox) throws Exception {
		
		return roomEduDAO.roomEduRsvRoomDetailInfo(requestBox);
	}

	@Override
	public List<Map<String, String>> roomEduCalendar(RequestBox requestBox) throws Exception {
		return roomEduDAO.roomEduCalendar(requestBox);
	}

	@Override
	public List<Map<String, String>> roomEduYearMonth(RequestBox requestBox) throws Exception {
		return roomEduDAO.roomEduYearMonth(requestBox);
	}

	@Override
	public Map<String, String> roomEduToday() throws Exception {
		return roomEduDAO.roomEduToday();
	}

	@Override
	public List<Map<String, String>> roomEduReservationInfoList(RequestBox requestBox) throws Exception {
		return roomEduDAO.roomEduReservationInfoList(requestBox);
	}

	@Override
	public List<Map<String, String>> roomEduSeesionList(RequestBox requestBox) throws Exception {
		return roomEduDAO.roomEduSeesionList(requestBox);
	}


	@Override
	public List<Map<String, String>> roomEduPaymentCheck(RequestBox requestBox) throws Exception {
		
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("reservationDate").size(); i++){
			
			requestBox.put("tempReservationDate", requestBox.getVector("reservationDate").get(i));
			requestBox.put("tempRsvSessionSeq", requestBox.getVector("rsvSessionSeq").get(i));
			
			Map<String, String> map = roomEduDAO.roomEduPaymentCheck(requestBox);
			
			if(map != null){
				list.add(map);
			}
			
		}
		
		return list;
	}

	@Override
	public List<Map<String, String>> roomEduPaymentInfoPop(RequestBox requestBox) throws Exception {
		
		String reservationType = requestBox.getString("costNoCost");
		LOGGER.debug("reservationType : ", reservationType);
		
		if("nocost".equals(reservationType)) {
			return super.roomPaymentInfo(requestBox, false);
		}else {
			return super.roomPaymentInfo(requestBox, true);
		}
		
	}
	
	@Override
	public List<Map<String, String>> roomEduPaymentInfoAjax(RequestBox requestBox) throws Exception {
		
		return super.roomPaymentInfo(requestBox, false);
	}

	@Override
	public List<Map<String, String>> roomEduReservationInsertAjax(RequestBox requestBox) throws Exception {
		
		return super.roomReservationInsert(requestBox);
	}

	@Override
	public List<Map<String, String>> roomEduReservationMobileInsertAjax(RequestBox requestBox) throws Exception {
		
		return super.roomReservationInsert(requestBox);
	}
	
	@Override
	public List<Map<String, String>> roomEduPaymentDisablePop(RequestBox requestBox) throws Exception {
		
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
			
			list.add(map);
		}
		
		return list;
	}

	@Override
	public List<Map<String, String>> roomReservationInfoList(RequestBox requestBox) throws Exception {
		return roomEduDAO.roomReservationInfoList(requestBox);
	}

	@Override
	public List<Map<String, String>> roomDayReservationList(RequestBox requestBox) throws Exception {
		return roomEduDAO.roomDayReservationList(requestBox);
	}
	
	@Override
	public List<Map<String, String>> roomMonthReservationList(RequestBox requestBox) throws Exception {
		return roomEduDAO.roomMonthReservationList(requestBox);
	}

	@Override
	public List<Map<String, String>> multipurposeRoomCheck(RequestBox requestBox) throws Exception {
		return roomEduDAO.multipurposeRoomCheck(requestBox);
	}

	@Override
	public Map<String, String> searchRoomPayPenalty(RequestBox requestBox) throws Exception {
		return roomInfoDAO.searchRoomPayPenalty(requestBox); 
	}

	@Override
	public List<Map<String, String>> partitionRoomSeqList(RequestBox requestBox) throws Exception {
		LOGGER.debug("invoke RoomEduService.partitionRoomSeqList()");
		
		/** 파티션룸 체크 (합쳐진 파티션룸인지 각각의 파티션룸인지 파티션룸이 아닌지 */
		String partitionCheck = roomEduDAO.partitionCheck(requestBox);
		LOGGER.debug("partitionCheck : {}", partitionCheck);
		
		List<Map<String, String>> partitionRoomSeqList = new ArrayList<Map<String,String>>();
		
		if(("true").equals(partitionCheck)){
			/** 합쳐진 파티션 룸인경우 해당 roomseq를 parentroomseq로 갖는 roomseq 조회 */
			partitionRoomSeqList = roomEduDAO.partitionRoomSeqList(requestBox);
		}else if(("false").equals(partitionCheck)){
			/** 합쳐지지않은 파티션 룸인경우 해당 roomseq return */
			partitionRoomSeqList = roomEduDAO.partitionRoomParentSeqList(requestBox);
		}
		
		LOGGER.debug("partitionRoomSeqList : {}", partitionRoomSeqList);
		return partitionRoomSeqList;
	}

	@Override
	public Map<String, String> roomStandByNumberAdvanceChecked(RequestBox requestBox) throws Exception {
		Map<String, String> roomStandByNumber = new HashMap<String, String>();
		
		String interfaceChannel = (String) requestBox.get("interfaceChannel");
		String paymentmode = (String) requestBox.get("paymentmode");
		
		for(int i = 0; i < requestBox.getVector("typeseq").size(); i++){
			
			if("MOBILE".equals(interfaceChannel)) {
				requestBox.put("tempStandByNumber", (String) requestBox.getVector("standByNumber").get(i));
				requestBox.put("tempReservationDate", (String) requestBox.getVector("reservationDate").get(i));
				requestBox.put("tempRsvSessionSeq", (String) requestBox.getVector("rsvSessionSeq").get(i));
			}else{
				requestBox.put("tempStandByNumber", (String) requestBox.getVector("standbynumber").get(i));
				requestBox.put("tempReservationDate", (String) requestBox.getVector("reservationdate").get(i));
				requestBox.put("tempRsvSessionSeq", (String) requestBox.getVector("rsvsessionseq").get(i));
			}
			
			//해당일, 해당 세션시간, 대기자 여부에 따른 대기자 조회
			roomStandByNumber =  roomEduDAO.roomStandByNumberAdvanceChecked(requestBox);
			
			//먼저 선점 한 사람이 있다면  return false
			if("false".equals(roomStandByNumber.get("standbynumber"))){
				roomStandByNumber.put("msg", "false");
				roomStandByNumber.put("reason", messageSource.getMessage("rsv.reservationCondition.anotherReservation")); //예약 불가 메세지
				
				return roomStandByNumber;
			}else{
				roomStandByNumber.put("msg", "true");
			}
		}
		return roomStandByNumber;
	}

}
