package amway.com.academy.reservation.expCulture.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import amway.com.academy.reservation.expCulture.service.ExpCultureService;
import amway.com.academy.reservation.expHealth.web.ExpMobileHealthController;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;

/**
 * <pre>
 * 문화체험 CONTROLLER
 * </pre>
 * Program Name  : ExpCultureController.java
 * Author : KR620226
 * Creation Date : 2016. 8. 31.
 */
@RequestMapping("/mobile/reservation")
@Controller
public class ExpMobileCultureController extends BasicReservationController{
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExpMobileCultureController.class);
	 
	/** 공통 코드 서비스 */
	@Autowired
	private BasicReservationService basicReservationService;

	/** 공통 코드 서비스 */
	@Autowired
	private ExpCultureService expCultureService;
	
	/**
	 * 문화체험 초기화면 (날짜먼저선택)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureForm.do")
	public String expCultureForm(HttpServletRequest request, HttpServletResponse response, ModelMap model, RequestBox requestBox) throws Exception{
		LOGGER.debug("===============> 문화 체험 예약 : " + request.getRequestURI()  );
		LOGGER.debug("===============> 문화 체험 예약 Session : " + requestBox.getSessionId());
		
		/* 시설 타입(형태)별 필수안내 */
		model.put("reservationInfo", super.getReservationInfoByType("문화체험"));
		
		requestBox.put("account", requestBox.getSession("abono"));

		/** 공통 년도 */
		model.addAttribute("reservationYearCodeList", super.reservationYearCodeList());
		
		/** 공통 월 */
		model.addAttribute("reservationFormatingMonthCodeList", super.reservationFormatingMonthCodeList());
		model.addAttribute("httpDomain", "www.abnkorea.co.kr");
		
		/** ----------------APinfo 정보--------------------------- */
		Map testAPI = UtilAPI.getApInfo();
		model.addAttribute("result", testAPI);
		
		//이미지 경로에 사용될 HybrisUrl
		String curerntHybrisLocation = UtilAPI.getCurerntHybrisLocation();
		model.addAttribute("curerntHybrisLocation", curerntHybrisLocation);
		/** --------------------------------------------------- */
		model.addAttribute("result", testAPI);
		
		/* for facebook */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
		/* sso 체크해서 세션 삭제 */
		boolean isValidSession = super.checkSso(request,response);
//2017.01.17 수정
		log.debug("!isValidSession");		
		if(!isValidSession){
			log.debug("!isValidSession IN");
			if ( null != request.getSession()){
				log.debug("null != request.getSession(");
				request.getSession().invalidate();

				requestBox.put("account", "");
				requestBox.put("session", "");
			}
		}
//2017.01.17 수정
		if("".equals(requestBox.get("account"))){
			requestBox.put("pinvalue", "-99");
		}else{
			/** 회원의 경우 */
			Map<String, String> userInfo = super.reservationCheckerService.getMemberInformation(requestBox);

			requestBox.put("pinvalue", userInfo.get("pinvalue"));
			requestBox.put("infoAge", userInfo.get("age"));
			requestBox.put("infoCityGroupCode", userInfo.get("citygroupcode"));
		}

//2017.01.17 수정
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics
//2017.01.17 수정

		model.addAttribute("scrData", requestBox);

		return "/mobile/reservation/exp/expCulture";
	}

	/**
	 * 문화체험 초기화면 (프로그램먼저선택)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureProgramForm.do")
	public String expCultureProgramForm(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		/* 시설 타입(형태)별 필수안내 */
		model.put("reservationInfo", super.getReservationInfoByType("문화체험"));
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		if("".equals(requestBox.get("account"))){
			requestBox.put("pinvalue", "-99");
		}else{
			/** 회원의 경우 */
			Map<String, String> aboMap = super.reservationCheckerService.getMemberInformation(requestBox);
			
			requestBox.put("pinvalue", aboMap.get("pinvalue"));
		}
		
		model.addAttribute("scrData", requestBox);
		model.addAttribute("httpDomain", "www.abnkorea.co.kr");
		
		/** 공통 년도 */
		model.addAttribute("reservationYearCodeList", super.reservationYearCodeList());
		
		/** 공통 월 */
		model.addAttribute("reservationFormatingMonthCodeList", super.reservationFormatingMonthCodeList());
		
		/** ----------------APinfo 정보--------------------------- */
		Map testAPI = UtilAPI.getApInfo();
		model.addAttribute("result", testAPI);
		
		//이미지 경로에 사용될 HybrisUrl
		String curerntHybrisLocation = UtilAPI.getCurerntHybrisLocation();
		model.addAttribute("curerntHybrisLocation", curerntHybrisLocation);
		/** --------------------------------------------------- */
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return "/mobile/reservation/exp/expCultureProgram";
	}
	
	/**
	 * 문화 체험에 속한 pp정보 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCulturePpInfoListAjax.do", method = RequestMethod.POST)
	public ModelAndView expCulturePpInfoListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 해당 pp조회  */
		List<Map<String, String>> ppRsvCodeList = expCultureService.ppRsvCodeList(requestBox);
		mav.addObject("ppCodeList", ppRsvCodeList);
		
		/** 마지막으로 예약한 pp정보 조회 */
		Map<String, String> searchLastRsvPp = basicReservationService.searchLastRsvPp(requestBox);
		mav.addObject("searchLastRsvPp", searchLastRsvPp);
		
		return mav;
	}

	/**
	 * 문화체험 날짜 정보 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureCalendarAjax.do", method = RequestMethod.POST)
	public ModelAndView expCultureCalendarAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 비회원의 경우 */
		if("".equals(requestBox.get("account"))){
			requestBox.put("pinvalue", "-99");
		}else{
			/** 회원의 경우 */
			requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		}
		
		/** 년, 월  조회(jsp에서 클래스 명으로 사용)*/
		List<Map<String, String>> expCultureYearMonth = expCultureService.expCultureYearMonth(requestBox);
		mav.addObject("expCultureYearMonth", expCultureYearMonth);
		
		/** 해당 pp, 해당 년, 월 의 예약가능한 프로그램이 있는 날짜 조회 */
		List<Map<String, String>> expCultureDayInfoList = expCultureService.expCultureDayInfoList(requestBox);
		mav.addObject("expCultureDayInfoList", expCultureDayInfoList);

		/** 오늘 날짜 조회 */
		Map<String, String> expCultureToday = expCultureService.expCultureToday();
		mav.addObject("expCultureToday", expCultureToday);
		
		return mav;
	}

	/**
	 * 문화체험 pp별 해당 날짜의 예약 가능한 프로그램 목록 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureProgramListAjax.do", method = RequestMethod.POST)
	public ModelAndView expCultureProgramListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		
		/** 비회원의 경우 */
		if("".equals(requestBox.get("account"))){
			requestBox.put("pinvalue", "-99");
		}else{
			/** 회원의 경우 */
			requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		}
		
		List<Map<String, String>> expCultureProgramList = expCultureService.expCultureProgramList(requestBox);
		mav.addObject("expCultureProgramList", expCultureProgramList);
		
		return mav;
	}

	/**
	 * 문화체험 예약 요청 팝업
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureRsvRequestPop.do", method = RequestMethod.POST)
	public ModelAndView expCultureRsvRequestPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/exp/expCultureRsvRequestPop");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		List<Map<String, String>> expCultureProgramList = expCultureService.expCultureRsvRequest(requestBox);
		mav.addObject("expCultureProgramList", expCultureProgramList);
		
		return mav;
	}

	/**
	 * 문화체험 예약 확정
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureRsvInsertAjax.do", method = RequestMethod.POST)
	public ModelAndView expCultureRsvInsertAjax(ModelMap model, RequestBox requestBox) throws Exception{
		
		LOGGER.debug("invoke expCultureRsvInsertAjax");
		LOGGER.debug("requestBox {}", requestBox);
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
//		//예약 대기자 조회[같은 세션을 선점할 경우 늦게 insert한 사용자는  다른 사용자가 먼저 선점하여 등록이 불가 하다라는 메세지를 뿌려줌]
//		Map<String, String> standByNumberAdvanceChecked = expCultureService.expCultureStandByNumberAdvanceChecked(requestBox);
//		
//		if ( !standByNumberAdvanceChecked.isEmpty() ) {
//			if("false".equals(standByNumberAdvanceChecked.get("msg"))){
//				mav.addObject("possibility", standByNumberAdvanceChecked.get("msg"));
//				mav.addObject("reason", standByNumberAdvanceChecked.get("reason"));
//				return mav;
//			}
//		}		
		
		List<Map<String, String>> expCultureCompleteList = expCultureService.expCultureRsvInsert(requestBox);
		
		for( int i=0; i<expCultureCompleteList.size(); i++ ) {
			Map<String, String> resultMap = expCultureCompleteList.get(i);
			
			if( resultMap.get("paymentStatusCode").equals("P03") ) {
				mav.addObject("possibility", "false");
				mav.addObject("reason", "예약 마감 프로그램이 존재 합니다.\n재 확인 후 예약신청 해 주세요.");
				return mav;
			}
		}
		
		mav.addObject("expCultureCompleteList", expCultureCompleteList);
		
		/* for facebook */
		String transactionTime = (String) requestBox.getVector("transactionTime").get(0);
		mav.addObject("transactionTime", transactionTime);
		
		return mav;
	}
	
	/**
	 * 해당 pp 프로그램 목록 조회(2달)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCulturePpProgramListAjax.do", method = RequestMethod.POST)
	public ModelAndView expCulturePpProgramListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 비회원의 경우 */
		if("".equals(requestBox.get("account"))){
			requestBox.put("pinvalue", "-99");
		}else{
			/** 회원의 경우 */
			requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		}
		
		List<Map<String, String>> expCulturePpProgramList = expCultureService.expCulturePpProgramList(requestBox);
		mav.addObject("expCulturePpProgramList", expCulturePpProgramList);
		
		return mav;
	}

	/**
	 * 해당 pp 프로그램 별 세션 정보 조회 (2달)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureSessionListAjax.do", method = RequestMethod.POST)
	public ModelAndView expCultureSessionListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 비회원의 경우 */
		if("".equals(requestBox.get("account"))){
			requestBox.put("pinvalue", "-99");
		}else{
			/** 회원의 경우 */
			requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		}
		
		List<Map<String, String>> expCultureSessionList = expCultureService.expCultureSessionList(requestBox);
		mav.addObject("expCultureSessionList", expCultureSessionList);
		
		return mav;
	}
	
	/**
	 * 문화체험 예약현황 목록 조회 모바일
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureInfoList.do")
	public ModelAndView expCultureInfoList(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/mobile/reservation/exp/expCultureInfoList");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 체험 예약 현황 리스트 */
		mav.addObject("expCultureInfoList", expCultureService.expCultureInfoListMobile(requestBox));
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics

		return mav;
	}
	
	/**
	 * 해당 프로그램 예약 가능 참석 인원수 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureSeatCountSelectAjax.do", method = RequestMethod.POST)
	public ModelAndView expCultureSeatCountSelectAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		mav.addObject("expCultureSeatCount", expCultureService.expCultureSeatCountSelect(requestBox));
		
		return mav;
	}

	/**
	 * 해당 예약 정보 참석자 수정
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureVisitNumberUpdateAjax.do", method = RequestMethod.POST)
	public ModelAndView expCultureVisitNumberUpdateAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		mav.addObject("expCultureSeatCount", expCultureService.expCultureVisitNumberUpdate(requestBox));
		
		return mav;
	}

	/**
	 * 문화체험 예약 취소
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureCancelUpdateAjax.do", method = RequestMethod.POST)
	public ModelAndView expCultureCancelUpdateAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		expCultureService.expCultureCancelUpdate(requestBox);
		
		return mav;
	}

	/**
	 * 문화체험 비회원 정보 체크 화면
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureNonmemberIdCheckForm.do", method = RequestMethod.POST)
	public ModelAndView expCultureNonmemberIdCheckForm(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/mobile/reservation/exp/expCultureNonmemberIdCheck");
		
		mav.addObject("expCultureInfoList", expCultureService.expCultureNonmemberIdCheckForm(requestBox));
		
		return mav;
	}

	/**
	 * 문화체험 비회원일 경우 예약 팝업에서 부모창으로 수정된 데이터 전송
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCulturePopToParentAjax.do", method = RequestMethod.POST)
	public ModelAndView expCulturePopToParentAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		mav.addObject("expCultureInfoList", expCultureService.expCultureNonmemberIdCheckForm(requestBox));
		
		return mav;
	}
	
	/**
	 * 문화 체험 소개 목록 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureIntroduceList.do", method = RequestMethod.POST)
	public ModelAndView expCultureIntroducePop(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		mav.addObject("expCultureIntroduceList", expCultureService.expCultureIntroduceList(requestBox));
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return mav;
	}
	
	/**
	 * 비회원 예약 완료
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureNonmemberComplete.do")
	public ModelAndView expCultureNonmemberComplete(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/mobile/reservation/exp/expCultureNonmemberComplete");
		
		List<Map<String, String>> expCultureCompleteList = expCultureService.expCultureNonmemberComplete(requestBox);
		mav.addObject("expCultureCompleteList", expCultureCompleteList);
		
		return mav;
	}
}
