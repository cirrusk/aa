package amway.com.academy.reservation.basicPackage.service.impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSessionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import amway.com.academy.common.push.PushSend;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import framework.com.cmm.FWMessageSource;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.DateUtil;
import framework.com.cmm.util.StringUtil;

/**
 * <pre>
 * </pre>
 * Program Name  : CommonService.java
 * Author : KR620207
 * Creation Date : 2016. 9. 7.
 */
public abstract class CommonReservationService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonReservationService.class);

	@Resource(name="egovMessageSource")
	private FWMessageSource messageSource;

	@Autowired
	private PushSend pushSend;

	@Autowired
	private BasicReservationMapper basicReservationMapper;
	
	@Autowired
	private ReservationPurchaseMapper reservationPurchaseMapper;

	
	/**
	 * <pre>
	 * 카드 추적번호 증가후 획득
	 * - 80만번 이상이면 70만번으로 초기화
	 * </pre>
	 * @return
	 */
	public String getCurrentCardTraceNumber() throws Exception {

		int cardTraceNumber = 0;
	/*
		int cutLineCardTraceNumber = 800000;
		
		reservationPurchaseMapper.increaseCardTraceNumber();
		cardTraceNumber = reservationPurchaseMapper.getCurrentCardTraceNumber();
		if (cardTraceNumber >= cutLineCardTraceNumber){ 
			reservationPurchaseMapper.resetCardTraceNumber();
			cardTraceNumber = reservationPurchaseMapper.getCurrentCardTraceNumber();
		}
	*/
		cardTraceNumber = reservationPurchaseMapper.getCurrentCardTraceNumber();
		return String.valueOf(cardTraceNumber);
	}
	
	
	/**
	 * 예약정보 확인 버튼 클릭시, 넘겨받는 PARAMETER 정리
	 * @param requestBox
	 * @param isWithCardInfo
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomPaymentInfo(RequestBox requestBox, boolean isWithCardInfo)
			throws Exception {

		/** 시설 정보를 담을 list */
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		try{
			
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
				map.put("cookMasterCode", (String) requestBox.getVector("cookMasterCode").get(i));
				map.put("standByNumber", (String) requestBox.getVector("standByNumber").get(i));
				map.put("paymentStatusCode", (String) requestBox.getVector("paymentStatusCode").get(i));
				
				/* 카드정보 포함시 : 일반결재시 카드정보 포함, 안심결제시 카드정보 미포함 */
				if(isWithCardInfo){
					
					map.put("bankid", (String) requestBox.getVector("bankid").get(0));
					map.put("paymentmode", (String) requestBox.getVector("paymentmode").get(0));
					map.put("cardowner", (String) requestBox.getVector("cardowner").get(0));
					map.put("cardnumber1", (String) requestBox.getVector("cardnumber1").get(0));
					map.put("cardnumber2", (String) requestBox.getVector("cardnumber2").get(0));
					map.put("cardnumber3", (String) requestBox.getVector("cardnumber3").get(0));
					map.put("cardnumber4", (String) requestBox.getVector("cardnumber4").get(0));
					map.put("cardmonth", (String) requestBox.getVector("cardmonth").get(0));
					map.put("cardyear", (String) requestBox.getVector("cardyear").get(0));
					map.put("cardpassword", (String) requestBox.getVector("cardpassword").get(0));
					map.put("einstallment", (String) requestBox.getVector("einstallment").get(0));
					map.put("ninstallment", (String) requestBox.getVector("ninstallment").get(0));
					map.put("birthday", (String) requestBox.getVector("birthday").get(0));
					map.put("biznumber", (String) requestBox.getVector("biznumber").get(0));
					
				}
				
				list.add(map);
			}
			
		}catch(SqlSessionException e){
			LOGGER.error(e.getMessage(), e);
		}
		
		return list;
	}
	
	/**
	 * 메세지 (push, notice) 처리를 위한 조회 : 예약 seq로 조회
	 * @param messageMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> getSendMessageRoomBySeq(Map messageMap) throws Exception {
		return basicReservationMapper.getSendMessageRoomBySeq(messageMap);
	}
	
	public Map<String, String> getSendMessageExpBySeq(Map messageMap) throws Exception {
		return basicReservationMapper.getSendMessageExpBySeq(messageMap);
	}
	
	/**
	 * <pre>
	 * 	예약 등록 처리
	 *    - 1. 사용자예약정보 테이블 데이터 입력
	 *    - 2. 결제진행 이력정보 테이블 데이터 입력
	 *    - 3. 주문정보관리 테이블 데이터 입력
	 *        > 
	 *        > 결제 API 호출 후 invoiceQueue 번호를 리턴 받은 후 RSVPURCHASEINFO 테이블에 최종 입력한다.
	 * </pre>
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> roomReservationInsert(RequestBox requestBox) throws Exception {
		LOGGER.debug("invoke roomReservationInsert");
		
		/** 시설 정보를 담을 list */
		ArrayList<Map<String, String>> list = new ArrayList<Map<String,String>>();
		
		String interfaceChannel = (String) requestBox.get("interfaceChannel");
		String paymentmode = (String) requestBox.get("paymentmode");
		
		Timestamp ts = new Timestamp(System.currentTimeMillis());
		String transactionTime = String.valueOf(ts.getTime());
		requestBox.put("transactionTime", transactionTime);
		
		LOGGER.debug("transactionTime", transactionTime);
		LOGGER.debug("interfaceChannel : {}", interfaceChannel);
		LOGGER.debug("typeseq.size : {}", requestBox.getVector("typeseq").size());
		LOGGER.debug("requestBox : {}", requestBox);
		
		for(int i = 0; i < requestBox.getVector("typeseq").size(); i++){
			
			LOGGER.debug("typeseq i : {}", i);
			
			HashMap<String, String> map = new HashMap<String, String>();
			
			/* normal or easypay : defferent parameter little bit */
 			if("MOBILE".equals(interfaceChannel)) {
 				map.put("account", (String) requestBox.get("account"));
 				map.put("typeSeq", (String) requestBox.getVector("typeseq").get(i));
 				map.put("roomSeq", (String) requestBox.getVector("roomseq").get(i));
 				map.put("reservationDate", (String) requestBox.getVector("reservationDate").get(i));
 				map.put("rsvSessionSeq", (String) requestBox.getVector("rsvSessionSeq").get(i));
 				map.put("startDateTime", (String) requestBox.getVector("startDateTime").get(i));
 				map.put("endDateTime", (String) requestBox.getVector("endDateTime").get(i));
 				map.put("price", (String) requestBox.getVector("price").get(i));
 				map.put("ppSeq", (String) requestBox.getVector("ppSeq").get(i));
 				map.put("cookMasterCode", (String) requestBox.getVector("cookMasterCode").get(i));
 				map.put("standByNumber", (String) requestBox.getVector("standByNumber").get(i));
 				map.put("paymentStatusCode", (String) requestBox.getVector("paymentStatusCode").get(i));
 			} else {
 				map.put("account", (String) requestBox.get("account"));
 				map.put("typeSeq", (String) requestBox.getVector("typeseq").get(i));
 				map.put("roomSeq", (String) requestBox.getVector("roomseq").get(i));
 				map.put("reservationDate", (String) requestBox.getVector("reservationdate").get(i));
 				map.put("rsvSessionSeq", (String) requestBox.getVector("rsvsessionseq").get(i));
 				map.put("startDateTime", (String) requestBox.getVector("startdatetime").get(i));
 				map.put("endDateTime", (String) requestBox.getVector("enddatetime").get(i));
 				map.put("price", (String) requestBox.getVector("price").get(i));
 				map.put("ppSeq", (String) requestBox.getVector("ppseq").get(i));
 				map.put("cookMasterCode", (String) requestBox.getVector("cookmastercode").get(i));
 				map.put("standByNumber", (String) requestBox.getVector("standbynumber").get(i));
 				map.put("paymentStatusCode", (String) requestBox.getVector("paymentstatuscode").get(i));
 			}
 			
 			map.put("transactionTime", transactionTime);
 			
 			LOGGER.debug("end of loop");
			
			/** 시설 예약 등록 */
			//roomEduDAO.roomEduReservationInsert(map);
			reservationPurchaseMapper.roomReservationInsert(map);
			
			LOGGER.debug("totalPrice : {}", Integer.parseInt(requestBox.get("totalPrice")));
			/** 총 금액이 0이 아닐경우에만 결제이력과 주문정보 등록 */
			if(0 != Integer.parseInt(requestBox.get("totalPrice"))){
			
				map.put("bankid", (String) requestBox.get("bankid"));
				map.put("bankname", (String) requestBox.get("bankname"));
				
				/** 시설 결제 이력정보 등록 */
				//roomEduDAO.roomEduPayMentInsert(map);
				reservationPurchaseMapper.roomPaymentInsert(map);
	
				String invoiceQueue = null;
				String responseTimestamp = null;
				String productCode = null;
				String cardTraceNumber = null;
				String orderAmount = null;
				
				LOGGER.debug("invoiceQueue : ", requestBox.getVector("invoiceQueue"));
				LOGGER.debug("responseTimestamp : ", requestBox.getVector("responseTimestamp"));
				
				/** 주문정보 등록 */
				if(null != requestBox.getVector("invoiceQueue")){
					
					invoiceQueue = (String) requestBox.getVector("invoiceQueue").get(0);
					responseTimestamp = (String) requestBox.getVector("responseTimestamp").get(0);
					productCode = (String) requestBox.getVector("productCode").get(0);
					
					orderAmount = requestBox.getString("orderAmount");
					cardTraceNumber = (String) requestBox.get("cardtracenumber"); /* 주의 : lowercase */
					
					map.put("cardtracenumber", cardTraceNumber);
					map.put("virtualpurchasenumber", invoiceQueue);
					map.put("sku", productCode);
					map.put("price", orderAmount);
					map.put("virtualdatetime", responseTimestamp);
					map.put("insertuser", (String) requestBox.get("account"));
					
					//map.put("regularpurchasenumber", "");
					//map.put("regulardatetime","");
					
					if ( 0 == reservationPurchaseMapper.selectRoomPurchase(map)) {
						reservationPurchaseMapper.roomPurchaseInsert(map);
					}
					
					LOGGER.debug("roomPurchaseInsert Inserted");
				}
			}
			
			list.add(map);
			
			try {

				Map<String, String> messageMap = new HashMap<String, String>();
				
				String sessionDateTime = (String) map.get("reservationDate") + (String) map.get("startDateTime");
				
				sessionDateTime = DateUtil.getKoreanDateTime(sessionDateTime, "MD");
				
				/* create message from db */
				messageMap.put("rsvSessionSeq", (String) map.get("rsvSessionSeq"));
				messageMap = basicReservationMapper.getSendMessage(messageMap);
				messageMap.put("account", map.get("account"));
				messageMap.put("programName", "");
				messageMap.put("reservationDate", (String) map.get("reservationDate"));
				messageMap.put("reservationDateKor", sessionDateTime);
				
				if( "P01".equals(map.get("paymentStatusCode") )) {
					messageMap.put("standByNumber", "1");	
				} else {
					messageMap.put("standByNumber", "0");
				}
				
				/** send message - push */
				this.sendPushMessage(messageMap, "room", "reserv");
				
				/** send message - note */
				this.sendNoteMessage(messageMap, "room", "reserv");
				
			} catch (Exception e) {
				LOGGER.error(e.getMessage(), e);
			}
		}
		
		return list;		
	}
	
	/**
	 * <pre>
	 * KICC 결제 이후 조회 하는 화면 중 첫번째 상자에 노출되는 내용
	 * 
	 * </pre>
	 * @param virtualPurchaseNumber
	 * @return
	 * @throws Exception
	 */
	public EgovMap selectReservationInfoStepOneByVirtualNumber(String virtualPurchaseNumber) throws Exception {
		
		RequestBox requestBox = new RequestBox("kicc");
		requestBox.put("virtualPurchaseNumber", virtualPurchaseNumber);
		
		return reservationPurchaseMapper.selectKiccCompleteStep1(requestBox);
	}
	
	/**
	 * <pre>
	 * KICC 결제 이후 조회 하는 화면 중 두번째 상자에 노출되는 내용
	 * </pre>
	 * @param virtualPurchaseNumber
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> selectReservationInfoStepTwoByVirtualNumber(String virtualPurchaseNumber) throws Exception {
		
		RequestBox requestBox = new RequestBox("kicc");
		requestBox.put("virtualPurchaseNumber", virtualPurchaseNumber);
		
		return reservationPurchaseMapper.selectKiccCompleteStep2(requestBox);
	}
	
	/**
	 * <pre>
	 * KICC 결제 이후 조회 하는 화면 중 세번째 상자에 노출되는 내용
	 * </pre>
	 * @param virtualPurchaseNumber
	 * @return
	 * @throws Exception
	 */
	public EgovMap selectReservationInfoStepThreeByVirtualNumber(String virtualPurchaseNumber) throws Exception {
		
		RequestBox requestBox = new RequestBox("kicc");
		requestBox.put("virtualPurchaseNumber", virtualPurchaseNumber);
		
		return reservationPurchaseMapper.selectKiccCompleteStep3(requestBox);
	}
	
	/**
	 * <pre>
	 * PUSH 메세지 호출
	 * >> message-reservation.properties
	 * 
	 * requestBox
	 *     - abo
	 *     - aboName
	 *     - ppName
	 *     - roomName
	 *     - sessionInfo
	 *     - programName
	 *     
	 * serviceType :
	 *     - room : 시설
	 *     - expr : 체험
	 *     - chck : 측정
	 *     
	 * alertType :
	 *     - reserv : 예약안내
	 *     - cancel : 취소안내
	 *     - remind : 리마인드
	 * </pre>
	 * @param requestBox
	 * @param serviceType
	 * @param alertType
	 * @throws Exception
	 */
	public void sendPushMessage(Map requestMap, String serviceType, String alertType) throws Exception {
		
		LOGGER.debug("invoke sendPushMessage");
		LOGGER.debug("requestBox  : {}", requestMap);
		LOGGER.debug("serviceType : {}", serviceType);
		LOGGER.debug("alertType   : {}", alertType);
		LOGGER.debug("standByNumber   : {}", requestMap.get("standByNumber"));
		
		String pushTit = ""; 
		String pushMsg = "";
		String pushUrl = "";
		
		String [] message = new String[10];
		message[0] = StringUtil.nvl( (String) requestMap.get("account"), "");
		message[1] = StringUtil.nvl( (String) requestMap.get("aboName"), "");
		message[2] = StringUtil.nvl( (String) requestMap.get("ppName"), "");
		message[3] = StringUtil.nvl( (String) requestMap.get("roomName"), "");
		message[4] = StringUtil.nvl( (String) requestMap.get("programName"), "");
		message[5] = StringUtil.nvl( (String) requestMap.get("reservationDate"), "");
		message[6] = DateUtil.getKoreanDate( (String) requestMap.get("reservationDate"), "MD");
		message[7] = StringUtil.nvl( (String) requestMap.get("session"), "");
		message[8] = StringUtil.nvl( (String) requestMap.get("sessionTime"), "");
		message[9] = StringUtil.nvl( (String) requestMap.get("sessionInfo"), "");
		
		
		String [] pushMessage = new String[4];
		
		switch(serviceType){

			case "room" :
				
				pushMessage[0] = message[0];	// account
				pushMessage[1] = message[2];	// ppName
				pushMessage[2] = message[3];	// roomName
				pushMessage[3] = message[9];	// 세션 + 세션시간 
				
				if ("reserv".equals(alertType)) {
					pushTit = messageSource.getMessage("rsv.push.roomComplete.title");
					pushMsg = messageSource.getMessage("rsv.push.roomComplete.message", pushMessage);
					
				}else if ("cancel".equals(alertType)) {
					pushTit = messageSource.getMessage("rsv.push.roomCancel.title");
					pushMsg = messageSource.getMessage("rsv.push.roomCancel.message", pushMessage);
					
				}else if ("remind".equals(alertType)) {
					pushTit = messageSource.getMessage("rsv.push.roomRemind.title");
					pushMsg = messageSource.getMessage("rsv.push.roomRemind.message", pushMessage);
				}
				
				pushUrl = "weblink|/reservation/roomInfoList/";
					
				break;
				
			case "expr" :
				
				pushMessage[0] = message[0];	// account
				pushMessage[1] = message[2];	// ppName
				pushMessage[2] = message[9];	// sessionInfo
				pushMessage[3] = message[4];	// programName
				
				if ("reserv".equals(alertType)) {
					pushTit = messageSource.getMessage("rsv.push.expComplete.title");
					pushMsg = messageSource.getMessage("rsv.push.expComplete.message", pushMessage);
					
				}else if ("cancel".equals(alertType)) {
					pushTit = "";
					pushMsg = "";
					
				}else if ("remind".equals(alertType)) {
					pushTit = messageSource.getMessage("rsv.push.expRemind.title");
					pushMsg = messageSource.getMessage("rsv.push.expRemind.message", pushMessage);
				}

				pushUrl = "weblink|/reservation/expInfoList/";
				
				break;
				
			case "chck" :
				
				pushMessage[0] = message[0];	// account
				pushMessage[1] = message[2];	// ppName
				pushMessage[2] = message[9];	// sessionInfo
				pushMessage[3] = message[4];	// programName
				
				if ("reserv".equals(alertType)) {
					pushTit = messageSource.getMessage("rsv.push.chkComplete.title");
					pushMsg = messageSource.getMessage("rsv.push.chkComplete.message", pushMessage);
					
				}else if ("cancel".equals(alertType)) {
					pushTit = "";
					pushMsg = "";
					
				}else if ("remind".equals(alertType)) {
					pushTit = messageSource.getMessage("rsv.push.chkRemind.title");
					pushMsg = messageSource.getMessage("rsv.push.chkRemind.message", pushMessage);
				}
					
				pushUrl = "weblink|/reservation/expInfoList/";
				
				break;
				
			default :
				break;
		}
		
		if(requestMap.get("standByNumber").equals("0")) {
			RequestBox requestBox = new RequestBox("message");
			
			requestBox.put("pushTitle",    pushTit);
			requestBox.put("pushMsg",      pushMsg);
			requestBox.put("pushUrl",      pushUrl);
			requestBox.put("pushUserId",   message[0]);
			requestBox.put("pushCategory", "ACADEMY");
			
			LOGGER.debug("requestBox : {}", requestBox);
			
			DataBox resultBox = pushSend.sendPushByUser(requestBox);
			LOGGER.debug("result push message : {}", resultBox.getString("status") );
		} else {
			LOGGER.debug("result push message : {}", "대기자 미발송" );
		}
	}
	
	/**
	 * <pre>
	 * 맞춤 쪽지 메세지 호출
	 * >> message-reservation.properties
	 * 
	 * requestBox
	 *      - abo
	 * 		- aboName : 수신 대상자 명
	 * 		- ppName
	 *      - roomName
	 *      - sessionInfo
	 *      - programName
	 *      - reservationDate
	 * 		- senddate : 노출일시 (datetime) - 'now' 라는 문자열 값을 설정하면 현재시간에 송신한다.
	 * 
	 * serviceType :
	 *     - room : 시설
	 *     - expr : 체험
	 *     - chck : 측정
	 *     
	 * alertType :
	 *     - reserv : 예약안내
	 *     - cancel : 취소안내
	 *     - remind : 리마인드 
	 * 
	 * </pre>
	 * @param requestBox
	 * @param serviceType
	 * @param alertType
	 * @throws Exception
	 */
	public void sendNoteMessage(Map requestMap, String serviceType, String alertType) throws Exception {

		LOGGER.debug("invoke sendNoteMessage");
		LOGGER.debug("requestBox  : {}", requestMap);
		LOGGER.debug("serviceType : {}", serviceType);
		LOGGER.debug("alertType   : {}", alertType);
		LOGGER.debug("standByNumber   : {}", requestMap.get("standByNumber"));

		String noteSrvc = "";
		
		String noteItem = "";
		String noteCont = "";
		
		String remindTitle = "";
		String remindContent = "";
		String remindDate = "";
		String reservationDate = "";
		
		String [] message = new String[8];
		message[0] = StringUtil.nvl( (String) requestMap.get("account"), "");
		message[1] = StringUtil.nvl( (String) requestMap.get("aboName"), "");
		message[2] = StringUtil.nvl( (String) requestMap.get("ppName"), "");
		message[3] = StringUtil.nvl( (String) requestMap.get("roomName"), "");
		message[4] = StringUtil.nvl( (String) requestMap.get("sessionInfo"), "");
		message[5] = StringUtil.nvl( (String) requestMap.get("programName"), "");
		message[6] = StringUtil.nvl( (String) requestMap.get("reservationDate"), "");
		message[7] = StringUtil.nvl( (String) requestMap.get("reservationDateKor"), "");
		
		if( "".equals(message[1]) ) {
			RequestBox requestBox = new RequestBox("temp");
			requestBox.put("account", message[0]);
			message[1] = basicReservationMapper.getMemberNameByAbo(requestBox);
		}

		String [] pushMessage = new String[4];
		
		switch(serviceType){
		
			case "room" :
				
				noteSrvc = "2";
				pushMessage[0] = message[1];
				pushMessage[1] = message[7];
				pushMessage[2] = message[2];
				pushMessage[3] = message[4];
				
				if ("reserv".equals(alertType)) {
					noteItem = messageSource.getMessage("rsv.alert.roomComplete.title");
					noteCont = messageSource.getMessage("rsv.alert.roomComplete.message", pushMessage);

					/* remind */
					remindDate = "8day";
					remindTitle = messageSource.getMessage("rsv.alert.roomRemind.title");
					remindContent = messageSource.getMessage("rsv.alert.roomRemind.message", pushMessage);
					
				}else if ("cancel".equals(alertType)) {
					
					pushMessage[1] = DateUtil.getKoreanDate(message[6], "MD");
					noteItem = messageSource.getMessage("rsv.alert.roomCancel.title");
					noteCont = messageSource.getMessage("rsv.alert.roomCancel.message", pushMessage);
					
				}
					
				break;
				
			case "expr" :  // 체험
				
				noteSrvc = "2";
				pushMessage[0] = message[1];
				pushMessage[1] = message[2];
				pushMessage[2] = message[4];
				pushMessage[3] = message[5];
				
				if ("reserv".equals(alertType)) {
					noteItem = messageSource.getMessage("rsv.alert.expComplete.title");
					noteCont = messageSource.getMessage("rsv.alert.expComplete.message", pushMessage);
					
					/* remind */
					remindDate = "1day";
					remindTitle = messageSource.getMessage("rsv.alert.expRemind.title");
					remindContent = messageSource.getMessage("rsv.alert.expRemind.message", pushMessage);
					
				}else if ("cancel".equals(alertType)) {
					noteItem = messageSource.getMessage("rsv.alert.expCancel.title");
					noteCont = messageSource.getMessage("rsv.alert.expCancel.message", pushMessage);
					
				}
					
				break;
				
			case "chck" : // 측정
				
				noteSrvc = "2";
				pushMessage[0] = message[1];
				pushMessage[1] = message[2];
				pushMessage[2] = message[4];
				pushMessage[3] = message[5];

				if ("reserv".equals(alertType)) {
					
					/* before 3month - remind */
					remindDate = "3month";
					noteItem = messageSource.getMessage("rsv.alert.chkRemind.title");
					noteCont = messageSource.getMessage("rsv.alert.chkRemind.3month.message", pushMessage);
					
					Map<String, String> paramMap = new HashMap<String, String>();
					paramMap.put("noteservice", noteSrvc); // 1.LMS 2.비즈니스(교육비) 3.비즈니스(시설) 4.비즈니스(체험) 5.비즈니스(측정) -> ['1:아카데미' / '2:비즈니스' / '3:쇼핑']
					paramMap.put("name",        message[1]);
					paramMap.put("uid",         message[0]);
					paramMap.put("noteitem",    noteItem);
					paramMap.put("notecontent", noteCont);
					paramMap.put("senddate",    remindDate);
					paramMap.put("modifier",    message[0]);
					paramMap.put("registrant",  message[0]);
					
					reservationDate = message[6];
					
					paramMap.put("senddate",        remindDate);
					paramMap.put("reservationDate", reservationDate);
					
					int resultCount2 = basicReservationMapper.insertReservationNoteSend(paramMap);
					LOGGER.debug("result push message : {}", resultCount2 );
					
					
					/* remind */
					remindDate = "1day";
					remindTitle = messageSource.getMessage("rsv.alert.chkRemind.title");
					remindContent = messageSource.getMessage("rsv.alert.chkRemind.1day.message", pushMessage);
					
					/* now */
					noteItem = messageSource.getMessage("rsv.alert.chkComplete.title");
					if(-1 != message[5].indexOf("피부")){
						noteCont = messageSource.getMessage("rsv.alert.chkComplete.message1", pushMessage);
					}else{
						noteCont = messageSource.getMessage("rsv.alert.chkComplete.message2", pushMessage);
						
					}
					
				}else if ("cancel".equals(alertType)) {
					//noteItem = messageSource.getMessage("rsv.alert.chkCancel.title");
					//noteCont = messageSource.getMessage("rsv.alert.chkCancel.message", pushMessage);
					
				}
					
				break;
				
			default :
				break;
		}
		
		if(requestMap.get("standByNumber").equals("0")) {
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("noteservice", noteSrvc); // 1.LMS 2.비즈니스(교육비) 3.비즈니스(시설) 4.비즈니스(체험) 5.비즈니스(측정) -> ['1:아카데미' / '2:비즈니스' / '3:쇼핑']
			paramMap.put("name",        message[1]);
			paramMap.put("uid",         message[0]);
			paramMap.put("noteitem",    noteItem);
			paramMap.put("notecontent", noteCont);
			paramMap.put("senddate",    "now");
			paramMap.put("modifier",    message[0]);
			paramMap.put("registrant",  message[0]);
			
			int resultCount = basicReservationMapper.insertReservationNoteSend(paramMap);
			LOGGER.debug("result sendNoteMessage : {}", resultCount );
	
			if(!"".equals(remindDate)){
				
				reservationDate = message[6];
				
				paramMap.put("senddate",        remindDate);
				paramMap.put("reservationDate", reservationDate);
				paramMap.put("noteitem",        remindTitle);
				paramMap.put("notecontent",     remindContent);
				
				int resultCount2 = basicReservationMapper.insertReservationNoteSend(paramMap);
				LOGGER.debug("result sendNoteMessage : {}", resultCount2 );
			}
		} else {
			LOGGER.debug("result sendNoteMessage : {}", "대기자 미발송" );
		}
		
	}
	
}
