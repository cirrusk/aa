package amway.com.academy.reservation.roomBiz.web;

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
import amway.com.academy.reservation.basicPackage.service.BasicReservationService;
import amway.com.academy.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.reservation.roomBiz.service.RoomBizService;
import amway.com.academy.reservation.roomEdu.service.RoomEduService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;


@RequestMapping("/mobile/reservation")
@Controller
public class RoomMobileBizController extends BasicReservationController {
	
	@Autowired
	private RoomBizService roomBizService;
	
	/** 공통 코드 서비스 */
	@Autowired
	private BasicReservationService basicReservationService;

	@RequestMapping(value = "/roomBizForm.do")
	public String roomEduInsertForm(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		/* 시설 타입(형태)별 필수안내 */
		model.put("reservationInfo", super.getReservationInfoByType("비즈룸"));
		
		/* 약관 1,2,3,4 */
		model.put("clause02", super.getClauseContentsAttentionAgreement());
		model.put("clause05", super.getClauseContentsRoomEducateAgreement());
		
		/** ----------------APinfo 정보--------------------------- */
		Map testAPI = UtilAPI.getApInfo();
		model.addAttribute("result", testAPI);
		
		//이미지 경로에 사용될 HybrisUrl
		String curerntHybrisLocation = UtilAPI.getCurerntHybrisLocation();
		model.addAttribute("curerntHybrisLocation", curerntHybrisLocation);
		/** --------------------------------------------------- */
		
		/* for facebook */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
		model.addAttribute("httpDomain", "www.abnkorea.co.kr");
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics

		return "/mobile/reservation/room/roomBiz";
	}
	
	/**
	 * 교육장 예약 PP 목록 조회
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomBizPpInfoListAjax.do", method = RequestMethod.POST)
	public ModelAndView roomEduPpInfoListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** session id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 해당 pp조회  */
		List<Map<String, String>> ppRsvRoomCodeList = roomBizService.ppRsvRoomBizCodeList(requestBox);
		mav.addObject("ppRsvRoomCodeList", ppRsvRoomCodeList);
		
		/** 마지막으로 예약한 pp정보 조회 */
		//Map<String, String> searchLastRsvRoomPp = roomEduService.searchLastRsvRoomPp(requestBox);
		Map<String, String> searchLastRsvRoomPp = basicReservationService.searchLastRsvPp(requestBox);
		mav.addObject("searchLastRsvRoomPp", searchLastRsvRoomPp);
		
		return mav;
	}
	
	/**
	 * 예약 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomBizPaymentCheckAjax.do", method = RequestMethod.POST)
	public ModelAndView roomBizPaymentCheckAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> cancelDataList = roomBizService.roomBizPaymentCheck(requestBox);
		mav.addObject("cancelDataList", cancelDataList);
		
		return mav;
	}
	
	/**
	 * 예약정보 확인 팝업(정상 진행)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomBizInfoPop.do", method = RequestMethod.POST)
	public ModelAndView roomBizPaymentInfoPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/room/roomBizInfoPop");
		
		List<Map<String, String>> roomEduPaymentInfoList = roomBizService.roomBizPaymentInfoPop(requestBox);
		mav.addObject("roomBizInfoList", roomEduPaymentInfoList);
		
		mav.addObject("reqData", requestBox);
		
		return mav;
	}
}
