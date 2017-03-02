package amway.com.academy.reservation.roominfo.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.reservation.basicPackage.service.impl.CommonReservationService;
import amway.com.academy.reservation.roomEdu.service.impl.RoomEduServiceImpl;
import amway.com.academy.reservation.roominfo.service.RoomInfoService;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.DateUtil;

@Service
public class RoomInfoServiceImpl extends CommonReservationService implements RoomInfoService{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RoomInfoServiceImpl.class);
	
	@Autowired
	private RoomInfoMapper roomInfoDAO;

	@Override
	public List<Map<String, String>> roomInfoList(RequestBox requestBox) throws Exception {
		
		List<String> list = new ArrayList<String>(); //string array를 list담기
		
		/** 검색조건[시설 종류(교육장, 비즈룸, 퀸룸/파티룸) 다중 선택시  조건 가공 하여 list에 담는다] */
		if(requestBox.getVector("searchRoomType").size() > 0){
			for(int i = 0; i < requestBox.getVector("searchRoomType").size(); i++){
				list.add((String) requestBox.getVector("searchRoomType").get(i));
			}
//			requestBox.remove("searchRoomType");
			requestBox.put("searchRoomTypeArray", list);
			requestBox.put("searchRoomType", list);
		}
		
		return roomInfoDAO.roomInfoList(requestBox);
	}
		
	@Override
	public int roomInfoListCount(RequestBox requestBox) throws Exception {
		
		List<String> list = new ArrayList<String>(); //string array를 list담기
		
		/** 검색조건[시설 종류(교육장, 비즈룸, 퀸룸/파티룸) 다중 선택시  조건 가공 하여 list에 담는다] */
		if(requestBox.getVector("searchRoomType").size() > 0){
			for(int i = 0; i < requestBox.getVector("searchRoomType").size(); i++){
				list.add((String) requestBox.getVector("searchRoomType").get(i));
			}
//			requestBox.remove("searchRoomType");
			requestBox.put("searchRoomTypeArray", list);
		}
		
		return (int) roomInfoDAO.roomInfoListCount(requestBox);
	}

	@Override
	public List<Map<String, String>> roomInfoDetailList(RequestBox requestBox) throws Exception {
		return roomInfoDAO.roomInfoDetailList(requestBox);
	}

	@Override
	public Map<String, String> searchRoomPayPenalty(RequestBox requestBox) throws Exception {
		return roomInfoDAO.searchRoomPayPenalty(requestBox);
	}
	
	@Override
	public int updateRoomCancelCodeAjax(RequestBox requestBox) throws Exception {
		
		LOGGER.debug("invoke updateRoomCancelCodeAjax");
		LOGGER.debug("requestBox : {}", requestBox);
		
		// 예약대기인 경우 패널티 없음
		if("1".equals(requestBox.get("standbynumber"))){
			// delete 로 변경
			roomInfoDAO.deleteRoomReservation(requestBox);
		}else{
			
			Map<String, String> penaltyInfo;
			Map<String, String> searchPenalty = null;
				
			if("P".equals(requestBox.get("typecode"))){
				//해당 시설 유료 패널티 조회
				searchPenalty = roomInfoDAO.searchRoomPayPenalty(requestBox);
			}
			if("F".equals(requestBox.get("typecode"))){
				//해당 시설 무료 패널티 조회
				searchPenalty = roomInfoDAO.searchRoomFreePenalty(requestBox);
			}
			if("C".equals(requestBox.get("typecode"))){
				//해당 시설 요리명장 무료 패널티 조회
				searchPenalty = roomInfoDAO.searchRoomCookFreePenalty(requestBox);
			}
			
			//패널티 부여
			if(searchPenalty != null){
				penaltyInfo = new HashMap<String, String>();
				
				penaltyInfo.put("account", requestBox.get("account"));
				penaltyInfo.put("rsvseq", requestBox.get("rsvseq"));
				
				penaltyInfo.put("roomseq", String.valueOf(searchPenalty.get("roomseq")));
				penaltyInfo.put("penaltyseq", String.valueOf(searchPenalty.get("penaltyseq")));
				penaltyInfo.put("reason", searchPenalty.get("typecode"));
				penaltyInfo.put("applytypecode", searchPenalty.get("applytypecode"));
				penaltyInfo.put("applytypevalue", searchPenalty.get("applytypevalue"));
				
				roomInfoDAO.insertRoomPenaltyHistory(penaltyInfo);
				
			}
			
			if(0 != Integer.parseInt(requestBox.get("paymentamount"))){
				/* RSVITEMBACKINFO : 반품정보관리 테이블에 인서트 - 패널티 적용된 환불금액 (requestBox.paymentamount x 환불비율)이 이미 적용이 돼있음 */
				if( 0 == roomInfoDAO.selectCountItemBackInfo(requestBox) ){
					roomInfoDAO.insertItemBackInfo(requestBox);
				}
			}
			
			/* 예약테이블(RSVRESERVATIONINFO)의 코드상태를 예약취소 상태로 변경 (CANCELCODE:B02->B01 , PAYMENTSTATUSCODE:?->P03 )  */
			roomInfoDAO.updateRoomCancelCodeAjax(requestBox);

			LOGGER.debug("requestBox {}", requestBox);
			
			/* 대기자 처리 - 예약 완료된건이 취소 됐을때 대기자가 있으면, 대기자를 예약 완료로 변경(업데이트) 해주는 기능 */ 
			/* (교육장과 퀸룸은 대기자가 없으므로 NULL이 되어 SKIP이 된다) */
			//rsvseq로 동일 날짜의 동일 rsvsessionseq 가 standbynumber 1이 존재 하는경우 조회된 예약정보의 standbynumber를 0으로 업데이트
			Map<String, String> roomWaitingInfo = roomInfoDAO.selectRoomWaitingInfo(requestBox);
			if(roomWaitingInfo != null){
				requestBox.put("rsvseq", roomWaitingInfo.get("rsvseq"));
				roomInfoDAO.updateRoomWaitingInfo(requestBox);
			}
		}
		
		
		/* send message for push & note */
		try {
			
			Map<String, String> messageMap; 
			
			messageMap = super.getSendMessageRoomBySeq(requestBox);
			
			messageMap.put("account",     requestBox.get("account"));
			messageMap.put("standByNumber",     "0");			
			//messageMap.put("aboName",     "");
			//messageMap.put("ppName",      "");
			//messageMap.put("roomName",    "");
			//messageMap.put("sessionInfo", "");
			//messageMap.put("reservationDate","");
			
			/** send message - push */
			super.sendPushMessage(messageMap, "room", "cancel");
			
			/** send message - note */
			super.sendNoteMessage(messageMap, "room", "cancel");
			
		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
		}
		
		return 0;
		
	}

	@Override
	public Map<String, String> roomInfoRsvInfo(RequestBox requestBox) throws Exception {
		return roomInfoDAO.roomInfoRsvInfo(requestBox);
	}
	
	@Override
	public Map<String, String> roomInfoRsvPaybackInfo(RequestBox requestBox)throws Exception {
		return roomInfoDAO.roomInfoRsvPaybackInfo(requestBox);
	}

	@Override
	public Map<String, String> searchThreeMonthRoom(RequestBox requestBox) throws Exception {
		return roomInfoDAO.searchThreeMonthRoom(requestBox);
	}

	@Override
	public Map<String, String> roomInfoRsvCancelPenalty(RequestBox requestBox)throws Exception {
		
		Map<String, String> roomInfoRsvCancelPenalty = new HashMap<String, String>();
		
		if("P".equals(requestBox.get("typecode"))){
			//유료 예약 취소 패널티 조회(당일예약취소시 패널티가 적용되지 않음)
			roomInfoRsvCancelPenalty = roomInfoDAO.roomInfoRsvPayCancelPenalty(requestBox);
			
		}else if("F".equals(requestBox.get("typecode"))){
			//무료 예약 취소 패널티 조회(당일예약취소시 패널티가 적용되지 않음)
			roomInfoRsvCancelPenalty = roomInfoDAO.roomInfoRsvFreeCancelPenalty(requestBox);
			
		}else if("C".equals(requestBox.get("typecode"))){
			//요리명장 무료예약 취소 패널티 조회(당일예약취소시 패널티가 적용되지 않음)
			roomInfoRsvCancelPenalty = roomInfoDAO.roomInfoRsvCookFreeCancelPenalty(requestBox);
		}
		
		if(roomInfoRsvCancelPenalty == null){
			roomInfoRsvCancelPenalty = new HashMap<String, String>();
		}
		
		return roomInfoRsvCancelPenalty;
	}

}
