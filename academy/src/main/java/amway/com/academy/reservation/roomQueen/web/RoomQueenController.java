package amway.com.academy.reservation.roomQueen.web;

import java.util.List;
import java.util.Map;

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
import amway.com.academy.reservation.roomEdu.service.impl.RoomEduServiceImpl;
import amway.com.academy.reservation.roomQueen.service.RoomQueenService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;


@RequestMapping("/reservation")
@Controller
public class RoomQueenController extends BasicReservationController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(BasicReservationController.class);
	
	@Autowired
	private RoomQueenService roomQueenService;
	
	/** 공통 코드 서비스 */
	@Autowired
	private BasicReservationService basicReservationService;
	
	/** adobe analytics */
	@Autowired
	private CommomCodeUtil commonCodeUtil;

	/**
	 * 체성분 측정 예약 페이지 호출
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomQueenForm.do")
	public String roomQueenInsertForm(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/* 약관 1,2,3,4 */
		model.put("clause01", super.getClauseContentsRoleAgreement());
		model.put("clause02", super.getClauseContentsAttentionAgreement());
		model.put("clause03", super.getClauseContentsPurchaseAgreement());
		model.put("clause04", super.getClauseContentsPrivateAgreement());
		
		/* 시설 타입(형태)별 필수안내 */
		model.put("reservationInfo", super.getReservationInfoByType("퀸룸"));
		
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
		
		/* API URL for only SNS */
		//model.addAttribute("httpDomain", UtilAPI.getApiLocation());
		model.addAttribute("httpDomain", "www.abnkorea.co.kr");
		
		/* CURRENT SERVER URL (FOR EASY-PAY) */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());		

		/** 예약 현황 확인시 페이지 이동에 필요한 현재 hybris의 경로 */
		model.addAttribute("hybrisUrl", UtilAPI.getCurerntHybrisLocation());
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return "/reservation/room/roomQueen";
	}
	
	/**
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomQueenReservOk.do")
	public String reservationComplete(ModelMap model, RequestBox requestBox) throws Exception {
		
		LOGGER.debug("requestBox {}", requestBox);
		
		return "/mobile/reservation/room/roomQueenReservOk";
	}
	
	/**
	 * 교육장 예약 PP 목록 조회
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomQueenPpInfoListAjax.do", method = RequestMethod.POST)
	public ModelAndView roomQueenPpInfoListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 해당 pp조회  */
		List<Map<String, String>> ppRsvRoomCodeList = roomQueenService.ppRsvRoomQueenCodeList(requestBox);
		mav.addObject("ppRsvRoomCodeList", ppRsvRoomCodeList);
		
		/** 마지막으로 예약한 pp정보 조회 */
		//Map<String, String> searchLastRsvRoomPp = roomEduService.searchLastRsvRoomPp(requestBox);
		Map<String, String> searchLastRsvRoomPp = basicReservationService.searchLastRsvPp(requestBox);
		mav.addObject("searchLastRsvRoomPp", searchLastRsvRoomPp);
		
		return mav;
	}

	/**
	 * 요리명장 쿠폰 갯수 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getCookMasterCouponAjax.do", method = RequestMethod.POST)
	public ModelAndView getCookMasterCouponAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** 요리명장 사용가능 쿠폰 갯수 조회  */
		requestBox.put("account", requestBox.getSession("abono"));
		Map<String, String> getCookMasterCoupon = roomQueenService.getCookMasterCoupon(requestBox);
		mav.addObject("getCookMasterCoupon", getCookMasterCoupon);
		
		return mav;
	}

}
