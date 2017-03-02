package amway.com.academy.lms.main.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.lms.common.LmsCode;
import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.common.service.impl.LmsCommonMapper;
import amway.com.academy.lms.common.web.LmsCommonMobileController;
import amway.com.academy.lms.main.service.LmsMainService;
import amway.com.academy.lms.myAcademy.service.impl.LmsMySurveyMapper;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.DateUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.util.StringUtil;


/**
 * @author KR620260
 *		date : 2016.08.01
 * lms Main 컨트롤러(모바일)
 */
@Controller
@RequestMapping("/mobile/lms")
public class LmsMainMobileController {
	
	@Autowired
	LmsUtil lmsUtil;

	@Autowired
	LmsCommonMobileController lmsCommonController;

	@Autowired
	private LmsMySurveyMapper lmsMySurveyMapper;

	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	/*
	 * Service
	 */
	@Autowired
    private LmsMainService lmsMainService;

	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	private String sRowPerPage = "20"; // 페이지에 넣을 row수
	private static final int ZERO = 0;
	private static final int ONE = 1;
	
	/**
	 * LMS메인 화면
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main.do")
	public ModelAndView lmsMain(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = null;
		
		requestBox.put("typecode", "C"); //조회구분 1:노출(A) 2:신청(B) 3:추천(C)	
		requestBox.put("httpDomain", lmsUtil.getDomain(request));
		requestBox.put("httpRootDomain", LmsCode.getHybrisHttpDomain());

		
		// 접속서버에 대한 Link 로그인 페이지
		String sLoginUrl = lmsUtil.getUrlFullLink("/account/signup-guide", "?access=link", "mobile", "https", request); // 접속서버에 대한 Link를 반환 한다.
		requestBox.put("loginUrl", sLoginUrl);  // 로그인 페이지
		
		
		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
		//	return new ModelAndView("/mobile/lms/common/login");
		}

		// LMS세션값을 설정하고 존재여부를 리턴한다.
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) { 
			requestBox.put("typecode", "C");
		}

		// 알림 조회
		if(!requestBox.get(LmsCode.userSessionUid).equals("")) {
			List<Map<String, Object>> notesendList = lmsMainService.selectMemberMessageList(requestBox);
			if(!notesendList.isEmpty() && notesendList.size() > ZERO) {
				requestBox.put("notecontent", (String) notesendList.get(0).get("notecontent").toString() );
				requestBox.put("notesendseq", (String) notesendList.get(0).get("notesendseq").toString() );
			}
		}
		
		
		// 계정에 따른 설정.
		String sortCol = "COURSEID";
		String sortOpt = "DESC";
		if("".equals(requestBox.getString("sortColumn"))) {
			requestBox.put("sortColumn", sortCol);
		}
		if("".equals(requestBox.getString("sortOrder"))) {
			requestBox.put("sortOrder", sortOpt);
		}
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsMainService.selectCourseListCount(requestBox));
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
		List<Map<String, Object>> courseList = lmsMainService.selectCourseList(requestBox);
		
		model.addAttribute("courseList", courseList);
		model.addAttribute("scrData", requestBox);
		
		//메인베너
		requestBox.put("position","M");
		requestBox.put("bannerDate",DateUtil.getDateType("yyMMdd"));
		model.addAttribute("bannerList", lmsMainService.selectLmsBannerList(requestBox));
		model.addAttribute("bannerDate", DateUtil.getDateType("yyMMdd"));
		String appYn = "N";
		String userAgent = (String) request.getHeader("User-Agent");
		if(userAgent.contains("AMWAY")){
			appYn = "Y";
		}
		model.addAttribute("appyn", appYn);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "MOBILE");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/mobile/lms/main");
		
		return mav;
	}

	/**
	 * LMS메인 화면 - 더보기 클릭시 내용부분을 채워준다 
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mainMoreAjax.do")
	public ModelAndView lmsMainMoreAjax(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = null;
		
		requestBox.put("typecode", "C"); //조회구분 1:노출(A) 2:신청(B) 3:추천(C)	
		requestBox.put("httpDomain", lmsUtil.getDomain(request));


		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			loginMap = null;
		//	return new ModelAndView("/mobile/lms/common/login");
		}

		// LMS세션값을 설정하고 존재여부를 리턴한다.
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) { 
			requestBox.put("typecode", "C");
		}
		
		// 계정에 따른 설정.
		String sortCol = "COURSEID";
		String sortOpt = "DESC";
		if("".equals(requestBox.getString("sortColumn"))) {
			requestBox.put("sortColumn", sortCol);
		}
		if("".equals(requestBox.getString("sortOrder"))) {
			requestBox.put("sortOrder", sortOpt);
		}
		
		// 페이징 시작.
		PageVO pageVO = new PageVO(requestBox);		
		if(requestBox.getString("page").equals("") || requestBox.getString("page").equals("0")) {
			requestBox.put("page", "1");
		}
		if("".equals(requestBox.getString("rowPerPage"))) {
			requestBox.put("rowPerPage", sRowPerPage);
		}
		pageVO.setTotalCount(lmsMainService.selectCourseListCount(requestBox));
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
		List<Map<String, Object>> courseList = lmsMainService.selectCourseList(requestBox);
		
		model.addAttribute("courseList", courseList);
		model.addAttribute("scrData", requestBox);
		
		// 메인 화면 호출
		mav = new ModelAndView("/mobile/lms/mainMore");
		
		return mav;
	}

	
	/**
	 * 상세보기전 접속 권한 체크.
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/authViewDataEvent.do")
	public ModelAndView lmsAuthViewDataEvent(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{

		ModelAndView mav = new ModelAndView("jsonView");
		
		// LMS세션값을 설정하고 존재여부를 리턴한다.
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		
		// 변수 셋팅
		String sCode = "1";
		String sMsg = "";
		String sLink = "";
		String sLink2 = "";
		//String sParam = "";
		StringBuffer sbParam = new StringBuffer();
		
		List<Map<String, Object>> listData;
		
		String pCourseId = "";
		String pCourseType = "";
		String pCategoryId = "";
		String pRequestflag = "";
		String pFinishflag = "";
		String pOpenflag = "";
		
		
		// 1. 과정 기본정보 조회 //listData = lmsMainService.selectCourseDetail(requestBox);
		requestBox.put("courseid", StringUtil.toInt(requestBox.get("courseid")));
		listData = lmsMainService.selectCourseViewAcces(requestBox);
		if(!listData.isEmpty() && listData.size() > ZERO) {
			pCourseId = (String) listData.get(0).get("courseid").toString();
			pCourseType = (String) listData.get(0).get("coursetype").toString();
			pCategoryId = (String) listData.get(0).get("categoryid").toString();
			pRequestflag = (String) listData.get(0).get("requestflag").toString();
			pOpenflag = (String) listData.get(0).get("openflag").toString();
			pFinishflag = (String) listData.get(0).get("finishflag").toString();
		} else {
			sCode = "21";
			sMsg = "이용 권한이 없습니다.";
		}
		
		//openFlag = 'C' 이고 requestFlag ='Y'가 아니면 Fail
		String strC = "C";
		String strY = "Y";
		if( strC.equals(pOpenflag) && !strY.equals(pRequestflag) ) {
			sCode = "21";
			sMsg = "이용 권한이 없습니다.";
		}
			
		if(!requestBox.get(LmsCode.userSessionUid).equals("")) {
			// 2. 저작권동의
			if(sCode.equals("1") && (pCourseType.equals("O") || pCourseType.equals("D")) ) {
			    //저작권동의 여부 확인.
				requestBox.put("categoryid",  pCategoryId);
				int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
				if(agreeCnt < ONE) {
					sCode = "12";
					sMsg = "저작권동의 여부 확인.";
					//sParam = "?categoryid=" + pCategoryId;
					if("O".equals(pCourseType)) {
						sLink = "/mobile/lms/online/lmsOnlineBizInfoAgree.do";
						
						//List - 메뉴 설정
						sbParam = new StringBuffer();
						sbParam.append("?courseid=").append(pCourseId);
						sbParam.append("&listCategoryCode=").append(pCategoryId);
							//sParam = "?courseid=" + pCourseId + "&listCategoryCode=" + pCategoryId;
						if( pCategoryId.equals(LmsCode.categoryIdOnlineBiz) ) {
							sLink2 = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineBiz", sbParam.toString(), "mobile", "", request);
						} else if( pCategoryId.equals(LmsCode.categoryIdOnlineBizSolution) ) {
							sLink2 = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineBizSolution", sbParam.toString(), "mobile", "", request);
						} else if( pCategoryId.equals(LmsCode.categoryIdOnlineNutrilite) ) 	{
							sLink2 = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineNutrilite", sbParam.toString(), "mobile", "", request);
						} else if( pCategoryId.equals(LmsCode.categoryIdOnlineArtistry) ) {
							sLink2 = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineArtistry", sbParam.toString(), "mobile", "", request);
						} else if( pCategoryId.equals(LmsCode.categoryIdOnlineHomeliving) ) {
							sLink2 = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineHomeliving", sbParam.toString(), "mobile", "", request);
						} else if( pCategoryId.equals(LmsCode.categoryIdOnlinePersonalcare) ) {
							sLink2 = lmsUtil.getUrlFullLink("/lms/online/lmsOnlinePersonalcare", sbParam.toString(), "mobile", "", request);
						} else if( pCategoryId.equals(LmsCode.categoryIdOnlineRecipe) ) {
							sLink2 = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineRecipe", sbParam.toString(), "mobile", "", request);
						} else if( pCategoryId.equals(LmsCode.categoryIdOnlineHealthNutrition) ) {
							sLink2 = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineHealthNutrition", sbParam.toString(), "mobile", "", request);
						} else {
							sbParam.append("&listName=New");
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineNew", sbParam.toString(), "mobile", "", request);
						}
					} else if("D".equals(pCourseType)) {
						sLink = "/mobile/lms/eduResource/lmsEduResourceBizInfoAgree.do";
						
						//List - 메뉴 설정
						sbParam = new StringBuffer();
						sbParam.append("?courseid=").append(pCourseId);
						sbParam.append("&listCategoryCode=").append(pCategoryId);
							//sParam = "?categoryid=" + pCategoryId + "&listCategoryCode=" + pCategoryId + "&datatype=" + requestBox.get("datatype");
						if( pCategoryId.equals(LmsCode.categoryIdEduResourceBiz) ) {
							sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceBiz", sbParam.toString(), "mobile", "", request);
						} else if( pCategoryId.equals(LmsCode.categoryIdEduResourceNutrilite) ) {
							sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceNutrilite", sbParam.toString(), "mobile", "", request);
						} else if( pCategoryId.equals(LmsCode.categoryIdEduResourceArtistry) ) {
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceArtistry", sbParam.toString(), "mobile", "", request);
					    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourcePersonalcare) ) {
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourcePersonalcare", sbParam.toString(), "mobile", "", request);
					    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceHomeliving) ) {
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceHomeliving", sbParam.toString(), "mobile", "", request);
					    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceRecipe) ) {
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceRecipe", sbParam.toString(), "mobile", "", request);
					    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceHealthNutrition) )	{
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceHealthNutrition", sbParam.toString(), "mobile", "", request);
					    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceMusic) ) {
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceMusic", sbParam.toString(), "mobile", "", request);
					    } else {
					    	sbParam.append("&listName=New");
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceNew", sbParam.toString(), "mobile", "", request);
					    }
					}
				}
			}
			
			// 3. 저장작업 - 카운트 증가, 수강신청, 수료처리, ...
			if("1".equals(sCode)) {
				requestBox.put("courseid",  pCourseId);
				
				//교육과정 카운트 증가
				lmsMainService.updateLmsCourseViewCnt(requestBox);  	//교육과정 조회수 1증가

				//조회로그 카운트 증가
				requestBox.put("viewtype", "3");  // 조회구분 1 SNS공유, 2좋아요, 3조회
				lmsMainService.mergeViewLogCount(requestBox); 		//조회로그 조회수 1증가
				
				// 최근본콘텐츠 추가
				requestBox.put("savetype", "1");  // 저장구분 1:최근본콘텐츠, 2:보관함, 3:GLMS동의
				lmsMainService.mergeSaveLog(requestBox); 	//저장로그 등록,수정
						
				// 수강신청이 미신청 상태일때.. (온라인, 교육자료)
				if( ("O".equals(pCourseType) || "D".equals(pCourseType)) && !"Y".equals(pRequestflag) ) {
					// 수강신청을 자동으로 등록한다. -  온라인, 교육자료만 해당.
					lmsMainService.mergeLmsCourseStudentRequest(requestBox);
				} 
				
				// 교육자료일때 수료처리, 
				if( "D".equals(pCourseType) ) {
					if( !"Y".equals(pFinishflag) && !"C".equals(pOpenflag) ) {
						requestBox.put("stampid", LmsCode.stampIdData);  		//교육자료 스탬프
						lmsMainService.updateLmsStudentFinish(requestBox);  	// 수료여부 Y, 수료일시
					}
					// 정규과정중인 항목
					if(pOpenflag.equals("C") && !requestBox.get(LmsCode.userSessionUid).equals("")) {
						requestBox.put("stepcourseid", requestBox.get("courseid")); 
						lmsMainService.updateFinishProcess2(requestBox); 						//정규 강좌의 경우 단계 완료 처리할 것
						requestBox.put("courseid", requestBox.getObject( "stepcourseid")); // 사용전 원상태로 복원
					}
				}
			}
		} else if(sCode.equals("1")) {
			// 계정이 없다.
			if(pCourseType.equals("D")) {
				if( requestBox.get(LmsCode.userSessionUid).equals("") ) {
					
					//비회원의 경우 저작권동의 여부 확인.
					requestBox.put("categoryid",  pCategoryId);
					int agreeCnt = lmsMainService.selectCategoryAgree(requestBox);
					if(agreeCnt < ONE) {
						sCode = "12";
						sMsg = "저작권동의 여부 확인.";
						
						//비회원이 자료 볼때 자작권동의 체크하기
						sLink = "/mobile/lms/eduResource/lmsEduResourceBizInfoAgree.do";
						
						//List - 메뉴 설정
						sbParam = new StringBuffer();
						sbParam.append("?courseid=").append(pCourseId);
						sbParam.append("&listCategoryCode=").append(pCategoryId);
							//sParam = "?categoryid=" + pCategoryId + "&listCategoryCode=" + pCategoryId + "&datatype=" + requestBox.get("datatype");
						if( pCategoryId.equals(LmsCode.categoryIdEduResourceBiz) ) {
							sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceBiz", sbParam.toString(), "mobile", "", request);
						} else if( pCategoryId.equals(LmsCode.categoryIdEduResourceNutrilite) ) {
							sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceNutrilite", sbParam.toString(), "mobile", "", request);
						} else if( pCategoryId.equals(LmsCode.categoryIdEduResourceArtistry) ) {
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceArtistry", sbParam.toString(), "mobile", "", request);
					    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourcePersonalcare) ) {
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourcePersonalcare", sbParam.toString(), "mobile", "", request);
					    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceHomeliving) ) {
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceHomeliving", sbParam.toString(), "mobile", "", request);
					    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceRecipe) ) {
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceRecipe", sbParam.toString(), "mobile", "", request);
					    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceHealthNutrition) )	{
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceHealthNutrition", sbParam.toString(), "mobile", "", request);
					    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceMusic) ) {
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceMusic", sbParam.toString(), "mobile", "", request);
					    } else {
					    	sbParam.append("&listName=New");
					    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceNew", sbParam.toString(), "mobile", "", request);
					    }
					}
				}
				if( "1".equals(sCode) ) {
					lmsMainService.updateLmsCourseViewCnt(requestBox);  	//교육과정 조회수 1증가
				}
			} else {
				sCode = "0";
				sMsg = "로그인후 이용 할 수 있습니다.";	
			}
		}
		
		// 4. 과정코드별로 상세보기 분기 처리 -  COURSETYPE 과정구분코드 (O온라인과정, F오프라인과정, D교육자료, L라이브과정, R정규과정, V설문, T시험)
		if("1".equals(sCode)) {
			
			sbParam = new StringBuffer();
			sbParam.append("?courseid=").append(pCourseId);
				//sParam = "?courseid=" + pCourseId;
			if("O".equals(pCourseType)) {
				sCode = "1";
				sMsg = "온라인과정 상세";
				sLink = "/mobile/lms/online/lmsOnlineView.do";
				sLink2 = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineView", sbParam.toString(), "mobile", "", request); // 접속서버에 대한 Link를 반환 한다.
			} else if("F".equals(pCourseType)) {
				sCode = "2";
				sMsg = "오프라인과정 상세";
				sLink = "/mobile/lms/request/lmsOfflineView.do";
				sLink2 = lmsUtil.getUrlFullLink("/lms/request/lmsOfflineView", sbParam.toString(), "mobile", "", request); // 접속서버에 대한 Link를 반환 한다.
			} else if("D".equals(pCourseType)) {
				sCode = "3";
				sMsg = "교육자료 상세";
				sLink = "/mobile/lms/eduResource/lmsEduResourceView.do";

				//List - 메뉴 설정
				sbParam.append("&listCategoryCode=").append(pCategoryId);
				sbParam.append("&datatype=").append(requestBox.get("datatype"));
				sbParam.append("&sortColumn=").append(requestBox.get("sortColumn"));
				sbParam.append("&searchType=M");
				sbParam.append("&searchTxt=").append(requestBox.get("searchTxt"));
					//sParam = sParam + "&listCategoryCode=" + pCategoryId + "&datatype=" + requestBox.get("datatype");
				if( pCategoryId.equals(LmsCode.categoryIdEduResourceBiz) ) {
					sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceBiz", sbParam.toString(), "mobile", "", request);
				} else if( pCategoryId.equals(LmsCode.categoryIdEduResourceNutrilite) ) {
					sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceNutrilite", sbParam.toString(), "mobile", "", request);
				} else if( pCategoryId.equals(LmsCode.categoryIdEduResourceArtistry) ) {
			    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceArtistry", sbParam.toString(), "mobile", "", request);
			    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourcePersonalcare) ) {
			    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourcePersonalcare", sbParam.toString(), "mobile", "", request);
			    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceHomeliving) ) {
			    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceHomeliving", sbParam.toString(), "mobile", "", request);
			    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceRecipe) ) {
			    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceRecipe", sbParam.toString(), "mobile", "", request);
			    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceHealthNutrition) )	{
			    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceHealthNutrition", sbParam.toString(), "mobile", "", request);
			    }  else if( pCategoryId.equals(LmsCode.categoryIdEduResourceMusic) ) {
			    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceMusic", sbParam.toString(), "mobile", "", request);
			    } else {
			    	sbParam.append("&listName=New");
			    	sLink2 = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceNew", sbParam.toString(), "mobile", "", request);
			    }
			} else if("L".equals(pCourseType)) {
				sCode = "4";
				sMsg = "라이브과정 상세";
				sLink = "/mobile/lms/request/lmsLiveView.do";
				sLink2 = lmsUtil.getUrlFullLink("/lms/request/lmsLiveView", sbParam.toString(), "mobile", "", request); // 접속서버에 대한 Link를 반환 한다.
			} else if("R".equals(pCourseType)) {
				sCode = "5";
				sMsg = "정규과정 상세";
				sLink = "/mobile/lms/request/lmsCourseView.do";
				sLink2 = lmsUtil.getUrlFullLink("/lms/request/lmsCourseView", sbParam.toString(), "mobile", "", request); // 접속서버에 대한 Link를 반환 한다.
			}
		}
		
		mav.addObject("sCode", sCode);
		mav.addObject("sMsg", sMsg);	
		mav.addObject("sCourseid", requestBox.get("courseid"));
		mav.addObject("sLink", sLink);		
		mav.addObject("sLink2", sLink2);		
		
		// 사용변수 초기화
		requestBox.put("categoryid",  "");
		requestBox.put("courseid", "");
		requestBox.put("coursetype", "");
		requestBox.put("viewtype", "");
		requestBox.put("viewmonth", "");
		requestBox.put("savetype", "");
		
		return mav;		
	}


	/**
	 * 조회수 카운트.
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/viewcountEvent.do")
	public ModelAndView lmsViewcountEvent(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{

		// LMS세션값을 설정하고 존재여부를 리턴한다.
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//if( "N".equals(requestBox.getString("MemberYn")) ) { LOGGER.debug("\n---------------------------------------------------------------\n================    로그인이 아님 (Session Null)...  ================\n---------------------------------------------------------------");}
				
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		// 변수 셋팅
		String sCode = "";
		String sMsg = "";
		String cntMsg = "";
		String cntFullMsg = "";
		
		List<Map<String, Object>> listCount;
		
		requestBox.put("viewtype", "3");  // 조회구분 1 SNS공유, 2좋아요, 3조회
		requestBox.put("viewmonth", "2016");
		
		if(!requestBox.get(LmsCode.userSessionUid).equals("")) {
			int viewCnt = lmsMainService.selectViewLogCount(requestBox);
			
			if(viewCnt < ONE) {
				lmsMainService.updateLmsCourseViewCnt(requestBox); //교육과정
				lmsMainService.insertLmsViewLogCnt(requestBox);  		//조회로그
				
				listCount = lmsMainService.selectCourseViewCount(requestBox);
				
				sCode = "1";
				sMsg = "해당 자료를 조회하였습니다.";
				cntMsg = listCount.get(1).get("viewcnt").toString();
				cntFullMsg = listCount.get(1).get("viewcount").toString();
				
			} else {
				// count되어있음.
				lmsMainService.updateLmsCourseViewCnt(requestBox); //교육과정
				lmsMainService.updateLmsViewLogCnt(requestBox);  		//조회로그
				
				listCount = lmsMainService.selectCourseViewCount(requestBox);
				
				sCode = "2";
				sMsg = "해당 자료를 조회하였습니다.(중복조회)";
				cntMsg = listCount.get(1).get("viewcnt").toString();
				cntFullMsg = listCount.get(1).get("viewcount").toString();
			}
			
		} else {
			// 계정이 없다.
			lmsMainService.updateLmsCourseViewCnt(requestBox); //교육과정
			
			listCount = lmsMainService.selectCourseViewCount(requestBox);
			
			sCode = "0";
			sMsg = "해당 자료를 조회하였습니다.(미로그인조회)";
			cntMsg = listCount.get(1).get("viewcnt").toString();
			cntFullMsg = listCount.get(1).get("viewcount").toString();
		}
		
		mav.addObject("sCode", sCode);
		mav.addObject("sMsg", sMsg);		
		mav.addObject("cntMsg", cntMsg);		
		mav.addObject("cntFullMsg", cntFullMsg);	
		
		// 사용변수 초기화
		requestBox.put("courseid", "");
		requestBox.put("viewtype", "");
		requestBox.put("viewmonth", "");
		
		return mav;		
	}

	/**
	 * 좋아요 클릭시 이벤트.
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/likecountEvent.do")
	public ModelAndView lmsLikecountEvent(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{

		// LMS세션값을 설정하고 존재여부를 리턴한다.
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//if( "N".equals(requestBox.getString("MemberYn")) ) { LOGGER.debug("\n---------------------------------------------------------------\n================    로그인이 아님 (Session Null)...  ================\n---------------------------------------------------------------");}

		
		ModelAndView mav = new ModelAndView("jsonView");
		
		// 변수 셋팅
		String sCode = "";
		String sMsg = "";
		String cntMsg = "";
		String cntFullMsg = "";
		
		if(!requestBox.get(LmsCode.userSessionUid).equals("")) {
			
			//좋아요는 compliance 회피할 것 2017.11.09
			//COMPLIANCEFLAG 조회 count 
			//int viewCnt = lmsMainService.selectComplianceCount(requestBox);
			//if(viewCnt < ONE) {
				//viewCnt = 0;
				requestBox.put("viewtype", "2");  // 조회구분 1 SNS공유, 2좋아요, 3조회
				requestBox.put("viewmonth", "");
				int viewCnt = lmsMainService.selectViewLogCount(requestBox);
				
				if(viewCnt < ONE) {
					// 좋아요 count
					lmsMainService.updateLmsCourseLikeCnt(requestBox); //교육과정
					lmsMainService.insertLmsViewLogCnt(requestBox);  		//조회로그
					
					List<Map<String, Object>> listCount = lmsMainService.selectCourseLikeCount(requestBox);
					
					sCode = "1";
					sMsg = "해당 콘텐츠가 추천되었습니다.";
					cntMsg = listCount.get(0).get("likecnt").toString();
					cntFullMsg = listCount.get(0).get("likecount").toString();
				} else {
					// count되어있음.
					sCode = "2";
					sMsg = "이미 추천된 콘텐츠입니다.";
				}
			//} else {
			//	sCode = "3";
			//	sMsg = "Compliance 설정되어 추천 하실 수 없습니다.";	
			//}
		} else {
			// 계정이 없다.
			sCode = "0";
			sMsg = "로그인후 이용 할 수 있습니다.";
		}
		
		mav.addObject("sCode", sCode);
		mav.addObject("sMsg", sMsg);		
		mav.addObject("cntMsg", cntMsg);		
		mav.addObject("cntFullMsg", cntFullMsg);		
		
		// 사용변수 초기화
		requestBox.put("courseid", "");
		requestBox.put("viewtype", "");
		requestBox.put("viewmonth", "");
		
		return mav;		
	}

	/**
	 * 보관함 선택시 이벤트.
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/depositEvent.do")
	public ModelAndView lmsDepositEvent(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{

		// LMS세션값을 설정하고 존재여부를 리턴한다.
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//if( "N".equals(requestBox.getString("MemberYn")) ) { LOGGER.debug("\n---------------------------------------------------------------\n================    로그인이 아님 (Session Null)...  ================\n---------------------------------------------------------------");}

		
		ModelAndView mav = new ModelAndView("jsonView");
		
		// 변수 셋팅
		String sCode = "";
		String sMsg = "";
		
		if(!requestBox.get(LmsCode.userSessionUid).equals("")) {
			
			//COMPLIANCEFLAG 조회 count 
			int viewCnt = lmsMainService.selectComplianceCount(requestBox);
			if(viewCnt < ONE) {
				viewCnt = 0;
				requestBox.put("savetype", "2");  // 저장구분 1:최근본콘텐츠, 2:보관함, 3:GLMS동의
				viewCnt = lmsMainService.selectSaveLogCount(requestBox); 	//저장로그 count
			
				if(viewCnt < ONE) {
					// 보관함 count
					lmsMainService.insertLmsSaveLog(requestBox);  		//저장로그
					sCode = "1";
					sMsg = "해당 자료가 보관함에 추가되었습니다.";
				} else {
					// count되어있음.
					lmsMainService.deleteLmsSaveLog(requestBox);  		//저장로그
					sCode = "2";
					sMsg = "해당 자료가 보관함에서 삭제되었습니다.";
				}
			} else {
				sCode = "3";
				sMsg = "Compliance 설정되어 보관함에 추가 하실 수 없습니다.";	
			}
		} else {
			// 계정이 없다.
			sCode = "0";
			sMsg = "로그인후 이용 할 수 있습니다.";
		}
		
		mav.addObject("sCode", sCode);
		mav.addObject("sMsg", sMsg);		
		
		// 사용변수 초기화
		requestBox.put("categoryid",  "");
		requestBox.put("savetype", "");
		
		return mav;		
	}
	

	/**
	 * 저작권동의 등록 이벤트.
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/categoryAgreeEvent.do")
	public ModelAndView lmsCategoryAgreeEvent(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{

		// LMS세션값을 설정하고 존재여부를 리턴한다.
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//if( "N".equals(requestBox.getString("MemberYn")) ) { LOGGER.debug("\n---------------------------------------------------------------\n================    로그인이 아님 (Session Null)...  ================\n---------------------------------------------------------------");}

		ModelAndView mav = new ModelAndView("jsonView");
		
		// 변수 셋팅
		String sCode = "";
		String sMsg = "";
		
		if(!requestBox.get(LmsCode.userSessionUid).equals("")) {
			// 저작권동의 등록
			lmsMainService.insertLmsCategoryAgree(requestBox);  		//저장로그
			sCode = "1";
			sMsg = "저작권동의 되었습니다.";
		} else {
			// 계정이 없다.
			sCode = "0";
			sMsg = "로그인후 이용 할 수 있습니다.";
		}
		
		mav.addObject("sCode", sCode);
		mav.addObject("sMsg", sMsg);		
		
		// 사용변수 초기화
		requestBox.put("categoryid",  "");
		
		return mav;		
	}

	/**
	 * 개인정보활용동의 등록.
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/PersonalInfoAgree.do")
	public ModelAndView lmsPersonalInfoAgreeEvent(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{

		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "New");  // 메뉴분류
		requestBox.put("menuCategoryNm", "신규");  // 메뉴분류명
		requestBox.put("agreeCourseid", "1");  // '1'으로 설정. 온라인강의에 해당하는 과정모두를 포함하기 위함.

		// 접속서버에 대한 Link
		String sParam = "";
		//String sLinkMain = lmsUtil.getUrlFullLink("/lms/main", sParam, "mobile", "", request); // 접속서버에 대한 Link를 반환 한다.
		String sLinkMain = lmsUtil.getUrlFullLink("/academy", sParam, "mobile", "", request); // 접속서버에 대한 Link를 반환 한다.
		String sLinkResource = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineNew", sParam, "mobile", "", request); // 접속서버에 대한 Link를 반환 한다.
		
		// LMS세션값을 설정하고 존재여부를 리턴한다.
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) { 	
			requestBox.put("directLink", sLinkMain);
			model.addAttribute("scrData", requestBox);
			mav = new ModelAndView("/mobile/lms/lmsDirectLink");
		}
		
		// 변수 셋팅
		String sPersonalAgree = requestBox.get("agreeYn");
		
		if(!requestBox.get(LmsCode.userSessionUid).equals("")) {
			requestBox.put("courseid", "1");  // '1'으로 설정. 온라인강의에 해당하는 과정모두를 포함하기 위함.
			requestBox.put("savetype", "3");  // 저장구분 1:최근본콘텐츠, 2:보관함, 3:GLMS동의
			
			if("Y".equals(sPersonalAgree)) {
				// 개인정보활용동의 등록
				lmsMainService.insertLmsSaveLog(requestBox); 
				requestBox.put("directLink", sLinkResource);
				model.addAttribute("scrData", requestBox);
				mav = new ModelAndView("/mobile/lms/lmsDirectLink");
			} else {
				requestBox.put("directLink", sLinkMain);
				model.addAttribute("scrData", requestBox);
				mav = new ModelAndView("/mobile/lms/lmsDirectLink");
			}
			
		}
		
		// 사용변수 초기화
		requestBox.put("categoryid",  "");
		requestBox.put("savetype", "");
		
		return mav;		
	}

	/**
	 * 온라인강의 비즈니스 활용 약관동의 등록.
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/BizInfoAgreeOnline.do")
	public ModelAndView lmsBizInfoAgreeOnlineEvent(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{

		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("menuCategory", "New");  // 메뉴분류
		requestBox.put("menuCategoryNm", "신규");  // 메뉴분류명
		String pCategoryId = requestBox.get("categoryid");
		
		// 접속서버에 대한 Link
		String sParam = "";
		//String sLinkMain = lmsUtil.getUrlFullLink("/lms/main", sParam, "mobile", "", request); // 접속서버에 대한 Link를 반환 한다.
		String sLinkMain = lmsUtil.getUrlFullLink("/academy", sParam, "mobile", "", request); // 접속서버에 대한 Link를 반환 한다.
		String sLinkResource = "";
		
		//List - 메뉴 설정
		if( pCategoryId.equals(LmsCode.categoryIdOnlineBiz) ) {
			sLinkResource = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineBiz", sParam, "mobile", "", request); 
		} else if( pCategoryId.equals(LmsCode.categoryIdOnlineBizSolution) ) {
			sLinkResource = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineBizSolution", sParam, "mobile", "", request); 
		} else if( pCategoryId.equals(LmsCode.categoryIdOnlineNutrilite) ) 	{
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineNutrilite", sParam, "mobile", "", request); 
	    } else if( pCategoryId.equals(LmsCode.categoryIdOnlineArtistry) ) {
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineArtistry", sParam, "mobile", "", request); 
	    } else if( pCategoryId.equals(LmsCode.categoryIdOnlineHomeliving) ) {
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineHomeliving", sParam, "mobile", "", request);  
	    } else if( pCategoryId.equals(LmsCode.categoryIdOnlinePersonalcare) ) {
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/online/lmsOnlinePersonalcare", sParam, "mobile", "", request); 
	    } else if( pCategoryId.equals(LmsCode.categoryIdOnlineRecipe) ) {
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineRecipe", sParam, "mobile", "", request); 
	    } else if( pCategoryId.equals(LmsCode.categoryIdOnlineHealthNutrition) ) {
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineHealthNutrition", sParam, "mobile", "", request); 
	    } else {
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/online/lmsOnlineNew", sParam, "mobile", "", request); 
	    }
		
		
		// LMS세션값을 설정하고 존재여부를 리턴한다.
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) { 	
			requestBox.put("directLink", sLinkMain);
			model.addAttribute("scrData", requestBox);
			mav = new ModelAndView("/mobile/lms/lmsDirectLink");
		}
		
		// 변수 셋팅
		String sAgree = requestBox.get("agreeYn");
		
		if(!requestBox.get(LmsCode.userSessionUid).equals("")) {
			if("Y".equals(sAgree)) {
				// 온라인강의 비즈니스 활용 약관동의 등록
				lmsMainService.insertLmsCategoryAgree(requestBox);  		//저장로그
				requestBox.put("directLink", sLinkResource);
				model.addAttribute("scrData", requestBox);
				mav = new ModelAndView("/mobile/lms/lmsDirectLink");
			} else {
				requestBox.put("directLink", sLinkMain);
				model.addAttribute("scrData", requestBox);
				mav = new ModelAndView("/mobile/lms/lmsDirectLink");
			}
			
		}
		
		// 사용변수 초기화
		requestBox.put("categoryid",  "");
		
		return mav;		
	}
	
	/**
	 * 저작권동의 등록. 2016.09.23 교육자료 모든 카테고리 별로 저작권 동의 확인으로 변경
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/BizInfoAgreeEduResource.do")
	public ModelAndView lmsBizInfoAgreeEvent(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{

		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		String pCategoryId = requestBox.get("agreeCategoryid");
		
		// 접속서버에 대한 Link
		String sParam = "";
		//String sLinkMain = lmsUtil.getUrlFullLink("/lms/main", sParam, "mobile", "", request); // 접속서버에 대한 Link를 반환 한다.
		String sLinkMain = lmsUtil.getUrlFullLink("/academy", sParam, "mobile", "", request); // 접속서버에 대한 Link를 반환 한다.
		String sLinkResource = "";
		
		//List - 메뉴 설정
		if( pCategoryId.equals(LmsCode.categoryIdEduResourceBiz) ) {
			sLinkResource = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceBiz", sParam, "mobile", "", request); 
		} else if( pCategoryId.equals(LmsCode.categoryIdEduResourceNutrilite) ) {
			sLinkResource = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceNutrilite", sParam, "mobile", "", request); 
		} else if( pCategoryId.equals(LmsCode.categoryIdEduResourceArtistry) ) {
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceArtistry", sParam, "mobile", "", request); 
	    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourcePersonalcare) ) {
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourcePersonalcare", sParam, "mobile", "", request);  
	    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceHomeliving) ) {
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceHomeliving", sParam, "mobile", "", request); 
	    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceRecipe) ) {
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceRecipe", sParam, "mobile", "", request); 
	    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceHealthNutrition) )	{
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceHealthNutrition", sParam, "mobile", "", request); 
	    } else if( pCategoryId.equals(LmsCode.categoryIdEduResourceMusic) ) {
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceMusic", sParam, "mobile", "", request);
	    } else {
	    	sLinkResource = lmsUtil.getUrlFullLink("/lms/eduResource/lmsEduResourceNew", sParam, "mobile", "", request); 
	    }
	    
		// LMS세션값을 설정하고 존재여부를 리턴한다.
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( "N".equals(requestBox.getString("MemberYn")) ) { 	
			requestBox.put("directLink", sLinkMain);
			model.addAttribute("scrData", requestBox);
			mav = new ModelAndView("/mobile/lms/lmsDirectLink");
		}
		
		// 변수 셋팅
		String sAgree = requestBox.get("agreeYn");
		
		if(!requestBox.get(LmsCode.userSessionUid).equals("")) {
			requestBox.put("categoryid", pCategoryId); //
			
			if("Y".equals(sAgree)) {
				// 교육자료 음원자료실 약관동의 등록
				lmsMainService.insertLmsCategoryAgree(requestBox);  		//저장로그
				requestBox.put("directLink", sLinkResource);
				model.addAttribute("scrData", requestBox);
				mav = new ModelAndView("/mobile/lms/lmsDirectLink");
			} else {
				requestBox.put("directLink", sLinkMain);
				model.addAttribute("scrData", requestBox);
				mav = new ModelAndView("/mobile/lms/lmsDirectLink");
			}
			
		}
		
		// 사용변수 초기화
		requestBox.put("categoryid",  "");
		
		return mav;		
	}

	/**
	 * 다이렉트 이동시 사용한다
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsDirectLink.do")
	public ModelAndView lmsDirectLink(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception {

		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		if("".equals(requestBox.getString("directLink"))) {
			requestBox.put("directLink", (String) request.getParameter("directLink"));
		}
		
		model.addAttribute("scrData", requestBox);
		
		// 메인 화면 호출
		mav = new ModelAndView("/mobile/lms/lmsDirectLink");
		
		return mav;
	}

	/**
	 * 회원등급 조회.
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getItemMemberGrade.do")
	public ModelAndView lmsGetItemMemberGrade(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{

		// LMS세션값을 설정하고 존재여부를 리턴한다.
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//if( "N".equals(requestBox.getString("MemberYn")) ) { LOGGER.debug("\n---------------------------------------------------------------\n================    로그인이 아님 (Session Null)...  ================\n---------------------------------------------------------------");}
		

		ModelAndView mav = new ModelAndView("jsonView");
		
		// 변수 셋팅
		String sCode = "";
		String sMsg = "";
		
		String sAboTypeCode = requestBox.get(LmsCode.userSessionAboTypeCode);
		String sPinCode = requestBox.get(LmsCode.userSessionPinCode);
		
		if(!requestBox.get(LmsCode.userSessionUid).equals("")) {
			if( "".equals(sPinCode) ) {
				if("M".equals(sAboTypeCode) ) {
					sMsg = "pinLevelLgMember"; //member
				} else if("I".equals(sAboTypeCode) ) {
					sMsg = "pinLevelLgAbo"; //abo회원
				}
			} else if("V".equals(sPinCode) ) {
				sMsg = "pinLevelLgMember"; //멤버
			} else if("0".equals(sPinCode) ) {
				sMsg = "pinLevelLgAbo"; //ABO회원
			} else if("D".equals(sPinCode) ) {
				sMsg = "pinLevelLgSps"; //실버 스폰서
			} else if("C".equals(sPinCode) ) {
				sMsg = "pinLevelLgSp"; //실버 프로튜서
			} else if("A".equals(sPinCode) ) {
				sMsg = "pinLevelLgGp"; //골드 프로튜서
			} else if("9".equals(sPinCode) ) {
				sMsg = "pinLevelLgPt"; //플래티늄
			} else if("B".equals(sPinCode) ) {
				sMsg = "pinLevelLgRuby"; //루비
			} else if("I".equals(sPinCode) ) {
				sMsg = "pinLevelLgFpt"; //파운더스플래티늄
			} else if("J".equals(sPinCode) ) {
				sMsg = "pinLevelLgFruby"; //파운더스루비
			} else if("1".equals(sPinCode) ) {
				sMsg = "pinLevelLgPearl"; //펄
			} else if("E".equals(sPinCode) ) {
				sMsg = "pinLevelLgSap"; //사파이어
			} else if("G".equals(sPinCode) ) {
				sMsg = "pinLevelLgFsap"; //파운더스사파이어
			} else if("2".equals(sPinCode) ) {
				sMsg = "pinLevelLgEme"; //에메랄드
			} else if("H".equals(sPinCode) ) {
				sMsg = "pinLevelLgFeme"; //파운더스에메랄드
			} else if("3".equals(sPinCode) ) {
				sMsg = "pinLevelLgDia"; //다이아몬드
			} else if("Z".equals(sPinCode) ) {
				sMsg = "pinLevelLgFdia"; //파운더스다이아몬드
			} else if("4".equals(sPinCode) ) {
				sMsg = "pinLevelLgExedia"; //수석다이아몬드
			} else if("K".equals(sPinCode) ) {
				sMsg = "pinLevelLgFexedia"; //파운더스수석다이아몬드
			} else if("5".equals(sPinCode) ) {
				sMsg = "pinLevelLgDdia"; //더블다이아몬드
			} else if("L".equals(sPinCode) ) {
				sMsg = "pinLevelLgFddia"; //파운더스더블다이아몬드
			} else if("6".equals(sPinCode) ) {
				sMsg = "pinLevelLgTdia"; //트리플다이아몬드
			} else if("M".equals(sPinCode) ) {
				sMsg = "pinLevelLgFtdia"; //파운더스트리플다이아몬드
			} else if("7".equals(sPinCode) ) {
				sMsg = "pinLevelLgCrown"; //크라운
			} else if("N".equals(sPinCode) ) {
				sMsg = "pinLevelLgFcrown"; //파운더스크라운
			} else if("8".equals(sPinCode) ) {
				sMsg = "pinLevelLgCrownamb"; //크라운앰배서더
			} else if("O".equals(sPinCode) ) {
				sMsg = "pinLevelLgFcrownamb"; //파운더스크라운앰배서더
			} else if("P".equals(sPinCode) ) {
				sMsg = "pinLevelLgFca40"; //FCA 40
			} else if("Q".equals(sPinCode) ) {
				sMsg = "pinLevelLgFca50"; //FCA 50
			} else if("R".equals(sPinCode) ) {
				sMsg = "pinLevelLgFca60"; //FCA 60
			}
			
			if("".equals(sMsg)) {
				sCode = "2";
			} else {
				sCode = "1";
			}
		
		} else {
			// 계정이 없다.
			sCode = "0";
			sMsg = "로그인후 이용 할 수 있습니다.";
		}
		
		mav.addObject("sCode", sCode);
		mav.addObject("sMsg", sMsg);		
		
		return mav;		
	}

}
