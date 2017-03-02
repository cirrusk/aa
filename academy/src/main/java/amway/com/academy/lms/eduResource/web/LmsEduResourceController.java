package amway.com.academy.lms.eduResource.web;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
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
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.lms.common.LmsCode;
import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.common.web.LmsCommonController;
import amway.com.academy.lms.eduResource.service.LmsEduResourceService;
import amway.com.academy.lms.main.service.LmsMainService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;

/**
 * @author KR620260
 *		date : 2016.08.09
 * lms 교육자료 컨트롤러
 */
@Controller
@RequestMapping("/lms/eduResource")
public class LmsEduResourceController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsEduResourceController.class);

	@Autowired
	LmsUtil lmsUtil;

	@Autowired
	LmsCommonController lmsCommonController;

	/*
	 * Service
	 */
	@Autowired
    private LmsEduResourceService lmsEduResourceService;
	@Autowired
    private LmsMainService lmsMainService;
    
	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	// CONDITIONTYPE 변수값 설정.
	private String conditiontypeCode = "1";	 //조회구분 1:노출 2:신청

	private String sRowPerPage = "12"; // 페이지에 넣을 row수
	
	public static final int ZERO = 0;
	public static final int ONE = 1;
	
	/**
	 * LMS 교육자료 신규
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsEduResourceNew.do")
	public ModelAndView lmsEduResourceNew(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "EduResourceNew");  // 메뉴분류
		requestBox.put("menuCategoryNm", "신규");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdNewImg);  // 타이틀이미지명
		requestBox.put("coursetype", "D");  // 교육자료 강제 설정 "D"
		requestBox.put("categoryid", "");  // 
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		
		//requestBox.put("datatype", requestBox.get("datatype")); 		// 자료유형: M-동영상, S-오디어, F-문서, L-링크, I-이미지	
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}
		if("".equals(requestBox.get("searchType"))) {
			requestBox.put("searchType", "t");
		}
		
		// 교육자료 상세보기 호출인지 확인한다.
		if( "New".equals(requestBox.get("listName")) ) {
			//개인정보활용동의 여부 확인.
			requestBox.put("categoryid", requestBox.get("listCategoryCode"));
			int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
			if(agreeCnt < ONE) {
				StringBuffer sbParam = new StringBuffer();
				sbParam.append("redirect:/lms/eduResource/lmsEduResourceBizInfoAgree.do");
				sbParam.append("?categoryid=").append(requestBox.get("categoryid"));
				return new ModelAndView(sbParam.toString());
			}
			requestBox.put("categoryid", "");
			
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceView.do");
			sbParam.append("?courseid=").append(requestBox.get("courseid"));
			sbParam.append("&menuCategory=").append(requestBox.get("menuCategory"));
			sbParam.append("&categoryid=").append(requestBox.get("listCategoryCode"));
			sbParam.append("&datatype=").append(requestBox.get("datatype"));
			sbParam.append("&sortColumn=").append(requestBox.get("sortColumn"));
			sbParam.append("&searchType=").append(requestBox.get("searchType"));
				//sbParam.append("&sTxt=").append(requestBox.get("searchTxt"));
			sbParam.append("&sTxt=").append(URLEncoder.encode(requestBox.get("searchTxt"), "UTF8"));
			sbParam.append("&page=").append(requestBox.get("page"));
			//String sParam = "redirect:/lms/eduResource/lmsEduResourceView.do?courseid="+requestBox.get("courseid")+"&menuCategory="+requestBox.get("menuCategory")+"&categoryid="+requestBox.get("listCategoryCode")+"&datatype="+requestBox.get("datatype");
			return new ModelAndView(sbParam.toString());
		}
		
		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);

		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.get("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsEduResourceService.selectEduResourceListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.get("page"));
		pageVO.setRowPerPage(requestBox.get("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
    	// 리스트
    	List<Map<String, Object>> courseList = lmsEduResourceService.selectEduResourceList(requestBox);
		

    	// Adobe Analytics 데이터생성
		requestBox.put("adobeCategory", "EduResource"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);

		
    	model.addAttribute("courseList", courseList);
    	model.addAttribute("scrData", requestBox);
    	
    	model.addAttribute("logMap", loginMap);
    	
    	model.addAttribute("dataList", LmsCode.getDataList());
    	
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/eduResource/lmsEduResource");
		
		return mav;
	}
		
	/**
	 * LMS 교육자료 인기
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsEduResourceBest.do")
	public ModelAndView lmsEduResourceBest(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "EduResourceBest");  // 메뉴분류
		requestBox.put("menuCategoryNm", "인기");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdBestImg);  // 타이틀이미지명
		requestBox.put("coursetype", "D");  // 교육자료 강제 설정 "D"
		requestBox.put("categoryid", "");  // 
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "VIEWCOUNT");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}

		
		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
		//	return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.get("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsEduResourceService.selectEduResourceListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.get("page"));
		pageVO.setRowPerPage(requestBox.get("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		List<Map<String, Object>> courseList = lmsEduResourceService.selectEduResourceList(requestBox);


    	// Adobe Analytics 데이터생성
		requestBox.put("adobeCategory", "EduResource"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);

		
		model.addAttribute("courseList", courseList);
		model.addAttribute("scrData", requestBox);
		model.addAttribute("dataList", LmsCode.getDataList());
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/eduResource/lmsEduResource");
		
		return mav;
	}
	
	/**
	 * LMS 교육자료 비즈니스
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsEduResourceBiz.do")
	public ModelAndView lmsEduResourceBiss(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "EduResourceBiz");  // 메뉴분류
		requestBox.put("menuCategoryNm", "비즈니스");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdEduBizImg);  // 타이틀이미지명
		requestBox.put("coursetype", "D");  // 교육자료 강제 설정 "D"
		requestBox.put("categoryid", LmsCode.categoryIdEduResourceBiz);  // 교육자료 비즈니스
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}


		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
		//	return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		
		
		//개인정보활용동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceBizInfoAgree.do");
			sbParam.append("?categoryid=").append(requestBox.get("categoryid"));
			//String sParam = "redirect:/lms/eduResource/lmsEduResourceBizInfoAgree.do?categoryid="+requestBox.get("categoryid");
			return new ModelAndView(sbParam.toString());
		}

		// 교육자료 상세보기 호출인지 확인한다.
		if( LmsCode.categoryIdEduResourceBiz.equals(requestBox.get("listCategoryCode")) ) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceView.do");
			sbParam.append("?courseid=").append(requestBox.get("courseid"));
			sbParam.append("&menuCategory=").append(requestBox.get("menuCategory"));
			sbParam.append("&categoryid=").append(requestBox.get("listCategoryCode"));
			sbParam.append("&datatype=").append(requestBox.get("datatype"));
			sbParam.append("&sortColumn=").append(requestBox.get("sortColumn"));
			sbParam.append("&searchType=").append(requestBox.get("searchType"));
			sbParam.append("&sTxt=").append(URLEncoder.encode(requestBox.get("searchTxt"), "UTF8"));
			sbParam.append("&page=").append(requestBox.get("page"));
			return new ModelAndView(sbParam.toString());
		}


		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.get("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsEduResourceService.selectEduResourceListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.get("page"));
		pageVO.setRowPerPage(requestBox.get("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		List<Map<String, Object>> courseList = lmsEduResourceService.selectEduResourceList(requestBox);
		

    	// Adobe Analytics 데이터생성
		requestBox.put("adobeCategory", "EduResource"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);

		
		model.addAttribute("courseList", courseList);
		model.addAttribute("scrData", requestBox);
		model.addAttribute("dataList", LmsCode.getDataList());
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/eduResource/lmsEduResource");
		
		return mav;
	}

	/**
	 * LMS 교육자료 뉴트리라이트
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsEduResourceNutrilite.do")
	public ModelAndView lmsEduResourceNutrilite(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "EduResourceNutrilite");  // 메뉴분류
		requestBox.put("menuCategoryNm", "뉴트리라이트");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdNutriliteImg);  // 타이틀이미지명
		requestBox.put("coursetype", "D");  // 교육자료 강제 설정 "D"
		requestBox.put("categoryid", LmsCode.categoryIdEduResourceNutrilite);  // 교육자료 뉴트리라이트
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}


		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
		//	return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
//		if( "N".equals(requestBox.get("MemberYn")) ) {
//			return new ModelAndView("/lms/common/session"); //session, sessionPop
//		}
		
		
		//개인정보활용동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceBizInfoAgree.do");
			sbParam.append("?categoryid=").append(requestBox.get("categoryid"));
			return new ModelAndView(sbParam.toString());
		}

		// 교육자료 상세보기 호출인지 확인한다.
		if( LmsCode.categoryIdEduResourceNutrilite.equals(requestBox.get("listCategoryCode")) ) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceView.do");
			sbParam.append("?courseid=").append(requestBox.get("courseid"));
			sbParam.append("&menuCategory=").append(requestBox.get("menuCategory"));
			sbParam.append("&categoryid=").append(requestBox.get("listCategoryCode"));
			sbParam.append("&datatype=").append(requestBox.get("datatype"));
			sbParam.append("&sortColumn=").append(requestBox.get("sortColumn"));
			sbParam.append("&searchType=").append(requestBox.get("searchType"));
			sbParam.append("&sTxt=").append(URLEncoder.encode(requestBox.get("searchTxt"), "UTF8"));
			sbParam.append("&page=").append(requestBox.get("page"));
			return new ModelAndView(sbParam.toString());
		}

		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.get("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsEduResourceService.selectEduResourceListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.get("page"));
		pageVO.setRowPerPage(requestBox.get("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		List<Map<String, Object>> courseList = lmsEduResourceService.selectEduResourceList(requestBox);
		

    	// Adobe Analytics 데이터생성
		requestBox.put("adobeCategory", "EduResource"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);


		model.addAttribute("courseList", courseList);
		model.addAttribute("scrData", requestBox);
		model.addAttribute("dataList", LmsCode.getDataList());
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/eduResource/lmsEduResource");
		
		return mav;
	}

	/**
	 * LMS 교육자료 아티스트리
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsEduResourceArtistry.do")
	public ModelAndView lmsEduResourceArtistry(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "EduResourceArtistry");  // 메뉴분류
		requestBox.put("menuCategoryNm", "아티스트리");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdArtistryImg);  // 타이틀이미지명
		requestBox.put("coursetype", "D");  // 교육자료 강제 설정 "D"
		requestBox.put("categoryid", LmsCode.categoryIdEduResourceArtistry);  // 교육자료 아티스트리
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}


		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
		//	return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
//		if( "N".equals(requestBox.get("MemberYn")) ) {
//			return new ModelAndView("/lms/common/session"); //session, sessionPop
//		}

		
		//개인정보활용동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceBizInfoAgree.do");
			sbParam.append("?categoryid=").append(requestBox.get("categoryid"));
			return new ModelAndView(sbParam.toString());
		}

		// 교육자료 상세보기 호출인지 확인한다.
		if( LmsCode.categoryIdEduResourceArtistry.equals(requestBox.get("listCategoryCode")) ) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceView.do");
			sbParam.append("?courseid=").append(requestBox.get("courseid"));
			sbParam.append("&menuCategory=").append(requestBox.get("menuCategory"));
			sbParam.append("&categoryid=").append(requestBox.get("listCategoryCode"));
			sbParam.append("&datatype=").append(requestBox.get("datatype"));
			sbParam.append("&sortColumn=").append(requestBox.get("sortColumn"));
			sbParam.append("&searchType=").append(requestBox.get("searchType"));
			sbParam.append("&sTxt=").append(URLEncoder.encode(requestBox.get("searchTxt"), "UTF8"));
			sbParam.append("&page=").append(requestBox.get("page"));
			return new ModelAndView(sbParam.toString());
		}


		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.get("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsEduResourceService.selectEduResourceListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.get("page"));
		pageVO.setRowPerPage(requestBox.get("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		List<Map<String, Object>> courseList = lmsEduResourceService.selectEduResourceList(requestBox);


    	// Adobe Analytics 데이터생성
		requestBox.put("adobeCategory", "EduResource"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);

		
		model.addAttribute("courseList", courseList);
		model.addAttribute("scrData", requestBox);
		model.addAttribute("dataList", LmsCode.getDataList());
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/eduResource/lmsEduResource");
		
		return mav;
	}

	/**
	 * LMS 교육자료 퍼스널케어
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsEduResourcePersonalcare.do")
	public ModelAndView lmsEduResourcePersonalcare(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "EduResourcePersonalcare");  // 메뉴분류
		requestBox.put("menuCategoryNm", "퍼스널케어");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdPersonalcareImg);  // 타이틀이미지명
		requestBox.put("coursetype", "D");  // 교육자료 강제 설정 "D"
		requestBox.put("categoryid", LmsCode.categoryIdEduResourcePersonalcare);  // 교육자료 퍼스널케어
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}


		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
		//	return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
//		if( "N".equals(requestBox.get("MemberYn")) ) {
//			return new ModelAndView("/lms/common/session"); //session, sessionPop
//		}

		
		//개인정보활용동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceBizInfoAgree.do");
			sbParam.append("?categoryid=").append(requestBox.get("categoryid"));
			return new ModelAndView(sbParam.toString());
		}

		// 교육자료 상세보기 호출인지 확인한다.
		if( LmsCode.categoryIdEduResourcePersonalcare.equals(requestBox.get("listCategoryCode")) ) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceView.do");
			sbParam.append("?courseid=").append(requestBox.get("courseid"));
			sbParam.append("&menuCategory=").append(requestBox.get("menuCategory"));
			sbParam.append("&categoryid=").append(requestBox.get("listCategoryCode"));
			sbParam.append("&datatype=").append(requestBox.get("datatype"));
			sbParam.append("&sortColumn=").append(requestBox.get("sortColumn"));
			sbParam.append("&searchType=").append(requestBox.get("searchType"));
			sbParam.append("&sTxt=").append(URLEncoder.encode(requestBox.get("searchTxt"), "UTF8"));
			sbParam.append("&page=").append(requestBox.get("page"));
			return new ModelAndView(sbParam.toString());
		}


		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.get("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsEduResourceService.selectEduResourceListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.get("page"));
		pageVO.setRowPerPage(requestBox.get("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		List<Map<String, Object>> courseList = lmsEduResourceService.selectEduResourceList(requestBox);
		

    	// Adobe Analytics 데이터생성
		requestBox.put("adobeCategory", "EduResource"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);

		
		model.addAttribute("courseList", courseList);
		model.addAttribute("scrData", requestBox);
		model.addAttribute("dataList", LmsCode.getDataList());
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/eduResource/lmsEduResource");
		
		return mav;
	}

	/**
	 * LMS 교육자료 홈리빙
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsEduResourceHomeliving.do")
	public ModelAndView lmsEduResourceHomeliving(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "EduResourceHomeliving");  // 메뉴분류
		requestBox.put("menuCategoryNm", "홈리빙");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdHomelivingImg);  // 타이틀이미지명
		requestBox.put("coursetype", "D");  // 교육자료 강제 설정 "D"
		requestBox.put("categoryid", LmsCode.categoryIdEduResourceHomeliving);  // 교육자료 홈리빙
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}


		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
		//	return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
//		if( "N".equals(requestBox.get("MemberYn")) ) {
//			return new ModelAndView("/lms/common/session"); //session, sessionPop
//		}

		
		//개인정보활용동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceBizInfoAgree.do");
			sbParam.append("?categoryid=").append(requestBox.get("categoryid"));
			return new ModelAndView(sbParam.toString());
		}

		// 교육자료 상세보기 호출인지 확인한다.
		if( LmsCode.categoryIdEduResourceHomeliving.equals(requestBox.get("listCategoryCode")) ) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceView.do");
			sbParam.append("?courseid=").append(requestBox.get("courseid"));
			sbParam.append("&menuCategory=").append(requestBox.get("menuCategory"));
			sbParam.append("&categoryid=").append(requestBox.get("listCategoryCode"));
			sbParam.append("&datatype=").append(requestBox.get("datatype"));
			sbParam.append("&sortColumn=").append(requestBox.get("sortColumn"));
			sbParam.append("&searchType=").append(requestBox.get("searchType"));
			sbParam.append("&sTxt=").append(URLEncoder.encode(requestBox.get("searchTxt"), "UTF8"));
			sbParam.append("&page=").append(requestBox.get("page"));
			return new ModelAndView(sbParam.toString());
		}

		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.get("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsEduResourceService.selectEduResourceListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.get("page"));
		pageVO.setRowPerPage(requestBox.get("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		List<Map<String, Object>> courseList = lmsEduResourceService.selectEduResourceList(requestBox);


    	// Adobe Analytics 데이터생성
		requestBox.put("adobeCategory", "EduResource"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);

		
		model.addAttribute("courseList", courseList);
		model.addAttribute("scrData", requestBox);
		model.addAttribute("dataList", LmsCode.getDataList());
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/eduResource/lmsEduResource");
		
		return mav;
	}

	/**
	 * LMS 교육자료 레시피
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsEduResourceRecipe.do")
	public ModelAndView lmsEduResourceRecipe(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "EduResourceRecipe");  // 메뉴분류
		requestBox.put("menuCategoryNm", "레시피");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdRecipeImg);  // 타이틀이미지명
		requestBox.put("coursetype", "D");  // 교육자료 강제 설정 "D"
		requestBox.put("categoryid", LmsCode.categoryIdEduResourceRecipe);  // 교육자료 레시피
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}


		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
		//	return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
//		if( "N".equals(requestBox.get("MemberYn")) ) {
//			return new ModelAndView("/lms/common/session"); //session, sessionPop
//		}

		
		//개인정보활용동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceBizInfoAgree.do");
			sbParam.append("?categoryid=").append(requestBox.get("categoryid"));
			return new ModelAndView(sbParam.toString());
		}

		// 교육자료 상세보기 호출인지 확인한다.
		if( LmsCode.categoryIdEduResourceRecipe.equals(requestBox.get("listCategoryCode")) ) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceView.do");
			sbParam.append("?courseid=").append(requestBox.get("courseid"));
			sbParam.append("&menuCategory=").append(requestBox.get("menuCategory"));
			sbParam.append("&categoryid=").append(requestBox.get("listCategoryCode"));
			sbParam.append("&datatype=").append(requestBox.get("datatype"));
			sbParam.append("&sortColumn=").append(requestBox.get("sortColumn"));
			sbParam.append("&searchType=").append(requestBox.get("searchType"));
			sbParam.append("&sTxt=").append(URLEncoder.encode(requestBox.get("searchTxt"), "UTF8"));
			sbParam.append("&page=").append(requestBox.get("page"));
			return new ModelAndView(sbParam.toString());
		}

		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.get("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsEduResourceService.selectEduResourceListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.get("page"));
		pageVO.setRowPerPage(requestBox.get("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		List<Map<String, Object>> courseList = lmsEduResourceService.selectEduResourceList(requestBox);


    	// Adobe Analytics 데이터생성
		requestBox.put("adobeCategory", "EduResource"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);
		
				
		model.addAttribute("courseList", courseList);
		model.addAttribute("scrData", requestBox);
		model.addAttribute("dataList", LmsCode.getDataList());
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/eduResource/lmsEduResource");
		
		return mav;
	}

	/**
	 * LMS 교육자료 건강영양
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsEduResourceHealthNutrition.do")
	public ModelAndView lmsEduResourceHealthNutrition(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "EduResourceHealthNutrition");  // 메뉴분류
		requestBox.put("menuCategoryNm", "건강영양");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdHealthNutritionImg);  // 타이틀이미지명
		requestBox.put("coursetype", "D");  // 교육자료 강제 설정 "D"
		requestBox.put("categoryid", LmsCode.categoryIdEduResourceHealthNutrition);  // 교육자료 건강영양
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}


		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
		//	return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
//		if( "N".equals(requestBox.get("MemberYn")) ) {
//			return new ModelAndView("/lms/common/session"); //session, sessionPop
//		}
		
		
		//개인정보활용동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceBizInfoAgree.do");
			sbParam.append("?categoryid=").append(requestBox.get("categoryid"));
			return new ModelAndView(sbParam.toString());
		}

		// 교육자료 상세보기 호출인지 확인한다.
		if( LmsCode.categoryIdEduResourceHealthNutrition.equals(requestBox.get("listCategoryCode")) ) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceView.do");
			sbParam.append("?courseid=").append(requestBox.get("courseid"));
			sbParam.append("&menuCategory=").append(requestBox.get("menuCategory"));
			sbParam.append("&categoryid=").append(requestBox.get("listCategoryCode"));
			sbParam.append("&datatype=").append(requestBox.get("datatype"));
			sbParam.append("&sortColumn=").append(requestBox.get("sortColumn"));
			sbParam.append("&searchType=").append(requestBox.get("searchType"));
			sbParam.append("&sTxt=").append(URLEncoder.encode(requestBox.get("searchTxt"), "UTF8"));
			sbParam.append("&page=").append(requestBox.get("page"));
			return new ModelAndView(sbParam.toString());
		}


		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.get("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsEduResourceService.selectEduResourceListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.get("page"));
		pageVO.setRowPerPage(requestBox.get("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		List<Map<String, Object>> courseList = lmsEduResourceService.selectEduResourceList(requestBox);
		

    	// Adobe Analytics 데이터생성
		requestBox.put("adobeCategory", "EduResource"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);
		
				
		model.addAttribute("courseList", courseList);
		model.addAttribute("scrData", requestBox);
		model.addAttribute("dataList", LmsCode.getDataList());
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/eduResource/lmsEduResource");
		
		return mav;
	}

	/**
	 * LMS 교육자료 음원자료실
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsEduResourceMusic.do")
	public ModelAndView lmsEduResourceMusic(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "EduResourceMusic");  // 메뉴분류
		requestBox.put("menuCategoryNm", "음원자료실");  // 메뉴분류명
		requestBox.put("menuCategoryImg", LmsCode.categoryIdMusicImg);  // 타이틀이미지명
		requestBox.put("coursetype", "D");  // 교육자료 강제 설정 "D"
		requestBox.put("categoryid", LmsCode.categoryIdEduResourceMusic);  // 교육자료 음원자료실
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		
		requestBox.put("datatype", ""); 		// 자료유형: M-동영상, S-오디어, F-문서, L-링크, I-이미지	
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}
		if("".equals(requestBox.get("sortOrder"))) {
			requestBox.put("sortOrder", "DESC");
		}


		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
		//	return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
//		if( "N".equals(requestBox.get("MemberYn")) ) {
//			return new ModelAndView("/lms/common/session"); //session, sessionPop
//		}

		
		//개인정보활용동의 여부 확인.
		int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
		if(agreeCnt < ONE) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceBizInfoAgree.do");
			sbParam.append("?categoryid=").append(requestBox.get("categoryid"));
			return new ModelAndView(sbParam.toString());
		}

		// 교육자료 상세보기 호출인지 확인한다.
		if( LmsCode.categoryIdEduResourceMusic.equals(requestBox.get("listCategoryCode")) ) {
			StringBuffer sbParam = new StringBuffer();
			sbParam.append("redirect:/lms/eduResource/lmsEduResourceView.do");
			sbParam.append("?courseid=").append(requestBox.get("courseid"));
			sbParam.append("&menuCategory=").append(requestBox.get("menuCategory"));
			sbParam.append("&categoryid=").append(requestBox.get("listCategoryCode"));
			sbParam.append("&datatype=").append(requestBox.get("datatype"));
			sbParam.append("&sortColumn=").append(requestBox.get("sortColumn"));
			sbParam.append("&searchType=").append(requestBox.get("searchType"));
			sbParam.append("&sTxt=").append(URLEncoder.encode(requestBox.get("searchTxt"), "UTF8"));
			sbParam.append("&page=").append(requestBox.get("page"));
			return new ModelAndView(sbParam.toString());
		}
		
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.get("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsEduResourceService.selectEduResourceListCount(requestBox));
		requestBox.put("totalPage", pageVO.getTotalPages());
		requestBox.put("firstIndex", "1");
		
		pageVO.setPage(requestBox.get("page"));
		pageVO.setRowPerPage(requestBox.get("rowPerPage"));
		requestBox.putAll(pageVO.toMapData());
		if(pageVO.getTotalCount() == ZERO) {
			requestBox.put("page", "1");
		}
		
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		List<Map<String, Object>> courseList = lmsEduResourceService.selectEduResourceList(requestBox);
		

    	// Adobe Analytics 데이터생성
		requestBox.put("adobeCategory", "EduResource"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", "");  							// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);
		
				
		model.addAttribute("courseList", courseList);
		model.addAttribute("scrData", requestBox);
		model.addAttribute("dataList", LmsCode.getDataList());
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/eduResource/lmsEduResource");
		
		return mav;
	}


	/**
	 * LMS 교육자료 상세보기
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsEduResourceView.do")
	public ModelAndView lmsEduResourceView(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		String sAdobeDetail = "";  // Adobe Analytics 변수
		
		//조회조건, 변수 설정
		requestBox.put("coursetype", "D");  // 교육자료 강제 설정 "D"
		requestBox.put("conditiontype", "2"); //조회구분 1:노출 2:신청
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		if("".equals(requestBox.get("sortColumn"))) {
			requestBox.put("sortColumn", "COURSEID");
		}

		if(!requestBox.get("sTxt").equals("")) {
			requestBox.put("searchTxt", URLDecoder.decode(requestBox.get("sTxt"), "UTF8"));
		}

		if("EduResourceNew".equals(requestBox.get("menuCategory"))) {
			//requestBox.put("sortColumn", "COURSEID");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdNewImg);  // 타이틀이미지명
			requestBox.put("categoryid", "");
		} else if("EduResourceBest".equals(requestBox.get("menuCategory"))) {
			//requestBox.put("sortColumn", "VIEWCOUNT");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdBestImg);  // 타이틀이미지명
			requestBox.put("categoryid", "");
		}
		String sCategoryid = requestBox.get("categoryid");
		
		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
		//	return new ModelAndView("/lms/common/login");
		}

		//세션 체크해서 없으면 특정 페이지로 이동시킴
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//if( "N".equals(requestBox.get("MemberYn")) ) {
		//	return new ModelAndView("/lms/common/session"); //session, sessionPop
		//}
		
		List<Map<String, Object>> listData;
		
		String pRequestflag = "";
		String pOpenflag = "";
		listData = lmsMainService.selectCourseViewAcces(requestBox);
		
		if(!listData.isEmpty() && listData.size() > ZERO) {
			pRequestflag = (String) listData.get(0).get("requestflag").toString();
			pOpenflag = (String) listData.get(0).get("openflag").toString();
		}
		requestBox.put("openFlag", pOpenflag);
		
		List<Map<String, Object>> courseView = new ArrayList<Map<String, Object>>();
		if( "C".equals(pOpenflag) ) {
			//정규과정인데 수강생이 아니면 빈값 보내기
			if( "Y".equals(pRequestflag) ){
				requestBox.put("conditioncheck", "N");
				courseView = lmsEduResourceService.selectEduResourceView(requestBox);
				if(!courseView.isEmpty() && courseView.size() > ZERO) {
					sCategoryid = courseView.get(0).get("categoryid").toString();
					sAdobeDetail = courseView.get(0).get("courseid").toString() + ":" + courseView.get(0).get("coursename").toString();
					
					courseView.get(0).put("coursecontentdetail", LmsUtil.getHtmlStrCnvrBr(courseView.get(0).get("coursecontent").toString()));
					courseView.set(0, courseView.get(0));
				}			
			}
		} else {
			//일반 공개면 이용권한 읽기
			requestBox.put("conditioncheck", "Y");
			courseView = lmsEduResourceService.selectEduResourceView(requestBox);
			if(!courseView.isEmpty() && courseView.size() > ZERO) {
				sCategoryid = courseView.get(0).get("categoryid").toString();
				sAdobeDetail = courseView.get(0).get("courseid").toString() + ":" + courseView.get(0).get("coursename").toString();

				courseView.get(0).put("coursecontentdetail", LmsUtil.getHtmlStrCnvrBr(courseView.get(0).get("coursecontent").toString()));
				courseView.set(0, courseView.get(0));
			}			
		}
		
		// 이전, 다음상세보기 
		requestBox.put("conditiontype", "1"); //조회구분 1:노출 2:신청
		
		List<Map<String, Object>> courseViewPrev = null;
		List<Map<String, Object>> courseViewNext = null;
		
		requestBox.put("sPrevNext", "current");
		List<Map<String, Object>> courseViewCrrent = lmsEduResourceService.selectEduResourceViewPrevNextList(requestBox);
		if( !courseViewCrrent.isEmpty() && courseViewCrrent.size() > ZERO) {
			String rownum = courseViewCrrent.get(0).get("rownum").toString();
			requestBox.put("rownum", rownum);
			
			requestBox.put("sPrevNext", "prev");
			courseViewPrev = lmsEduResourceService.selectEduResourceViewPrevNextList(requestBox);
			
			requestBox.put("sPrevNext", "next");
			courseViewNext = lmsEduResourceService.selectEduResourceViewPrevNextList(requestBox);
		}
		
		// 상세보기 타이틀명 설정
		if( "EduResourceNew".equals(requestBox.get("menuCategory")) ) {
			requestBox.put("menuCategoryNm", "신규");  // 메뉴분류명
			requestBox.put("menuCategoryImg", LmsCode.categoryIdNewImg);  // 타이틀이미지명
		} else if( "EduResourceBest".equals(requestBox.get("menuCategory")) ) { 
	    	requestBox.put("menuCategoryNm", "인기");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdBestImg);  // 타이틀이미지명
		} else if( sCategoryid.equals(LmsCode.categoryIdEduResourceBiz) ) {
			requestBox.put("menuCategory", "EduResourceBiz");  // 메뉴분류
			requestBox.put("menuCategoryNm", "비즈니스");  // 메뉴분류명
			requestBox.put("menuCategoryImg", LmsCode.categoryIdEduBizImg);  // 타이틀이미지명
		} else if( sCategoryid.equals(LmsCode.categoryIdEduResourceNutrilite) ) { 
	    	requestBox.put("menuCategory", "EduResourceNutrilite");
			requestBox.put("menuCategoryNm", "뉴트리라이트");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdNutriliteImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdEduResourceArtistry) ) { 
	    	requestBox.put("menuCategory", "EduResourceArtistry");
			requestBox.put("menuCategoryNm", "아티스트리");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdArtistryImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdEduResourcePersonalcare) ) { 
	    	requestBox.put("menuCategory", "EduResourcePersonalcare");
			requestBox.put("menuCategoryNm", "퍼스널케어");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdPersonalcareImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdEduResourceHomeliving) ) { 
	    	requestBox.put("menuCategory", "EduResourceHomeliving");
			requestBox.put("menuCategoryNm", "홈리빙");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdHomelivingImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdEduResourceRecipe) ) { 
	    	requestBox.put("menuCategory", "EduResourceRecipe");
			requestBox.put("menuCategoryNm", "레시피");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdRecipeImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdEduResourceHealthNutrition) ) { 
	    	requestBox.put("menuCategory", "EduResourceHealthNutrition");
			requestBox.put("menuCategoryNm", "건강영양");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdHealthNutritionImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdEduResourceMusic) ) { 
			requestBox.put("menuCategory", "EduResourceMusic");  
			requestBox.put("menuCategoryNm", "음원자료실"); 
			requestBox.put("menuCategoryImg", LmsCode.categoryIdMusicImg);  // 타이틀이미지명
		} else {
			requestBox.put("menuCategory", "EduResourceNew");  // 메뉴분류
			requestBox.put("menuCategoryNm", "신규");  // 메뉴분류명
			requestBox.put("menuCategoryImg", LmsCode.categoryIdNewImg);  // 타이틀이미지명
		}

		
		// Adobe Analytics 데이터생성
		requestBox.put("adobeCategory", "EduResource"); 		// category
		requestBox.put("adobeSubCategory", requestBox.get("menuCategory"));	// subCategory
		requestBox.put("adobeDetail", sAdobeDetail);  			// detail
		Map<String, Object> analyMap =  lmsUtil.setLmsAdobeAnalytics(request, requestBox, "PC");
		requestBox.put("urlAccess", analyMap.get("urlAccess")); // 접속서버URL 위치 - OPER:운영, DEV:개발
		model.addAttribute("analyticsData", analyMap);
		
		
		model.addAttribute("courseView", courseView);
		model.addAttribute("courseViewPrev", courseViewPrev);
		model.addAttribute("courseViewNext", courseViewNext);
		
		model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/eduResource/lmsEduResourceView");
		
		return mav;
	}

	/**
	 * LMS 음원자료 활용동의 여부 html
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsEduResourceBizInfoAgree.do")
	public ModelAndView lmsEduResourceBizInfoAgree(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox); //하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
			requestBox.put("loginYn", "N");
		} else {
			requestBox.put("loginYn", "Y");
		}
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox); 		//세션 체크해서 없으면 특정 페이지로 이동시킴
		
		//조회조건, 변수 설정
		String sCategoryid = requestBox.get("categoryid");

		// 타이틀명 설정
		if( sCategoryid.equals(LmsCode.categoryIdEduResourceBiz) ) {
			requestBox.put("menuCategory", "EduResourceBiz");  // 메뉴분류
			requestBox.put("menuCategoryNm", "비즈니스");  // 메뉴분류명
			requestBox.put("menuCategoryImg", LmsCode.categoryIdEduBizImg);  // 타이틀이미지명
		} else if( sCategoryid.equals(LmsCode.categoryIdEduResourceNutrilite) ) { 
	    	requestBox.put("menuCategory", "EduResourceNutrilite");
			requestBox.put("menuCategoryNm", "뉴트리라이트");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdNutriliteImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdEduResourceArtistry) ) { 
	    	requestBox.put("menuCategory", "EduResourceArtistry");
			requestBox.put("menuCategoryNm", "아티스트리");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdArtistryImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdEduResourcePersonalcare) ) { 
	    	requestBox.put("menuCategory", "EduResourcePersonalcare");
			requestBox.put("menuCategoryNm", "퍼스널케어");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdPersonalcareImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdEduResourceHomeliving) ) { 
	    	requestBox.put("menuCategory", "EduResourceHomeliving");
			requestBox.put("menuCategoryNm", "홈리빙");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdHomelivingImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdEduResourceRecipe) ) { 
	    	requestBox.put("menuCategory", "EduResourceRecipe");
			requestBox.put("menuCategoryNm", "레시피");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdRecipeImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdEduResourceHealthNutrition) ) { 
	    	requestBox.put("menuCategory", "EduResourceHealthNutrition");
			requestBox.put("menuCategoryNm", "건강영양");
			requestBox.put("menuCategoryImg", LmsCode.categoryIdHealthNutritionImg);  // 타이틀이미지명
	    } else if( sCategoryid.equals(LmsCode.categoryIdEduResourceMusic) ) { 
			requestBox.put("menuCategory", "EduResourceMusic");  
			requestBox.put("menuCategoryNm", "음원자료실"); 
			requestBox.put("menuCategoryImg", LmsCode.categoryIdMusicImg);  // 타이틀이미지명
		} else {
			requestBox.put("menuCategory", "EduResourceNew");  // 메뉴분류
			requestBox.put("menuCategoryNm", "신규");  // 메뉴분류명
			requestBox.put("menuCategoryImg", LmsCode.categoryIdNewImg);  // 타이틀이미지명
		}

		model.addAttribute("scrData", requestBox);

    	model.addAttribute("logMap", loginMap);
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/eduResource/lmsEduResourceBizInfoAgree");
		
		return mav;
	}
	
}
