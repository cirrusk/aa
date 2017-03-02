package amway.com.academy.reservation.expBrand.web;

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
import amway.com.academy.common.util.UtilAPI;
import amway.com.academy.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.reservation.expBrand.service.ExpBrandService;
import amway.com.academy.reservation.expCulture.web.ExpMobileCultureController;

@RequestMapping("/mobile/reservation")
@Controller
public class ExpMobileBrandController extends BasicReservationController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ExpMobileBrandController.class);
	
	@Autowired
	private ExpBrandService expBrandService;

	/**
	 * 날짜 먼저 선택 페이지 호출
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expBrandForm.do")
	public ModelAndView expBrandCalendarForm(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = new ModelAndView("/mobile/reservation/exp/expBrandCalendar");
		
		/* 시설 타입(형태)별 필수안내 */
		model.put("reservationInfo", super.getReservationInfoByType("브랜드"));
		
		/** 카테고리 2 리스트 */
		List<Map<String, String>> searchBrandCategoryType2 = expBrandService.searchBrandCategoryType2(requestBox);
		mav.addObject("brandCategoryType2", searchBrandCategoryType2);
		
		/** 브랜드 체험 pp정보 조회 */
		Map<String, String> searchBrandPpInfo = expBrandService.searchBrandPpInfo(requestBox);
		mav.addObject("searchBrandPpInfo", searchBrandPpInfo);
		
		/** 공통 년도 */
		model.addAttribute("reservationYearCodeList", super.reservationYearCodeList());
		
		/** 공통 월 */
		model.addAttribute("reservationFormatingMonthCodeList", super.reservationFormatingMonthCodeList());
		
		/* for facebook */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics

		return mav;
	}
	
	/**
	 * 프로그램 먼저 페이지 호출
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expBrandProgramForm.do")
	public ModelAndView expBrandProgramForm(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = new ModelAndView("/mobile/reservation/exp/expBrandProgram");
		
		/* 시설 타입(형태)별 필수안내 */
		model.put("reservationInfo", super.getReservationInfoByType("브랜드"));
		
		/** 카테고리 2 리스트 */
		List<Map<String, String>> searchBrandCategoryType2 = expBrandService.searchBrandCategoryType2(requestBox);
		mav.addObject("brandCategoryType2", searchBrandCategoryType2);
		
		/** 브랜드 체험 pp정보 조회 */
		Map<String, String> searchBrandPpInfo = expBrandService.searchBrandPpInfo(requestBox);
		mav.addObject("searchBrandPpInfo", searchBrandPpInfo);
		
		/** 공통 년도 */
		model.addAttribute("reservationYearCodeList", super.reservationYearCodeList());
		
		/** 공통 월 */
		model.addAttribute("reservationFormatingMonthCodeList", super.reservationFormatingMonthCodeList());
		
		/* for facebook */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics

		return mav;
	}
	
	/**
	 * 현재달~2개월 후  년, 월, 클래스명으로 사용될 영어월
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchNextYearMonthAjax.do", method = RequestMethod.POST)
	public ModelAndView searchNextYearMonthAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		
		/** 다음 월에 대한 년, 월 을 조회한다(jsp에서 클래스 명으로 사용)*/
		List<Map<String, String>> nextYearMonth = expBrandService.brandNextYearMonth(requestBox);
		mav.addObject("searchNextYearMonth", nextYearMonth);
		
		return mav;
	}
	
	/**
	 * 현재달~2개월 후  년, 월, 클래스명으로 사용될 영어월(날짜 먼저 선택)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/brandCalenderNextYearMonth.do", method = RequestMethod.POST)
	public ModelAndView brandCalenderNextYearMonth(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		
		/** 다음 월에 대한 년, 월 을 조회한다(jsp에서 클래스 명으로 사용)*/
		List<Map<String, String>> nextYearMonth = expBrandService.brandCalenderNextYearMonth(requestBox);
		mav.addObject("searchNextYearMonth", nextYearMonth);
		
		return mav;
	}
	
	
	/**
	 * 날짜 먼저 선택_캘린더 셋팅에 필요한 정보
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchNextMonthCalendarAjax.do")
	public ModelAndView searchNextMonthCalendarAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		
		/** 다음달 날짜 리스트 */
		List<Map<String, String>> nextMonthCalendar = basicReservationService.getCalendarList(requestBox);
		mav.addObject("nextMonthCalendar", nextMonthCalendar);
		
		/** 다음달에 휴무일을 조회 */
		List<Map<String, String>> searchExpHealthHoliDayList = expBrandService.searchBrandCalenderHoliDay(requestBox);
		mav.addObject("expHealthHoliDayList", searchExpHealthHoliDayList);
		
		/** 일자 별로 예약 가능 여부 리스트 */
		List<Map<String, String>> searchRsvAbleSessionList = expBrandService.searchRsvAbleSessionList(requestBox);
		mav.addObject("searchRsvAbleSessionList", searchRsvAbleSessionList);
		
		return mav;
	}
	
	
	/**
	 * 프로그램 먼저선택_캘린더 셋팅에 필요한 정보 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchNextMonthProgramCalendarAjax.do")
	public ModelAndView searchNextMonthProgramCalendarAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		
		/** 다음달 날짜 리스트 */
		List<Map<String, String>> nextMonthCalendar = basicReservationService.getCalendarList(requestBox);
		mav.addObject("nextMonthCalendar", nextMonthCalendar);
		
		/** 다음달에 휴무일을 조회 */
		List<Map<String, String>> searchExpHealthHoliDayList = expBrandService.searchExpHealthHoliDayList(requestBox);
		mav.addObject("expHealthHoliDayList", searchExpHealthHoliDayList);
		
		/** 일자 별로 예약 가능 여부 리스트 */
		List<Map<String, String>> searchRsvProgramAbleSessionList = expBrandService.searchRsvProgramAbleSessionList(requestBox);
		mav.addObject("searchRsvProgramAbleSessionList", searchRsvProgramAbleSessionList);
		
		return mav;
	}
	
	/**
	 * 해당 날짜의 얘약 가능한 프로그램 리스트
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchBrandProgramListAjax.do")
	public ModelAndView searchBrandProgramListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		
		Map<String, List<Map<String, String>>> searchBrandProgramList = expBrandService.searchBrandProgramList(requestBox);
		mav.addObject("searchBrandProgramList", searchBrandProgramList);
		
		mav.addObject("listCnt", searchBrandProgramList.size());
		
		return mav;
	}
	
	/**
	 * 브랜드 체험 소개 팝업 호출
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expBrandIntroPop.do")
	public ModelAndView expBrandIntroPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/exp/expBrandIntroPop");
		
		/** 카테고리 2 리스트 */
		List<Map<String, String>> searchBrandCategoryType2 = expBrandService.searchBrandCategoryType2(requestBox);
		mav.addObject("brandCategoryType2", searchBrandCategoryType2);
		
		mav.addObject("reqData", requestBox);
		
		return mav;
	}
	
	/**
	 * 카테고리 1에 해당되는 카테고리 2조회(브랜드 체험소개 팝업 사용 & 프로그램 먼저선텍 페이지 사용)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/setBrandCategoryType2Ajax.do")
	public ModelAndView setBrandCategoryType3Ajax(ModelMap model, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> searchBrandCategoryType2 = expBrandService.searchBrandCategoryType2(requestBox);
		mav.addObject("searchBrandCategoryType2", searchBrandCategoryType2);
		
		return mav;
	}
	
	/**
	 * 해당 카테고리 1, 2에 해당되는 카테고리 3조회(브랜드 체험소개 팝업 사용 & 프로그램 먼저선텍 페이지 사용)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/setBrandCategorytype3Ajax.do")
	public ModelAndView setBrandCategorytype3Ajax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> searchBrandCategoryType3 = expBrandService.searchBrandCategoryType3(requestBox);
		mav.addObject("searchBrandCategoryType3", searchBrandCategoryType3);
		
		return mav;
	}
	
	/**
	 * 해당 카테고리 1,2 에 해당 하는 프로그램 타이틀 조회(브랜드 체험소개 팝업 사용 & 프로그램 먼저선텍 페이지 사용)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchBrandProductListAjax.do")
	public ModelAndView searchBrandProductList(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> searchBrandProductList = expBrandService.searchBrandProductList(requestBox);
		mav.addObject("searchBrandProductList", searchBrandProductList);
		
		return mav;
	}
	
	/**
	 * 프로그램 상세 정보(브랜드 체험 소개 팝업 사용)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchBrandProductDetailAjax.do")
	public ModelAndView searchBrandProductAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		Map<String, String> searchBrandProductDetail = expBrandService.searchBrandProductDetail(requestBox);
		mav.addObject("searchBrandProductDetail", searchBrandProductDetail);
		
		
		return mav;
	}
	
	/**
	 * 날짜 먼저 선택_예액정보 확인 팝업 호출
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expBrandRsvRequestPopAjax.do", method = RequestMethod.POST)
	public ModelAndView expBrandRsvRequestPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** 선택한 프로그램 데이터 셋팅 */
		List<Map<String, String>> expBrandRsvInfoList = expBrandService.expBrandRsvRequestPop(requestBox);
		model.addAttribute("expBrandRsvInfoList", expBrandRsvInfoList);
		
		/** 선택한 프로그램 갯수 */
		mav.addObject("totalCnt", expBrandRsvInfoList.size());
		
		/** 동반 여부 리스트(공통_셀렉트박스) */
		mav.addObject("partnerTypeCodeList", super.partnerTypeCodeList());
		
		return mav;
	}
	
	/**
	 * 날짜 먼저 선택페이지_선택한 프로그램 등록(예약정보 확인 팝업)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/expBrandCalendarInsertAjax.do")
	public ModelAndView expBrandCalendarInsertAjax(ModelMap model, RequestBox requestBox) throws Exception{
		
		LOGGER.debug("invoke expBrandCalendarInsertAjax");
		LOGGER.debug("requestBox {}", requestBox);
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/* 예약 가능여부 체크 - 시작 { */
		Map tupleMap = new HashMap();
		tupleMap.put(COLUMN_NAME_ACCOUNT,			"account");
		tupleMap.put(COLUMN_NAME_RESERVATIONDATE,	"reservationDate");
		tupleMap.put(COLUMN_NAME_RSVTYPECODE,		"");
		tupleMap.put(COLUMN_NAME_TYPESEQ,			"typeseq");
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
		Map<String, String> standByNumberAdvanceChecked = expBrandService.expBrandStandByNumberAdvanceChecked(requestBox);
		if("false".equals(standByNumberAdvanceChecked.get("msg"))){
			mav.addObject("possibility", standByNumberAdvanceChecked.get("msg"));
			mav.addObject("reason", standByNumberAdvanceChecked.get("reason"));
			return mav;
		}
		
		/** 체성분 측정 예약정보 리스트&등록 메소드 */
		List<Map<String, String>> expBrandCalendarRsvInfoList = expBrandService.expBrandCalendarInsertAjax(requestBox);
		mav.addObject("expBrandCalendarRsvInfoList", expBrandCalendarRsvInfoList);

		/* for facebook */
		String transactionTime = (String) requestBox.getVector("transactionTime").get(0);
		mav.addObject("transactionTime", transactionTime);
		
		/** 선택 예약 정보 총 갯수 */
		mav.addObject("totalCnt", expBrandCalendarRsvInfoList.size());
		
		LOGGER.debug("requestBox {}", requestBox);
		
		return mav;
	}
	
	/**
	 * 프로그램 먼저선텍_선택한 프로그램 & 날짜에 해당 되는 세션 리스트
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchProgramSessionListAjax.do")
	public ModelAndView searchProgramSessionList(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		/** 세션 리스트 */
		List<Map<String, String>> searchProgramSessionList = expBrandService.searchProgramSessionList(requestBox);
		mav.addObject("searchProgramSessionList", searchProgramSessionList);
		
		return mav;
	}
	
	/**
	 * 프로그램 먼저 선텍_예약정보 등록 팝업 호출
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expBrandProgramRsvRequestPopAjax.do")
	public ModelAndView expBrandProgramRsvRequestPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 부모 창에서 선택한  데이터 셋팅*/
		List<Map<String, String>> expBrandProgramList = expBrandService.expBrandProgramRsvRequestPop(requestBox);
		model.addAttribute("expBrandProgramList", expBrandProgramList);
		
		/** 브랜드 체험 예약 갯수 */
		mav.addObject("totalCnt", expBrandProgramList.size());
		
		/** 동반 여부 리스트(공통_셀렉트박스) */
		mav.addObject("partnerTypeCodeList", super.partnerTypeCodeList());
		
		return mav;
	}
	
	/**
	 * 프로그램 먼저 선택_예약정보 등록(예약정보 확인 팝업)
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/expBrandProgramInsertAjax.do")
	public ModelAndView expBrandProgramInsertAjax(ModelMap model, RequestBox requestBox) throws Exception{
		
		LOGGER.debug("invoke expBrandProgramInsertAjax");
		LOGGER.debug("requestBox {}", requestBox);
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/* 예약 가능여부 체크 - 시작 { */
		Map tupleMap = new HashMap();
		tupleMap.put(COLUMN_NAME_ACCOUNT,			"account");
		tupleMap.put(COLUMN_NAME_RESERVATIONDATE,	"reservationDate");
		tupleMap.put(COLUMN_NAME_RSVTYPECODE,		"");
		tupleMap.put(COLUMN_NAME_TYPESEQ,			"typeseq");
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
		Map<String, String> standByNumberAdvanceChecked = expBrandService.expBrandStandByNumberAdvanceChecked(requestBox);
		if("false".equals(standByNumberAdvanceChecked.get("msg"))){
			mav.addObject("possibility", standByNumberAdvanceChecked.get("msg"));
			mav.addObject("reason", standByNumberAdvanceChecked.get("reason"));
			return mav;
		}
		
		
		/** 선택한 브랜드 체험 등록후 & 리스트 반환 */
		List<Map<String, String>> expBrandProgramList = expBrandService.expBrandProgramInsertAjax(requestBox);
		
		LOGGER.debug("expBrandProgramList {}", expBrandProgramList);
		LOGGER.debug("expBrandProgramList.size {}", expBrandProgramList.size());
		
		mav.addObject("expBrandProgramList", expBrandProgramList);
		
		/* for facebook */
		String transactionTime = (String) requestBox.getVector("transactionTime").get(0);
		mav.addObject("transactionTime", transactionTime);
		
		/** 선택 예약 정보 총 갯수 */
		mav.addObject("totalCnt", expBrandProgramList.size());
		
		LOGGER.debug("requestBox {}", requestBox);
		
		return mav;
	}
	
	/**
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchExpBrandProgramKeyListAjax.do")
	public ModelAndView searchExpBrandProgramKeyList(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> brandProgramKeyList = expBrandService.brandProgramKeyList(requestBox);
		mav.addObject("brandProgramKeyList", brandProgramKeyList);
		
		return mav;
		
	}
	
	@RequestMapping(value = "/searchExpBrandFileKeyListAjax.do")
	public ModelAndView searchExpBrandFileKeyListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> searchExpImageFileKeyList = basicReservationService.searchExpImageFileKeyList(requestBox);
		mav.addObject("expImageFileKeyList", searchExpImageFileKeyList);
		
		return mav;
	}
	
	@RequestMapping(value = "/expBrandRsvAvailabilityCheckAjax.do")
	public ModelAndView expBrandRsvAvailabilityCheckAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/* 세션으로부터 abono 획득 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		mav.addObject("rsvAvailabilityCheck", reservationCheckerService.expBrandRsvAvailabilityCheck(requestBox));
		
		return mav;
	}
}
