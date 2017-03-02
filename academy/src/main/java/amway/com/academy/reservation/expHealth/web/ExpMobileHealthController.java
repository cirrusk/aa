package amway.com.academy.reservation.expHealth.web;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
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

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.StringUtil;
import amway.com.academy.common.file.service.FileUpLoadService;
import amway.com.academy.common.util.UtilAPI;
import amway.com.academy.reservation.basicPackage.service.BasicReservationService;
import amway.com.academy.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.reservation.expHealth.service.ExpHealthService;


@RequestMapping("/mobile/reservation")
@Controller
public class ExpMobileHealthController extends BasicReservationController {
	@Autowired
	private ExpHealthService expHealthService;
	
	/** 공통 코드 서비스 */
	@Autowired
	private BasicReservationService basicReservationService;
	
	@Autowired
	private FileUpLoadService fileUploadService;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExpMobileHealthController.class);
	
	public static final String ROOT_UPLOAD_DIR = StringUtil.uploadPath()+ File.separator;

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
		
		/* 시설 타입(형태)별 필수안내 */
		model.put("reservationInfo", super.getReservationInfoByType("체성분측정"));
		
		/** 공통 년도 */
		model.addAttribute("reservationYearCodeList", super.reservationYearCodeList());
		
		/** 공통 월 */
		model.addAttribute("reservationFormatingMonthCodeList", super.reservationFormatingMonthCodeList());
		
//		model.addAttribute("httpDomain", UtilAPI.getApiLocation());
		model.addAttribute("httpDomain", "www.abnkorea.co.kr");
		
		model.addAttribute("ppCodeList", super.ppCodeList());

		/** ----------------APinfo 정보--------------------------- */
		Map testAPI = UtilAPI.getApInfo();
		model.addAttribute("result", testAPI);
		
		//이미지 경로에 사용될 HybrisUrl
		String curerntHybrisLocation = UtilAPI.getCurerntHybrisLocation();
		model.addAttribute("curerntHybrisLocation", curerntHybrisLocation);
		/** --------------------------------------------------- */
		
		/* for facebook */
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return "/mobile/reservation/exp/expHealth";
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
	@RequestMapping(value = "/expHealthRsvRequestPopAjax.do", method = RequestMethod.POST)
	public ModelAndView expHealthRsvRequestPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** 선택한 예약정보 리스트 */
		List<Map<String, String>> expHealthRsvInfoList = expHealthService.expHealthRsvRequestPop(requestBox);
		mav.addObject("expHealthRsvInfoList", expHealthRsvInfoList);
		
		/** 선택 예약 정보 총 갯수 */
		mav.addObject("totalCnt", expHealthRsvInfoList.size());
		
		/** 동반 여부 리스트(공통_셀렉트박스) */
		mav.addObject("partnerTypeCodeList", super.partnerTypeCodeList());
		
//		mav.addObject("reqData", requestBox);
		
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
		Map<String, String> standByNumberAdvanceChecked = expHealthService.expHealthStandByNumberAdvanceChecked(requestBox);
		if("false".equals(standByNumberAdvanceChecked.get("msg"))){
			mav.addObject("possibility", standByNumberAdvanceChecked.get("msg"));
			mav.addObject("reason", standByNumberAdvanceChecked.get("reason"));
			return mav;
		}
		
		/** 체성분 측정 예약정보 리스트&등록 메소드 */
		List<Map<String, String>> expHealthRsvInfoList = expHealthService.expHealthInsertAjax(requestBox);
		mav.addObject("expHealthRsvInfoList", expHealthRsvInfoList);
		
		/* for facebook */
		String transactionTime = (String) requestBox.getVector("transactionTime").get(0);
		mav.addObject("transactionTime", transactionTime);
		
		/** 선택 예약 정보 총 갯수 */
		mav.addObject("totalCnt", expHealthRsvInfoList.size());
		
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
		requestBox.put("pinvalue", super.reservationCheckerService.getMemberInformation(requestBox).get("pinvalue"));
		
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
		
		List<Map<String, String>> searchRsvAbleSessionTotalCount = expHealthService.searchRsvAbleSessionTotalCount(requestBox);
		mav.addObject("rsvAbleCntList", searchRsvAbleSessionTotalCount);
		
		return mav;
	}
	
	/**
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
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
	 * ap 정보 조회
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchApInfoAjax.do", method = RequestMethod.POST)
	public ModelAndView showApInfoAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		mav.addObject("ppCodeList", super.ppCodeList());
		
		return mav;
	}
	
	/**
	 * 
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
	 * 
	 * @param requestBox
	 * @param req
	 * @param res
	 * @throws Exception
	 */
	@RequestMapping(value = "/imageView.do")
	public void imageView (RequestBox requestBox, HttpServletRequest req, HttpServletResponse res) throws Exception{
//		String fileFullPath = requestBox.get("filefullurl") + requestBox.get("storefilename");
		

		// 이미지 폴더명이 현재 년 이기 때문에 서버 기준 년 으로 한다.
		Calendar cal = new GregorianCalendar(Locale.KOREA);
		// 폴더 이름
		String folder  = String.valueOf(cal.get(Calendar.YEAR));
		String fileFullUrl = "";
		String file = requestBox.get("file");
		String mode;
		
		file = file.replaceAll("\\.\\.\\/", "");
		
		String fileFullPath = "";
		
		if("RSVBRAND".equals(requestBox.get("mode"))){

			ModelMap modelMap = new ModelMap();
			modelMap.put("work", "RSVBRAND");
			modelMap.put("storefilename", file);
			Map map = (Map) fileUploadService.getSelectFileDetailByFileName(modelMap);
			
			if(null != map){
				fileFullUrl = (String)map.get("filefullurl");
				fileFullPath = fileFullUrl + file;
			}

		} else if("RESERVATION".equals(requestBox.get("mode"))) {
			
			ModelMap modelMap = new ModelMap();
			modelMap.put("work", "RESERVATION");
			modelMap.put("storefilename", file);
			Map map = (Map) fileUploadService.getSelectFileDetailByFileName(modelMap);
			
			if(null != map){
				fileFullUrl = (String)map.get("filefullurl");
				fileFullPath = fileFullUrl + file;
			}

		}else{
			mode = requestBox.get("mode");
			fileFullPath = ROOT_UPLOAD_DIR + mode + File.separator + folder + File.separator + file;
		}
		
		LOGGER.debug("fileFullPath : {}", fileFullPath);
		
		File imgFile = new File(fileFullPath);
		if(imgFile.isFile()){
			FileInputStream ifo = new FileInputStream(imgFile);
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			byte[] buf = new byte[1024];
			int readlength = 0;
			while((readlength = ifo.read(buf)) != -1){
				baos.write(buf, 0, readlength);
			}
			byte[] imgbuf = null;
			imgbuf = baos.toByteArray();
			baos.close();
			ifo.close();
			
			int length = imgbuf.length;
			OutputStream out = res.getOutputStream();
			out.write(imgbuf, 0, length);
			out.close();
		}
	}
}
