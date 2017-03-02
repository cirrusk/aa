package amway.com.academy.manager.reservation.expInfo.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.reservation.expInfo.service.ExpInfoService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.StringUtil;

@Service
public class ExpInfoServiceImpl implements ExpInfoService {

	@Autowired
	private ExpInfoMapper expInfoMapper;

	/**
	 * pp별 예약 측정/체험 프로그램 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> expProgramListAjax(RequestBox requestBox) throws Exception {
		return expInfoMapper.expProgramListAjax(requestBox);
	}

	/**
	 * 해당 pp 해당 측정/체험타입 년 월 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> expInfoCalendarAjax(RequestBox requestBox) throws Exception {
		return expInfoMapper.expInfoCalendarAjax(requestBox);
	}

	/**
	 * 해당 pp 해당 측정/체험타입 년 월 별 예약 현황 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> expInfoListAjax(RequestBox requestBox) throws Exception {
		return expInfoMapper.expInfoListAjax(requestBox);
	}

	/**
	 * 측정/체험 예약현황 운영자 예약 정보 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> expInfoAdminReservationSelectAjax(RequestBox requestBox) throws Exception {
		
		List<DataBox> list = new ArrayList<DataBox>();
		
		for(int i = 0; i < requestBox.getVector("sessionCheck").size(); i++){
			if(Boolean.parseBoolean((String) requestBox.getVector("sessionCheck").get(i))){
				requestBox.put("ppSeq", requestBox.getVector("tempPpSeq").get(i));
				requestBox.put("expSeq", requestBox.getVector("tempExpSeq").get(i));
				requestBox.put("expSessionSeq", requestBox.getVector("tempExpSessionSeq").get(i));
				requestBox.put("sessionDateTime", requestBox.getVector("tempSessionDateTime").get(i));
				
				list.add(expInfoMapper.expInfoAdminReservationSelectAjax(requestBox));
			}
		}
		
		return list;
	}

	/**
	 * 측정/체험 예약현황 운영자 예약
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int expInfoAdminReservationListInsertAjax(RequestBox requestBox) throws Exception {
		
		int result = 0;
		
		String comboValue = "";
		String textValue = "";
		String adminFirstReason = "";		
		String firstreason = "";
		
		//기존 로직은 typeseq가 없어 어드민이 예약 하더라도 프로트에서 예약대기 표현이 안되어서 typeseq조회 쿼리 추가 
		requestBox.put("temExpSeq", requestBox.getVector("tempExpSeq").get(0));
		DataBox typeSeq = expInfoMapper.searchExpTypeSeq(requestBox);
		requestBox.put("typeseq", typeSeq.get("typeseq"));
		
		for(int i = 0; i < requestBox.getVector("tempPpSeq").size(); i++){
			requestBox.put("ppSeq", requestBox.getVector("tempPpSeq").get(i));
//			requestBox.put("typeSeq", requestBox.getVector("tempTypeSeq").get(i));
			requestBox.put("expSeq", requestBox.getVector("tempExpSeq").get(i));
			requestBox.put("reservationDate", requestBox.getVector("tempReservationDate").get(i));
			requestBox.put("expSessionSeq", requestBox.getVector("tempExpSessionSeq").get(i));
			requestBox.put("startDateTime", requestBox.getVector("tempStartDateTime").get(i));
			requestBox.put("endDateTime", requestBox.getVector("tempEndDateTime").get(i));
			
			/** 테스터요청[관리자 우선예약 사유를 전부다 보여주길 원하여 모든 사유를 '/'로 구분하여 ADMINFIRSTREASON 컬럼에 모든 사유를 한줄로 insert ] */
			firstreason = (String) requestBox.getVector("firstreason").get(0);
			comboValue = (String)requestBox.getVector("adminfirstreasoncode2").get(0);
			
			/** 예약자관리 리스트에서 사유를 보여줄때 &amp 까지 보여줘서 quoteReplacement 함수 삭제 */ 
//			textValue = java.util.regex.Matcher.quoteReplacement(StringUtil.htmlSpecialChar((String)requestBox.getVector("adminfirstreason").get(0))); 
			
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
			
 			result = expInfoMapper.expInfoAdminReservationInsertAjax(requestBox);
		}
		
		return result;
	}

	/**
	 * 측정/체험 예약현황 운영자 예약 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> expInfoAdminReservationCancelSelectAjax(RequestBox requestBox) throws Exception {
		return expInfoMapper.expInfoAdminReservationCancelSelectAjax(requestBox);
	}

	/**
	 * 측정/체험 예약현황 운영자 예약 취소
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int expInfoAdminReservationListCancelUpdateAjax(RequestBox requestBox) throws Exception {
		
		int result = 0;
		
		for(int i = 0; i < requestBox.getVector("rsvCancelCheck").size(); i++){
			if(Boolean.parseBoolean((String) requestBox.getVector("rsvCancelCheck").get(i))){
				requestBox.put("rsvSeq", requestBox.getVector("tempRsvSeq").get(i));
				
				result = expInfoMapper.expInfoAdminReservationCancelUpdateAjax(requestBox);
			}
			
		}
		
		return result;
	}

	/**
	 * pp, 측정/체험, 년, 월, 일 정보 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public DataBox expInfoSessionSelectAjax(RequestBox requestBox) throws Exception {
		return expInfoMapper.expInfoSessionSelectAjax(requestBox);
	}

	/**
	 * pp, 측정/체험, 년, 월, 일 세션 정보 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> expInfoSessionListAjax(RequestBox requestBox) throws Exception {
		return expInfoMapper.expInfoSessionListAjax(requestBox);
	}

	/**
	 * 운영자 예약
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int expInfoAdminReservationInsertAjax(RequestBox requestBox) throws Exception {
		return expInfoMapper.expInfoAdminReservationInsertAjax(requestBox);
	}

	/**
	 * 운영자 예약 취소
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int expInfoAdminReservationCancelUpdateAjax(RequestBox requestBox) throws Exception {
		return expInfoMapper.expInfoAdminReservationCancelUpdateAjax(requestBox);
	}
	
}
