package amway.com.academy.reservation.expHealth.service.impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.reservation.basicPackage.service.impl.BasicReservationMapper;
import amway.com.academy.reservation.basicPackage.service.impl.CommonReservationService;
import amway.com.academy.reservation.expHealth.service.ExpHealthService;
import framework.com.cmm.FWMessageSource;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.DateUtil;

@Service
public class ExpHealthServiceImpl extends CommonReservationService implements ExpHealthService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExpHealthServiceImpl.class);
	
	@Autowired
	private BasicReservationMapper basicReservationDAO;
	
	@Resource(name="egovMessageSource")
	private FWMessageSource messageSource;

	@Override
	public List<Map<String, String>> ppRsvCodeList(RequestBox requestBox) throws Exception {
		/** 체성분 키 값 가져오기 */
		requestBox.put("rsvTypeName", "체성분");
		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 체성분 키값 셋팅  */
		requestBox.put("typeseq", searchRsvTypeSeq.get("typeseq"));
		
		/** 해당 pp조회 */
		return basicReservationDAO.ppRsvCodeList(requestBox);
	}

	@Override
	public Map<String, String> expHealthDetailInfo(RequestBox requestBox) throws Exception {
		
		/** 체성분 키 값 가져오기 */
		requestBox.put("rsvTypeName", "체성분");
		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 체성분 키값 셋팅  */
		requestBox.put("typeseq", searchRsvTypeSeq.get("typeseq"));
		
		return basicReservationDAO.expDetailInfo(requestBox);
	}

	@Override
	public List<Map<String, String>> searchStartSeesionTimeListAjax(RequestBox requestBox) throws Exception {
		
		Map<String, String> searchFirstSession = basicReservationDAO.searchFirstSession(requestBox);
		
		if(searchFirstSession != null){
			requestBox.put("settypecode", searchFirstSession.get("settypecode"));
			requestBox.put("worktypecode", searchFirstSession.get("worktypecode"));
		}else{
			requestBox.put("settypecode", "S01".toString());
			requestBox.put("worktypecode", "");
		}
		
		/** 체성분 키 값 조회 */
		requestBox.put("rsvTypeName", "체성분");
		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 체성분 키값 셋팅  */
		requestBox.put("typeseq", searchRsvTypeSeq.get("typeseq"));
		
		return basicReservationDAO.searchStartSeesionTimeListAjax(requestBox);
	}

	@Override
	public List<Map<String, String>> expHealthRsvRequestPop(RequestBox requestBox) throws Exception {
		
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("reservationDate").size(); i++){
			
			HashMap<String, String> map = new HashMap<String, String>();
			
			map.put("expsessionseq", (String) requestBox.getVector("expsessionseq").get(i));
			map.put("sessionTime", (String) requestBox.getVector("sessionTime").get(i));
			map.put("rsvflag", (String) requestBox.getVector("rsvflag").get(i));
			map.put("startdatetime", (String) requestBox.getVector("startdatetime").get(i));
			map.put("enddatetime", (String) requestBox.getVector("enddatetime").get(i));
			map.put("dateFormat", (String) requestBox.getVector("dateFormat").get(i));
			map.put("reservationDate", (String) requestBox.getVector("reservationDate").get(i));
			map.put("ppSeq", (String) requestBox.getVector("ppSeq").get(i));
			map.put("ppName", (String) requestBox.getVector("ppName").get(i));
			map.put("expseq", (String) requestBox.getVector("expseq").get(i));
			map.put("typeSeq", (String) requestBox.getVector("typeSeq").get(i));
			
			list.add(map);
			
		}
		
		return list;
	}


	@Override
	public List<Map<String, String>> expHealthInsertAjax(RequestBox requestBox) throws Exception {
		
		LOGGER.debug("invoke expHealthInsertAjax");
		LOGGER.debug("requestBox : {}", requestBox);
		
		Timestamp ts = new Timestamp(System.currentTimeMillis());
		String transactionTime = String.valueOf(ts.getTime());
		requestBox.put("transactionTime", transactionTime);

        LOGGER.debug("transactionTime", transactionTime);

		/** 체성분 측정 정보를 담을 list */
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("ppSeq").size(); i++){
			HashMap<String, String> map = new HashMap<String, String>();
			
			requestBox.put("tempReservationDate", (String) requestBox.getVector("reservationDate").get(i));
			requestBox.put("tempExpsessionseq", (String) requestBox.getVector("expsessionseq").get(i));
			
			/** 예약 전 예약 대기자 조회 */
			Map<String, String> expReservation = basicReservationDAO.searchExpReservation(requestBox);
			
			
			if(Integer.parseInt(String.valueOf(expReservation.get("standbynumber"))) < 1){
				map.put("transactionTime", transactionTime);
				map.put("programName", "체성분 측정"); /* for sms */
				map.put("ppName", (String) requestBox.getVector("ppName").get(0));
				
				map.put("account", (String) requestBox.getVector("account").get(0));
				
				map.put("ppSeq", (String) requestBox.getVector("ppSeq").get(i));
				map.put("expsessionseq", (String) requestBox.getVector("expsessionseq").get(i));
				map.put("expseq", (String) requestBox.getVector("expseq").get(i));
				map.put("typeSeq", (String) requestBox.getVector("typeSeq").get(i));
				
				map.put("reservationDate", (String) requestBox.getVector("reservationDate").get(i));
				map.put("dateFormat", (String) requestBox.getVector("dateFormat").get(i));
				
				
				map.put("sessionTime", (String) requestBox.getVector("sessionTime").get(i));
				map.put("startdatetime", (String) requestBox.getVector("startdatetime").get(i));
				map.put("enddatetime", (String) requestBox.getVector("enddatetime").get(i));
				
				map.put("partnerTypeCode", (String) requestBox.getVector("partnerTypeCode").get(i));
				
				map.put("rsvflag", (String) requestBox.getVector("rsvflag").get(i));
				
				if("200".equals((String) requestBox.getVector("rsvflag").get(i))){
					map.put("standbynumber", "1");
					map.put("standByNumber", "1");
				}else{
					map.put("standbynumber", "0");
					map.put("standByNumber", "0");
				}
				map.put("msg", "true");
				
				
				/** 체성분 측정 등록 */
				basicReservationDAO.expInsertAjax(map);
				
		
				list.add(map);
				
				try {
					
					String sessionDateTime = (String) requestBox.getVector("reservationDate").get(i) 
							+ (String) requestBox.getVector("startdatetime").get(i);
					
					sessionDateTime = DateUtil.getKoreanDateTime(sessionDateTime, "MDhm");
					
					map.put("sessionInfo", sessionDateTime );
					
					/** send message - push */
					super.sendPushMessage(map, "chck", "reserv");
					
					/** send message - note */
					super.sendNoteMessage(map, "chck", "reserv");
					
				} catch (Exception e) {
					LOGGER.error(e.getMessage(), e);
				}
				
			}else{
				map.put("msg", "false");
				map.put("reason", messageSource.getMessage("rsv.reservationCondition.anotherReservation"));
				list.add(map);
			}
			
		}
		
		return list;
	}
	
	@Override
	public List<Map<String, String>> expReservationInfoDetailList(RequestBox requestBox) throws Exception {
		
		return basicReservationDAO.expReservationInfoDetailList(requestBox);
	}

	@Override
	public List<Map<String, String>> searchExpHealthHoilDay(RequestBox requestBox) throws Exception {
		
		/** 체성분 키 값 가져오기 */
		requestBox.put("rsvTypeName", "체성분");
		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 체성분 키값 셋팅  */
		requestBox.put("typeseq", searchRsvTypeSeq.get("typeseq"));
		
		return basicReservationDAO.searchExpHoliDay(requestBox);
	}

	@Override
	public List<Map<String, String>> searchRsvAbleSessionTotalCount(RequestBox requestBox) throws Exception {
		
		/** 체성분 키 값 가져오기 */
		requestBox.put("rsvTypeName", "체성분");
		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 체성분 키값 셋팅  */
		requestBox.put("typeseq", searchRsvTypeSeq.get("typeseq"));
		
		return basicReservationDAO.searchRsvAbleSessionTotalCount(requestBox);
	}

	@Override
	public List<Map<String, String>> expHealthDuplicateCheck(RequestBox requestBox) throws Exception {
		
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("reservationDate").size(); i++){
			
			requestBox.put("tempReservationDate", requestBox.getVector("reservationDate").get(i));
			requestBox.put("tempExpSessionSeq", requestBox.getVector("expsessionseq").get(i));
			if(("100").equals(requestBox.getVector("rsvflag").get(i))){
				requestBox.put("tempStandByNumber", "0");
			}else if(("200").equals(requestBox.getVector("rsvflag").get(i))){
				requestBox.put("tempStandByNumber", "1");
			}
			
			Map<String, String> map = basicReservationDAO.expDuplicateCheck(requestBox);
			
			if(map != null){
				list.add(map);
			}
			
		}
		
		return list;
	}

	@Override
	public List<Map<String, String>> expHealthDisablePop(RequestBox requestBox) throws Exception {
		
		/** 시설 정보를 담을 list */
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("expsessionseq").size(); i++){
			
			HashMap<String, String> map = new HashMap<String, String>();
			
			map.put("ppName", (String) requestBox.getVector("ppname").get(i));
			map.put("programName", (String) requestBox.getVector("programname").get(i));
			map.put("reservationDate", (String) requestBox.getVector("reservationdate").get(i));
			map.put("reservationWeek", (String) requestBox.getVector("reservationweek").get(i));
			map.put("expSessionSeq", (String) requestBox.getVector("expsessionseq").get(i));
			map.put("startDateTime", (String) requestBox.getVector("starttime").get(i));
			map.put("endDateTime", (String) requestBox.getVector("endtime").get(i));
			map.put("sessionName", (String) requestBox.getVector("sessionname").get(i));
			map.put("standByNumber", (String) requestBox.getVector("standbynumber").get(i));
			
			list.add(map);
		}
		
		return list;
	}

	@Override
	public Map<String, String> searchExpPenalty(RequestBox requestBox)throws Exception {
		return basicReservationDAO.searchExpPenalty(requestBox);
	}

	@Override
	public Map<String, String> expHealthStandByNumberAdvanceChecked(RequestBox requestBox) throws Exception {
		
		Map<String, String> expStandByNumber = new HashMap<String, String>();
		
		for(int i = 0; i < requestBox.getVector("ppSeq").size(); i++){
			requestBox.put("tempReservationDate", (String) requestBox.getVector("reservationDate").get(i));
			requestBox.put("tempExpsessionseq", (String) requestBox.getVector("expsessionseq").get(i));
			requestBox.put("tempRsvflag", (String) requestBox.getVector("rsvflag").get(i));
		
			//해당일, 해당 세션시간, 대기자 여부에 따른 대기자 조회
			expStandByNumber =  basicReservationDAO.expStandByNumberAdvanceChecked(requestBox);
			
			//먼저 선점 한 사람이 있다면  return false
			if("false".equals(expStandByNumber.get("standbynumber"))){
				expStandByNumber.put("msg", "false");
				expStandByNumber.put("reason", messageSource.getMessage("rsv.reservationCondition.anotherReservation"));//예약 불가 메세지
				
				return expStandByNumber;
			}else{
				expStandByNumber.put("msg", "true");
			}
		}
		
		return expStandByNumber;
		
	}

}
