package amway.com.academy.lms.myAcademy.web;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.lms.common.LmsCode;
import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.common.web.LmsCommonController;
import amway.com.academy.lms.myAcademy.service.LmsMyAcademyService;
import egovframework.com.utl.fcc.service.EgovDateUtil;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.DateUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :LmsMyAcademyController.java
 * @DESC : 교육신청 현황
 *        - 자신의 교육신청 현황 목록과 상세 화면 구성 
 * @Author:KR620243
 * @VER : 1.0 ------------------------------------------------------------------------------ 변 경 사 항
 *      ------------------------------------------------------------------------------ DATE AUTHOR
 *      DESCRIPTION ------------- ------ --------------------------------------------------- 
 *      2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */

@Controller
@RequestMapping("/lms/myAcademy")
public class LmsMyAcademyController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsMyAcademyController.class);

	@Autowired
	LmsUtil lmsUtil;

	/*
	 * Service
	 * 과정 테이블을 공용으로 사용(COURSETYPE 컬럼값이 다름) 
	 */
	@Autowired
    private LmsMyAcademyService lmsMyAcademyService;
	
	@Autowired
	LmsCommonController lmsCommonController;

	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	/**
	 * 통합교육 신청 달력 목록
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsMyRequest.do")
	public ModelAndView lmsMyRequest(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		String successStr = "SUCCESS";
		if( !successStr.equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}
		
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		/*목록에서 코스아이디 있으면 바로 뷰로 간다 시작*/
		String courseid = requestBox.get("courseid");
		String detailyn = requestBox.get("detailyn");
		String coursetype = "";
		boolean courseidExists = false;
		if(!courseid.isEmpty() && !detailyn.isEmpty() && detailyn.equals("y")){
			DataBox dataBox = lmsMyAcademyService.selectLmsMyAcademyListView(requestBox);
			if(dataBox!= null && !dataBox.isEmpty()){
				courseidExists = true;
				coursetype = dataBox.getString("coursetype");
			}
		}
		if(courseidExists){
			if(coursetype.equals("R")){
				return new ModelAndView( "redirect:/lms/myAcademy/lmsMyRequestCourse.do?courseid="+courseid);
			}
			if(coursetype.equals("F")){
				return new ModelAndView( "redirect:/lms/myAcademy/lmsMyRequestOffline.do?courseid="+courseid);
			}
			if(coursetype.equals("L")){
				return new ModelAndView( "redirect:/lms/myAcademy/lmsMyRequestLive.do?courseid="+courseid);
			}
		}
		/*목록에서 코스아이디 있으면 바로 뷰로 간다 끝*/
		String nowyear = EgovDateUtil.getToday().substring(0, 4);
		String nowmonth = EgovDateUtil.getToday().substring(4, 6);
		String nowday = EgovDateUtil.getToday().substring(6, 8);
		model.addAttribute("nowyear", nowyear);
		model.addAttribute("nowmonth", nowmonth);
		model.addAttribute("nowday", nowday);
		String searchyear = requestBox.get("searchyear");
		String searchmonth = requestBox.get("searchmonth");
		String searchday = requestBox.getStringDefault("searchday", "01");
		if("".equals(searchyear)){
			searchyear = nowyear;
			searchmonth = nowmonth;
		}
		model.addAttribute("searchyear", searchyear);
		model.addAttribute("searchmonth", searchmonth);
		model.addAttribute("searchday", searchday);
		if(nowyear.equals(searchyear) && nowmonth.equals(searchmonth)){
			model.addAttribute("nowyn", "Y");
		}
		requestBox.put("searchdate", searchyear+"-"+searchmonth);
		//달력 리스트
		model.addAttribute("monthList", lmsMyAcademyService.selectLmsRequestMonthDate(requestBox));
		
		//과정 목록
		model.addAttribute("courseList", lmsMyAcademyService.selectLmsMyAcademyCourseCalendar(requestBox));
	
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return new ModelAndView("/lms/myAcademy/lmsMyRequest");
	}
	
	/**
	 * 통합교육 신청 페이징 목록
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsMyRequestList.do")
	public ModelAndView lmsMyRequestList(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		String successStr = "SUCCESS";
		if( !successStr.equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}
		
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		String searchyn = requestBox.get("searchyn"); 
		
		String nowyear = EgovDateUtil.getToday().substring(0, 4);
		model.addAttribute("nowyear", nowyear);
		model.addAttribute("nowmonth", Integer.toString(Integer.parseInt(EgovDateUtil.getToday().substring(4, 6))));
		
		Vector<Object> searchcoursetypeArr = requestBox.getVector("searchcoursetype");
		String yStr = "Y";
		int check0 = 0;
		if(yStr.equals(searchyn) && searchcoursetypeArr.size() == check0 ){
			searchcoursetypeArr.add("0");
		}
		requestBox.put("searchcoursetypeArr", searchcoursetypeArr);
		model.addAttribute("searchcoursetypeArr", searchcoursetypeArr);
		if("".equals(searchyn)){
			String nowDate = DateUtil.getDate();
			String nowYear = nowDate.substring(0, 4);
			String nowMonth = nowDate.substring(5, 7);
			requestBox.put("searchstartyear", nowYear);
			requestBox.put("searchstartmonth", Integer.toString(Integer.parseInt(nowMonth)));
			requestBox.put("searchendyear", nowYear);
			requestBox.put("searchendmonth", Integer.toString(Integer.parseInt(nowMonth)));
		}
		
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);	
		String zeroStr = "0";
		String blankStr = "";
		if(blankStr.equals(requestBox.getString("page")) || zeroStr.equals(requestBox.getString("page"))) {requestBox.put("page", "1");}
		if(blankStr.equals(requestBox.getString("rowPerPage"))) {requestBox.put("rowPerPage", "12");}
		pageVO.setTotalCount(lmsMyAcademyService.selectLmsMyAcademyCourseListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", 1);
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == check0) {requestBox.put("page", "1");}
		
		PagingUtil.defaultParmSetting(requestBox);
		
		//과정 목록
		model.addAttribute("courseList", lmsMyAcademyService.selectLmsMyAcademyCourseList(requestBox));
		
		model.addAttribute("scrData", requestBox);
		
		model.addAttribute("statusList", LmsCode.getStatusList());
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return new ModelAndView("/lms/myAcademy/lmsMyRequestList");
	}
	

	/**
	 * 통합교육 신청 정규과정 상세
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsMyRequestCourse.do")
	public ModelAndView lmsMyRequestRegular(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		
		String successStr = "SUCCESS";
		if( !successStr.equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}
		
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		// 상세
		model.addAttribute("detail", lmsMyAcademyService.selectLmsMyAcademyRegular(requestBox));
		model.addAttribute("unitList", lmsMyAcademyService.selectLmsMyAcademyRegularUnit(requestBox));
		model.addAttribute("abnHttpDomain", LmsCode.getHybrisHttpDomain());
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return new ModelAndView("/lms/myAcademy/lmsMyRequestCourse");
	}
	
	/**
	 * 통합교육 신청 오프라인강의 상세
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsMyRequestOffline.do")
	public ModelAndView lmsMyRequestOffline(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		String successStr = "SUCCESS";
		if( !successStr.equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}
		
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		//상세
		model.addAttribute("detail", lmsMyAcademyService.selectLmsMyAcademyOffline(requestBox));
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return new ModelAndView("/lms/myAcademy/lmsMyRequestOffline");
	}
	
	/**
	 * 통합교육 신청 라이브교육 상세
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsMyRequestLive.do")
	public ModelAndView lmsMyRequestLive(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		String successStr = "SUCCESS";
		if( !successStr.equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}
		
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		//상세
		model.addAttribute("detail", lmsMyAcademyService.selectLmsMyAcademyLive(requestBox));
		model.addAttribute("abnHttpDomain", LmsCode.getHybrisHttpDomain());
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		return new ModelAndView("/lms/myAcademy/lmsMyRequestLive");
	}
	
	
	/**
	 * 신청현황 교육신청 취소
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsMyRequestCancelAjax.do")
	public ModelAndView updateLmsMyAcademyCancel(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{
		mav.setView(new JSONView());
		Map<String, Object> map = new HashMap<String, Object>();
		
		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		String successStr = "SUCCESS";
		if( !successStr.equals(loginMap.get("result")) ) {
			map.put("result", "LOGOUT");
			map.put("msg", "로그인이 필요한 서비스입니다.");
			mav.addObject("JSON_OBJECT",  map);
			return mav;
		}
		
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			map.put("result", "LOGOUT");
			map.put("msg", "로그인이 필요한 서비스입니다.");
			mav.addObject("JSON_OBJECT",  map);
			return mav;
		}
		mav.addObject("JSON_OBJECT",  lmsMyAcademyService.updateLmsMyAcademyCancel(requestBox));
		return mav;
	}	
}
