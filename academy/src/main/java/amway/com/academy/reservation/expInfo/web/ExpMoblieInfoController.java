package amway.com.academy.reservation.expInfo.web;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import amway.com.academy.common.util.CheckSSO;
import amway.com.academy.common.util.UtilAPI;
import amway.com.academy.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.reservation.expCulture.service.ExpCultureService;
import amway.com.academy.reservation.expInfo.service.ExpInfoService;

/**
 * <pre>
 * 		-체험 예약 컨트롤러
 * 			: FRONT- 사용자의 체험얘약 현황 확인 컨트롤러
 * </pre>
 * Program Name  : ExpInfoController.java
 * Author : KR620225
 * Creation Date : 2016. 8. 11.
 */
@RequestMapping("/mobile/reservation")
@Controller
public class ExpMoblieInfoController extends BasicReservationController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExpMoblieInfoController.class);
	
	@Autowired
	private ExpInfoService expInfoService;

	@Autowired
	private ExpCultureService expCultureService;
	
	private String sRowPerPage = "20"; // 페이지에 넣을 row수
	public static final int ZERO = 0;
	
	/**
	 * 체험 예약 현황 리스트
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoList.do")
	public ModelAndView expInfoList(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		LOGGER.debug("invoke ExpMoblieInfoController.expInfoList");
		LOGGER.debug("requestBox {}", requestBox);
		
		ModelAndView mav = null;
		
		requestBox.put("account", requestBox.getSession("abono"));
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics

	
		
		String ssoValue = "";
		String urlString = "";
		boolean imarCheck = false;
		
		String resourceName = "/config/props/framework.properties";
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties props = new Properties();
		
		try {
			
			InputStream resourceStream = loader.getResourceAsStream(resourceName);
			props.load(resourceStream);
			//삼성 하이브리스 체크 url
			urlString = props.getProperty("Hybris.ssoUrl");
			
			if( urlString.indexOf("https://localhost") >= 0 ) {
				Cookie[] cookies = request.getCookies();
				
				/* 유효한 연결이면 requestMap 객체 생성 */
				for(Cookie cookie : cookies){
					String cookieName = cookie.getName();
					String cookieValue = cookie.getValue();
					
					LOGGER.debug("@@@@@@@@ cookieName: {}", cookieName);
					LOGGER.debug("@@@@@@@@ cookieValue : {}", cookieValue);
					
					if("i_mar".equals(cookieName)){
						imarCheck = true;
					}else if("username".equals(cookieName)){
						requestBox.put("account", cookieValue);
						LOGGER.debug("@@@@@@@@ username : {}", cookieValue);
					}
				}
				
			} else {
				ssoValue = CheckSSO.ssoCheck(request, urlString);
				//request.getSession().setAttribute("abono", ssoValue);

				LOGGER.debug("#############################################   ssoValue : {}", ssoValue);
				
				//requestBox.put("account", request.getSession().getAttribute("abono"));
				
				LOGGER.debug("#############################################   requestBox.get - account : {}", requestBox.get("account"));
				
				if(("").equals(ssoValue)){
					LOGGER.debug("(\"\").equals(ssoValue)");
				}
				if(("").equals(ssoValue.trim())){
					LOGGER.debug("(\"\").equals(ssoValue.trim())");
				}
				
				if(("").equals(ssoValue)){
					imarCheck = false;
				}else if("ERROR".equals(ssoValue)){
					imarCheck = false;
				}else{
					imarCheck = true;
				}
				/* 예외 발생시 비회원 처리 */
				
			}
			
		} catch (Exception e){
			imarCheck = false;
			LOGGER.error(e.getMessage(), e);
		}
		
		//if (!("").equals(requestBox.get("account"))){
		if (imarCheck){

			LOGGER.debug("@@@@@@@@ account : {}", requestBox.get("account"));
			if (!"".equals(ssoValue)){
				requestBox.put("account", ssoValue);
			}
			
			/**----------------------------검색 조건------------------------------------------*/
			model.addAttribute("reservationYearCodeList", super.reservationYearCodeList());							// 년도
			model.addAttribute("reservationFormatingMonthCodeList", super.reservationFormatingMonthCodeList());		//월
			model.addAttribute("expRsvTypeInfoCodeList", super.expRsvTypeInfoCodeList());							//체험종류
			model.addAttribute("ppCodeList", super.ppCodeList());													//pp리스트
			/**--------------------------------------------------------------------------*/
			
			/** 디폴트 날짜 검색 조건 셋팅 [현재시작일~3개월후 마지막날 조회] */
			Map<String, String> searchThreeMonthMobile = expInfoService.searchThreeMonthMobile(requestBox);
			
			if(("").equals(requestBox.get("searchStrDateMobile")) || ("").equals(requestBox.get("searchEndDateMobile"))){
				
				model.addAttribute("searchThreeMonthMobile", searchThreeMonthMobile);
				
				/** 디폴트 날짜 검색 조건 셋팅[쿼리용] */
//				requestBox.put("searchStrDateMobile", searchThreeMonthMobile.get("strdate"));
//				requestBox.put("searchEndDateMobile", searchThreeMonthMobile.get("enddate"));
				
				requestBox.put("searchStrYear", searchThreeMonthMobile.get("strdate").substring(0, 4));
				requestBox.put("searchStrMonth", searchThreeMonthMobile.get("strdate").substring(5, 7));
				requestBox.put("searchEndYear", searchThreeMonthMobile.get("enddate").substring(0, 4));
				requestBox.put("searchEndMonth", searchThreeMonthMobile.get("enddate").substring(5, 7));
				
				/** 화면에 표현될 데이터 */
				requestBox.put("strDateMobile", searchThreeMonthMobile.get("strdate"));
				requestBox.put("endDateMobile", searchThreeMonthMobile.get("enddate"));
				
				requestBox.put("searchFlag", "L");
				
			} else {

				requestBox.put("searchStrYear", requestBox.get("searchStrDateMobile").substring(0, 4));
				requestBox.put("searchStrMonth", requestBox.get("searchStrDateMobile").substring(5, 7));
				requestBox.put("searchEndYear", requestBox.get("searchEndDateMobile").substring(0, 4));
				requestBox.put("searchEndMonth", requestBox.get("searchEndDateMobile").substring(5, 7));
				
				/** 화면에 표현될 데이터 */
				requestBox.put("strDateMobile", requestBox.get("searchStrDateMobile"));
				requestBox.put("endDateMobile", requestBox.get("searchEndDateMobile"));
				
			}
			
			requestBox.put("calStarYeaer", searchThreeMonthMobile.get("staryeaer"));
			requestBox.put("calStarMonth", searchThreeMonthMobile.get("starmonth"));
			requestBox.put("calToday", searchThreeMonthMobile.get("today"));
			
			/**----------------------------페이징-------------------------------------------*/
			
			PageVO pageVO = new PageVO(requestBox);		
			if(("").equals(requestBox.getString("page")) || ("0").equals(requestBox.getString("page"))){
				requestBox.put("page", "1");
			}
			
			if("".equals(requestBox.getString("rowPerPage"))){
				requestBox.put("rowPerPage", sRowPerPage);
			}
			
			LOGGER.debug("requestBox : {}", requestBox);
			
			if(("").equals(requestBox.getString("totalCount")) || ("0").equals(requestBox.getString("totalCount"))) {
				pageVO.setTotalCount(expInfoService.expInfoListCount(requestBox));
				requestBox.put("totalPage", pageVO.getTotalPages());
				requestBox.put("firstIndex", 1);
			} else {
				pageVO.setTotalCount(requestBox.getString("totalCount"));
			}
			
			pageVO.setPage(requestBox.getString("page"));
			pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
			requestBox.putAll(pageVO.toMapData());
	
			PagingUtil.defaultParmSetting(requestBox);
			/**--------------------------------------------------------------------------*/

			/** 현재 hybris의 경로 */
			model.addAttribute("hybrisUrl", UtilAPI.getCurerntHybrisLocation());
			
			/** 체험 예약 현황 리스트 */
			List<Map<String, String>> expInfoList = expInfoService.expInfoList(requestBox);
			model.addAttribute("expInfoList", expInfoList);
			
			model.addAttribute("scrData", requestBox);
			
			mav = new ModelAndView("/mobile/reservation/exp/expInfoList");
			
			return mav;
		}else{
			mav = new ModelAndView("/mobile/reservation/exp/expCultureInfoList");
			
			/** 체험 예약 현황 리스트 */
			mav.addObject("expCultureInfoList", expCultureService.expCultureInfoListMobile(requestBox));
			mav.addObject("nonMember", requestBox.get("nonMember"));
			mav.addObject("nonMemberId", requestBox.get("nonMemberId"));
			
			/** 현재 hybris의 경로 */
			model.addAttribute("hybrisUrl", UtilAPI.getCurerntHybrisLocation());
			
			return mav;
		}
	}
	
	/**
	 * 체험 얘약 현황 상세 리스트
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoDetailList.do", method = RequestMethod.POST)
	public ModelAndView expInfoDetailList(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/mobile/reservation/exp/expInfoDetailList");
		
		mav.addObject("partnerTypeCodeList", super.partnerTypeCodeList());									//동반자 코드 리스트
		
		/** 임시 id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		Map<String, String> memberInfo = super.reservationCheckerService.getMemberInformation(requestBox);
		requestBox.put("accountname", memberInfo.get("accountname"));
		
		/** 체험 예약 현황 상세 리스트 */
		List<Map<String, String>> expInfoDetailList = expInfoService.expInfoDetailList(requestBox);
		mav.addObject("expInfoDetailList", expInfoDetailList);
		
		/** 파라미터값 */
		model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = super.commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		model.addAttribute("httpDomain", UtilAPI.getApiLocation());
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
		// adobe analytics

		return mav;
	}
	
	/**
	 * 체험 예약 현황 동반여부 변경
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/changePartnertAjax.do")
	public ModelAndView changePartnertAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		/** 임시 id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		int result = expInfoService.changePartnertAjax(requestBox);
		
		if(result > 0){
			mav.addObject("msg", "success");
		}else{
			mav.addObject("msg", "error");
			
		}
		return mav;
	}
	
	/**
	 * 체험 얘약현황 예약 취소 팝업 호출
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoRsvCanselPop.do")
	public ModelAndView expInfoRsvCanselPop(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/exp/expInfoRsvCancelPop");
		
		/** 파라미터값 */
		model.addAttribute("scrData", requestBox);
		
		return mav;
	}
	
	/**
	 * 체험 예약 현황  예약 취소
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateCancelCodeAjax.do", method = RequestMethod.POST)
	public ModelAndView updateCancelCodeAjax(ModelMap model, RequestBox requestBox)throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		int result = expInfoService.updateCancelCodeAjax(requestBox);
		
		if(result > 0){
			mav.addObject("msg", "success");
		}else{
			mav.addObject("msg", "error");
			
		}
		
		expInfoService.updateStandByNumber(requestBox);
		
		return mav;
	}
	
	/**
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/viewTypeCalendarAjax", method = RequestMethod.POST)
	public ModelAndView viewTypeCalendarAjax(ModelMap model, RequestBox requestBox) throws Exception{
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
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/rsvExpDetailInfoAjax.do")
	public ModelAndView rsvExpDetailInfoAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		/** 해당월에 예약한 체험 프로그램 리스트 조횐 */
		List<Map<String, String>> expReservationInfoDetailList = basicReservationService.expReservationInfoDetailList(requestBox);
		mav.addObject("expReservationInfoDetailList", expReservationInfoDetailList);
		
		return mav;
	}
	
	/**
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value  = "/searchThreeMonthMobileAjax.do")
	public ModelAndView searchThreeMothListMobile(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		Map<String, String> searchThreeMonthMobile = expInfoService.searchThreeMonthMobile(requestBox);
		mav.addObject("searchThreeMonthMobile", searchThreeMonthMobile);
		
		return mav;
	}
	
	/**
	 * 
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoMoreListAjax.do")
	public ModelAndView expInfoMoreListAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = null;
		
		requestBox.put("account", requestBox.getSession("abono"));
		
		if(("").equals(requestBox.get("searchStrDateMobile")) || ("").equals(requestBox.get("searchEndDateMobile"))){
			/** 디폴트 날짜 검색 조건 셋팅 [현재시작일~3개월후 마지막날 조회] */
			Map<String, String> searchThreeMonthMobile = expInfoService.searchThreeMonthMobile(requestBox);
			model.addAttribute("searchThreeMonthMobile", searchThreeMonthMobile);
			
			/** 디폴트 날짜 검색 조건 셋팅 */
//			requestBox.put("searchStrDateMobile", searchThreeMonthMobile.get("strdate"));
//			requestBox.put("searchEndDateMobile", searchThreeMonthMobile.get("enddate"));
			
			requestBox.put("searchStrYear", searchThreeMonthMobile.get("strdate").substring(0, 4));
			requestBox.put("searchStrMonth", searchThreeMonthMobile.get("strdate").substring(5, 7));
			requestBox.put("searchEndYear", searchThreeMonthMobile.get("enddate").substring(0, 4));
			requestBox.put("searchEndMonth", searchThreeMonthMobile.get("enddate").substring(5, 7));
			
		}else{
			requestBox.put("searchStrYear", requestBox.get("searchStrDateMobile").substring(0, 4));
			requestBox.put("searchStrMonth", requestBox.get("searchStrDateMobile").substring(5, 7));
			requestBox.put("searchEndYear", requestBox.get("searchEndDateMobile").substring(0, 4));
			requestBox.put("searchEndMonth", requestBox.get("searchEndDateMobile").substring(5, 7));
		}
		
		
		/**----------------------------페이징-------------------------------------------*/
		
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.get("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}

		
		pageVO.setTotalCount(expInfoService.expInfoListCount(requestBox));
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
		List<Map<String, String>> expInfoList = expInfoService.expInfoList(requestBox);
		model.addAttribute("expInfoList", expInfoList);
		
		model.addAttribute("scrData", requestBox);
		
		mav = new ModelAndView("/mobile/reservation/exp/expInfoMoreList");
		
		return mav;
	}
	
	/**
	 * 체험 프로그램 신청 여부 체크
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expProgramVailabilityCheckAjax.do")
	public ModelAndView expProgramVailabilityCheckAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		Map<Object, String> ProgramVailability = new HashMap<Object, String>();
		RequestBox tempRequestBox = new RequestBox(new String());
		tempRequestBox.put("account", requestBox.getSession("abono"));
		LOGGER.debug("==================> Mobile 체험 중복 신청 체크 : {}", requestBox);
		if(requestBox.getSession("abono").equals("")) {
			LOGGER.debug("==================> 비회원 체험 중복 신청 체크 : {}", tempRequestBox.get("account"));
			if( !requestBox.get("tempTypeSeq").equals("") ) {
				for(int i = 0; i < requestBox.getVector("tempTypeSeq").size(); i++){
					tempRequestBox.put("expseq", requestBox.getVector("tempExpSeq").get(i));
					tempRequestBox.put("reservationDate", requestBox.getVector("tempReservationDate").get(i));
					tempRequestBox.put("expSessionSeq", requestBox.getVector("tempExpSessionSeq").get(i));
					tempRequestBox.put("nonMemberId", requestBox.get("nonMemberId"));
					
					int cnt = basicReservationService.expProgramVailabilityCheckAjax(tempRequestBox);
					
					if(cnt==0) {
						ProgramVailability.put("cnt", "0");
					} else {
						ProgramVailability.put("cnt", "1");
						break;
					}
				}
			} else {
				ProgramVailability.put("cnt", "0");
				LOGGER.debug("==================> 비회원 체험 중복 신청 체크 안함 ");
			}
		} else {
			LOGGER.debug("==================> 회원 체험 중복 신청 체크 : {}", tempRequestBox.get("account"));
			for(int i = 0; i < requestBox.getVector("typeSeq").size(); i++){
				tempRequestBox.put("expseq", requestBox.getVector("expseq").get(i));
				tempRequestBox.put("reservationDate", requestBox.getVector("reservationDate").get(i));
				tempRequestBox.put("expSessionSeq", requestBox.getVector("expSessionSeq").get(i));
				tempRequestBox.put("nonMemberId", "");
				
				int cnt = basicReservationService.expProgramVailabilityCheckAjax(tempRequestBox);
				
				if(cnt==0) {
					ProgramVailability.put("cnt", "0");
				} else {
					ProgramVailability.put("cnt", "1");
					break;
				}
			}
		
		}
		
		mav.addObject("ProgramVailability", ProgramVailability);
		
		return mav;
	}
	
}
