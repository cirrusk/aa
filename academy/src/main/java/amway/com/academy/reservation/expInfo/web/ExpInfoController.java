package amway.com.academy.reservation.expInfo.web;

import java.io.InputStream;
import java.util.ArrayList;
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

import amway.com.academy.common.util.CheckSSO;
import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.common.util.UtilAPI;
import amway.com.academy.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.reservation.expCulture.service.ExpCultureService;
import amway.com.academy.reservation.expInfo.service.ExpInfoService;
import amway.com.academy.reservation.roomEdu.web.RoomEduController;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;

/**
 * <pre>
 * 		-체험 예약 컨트롤러
 * 			: FRONT- 사용자의 체험얘약 현황 확인 컨트롤러
 * </pre>
 * Program Name  : ExpInfoController.java
 * Author : KR620225
 * Creation Date : 2016. 8. 11.
 */
@RequestMapping("/reservation")
@Controller
public class ExpInfoController extends BasicReservationController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExpInfoController.class);
	
	@Autowired
	private ExpInfoService expInfoService;
	
	@Autowired
	private ExpCultureService expCultureService;
	
	/** adobe analytics */
	@Autowired
	private CommomCodeUtil commonCodeUtil;

	private String sRowPerPage = "10"; // 페이지에 넣을 row수

	/**
	 * 체험 예약 현황 리스트
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoList.do")
	public ModelAndView expInfoList(ModelMap model, RequestBox requestBox, HttpServletRequest request) throws Exception{
		
		LOGGER.debug("invoke ExpInfoController.expInfoList");
		
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
		
//		requestBox.put("account", requestBox.getSession("abono"));
		
		if (imarCheck){
			
			LOGGER.debug("@@@@@@@@ account : {}", requestBox.get("account"));
			if (!"".equals(ssoValue)){
				requestBox.put("account", ssoValue);
			}
			
			ModelAndView mav = new ModelAndView("/reservation/exp/expInfoList");

			/**----------------------------검색 조건------------------------------------------*/
			mav.addObject("reservationYearCodeList", super.reservationYearCodeList());							// 년도
			mav.addObject("reservationFormatingMonthCodeList", super.reservationFormatingMonthCodeList());		//월
			mav.addObject("expRsvTypeInfoCodeList", super.expRsvTypeInfoCodeList());							//체험종류
			mav.addObject("ppCodeList", super.ppCodeList());													//pp리스트
			/**--------------------------------------------------------------------------*/
			
			/** 디폴트 날짜 검색 조건 셋팅 [현재시작일~3개월후 마지막날 조회] */
			Map<String, String> searchThreeMonthMobile = expInfoService.searchThreeMonthMobile(requestBox);
			
			//검색 조건이 없을 경우 날짜 검색 조건 셋팅
			if(("").equals(requestBox.get("searchStrYear")) || ("").equals(requestBox.get("searchEndYear"))){
				
				requestBox.put("searchStrYear", searchThreeMonthMobile.get("staryeaer"));
				requestBox.put("searchStrMonth", searchThreeMonthMobile.get("starmonth"));
				requestBox.put("searchEndYear", searchThreeMonthMobile.get("endyeaer"));
				requestBox.put("searchEndMonth", searchThreeMonthMobile.get("endmonth"));

				/** 디폴트 날짜 검색 조건 셋팅 */
//				requestBox.put("searchStrDateMobile", searchThreeMonthMobile.get("strdate"));
//				requestBox.put("searchEndDateMobile", searchThreeMonthMobile.get("enddate"));
				
//				requestBox.put("searchFlag", "L");
			}
			
			requestBox.put("calStarYeaer", searchThreeMonthMobile.get("staryeaer"));
			requestBox.put("calStarMonth", searchThreeMonthMobile.get("starmonth"));
			requestBox.put("calEndYeaer", searchThreeMonthMobile.get("endyeaer"));
			requestBox.put("calEndMonth", searchThreeMonthMobile.get("endmonth"));
			requestBox.put("calToday", searchThreeMonthMobile.get("today"));
			
			/**----------------------------페이징-------------------------------------------*/
			PageVO pageVO = new PageVO(requestBox);		
			if(("").equals(requestBox.getString("page")) || ("0").equals(requestBox.getString("page"))){
				requestBox.put("page", "1");
			}
			
			if("".equals(requestBox.getString("rowPerPage"))) {
				requestBox.put("rowPerPage", sRowPerPage);
			}
			
			if(("").equals(requestBox.getString("totalCount")) || ("0").equals(requestBox.getString("totalCount"))) {
				/** 체험 예약 현황 리스트 카운트 */
				pageVO.setTotalCount(expInfoService.expInfoListCount(requestBox));
				requestBox.put("totalPage", pageVO.getTotalPages());
				requestBox.put("firstIndex", 1);
			} else {
				pageVO.setTotalCount(requestBox.getString("totalCount"));
			}
			
			pageVO.setTotalCount(expInfoService.expInfoListCount(requestBox));
			requestBox.put("totalPage", pageVO.getTotalPages());
			requestBox.put("firstIndex", 1);
			
			pageVO.setPage(requestBox.getString("page"));
			pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
			requestBox.putAll(pageVO.toMapData());
	
			PagingUtil.defaultParmSetting(requestBox);
			
			model.addAttribute("scrData", requestBox);
			/**--------------------------------------------------------------------------*/
			
			/** 현재 hybris의 경로 */
			mav.addObject("hybrisUrl", UtilAPI.getCurerntHybrisLocation());
			
			/** 체험 예약 현황 리스트 */
	//		List<Map<String, String>> expInfoList = expInfoService.expInfoList(requestBox);
			mav.addObject("expInfoList", expInfoService.expInfoList(requestBox));
			
			// adobe analytics
			DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
			model.addAttribute("analBox", analBox);
			// adobe analytics

			return mav;
			
		}else{
			
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
//			System.out.println(requestBox);
			/**--------------------------------------------------------------------------*/
			
			/** 현재 hybris의 경로 */
			mav.addObject("hybrisUrl", UtilAPI.getCurerntHybrisLocation());
			
			/** 체험 예약 현황 리스트 */
			mav.addObject("expCultureInfoList", expCultureService.expCultureInfoList(requestBox));
			
			// adobe analytics
			DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
			model.addAttribute("analBox", analBox);
			// adobe analytics

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
	@RequestMapping(value = "/expInfoDetailList.do")
	public ModelAndView expInfoDetailList(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/reservation/exp/expInfoDetailList");
		
		mav.addObject("partnerTypeCodeList", super.partnerTypeCodeList());									//동반자 코드 리스트
		
		/** 임시 id값 */
		requestBox.put("account", requestBox.getSession("abono"));
		
		LOGGER.debug("################################ expInfoDetailList");
		LOGGER.debug(""+requestBox);
		LOGGER.debug("################################ expInfoDetailList");
		Map<String, String> memberInfo = super.reservationCheckerService.getMemberInformation(requestBox);
		requestBox.put("accountname", memberInfo.get("accountname"));
		
		/** 체험 예약 현황 상세 리스트 */
		List<Map<String, String>> expInfoDetailList = expInfoService.expInfoDetailList(requestBox);
		mav.addObject("expInfoDetailList", expInfoDetailList);
		
		
		
		LOGGER.debug("################################ expInfoDetailList");
		LOGGER.debug(""+expInfoDetailList);
		LOGGER.debug("################################ expInfoDetailList");
		
		
//		Map<String, String> searchExpPenaltyYn = expInfoService.searchExpPenaltyYn(requestBox);
//		requestBox.put("typecode", searchExpPenaltyYn.get("typecode"));
		
		/** 파라미터값 */
		model.addAttribute("scrData", requestBox);
		model.addAttribute("httpDomain", UtilAPI.getApiLocation());
		model.addAttribute("currentDomain", UtilAPI.getCurrentServerLocation());
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
		String sessinAccount = requestBox.getSession("abono");
		
		/* 예약자와 세션 사용자와 같은지 검사 */
		String reservationAccount = this.expInfoService.expInfoByRsvSeq(requestBox);
		
		if(!sessinAccount.equals(reservationAccount)){
			model.put("errorMsg", "예약자가 동일하지 않습니다.");
			return mav;
		}
		
		/* 취소 상태로 변경 */
		expInfoService.updateCancelCodeAjax(requestBox);
		
		/* 대기 상태가 있으면, 예약 상태로  */
		expInfoService.updateStandByNumber(requestBox);
		
		return mav;
	}
	
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
	 * 체험 프로그램 신청 여부 체크
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expProgramVailabilityCheckAjax.do")
	public ModelAndView expProgramVailabilityCheckAjax(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		Map<String, Object> ProgramVailability     = new HashMap<String, Object>();
		
		RequestBox tempRequestBox = new RequestBox(new String());
		tempRequestBox.put("account", requestBox.getSession("abono"));
		LOGGER.debug("==================> PC 체험 중복 신청 체크 : {}", requestBox);
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
