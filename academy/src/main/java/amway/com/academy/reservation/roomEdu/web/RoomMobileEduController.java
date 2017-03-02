package amway.com.academy.reservation.roomEdu.web;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.util.UtilAPI;
import amway.com.academy.reservation.basicPackage.service.BasicReservationService;
import amway.com.academy.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.reservation.roomEdu.service.RoomEduService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;


@RequestMapping("/mobile/reservation")
@Controller
public class RoomMobileEduController extends BasicReservationController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RoomMobileEduController.class);
	
	@Autowired
	private RoomEduService roomEduService;
	
	/** 공통 코드 서비스 */
	@Autowired
	private BasicReservationService basicReservationService;

	/**
	 * 교육장 예약 페이지 호출
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomEduForm.do")
	public String roomEduInsertForm(HttpServletRequest request, ModelMap model, RequestBox requestBox) throws Exception{
		
		LOGGER.debug("invoke roomEduForm#");
		
		try{

			Enumeration eNum = request.getHeaderNames();
			
			while(eNum.hasMoreElements()){
				String headerName = (String) eNum.nextElement();
				LOGGER.debug("----------------------------------------");
				LOGGER.debug("-headerName  : {}", headerName);
				LOGGER.debug("-headerValue : {}", request.getHeader(headerName));
			}
			
		}catch(Exception e) {
			LOGGER.error(e.getMessage(), e);
		}

		requestBox.put("account", requestBox.getSession("abono"));
		
		model.put("clause01", super.getClauseContentsRoleAgreement());
		model.put("clause02", super.getClauseContentsAttentionAgreement());
		model.put("clause03", super.getClauseContentsPurchaseAgreement());
		model.put("clause04", super.getClauseContentsPrivateAgreement());
		
		/* 시설 타입(형태)별 필수안내 */
		model.put("reservationInfo", super.getReservationInfoByType("교육장"));
		
		model.addAttribute("getMemberInformation", super.reservationCheckerService.getMemberInformation(requestBox));
		
		/** ----------------APinfo 정보--------------------------- */
		Map testAPI = UtilAPI.getApInfo();
		model.addAttribute("result", testAPI);
		
		//이미지 경로에 사용될 HybrisUrl
		String curerntHybrisLocation = UtilAPI.getCurerntHybrisLocation();
		model.addAttribute("curerntHybrisLocation", curerntHybrisLocation);
		/** --------------------------------------------------- */

		/* 카드사 정보 */
		model.addAttribute("bankInfo", UtilAPI.creditCardCompany());
		
		/* Hybris domain */
		model.addAttribute("hybrisDomain", UtilAPI.getCurerntHybrisLocation());
		
		/* API URL for only SNS */
		model.addAttribute("httpDomain", "www.abnkorea.co.kr");
		
		/* CURRENT SERVER URL (FOR EASY-PAY) */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return "/mobile/reservation/room/roomEdu";
	}

	/**
	 * sabn 어플에서 결제가 성공한 이후 처리되는 페이지 (결제 완료페이지)의 구성
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomEduReservOk.do")
	public String reservationComplete(HttpServletRequest request, ModelMap model, RequestBox requestBox) throws Exception {
		
		LOGGER.debug("invoke roomEduReservOk#");
		LOGGER.debug("requestBox {}", requestBox);
		
		try{

			Enumeration eNum = request.getHeaderNames();
			
			while(eNum.hasMoreElements()){
				String headerName = (String) eNum.nextElement();
				LOGGER.debug("----------------------------------------");
				LOGGER.debug("-headerName  : {}", headerName);
				LOGGER.debug("-headerValue : {}", request.getHeader(headerName));
			}
			
		}catch(Exception e) {
			LOGGER.error(e.getMessage(), e);
		}
		
		String virtualPurchaseNumber = requestBox.get("virtualNumber");
		//String resCode;
		//String resMsg;
		
		/* 시설 타입(형태)별 필수안내 */
		model.put("reservationInfo", super.getReservationInfoByType("교육장"));
		
		model.addAttribute("hybrisDomain", UtilAPI.getCurerntHybrisLocation());
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
		Map firstBox = basicReservationService.selectReservationInfoStepOneByVirtualNumber(virtualPurchaseNumber);
		List<?> secondBox = basicReservationService.selectReservationInfoStepTwoByVirtualNumber(virtualPurchaseNumber);
		Map thirdBox = basicReservationService.selectReservationInfoStepThreeByVirtualNumber(virtualPurchaseNumber);
		
		LOGGER.debug("firstBox : {}", firstBox);
		LOGGER.debug("secondBox : {}", secondBox);
		LOGGER.debug("thirdBox : {}", thirdBox);
		
		String ppName = (String) firstBox.get("ppName");
		String roomName = (String) firstBox.get("roomName");
		
		int reservationCount = secondBox.size();
		String totalAmount = (String) thirdBox.get("totalAmount");
		
		model.addAttribute("ppName", ppName);
		model.addAttribute("roomName", roomName);
		model.addAttribute("reservationCount", reservationCount);
		model.addAttribute("totalAmount", totalAmount);
		model.addAttribute("reservedInfo", secondBox);
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics

		return "/mobile/reservation/room/roomEduReservOk";
	}
	
	/**
	 * 교육장 예약 PP 목록 조회
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomEduPpInfoListAjax.do", method = RequestMethod.POST)
	public ModelAndView roomEduPpInfoListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 해당 pp조회  */
		List<Map<String, String>> ppRsvRoomCodeList = roomEduService.ppRsvRoomCodeList(requestBox);
		mav.addObject("ppRsvRoomCodeList", ppRsvRoomCodeList);
		
		/** 마지막으로 예약한 pp정보 조회 */
		Map<String, String> searchLastRsvRoomPp = roomEduService.searchLastRsvRoomPp(requestBox);
		mav.addObject("searchLastRsvRoomPp", searchLastRsvRoomPp);
		
		return mav;
	}
	
	/**
	 * 교육장 예약 해당 pp의 시설(룸) 목록 조회
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomEduRoomInfoListAjax.do", method = RequestMethod.POST)
	public ModelAndView roomEduRoomInfoListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 해당 pp 시설 목록 조회  */
		List<Map<String, String>> rsvRoomInfoList = roomEduService.rsvRoomInfoList(requestBox);
		mav.addObject("rsvRoomInfoList", rsvRoomInfoList);
		
		/** 마지막으로 예약한 pp정보 조회 */
		Map<String, String> searchLastRsvRoom = basicReservationService.searchLastRsvRoom(requestBox);
		mav.addObject("searchLastRsvRoom", searchLastRsvRoom);
		
		return mav;
	}
	
	/**
	 * 해당 시설의 정원, 이용시간, 예약자격, 부대시설 등을 조회
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomEduRsvRoomDetailInfoAjax.do", method = RequestMethod.POST)
	public ModelAndView roomEduRsvRoomDetailInfoAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		Map<String, String> roomEduRsvRoomDetailInfo = roomEduService.roomEduRsvRoomDetailInfo(requestBox);
		mav.addObject("roomEduRsvRoomDetailInfo", roomEduRsvRoomDetailInfo);
		
		return mav;
	}
	
	/**
	 * step2에 들어가는 날짜, 휴무일을 조회
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomEduCalendarAjax.do", method = RequestMethod.POST)
	public ModelAndView roomEduCalendarAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		
		/** 해당 월 달력 조회 */
		List<Map<String, String>> roomEduCalendar = roomEduService.roomEduCalendar(requestBox);
		mav.addObject("roomEduCalendar", roomEduCalendar);
		
//		/** 휴무일 조회 */
//		List<Map<String, String>> searchExpHealthHoilDayList = expHealthService.searchExpHealthHoilDay(requestBox);
//		mav.addObject("searchExpHealthHoilDayList", searchExpHealthHoilDayList);
//		
		/** 날짜별 예약 정보(남은예약카운트, 예약마감 유무, 휴무일) 조회 */
		List<Map<String, String>> roomEduReservationInfoList = roomEduService.roomEduReservationInfoList(requestBox);
		mav.addObject("roomEduReservationInfoList", roomEduReservationInfoList);

		/** 오늘 날짜 조회 */
		Map<String, String> roomEduToday = roomEduService.roomEduToday();
		mav.addObject("roomEduToday", roomEduToday);
		
		/** 년, 월  조회(jsp에서 클래스 명으로 사용)*/
		List<Map<String, String>> roomEduYearMonth = roomEduService.roomEduYearMonth(requestBox);
		mav.addObject("roomEduYearMonth", roomEduYearMonth);
		
		/** 파티션룸 체크 param-roomseq
		 * case1 파티션룸이 아님 (null)
		 * 	- 추가 조회 없음
		 * case2 합쳐진 파티션룸 (R1 + R2)
		 *  - RSVSAMEROOMINFO에서 해당 ROOMSEQ를 PARENTROOMSEQ로 갖고있는 시설들의 날짜별 예약정보 조회 
		 * case3 합쳐지지 않은 파티션룸 (R1, R2)
		 *  - PARENTROOMSEQ 로 날짜별 예약정보 조회
		 *  */
		
		List<Map<String, String>> partitionRoomSeqList = roomEduService.partitionRoomSeqList(requestBox);
		
		List<Map<String, String>> partitionRoomFirstRsvList = null;
		List<Map<String, String>> partitionRoomSecondRsvList = null;
		
		if(partitionRoomSeqList.isEmpty()){
			partitionRoomFirstRsvList = null;
		}else if(1 == partitionRoomSeqList.size()){
			requestBox.put("roomseq", partitionRoomSeqList.get(0).get("roomseq"));
			//requestBox.put("typeseq", partitionRoomSeqList.get(0).get("typeseq"));
			partitionRoomFirstRsvList = roomEduService.roomEduReservationInfoList(requestBox);
		}else{
			requestBox.put("roomseq", partitionRoomSeqList.get(0).get("roomseq"));
			//requestBox.put("typeseq", partitionRoomSeqList.get(0).get("typeseq"));
			partitionRoomFirstRsvList = roomEduService.roomEduReservationInfoList(requestBox);
			
			requestBox.put("roomseq", partitionRoomSeqList.get(1).get("roomseq"));
			//requestBox.put("typeseq", partitionRoomSeqList.get(1).get("typeseq"));
			partitionRoomSecondRsvList = roomEduService.roomEduReservationInfoList(requestBox);
		}
		
		mav.addObject("partitionRoomFirstRsvList", partitionRoomFirstRsvList);
		mav.addObject("partitionRoomSecondRsvList", partitionRoomSecondRsvList);
		
		return mav;
	}
	
	/**
	 * 선택 날짜에 세션 시간 상세보기
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomEduSeesionListAjax.do", method = RequestMethod.POST)
	public ModelAndView roomEduSeesionListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		
		List<Map<String, String>> roomEduSeesionList = roomEduService.roomEduSeesionList(requestBox);
		mav.addObject("roomEduSeesionList", roomEduSeesionList);
		
		/** 파티션룸 체크 param-roomseq
		 * case1 파티션룸이 아님 (null)
		 * 	- 추가 조회 없음
		 * case2 합쳐진 파티션룸 (R1 + R2)
		 *  - RSVSAMEROOMINFO에서 해당 ROOMSEQ를 PARENTROOMSEQ로 갖고있는 시설들의 선택 날짜 세션 시간 정보 조회
		 * case3 합쳐지지 않은 파티션룸 (R1, R2)
		 *  - PARENTROOMSEQ 로 선택 날짜 세션 시간 정보 조회
		 *  */
		
		List<Map<String, String>> partitionRoomSeqList = roomEduService.partitionRoomSeqList(requestBox);
		
		List<Map<String, String>> partitionRoomFirstSessionList = null;
		List<Map<String, String>> partitionRoomSecondSessionList = null;
		
		if(partitionRoomSeqList.isEmpty()){
			partitionRoomFirstSessionList = null;
		}else if(1 == partitionRoomSeqList.size()){
			requestBox.put("roomseq", partitionRoomSeqList.get(0).get("roomseq"));
			//requestBox.put("typeseq", partitionRoomSeqList.get(0).get("typeseq"));
			partitionRoomFirstSessionList = roomEduService.roomEduSeesionList(requestBox);
		}else{
			requestBox.put("roomseq", partitionRoomSeqList.get(0).get("roomseq"));
			//requestBox.put("typeseq", partitionRoomSeqList.get(0).get("typeseq"));
			partitionRoomFirstSessionList = roomEduService.roomEduSeesionList(requestBox);
			
			requestBox.put("roomseq", partitionRoomSeqList.get(1).get("roomseq"));
			//requestBox.put("typeseq", partitionRoomSeqList.get(1).get("typeseq"));
			partitionRoomSecondSessionList = roomEduService.roomEduSeesionList(requestBox);
		}
		
		mav.addObject("partitionRoomFirstSessionList", partitionRoomFirstSessionList);
		mav.addObject("partitionRoomSecondSessionList", partitionRoomSecondSessionList);
		
		return mav;
	}

	/**
	 * 결제 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomEduPaymentCheckAjax.do", method = RequestMethod.POST)
	public ModelAndView roomEduPaymentCheckAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> canceDataList = roomEduService.roomEduPaymentCheck(requestBox);
		mav.addObject("canceDataList", canceDataList);
		
		return mav;
	}
	
	/**
	 * 예약불가 팝업(예약 충돌)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomEduPaymentDisablePop.do", method = RequestMethod.POST)
	public ModelAndView roomEduPaymentDisablePop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/room/roomEduPaymentDisablePop");
		
		List<Map<String, String>> roomEduPaymentDisableList = roomEduService.roomEduPaymentDisablePop(requestBox);
		mav.addObject("roomEduPaymentDisableList", roomEduPaymentDisableList);
		
		mav.addObject("reqData", requestBox);
		
		return mav;
	}
	
	/**
	 * 예약취소 팝업(결제 오류)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomEduPaymentCancelPop.do", method = RequestMethod.POST)
	public ModelAndView roomEduPaymentCancelPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/room/roomEduPaymentCancelPop");
		
		mav.addObject("reqData", requestBox);
		
		return mav;
	}
	
	/**
	 * 예약정보 확인 팝업(정상 진행)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomEduPaymentInfoPop.do", method = RequestMethod.POST)
	public ModelAndView roomEduPaymentInfoPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/room/roomEduPaymentInfoPop");
		
		/* requestBox -> List<Map> 으로 변환 */
		List<Map<String, String>> roomEduPaymentInfoList = roomEduService.roomEduPaymentInfoPop(requestBox);
		mav.addObject("roomEduPaymentInfoList", roomEduPaymentInfoList);
		
		
		mav.addObject("reqData", requestBox);
		
		return mav;
	}
	
	/**
	 * 교육장 시설 예약 등록
	 * 
	 * typeseq : 1-교육장, 2-비즈룸, 3-퀸룸
	 * 
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/roomEduReservationInsertAjax.do", method = RequestMethod.POST)
	public ModelAndView roomEduReservationInsertAjax(HttpServletRequest req, ModelMap model, RequestBox requestBox) throws Exception{
		LOGGER.debug("invoke roomEduReservationInsertAjax");
		LOGGER.debug("requestBox : {}", requestBox);
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		/* 세션으로부터 abono 획득 */
		requestBox.put("account", requestBox.getSession("abono"));

		/** 예약 가능여부 체크 - 시작 { */
		/* 파라미터 명 fix - lower case */
		Map tupleMap = new HashMap();
		tupleMap.put(COLUMN_NAME_ACCOUNT,			"account");
		tupleMap.put(COLUMN_NAME_RESERVATIONDATE,	"reservationDate");
		tupleMap.put(COLUMN_NAME_RSVTYPECODE,		"");
		tupleMap.put(COLUMN_NAME_TYPESEQ,			"typeSeq");
		tupleMap.put(COLUMN_NAME_ROOMSEQ,			"roomSeq");
		tupleMap.put(COLUMN_NAME_PPSEQ,				"ppSeq");
		tupleMap.put(COLUMN_NAME_SESSIONSEQ, 		"rsvSessionSeq");
		
		/* parameter 정리 */
		//RequestBox requestBoxForInsert = (RequestBox) requestBox.clone();
		requestBox.remove("typeseq");
		requestBox.put("typeseq", requestBox.getObject("typeSeq"));
		requestBox.remove("ppseq");
		requestBox.put("ppseq", requestBox.getObject("ppSeq"));
		requestBox.remove("roomseq");
		requestBox.put("roomseq", requestBox.getObject("roomSeq"));
		
		Map<String, String> checkResultMap = super.reservationCheckerService.checkRoomReservationList(requestBox, tupleMap, requestBox.getVector("rsvSessionSeq").size());
		
		if("false".equals(checkResultMap.get("possibility"))){
			mav.addObject("possibility", checkResultMap.get("possibility"));
			mav.addObject("reason", checkResultMap.get("reason"));
			return mav;
		}
		/** } 예약 가능여부 체크 - 종료 */
		
		//예약 대기자 조회[같은 세션을 선점할 경우 늦게 insert한 사용자는  다른 사용자가 먼저 선점하여 등록이 불가 하다라는 메세지를 뿌려줌]
		Map<String, String> standByNumberAdvanceChecked = roomEduService.roomStandByNumberAdvanceChecked(requestBox);
		if("false".equals(standByNumberAdvanceChecked.get("msg"))){
			mav.addObject("possibility", standByNumberAdvanceChecked.get("msg"));
			mav.addObject("reason", standByNumberAdvanceChecked.get("reason"));
			return mav;
		}
		
		/* 결제 필요 금액 확인(not 0)*/
		int totalPrice = 0;
		
		for(int i = 0 ; i < requestBox.getVector("price").size() ; i++){
			totalPrice += Integer.parseInt((String) requestBox.getVector("price").get(i));
		}
		
		/* biz룸에서는 필요 없는 부분 */
		Map<String, String> tempTypeName = basicReservationService.searchTypeName(requestBox);
		if (!"비".equals(tempTypeName.get("temptypename"))) {

			/* 금액의 (임의적인) 변경 검증 {S} */
			int requestAmount = 0; // 요청 금액 (from front)
	
			String interfaceChannel = (String) requestBox.get("interfaceChannel");
			String paymentmode = (String) requestBox.get("paymentmode");
	
			for(int i = 0; i < requestBox.getVector("typeseq").size(); i++){
	
				HashMap<String, String> map = new HashMap<String, String>();
	
				map.put("typeseq", (String) requestBox.getVector("typeseq").get(i));
				map.put("rsvSessionSeq", (String) requestBox.getVector("rsvSessionSeq").get(i));
	
				String cookMasterCode = (String) requestBox.getVector("cookMasterCode").get(i);
	
				/* 다음의 정보로 정상적인 가격을 추출한 후 total 금액과 비교 후 금액이 다르면 exception을 생성한다. */
				LOGGER.debug("sec.map           : {}", map);
				LOGGER.debug("sec.typeseq       : {}", map.get("typeseq"));
				LOGGER.debug("sec.rsvSessionSeq : {}", map.get("rsvSessionSeq"));
				LOGGER.debug("sec.cookMasterCode    : {}", cookMasterCode);
	
				try {
					int tempAmount = 0;
	
					/* 요리명장-무료는 제외 */
					if(!"R01".equals(cookMasterCode)){
	
						EgovMap eMap = super.reservationCheckerService.getReservationPriceBySessionSeq(map);
						LOGGER.debug("sec.eMap : {}", eMap);
	
						if(null != eMap.get("price")){
	
							tempAmount = Integer.parseInt(eMap.get("price")+"");
							requestAmount += (tempAmount + (tempAmount * 0.1) );
						}
					}
				}catch (Exception e){
					LOGGER.error(e.getMessage(), e);
				}
			}
	
			LOGGER.debug("sec.totalPrice     : {}", totalPrice);
			LOGGER.debug("sec.requestAmount  : {}", requestAmount);
	
			if (totalPrice != requestAmount) {
				LOGGER.debug("결제 실패 : 주문 금액과 요청한 결제금액이 맞지 않습니다.");
				mav.addObject("possibility", "false");
				mav.addObject("reason", "주문 금액과 요청한 결제금액이 맞지 않습니다.");
				return mav;
			}
	
			/* 금액의 (임의적인) 변경 검증 {E} */

		}
			
		requestBox.put("totalPrice", totalPrice);
		requestBox.put("orderAmount", totalPrice); /* API 에서 totalPrice를 orderAmount로 사용하고 있어서 추가함 */
		
		/* 결제 기능 시작 - 예약의 합산 가격이 0 보다 크면 (퀸룸의 무료 예약 상품이 있음) */
		if( 0 < totalPrice ){
			
			String cardTraceNumber = basicReservationService.getCurrentCardTraceNumber();
			requestBox.put("cardtracenumber", cardTraceNumber);
			
			/** API call **/
			Map resultObject = super.interfacePayment(req, requestBox);
			String status = (String)resultObject.get("status");
			String errorMsg = (String)resultObject.get("errorMsg");
			
			if(null != status && ("SUCCESS").equals(status)){
				String invoiceQueue = (String) resultObject.get("invoiceQueue");
				String productCode = (String) resultObject.get("productCode");
				String responseTimestamp = (String) resultObject.get("responseTimestamp");
					
				requestBox.put("invoiceQueue", invoiceQueue);
				requestBox.put("productCode", productCode);
				requestBox.put("responseTimestamp", responseTimestamp);
				LOGGER.debug("결재성공");
			} else {
				LOGGER.debug("결제 실패 : {}", errorMsg);
				mav.addObject("possibility", "false");
				mav.addObject("reason", errorMsg);
				return mav;
			}
		}
		
		/** 교육장 예약 등록 **/
		/* insert */
		List<Map<String, String>> roomEduReservationList = roomEduService.roomEduReservationMobileInsertAjax(requestBox);
		mav.addObject("roomEduReservationList", roomEduReservationList);
		
		if(0 < totalPrice){
			// 유료 교육장일 경우[규약동의 4개]
			//약관 타입 코드 값 셋팅
			String[] typecode = {"C01", "C02", "C03", "C04"};
			requestBox.put("typecode", typecode);
			
		}else{
			//무료 교육장일 경우[규약동의 2개]
			
			// typeseq로 룸 이름 조회 : 상단에서 처리
			// Map<String, String> tempTypeName = basicReservationService.searchTypeName(requestBox);
			
			// 비즈룸 일경우 규약동의가 다르기때문에 분기를 한번 더 태운다.
			if("비".equals(tempTypeName.get("temptypename"))){
				//약관 타입 코드 값 셋팅
				String[] typecode = {"C05", "C02"};
				requestBox.put("typecode", typecode);
				
				
			// 무료 쿠폰일 경우
			}else{
				//약관 타입 코드 값 셋팅
				String[] typecode = {"C01", "C02"};
				requestBox.put("typecode", typecode);
				
			}
			
		}
		
		basicReservationService.insertRsvClauseHistory(requestBox);
		
		/* for facebook */
		String transactionTime = (String) requestBox.getVector("transactionTime").get(0);
		
		/** 선택 예약 정보 총 갯수 */
		mav.addObject("totalCnt", roomEduReservationList.size());
		mav.addObject("totalPrice", totalPrice);
		mav.addObject("transactionTime", transactionTime);
		
		LOGGER.debug("end of class requestBox : {}", requestBox);
		
		return mav;
	}
	
	/**
	 * 모바일 시설 예약 현황 확인(레이어팝업) 기준 년 월 셋팅
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popCalenderSettingAjax.do", method = RequestMethod.POST)
	public ModelAndView popCalenderSettingAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** 기준 년도 조회 */
		mav.addObject("yearCodeList", super.reservationYearCodeList());
		
		/** 기준 둴 조회 */
		mav.addObject("monthCodeList", super.reservationFormatingMonthCodeList());
		
		/** 현재 년, 월 조회 */
		mav.addObject("yearMonthDay", roomEduService.roomEduToday());
		
		return mav;
	}
	
	/**
	 * 해당 년, 월  달력정보 조회
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomCalenderInfoAjax.do", method = RequestMethod.POST)
	public ModelAndView roomCalenderInfoAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 해당 월 달력 조회 */
		List<Map<String, String>> roomCalendar = roomEduService.roomEduCalendar(requestBox);
		mav.addObject("roomCalendar", roomCalendar);
		
		/** 날짜별 예약 정보 조회 */
		List<Map<String, String>> roomReservationInfoList = roomEduService.roomReservationInfoList(requestBox);
		mav.addObject("roomReservationInfoList", roomReservationInfoList);
		
		/** 오늘 날짜 조회 */
		Map<String, String> roomToday = roomEduService.roomEduToday();
		mav.addObject("roomToday", roomToday);
		
		/** 이전달, 현재달, 다음달 예약 정보 카운트 */
		mav.addObject("monthRsvCount", basicReservationService.searchMonthRsvCount(requestBox));
		
		/** 파티션룸 체크 param-roomseq
		 * case1 파티션룸이 아님 (null)
		 * 	- 추가 조회 없음
		 * case2 합쳐진 파티션룸 (R1 + R2)
		 *  - RSVSAMEROOMINFO에서 해당 ROOMSEQ를 PARENTROOMSEQ로 갖고있는 시설들의 날짜별 예약정보 조회 
		 * case3 합쳐지지 않은 파티션룸 (R1, R2)
		 *  - PARENTROOMSEQ 로 날짜별 예약정보 조회
		 *  */
		
		List<Map<String, String>> partitionRoomSeqList = roomEduService.partitionRoomSeqList(requestBox);
		
		List<Map<String, String>> partitionRoomFirstRsvList = null;
		List<Map<String, String>> partitionRoomSecondRsvList = null;
		
		if(partitionRoomSeqList.isEmpty()){
			partitionRoomFirstRsvList = null;
		}else if(1 == partitionRoomSeqList.size()){
			requestBox.put("roomseq", partitionRoomSeqList.get(0).get("roomseq"));
			//requestBox.put("typeseq", partitionRoomSeqList.get(0).get("typeseq"));
			partitionRoomFirstRsvList = roomEduService.roomEduReservationInfoList(requestBox);
		}else{
			requestBox.put("roomseq", partitionRoomSeqList.get(0).get("roomseq"));
			//requestBox.put("typeseq", partitionRoomSeqList.get(0).get("typeseq"));
			partitionRoomFirstRsvList = roomEduService.roomEduReservationInfoList(requestBox);
			
			requestBox.put("roomseq", partitionRoomSeqList.get(1).get("roomseq"));
			//requestBox.put("typeseq", partitionRoomSeqList.get(1).get("typeseq"));
			partitionRoomSecondRsvList = roomEduService.roomEduReservationInfoList(requestBox);
		}
		
		mav.addObject("partitionRoomFirstRsvList", partitionRoomFirstRsvList);
		mav.addObject("partitionRoomSecondRsvList", partitionRoomSecondRsvList);
		
		return mav;
	}
	
	/**
	 * 해당 날짜 시설 예약 정보 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomDayReservationListAjax.do", method = RequestMethod.POST)
	public ModelAndView roomDayReservationListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		List<Map<String, String>> roomReservationList = roomEduService.roomDayReservationList(requestBox);
		mav.addObject("roomReservationList", roomReservationList);
		
		return mav;
	}
	
	/**
	 * 해당 년, 월 시설 예약 정보 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomMonthReservationListAjax.do", method = RequestMethod.POST)
	public ModelAndView roomMonthReservationListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		List<Map<String, String>> roomReservationList = roomEduService.roomMonthReservationList(requestBox);
		mav.addObject("roomReservationList", roomReservationList);
		
		return mav;
	}
	
	/**
	 * 시설 이미지 경로 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomImageUrlListAjax.do", method = RequestMethod.POST)
	public ModelAndView roomImageUrlListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> roomImageUrlList = basicReservationService.roomImageUrlList(requestBox);
		mav.addObject("roomImageUrlList", roomImageUrlList);
		
		return mav;
	}
	
}
