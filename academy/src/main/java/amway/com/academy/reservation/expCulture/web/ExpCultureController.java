package amway.com.academy.reservation.expCulture.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.aspectj.weaver.patterns.ThisOrTargetAnnotationPointcut;
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
import amway.com.academy.reservation.expBrand.web.ExpBrandController;
import amway.com.academy.reservation.expCulture.service.ExpCultureService;
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
@RequestMapping("/reservation")
@Controller
public class ExpCultureController extends BasicReservationController{
	
	private final Logger log = LoggerFactory.getLogger(this.getClass());
 
	
	/** 공통 코드 서비스 */
	@Autowired
	private BasicReservationService basicReservationService;

	/** 공통 코드 서비스 */
	@Autowired
	private ExpCultureService expCultureService;
	
	/** adobe analytics */
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	private String sRowPerPage = "10"; // 페이지에 넣을 row수
	
	/**
	 * 문화체험 초기화면 (날짜먼저선택)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureForm.do")
	public String expCultureForm(HttpServletRequest request, HttpServletResponse response, ModelMap model, RequestBox requestBox) throws Exception{
		
		/* 시설 타입(형태)별 필수안내 */
		model.put("reservationInfo", super.getReservationInfoByType("문화체험"));
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** ----------------APinfo 정보--------------------------- */
		Map testAPI = UtilAPI.getApInfo();
		model.addAttribute("result", testAPI);
		
		//이미지 경로에 사용될 HybrisUrl
		String curerntHybrisLocation = UtilAPI.getCurerntHybrisLocation();
		model.addAttribute("curerntHybrisLocation", curerntHybrisLocation);
		/** --------------------------------------------------- */
		
		/** 예약 현황 확인시 페이지 이동에 필요한 현재 hybris의 경로 */
		model.addAttribute("hybrisUrl", UtilAPI.getCurerntHybrisLocation());
		
		/** 현재 AI의 경로 */
		model.addAttribute("currentDomain", UtilAPI.getCurerntHybrisLocation());

		/* sso 체크해서 세션 삭제 */
		boolean isValidSession = super.checkSso(request,response);
		
//2017.01.16 수정
		log.debug("!isValidSession");
		if(!isValidSession){
			log.debug("!isValidSession IN");
			if ( null != request.getSession()){
				log.debug("null != request.getSession(");
				/* destroy session */
				request.getSession().invalidate();
				/* destroy account */
				requestBox.put("account", "");
				requestBox.put("session", "");
			}
		}/*else{
			return "/reservation/exp/noPage";
		}*/
//2017.01.16 수정	
		
//		model.addAttribute("httpDomain", UtilAPI.getApiLocation());
		model.addAttribute("httpDomain", "www.abnkorea.co.kr");
		
		if("".equals(requestBox.get("account"))){
			requestBox.put("pinvalue", "-99");
		}else{
			/** 회원의 경우 */
			Map<String, String> userInfo = super.reservationCheckerService.getMemberInformation(requestBox);
			
			requestBox.put("pinvalue", userInfo.get("pinvalue"));
			requestBox.put("infoAge", userInfo.get("age"));
			requestBox.put("infoCityGroupCode", userInfo.get("citygroupcode"));
		}

		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		model.addAttribute("srcData", requestBox);
		

		return "/reservation/exp/expCulture";
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
		
		/** ----------------APinfo 정보--------------------------- */
		Map testAPI = UtilAPI.getApInfo();
		model.addAttribute("result", testAPI);
		
		//이미지 경로에 사용될 HybrisUrl
		String curerntHybrisLocation = UtilAPI.getCurerntHybrisLocation();
		model.addAttribute("curerntHybrisLocation", curerntHybrisLocation);
		
		/** 현재 AI의 경로 */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		/** --------------------------------------------------- */
		
		model.addAttribute("httpDomain", UtilAPI.getApiLocation());
		
		/** 예약 현황 확인시 페이지 이동에 필요한 현재 hybris의 경로 */
		model.addAttribute("hybrisUrl", UtilAPI.getCurerntHybrisLocation());
		
		if("".equals(requestBox.get("account"))){
			requestBox.put("pinvalue", "-99");
		}else{
			/** 회원의 경우 */
			requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		}
		
		model.addAttribute("srcData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return "/reservation/exp/expCultureProgram";
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
	@RequestMapping(value = "/expCultureRsvInsertAjax.do")
	public ModelAndView expCultureRsvInsertAjax(ModelMap model, RequestBox requestBox) throws Exception{
		
		log.debug("invoke expCultureRsvInsertAjax");
		log.debug("requestBox : {}", requestBox);
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		//예약 대기자 조회[같은 세션을 선점할 경우 늦게 insert한 사용자는  다른 사용자가 먼저 선점하여 등록이 불가 하다라는 메세지를 뿌려줌]
//		Map<String, String> standByNumberAdvanceChecked = expCultureService.expCultureStandByNumberAdvanceChecked(requestBox);
//		
//		if("false".equals(standByNumberAdvanceChecked.get("standbynumber"))){
//			mav.addObject("possibility", standByNumberAdvanceChecked.get("standbynumber"));
//			mav.addObject("reason", "예약인원이 초과되어 예약 할 수 없습니다.");
//			return mav;
//		} 
		
		List<Map<String, String>> expCultureCompleteList = expCultureService.expCultureRsvInsert(requestBox);
		mav.addObject("expCultureCompleteList", expCultureCompleteList);
		
		/** for facebook */
		String transactionTime = (String) requestBox.getVector("transactionTime").get(0);
		mav.addObject("transactionTime", transactionTime);

		log.debug("requestBox : {}", requestBox);
		
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
	 * 문화체험 프로그램 먼저선택 예약 요청 팝업
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureProgramRsvRequestPop.do", method = RequestMethod.POST)
	public ModelAndView expCultureProgramRsvRequestPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/exp/expCultureProgramRsvRequestPop");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		List<Map<String, String>> expCultureProgramList = expCultureService.expCultureRsvRequest(requestBox);
		mav.addObject("expCultureProgramList", expCultureProgramList);
		
		return mav;
	}
	
	/**
	 * 비회원 전용 (미사용)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureInfoList.do")
	public ModelAndView expCultureInfoList(ModelMap model, RequestBox requestBox) throws Exception{
		
		if (!("").equals(requestBox.getSession("abono"))) {
			return new ModelAndView("redirect:/reservation/expInfoList.do");
		}
		
		ModelAndView mav = new ModelAndView("/reservation/exp/expCultureInfoList");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/**----------------------------페이징-------------------------------------------*/
		PageVO pageVO = new PageVO(requestBox);		
		if(("").equals(requestBox.getString("page")) 
				|| ("0").equals(requestBox.getString("page"))){
			requestBox.put("page", "1");
		}
		
		if("".equals(requestBox.getString("rowPerPage"))){
			requestBox.put("rowPerPage", sRowPerPage);
		}
		
		if(("").equals(requestBox.getString("totalCount"))
				|| ("0").equals(requestBox.getString("totalCount"))) {
			/** 체험 얘약 현황 리스트 카운트 */
			pageVO.setTotalCount(expCultureService.expCultureInfoListCount(requestBox));
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
		model.addAttribute("hybrisDomain", UtilAPI.getCurerntHybrisLocation());
//		System.out.println(requestBox);
		/**--------------------------------------------------------------------------*/
		
		/** 체험 예약 현황 리스트 */
		mav.addObject("expCultureInfoList", expCultureService.expCultureInfoList(requestBox));
		
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
		ModelAndView mav = new ModelAndView("/reservation/exp/expCultureNonmemberIdCheck");
		
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
	 * 문화 체험 소개 팝업
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureIntroducePop.do", method = RequestMethod.POST)
	public ModelAndView expCultureIntroducePop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/exp/expCultureIntroducePop");
		
		mav.addObject("expCultureIntroduceList", expCultureService.expCultureIntroduceList(requestBox));
		
		mav.addObject("tempexpseq", requestBox.get("tempexpseq"));
		
		return mav;
	}
	
	/**
	 * 비회원 본인 인증 번호 발송
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureAuthenticationNumberSendAjax.do", method = RequestMethod.POST)
	public ModelAndView expCultureAuthenticationNumberSendAjax(ModelMap model, RequestBox requestBox, HttpServletRequest request) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		mav.addObject("expCultureAuthenticationInfo", expCultureService.expCultureAuthenticationNumberSend(requestBox, request));
		
		return mav;
	}

	/**
	 * 비회원 본인 인증 번호 체크
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureAuthenticationNumberCheckAjax.do", method = RequestMethod.POST)
	public ModelAndView expCultureAuthenticationNumberCheckAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		mav.addObject("expCultureAuthenticationCheckInfo", expCultureService.expCultureAuthenticationNumberCheck(requestBox));
		
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
		ModelAndView mav = new ModelAndView("/reservation/exp/expCultureNonmemberComplete");
		
		List<Map<String, String>> expCultureCompleteList = expCultureService.expCultureNonmemberComplete(requestBox);
		mav.addObject("expCultureCompleteList", expCultureCompleteList);
		
		return mav;
	}
	
	
	/**
	 * 예약 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureDuplicateCheckAjax.do", method = RequestMethod.POST)
	public ModelAndView expCultureDuplicateCheckAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> cancelDataList = expCultureService.expCultureDuplicateCheck(requestBox);
		mav.addObject("cancelDataList", cancelDataList);
		
		return mav;
	}
	
	/**
	 * 문화 체험 날짜먼저 선택 예약 불가 알림 팝업
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureDisablePop.do", method = RequestMethod.POST)
	public ModelAndView expCultureDisablePop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/exp/expCultureDisablePop");
		
		List<Map<String, String>> expCultureDisableList = expCultureService.expCultureDisablePop(requestBox);
		mav.addObject("expCultureDisableList", expCultureDisableList);
		
		mav.addObject("reqData", requestBox);
		
		return mav;
	}
	
	/**
	 * 문화체험 프로그램 먼저 선택 예약 불가 알림 팝업
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expCultureProgramDisablePop.do", method = RequestMethod.POST)
	public ModelAndView expCultureProgramDisablePop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/exp/expCultureProgramDisablePop");
		
		List<Map<String, String>> expCultureDisableList = expCultureService.expCultureDisablePop(requestBox);
		mav.addObject("expCultureDisableList", expCultureDisableList);
		
		mav.addObject("reqData", requestBox);
		
		return mav;
	}
}
