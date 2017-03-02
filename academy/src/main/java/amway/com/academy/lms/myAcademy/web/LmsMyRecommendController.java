package amway.com.academy.lms.myAcademy.web;

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
import amway.com.academy.lms.myAcademy.service.LmsMyRecommendService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.web.JSONView;


/**
 * @author KR620260
 *		date : 2016.08.16
 * lms 추천콘텐츠 컨트롤러
 */
@Controller
@RequestMapping("/lms/myAcademy")
public class LmsMyRecommendController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsMyRecommendController.class);

	@Autowired
	LmsUtil lmsUtil;

	@Autowired
	LmsCommonController lmsCommonController;

	/*
	 * Service
	 */
	@Autowired
    private LmsMyRecommendService lmsMyRecommendService;
	
	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	@RequestMapping(value = "/lmsMyRecommend.do")
	public ModelAndView lmsMyRecommend(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		requestBox.put("httpDomain", lmsUtil.getDomain(request));

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		String successStr = "SUCCESS";
		if( !successStr.equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}
		
		ModelAndView mav = null;
		
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		lmsUtil.setLmsSessionBoolean(requestBox);
		String yStr = "Y";
		if( !yStr.equals(requestBox.get("MemberYn")) ) {
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		//0. 회원의 핀레벨 또는 보너스 레벨 읽어오기
		String blankStr = "";
		if( !blankStr.equals(requestBox.getString(LmsCode.userSessionPinCode)) ) {
			requestBox.put("targetmasterseq", "PINCODE");
			requestBox.put("targetcodeseq", requestBox.getString(LmsCode.userSessionPinCode));
			
			model.addAttribute("memberGrowthLevel", lmsMyRecommendService.selectLmsTargetCodeName(requestBox) );
		} else {
			requestBox.put("targetmasterseq", "BONUSCODE");
			requestBox.put("targetcodeseq", requestBox.getString(LmsCode.userSessionBonusCode));
			
			model.addAttribute("memberGrowthLevel", lmsMyRecommendService.selectLmsTargetCodeName(requestBox) );
		}

		// 페이징 시작
		String sortCol = "COURSEID";
		String sortOpt = "DESC";
		if(blankStr.equals(requestBox.getString("sortOrderColumn"))) {requestBox.put("sortOrderColumn", sortCol);}
		if(blankStr.equals(requestBox.getString("sortOrderType"))) {requestBox.put("sortOrderType", sortOpt);}
		
		requestBox.put("rowPerPage", 50);
		requestBox.put("pageIndex", 1);
		//페이징 끝
		
		//2. 성장단계 읽기
		requestBox.put("conditiontype", "1"); //1.성장단계
		requestBox.put("categoryflag", "N"); //Y 카테고리만 검색 , N 전체 검색
		List<Map<String, String>> pinList = lmsMyRecommendService.selectLmsRecommendList(requestBox);
		model.addAttribute("pinList", pinList);
		
		//3. 비즈니스성장 읽기
		requestBox.put("conditiontype", "2"); //2.비즈니스성장
		requestBox.put("categoryflag", "N"); //Y 카테고리만 검색 , N 전체 검색
		List<Map<String, String>> businessStatusList = lmsMyRecommendService.selectLmsRecommendList(requestBox);
		model.addAttribute("businessStatusList", businessStatusList);

		//4. 리쿠리팅
		requestBox.put("conditiontype", "3"); //3.리쿠리팅
		requestBox.put("categoryflag", "N"); //Y 카테고리만 검색 , N 전체 검색
		List<Map<String, String>> customerList = lmsMyRecommendService.selectLmsRecommendList(requestBox);
		model.addAttribute("customerList", customerList);

		//5. 구매성향
		requestBox.put("conditiontype", "4"); //4.구매성향
		requestBox.put("categoryflag", "N"); //Y 카테고리만 검색 , N 전체 검색
		List<Map<String, String>> consecutiveList = lmsMyRecommendService.selectLmsRecommendList(requestBox);
		model.addAttribute("consecutiveList", consecutiveList);
		
		model.addAttribute("data", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/myAcademy/lmsMyRecommend");
		
		return mav;
	}
	
	@RequestMapping(value = "/lmsMyRecommendCategoryAjax.do")
	public ModelAndView lmsMyRecommendCategoryAjax(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			rtnMap.put("result", "LOGOUT");
			mav.addObject("data", rtnMap);
			return new ModelAndView("/lms/myAcademy/lmsMyRecommendSubscribe");
		}
		
		//1. 구독 카테고리 읽기
		List<Map<String, String>> categoryList = new ArrayList<Map<String, String>>();
		
		String categorytype = requestBox.getString("categorytype");
		if( "".equals(categorytype) ) {
			String[] cateArr = {"N","N","N","N","N","N"}; 
			String[] cateNameArr = {"비즈니스","뉴트리라이트","아티스트리","퍼스널케어","홈리빙","레시피"};
					
			categoryList = lmsMyRecommendService.selectLmsRecommendCategoryList(requestBox);
			int check0 = 0;
			if( categoryList != null && categoryList.size() > check0 ) {
				for(int i=0; i<categoryList.size(); i++) {
					Map<String,String> tempMap = categoryList.get(i);
					String tempCate = tempMap.get("categoryid");
					
					if( tempCate.equals( LmsCode.categoryIdOnlineBiz ) || tempCate.equals( LmsCode.categoryIdOnlineBizSolution ) || tempCate.equals( LmsCode.categoryIdEduResourceBiz ) ) {
						//비즈니스
						cateArr[0] = "Y";
					} else if( tempCate.equals( LmsCode.categoryIdOnlineNutrilite ) || tempCate.equals( LmsCode.categoryIdEduResourceNutrilite ) ) {
						//뉴트리라이트
						cateArr[1] = "Y";
					} else if( tempCate.equals( LmsCode.categoryIdOnlineArtistry ) || tempCate.equals( LmsCode.categoryIdEduResourceArtistry ) ) {
						//아티스트리
						cateArr[2] = "Y";
					} else if( tempCate.equals( LmsCode.categoryIdOnlinePersonalcare ) || tempCate.equals( LmsCode.categoryIdEduResourcePersonalcare ) ) {
						//퍼스널케어
						cateArr[3] = "Y";
					} else if( tempCate.equals( LmsCode.categoryIdOnlineHomeliving ) || tempCate.equals( LmsCode.categoryIdEduResourceHomeliving ) ) {
						//홈리빙
						cateArr[4] = "Y";
					} else if( tempCate.equals( LmsCode.categoryIdOnlineRecipe ) || tempCate.equals( LmsCode.categoryIdEduResourceRecipe ) ) {
						//레시피
						cateArr[5] = "Y";
					}
				}
				
				//카테고리 설정
				boolean cateCheck = true;
				categoryList = new ArrayList<Map<String, String>>();
				for( int i=0; i<cateArr.length; i++ ) {
					if( cateArr[i].equals("Y") ) {
						Map<String,String> tempMap = new HashMap<String,String>();
						tempMap.put("categorytype", (i+1)+"");
						tempMap.put("categoryname", cateNameArr[i]);
						
						categoryList.add(tempMap);
						
						if( cateCheck ) {
							//카테고리 선택 없으면 맨 처음것 선택함
							categorytype = (i+1)+"";
							cateCheck = false;
						}
					}
				}
			}
		}
		mav.addObject("categoryList", categoryList);
	
		//2. 카테고리에 해당하는 추천 콘텐츠 읽기
		String blankStr = "";
		if( !blankStr.equals(categorytype) ) {
			
			// 페이징 시작
			String sortCol = "COURSEID";
			String sortOpt = "DESC";
			if(blankStr.equals(requestBox.getString("sortOrderColumn"))) {requestBox.put("sortOrderColumn", sortCol);}
			if(blankStr.equals(requestBox.getString("sortOrderType"))) {requestBox.put("sortOrderType", sortOpt);}
			
			requestBox.put("rowPerPage", 50);
			requestBox.put("pageIndex", 1);
			//페이징 끝
			
			requestBox.put("conditiontype", ""); //전체 조건
			requestBox.put("categoryflag", "Y"); //Y 카테고리만 검색 , N 전체 검색
			
			String categorytypes = "";
			
			if( categorytype.equals("1") ) {categorytypes = LmsCode.categoryIdOnlineBiz + "," + LmsCode.categoryIdOnlineBizSolution + "," + LmsCode.categoryIdEduResourceBiz;}
			else if( categorytype.equals("2") ) {categorytypes = LmsCode.categoryIdOnlineNutrilite + "," + LmsCode.categoryIdEduResourceNutrilite;}
			else if( categorytype.equals("3") ) {categorytypes = LmsCode.categoryIdOnlineArtistry + "," + LmsCode.categoryIdEduResourceArtistry;}
			else if( categorytype.equals("4") ) {categorytypes = LmsCode.categoryIdOnlinePersonalcare + "," + LmsCode.categoryIdEduResourcePersonalcare;}
			else if( categorytype.equals("5") ) {categorytypes = LmsCode.categoryIdOnlineHomeliving + "," + LmsCode.categoryIdEduResourceHomeliving;}
			else if( categorytype.equals("6") ) {categorytypes = LmsCode.categoryIdOnlineRecipe + "," + LmsCode.categoryIdEduResourceRecipe;}
			
			String[] categoryids = categorytypes.split("[,]");
			requestBox.put("categoryids", categoryids);
			
			List<Map<String, String>> categoryDataList = lmsMyRecommendService.selectLmsRecommendList(requestBox);
			mav.addObject("categoryDataList", categoryDataList);
		}
		
		rtnMap.put("categorytype", categorytype);
		rtnMap.put("result", "SUCCESS");

		mav.addObject("data", rtnMap);
		
		mav.setViewName("/lms/myAcademy/lmsMyRecommendSubscribe");
		return mav;
	}
	
	@RequestMapping(value = "/lmsMyRecommendCategorySaveAjax.do")
	public ModelAndView lmsMyRecommendCategorySaveAjax(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			rtnMap.put("result", "LOGOUT");
			
			mav.setView(new JSONView());
			mav.addObject("JSON_OBJECT",  rtnMap);
			return mav;
		}

		// 구독 카테고리 등록
		String blankStr = "";
		if( !blankStr.equals(requestBox.getString("categorytypes")) ) {
			//선택한 카테고리의 값을 실제 카테고리 코드값으로 변환하여 저장할 것
			String str1 = "1";
			String str2 = "2";
			String str3 = "3";
			String str4 = "4";
			String str5 = "5";
			String str6 = "6";
			String[] categorytypes = requestBox.getString("categorytypes").split("[,]");
			String categoryids = "";
			for( int i=0; i<categorytypes.length; i++) {
				if( str1.equals(categorytypes[i]) ) {
					StringBuffer categoryidsBuffer = new StringBuffer(categoryids);
					categoryidsBuffer.append(LmsCode.categoryIdOnlineBiz + "," + LmsCode.categoryIdOnlineBizSolution + "," + LmsCode.categoryIdEduResourceBiz + ",");
					categoryids = categoryidsBuffer.toString();
					//categoryids += LmsCode.categoryIdOnlineBiz + "," + LmsCode.categoryIdOnlineBizSolution + "," + LmsCode.categoryIdEduResourceBiz + ",";
				}
				if( str2.equals(categorytypes[i]) ) {
					StringBuffer categoryidsBuffer = new StringBuffer(categoryids);
					categoryidsBuffer.append(LmsCode.categoryIdOnlineNutrilite + "," + LmsCode.categoryIdEduResourceNutrilite + ",");
					categoryids = categoryidsBuffer.toString();
					//categoryids += LmsCode.categoryIdOnlineNutrilite + "," + LmsCode.categoryIdEduResourceNutrilite + ",";
				}
				if( str3.equals(categorytypes[i]) ) {
					StringBuffer categoryidsBuffer = new StringBuffer(categoryids);
					categoryidsBuffer.append(LmsCode.categoryIdOnlineArtistry + "," + LmsCode.categoryIdEduResourceArtistry + ",");
					categoryids = categoryidsBuffer.toString();
					//categoryids += LmsCode.categoryIdOnlineArtistry + "," + LmsCode.categoryIdEduResourceArtistry + ",";
				}
				if( str4.equals(categorytypes[i]) ) {
					StringBuffer categoryidsBuffer = new StringBuffer(categoryids);
					categoryidsBuffer.append(LmsCode.categoryIdOnlinePersonalcare + "," + LmsCode.categoryIdEduResourcePersonalcare + ",");
					categoryids = categoryidsBuffer.toString();
					//categoryids += LmsCode.categoryIdOnlinePersonalcare + "," + LmsCode.categoryIdEduResourcePersonalcare + ",";
				}
				if( str5.equals(categorytypes[i]) ) {
					StringBuffer categoryidsBuffer = new StringBuffer(categoryids);
					categoryidsBuffer.append(LmsCode.categoryIdOnlineHomeliving + "," + LmsCode.categoryIdEduResourceHomeliving + ",");
					categoryids = categoryidsBuffer.toString();
					//categoryids += LmsCode.categoryIdOnlineHomeliving + "," + LmsCode.categoryIdEduResourceHomeliving + ",";
				}
				if( str6.equals(categorytypes[i]) ) {
					StringBuffer categoryidsBuffer = new StringBuffer(categoryids);
					categoryidsBuffer.append(LmsCode.categoryIdOnlineRecipe + "," + LmsCode.categoryIdEduResourceRecipe + ",");
					categoryids = categoryidsBuffer.toString();
					//categoryids += LmsCode.categoryIdOnlineRecipe + "," + LmsCode.categoryIdEduResourceRecipe + ",";
				}
			}
			if( !blankStr.equals(categoryids) ) {
				categoryids = categoryids.substring(0, categoryids.length()-1);
			}
			
			requestBox.put("categoryids", categoryids);
			int insertCount = lmsMyRecommendService.insertLmsSubscribe(requestBox);
			if( insertCount < 0 ) {
				rtnMap.put("result", "FAIL");
			} else {
				rtnMap.put("result", "SUCCESS");
			}
		} else {
			//전체 구독 카테고리 삭제하기
			lmsMyRecommendService.deleteLmsSubscribe(requestBox);
			rtnMap.put("result", "SUCCESS");
		}
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	@RequestMapping(value = "/lmsMyRecommendCategoryReadAjax.do")
	public ModelAndView lmsMyRecommendCategoryReadAjax(ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		if( "N".equals(requestBox.getString("MemberYn")) ) {
			rtnMap.put("result", "LOGOUT");
			
			mav.setView(new JSONView());
			mav.addObject("JSON_OBJECT",  rtnMap);
			return mav;
		}

		String[] cateArr = {"N","N","N","N","N","N"}; 
					
		List<Map<String, String>> categoryList = lmsMyRecommendService.selectLmsRecommendCategoryList(requestBox);
		int check0 = 0;
		if( categoryList != null && categoryList.size() > check0 ) {
			for(int i=0; i<categoryList.size(); i++) {
				Map<String,String> tempMap = categoryList.get(i);
				String tempCate = tempMap.get("categoryid");
				
				if( tempCate.equals( LmsCode.categoryIdOnlineBiz ) || tempCate.equals( LmsCode.categoryIdOnlineBizSolution ) || tempCate.equals( LmsCode.categoryIdEduResourceBiz ) ) {
					//비즈니스
					cateArr[0] = "Y";
				} else if( tempCate.equals( LmsCode.categoryIdOnlineNutrilite ) || tempCate.equals( LmsCode.categoryIdEduResourceNutrilite ) ) {
					//뉴트리라이트
					cateArr[1] = "Y";
				} else if( tempCate.equals( LmsCode.categoryIdOnlineArtistry ) || tempCate.equals( LmsCode.categoryIdEduResourceArtistry ) ) {
					//아티스트리
					cateArr[2] = "Y";
				} else if( tempCate.equals( LmsCode.categoryIdOnlinePersonalcare ) || tempCate.equals( LmsCode.categoryIdEduResourcePersonalcare ) ) {
					//퍼스널케어
					cateArr[3] = "Y";
				} else if( tempCate.equals( LmsCode.categoryIdOnlineHomeliving ) || tempCate.equals( LmsCode.categoryIdEduResourceHomeliving ) ) {
					//홈리빙
					cateArr[4] = "Y";
				} else if( tempCate.equals( LmsCode.categoryIdOnlineRecipe ) || tempCate.equals( LmsCode.categoryIdEduResourceRecipe ) ) {
					//레시피
					cateArr[5] = "Y";
				}
			}
		}
		rtnMap.put("result", "SUCCESS");
		rtnMap.put("categoryArr", cateArr);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
}
