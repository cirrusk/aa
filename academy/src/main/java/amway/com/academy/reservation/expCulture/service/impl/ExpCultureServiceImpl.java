package amway.com.academy.reservation.expCulture.service.impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.reservation.basicPackage.service.impl.BasicReservationMapper;
import amway.com.academy.reservation.basicPackage.service.impl.CommonReservationService;
import amway.com.academy.reservation.expCulture.service.ExpCultureService;
import framework.com.cmm.FWMessageSource;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.DateUtil;
import framework.com.cmm.util.StringUtil;

@Service
public class ExpCultureServiceImpl extends CommonReservationService implements ExpCultureService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExpCultureServiceImpl.class);
	
	@Autowired
	private BasicReservationMapper basicReservationDAO;
	
	@Autowired
	private ExpCultureMapper expCultureDAO;

	@Resource(name="egovMessageSource")
	private FWMessageSource messageSource;
	
	@Override
	public List<Map<String, String>> ppRsvCodeList(RequestBox requestBox) throws Exception {
		/** 체성분 키 값 가져오기 */
		requestBox.put("rsvTypeName", "문화");
		Map<String, Integer> searchRsvTypeSeq = basicReservationDAO.searchRsvTypeSeq(requestBox);
		
		/** 얻어온 체성분 키값 셋팅  */
		requestBox.put("typeseq", searchRsvTypeSeq.get("typeseq"));
		
		/** 해당 pp조회 */
		return expCultureDAO.expCulturePpRsvCodeList(requestBox);
	}

	@Override
	public List<Map<String, String>> expCultureYearMonth(RequestBox requestBox) throws Exception {
		return expCultureDAO.expCultureYearMonth(requestBox);
	}

	@Override
	public List<Map<String, String>> expCultureDayInfoList(RequestBox requestBox) throws Exception {
		return expCultureDAO.expCultureDayInfoList(requestBox);
	}

	@Override
	public List<Map<String, String>> expCultureProgramList(RequestBox requestBox) throws Exception {
		return expCultureDAO.expCultureProgramList(requestBox);
	}

	@Override
	public List<Map<String, String>> expCultureRsvRequest(RequestBox requestBox) throws Exception {
		/** 프로그램 정보를 담을 list */
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("typeSeq").size(); i++){
			
			HashMap<String, String> map = new HashMap<String, String>();
			
			map.put("typeSeq", (String) requestBox.getVector("typeSeq").get(i));
			map.put("ppSeq", (String) requestBox.getVector("ppSeq").get(i));
			map.put("ppName", (String) requestBox.getVector("ppName").get(i));
			map.put("expSeq", (String) requestBox.getVector("expSeq").get(i));
			map.put("expSessionSeq", (String) requestBox.getVector("expSessionSeq").get(i));
			map.put("reservationDate", (String) requestBox.getVector("reservationDate").get(i));
			map.put("standByNumber", (String) requestBox.getVector("standByNumber").get(i));
			map.put("paymentStatusCode", (String) requestBox.getVector("paymentStatusCode").get(i));
			map.put("productName", (String) requestBox.getVector("productName").get(i));
			map.put("krWeekDay", (String) requestBox.getVector("krWeekDay").get(i));
			map.put("startDateTime", (String) requestBox.getVector("startDateTime").get(i));
			map.put("endDateTime", (String) requestBox.getVector("endDateTime").get(i));
			map.put("account", (String) requestBox.get("account"));
			
			// expSeq 로 해당 프로그램의 참석 제한 인원 조회 seatCount
			requestBox.put("searchExpSeq", requestBox.getVector("expSeq").get(i));
			map.put("seatCount", (String) expCultureDAO.expCultureSeatCountSelect(requestBox));
			
			list.add(map);
		}
		
		return list;
	}

	@Override
	public List<Map<String, String>> expCultureRsvInsert(RequestBox requestBox) throws Exception {
		
		LOGGER.debug("invoke expCultureRsvInsert");
		LOGGER.debug("requestBox : {}", requestBox);
		
		Timestamp ts = new Timestamp(System.currentTimeMillis());
		String transactionTime = String.valueOf(ts.getTime());
		requestBox.put("transactionTime", transactionTime);

        LOGGER.debug("transactionTime", transactionTime);
        
		/** 프로그램 정보를 담을 list */
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();

		/** 선택한 프로그램별 신청 가능 여부를 체크 한다.
		 * */
		for(int i = 0; i < requestBox.getVector("tempTypeSeq").size(); i++){
			String paymentStatusCode = "";
			String standByNumber = "";
			
			/* 리턴 데이터 Map*/
			HashMap<String, String> map = new HashMap<String, String>(); 
			
			requestBox.put("typeSeq", (String) requestBox.getVector("tempTypeSeq").get(i));
			requestBox.put("ppSeq", (String) requestBox.getVector("tempPpSeq").get(i));
			requestBox.put("expSeq", (String) requestBox.getVector("tempExpSeq").get(i));
			requestBox.put("expSessionSeq", (String) requestBox.getVector("tempExpSessionSeq").get(i));
			requestBox.put("reservationDate", (String) requestBox.getVector("tempReservationDate").get(i));
			requestBox.put("paymentStatusCode", (String) requestBox.getVector("tempPaymentStatusCode").get(i));
			requestBox.put("visitNumber", (String) requestBox.getVector("tempVisitNumber").get(i));
			requestBox.put("startDateTime", (String) requestBox.getVector("tempStartDateTime").get(i));
			requestBox.put("endDateTime", (String) requestBox.getVector("tempEndDateTime").get(i));
			
			/* standbynumber = 0 이고 
			 * 남은 정원 >= 예약인원 0 
			 * 남은 정원 < 예약인원 0 */
			if("0".equals((String) requestBox.getVector("tempStandByNumber").get(i))){
				paymentStatusCode = (String) expCultureDAO.expCultureRsvPersonCheck(requestBox);
				
				if(null == paymentStatusCode){
					paymentStatusCode = "P01";
					standByNumber = "0";
				}
				
				/** 예약대기 및 예약완료 체크
				 * */
				if(paymentStatusCode.equals("P01")){
					standByNumber = "0";
				} else if(paymentStatusCode.equals("P02")){
					standByNumber = "1";
				} else {
					/* 예약마감이 존재 하는 경우 오류 */
					map.put("paymentStatusCode", paymentStatusCode);
					list.add(map);
					return list;
				}
				
				requestBox.put("standByNumber", standByNumber);
				map.put("paymentStatusCode", paymentStatusCode);
			} else {
				requestBox.put("standByNumber", (String) requestBox.getVector("tempStandByNumber").get(i));
				map.put("paymentStatusCode", (String) requestBox.getVector("tempPaymentStatusCode").get(i));
			}
			
			if(requestBox.get("account").equals("")){
				/* 비회원 예약 */
				requestBox.put("nonMember", (String) requestBox.get("nonMember"));
				requestBox.put("nonMemberId", (String) requestBox.get("nonMemberId1") + (String) requestBox.get("nonMemberId2") + (String) requestBox.get("nonMemberId3"));
				expCultureDAO.expCultureNonMemberRsvInsert(requestBox);
			}else{
				
				/* 회원 예약 */
				requestBox.put("account", (String) requestBox.get("account"));
				expCultureDAO.expCultureRsvInsert(requestBox);
				
			}
			
			map.put("visitNumber", (String) requestBox.getVector("tempVisitNumber").get(i));
			map.put("productName", (String) requestBox.getVector("tempProductName").get(i));
			map.put("startDateTime", (String) requestBox.getVector("tempStartDateTime").get(i));
			map.put("reservationDate", (String) requestBox.getVector("tempReservationDate").get(i));
			
			list.add(map);
			
			try {
				
				/*
				- account
				- aboName
				- ppName
				- roomName : x
				- sessionInfo
				- programName
				- reservationDate
				*/
				String sessionDateTime = (String) requestBox.getVector("reservationDate").get(i) 
						+ (String) requestBox.getVector("tempStartDateTime").get(i);
				
				sessionDateTime = DateUtil.getKoreanDateTime(sessionDateTime, "MDhm");
				
				map.put("ppName",      (String) requestBox.getVector("tempPpName").get(i) );
				map.put("roomName",    "");
				map.put("sessionInfo", sessionDateTime );
				map.put("programName", (String) requestBox.getVector("tempProductName").get(i) );
				map.put("standByNumber", standByNumber );
				
				if(requestBox.get("account").equals("")){

					/* 비회원 메세지 전송 */
					//map.put("aboName", StringUtil.nvl((String) requestBox.get("nonMember"),""));
					
					/** send message - push */
					//super.sendPushMessage(map, "expr", "reserv");
					
					/** send message - note */
					//super.sendNoteMessage(map, "expr", "reserv");
						
				} else {
					/* 회원 메세지 전송 */
					map.put("account", StringUtil.nvl((String) requestBox.get("account"),""));
					
					/** send message - push */
					super.sendPushMessage(map, "expr", "reserv");
					
					/** send message - note */
					super.sendNoteMessage(map, "expr", "reserv");
				}
			} catch (Exception e) {
				LOGGER.error(e.getMessage(), e);
			}
			
		}
		
		return list;
	}

	@Override
	public List<Map<String, String>> expCulturePpProgramList(RequestBox requestBox) throws Exception {
		return expCultureDAO.expCulturePpProgramList(requestBox);
	}

	@Override
	public List<Map<String, String>> expCultureSessionList(RequestBox requestBox) throws Exception {
		return expCultureDAO.expCultureSessionList(requestBox);
	}

	@Override
	public int expCultureInfoListCount(RequestBox requestBox) throws Exception {
		return expCultureDAO.expCultureInfoListCount(requestBox);
	}

	@Override
	public List<Map<String, String>> expCultureInfoList(RequestBox requestBox) throws Exception {
		return expCultureDAO.expCultureInfoList(requestBox);
	}

	@Override
	public String expCultureSeatCountSelect(RequestBox requestBox) throws Exception {
		return expCultureDAO.expCultureSeatCountSelect(requestBox);
	}

	@Override
	public int expCultureVisitNumberUpdate(RequestBox requestBox) throws Exception {
		return expCultureDAO.expCultureVisitNumberUpdate(requestBox);
	}

	@Override
	public int expCultureCancelUpdate(RequestBox requestBox) throws Exception {
		
		final int ONE = 1;
		
		// rsvSeq 로 예약 대기인지 확인  
		if(ONE == expCultureDAO.searchStandByNumberCheck(requestBox)){
			// standbynumber == 1 이면 delete
			expCultureDAO.deleteExpCultureReservation(requestBox);
		}else{
			// standbynumber == 0 이고
			if(!requestBox.get("account").equals("")){
				// 회원이면
				// 패널티 조회 select
				List<Map<String, String>> searchPenaltyList = expCultureDAO.searchExpCulturePenaltyList(requestBox);
				Map<String, String> penaltyInfo;
				for(int i = 0; i < searchPenaltyList.size(); i++){
					penaltyInfo = new HashMap<String, String>();
					
					penaltyInfo.put("account", requestBox.get("account"));
					penaltyInfo.put("rsvseq", requestBox.get("rsvseq"));
					penaltyInfo.put("penaltyseq", String.valueOf(searchPenaltyList.get(i).get("penaltyseq")));
					penaltyInfo.put("reason", searchPenaltyList.get(i).get("typecode"));
					penaltyInfo.put("applytypecode", searchPenaltyList.get(i).get("applytypecode"));
					penaltyInfo.put("applytypevalue", searchPenaltyList.get(i).get("applytypevalue"));
					
					expCultureDAO.insertExpCulturePenaltyHistory(penaltyInfo);
					
				}
				// 패널티 부여 insert
				
			}
			// 예약정보 취소 부여
			expCultureDAO.updateExpCultureCancelCodeAjax(requestBox);
			
			//rsvseq로 동일 날짜의 동일 expsessionseq 가 standbynumber 1이 존재 하는경우 조회된 예약정보의 standbynumber를 0으로 업데이트
			Map<String, String> expWaitingInfo = expCultureDAO.selectExpWaitingInfo(requestBox);
			if(expWaitingInfo != null){
				requestBox.put("rsvseq", expWaitingInfo.get("rsvseq"));
				expCultureDAO.updateExpWaitingInfo(requestBox);
			}
		}
		
		return 0;
	}

	@Override
	public List<Map<String, String>> expCultureNonmemberIdCheckForm(RequestBox requestBox) throws Exception {
		/** 프로그램 정보를 담을 list */
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("tempTypeSeq").size(); i++){
			
			HashMap<String, String> map = new HashMap<String, String>();
			
			map.put("tempTypeSeq", (String) requestBox.getVector("tempTypeSeq").get(i));
			map.put("tempPpSeq", (String) requestBox.getVector("tempPpSeq").get(i));
			map.put("tempPpName", (String) requestBox.getVector("tempPpName").get(i));
			map.put("tempExpSeq", (String) requestBox.getVector("tempExpSeq").get(i));
			map.put("tempExpSessionSeq", (String) requestBox.getVector("tempExpSessionSeq").get(i));
			map.put("tempReservationDate", (String) requestBox.getVector("tempReservationDate").get(i));
			map.put("tempStandByNumber", (String) requestBox.getVector("tempStandByNumber").get(i));
			map.put("tempPaymentStatusCode", (String) requestBox.getVector("tempPaymentStatusCode").get(i));
			map.put("tempProductName", (String) requestBox.getVector("tempProductName").get(i));
			map.put("tempStartDateTime", (String) requestBox.getVector("tempStartDateTime").get(i));
			map.put("tempEndDateTime", (String) requestBox.getVector("tempEndDateTime").get(i));
			map.put("tempVisitNumber", (String) requestBox.getVector("tempVisitNumber").get(i));
			map.put("tempParentFlag", (String) requestBox.get("tempParentFlag"));
			map.put("tempKrWeekDay", (String) requestBox.get("tempKrWeekDay"));
			
			list.add(map);
		}
		
		return list;
	}
	
	@Override
	public List<Map<String, String>> expCultureIntroduceList(RequestBox requestBox) throws Exception {
		return expCultureDAO.expCultureIntroduceList(requestBox);
	}

	@Override
	public Map<String, String> expCultureToday() throws Exception {
		return expCultureDAO.expCultureToday();
	}

	@Override
	public List<Map<String, String>> expCultureInfoListMobile(RequestBox requestBox) throws Exception {
		return expCultureDAO.expCultureInfoListMobile(requestBox);
	}

	@Override
	public Map<String, String> expCultureAuthenticationNumberSend(RequestBox requestBox, HttpServletRequest request) throws Exception {
		
		Random random = new Random();
        
		int result = random.nextInt(1000000)+100000;
		 
		if(result > 1000000){
		    result = result - 100000;
		}
		
		requestBox.put("content", "[암웨이코리아] 휴대폰 인증번호 ["+result+"]");
		requestBox.put("nonMemberId", requestBox.get("nonMemberId1") + "-" + requestBox.get("nonMemberId2") + "-" + requestBox.get("nonMemberId3"));
		
		// localhost에서 DB연결이 안됨
		String requestUrl = request.getRequestURL().toString();  
		if( 0 > requestUrl.indexOf("localhost") ){
			expCultureDAO.expCultureAuthenticationNumberSend(requestBox);
		}
		
		requestBox.put("nonMemberId", requestBox.get("nonMemberId1") + requestBox.get("nonMemberId2") + requestBox.get("nonMemberId3"));
		requestBox.put("certNumber", result);
		expCultureDAO.expCultureAuthenticationNumberInsert(requestBox);
		
		Map<String, String> returnMap = new HashMap<String, String>();
		
		returnMap.put("certNumber", Integer.toString(result));
		returnMap.put("nonMember", requestBox.get("nonMember"));
		returnMap.put("nonMemberId", requestBox.get("nonMemberId"));
		
		return returnMap;
		
	}

	@Override
	public Map<String, String> expCultureAuthenticationNumberCheck(RequestBox requestBox) throws Exception {
		
		Map<String, String> returnMapObject = new HashMap<String, String>();
		
		/*인증번호 6자리 체크*/
		
		/* 입력시간 초과 체크 */
		if(!this.expCultureTimeCheck(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.smsAuthentication.expCultureTimeCheck"));
			return returnMapObject;
		}
		
		/* 인증번호 체크 */
		if(!this.expCultureNumberCheck(requestBox)){
			returnMapObject.put("possibility", "false");
			returnMapObject.put("reason", messageSource.getMessage("rsv.smsAuthentication.expCultureNumberCheck"));
			return returnMapObject;
		}
		
		returnMapObject.put("possibility", "true");
		
		return returnMapObject;
	}
	
	/**
	 * 입력시간 초과 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Boolean expCultureTimeCheck(RequestBox requestBox) throws Exception {
		
		Boolean ret = null;
		
		ret = expCultureDAO.expCultureTimeCheck(requestBox);
		
		if(null != ret && ret){
			return true;
		}else{
			return false;
		}
		
	}
	
	/**
	 * 인증번호 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Boolean expCultureNumberCheck(RequestBox requestBox) throws Exception {
		
		Boolean ret = null;
		
		ret = expCultureDAO.expCultureNumberCheck(requestBox);
		
		if(null != ret && ret){
			return true;
		}else{
			return false;
		}
		
	}

	@Override
	public List<Map<String, String>> expCultureNonmemberComplete(RequestBox requestBox) throws Exception {
		
		/** 프로그램 정보를 담을 list */
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("tempTypeSeq").size(); i++){
			
			HashMap<String, String> map = new HashMap<String, String>();
			
			map.put("visitNumber", (String) requestBox.getVector("tempVisitNumber").get(i));
			map.put("productName", (String) requestBox.getVector("tempProductName").get(i));
			map.put("startDateTime", (String) requestBox.getVector("tempStartDateTime").get(i));
			map.put("paymentStatusCode", (String) requestBox.getVector("tempPaymentStatusCode").get(i));
			map.put("reservationDate", (String) requestBox.getVector("tempReservationDate").get(i));
			map.put("krWeekDay", (String) requestBox.getVector("tempKrWeekDay").get(i));
			map.put("ppName", (String) requestBox.getVector("tempPpName").get(i));
			
			list.add(map);
		}
		
		return list;
	}

	@Override
	public List<Map<String, String>> expCultureDuplicateCheck(RequestBox requestBox) throws Exception {
		
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		for(int i = 0; i < requestBox.getVector("reservationDate").size(); i++){
			
			requestBox.put("tempReservationDate", requestBox.getVector("reservationDate").get(i));
			requestBox.put("tempExpSessionSeq", requestBox.getVector("expSessionSeq").get(i));
			requestBox.put("tempStandByNumber", requestBox.getVector("standByNumber").get(i));
			
			Map<String, String> map = basicReservationDAO.expDuplicateExceptCheck(requestBox);
			
			if(map != null){
				list.add(map);
			}
			
		}
		
		return list;
	}

	@Override
	public List<Map<String, String>> expCultureDisablePop(RequestBox requestBox) throws Exception {
		
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
	public Map<String, String> expCultureStandByNumberAdvanceChecked(RequestBox requestBox) throws Exception {
		Map<String, String> expStandByNumber = new HashMap<String, String>();
		
		for(int i = 0; i < requestBox.getVector("tempTypeSeq").size(); i++){
			
			requestBox.put("expSessionSeq", (String) requestBox.getVector("tempExpSessionSeq").get(i));
			requestBox.put("reservationDate", (String) requestBox.getVector("tempReservationDate").get(i));
			requestBox.put("standByNumber", (String) requestBox.getVector("tempStandByNumber").get(i));
		
			//해당일, 해당 세션시간, 대기자 여부에 따른 대기자 조회
			expStandByNumber =  expCultureDAO.expCultureStandByNumberAdvanceChecked(requestBox);
			
			//먼저 선점 한 사람이 있다면  return false
			if("false".equals(expStandByNumber.get("standbynumber"))){
				expStandByNumber.put("msg", "false");
				expStandByNumber.put("reason", messageSource.getMessage("rsv.reservationCondition.anotherReservation")); //예약 불가 메세지
				
				return expStandByNumber;
			}else{
				expStandByNumber.put("msg", "true");
			}
		}
		
		return expStandByNumber;
	}
	
}
