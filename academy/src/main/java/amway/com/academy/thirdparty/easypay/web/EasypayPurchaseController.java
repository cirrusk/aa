package amway.com.academy.thirdparty.easypay.web;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import framework.com.cmm.util.StringUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import amway.com.academy.common.util.UtilAPI;
import amway.com.academy.reservation.basicPackage.web.BasicReservationController;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import framework.com.cmm.lib.RequestBox;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

/**
 * <pre>
 * </pre>
 * Program Name  : EasypayPurchaseController.java
 * Author : KR620207
 * Creation Date : 2016. 10. 21.
 */
@RequestMapping("/easypay")
@Controller
public class EasypayPurchaseController extends BasicReservationController{

	private static final Logger LOGGER = LoggerFactory.getLogger(EasypayPurchaseController.class);
	
	/**
	 * <pre>
	 * json-object 파라미터의 name, value 속성으로 requestBox의 개체를 생성해 준다.
	 * 
	 * - KICC 결제를 위한 기능
	 * </pre>
	 * @param requestBox
	 * @param mobilereserved1
	 * @throws Exception
	 */
	private void setRequestBoxFromMobileJson(RequestBox requestBox, String reserved1) throws Exception {
		
		try {
			LOGGER.debug("in setRequestBoxFromMobileJson : {}", requestBox);
			LOGGER.debug("in setRequestBoxFromMobileJson : {}", reserved1);
			
			Gson gson = new Gson();
			List<Map<String,String>> list = gson.fromJson(reserved1, new TypeToken<List<Map<String,String>>>(){}.getType());
			
			if ( null != list ){
				LOGGER.debug("{}", list);
			}
			
			for (int i = 0 ; i < list.size(); i++ ){
				
				String name = (String)list.get(i).get("name");
				LOGGER.debug("{}", name);
				
				String value = (String)list.get(i).get("value");
				LOGGER.debug("{}", value);
				
				requestBox.put(name, value);
			}
			
		}catch (Exception e){
			LOGGER.error(e.getMessage(), e);
		}
		
	}
	
	
	/**
	 * <pre>
	 * 결제 페이지내 include 되는 페이지로 forwarding
	 * </pre>
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/order.do")
	public String easypayOrder(ModelMap model, RequestBox requestBox) throws Exception {
		
		LOGGER.debug("invoke easypayOrder");
		
		requestBox.put("account", requestBox.getSession("abono"));
		model.addAttribute("getMemberInformation", super.reservationCheckerService.getMemberInformation(requestBox));
		
		/* CURRENT SERVER URL (FOR EASY-PAY) */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
		model.addAttribute("mallId", UtilAPI.getFrameworkProperties("easypay.g_mall_id"));
		model.addAttribute("mallName", UtilAPI.getFrameworkProperties("easypay.g_mall_name"));

		return "/thirdparty/easypay/order";
	}
	
	/**
	 * <pre>
	 * 결제 페이지내 include 되는 페이지로 forwarding
	 * </pre>
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/orderMobile.do")
	public String easypayOrderMobile(ModelMap model, RequestBox requestBox) throws Exception {
		
		LOGGER.debug("invoke easypayOrder");
		
		requestBox.put("account", requestBox.getSession("abono"));
		model.addAttribute("getMemberInformation", super.reservationCheckerService.getMemberInformation(requestBox));
		model.addAttribute("easypayRequestPage", UtilAPI.getFrameworkProperties("request.mobile.location"));
		
		/* CURRENT SERVER URL (FOR EASY-PAY) */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
		model.addAttribute("mallId", UtilAPI.getFrameworkProperties("easypay.g_mall_id"));
		model.addAttribute("mallName", UtilAPI.getFrameworkProperties("easypay.g_mall_name"));

		return "/thirdparty/easypay/order_mobile";
	}
	
	/**
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popupRequest.do")
	public String easypayPopupRequest(ModelMap model) throws Exception {
		
		LOGGER.debug("invoke popupRequest");
		model.addAttribute("easypayRequestPage", UtilAPI.getFrameworkProperties("request.server.location"));
		
		return "/thirdparty/easypay/popup_req";
	}
	
	/**
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/popupResponse.do")
	public String easypayPopupResponse(ModelMap model) throws Exception {
		
		LOGGER.debug("invoke popupResponse");
		
		return "/thirdparty/easypay/popup_res";
	}
	
	/**
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/result.do")
	public String easypayResult(ModelMap model) throws Exception {
		
		LOGGER.debug("invoke result");
		
		return "/thirdparty/easypay/result";
	}
	
	/**
	 * 결제를 진행 하며, 결제 성공여부에 따라 DB에 결과를 기록하는 기능 
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/easypayRequest.do")
	public String easypayReqest(ModelMap model) throws Exception {
		
		LOGGER.debug("invoke easypayReqest");
		
		/* CURRENT SERVER URL (FOR EASY-PAY) */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
		//g_gw_url
		model.addAttribute("gatewayUrl", UtilAPI.getFrameworkProperties("easypay.g_gw_url"));
		model.addAttribute("gatewayPort", UtilAPI.getFrameworkProperties("easypay.g_gw_port"));
		model.addAttribute("certFile", UtilAPI.getFrameworkProperties("easypay.certfile.location"));
		model.addAttribute("logFileLocation", UtilAPI.getFrameworkProperties("easypay.logfile.location"));
		
		//testgw.easypay.co.kr
		//return "/thirdparty/easypay/easypay_request";
		
		return "/thirdparty/easypay/result";
	}

	/**
	 * <pre>
	 * forwarding 없이 controller 에서 처리
	 * </pre>
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/easypayRequestProcess.do")
	public String easypayProcessor(HttpServletRequest request, RequestBox requestBox, ModelMap model) throws Exception {
		
		LOGGER.debug("invoke easypayProcessor");
		LOGGER.debug("requestBox : {}", requestBox);
		
	    /* -------------------------------------------------------------------------- */
	    /* ::: 결제 결과                                                              */
	    /* -------------------------------------------------------------------------- */
	    String bDBProc          = "";
	    String res_cd           = "";
	    String res_msg          = "";
	    
	    res_cd = request.getParameter("EP_res_cd");
	    res_msg = request.getParameter("EP_res_msg");

	    /* -------------------------------------------------------------------------- */
	    /* ::: 가맹점 DB 처리                                                         */
	    /* -------------------------------------------------------------------------- */
	    /* 응답코드(res_cd)가 "0000" 이면 정상승인 입니다.                            */
	    /* r_amount가 주문DB의 금액과 다를 시 반드시 취소 요청을 하시기 바랍니다.     */
	    /* DB 처리 실패 시 취소 처리를 해주시기 바랍니다.                             */
	    /* -------------------------------------------------------------------------- */
    	LOGGER.debug("insert payment success result");
    	LOGGER.debug("requestBox : ", requestBox);
    	LOGGER.debug("request    : ", request);
    	
		/* 세션으로부터 abono 획득 */
		requestBox.put("account", requestBox.getSession("abono"));
    	
    	/* 총 금액 */
    	String orderAmount = requestBox.get("totalPrice");
    	requestBox.put("orderAmount", orderAmount);
    	int totalPrice = Integer.parseInt(orderAmount);
    	
    	
    	/* 금액의 (악의적인) 변경 검증 {S} */
		int requestAmount = 0; // 요청 금액 (from front)
		
		for(int i = 0; i < requestBox.getVector("typeseq").size(); i++){

			HashMap<String, String> map = new HashMap<String, String>();
			
			map.put("typeseq", (String) requestBox.getVector("typeseq").get(i));
			map.put("rsvSessionSeq", (String) requestBox.getVector("rsvsessionseq").get(i));
			
			String cookMasterCode = (String) requestBox.get("cookmastercode");

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
		
		LOGGER.debug("sec.totalPrice    : {}", totalPrice);
		LOGGER.debug("sec.requestAmount : {}", requestAmount);
		
		if (totalPrice != requestAmount ) {

			LOGGER.debug("결제 실패 : 주문 금액과 요청한 결제금액이 맞지 않습니다.");
			
			model.put("res_cd", "ER09");
	    	model.put("res_msg", "주문 금액과 요청한 결제금액이 맞지 않습니다.");
	    	model.put("bDBProc", "false");
	    	return "/thirdparty/easypay/result";
	    
		}
		
		/* 금액의 (임의적인) 변경 검증 {E} */
    	
    	
    	/* 가상주문번호 */
    	String cardTraceNumber = basicReservationService.getCurrentCardTraceNumber();
		requestBox.put("cardtracenumber", cardTraceNumber);
		
		/** API call **/
		bDBProc = "false";
		String apiProcess = "false";

		Map resultObject = super.interfacePayment(request, requestBox);
		String status = (String)resultObject.get("status");
		String errorCode = (String)resultObject.get("errorCode");
		String errorMsg = (String)resultObject.get("errorMsg");
		
		if(null != status && "SUCCESS".equals(status)){
			String invoiceQueue = (String) resultObject.get("invoiceQueue");
			String productCode = (String) resultObject.get("productCode");
			String responseTimestamp = (String) resultObject.get("responseTimestamp");
			
			if (null == invoiceQueue || "".equals(invoiceQueue) ){
				invoiceQueue = "not_responsed";
			}
			
			requestBox.put("invoiceQueue", invoiceQueue);
			requestBox.put("productCode", productCode);
			requestBox.put("responseTimestamp", responseTimestamp);
			LOGGER.debug("결재성공");
			
			apiProcess = "true";
			
		} else {
			LOGGER.debug("결제 실패 : {}", errorCode);
			LOGGER.debug("결제 실패 : {}", errorMsg);
			
			apiProcess = "false";
		}

		
		try {
			
			if ("true".equals(apiProcess)) {
				/* 교육장 예약 등록 : 주문 정보 입력 및 사용자 예약정보의 결제정보 갱신 */
				List<Map<String, String>> roomEduReservationList = basicReservationService.roomReservationInsert(requestBox);
				//mav.addObject("roomEduReservationList", roomEduReservationList);
				
				
				/* 동의한 약관 등록 */
				String[] typecode = {"C01", "C02", "C03", "C04"};
				requestBox.put("typecode", typecode);
				
				basicReservationService.insertRsvClauseHistory(requestBox);
				
				bDBProc = "true";	// DB처리 성공 시 "true", 실패 시 "false"
			}
			
		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
			bDBProc = "false";		// DB처리 성공 시 "true", 실패 시 "false"
		}
		
		LOGGER.debug("errorCode : {}", errorCode);
		LOGGER.debug("errorMsg  : {}", errorMsg);
		LOGGER.debug("res_cd  : {}", res_cd);
		LOGGER.debug("res_msg : {}", res_msg);
		LOGGER.debug("res_msg (decode ): {}", URLDecoder.decode(res_msg, "UTF-8"));
		LOGGER.debug("bDBProc : {}", bDBProc);
	    
	    LOGGER.debug("invoiceQueue : {}", resultObject.get("invoiceQueue"));
		
	    
	    
	    if("".equals(errorCode)){
	    	model.put("res_cd", res_cd);
	    	model.put("res_msg", res_msg);
	    	model.put("bDBProc", bDBProc);
	    }else{
	    	model.put("res_cd", errorCode);
	    	model.put("res_msg", errorMsg);
	    	model.put("bDBProc", bDBProc);
	    }
	    
		return "/thirdparty/easypay/result";
	}

	
	
	
	
	/**
	 * 
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/easypayRequestMobile.do")
	public String easypayRequestMobile(ModelMap model) throws Exception {
		
		LOGGER.debug("invoke easypayRequestMobile");
		
		/* CURRENT SERVER URL (FOR EASY-PAY) */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
		//g_gw_url
		model.addAttribute("gatewayUrl", UtilAPI.getFrameworkProperties("easypay.g_gw_url"));
		model.addAttribute("gatewayPort", UtilAPI.getFrameworkProperties("easypay.g_gw_port"));
		model.addAttribute("certFile", UtilAPI.getFrameworkProperties("easypay.certfile.location"));
		model.addAttribute("logFileLocation", UtilAPI.getFrameworkProperties("easypay.logfile.location"));
		
		return "/thirdparty/easypay/easypay_request_mobile";
	}
	
	
	/**
	 * <pre>
	 * sABN의 database 처리
	 * 
	 * </pre>
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/easypayRequestSabn.do")
	public String easypayRequestSabn(HttpServletRequest request, RequestBox requestBox, ModelMap model) throws Exception {
		
		LOGGER.debug("invoke easypayRequestSabn");
		
		/* CURRENT SERVER URL (FOR EASY-PAY) */
		model.addAttribute("currentDomain", UtilAPI.getCurerntHybrisLocation());
		
		model.addAttribute("hybrisDomain", UtilAPI.getCurerntHybrisLocation());
		
		model.addAttribute("currentBusiness",  requestBox.get("reserved2"));
		
		//g_gw_url
		//model.addAttribute("gatewayUrl", UtilAPI.getFrameworkProperties("easypay.g_gw_url"));
		//model.addAttribute("gatewayPort", UtilAPI.getFrameworkProperties("easypay.g_gw_port"));
		//model.addAttribute("certFile", UtilAPI.getFrameworkProperties("easypay.certfile.location"));
		//model.addAttribute("logFileLocation", UtilAPI.getFrameworkProperties("easypay.logfile.location"));
		
		String resCd = StringUtil.chkNull(request.getParameter("res_cd"));      
		String resMsg = StringUtil.chkNull(request.getParameter("res_msg")); 
		
		String reserved1 = StringUtil.chkNull(request.getParameter("reserved1"));
		
		this.setRequestBoxFromMobileJson(requestBox, URLDecoder.decode(reserved1, "UTF-8"));
		
		LOGGER.debug("requestBox in easypayRequestSabn : {}", requestBox);
		
		/* resCd 가 0000 이면 api 호출 및 데이터 인서트 */
		if("0000".equals(resCd)){
			
			/* -------------------------------------------------------------------------- */
		    /* ::: 결제 결과                                                                                                                 */
		    /* -------------------------------------------------------------------------- */
		    String bDBProc          = "";

		    /* -------------------------------------------------------------------------- */
		    /* ::: 가맹점 DB 처리                                                                                                         */
		    /* -------------------------------------------------------------------------- */
		    /* 응답코드(res_cd)가 "0000" 이면 정상승인 입니다.                                     */
		    /* r_amount가 주문DB의 금액과 다를 시 반드시 취소 요청을 하시기 바랍니다.                       */
		    /* DB 처리 실패 시 취소 처리를 해주시기 바랍니다.                                          */
		    /* -------------------------------------------------------------------------- */

	    	LOGGER.debug("insert payment success result");
	    	//LOGGER.debug("requestBox : ", requestBox);
	    	LOGGER.debug("request    : ", request);
	    	
			/* 세션으로부터 abono 획득 */
			requestBox.put("account", requestBox.getSession("abono"));
	    	
	    	/* 총 금액 */
	    	String orderAmount = requestBox.get("totalPrice");
	    	requestBox.put("orderAmount", orderAmount);
	    	
	    	/* 가상주문번호 */
	    	String cardTraceNumber = basicReservationService.getCurrentCardTraceNumber();
			requestBox.put("cardtracenumber", cardTraceNumber);
			
			/** API call **/
			bDBProc = "false";
			String apiProcess = "false";

			Map resultObject = super.interfacePayment(request, requestBox);
			LOGGER.debug("interfacePayment - resultObject : ", resultObject);
			
			String status = (String)resultObject.get("status");
			String errorCode = (String)resultObject.get("errorCode");
			String errorMsg = (String)resultObject.get("errorMsg");
			
			if(null != status && "SUCCESS".equals(status)){
				String invoiceQueue = (String) resultObject.get("invoiceQueue");
				String productCode = (String) resultObject.get("productCode");
				String responseTimestamp = (String) resultObject.get("responseTimestamp");
				
				if (null == invoiceQueue || "".equals(invoiceQueue) ){
					invoiceQueue = "not_responsed";
				}
				
				requestBox.put("invoiceQueue", invoiceQueue);
				requestBox.put("productCode", productCode);
				requestBox.put("responseTimestamp", responseTimestamp);
				LOGGER.debug("결재성공");
				
				apiProcess = "true";
				
			} else {
				LOGGER.debug("결제 실패 : {}", errorCode);
				LOGGER.debug("결제 실패 : {}", errorMsg);
				
				apiProcess = "false";
			}

			
			try {
				
				if ("true".equals(apiProcess)) {
					/* 교육장 예약 등록 : 주문 정보 입력 및 사용자 예약정보의 결제정보 갱신 */
					List<Map<String, String>> roomEduReservationList = basicReservationService.roomReservationInsert(requestBox);
					//mav.addObject("roomEduReservationList", roomEduReservationList);
					
					LOGGER.debug("roomReservationInsert inserted");
					
					/* 동의한 약관 등록 */
					String[] typecode = {"C01", "C02", "C03", "C04"};
					requestBox.put("typecode", typecode);
					
					basicReservationService.insertRsvClauseHistory(requestBox);
					
					bDBProc = "true";	// DB처리 성공 시 "true", 실패 시 "false"
				}
				
			} catch (Exception e) {
				LOGGER.error(e.getMessage(), e);
				bDBProc = "false";		// DB처리 성공 시 "true", 실패 시 "false"
			}
			
			
			LOGGER.debug("errorCode  : {}", errorCode);
			LOGGER.debug("errorMsg  : {}", errorMsg);
		    LOGGER.debug("resCd  : {}", resCd);
		    LOGGER.debug("res_msg : {}", resMsg);
		    LOGGER.debug("res_msg (decode ): {}", URLDecoder.decode(resMsg, "UTF-8"));
		    LOGGER.debug("bDBProc : {}", bDBProc);
		    
		    LOGGER.debug("invoiceQueue : {}", resultObject.get("invoiceQueue"));
		    model.put("invoiceQueue", resultObject.get("invoiceQueue"));
		    
		    if("".equals(errorCode)){
		    	model.put("res_cd", resCd);
		    	model.put("res_msg", resMsg);
		    	model.put("bDBProc", bDBProc);
		    }else{
		    	model.put("res_cd", errorCode);
		    	model.put("res_msg", errorMsg);
		    	model.put("bDBProc", bDBProc);
		    }
			
		}
		
		return "/thirdparty/easypay/easypay_request_sabn";
	}
	
	/**
	 * 모바일
	 * @param request
	 * @param requestBox
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/easypayRequestProcessMobile.do")
	public String easypayRequestProcessMobile(HttpServletRequest request, RequestBox requestBox, ModelMap model) throws Exception {
		
	    /* -------------------------------------------------------------------------- */
	    /* ::: 결제 결과                                                                                                                 */
	    /* -------------------------------------------------------------------------- */
	    String bDBProc          = "";
	    String res_cd           = "";
	    String res_msg          = "";
	    
	    res_cd = request.getParameter("EP_res_cd");
	    res_msg = request.getParameter("EP_res_msg");

	    /* -------------------------------------------------------------------------- */
	    /* ::: 가맹점 DB 처리                                                                                                         */
	    /* -------------------------------------------------------------------------- */
	    /* 응답코드(res_cd)가 "0000" 이면 정상승인 입니다.                                     */
	    /* r_amount가 주문DB의 금액과 다를 시 반드시 취소 요청을 하시기 바랍니다.                       */
	    /* DB 처리 실패 시 취소 처리를 해주시기 바랍니다.                                          */
	    /* -------------------------------------------------------------------------- */

    	LOGGER.debug("insert payment success result");
    	LOGGER.debug("requestBox : ", requestBox);
    	LOGGER.debug("request    : ", request);
    	
		/* 세션으로부터 abono 획득 */
		requestBox.put("account", requestBox.getSession("abono"));
    	
    	/* 총 금액 */
    	String orderAmount = requestBox.get("totalPrice");
    	requestBox.put("orderAmount", orderAmount);
    	
    	/* 가상주문번호 */
    	String cardTraceNumber = basicReservationService.getCurrentCardTraceNumber();
		requestBox.put("cardtracenumber", cardTraceNumber);
		
		/** API call **/
		bDBProc = "false";
		String apiProcess = "false";

		Map resultObject = super.interfacePayment(request, requestBox);
		LOGGER.debug("interfacePayment - resultObject : ", resultObject);
		
		String status = (String)resultObject.get("status");
		String errorMsg = (String)resultObject.get("errorMsg");
		
		if(null != status && "SUCCESS".equals(status)){
			String invoiceQueue = (String) resultObject.get("invoiceQueue");
			String productCode = (String) resultObject.get("productCode");
			String responseTimestamp = (String) resultObject.get("responseTimestamp");
			
			if (null == invoiceQueue || "".equals(invoiceQueue) ){
				invoiceQueue = "not_responsed";
			}
			
			requestBox.put("invoiceQueue", invoiceQueue);
			requestBox.put("productCode", productCode);
			requestBox.put("responseTimestamp", responseTimestamp);
			LOGGER.debug("결재성공");
			
			apiProcess = "true";
			
		} else {
			LOGGER.debug("결제 실패 : {}", errorMsg);
			
			apiProcess = "false";
		}

		
		try {
			
			if ("true".equals(apiProcess)) {
				/* 교육장 예약 등록 : 주문 정보 입력 및 사용자 예약정보의 결제정보 갱신 */
				List<Map<String, String>> roomEduReservationList = basicReservationService.roomReservationInsert(requestBox);
				//mav.addObject("roomEduReservationList", roomEduReservationList);
				
				LOGGER.debug("roomReservationInsert inserted");
				
				/* 동의한 약관 등록 */
				String[] typecode = {"C01", "C02", "C03", "C04"};
				requestBox.put("typecode", typecode);
				
				basicReservationService.insertRsvClauseHistory(requestBox);
				
				bDBProc = "true";	// DB처리 성공 시 "true", 실패 시 "false"
			}
			
		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
			bDBProc = "false";		// DB처리 성공 시 "true", 실패 시 "false"
		}
		
		
	    LOGGER.debug("res_cd  : {}", res_cd);
	    LOGGER.debug("res_msg : {}", res_msg);
	    LOGGER.debug("bDBProc : {}", bDBProc);
	    
	    model.put("res_cd", res_cd);
	    model.put("res_msg", res_msg);
	    model.put("bDBProc", bDBProc);
	    
		return "/thirdparty/easypay/result_mobile";
	}
	
}
