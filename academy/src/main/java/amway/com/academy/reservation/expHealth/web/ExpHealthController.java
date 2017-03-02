package amway.com.academy.reservation.expHealth.web;

import java.util.HashMap;
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

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.common.util.UtilAPI;
import amway.com.academy.reservation.basicPackage.service.BasicReservationService;
import amway.com.academy.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.reservation.expHealth.service.ExpHealthService;


@RequestMapping("/reservation")
@Controller
public class ExpHealthController extends BasicReservationController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExpHealthController.class);
	
	@Autowired
	private ExpHealthService expHealthService;
	
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
	@RequestMapping(value = "/expHealthForm.do")
	public String expHealthInsertForm(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		/** ----------------APinfo 정보--------------------------- */
		Map testAPI = UtilAPI.getApInfo();
		model.addAttribute("result", testAPI);
		
		//이미지 경로에 사용될 HybrisUrl
		String curerntHybrisLocation = UtilAPI.getCurerntHybrisLocation();
		model.addAttribute("curerntHybrisLocation", curerntHybrisLocation);
		/** --------------------------------------------------- */
		
		/* 시설 타입(형태)별 필수안내 */
		model.put("reservationInfo", super.getReservationInfoByType("체성분측정"));
		
//		model.addAttribute("httpDomain", UtilAPI.getApiLocation());
		model.addAttribute("httpDomain", "www.abnkorea.co.kr");
		
		/** 예약 현황 확인시 페이지 이동에 필요한 현재 hybris의 경로 */
		model.addAttribute("hybrisUrl", UtilAPI.getCurerntHybrisLocation());
		
		/** 현재 AI의 경로 */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics

		return "/reservation/exp/expHealth";
	}
	
	/**
	 * 해당 pp의 정원, 이용시간, 예약자격, 준비물등을 조회
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expHealthDetailInfoAjax.do", method = RequestMethod.POST)
	public ModelAndView expHealthDetailInfoAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		Map<String, String> expHealthDetailInfo = expHealthService.expHealthDetailInfo(requestBox);
		mav.addObject("expHealthDetailInfo", expHealthDetailInfo);
		
		
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
	@RequestMapping(value = "/searchStartSeesionTimeListAjax.do", method = RequestMethod.POST)
	public ModelAndView searchStartSeesionTimeListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		
		List<Map<String, String>> searchStartSeesionTimeList = expHealthService.searchStartSeesionTimeListAjax(requestBox);
		mav.addObject("searchStartSeesionTimeList", searchStartSeesionTimeList);
		
		return mav;
	}
	
	/**
	 * 체성분 측정 정보 확인(팝업)
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expHealthRsvRequestPop.do", method = RequestMethod.POST)
	public ModelAndView expHealthRsvRequestPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/exp/expHealthRsvRequestPop");
		
		/** 선택한 예약정보 리스트 */
		List<Map<String, String>> expHealthRsvInfoList = expHealthService.expHealthRsvRequestPop(requestBox);
		mav.addObject("expHealthRsvInfoList", expHealthRsvInfoList);
		
		/** 선택 예약 정보 총 갯수 */
		mav.addObject("totalCnt", expHealthRsvInfoList.size());
		
		/** 동반 여부 리스트(공통_셀렉트박스) */
		mav.addObject("partnerTypeCodeList", super.partnerTypeCodeList());
		
		mav.addObject("reqData", requestBox);
		
		return mav;
	}
	
	/**
	 * 체성분 측정 예약 정보 등록(팝업)
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/expHealthInsertAjax.do", method = RequestMethod.POST)
	public ModelAndView expHealthInsertAjax(ModelMap model, RequestBox requestBox) throws Exception{
		
		LOGGER.debug("invoke expHealthInsertAjax");
		LOGGER.debug("requestBox : {}", requestBox);
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		/* 세션으로부터 abono 획득 */
		requestBox.put("account", requestBox.getSession("abono"));

		/* 예약 가능여부 체크 - 시작 { */
		Map tupleMap = new HashMap();
		tupleMap.put(COLUMN_NAME_ACCOUNT,			"account");
		tupleMap.put(COLUMN_NAME_RESERVATIONDATE,	"reservationDate");
		tupleMap.put(COLUMN_NAME_RSVTYPECODE,		"");
		tupleMap.put(COLUMN_NAME_TYPESEQ,			"typeSeq");
		tupleMap.put(COLUMN_NAME_EXPSEQ,			"expseq");
		tupleMap.put(COLUMN_NAME_PPSEQ,				"ppSeq");
		tupleMap.put(COLUMN_NAME_SESSIONSEQ, 		"expsessionseq");
		
		Map<String, String> checkResultMap = super.reservationCheckerService.checkExpReservationList(requestBox, tupleMap, requestBox.getVector("expsessionseq").size());
		
		if("false".equals(checkResultMap.get("possibility"))){
			mav.addObject("possibility", checkResultMap.get("possibility"));
			mav.addObject("reason", checkResultMap.get("reason"));
			return mav;
		}
		/* } 예약 가능여부 체크 - 종료 */
		
		//예약 대기자 조회[같은 세션을 선점할 경우 늦게 insert한 사용자는  다른 사용자가 먼저 선점하여 등록이 불가 하다라는 메세지를 뿌려줌]
		Map<String, String> standByNumberAdvanceChecked = expHealthService.expHealthStandByNumberAdvanceChecked(requestBox);
		if("false".equals(standByNumberAdvanceChecked.get("msg"))){
			mav.addObject("possibility", standByNumberAdvanceChecked.get("msg"));
			mav.addObject("reason", standByNumberAdvanceChecked.get("reason"));
			return mav;
		}
		
		/** 체성분 측정 예약정보 리스트&등록 메소드 */
		List<Map<String, String>> expHealthRsvInfoList = expHealthService.expHealthInsertAjax(requestBox);
		mav.addObject("expHealthRsvInfoList", expHealthRsvInfoList);
		
		/** for facebook */
		String transactionTime = (String) requestBox.getVector("transactionTime").get(0);
		mav.addObject("transactionTime", transactionTime);
		
		/** 선택 예약 정보 총 갯수 */
		mav.addObject("totalCnt", expHealthRsvInfoList.size());
		
		LOGGER.debug("requestBox : {}", requestBox);
		
		return mav;
	}
	
	/**
	 * 체험 예약 현황 확인(팝업)
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expHealthRsvConfirmPop.do", method = RequestMethod.POST)
	public ModelAndView expHealthRsvConfirmPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/exp/expRsvConfirmPop");
		
		/** 공통 년도 */
		model.addAttribute("reservationYearCodeList", super.reservationYearCodeList());
		
		/** 공통 월 */
		model.addAttribute("reservationFormatingMonthCodeList", super.reservationFormatingMonthCodeList());
		
		/** 현재 년, 월을 디폴트 값을 주기 위해 사용됨 */
		model.addAttribute("getYear", requestBox.get("getYearPop"));
		model.addAttribute("getMonth", requestBox.get("getMonthPop"));
		model.addAttribute("getDay", requestBox.get("getDayPop"));
		
		return mav;
	}
	
	/**
	 * 셀렉트 박스에서 선택한 년, 월 로  달력을 그려주는 메소드 
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expSearchCalAjax.do", method = RequestMethod.POST)
	public ModelAndView expHealthSearchCalAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 선택한 년, 월 로  해당 월 날짜리스트*/
		List<Map<String, String>> nowMonthCalList = basicReservationService.getCalendarList(requestBox);
		mav.addObject("nowMonthCalList", nowMonthCalList);
		
		/** 해당월에 예약한 체험 프로그램 리스트 조횐 */
		List<Map<String, String>> expReservationInfoDetailList = basicReservationService.expReservationInfoDetailList(requestBox);
		mav.addObject("expReservationInfoDetailList", expReservationInfoDetailList);
		
		/** 이전달, 다음달에 예약된 체험 카운트(예약 현황 확인 팝업 에서 사용) */
		Map<String, String > searchMonthRsvCount = basicReservationService.searchMonthRsvCount(requestBox);
		mav.addObject("searchMonthRsvCount", searchMonthRsvCount);
		
		
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
	@RequestMapping(value = "/nextMonthCalendarAjax.do", method = RequestMethod.POST)
	public ModelAndView nextMonthCalendarAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		
		/** 다음달 날짜 리스트 */
		List<Map<String, String>> nextMonthCalendar = basicReservationService.getCalendarList(requestBox);
		mav.addObject("nextMonthCalendar", nextMonthCalendar);
		
		/** 다음달에 휴무일을 조회 */
		List<Map<String, String>> searchExpHealthHoilDayList = expHealthService.searchExpHealthHoilDay(requestBox);
		mav.addObject("searchExpHealthHoilDayList", searchExpHealthHoilDayList);
		
		/** 다음 월에 대한 년, 월 을 조회한다(jsp에서 클래스 명으로 사용)*/
		List<Map<String, String>> nextYearMonth = basicReservationService.nextYearMonth(requestBox);
		mav.addObject("nextYearMonth", nextYearMonth);
		
		/** 달력상에 예약 가능 세션 갯수 조회 */
		List<Map<String, String>> searchRsvAbleSessionTotalCount = expHealthService.searchRsvAbleSessionTotalCount(requestBox);
		mav.addObject("rsvAbleCntList", searchRsvAbleSessionTotalCount);
		
		return mav;
	}
	
	@RequestMapping(value = "/searchPpInfoListAjax.do", method = RequestMethod.POST)
	public ModelAndView searchPpInfoListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 해당 pp조회  */
		List<Map<String, String>> ppRsvCodeList = expHealthService.ppRsvCodeList(requestBox);
		mav.addObject("ppCodeList", ppRsvCodeList);
		
		/** 마지막으로 예약한 pp정보 조회 */
		Map<String, String> searchLastRsvPp = basicReservationService.searchLastRsvPp(requestBox);
		mav.addObject("searchLastRsvPp", searchLastRsvPp);
		
		return mav;
	}
	
	/**
	 * 체성분 측정 이미지 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchExpHealthFileKeyListAjax.do")
	public ModelAndView searchExpHealthFileKeyListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> searchExpImageFileKeyList = basicReservationService.searchExpImageFileKeyList(requestBox);
		mav.addObject("expImageFileKeyList", searchExpImageFileKeyList);
		
		return mav;
	}
	
	/**
	 * 예약 요청 세션 정보가 타인에 의해 실시간으로 등록된 사항이 있는지 확인
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expHealthDuplicateCheckAjax.do", method = RequestMethod.POST)
	public ModelAndView expHealthDuplicateCheckAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> cancelDataList = expHealthService.expHealthDuplicateCheck(requestBox);
		mav.addObject("cancelDataList", cancelDataList);
		
		return mav;
	}
	
	/**
	 * 예약 불가 알림 팝업
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expHealthDisablePop.do", method = RequestMethod.POST)
	public ModelAndView expHealthDisablePop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/exp/expHealthDisablePop");
		
		List<Map<String, String>> expHealthDisableList = expHealthService.expHealthDisablePop(requestBox);
		mav.addObject("expHealthDisableList", expHealthDisableList);
		
		mav.addObject("reqData", requestBox);
		
		return mav;
	}
	
	/**
	 * 측정체험 패널티 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchExpPenaltyAjax.do")
	public ModelAndView searchExpPenaltyAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		Map<String, String> searchExpPenalty = expHealthService.searchExpPenalty(requestBox);
		mav.addObject("searchExpPenalty", searchExpPenalty);
		
		return mav;
	}
}
