package amway.com.academy.reservation.roominfo.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.util.UtilAPI;
import amway.com.academy.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.reservation.roomEdu.service.RoomEduService;
import amway.com.academy.reservation.roominfo.service.RoomInfoService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;


@RequestMapping("/mobile/reservation")
@Controller
public class RoomMobileInfoController extends BasicReservationController {
	
	@Autowired
	private RoomInfoService roomInfoService;
	
	@Autowired
	private RoomEduService roomEduService;
	
	private String sRowPerPage = "20"; // 페이지에 넣을 row수
	public static final int ZERO = 0;
	
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
		ModelAndView mav = new ModelAndView("/mobile/reservation/room/roomInfoList");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		/**----------------------------검색 조건------------------------------------------*/
		mav.addObject("roomRsvTypeInfoCodeList", super.roomRsvTypeInfoCodeList());							// 시설 종류
		mav.addObject("ppCodeList", super.ppCodeList());													// pp리스트
		/**--------------------------------------------------------------------------*/
		
		/** 디폴트 날짜 검색 조건 셋팅 [2개월전 1일~현재월 마지막날 조회] */
		Map<String, String> searchThreeMonthRoom = roomInfoService.searchThreeMonthRoom(requestBox);
		model.addAttribute("searchThreeMonthRoom", searchThreeMonthRoom);
		
		/** 디폴트 날짜 검색 조건 셋팅[jsp 화면에 표현될 디폴트 날짜 값] */
		if("".equals(requestBox.get("searchStrDateMobile"))){
			requestBox.put("searchStrDateMobile", searchThreeMonthRoom.get("strdate"));
		}
		if("".equals(requestBox.get("searchEndDateMobile"))){
			requestBox.put("searchEndDateMobile", searchThreeMonthRoom.get("enddate"));
		}
		
		/** 디폴트 날짜 검색 조건 셋팅[디비 조회용 파라미터] */
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
		
		/** 기준 년도 조회 */
		mav.addObject("yearCodeList", super.reservationYearCodeList());
		
		/** 기준 둴 조회 */
		mav.addObject("monthCodeList", super.reservationFormatingMonthCodeList());
		
		/** 현재 년, 월 조회 */
		mav.addObject("yearMonthDay", roomEduService.roomEduToday());
		
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
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		
		PagingUtil.defaultParmSetting(requestBox);
		
		model.addAttribute("scrData", requestBox);
		/**--------------------------------------------------------------------------*/
		
		/** 현재 hybris의 경로 */
		mav.addObject("hybrisUrl", UtilAPI.getCurerntHybrisLocation());

		/** 체험 예약 현황 리스트 */
		mav.addObject("roomInfoList", roomInfoService.roomInfoList(requestBox));
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return mav;
	}
	
	/**
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoRsvCancelAjax.do")
	public ModelAndView roomInfoRsvCancelAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		Map<String, String> roomInfoRsvCancelPenalty = roomInfoService.roomInfoRsvCancelPenalty(requestBox);
		roomInfoRsvCancelPenalty.put("typecode", requestBox.get("typecode"));
		mav.addObject("roomInfoRsvCancelPenalty", roomInfoRsvCancelPenalty);
		
		/** 파라미터값 */
//		mav.addObject("scrData", requestBox);
		
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
		ModelAndView mav = new ModelAndView("/mobile/reservation/room/roomInfoDetailList");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 시설 예약 현황 상세 리스트 */
		List<Map<String, String>> roomInfoDetailList = roomInfoService.roomInfoDetailList(requestBox);
		mav.addObject("roomInfoDetailList", roomInfoDetailList);
		
		if(!("").equals(requestBox.get("virtualpurchasenumber"))){
			// 가상 주문 번호로 주문번호 조회
			Map<String, String> realOrderNumber = UtilAPI.getInvoice(requestBox.get("purchasedate"), requestBox.get("virtualpurchasenumber"));
			
			//카드 번호 조회
			Map<String, String> getReceiptInfo= UtilAPI.getReceipts(realOrderNumber.get("invoiceCode"));
			
			model.addAttribute("getReceiptInfo", getReceiptInfo);
		}
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		/** 파라미터값 */
		model.addAttribute("scrData", requestBox);
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
		requestBox.put("account", requestBox.getSession("abono"));
		
		/* 환불에 필요한 SSN 값 획득 */
		Map<String, String> memberInformatioin = super.reservationCheckerService.getMemberInformation(requestBox);
		String ssn = memberInformatioin.get("ssn");
		requestBox.put("ssn", ssn);
		
		
		/* ****************************************************************************** */
		int refundAmountRatio = 0;
		
		if("P".equals(requestBox.get("typecode"))){
			
			/*  패널티 적용금액을 적용 */
			Map<String,String> searchPenalty = roomInfoService.searchRoomPayPenalty(requestBox);
			
			if(searchPenalty != null){
				/* 패널티 적용비율 */
				int penaltyValue = Integer.parseInt((String)searchPenalty.get("applytypevalue"));
				/* 환불 대상 금액 */
				int paymentAmount = Integer.parseInt((String)requestBox.get("paymentamount"));
				
				refundAmountRatio = paymentAmount * penaltyValue / 100;
				
				int refundAmount = paymentAmount - refundAmountRatio;
				
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
	@RequestMapping(value = "/roomInfoRsvPaybackInfoAjax.do")
	public ModelAndView roomInfoRsvPaybackInfoAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		mav.addObject("roomInfoRsvPaybackInfo", roomInfoService.roomInfoRsvPaybackInfo(requestBox));
		
		return mav;
	}
	
	/**
	 * 상세페이지
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoMoreListAjax.do")
	public ModelAndView roomInfoMoreListAjax(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = null;
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 디폴트 날짜 검색 조건 셋팅 [2개월전 1일~현재월 마지막날 조회] */
		Map<String, String> searchThreeMonthRoom = roomInfoService.searchThreeMonthRoom(requestBox);
		model.addAttribute("searchThreeMonthRoom", searchThreeMonthRoom);
		
		/** 디폴트 날짜 검색 조건 셋팅[디비 조회용 파라미터] */
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
		if(("").equals(requestBox.getString("rowPerPage")) || ("0").equals(requestBox.getString("rowPerPage"))){
			requestBox.put("rowPerPage", sRowPerPage);
		}
		
//		if(("").equals(requestBox.getString("totalCount")) || ("0").equals(requestBox.getString("totalCount"))) {
//			/** 시설 예약 현황 리스트 카운트 */
//			pageVO.setTotalCount(roomInfoService.roomInfoListCount(requestBox));
//			requestBox.put("totalPage", pageVO.getTotalPages());
//			requestBox.put("firstIndex", 1);
//		} else {
//			pageVO.setTotalCount(requestBox.getString("totalCount"));
//		}
//		
//		pageVO.setPage(requestBox.getString("page"));
//		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
//		requestBox.putAll(pageVO.toMapData());
//		
//		PagingUtil.defaultParmSetting(requestBox);
		
		
		pageVO.setTotalCount(roomInfoService.roomInfoListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.get("page"));
		pageVO.setRowPerPage(requestBox.get("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}

		PagingUtil.defaultParmSetting(requestBox);
		
		
		/**--------------------------------------------------------------------------*/
		
		/** 체험 예약 현황 리스트 */
		model.addAttribute("roomInfoList", roomInfoService.roomInfoList(requestBox));
		
		model.addAttribute("scrData", requestBox);
		
		mav = new ModelAndView("/mobile/reservation/room/roomInfoMoreList");
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return mav;
	}
	
	/**
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/showRoomRsvReceiptPop.do")
	public ModelAndView roomInfoRsvPaybackInfoPopAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/mobile/reservation/room/showRoomRsvReceiptPop");
		
		String tempInstalment;
		
		Map<String, String> realOrderNumber = UtilAPI.getInvoice(requestBox.get("purchasedate"), requestBox.get("virtualpurchasenumber"));
		Map<String, String> getReceiptTempInfo= UtilAPI.getReceipts(realOrderNumber.get("invoiceCode"));
		
		getReceiptTempInfo.put("typeName", requestBox.get("tempTypeName"));
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
