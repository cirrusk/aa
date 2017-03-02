package amway.com.academy.reservation.expSkin.web;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
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
import amway.com.academy.reservation.expHealth.web.ExpMobileHealthController;
import amway.com.academy.reservation.expSkin.service.ExpSkinService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

/**
 * <pre>
 * 피부 측정 사용자 예약 Mobile 컨트롤러
 * </pre>
 * Program Name  : ExpSkinController.java
 * Author : KR620226
 * Creation Date : 2016. 8. 11.
 */
@RequestMapping("/mobile/reservation")
@Controller
public class ExpMobileSkinController extends BasicReservationController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExpMobileSkinController.class);
	
	@Autowired
	private ExpSkinService expSkinService;
	
	/** 공통 코드 서비스 */
	@Autowired
	private BasicReservationService basicReservationService;

	/**
	 * 피부 측정 예약 페이지 호출
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expSkinForm.do")
	public String expSkinInsertForm(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		/* 시설 타입(형태)별 필수안내 */
		model.put("reservationInfo", super.getReservationInfoByType("피부"));
		
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
		
		/* for facebook */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
//		model.addAttribute("httpDomain", UtilAPI.getApiLocation());
		model.addAttribute("httpDomain", "www.abnkorea.co.kr");
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return "/mobile/reservation/exp/expSkin";
	}
	
	/**
	 * 해당 pp의 정원, 이용시간, 예약자격, 준비물등을 조회
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expSkinDetailInfoAjax.do", method = RequestMethod.POST)
	public ModelAndView expSkinDetailInfoAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		Map<String, String> expSkinDetailInfo = expSkinService.expSkinDetailInfo(requestBox);
		mav.addObject("expSkinDetailInfo", expSkinDetailInfo);
		
		
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
	@RequestMapping(value = "/searchSkinSeesionListAjax.do", method = RequestMethod.POST)
	public ModelAndView searchSkinSeesionListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		
		List<Map<String, String>> searchSkinSeesionListAjax = expSkinService.searchSkinSeesionListAjax(requestBox);
		mav.addObject("searchStartSeesionTimeListAjax", searchSkinSeesionListAjax);
		
		return mav;
	}
	
	/**
	 * 피부 측정 정보 확인(팝업)
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expSkinRsvRequestPop.do", method = RequestMethod.POST)
	public ModelAndView expSkinRsvRequestPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 선택한 예약정보 리스트 */
		List<Map<String, String>> expSkinRsvInfoList = expSkinService.expSkinRsvRequestPop(requestBox);
		mav.addObject("expSkinRsvInfoList", expSkinRsvInfoList);
		
		/** 선택 예약 정보 총 갯수 */
		mav.addObject("totalCnt", expSkinRsvInfoList.size());
		
		/** 동반 여부 리스트(공통_셀렉트박스) */
		mav.addObject("partnerTypeCodeList", super.partnerTypeCodeList());
		
		//mav.addObject("reqData", requestBox);
		
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
	@RequestMapping(value = "/expSkinInsertAjax.do", method = RequestMethod.POST)
	public ModelAndView expSkinInsertAjax(ModelMap model, RequestBox requestBox) throws Exception{
		
		LOGGER.debug("invoke expSkinInsertAjax");
		LOGGER.debug("requestBox {}", requestBox);
		
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
		Map<String, String> standByNumberAdvanceChecked = expSkinService.expSkinStandByNumberAdvanceChecked(requestBox);
		if("false".equals(standByNumberAdvanceChecked.get("msg"))){
			mav.addObject("possibility", standByNumberAdvanceChecked.get("msg"));
			mav.addObject("reason", standByNumberAdvanceChecked.get("reason"));
			return mav;
		}

		/** 체성분 측정 예약정보 리스트&등록 메소드 */
		List<Map<String, String>> expSkinRsvInfoList = expSkinService.expSkinInsertAjax(requestBox);
		mav.addObject("expSkinRsvInfoList", expSkinRsvInfoList);
		
		/* for facebook */
		String transactionTime = (String) requestBox.getVector("transactionTime").get(0);
		mav.addObject("transactionTime", transactionTime);
		
		/** 선택 예약 정보 총 갯수 */
		mav.addObject("totalCnt", expSkinRsvInfoList.size());
		
		LOGGER.debug("requestBox {}", requestBox);
		
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
	@RequestMapping(value = "/expSkinRsvConfirmPop.do", method = RequestMethod.POST)
	public ModelAndView expSkinRsvConfirmPop(ModelAndView mav, RequestBox requestBox) throws Exception{
		
		/** 공통 년도 */
		mav.addObject("reservationYearCodeList", super.reservationYearCodeList());
		
		/** 공통 월 */
		mav.addObject("reservationFormatingMonthCodeList", super.reservationFormatingMonthCodeList());
		
		/** 현재 년, 월을 디폴트 값을 주기 위해 사용됨 */
		mav.addObject("getYear", requestBox.get("getYearPop"));
		mav.addObject("getMonth", requestBox.get("getMonthPop"));
		mav.addObject("getDay", requestBox.get("getDayPop"));
		
		mav.setViewName("/mobile/reservation/exp/expRsvConfirmPop");
		
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
	@RequestMapping(value = "/expSkinNextMonthCalendarAjax.do", method = RequestMethod.POST)
	public ModelAndView expSkinNextMonthCalendarAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		
		/** 다음달 날짜 리스트 */
		List<Map<String, String>> nextMonthCalendar = basicReservationService.getCalendarList(requestBox);
		mav.addObject("nextMonthCalendar", nextMonthCalendar);
		
		/** 다음달에 휴무일을 조회 */
		List<Map<String, String>> searchExpSkinHoliDayList = expSkinService.searchExpSkinHoliDay(requestBox);
		mav.addObject("searchExpSkinHoliDayList", searchExpSkinHoliDayList);
		
		/** 다음 월에 대한 년, 월 을 조회한다(jsp에서 클래스 명으로 사용)*/
		List<Map<String, String>> nextYearMonth = basicReservationService.nextYearMonth(requestBox);
		mav.addObject("nextYearMonth", nextYearMonth);
		
		List<Map<String, String>> searchRsvAbleSessionTotalCount = expSkinService.searchRsvAbleSessionTotalCount(requestBox);
		mav.addObject("rsvAbleCntList", searchRsvAbleSessionTotalCount);
		
		return mav;
	}
	
	@RequestMapping(value = "/searchExpSkinPpInfoListAjax.do", method = RequestMethod.POST)
	public ModelAndView searchExpSkinPpInfoListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 해당 pp조회  */
		List<Map<String, String>> ppRsvCodeList = expSkinService.ppRsvCodeList(requestBox);
		mav.addObject("ppCodeList", ppRsvCodeList);
		
		/** 마지막으로 예약한 pp정보 조회 */
		Map<String, String> searchLastRsvPp = basicReservationService.searchLastRsvPp(requestBox);
		mav.addObject("searchLastRsvPp", searchLastRsvPp);
		
		return mav;
	}
	
	/**
	 * ap 정보 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchExpSkinApInfoAjax.do", method = RequestMethod.POST)
	public ModelAndView showApInfoAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		mav.addObject("ppCodeList", super.ppCodeList());
		
		return mav;
	}
	
	/**
	 * 이미지 경로 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/searchExpSkinFileKeyListAjax.do")
	public ModelAndView searchExpSkinFileKeyListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> expImageFileKeyList = basicReservationService.searchExpImageFileKeyList(requestBox);
		mav.addObject("expImageFileKeyList", expImageFileKeyList);
		
		return mav;
	}
	
}
