package amway.com.academy.manager.common.scheduler;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import amway.com.academy.manager.common.commoncode.service.impl.ManageCodeMapper;
import amway.com.academy.manager.common.push.PushSend;
import amway.com.academy.manager.common.util.CommomCodeUtil;
import amway.com.academy.manager.common.util.NavigationAPI;
import amway.com.academy.manager.reservation.expSubscriber.service.impl.ExpSubscriberMapper;
import amway.com.academy.manager.reservation.roomSubscriber.service.impl.RoomSubscriberMapper;
import amway.com.academy.manager.reservation.scheduler.service.impl.ReservationSchedulerMapper;
import framework.com.cmm.FWMessageSource;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Component
public class ReservationScheduler  {

	private static final Logger LOGGER = LoggerFactory.getLogger(ReservationScheduler.class);
	
	@Resource(name="egovMessageSource")
	private FWMessageSource messageSource;

	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	@Autowired
	private ReservationSchedulerMapper reservationSchedulerMapper;
	
	@Autowired
	private RoomSubscriberMapper roomSubscriberDAO;
	
	@Autowired
	private ExpSubscriberMapper expSubscriberDAO;
	
	@Autowired
	private PushSend pushSend;
	
	@Autowired
	private ManageCodeMapper manageCodeMapper;
	
	/**
	 * <pre>
	 * framework.properties 의 환경파일을 대상으로 value 획득
	 * </pre>
	 * @param propertyKey
	 * @return
	 * @throws Exception
	 */
	private String getSystemProperties(String propertyKey) throws Exception {
		
		String returnValue = "";
		
		String reName = "/config/props/framework.properties";
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties prop = new Properties();
		
		try( InputStream resourceStream = loader.getResourceAsStream(reName) ) {
            prop.load(resourceStream);
            returnValue = prop.getProperty(propertyKey);
		} catch( IOException e) {
			LOGGER.error(e.getMessage(), e);
		}
		
		return returnValue;
	}
	
	
	/**
	 * <pre>
	 * API-INTERFACE
	 * 가상번호를 통한 실주문번호 업데이트
	 * 매 5분 마다 수행되며, 10분 전까지의 주문번호들을 대상으로 한다. 
	 * </pre>
	 * @throws Exception
	 */
	@Scheduled(cron = "0 0/5 * * * *") // 5분 마다
	public void reservationRegularPurchaseNumberInsert() throws Exception {
		LOGGER.debug("invoke reservationRegularPurchaseNumberInsert");
		
		if( commonCodeUtil.getSchedulerUseYn() ){ // 스케줄러 실행 설정 된 서버만 실행한다.
			
			LOGGER.info("execute daily batch (every 5 minutes) : audit real purchase number from virtual purchase number");
			
			int virtualPurchaseNumberListCount = 0;
			RequestBox requestBox = new RequestBox("");
			
			/* 실주문번호 없는 주문내역 가상주문번호 select (현시간 기준 10분 이내) 
			 * TABLE RSVPURCHASEINFO
			 * COLUMN RSVSEQ, VIRTUALPURCHASENUMBER, REQUESTDATETIME */
			List<DataBox> virtualPurchaseNumberList = reservationSchedulerMapper.selectVirtualPurchaseNumber();
			
			/* 리스트 루프 돌리고 건 별 API호출 return받은 실 주문번호 update 
			 * TABLE RSVPURCHASEINFO 
			 * COLUMN RSVSEQ, VIRTUALPURCHASENUMBER, REGULARPURCHASENUMBER, REGULARDATETIME, UPDATEUSER, UPDATEDATE */
			if(!virtualPurchaseNumberList.isEmpty()){
				
				virtualPurchaseNumberListCount = virtualPurchaseNumberList.size();
				
				for(int i = 0; i < virtualPurchaseNumberListCount; i++){

					/* 실주문번호 요청 API 호출 */
					Map<String, String> realOrderNumber = null;
					
					/* returned invoice-code */
					String invoiceCode = "";
					String virtualCode = "";
					
					try {
						
						LOGGER.debug("invoiceCode {}", (String) virtualPurchaseNumberList.get(i).get("virtualpurchasenumber"));
						LOGGER.debug("update process {}", i + " / " + virtualPurchaseNumberList.size());
						
						virtualCode = (String) virtualPurchaseNumberList.get(i).get("virtualpurchasenumber");
						
						realOrderNumber = NavigationAPI.getInvoice((String) virtualPurchaseNumberList.get(i).get("requestdatetime"), virtualCode);
						invoiceCode = realOrderNumber.get("invoiceCode"); // 값을 받아 왔는지의 체크로만 사용
						
					} catch (Exception e) {
						LOGGER.error(e.getMessage(), e);
					}
					
					LOGGER.debug("realOrderNumber  : {}", realOrderNumber);
					LOGGER.debug("invoiceCode      : {}", invoiceCode);
					
					if(null != invoiceCode){
						
						/* update real purchase number */
						if (null != realOrderNumber) {
							requestBox.put("rsvseq", virtualPurchaseNumberList.get(i).get("rsvseq"));
							requestBox.put("regularpurchasenumber", realOrderNumber.get("invoiceCode"));
							
							reservationSchedulerMapper.updateRegularPurchaseNumber(requestBox);
							LOGGER.debug("successfully updated purchase number");
							
						} 	
						
					} else {
						
						/* 실-주문 번호를 받지 못했을때 처리 */
						try {
							/* send push & mail */
							//String availablePush = messageSource.getMessage("rsv.auditError.sms");
							//String availableMail = messageSource.getMessage("rsv.auditError.mail");
							String availablePush = this.getSystemProperties("rsv.auditError.sms");
							String availableMail = this.getSystemProperties("rsv.auditError.mail");
							
							String toId    = "SYSTEM";
							//String content = messageSource.getMessage("rsv.auditError.message", new String[]{ realOrderNumber.get("invoiceCode") });
							String content = this.getSystemProperties("rsv.auditError.message");
							content = content.replaceAll("__virtual-number__", virtualCode);
							
							String toName  = "관리자";
							//String toPhone = messageSource.getMessage("rsv.auditError.targetNumber");
							String toPhone = this.getSystemProperties("rsv.auditError.targetNumber");
							
							if("true".equals(availablePush)) {
								
								RequestBox messageBox = new RequestBox("push-message");
								messageBox.put("toId",    toId);	// 
								messageBox.put("content", content);	// 
								messageBox.put("toName",  toName);	// 
								messageBox.put("toPhone", toPhone);	// 
								
								LOGGER.debug("messageBox : {}", messageBox);
								manageCodeMapper.insertSmsMailQueue(messageBox);
								LOGGER.debug("successfully push message");
							}
							
							if("true".equals(availableMail)) {
								
								RequestBox messageBox = new RequestBox("mail-message");
								messageBox.put("toId",    toId);	// 
								messageBox.put("content", content);	// 
								messageBox.put("toName",  toName);	// 
								messageBox.put("toPhone", toPhone);	// 
								
								LOGGER.debug("messageBox : {}", messageBox);
								manageCodeMapper.insertSmsMailQueue(messageBox);
								LOGGER.debug("successfully send mail");
							}
							
						}catch(Exception e){
							LOGGER.error(e.getMessage(), e);
						}
					}
				}
			}
			
			LOGGER.info("execute daily batch (every 5 minutes) : complete {} cases", virtualPurchaseNumberListCount);
		}
		
	}
	
	/**
	 * <pre>
	 * 일일 배치 예약 사용 완료 처리
	 * 예약 대기자 삭제
	 * </pre>
	 * @throws Exception
	 */
	@Scheduled(cron = "0 1 0 * * *") // 매일 0시 1분
	public void lmsSchedulerOffLineNoteSend() throws Exception {
		
		if( commonCodeUtil.getSchedulerUseYn() ){ // 스케줄러 실행 설정 된 서버만 실행한다.
			
			LOGGER.info("execute daily batch : delete reservation waiting");
			
			/* 시설 예약자관리 사용완료 update */
			roomSubscriberDAO.beforSearchRoomPaymentStatuscodeUpdate();
			
			/* 측정/체험 예약자관리 사용완료 update */
			expSubscriberDAO.beforSearchExpPaymentStatuscodeUpdate();
			
			/* 예약 대기자 삭제 */
			reservationSchedulerMapper.beforeWatingReservationDelete();
			
			/* 비회원 휴대폰 인증 정보 삭제 */
			reservationSchedulerMapper.nonMemberCertInfoDelete();
			
			LOGGER.info("execute daily batch : complete");
		}
		
	}
	
	/**
	 * <pre>
	 * 예약전 x일 전에 push 알림 ( 맞춤 메세지는 프로그램 내에서 처리하고 있음 )
	 * </pre>
	 * @throws Exception
	 */
	//@Scheduled(cron = "0 0 17 * * *") // 매일 오후 5시
	@Scheduled(cron = "0 0 * * * *") // 1시간 마다 - 테스트
	public void reservationRemindNotificationPush() throws Exception {
		LOGGER.debug("invoke reservationRemindNotificationPush");
		LOGGER.debug("execute every pm 5h");

		if( commonCodeUtil.getSchedulerUseYn() ){ // 스케줄러 실행 설정 된 서버만 실행한다.
			
			LOGGER.info("execute daily batch : send push to booking information");
			
			String pushTitle = "예약 재안내";
			//String pushUrlRoom = "weblink|/reservation/roomInfoList";
			//String pushUrlExpr = "weblink|/reservation/expInfoList";
			String pushUrlRoom = "weblink|/business";
			String pushUrlExpr = "weblink|/business";

			
			/* 시설 */
			List<Map<String, String>> pushRoom = reservationSchedulerMapper.reservationRemindNotificationPushRoom();
			LOGGER.debug("# pushRoom {}", pushRoom);

			for(Map pushRoomMap : pushRoom){
				RequestBox requestBox = new RequestBox("pushRoomMap");
				
				requestBox.put("pushTitle", pushTitle);
				requestBox.put("pushMsg", pushRoomMap.get("pushMsg"));
				requestBox.put("pushUrl", pushUrlRoom);
				requestBox.put("pushCategory", "ACADEMY");
				requestBox.put("pushUserId", pushRoomMap.get("uid"));

				LOGGER.debug("requestBox : {}", requestBox);
				DataBox resultBox = pushSend.sendPushByUser(requestBox);
			}
			
			
			/* 체험 */
			List<Map<String, String>> exprRoom = reservationSchedulerMapper.reservationRemindNotificationPushExpr();
			LOGGER.debug("# exprRoom {}", exprRoom);
			
			for(Map pushExprMap : exprRoom){
				RequestBox requestBox = new RequestBox("pushRoomMap");
				
				requestBox.put("pushTitle", pushTitle);
				requestBox.put("pushMsg", pushExprMap.get("pushMsg"));
				requestBox.put("pushUrl", pushUrlExpr);
				requestBox.put("pushCategory", "ACADEMY");
				requestBox.put("pushUserId", pushExprMap.get("uid"));
				
				LOGGER.debug("requestBox : {}", requestBox);
				DataBox resultBox = pushSend.sendPushByUser(requestBox);
			}
			
			
			/* 피부측정*/
			List<Map<String, String>> chk1Room = reservationSchedulerMapper.reservationRemindNotificationPushChck1();
			LOGGER.debug("# chk1Room {}", chk1Room);
			
			for(Map pushChk1Map : chk1Room){
				RequestBox requestBox = new RequestBox("pushRoomMap");
				
				requestBox.put("pushTitle", pushTitle);
				requestBox.put("pushMsg", pushChk1Map.get("pushMsg"));
				requestBox.put("pushUrl", pushUrlExpr);
				requestBox.put("pushCategory", "ACADEMY");
				requestBox.put("pushUserId", pushChk1Map.get("uid"));
				
				LOGGER.debug("requestBox : {}", requestBox);
				DataBox resultBox = pushSend.sendPushByUser(requestBox);
			}
			
			
			/* 체성분 측정 */
			List<Map<String, String>> chk2Room = reservationSchedulerMapper.reservationRemindNotificationPushChck2();
			LOGGER.debug("# chk2Room {}", chk2Room);
			
			for(Map pushChk2rMap : chk2Room){
				RequestBox requestBox = new RequestBox("pushRoomMap");
				
				requestBox.put("pushTitle", pushTitle);
				requestBox.put("pushMsg", pushChk2rMap.get("pushMsg"));
				requestBox.put("pushUrl", pushUrlExpr);
				requestBox.put("pushCategory", "ACADEMY");
				requestBox.put("pushUserId", pushChk2rMap.get("uid"));
				
				LOGGER.debug("requestBox : {}", requestBox);
				DataBox resultBox = pushSend.sendPushByUser(requestBox);
			}
			
			LOGGER.info("execute daily batch : complete");
		}
		
	}
	
}