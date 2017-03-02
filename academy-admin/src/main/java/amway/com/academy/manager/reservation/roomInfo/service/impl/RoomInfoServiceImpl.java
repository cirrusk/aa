package amway.com.academy.manager.reservation.roomInfo.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.reservation.roomInfo.service.RoomInfoService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.StringUtil;

@Service
public class RoomInfoServiceImpl implements RoomInfoService {

	@Autowired
	private RoomInfoMapper roomInfoMapper;

	/**
	 * pp별 예약 시설 형태 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> roomTypeListAjax(RequestBox requestBox) throws Exception {
		return roomInfoMapper.roomTypeListAjax(requestBox);
	}

	/**
	 * 해당 pp 해당 시설타입 년 월 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> roomInfoCalendarAjax(RequestBox requestBox) throws Exception {
		return roomInfoMapper.roomInfoCalendarAjax(requestBox);
	}

	/**
	 * 해당 pp 해당 시설타입 년 월 별 예약 현황 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> roomInfoListAjax(RequestBox requestBox) throws Exception {
		return roomInfoMapper.roomInfoListAjax(requestBox);
	}

	/**
	 * 시설 예약현황 운영자 예약 정보 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> roomInfoAdminReservationSelectAjax(RequestBox requestBox) throws Exception {
		
		List<DataBox> list = new ArrayList<DataBox>();
		
		for(int i = 0; i < requestBox.getVector("sessionCheck").size(); i++){
			
			if(Boolean.parseBoolean((String) requestBox.getVector("sessionCheck").get(i))){
				requestBox.put("ppSeq", requestBox.getVector("tempPpSeq").get(i));
				requestBox.put("roomSeq", requestBox.getVector("tempRoomSeq").get(i));
				requestBox.put("rsvSessionSeq", requestBox.getVector("tempRsvSessionSeq").get(i));
				requestBox.put("sessionDateTime", requestBox.getVector("tempSessionDateTime").get(i));
				
				list.add(roomInfoMapper.roomInfoAdminReservationSelectAjax(requestBox));
			}
		}
		
		return list;
	}

	/**
	 * 시설 예약현황 운영자 예약
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int roomInfoAdminReservationListInsertAjax(RequestBox requestBox) throws Exception {
		
		int result = 0;
		
		String comboValue = "";
		String textValue = "";
		String adminFirstReason = "";
		String firstreason = "";
		
		for(int i = 0; i < requestBox.getVector("tempPpSeq").size(); i++){
			requestBox.put("ppSeq", requestBox.getVector("tempPpSeq").get(i));
//			requestBox.put("typeSeq", requestBox.getVector("tempTypeSeq").get(i));
			requestBox.put("roomSeq", requestBox.getVector("tempRoomSeq").get(i));
			requestBox.put("reservationDate", requestBox.getVector("tempReservationDate").get(i));
			requestBox.put("rsvSessionSeq", requestBox.getVector("tempRsvSessionSeq").get(i));
			requestBox.put("startDateTime", requestBox.getVector("tempStartDateTime").get(i));
			requestBox.put("endDateTime", requestBox.getVector("tempEndDateTime").get(i));
			
			/** 테스터요청[관리자 우선예약 사유를 전부다 보여주길 원하여 모든 사유를 '/'로 구분하여 ADMINFIRSTREASON 컬럼에 모든 사유를 한줄로 insert ] */
			firstreason = (String) requestBox.getVector("firstreason").get(0);
			comboValue = (String)requestBox.getVector("adminfirstreasoncode2").get(0);
			
			/** 예약자관리 리스트에서 사유를 보여줄때 &amp 까지 보여줘서 quoteReplacement 함수 삭제 */ 
//			textValue = java.util.regex.Matcher.quoteReplacement(StringUtil.htmlSpecialChar((String)requestBox.getVector("adminfirstreason").get(0)));
			textValue = java.util.regex.Matcher.quoteReplacement(StringUtil.htmlSpecialChar((String)requestBox.getVector("adminfirstreason").get(0)));
			
			textValue = (String)requestBox.getVector("adminfirstreason").get(0);
//			adminFirstReason = "".equals(textValue) ? comboValue : textValue;
			
			/** 테스터요청[관리자 우선예약 사유를 전부다 보여주길 원하여 모든 사유를 '/'로 구분하여 ADMINFIRSTREASON 컬럼에 모든 사유를 한줄로 insert ] */
			if("".equals(adminFirstReason)){
				if("".equals(textValue)){
					adminFirstReason = firstreason + "/ " + comboValue;
				}else{
					adminFirstReason = firstreason + "/ " + comboValue + "/ " + textValue;
				}
			}
			
			requestBox.put("adminfirstreason", adminFirstReason);
			
			result = roomInfoMapper.roomInfoAdminReservationInsertAjax(requestBox);
		}
		
		return result;
	}

	/**
	 * 시설 예약현황 운영자 예약 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> roomInfoAdminReservationCancelSelectAjax(RequestBox requestBox) throws Exception {
		return roomInfoMapper.roomInfoAdminReservationCancelSelectAjax(requestBox);
	}

	/**
	 * 시설 예약현황 운영자 예약 취소
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int roomInfoAdminReservationListCancelUpdateAjax(RequestBox requestBox) throws Exception {
		
		int result = 0;
		
		for(int i = 0; i < requestBox.getVector("rsvCancelCheck").size(); i++){
			if(Boolean.parseBoolean((String) requestBox.getVector("rsvCancelCheck").get(i))){
				requestBox.put("rsvSeq", requestBox.getVector("tempRsvSeq").get(i));
				
				result = roomInfoMapper.roomInfoAdminReservationCancelUpdateAjax(requestBox);
			}
			
		}
		
		return result;
	}

	/**
	 * pp, 시설, 년, 월, 일 정보 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public DataBox roomInfoSessionSelectAjax(RequestBox requestBox) throws Exception {
		return roomInfoMapper.roomInfoSessionSelectAjax(requestBox);
	}

	/**
	 * pp, 시설, 년, 월, 일 세션 정보 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> roomInfoSessionListAjax(RequestBox requestBox) throws Exception {
		return roomInfoMapper.roomInfoSessionListAjax(requestBox);
	}

	/**
	 * 운영자 예약
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int roomInfoAdminReservationInsertAjax(RequestBox requestBox) throws Exception {
		return roomInfoMapper.roomInfoAdminReservationInsertAjax(requestBox);
	}

	/**
	 * 운영자 예약 취소
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int roomInfoAdminReservationCancelUpdateAjax(RequestBox requestBox) throws Exception {
		return roomInfoMapper.roomInfoAdminReservationCancelUpdateAjax(requestBox);
	}

	@Override
	public List<DataBox> partitionRoomSeqList(RequestBox requestBox) throws Exception {
		/** 파티션룸 체크 (합쳐진 파티션룸인지 각각의 파티션룸인지 파티션룸이 아닌지 */
		String partitionCheck = roomInfoMapper.partitionCheck(requestBox);
		
		List<DataBox> partitionRoomSeqList = new ArrayList<DataBox>();
		
		if(("true").equals(partitionCheck)){
			/** 합쳐진 파티션 룸인경우 해당 roomseq를 parentroomseq로 갖는 roomseq 조회 */
			partitionRoomSeqList = roomInfoMapper.partitionRoomSeqList(requestBox);
		}else if(("false").equals(partitionCheck)){
			/** 합쳐지지않은 파티션 룸인경우 해당 roomseq return */
			partitionRoomSeqList = roomInfoMapper.partitionRoomParentSeqList(requestBox);
		}
		
		return partitionRoomSeqList;
	}
	
}
