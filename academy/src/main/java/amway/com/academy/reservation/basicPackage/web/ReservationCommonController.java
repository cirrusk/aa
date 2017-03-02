package amway.com.academy.reservation.basicPackage.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSessionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.util.UtilAPI;
import amway.com.academy.reservation.basicPackage.service.ReservationCheckerService;
import framework.com.cmm.lib.RequestBox;

/**
 * <pre>
 * </pre>
 * Program Name  : ReservationCommonController.java
 * Author : KR620207
 * Creation Date : 2016. 8. 29.
 */
@RequestMapping("/reservation")
@Controller
public class ReservationCommonController extends BasicReservationController {


	private static final Logger LOGGER = LoggerFactory.getLogger(ReservationCommonController.class);
	
	/** 공통 코드 서비스 */
	@Autowired
	private ReservationCheckerService reservationCheckerService;
	
	/**
	 * <pre>
	 * 예약 화면에서, '월'을 클릭시 해당월에 잔여 예약일을 표시해주는 기능
	 * 
	 * required member variables
	 * - account
	 * - reservationdate
	 * - rsvtypecode
	 * - ppseq
	 * - typeseq
	 * - roomseq/expseq
	 * 
	 * </pre>
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getRemainDayByMonthAjax.do", method = RequestMethod.GET)
	public ModelAndView getRemainDayByMonthAjax(ModelMap model, RequestBox requestBox) throws Exception {
		ModelAndView mav = new ModelAndView("jsonView");
		
		int limitedDays = 0;
		int usedDays = 0;
		
		try{
			/* 세션으로부터 abono 획득 */
			requestBox.put("account", requestBox.getSession("abono"));
			
			Map member = reservationCheckerService.getMemberInformation(requestBox);
			requestBox.put("pinvalue", 			member.get("pinvalue"));
			requestBox.put("citygroupcode", 	member.get("citygroupcode"));
			requestBox.put("age", 				member.get("age"));
			requestBox.put("cookmastercode",	member.get("cookmastercode"));
			
			limitedDays = reservationCheckerService.getPrimiumCountByRegion(requestBox);
			LOGGER.debug("limitedDays : {}", limitedDays);
			
			usedDays = reservationCheckerService.getMonthlyReservedCountByRegion(requestBox);
			LOGGER.debug("usedDays : {}", usedDays);
		}catch(SqlSessionException e){
			LOGGER.error(e.getMessage(), e);
		}
		
		int remainDays = (limitedDays - usedDays) < 0 ? 0 : limitedDays - usedDays;
		
		mav.addObject("remainDay", remainDays);
		return mav;
	}

	/**
	 * facebook 링크
	 * @param request
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/simpleReservation.do", method=RequestMethod.GET)
	public String simpleReservation(HttpServletRequest request, ModelMap model, RequestBox requestBox) throws Exception {
		
		LOGGER.debug("invoke simpleReservation.do");
		
		String transactionTime = requestBox.get("reservation");
		
		List<Map<String, String>> reservationInfo = null; 
		StringBuffer rsvDescription = new StringBuffer();
		
		StringBuffer reserveData = new StringBuffer();
		reserveData.delete(0, reserveData.length());
		
		if(null != transactionTime && !"".equals(transactionTime)) {
			
			requestBox.put("transactionTime", transactionTime);
			
			reservationInfo = super.basicReservationService.simpleReservationDataByTransaction(requestBox);
			
			for(Map<String, String> reservationObj : reservationInfo){
				
				//String rsvSeq = reservationObj.get("rsvSeq");
				String ppName = reservationObj.get("ppName");
				String reservationName = reservationObj.get("reservationName");
				String reservationDate = reservationObj.get("reservationDate");
				String sessionName = reservationObj.get("sessionName");
				String startdateTime = reservationObj.get("startdateTime");
				String enddateTime = reservationObj.get("enddateTime");
				
				reserveData
					.append("# ")
					.append(ppName).append(" (")
					.append(reservationName).append(") | ")
					.append(reservationDate).append(" | ")
					.append(sessionName).append(" | (")
					.append(startdateTime).append(" ~ ")
					.append(enddateTime).append(")  ");
				
				LOGGER.debug("reserveData :{}", reserveData.toString());
			}
			
		}
		
		LOGGER.debug("rsvDescription :{}", reserveData.toString());
		LOGGER.debug("currentDomain  :{}", UtilAPI.getCurrentServerLocation());
		LOGGER.debug("hybrisUrl      :{}", UtilAPI.getCurerntHybrisLocation());
		
		model.put("rsvSeq", transactionTime);
		model.put("rsvDescription", reserveData.toString());
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		model.addAttribute("hybrisUrl", UtilAPI.getCurerntHybrisLocation());
		
		return "/reservation/room/simpleReservation";
	}
	
	/**
	 * 누적 예약 가능 횟수 (월, 주, 일) 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getRsvAvailabilityCountAjax.do", method = RequestMethod.POST)
	public ModelAndView getRsvAvailabilityCountAjax(ModelMap model, RequestBox requestBox) throws Exception {
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		/* 세션으로부터 abono 획득 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		if (requestBox.getSession("abono") == "" || requestBox.getSession("abono") == null) {
			
			// NONMEMBERID SET
			
			// requestBox.put("account", requestBox.get("nonmemberid"));
		}
		
		mav.addObject("getRsvAvailabilityCount", reservationCheckerService.getRsvAvailabilityCount(requestBox));
		
		return mav;
	}
	
	/**
	 * 누적예약 가능 횟수 예약가능 체크 기능
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/rsvAvailabilityCheckAjax.do", method = RequestMethod.POST)
	public ModelAndView rsvAvailabilityCheckAjax(ModelMap model, RequestBox requestBox) throws Exception {
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		/* 세션으로부터 abono 획득 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		mav.addObject("rsvAvailabilityCheck", reservationCheckerService.rsvAvailabilityCheck(requestBox));
		
		return mav;
	}
	
	/**
	 * 요리명장 누적예약 가능 횟수 예약가능 체크 기능
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/cookMasterRsvAvailabilityCheckAjax.do", method = RequestMethod.POST)
	public ModelAndView cookMasterRsvAvailabilityCheckAjax(ModelMap model, RequestBox requestBox) throws Exception {
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		/* 세션으로부터 abono 획득 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		mav.addObject("cookMasterRsvAvailabilityCheck", reservationCheckerService.cookMasterRsvAvailabilityCheck(requestBox));
		
		return mav;
	}
	
	@RequestMapping(value="/rsvMiddlePenaltyCheckAjax.do", method = RequestMethod.POST)
	public ModelAndView rsvMiddlePenaltyCheckAjax(ModelMap model, RequestBox requestBox) throws Exception {
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		/* 세션으로부터 abono 획득 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		mav.addObject("middlePenaltyCheck", reservationCheckerService.rsvMiddlePenaltyCheck(requestBox));
		
		return mav;
	}
	
	/**
	 * ap 정보 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchApInfoAjax.do", method = RequestMethod.POST)
	public ModelAndView showApInfoAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");

		Map apInfoMap = null;
		
		try{
			apInfoMap = UtilAPI.getApInfo();
			
			
		}catch(SqlSessionException e){
			LOGGER.error(e.getMessage(), e);
		}
		
		
		LOGGER.debug("apInfoMap : {}",apInfoMap);
		
		mav.addObject("ppCodeList", super.ppCodeList());
		mav.addObject("ppInfo", apInfoMap);
		
		return mav;
	}
	
	
	/**
	 * 약관 및 동의 전체보기
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomIntroduceInfoPop.do", method = RequestMethod.POST)
	public ModelAndView roomIntroduceInfoPop(ModelMap model, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = new ModelAndView();
		
		if("eduroom".equals(requestBox.get("clauseType"))){	// 교육장(퀸룸)
			mav.setViewName("/reservation/room/clauseEduRoomPop");
			model.put("clause01", super.getClauseContentsRoleAgreement());
			model.put("clause02", super.getClauseContentsAttentionAgreement());
			
		}else if("bizroom".equals(requestBox.get("clauseType"))){	// 비즈룸
			mav.setViewName("/reservation/room/clauseBizRoomPop");
			model.put("clause05", super.getClauseContentsRoomEducateAgreement());
			model.put("clause02", super.getClauseContentsAttentionAgreement());
			
		}
		
		return mav;
	}

	/**
	 * 환불처리 - interface 연동
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/itemRefundProcessAjax.do", method = RequestMethod.POST)
	public ModelAndView itemRefundProcess(ModelMap model, RequestBox requestBox) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		/* 결재모듈 */
		Map resultObject = super.interfaceRefund(requestBox);
		String status = (String)resultObject.get("status");
		String errorMsg = (String)resultObject.get("errorMsg");
		
		if("SUCCESS".equals(status)){
			LOGGER.debug("환불 처리 성공");
		} else {
			LOGGER.debug("환불 처리 실패 : {}", errorMsg);
			mav.addObject("possibility", "false");
			mav.addObject("reason", errorMsg);
			return mav;
		}
		
		return mav;
	}
}
