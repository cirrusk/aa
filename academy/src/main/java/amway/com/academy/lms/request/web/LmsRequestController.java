package amway.com.academy.lms.request.web;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.lms.common.LmsCode;
import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.common.service.LmsCommonService;
import amway.com.academy.lms.common.web.LmsCommonController;
import amway.com.academy.lms.request.service.LmsRequestService;
import egovframework.com.utl.fcc.service.EgovDateUtil;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :LmsRequestController.java
 * @DESC : 통합교육신청 메뉴 콘트롤러
 *        - 통합교육신청의 과정 목록과 상세 화면 콘트롤러임
 * @Author:KR620243
 * @VER : 1.0 ------------------------------------------------------------------------------ 변 경 사 항
 *      ------------------------------------------------------------------------------ DATE AUTHOR
 *      DESCRIPTION ------------- ------ --------------------------------------------------- 
 *      2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */

@Controller
@RequestMapping("/lms/request")
public class LmsRequestController {
	
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsRequestController.class);
	
	@Autowired
	LmsRequestService lmsRequestService;
	
	@Autowired
	LmsCommonService lmsCommonService;
	
	@Autowired
	LmsUtil lmsUtil;

	@Autowired
	LmsCommonController lmsCommonController;
	
	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	/**
	 * 통합교육 신청 정규과정 리스트
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsCourse.do")
	public ModelAndView lmsRequestCourseList(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{

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

		// 과정타입 설정 정규과정
		requestBox.put("coursetype", "R");

		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		String blankStr = "";
		if(blankStr.equals(requestBox.getString("page"))) {requestBox.put("page", "1");}
		if(blankStr.equals(requestBox.getString("rowPerPage"))) {requestBox.put("rowPerPage", "10000");}

		pageVO.setTotalCount(1000);
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", 1);
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());

		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		mav.addObject("courseList", lmsRequestService.selectLmsRequestList(requestBox));
		mav.addObject("httpDomain", lmsUtil.getDomain(request));
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		mav.addObject("analBox", analBox);
		// adobe analytics		
		
		return mav;
	}
	
	
	/**
	 * 통합교육 신청 정규과정 상세
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsCourseView.do")
	public ModelAndView lmsRequestCourseDetail(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{

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

		// 과정타입 설정 정규과정
		requestBox.put("coursetype", "R");
		// 상세
		mav.addObject("detail", lmsRequestService.selectLmsRequestRegularDetail(requestBox));
		mav.addObject("userinfo", lmsCommonService.selectLmsMemberInfo(requestBox));
		mav.addObject("httpDomain", lmsUtil.getDomain(request));
		mav.addObject("abnHttpDomain", LmsCode.getHybrisHttpDomain());
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		mav.addObject("analBox", analBox);
		// adobe analytics				
		
		return mav;
	}
	
	/**
	 * 통합교육 신청 오프라인과정 리스트
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsOffline.do")
	public ModelAndView lmsRequestOfflineList(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{

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
		// 과정타입 설정 정규과정
		requestBox.put("coursetype", "F");
		Vector<Object> searchapseqArr = requestBox.getVector("searchapseq");
		String searchYn = requestBox.get("searchYn");
		int check0 = 0;
		String yStr = "Y";
		if(yStr.equals(searchYn) && searchapseqArr.size() == check0){
			searchapseqArr.add(0, "99999999");
		}
		requestBox.put("searchapseqArr", searchapseqArr);
		mav.addObject("searchapseqArr", searchapseqArr);
		
		String searchyear = requestBox.get("searchyear");
		String searchmonth = requestBox.get("searchmonth");
		String searchday = requestBox.getStringDefault("searchday", "01");
		if("".equals(searchyear)){
			searchyear = EgovDateUtil.getToday().substring(0, 4);
			searchmonth = EgovDateUtil.getToday().substring(4, 6);
		}
		mav.addObject("searchyear", searchyear);
		mav.addObject("searchmonth", searchmonth);
		mav.addObject("searchday", searchday);
		
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if("".equals(requestBox.getString("page"))) {requestBox.put("page", "1");}
		if("".equals(requestBox.getString("rowPerPage"))) {requestBox.put("rowPerPage", "10000");}
		pageVO.setTotalCount(1000);
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", 1);
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());

		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		mav.addObject("courseList", lmsRequestService.selectLmsRequestList(requestBox));
		
		// 교육장소 목록 서칭
		mav.addObject("apList", lmsRequestService.selectLmsRequestApList(requestBox));
		mav.addObject("httpDomain", lmsUtil.getDomain(request));
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		mav.addObject("analBox", analBox);
		// adobe analytics		
		
		return mav;
	}

	/**
	 * 통합교육 신청 오프라인과정 월별
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsOfflineMonth.do")
	public ModelAndView lmsRequestOfflineMonthList(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		String successStr = "SUCCESS";
		if( !successStr.equals(loginMap.get("result")) ) {
			mav.addObject("result", "LOGOUT");
		}
		
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			mav.addObject("result", "LOGOUT");
		}
		// 과정타입 설정 정규과정
		requestBox.put("coursetype", "F");
		Vector<Object> searchapseqArr = requestBox.getVector("searchapseq");
		String searchYn = requestBox.get("searchYn");
		int check0 = 0;
		String yStr = "Y";
		if(yStr.equals(searchYn) && searchapseqArr.size() == check0){
			searchapseqArr.add(0, "99999999");
		}
		requestBox.put("searchapseqArr", searchapseqArr);
		mav.addObject("searchapseqArr", searchapseqArr);
		
		String nowyear = EgovDateUtil.getToday().substring(0, 4);
		String nowmonth = EgovDateUtil.getToday().substring(4, 6);
		String searchyear = requestBox.get("searchyear");
		String searchmonth = requestBox.get("searchmonth");
		String searchday = requestBox.getStringDefault("searchday", "01");
		if("".equals(searchyear)){
			searchyear = nowyear;
			searchmonth = nowmonth;
		}
		mav.addObject("searchyear", searchyear);
		mav.addObject("searchmonth", searchmonth);
		mav.addObject("searchday", searchday);
		if(nowyear.equals(searchyear) && nowmonth.equals(searchmonth)){
			mav.addObject("nowyn", "Y");
		}
		
		requestBox.put("searchdate", searchyear+"-"+searchmonth);
		
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if("".equals(requestBox.getString("page"))) {requestBox.put("page", "1");}
		if("".equals(requestBox.getString("rowPerPage"))) {requestBox.put("rowPerPage", "10000");}
		pageVO.setTotalCount(1000);
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", 1);
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());

		PagingUtil.defaultParmSetting(requestBox);
		
		//달력 리스트
		mav.addObject("monthList", lmsRequestService.selectLmsRequestMonthDate(requestBox));
		
		// 오프라인 리스트
		mav.addObject("courseList", lmsRequestService.selectLmsRequestList(requestBox));
		
		// 교육장소 목록 서칭
		mav.addObject("apList", lmsRequestService.selectLmsRequestApList(requestBox));
		mav.addObject("httpDomain", lmsUtil.getDomain(request));
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		mav.addObject("analBox", analBox);
		// adobe analytics		
		
		return mav;
	}
	
	
	/**
	 * 통합교육 신청 오프라인과정 상세
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsOfflineView.do")
	public ModelAndView lmsRequestOfflineDetail(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{

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
		Vector<Object> searchapseqArr = requestBox.getVector("searchapseq");
		mav.addObject("searchapseqArr", searchapseqArr);
		
		// 과정타입 설정 오프라인
		requestBox.put("coursetype", "F");
		// 상세
		mav.addObject("detail", lmsRequestService.selectLmsRequestOfflineDetail(requestBox));
		mav.addObject("userinfo", lmsCommonService.selectLmsMemberInfo(requestBox));
		mav.addObject("httpDomain", lmsUtil.getDomain(request));
		mav.addObject("abnHttpDomain", LmsCode.getHybrisHttpDomain());
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		mav.addObject("analBox", analBox);
		// adobe analytics		
		
		return mav;
	}
	
	
	/**
	 * 통합교육 신청 라이브과정 리스트
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsLive.do")
	public ModelAndView lmsRequestLiveList(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{

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
		
		// 과정타입 설정 라이브교육
		requestBox.put("coursetype", "L");
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if("".equals(requestBox.getString("page"))) {requestBox.put("page", "1");}
		if("".equals(requestBox.getString("rowPerPage"))) {requestBox.put("rowPerPage", "10000");}
		pageVO.setTotalCount(1000);
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", 1);
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());

		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		mav.addObject("courseList", lmsRequestService.selectLmsRequestList(requestBox));
		mav.addObject("httpDomain", lmsUtil.getDomain(request));
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		mav.addObject("analBox", analBox);
		// adobe analytics		
		
		return mav;
	}
	
	
	/**
	 * 통합교육 신청 라이브교육 상세
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsLiveView.do")
	public ModelAndView lmsRequestLiveDetail(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{

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
		
		// 과정타입 설정 라이브교육
		requestBox.put("coursetype", "L");
		// 상세
		mav.addObject("detail", lmsRequestService.selectLmsRequestLiveDetail(requestBox));
		mav.addObject("httpDomain", lmsUtil.getDomain(request));
		mav.addObject("abnHttpDomain", LmsCode.getHybrisHttpDomain());
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		mav.addObject("analBox", analBox);
		// adobe analytics		
		
		return mav;
	}

	
	
	
	
	/**
	 * 통합교육 신청 처리
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsCourseRequestAjax.do")
	public ModelAndView lmsCourseRequestAjax(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		String successStr = "SUCCESS";
		if( !successStr.equals(loginMap.get("result")) ) {
			rtnMap.put("result", "LOGOUT");
		}
		
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			rtnMap.put("result", "LOGOUT");
		}
    	// 수강 신청 처리
		rtnMap = lmsRequestService.insertCourseRequest(requestBox);

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;

	}	
	
	/**
	 * 통합교육 신청 팝업
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/lmsCourseRequestResult.do")
	public ModelAndView lmsCourseRequestPop(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{
		mav.addObject("amwaygo",  lmsUtil.getAmwayGoLink());
		return mav;
	}	
	
	
	
}
