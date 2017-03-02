package amway.com.academy.reservation.roominfo.web;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.common.util.UtilAPI;
import amway.com.academy.reservation.basicPackage.service.BasicReservationService;
import amway.com.academy.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.reservation.roomEdu.service.RoomEduService;
import amway.com.academy.reservation.roominfo.service.RoomInfoService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;


@RequestMapping("/reservation")
@Controller
public class RoomInfoController extends BasicReservationController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(BasicReservationController.class);
	
	@Autowired
	private RoomInfoService roomInfoService;
	
	@Autowired
	private RoomEduService roomEduService;
	
	/** 공통 코드 서비스 */
	@Autowired
	private BasicReservationService basicReservationService;
	
	/** adobe analytics */
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	private String sRowPerPage = "10"; // 페이지에 넣을 row수

	/**
	 * 시설예약 현황확인 페이지 호출
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoList.do")
	public ModelAndView roomInfoForm(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/room/roomInfoList");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		/**----------------------------검색 조건------------------------------------------*/
		mav.addObject("reservationYearCodeList", super.reservationYearCodeList());							// 년도
		mav.addObject("reservationFormatingMonthCodeList", super.reservationFormatingMonthCodeList());		// 월
		mav.addObject("roomRsvTypeInfoCodeList", super.roomRsvTypeInfoCodeList());							// 시설 종류
		mav.addObject("ppCodeList", super.ppCodeList());													// pp리스트
		/**--------------------------------------------------------------------------*/
		
		/** 기준 년도 조회 */
		mav.addObject("yearCodeList", super.reservationYearCodeList());
		
		/** 기준 둴 조회 */
		mav.addObject("monthCodeList", super.reservationFormatingMonthCodeList());
		
		/** 현재 년, 월 조회 */
		mav.addObject("yearMonthDay", roomEduService.roomEduToday());
		
		/** 디폴트 날짜 검색 조건 셋팅 [2개월전 1일~현재월 마지막날 조회] (yyyy-mm-dd)*/
		Map<String, String> searchThreeMonthRoom = roomInfoService.searchThreeMonthRoom(requestBox);
		model.addAttribute("searchThreeMonthRoom", searchThreeMonthRoom);
		
		/** 디폴트 날짜 검색 조건 셋팅 */
		if("".equals(requestBox.get("searchStrYear"))){
			requestBox.put("searchStrYear", searchThreeMonthRoom.get("strdate").substring(0, 4));
		}
		if("".equals(requestBox.get("searchStrMonth"))){
			requestBox.put("searchStrMonth", searchThreeMonthRoom.get("strdate").substring(5, 7));
		}
		if("".equals(requestBox.get("searchEndYear"))){
			requestBox.put("searchEndYear", searchThreeMonthRoom.get("enddate").substring(0, 4));
		}
		if("".equals(requestBox.get("searchEndMonth"))){
			requestBox.put("searchEndMonth", searchThreeMonthRoom.get("enddate").substring(5, 7));
		}
		
		/**----------------------------페이징-------------------------------------------*/
		PageVO pageVO = new PageVO(requestBox);
		if(("").equals(requestBox.getString("page")) || ("0").equals(requestBox.getString("page"))){
			requestBox.put("page", "1");
		}
		
		if("".equals(requestBox.getString("rowPerPage"))){
			requestBox.put("rowPerPage", sRowPerPage);
		}
		
		if(("").equals(requestBox.getString("totalCount")) || ("0").equals(requestBox.getString("totalCount"))) {
			/** 시설 예약 현황 리스트 카운트 */
			pageVO.setTotalCount(roomInfoService.roomInfoListCount(requestBox));
			requestBox.put("totalPage", pageVO.getTotalPages());
			requestBox.put("firstIndex", 1);
		} else {
			pageVO.setTotalCount(requestBox.getString("totalCount"));
		}
		
		pageVO.setTotalCount(roomInfoService.roomInfoListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", 1);
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		
		PagingUtil.defaultParmSetting(requestBox);
		
		model.addAttribute("scrData", requestBox);
		/**--------------------------------------------------------------------------*/
		
		/** 현재 hybris의 경로 */
		mav.addObject("hybrisUrl", UtilAPI.getCurerntHybrisLocation());
		
		/** 시설 예약 현황 리스트 */
		mav.addObject("roomInfoList", roomInfoService.roomInfoList(requestBox));

		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return mav;
	}
	
	@RequestMapping(value = "/roomInfoRsvCancelPop.do")
	public ModelAndView roomInfoRsvCancelPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/room/roomInfoRsvCancelPop");
		
		/* 패널티 조회(당일예약 취소시 패널티가 적용되지 않음) */
		Map<String, String> roomInfoRsvCancelPenalty = roomInfoService.roomInfoRsvCancelPenalty(requestBox);
		mav.addObject("roomInfoRsvCancelPenalty", roomInfoRsvCancelPenalty);
		
		
		Map<String, String> reservationInfo = roomInfoService.roomInfoRsvInfo(requestBox);
		
		/** 파라미터값 */
		model.addAttribute("scrData", requestBox);
		model.addAttribute("reservationInfo", reservationInfo);
		
		return mav;
	}
	
	/**
	 * 시설 예약 현황 상세 리스트
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoDetailList.do")
	public ModelAndView roomInfoDetailList(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/room/roomInfoDetailList");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 시설 예약 현황 상세 리스트 */
		List<Map<String, String>> roomInfoDetailList = roomInfoService.roomInfoDetailList(requestBox);
		mav.addObject("roomInfoDetailList", roomInfoDetailList);
		
		/* 가상 주문 번호가 있으면, 교육장or퀸룸 이며 영수증 존재. 
		 * 가상 주문 번호가 없으면, 영수증 없음 */
		if(!("").equals(requestBox.get("virtualpurchasenumber"))){
			// 가상 주문 번호로 주문번호 조회
			Map<String, String> realOrderNumber = UtilAPI.getInvoice(requestBox.get("purchasedate"), requestBox.get("virtualpurchasenumber"));
			
			//카드 번호 조회
			Map<String, String> getCardNumber= UtilAPI.getReceipts(realOrderNumber.get("invoiceCode"));
			
			model.addAttribute("cardNumber", getCardNumber.get("cardNumber"));
		}
		
		/** 파라미터값 */
		model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics

		return mav;
	}
	
	/**
	 * 시설 예약 취소
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateRoomCancelCodeAjax.do", method = RequestMethod.POST)
	public ModelAndView updateRoomCancelCodeAjax(ModelMap model, RequestBox requestBox)throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** session id값 */
		String sessinAccount = requestBox.getSession("abono");
		requestBox.put("account", sessinAccount);
		
		/* 환불에 필요한 SSN 값 획득 */
		Map<String, String> memberInformatioin = super.reservationCheckerService.getMemberInformation(requestBox);
		String ssn = memberInformatioin.get("ssn");
		requestBox.put("ssn", ssn);
		
		/* 예약자와 세션 사용자와 같은지 검사 */
		Map<String, String> reservationInformation = this.roomInfoService.roomInfoRsvInfo(requestBox);
		String reservationAccount = reservationInformation.get("account");
		
		if(!sessinAccount.equals(reservationAccount)){
			model.put("errorMsg", "예약자가 동일하지 않습니다.");
			return mav;
		}
		
		/* ****************************************************************************** */
		int refundAmountRatio = 0;
		
		if("P".equals(requestBox.get("typecode"))){
			
			/*  패널티 적용금액을 적용 */
			Map<String,String> searchPenalty = roomInfoService.searchRoomPayPenalty(requestBox);
			
			/* temporary penalty role : 오픈일 이전 예약은 패널티를 적용하지 않음 */
			String systemOpenDay = UtilAPI.getFrameworkProperties("ai.systemOpen.day"); // 20170110
			String reservedDay = (String) reservationInformation.get("reservationdate").replaceAll("-", ""); // 예약일
			
			LOGGER.debug("systemOpenDay {}", systemOpenDay);
			LOGGER.debug("reservedDay   {}", reservedDay);
			
			int opnDay = Integer.parseInt(systemOpenDay);
			int rsvDay = Integer.parseInt(reservedDay);
			
			/* 예약한 날이 오픈일 이전이면 패널티 생략 */
			if(rsvDay < opnDay ){
				searchPenalty = null;
				requestBox.put("isOldReservation", "true");
			}
			
			if(null != searchPenalty){
				/* 패널티 적용비율 */
				int penaltyValue = Integer.parseInt((String)searchPenalty.get("applytypevalue"));
				LOGGER.debug("penaltyValue : {}", penaltyValue); 
				/* 환불 대상 금액 */
				int paymentAmount = Integer.parseInt((String)requestBox.get("paymentamount"));
				LOGGER.debug("paymentAmount : {}", paymentAmount); 
				
				refundAmountRatio = paymentAmount * penaltyValue / 100;
				LOGGER.debug("refundAmountRatio : {}", refundAmountRatio);
				
				int refundAmount = paymentAmount - refundAmountRatio;
				LOGGER.debug("refundAmount : {}", refundAmount);
				
				requestBox.put("paymentamount", refundAmount);
				
			}
		}
		
		requestBox.put("refundcharge", refundAmountRatio);
		
		if(0 != Integer.parseInt((String)requestBox.get("paymentamount"))){
		
			/** 예약 취소시 환불 API */
			Map<String, String> returnMap = super.interfaceRefund(requestBox);
			
			if("ERROR".equals(returnMap.get("status"))) {
				String returnMessage = (String) returnMap.get("errorMsg");
				String returnCode = (String) returnMap.get("errorCode");

				/* 이전 예약 취소가 실패한 경우 -취소요청수량이 주문수량보다 많습니다 - 의 메세지로인해서 처리 안되는 내용을 db에서 강제로 수행 */
				if("15".equals(returnCode)){
					roomInfoService.updateRoomCancelCodeAjax(requestBox);
				}
				
				model.put("errorMsg", returnMessage);
				return mav;
			}
		}
		roomInfoService.updateRoomCancelCodeAjax(requestBox);
		
		
		return mav;
	}
	
	/**
	 * 시설 예약 환불 정보 팝업
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoRsvPaybackInfoPop.do")
	public ModelAndView roomInfoRsvPaybackInfoPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/room/roomInfoRsvPaybackInfoPop");
		
		mav.addObject("roomInfoRsvPaybackInfo", roomInfoService.roomInfoRsvPaybackInfo(requestBox));
		
		return mav;
	}
	
	@RequestMapping(value = "/showRoomRsvReceiptPop.do")
	public ModelAndView showRoomRsvReceiptPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/room/showRoomRsvReceiptPop");
		
		String tempInstalment;
		
		String resourceName = "/config/props/framework.properties";
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties props = new Properties();
		
		try {
			
			InputStream resourceStream = loader.getResourceAsStream(resourceName);
			props.load(resourceStream);
			
			props.getProperty("receipt.rdSolution.location");
			props.getProperty("receipt.mrdPath.location");
			props.getProperty("receipt.reportingServer.location");
			
//			props.getProperty("receipt.css.location");
//			props.getProperty("receipt.jquery.location");
			props.getProperty("receipt.crownix.location");
			
			mav.addObject("rdSolution", props.getProperty("receipt.rdSolution.location"));
			mav.addObject("mrdPath", props.getProperty("receipt.mrdPath.location"));
			mav.addObject("reportingServer", props.getProperty("receipt.reportingServer.location"));
			
//			mav.addObject("receiptCss", props.getProperty("receipt.css.location"));
//			mav.addObject("receiptJquery", props.getProperty("receipt.jquery.location"));
			mav.addObject("receiptCrownix", props.getProperty("receipt.crownix.location"));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		Map<String, String> realOrderNumber = UtilAPI.getInvoice(requestBox.get("purchasedate"), requestBox.get("virtualpurchasenumber"));
		Map<String, String> getReceiptTempInfo= UtilAPI.getReceipts(realOrderNumber.get("invoiceCode"));
		
		getReceiptTempInfo.put("typeName", requestBox.get("typeName"));
		getReceiptTempInfo.put("cardName", requestBox.get("cardName"));
		
		if(("0").equals(getReceiptTempInfo.get("instalment")) || ("1").equals(getReceiptTempInfo.get("instalment"))){
			tempInstalment = "일시불";
		}else{
			tempInstalment = getReceiptTempInfo.get("instalment") + " 개월";
		}
		getReceiptTempInfo.put("instalment", tempInstalment);
	
		model.addAttribute("getReceiptTempInfo", getReceiptTempInfo);
		
		return mav;
	}
}
