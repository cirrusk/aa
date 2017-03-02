package amway.com.academy.lms.online.web;

import java.net.URLEncoder;
import java.util.ArrayList;
//import java.net.URLDecoder;
import java.util.List;
import java.util.Map;

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
import amway.com.academy.lms.main.service.LmsMainService;
import amway.com.academy.lms.online.service.LmsOnlineService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.DateUtil;
import framework.com.cmm.util.PagingUtil;


/**
 * @author KR620260
 *		date : 2016.08.03
 * lms 온라인강의 컨트롤러
 */
@Controller
@RequestMapping("/lms/online")
public class LmsOnlineController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsOnlineController.class);

	@Autowired
	LmsUtil lmsUtil;

	@Autowired
	LmsCommonController lmsCommonController;

	/*
	 * Service
	 */
	@Autowired
    private LmsOnlineService lmsOnlineService;
	@Autowired
    private LmsMainService lmsMainService;
	
	
	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;

	// CONDITIONTYPE 변수값 설정.
	private String conditiontypeCode = "1";	 //조회구분 1:노출 2:신청	
	
	private String sRowPerPage = "12"; // 페이지에 넣을 row수
	private static final int ZERO = 0;
	private static final int ONE = 1;
	
	/**
	 * LMS 온라인강의 신규
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlineNew.do")
	public ModelAndView lmsOnlineNew(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}

		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "OnlineNew");  // 메뉴분류
		requestBox.put("menuCategoryNm", "신규");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdNewImg);  // 타이틀이미지명
		requestBox.put("coursetype", "O");  // 온라인강의 강제 설정 "O"
		requestBox.put("categoryid", "");  // 
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청	

		requestBox.put("finishflag", requestBox.getString("lectType")); 		// 강의,수강완료
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}
		
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		//저작권동의 여부 확인.
		if( "New".equals(requestBox.getString("listName")) ) {
			requestBox.put("categoryid", requestBox.get("listCategoryCode"));
			int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
			if(agreeCnt < ONE) {
				return new ModelAndView("redirect:/lms/online/lmsOnlineBizInfoAgree.do" + "?categoryid=" + requestBox.get("categoryid"));
			}
			requestBox.put("categoryid", "");
		}
		
		//하이브리스에서 코스아이디 넘어오면 조회 권한 체크할 것
		requestBox.put("hybrischeck", "Y");
		String blankStr = "";
		if( !blankStr.equals(requestBox.get("courseid")) ) {
			requestBox.put("conditioncheck", "Y");
			List<Map<String, Object>> courseView = lmsOnlineService.selectOnlineView(requestBox);
			if( courseView.isEmpty() || courseView.size() == ZERO ) {
				requestBox.put("hybrischeck", "N");
	    	}
		}

		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsOnlineService.selectOnlineListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
    	// 리스트
    	List<Map<String, Object>> courseList = lmsOnlineService.selectOnlineList(requestBox);
		

    	// Adobe Analytics 데이터생성
		requestBox.put("adobeCategory", "Online"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);

		
    	model.addAttribute("courseList", courseList);
    	model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnline");
		
		// 사용변수 초기화
		requestBox.put("courseid", "");
		requestBox.put("savetype", "");
		
		return mav;
	}
	
	/**
	 * LMS 온라인강의 인기
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlineBest.do")
	public ModelAndView lmsOnlineBest(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "OnlineBest");  // 메뉴분류
		requestBox.put("menuCategoryNm", "인기");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdBestImg);  // 타이틀이미지명
		requestBox.put("coursetype", "O");  // 온라인강의 강제 설정 "O"
		requestBox.put("categoryid", "");  // 
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));

		requestBox.put("finishflag", requestBox.getString("lectType")); 		// 강의,수강완료
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "VIEWCOUNT");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}

		//하이브리스에서 코스아이디 넘어오면 조회 권한 체크할 것
		requestBox.put("hybrischeck", "Y");
		String blankStr = "";
		if( !blankStr.equals(requestBox.get("courseid")) ) {
			requestBox.put("conditioncheck", "Y");
			List<Map<String, Object>> courseView = lmsOnlineService.selectOnlineView(requestBox);
			if( courseView.isEmpty() || courseView.size() == ZERO ) {
				requestBox.put("hybrischeck", "N");
	    	}
		}
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsOnlineService.selectOnlineListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
    	// 리스트
    	List<Map<String, Object>> courseList = lmsOnlineService.selectOnlineList(requestBox);
		

    	// Adobe Analytics 데이터생성
    	requestBox.put("adobeCategory", "Online"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);

		
    	model.addAttribute("courseList", courseList);
    	model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnline");
		
		// 사용변수 초기화
		requestBox.put("courseid", "");
		requestBox.put("savetype", "");
		
		return mav;
	}
	

	/**
	 * LMS 온라인강의 비즈니스 이해
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlineBiz.do")
	public ModelAndView lmsOnlineBiz(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "OnlineBiz");  // 메뉴분류
		requestBox.put("menuCategoryNm", "비즈니스 이해");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdBizImg);  // 타이틀이미지명
		requestBox.put("coursetype", "O");  // 온라인강의 강제 설정 "O"
		requestBox.put("categoryid", LmsCode.categoryIdOnlineBiz);  // 비즈니스 이해
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));

		requestBox.put("finishflag", requestBox.getString("lectType")); 		// 강의,수강완료
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		//저작권동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			return new ModelAndView("redirect:/lms/online/lmsOnlineBizInfoAgree.do" + "?categoryid=" + requestBox.get("categoryid"));
		}
		
		//하이브리스에서 코스아이디 넘어오면 조회 권한 체크할 것
		requestBox.put("hybrischeck", "Y");
		String blangStr = "";
		if( !blangStr.equals(requestBox.get("courseid")) ) {
			requestBox.put("conditioncheck", "Y");
			List<Map<String, Object>> courseView = lmsOnlineService.selectOnlineView(requestBox);
			if( courseView.isEmpty() || courseView.size() == ZERO ) {
				requestBox.put("hybrischeck", "N");
	    	}
		}
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsOnlineService.selectOnlineListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
    	// 리스트
    	List<Map<String, Object>> courseList = lmsOnlineService.selectOnlineList(requestBox);
		

    	// Adobe Analytics 데이터생성
    	requestBox.put("adobeCategory", "Online"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);

		
    	model.addAttribute("courseList", courseList);
    	model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnline");

		// 사용변수 초기화
		requestBox.put("courseid", "");
		requestBox.put("savetype", "");
		
		return mav;
	}

	/**
	 * LMS 온라인강의 비즈니스 솔루션
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlineBizSolution.do")
	public ModelAndView lmsOnlineBizSolution(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "OnlineBizSolution");  // 메뉴분류
		requestBox.put("menuCategoryNm", "비즈니스 솔루션");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdBizSolutionImg);  // 타이틀이미지명
		requestBox.put("coursetype", "O");  // 온라인강의 강제 설정 "O"
		requestBox.put("categoryid", LmsCode.categoryIdOnlineBizSolution);  // 비즈니스 솔루션
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));

		requestBox.put("finishflag", requestBox.getString("lectType")); 		// 강의,수강완료
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		//저작권동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			return new ModelAndView("redirect:/lms/online/lmsOnlineBizInfoAgree.do" + "?categoryid=" + requestBox.get("categoryid"));
		}

		//하이브리스에서 코스아이디 넘어오면 조회 권한 체크할 것
		requestBox.put("hybrischeck", "Y");
		String blangStr = "";
		if( !blangStr.equals(requestBox.get("courseid")) ) {
			requestBox.put("conditioncheck", "Y");
			List<Map<String, Object>> courseView = lmsOnlineService.selectOnlineView(requestBox);
			if( courseView.isEmpty() || courseView.size() == ZERO ) {
				requestBox.put("hybrischeck", "N");
	    	}
		}
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsOnlineService.selectOnlineListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
    	// 리스트
    	List<Map<String, Object>> courseList = lmsOnlineService.selectOnlineList(requestBox);
		

    	// Adobe Analytics 데이터생성
    	requestBox.put("adobeCategory", "Online"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);


    	model.addAttribute("courseList", courseList);
    	model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnline");

		// 사용변수 초기화
		requestBox.put("courseid", "");
		requestBox.put("savetype", "");
		
		return mav;
	}

	/**
	 * LMS 온라인강의 뉴트리라이트
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlineNutrilite.do")
	public ModelAndView lmsOnlineNutrilite(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "OnlineNutrilite");  // 메뉴분류
		requestBox.put("menuCategoryNm", "뉴트리라이트");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdNutriliteImg);  // 타이틀이미지명
		requestBox.put("coursetype", "O");  // 온라인강의 강제 설정 "O"
		requestBox.put("categoryid", LmsCode.categoryIdOnlineNutrilite);  // 뉴트리라이트
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));

		requestBox.put("finishflag", requestBox.getString("lectType")); 		// 강의,수강완료
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		//저작권동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			return new ModelAndView("redirect:/lms/online/lmsOnlineBizInfoAgree.do" + "?categoryid=" + requestBox.get("categoryid"));
		}

		//하이브리스에서 코스아이디 넘어오면 조회 권한 체크할 것
		requestBox.put("hybrischeck", "Y");
		String blangStr = "";
		if( !blangStr.equals(requestBox.get("courseid")) ) {
			requestBox.put("conditioncheck", "Y");
			List<Map<String, Object>> courseView = lmsOnlineService.selectOnlineView(requestBox);
			if( courseView.isEmpty() || courseView.size() == ZERO ) {
				requestBox.put("hybrischeck", "N");
	    	}
		}
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsOnlineService.selectOnlineListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
    	// 리스트
    	List<Map<String, Object>> courseList = lmsOnlineService.selectOnlineList(requestBox);
		

    	// Adobe Analytics 데이터생성
    	requestBox.put("adobeCategory", "Online"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);


    	model.addAttribute("courseList", courseList);
    	model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnline");

		// 사용변수 초기화
		requestBox.put("courseid", "");
		requestBox.put("savetype", "");
		
		return mav;
	}

	/**
	 * LMS 온라인강의 아티스트리
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlineArtistry.do")
	public ModelAndView lmsOnlineArtistry(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "OnlineArtistry");  // 메뉴분류
		requestBox.put("menuCategoryNm", "아티스트리");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdArtistryImg);  // 타이틀이미지명
		requestBox.put("coursetype", "O");  // 온라인강의 강제 설정 "O"
		requestBox.put("categoryid", LmsCode.categoryIdOnlineArtistry);  // 아티스트리
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));

		requestBox.put("finishflag", requestBox.getString("lectType")); 		// 강의,수강완료
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		//저작권동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			return new ModelAndView("redirect:/lms/online/lmsOnlineBizInfoAgree.do" + "?categoryid=" + requestBox.get("categoryid"));
		}

		//하이브리스에서 코스아이디 넘어오면 조회 권한 체크할 것
		requestBox.put("hybrischeck", "Y");
		String blangStr = "";
		if( !blangStr.equals(requestBox.get("courseid")) ) {
			requestBox.put("conditioncheck", "Y");
			List<Map<String, Object>> courseView = lmsOnlineService.selectOnlineView(requestBox);
			if( courseView.isEmpty() || courseView.size() == ZERO ) {
				requestBox.put("hybrischeck", "N");
	    	}
		}
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsOnlineService.selectOnlineListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
    	// 리스트
    	List<Map<String, Object>> courseList = lmsOnlineService.selectOnlineList(requestBox);
		

    	// Adobe Analytics 데이터생성
    	requestBox.put("adobeCategory", "Online"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);

		
    	model.addAttribute("courseList", courseList);
    	model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnline");

		// 사용변수 초기화
		requestBox.put("courseid", "");
		requestBox.put("savetype", "");
		
		return mav;
	}

	/**
	 * LMS 온라인강의 홈리빙
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlineHomeliving.do")
	public ModelAndView lmsOnlineHomeliving(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "OnlineHomeliving");  // 메뉴분류
		requestBox.put("menuCategoryNm", "홈리빙");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdHomelivingImg);  // 타이틀이미지명
		requestBox.put("coursetype", "O");  // 온라인강의 강제 설정 "O"
		requestBox.put("categoryid", LmsCode.categoryIdOnlineHomeliving);  // 홈리빙
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));

		requestBox.put("finishflag", requestBox.getString("lectType")); 		// 강의,수강완료
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		//저작권동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			return new ModelAndView("redirect:/lms/online/lmsOnlineBizInfoAgree.do" + "?categoryid=" + requestBox.get("categoryid"));
		}

		//하이브리스에서 코스아이디 넘어오면 조회 권한 체크할 것
		requestBox.put("hybrischeck", "Y");
		String blangStr = "";
		if( !blangStr.equals(requestBox.get("courseid")) ) {
			requestBox.put("conditioncheck", "Y");
			List<Map<String, Object>> courseView = lmsOnlineService.selectOnlineView(requestBox);
			if( courseView.isEmpty() || courseView.size() == ZERO ) {
				requestBox.put("hybrischeck", "N");
	    	}
		}
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsOnlineService.selectOnlineListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
    	// 리스트
    	List<Map<String, Object>> courseList = lmsOnlineService.selectOnlineList(requestBox);
		

    	// Adobe Analytics 데이터생성
    	requestBox.put("adobeCategory", "Online"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);

		
    	model.addAttribute("courseList", courseList);
    	model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnline");

		// 사용변수 초기화
		requestBox.put("courseid", "");
		requestBox.put("savetype", "");
		
		return mav;
	}

	/**
	 * LMS 온라인강의 퍼스널케어
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlinePersonalcare.do")
	public ModelAndView lmsOnlinePersonalcare(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "OnlinePersonalcare");  // 메뉴분류
		requestBox.put("menuCategoryNm", "퍼스널케어");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdPersonalcareImg);  // 타이틀이미지명
		requestBox.put("coursetype", "O");  // 온라인강의 강제 설정 "O"
		requestBox.put("categoryid", LmsCode.categoryIdOnlinePersonalcare);  // 퍼스널케어
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));

		requestBox.put("finishflag", requestBox.getString("lectType")); 		// 강의,수강완료
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		//저작권동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			return new ModelAndView("redirect:/lms/online/lmsOnlineBizInfoAgree.do" + "?categoryid=" + requestBox.get("categoryid"));
		}

		//하이브리스에서 코스아이디 넘어오면 조회 권한 체크할 것
		requestBox.put("hybrischeck", "Y");
		String blangStr = "";
		if( !blangStr.equals(requestBox.get("courseid")) ) {
			requestBox.put("conditioncheck", "Y");
			List<Map<String, Object>> courseView = lmsOnlineService.selectOnlineView(requestBox);
			if( courseView.isEmpty() || courseView.size() == ZERO ) {
				requestBox.put("hybrischeck", "N");
	    	}
		}
				
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsOnlineService.selectOnlineListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
    	// 리스트
    	List<Map<String, Object>> courseList = lmsOnlineService.selectOnlineList(requestBox);
		

    	// Adobe Analytics 데이터생성
    	requestBox.put("adobeCategory", "Online"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);


    	model.addAttribute("courseList", courseList);
    	model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnline");

		// 사용변수 초기화
		requestBox.put("courseid", "");
		requestBox.put("savetype", "");
		
		return mav;
	}

	/**
	 * LMS 온라인강의 레시피
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlineRecipe.do")
	public ModelAndView lmsOnlineRecipe(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "OnlineRecipe");  // 메뉴분류
		requestBox.put("menuCategoryNm", "레시피");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdRecipeImg);  // 타이틀이미지명
		requestBox.put("coursetype", "O");  // 온라인강의 강제 설정 "O"
		requestBox.put("categoryid", LmsCode.categoryIdOnlineRecipe);  // 레시피
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));

		requestBox.put("finishflag", requestBox.getString("lectType")); 		// 강의,수강완료
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		//저작권동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			return new ModelAndView("redirect:/lms/online/lmsOnlineBizInfoAgree.do" + "?categoryid=" + requestBox.get("categoryid"));
		}

		//하이브리스에서 코스아이디 넘어오면 조회 권한 체크할 것
		requestBox.put("hybrischeck", "Y");
		String blangStr = "";
		if( !blangStr.equals(requestBox.get("courseid")) ) {
			requestBox.put("conditioncheck", "Y");
			List<Map<String, Object>> courseView = lmsOnlineService.selectOnlineView(requestBox);
			if( courseView.isEmpty() || courseView.size() == ZERO ) {
				requestBox.put("hybrischeck", "N");
	    	}
		}
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsOnlineService.selectOnlineListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
    	// 리스트
    	List<Map<String, Object>> courseList = lmsOnlineService.selectOnlineList(requestBox);
		

    	// Adobe Analytics 데이터생성
    	requestBox.put("adobeCategory", "Online"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);


    	model.addAttribute("courseList", courseList);
    	model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnline");

		// 사용변수 초기화
		requestBox.put("courseid", "");
		requestBox.put("savetype", "");
		
		return mav;
	}

	/**
	 * LMS 온라인강의 건강영양
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlineHealthNutrition.do")
	public ModelAndView lmsOnlineHealthNutrition(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "OnlineHealthNutrition");  // 메뉴분류
		requestBox.put("menuCategoryNm", "건강영양");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdHealthNutritionImg);  // 타이틀이미지명
		requestBox.put("coursetype", "O");  // 온라인강의 강제 설정 "O"
		requestBox.put("categoryid", LmsCode.categoryIdOnlineHealthNutrition);  // 건강영양
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));

		requestBox.put("finishflag", requestBox.getString("lectType")); 		// 강의,수강완료
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		//저작권동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			return new ModelAndView("redirect:/lms/online/lmsOnlineBizInfoAgree.do" + "?categoryid=" + requestBox.get("categoryid"));
		}

		//하이브리스에서 코스아이디 넘어오면 조회 권한 체크할 것
		requestBox.put("hybrischeck", "Y");
		String blangStr = "";
		if( !blangStr.equals(requestBox.get("courseid")) ) {
			requestBox.put("conditioncheck", "Y");
			List<Map<String, Object>> courseView = lmsOnlineService.selectOnlineView(requestBox);
			if( courseView.isEmpty() || courseView.size() == ZERO ) {
				requestBox.put("hybrischeck", "N");
	    	}
		}
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsOnlineService.selectOnlineListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.getString("page"));
		pageVO.setRowPerPage(requestBox.getString("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
    	// 리스트
    	List<Map<String, Object>> courseList = lmsOnlineService.selectOnlineList(requestBox);
		

    	// Adobe Analytics 데이터생성
    	requestBox.put("adobeCategory", "Online"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);


    	model.addAttribute("courseList", courseList);
    	model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnline");

		// 사용변수 초기화
		requestBox.put("courseid", "");
		requestBox.put("savetype", "");
		
		return mav;
	}

	/**
	 * LMS 온라인강의 상세보기
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlineView.do")
	public ModelAndView lmsOnlineView(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		

		ModelAndView mav = null;

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if ( "N".equals(requestBox.getString("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		//조회조건, 변수 설정
		requestBox.put("coursetype", "O");  // 온라인강의 강제 설정 "O"
		requestBox.put("conditiontype", "2"); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		
		String uID = requestBox.get(LmsCode.userSessionUid);
		//String distNo = "";		// 회원번호
		StringBuffer distNo = new StringBuffer();  // 회원번호
        
		String infoName = "암웨이한국";
		String iboType = "NP"; 
		String nowTime = DateUtil.getDateType("yyyyMMddHHmm");	// 년월일시분
		String pCreationtime = requestBox.get(LmsCode.userSessionCreationtime); 	// 가입일자
    	String pActivityid = "";
		String pActivitycode = "";
		
		List<Map<String, Object>> listData;
		
		String pRequestflag = "";
		String pOpenflag = "";
		listData = lmsMainService.selectCourseViewAcces(requestBox);
		
		if(!listData.isEmpty() && listData.size() > ZERO) {
			pRequestflag = (String) listData.get(0).get("requestflag").toString();
			pOpenflag = (String) listData.get(0).get("openflag").toString();
		}
		
		List<Map<String, Object>> courseView = new ArrayList<Map<String, Object>>();
		if( "C".equals(pOpenflag) ) {
			//정규과정인데 수강생이 아니면 빈값 보내기
			if( "Y".equals(pRequestflag) ){
				requestBox.put("conditioncheck", "N");
				courseView = lmsOnlineService.selectOnlineView(requestBox);
				if (!courseView.isEmpty() && courseView.size() > ZERO) {
		    		pActivityid = (String) courseView.get(0).get("activityid").toString();
		    		pActivitycode = (String) courseView.get(0).get("activitycode").toString();
		    	}
			}
		} else {
			//일반 공개면 이용권한 읽기
			requestBox.put("conditioncheck", "Y");
			courseView = lmsOnlineService.selectOnlineView(requestBox);
			if (!courseView.isEmpty() && courseView.size() > ZERO) {
	    		pActivityid = (String) courseView.get(0).get("activityid").toString();
	    		pActivitycode = (String) courseView.get(0).get("activitycode").toString();
	    	} else {
	    		//일반일때 조회 못하면 이용권한, 강의기간 체크하기
	    		int count = lmsOnlineService.selectOnlineViewCount(requestBox);
	    		if( count > ZERO ) {
	    			//수강기간이 종료되었습니다.
	    			pActivitycode = "T";
	    		} else {
	    			//이용권한이 없음
	    			pActivitycode = "A";
	    		}
	    	}
		}
		
		/* distNo 생성 -> '00' + IBO Number */
        /* 7480003 -> 00007480003 */
        final int distNoLength = 11;
        for (int i = 0; i < distNoLength - uID.length(); i++) {
        	distNo.append("0");
        }
        distNo.append(uID);
        
        if (pCreationtime != null && !"".equals(pCreationtime) && (Integer.parseInt(pCreationtime) >= 20080901 && Integer.parseInt(pCreationtime) <= 20090831)) {
        	iboType = "N1";
        }
        String strCell = distNo.toString() + "/" + infoName + "/" + iboType + "/" + pCreationtime + "/" + nowTime;
        
        String strEncrypted = lmsUtil.getEncryptStr(strCell); 											//암호화 설정
    	String paramEncryptVal = URLEncoder.encode(strEncrypted, "UTF8");
    	
    	// glms팝업호출 한다.
        /* 호출 주소 http://www.abnkorea.co.kr/academy/elearning/lms-link?value=<%=strEncrypted%>&activityId=<%=ReplaceTag2text(Request("activityId"))%> */
        /* http://qa2.abnkorea.co.kr/academy/elearning/lms-link?value=g9tf3MGxgXoMg1fN%2BLjKZW18ENGU0PUQZXss8IHGXnaPiLkcnBPYgrFL4R7VxSQsKw3VzcbHKUHASmqbWxRHzQ%3D%3D&activityId=16933  */
        
    	String sHybrisDomain = lmsUtil.getUrlFullLink("", "", "", "", request); // 접속서버에 대한 Link를 반환 한다.
		String paramVal = "/academy/elearning/lms-link?value=" + paramEncryptVal + "&activityId=" + pActivityid;
		String redirectURL = sHybrisDomain + paramVal;
        
        if (pCreationtime == null || pCreationtime.equals("")) {
        	pActivityid = ""; 	// 온라인GLMS - Activityid
        }
        
        requestBox.put("redirectGlmsURL", lmsUtil.getGlmsStr(distNo.toString(), pActivityid)); //glms 직접 전달하는 link
    	requestBox.put("redirectURL", redirectURL); //하이브리스에 보낸 경우
        requestBox.put("activityid", pActivityid);
        requestBox.put("activitycode", pActivitycode);
        
   	    model.addAttribute("courseView", courseView);
		model.addAttribute("scrData", requestBox);
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnlineView");
		
    	/* 테스트 결과 표시 
        String decryptedStr = lmsUtil.getDecryptStr(URLDecoder.decode(paramEncryptVal, "UTF8")); //복호화 설정
    	LOGGER.debug("======================================================================================================================");
    	LOGGER.debug("GLMS Link :: " + redirectURL + "\n");
    	LOGGER.debug("원   문 :: " + strCell);
    	LOGGER.debug("암호화 :: " + paramEncryptVal);
    	LOGGER.debug("복호화 :: " + decryptedStr);
    	LOGGER.debug("======================================================================================================================");
		테스트 결과 표시 end */
    	
		return mav;
	}


	/**
	 * LMS 개인정보활용동의 여부 html - 사용안함. 2016.09.07
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlinePersonalinfoAgree.do")
	public ModelAndView lmsOnlinePersonalinfoAgree(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		
		model.addAttribute("scrData", requestBox);
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnlinePersonalinfoAgree");
		
		return mav;
	}

	/**
	 * LMS 온라인강의 저작권 약관동의 여부 html
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOnlineBizInfoAgree.do")
	public ModelAndView lmsOnlineBizInfoAgree(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		//if("".equals(requestBox.getString("categoryid"))) requestBox.put("categoryid", (String) request.getParameter("categoryid"));
		String sCategoryid = requestBox.get("categoryid");

		// 타이틀명 설정
		if( sCategoryid.equals(LmsCode.categoryIdOnlineBiz) ) {
			requestBox.put("menuCategory", "OnlineBiz");  // 메뉴분류
			requestBox.put("menuCategoryNm", "비즈니스 이해");  // 메뉴분류명
			requestBox.put("menuCategoryImg", LmsCode.categoryIdBizImg);  // 타이틀이미지명
		} else if( sCategoryid.equals(LmsCode.categoryIdOnlineBizSolution) ) { 
	    	requestBox.put("menuCategory", "OnlineBizSolution");
			requestBox.put("menuCategoryNm", "비즈니스 솔루션");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdBizSolutionImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdOnlineNutrilite) ) { 
	    	requestBox.put("menuCategory", "OnlineNutrilite");
			requestBox.put("menuCategoryNm", "뉴트리라이트");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdNutriliteImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdOnlineArtistry) ) { 
	    	requestBox.put("menuCategory", "OnlineArtistry");
			requestBox.put("menuCategoryNm", "아티스트리");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdArtistryImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdOnlineHomeliving) ) { 
	    	requestBox.put("menuCategory", "OnlineHomeliving");
			requestBox.put("menuCategoryNm", "홈리빙");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdHomelivingImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdOnlinePersonalcare) ) { 
	    	requestBox.put("menuCategory", "OnlinePersonalcare");
			requestBox.put("menuCategoryNm", "퍼스널케어");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdPersonalcareImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdOnlineRecipe) ) { 
	    	requestBox.put("menuCategory", "OnlineRecipe");
			requestBox.put("menuCategoryNm", "레시피");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdRecipeImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdOnlineHealthNutrition) ) { 
			requestBox.put("menuCategory", "OnlineHealthNutrition");  
			requestBox.put("menuCategoryNm", "건강영양"); 
			requestBox.put("menuCategoryImg", LmsCode.categoryIdHealthNutritionImg);  // 타이틀이미지명
		} else {
			requestBox.put("menuCategory", "OnlineNew");  // 메뉴분류
			requestBox.put("menuCategoryNm", "신규");  // 메뉴분류명
			requestBox.put("menuCategoryImg", LmsCode.categoryIdNewImg);  // 타이틀이미지명
		}
		
		model.addAttribute("scrData", requestBox);
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/online/lmsOnlineBizInfoAgree");
		
		return mav;
	}

}
