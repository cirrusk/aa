package amway.com.academy.trainingFee.trainingFeeMain.web;

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

import amway.com.academy.common.commoncode.service.CommonCodeService;
import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.trainingFee.common.service.TrainingFeeCommonService;
import amway.com.academy.trainingFee.trainingFeeMain.service.TrainingFeeMainService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.StringUtil;
import framework.com.cmm.web.JSONView;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :TrainingFeeMainController.java
 * @DESC :교육비 모바일 index Controller
 *        - 교육비 메뉴 클릭시 호출 하여 페이지 네이게이션 역할을 함
 * @Author:홍석조
 * @VER : 1.0 ------------------------------------------------------------------------------ 변 경 사 항
 *      ------------------------------------------------------------------------------ DATE AUTHOR
 *      DESCRIPTION ------------- ------ --------------------------------------------------- 
 *      2016.08. 18. 최초작성
 *      -----------------------------------------------------------------------------
 */
@Controller
@RequestMapping("/mobile/trainingFee")
public class TrainingFeeMainMobileController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeeMainController.class);

	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
		
	/*
	 * Service
	 */
	@Autowired
    private TrainingFeeMainService trainingFeeMainService;
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@Autowired
	private TrainingFeeCommonService trainingFeeCommonService;
	
	/**
	 * 교육비 초기 화면 네비게이션
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeIndex.do")
	public ModelAndView trainingFeeIndex(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = null;
		
		requestBox.put("depaboNo", requestBox.getSession("abono") );
		
		/** 회계연도 및 기준 연도/월을 구한다. */
		Map<String, Object> scheduleMap = trainingFeeMainService.selectSchedule(requestBox);
		
		requestBox.putAll(scheduleMap);
		
		/**
		 * 교육비 지급 대상자 인지 체크
		 */
		Map<String, Object> aboInfoMap = trainingFeeMainService.selectTargetInformation(requestBox);
		int sizeNum = 0;
		
		if( aboInfoMap == null ) {
			// 대상자는 아니지만 다이아 위임자 이면 위임 동의서를 받아야 한다.
			List<Map<String, Object>> agreeTargetMap = trainingFeeMainService.selectTrfeeAgreeDeleg(requestBox);
			
			if(agreeTargetMap.size()==sizeNum) {
				requestBox.put("targetType", "NOT");
				mav = new ModelAndView("/mobile/trainingFee/trainingFeeIndex");	
			} else {
				requestBox.put("targetType"   , "type3");
				requestBox.put("agreetypecode", "200"  );
				requestBox.put("delegtypecode", "2"  );
				model.addAttribute("agreeTarget", agreeTargetMap);
				mav = new ModelAndView("/mobile/trainingFee/trainingFeeAgree");
			}
		} else if( aboInfoMap.get("diadelegaboNo").equals("N") ) {
			/** 
			 * 다이아 위임자 위임동의 체크
			 * */			
			requestBox.put("targetType", "DIA");
			mav = new ModelAndView("/mobile/trainingFee/trainingFeeIndex");
		} else {
			requestBox.putAll(aboInfoMap);
			
			/**
			 * 교육비 대상자 이면 서약서 및 동의서를 받았는지 확인 한다.
			 */
			String delegtypecode = aboInfoMap.get("delegtypecode").toString();
			String delegflag = aboInfoMap.get("delegflag").toString();
			String delegcnt = aboInfoMap.get("delegcnt").toString();
					
			if(delegtypecode.equals("1") && delegflag.equals("O") && delegcnt.equals("Y") ){
				/** 
				 * 위임 서약서를 받는다.(Emeald 위임) 	에메랄드 위임: 교육비 권한 수령 받는 에메랄드 용 (피위임자용)
				 * */
				List<Map<String, Object>> agreeTargetMap = trainingFeeMainService.selectTrfeeAgreeDelegEm(requestBox);
				requestBox.put("targetType"   , "type3");
				requestBox.put("agreetypecode", "200"  );
				requestBox.put("delegtypecode", "1"  );
				model.addAttribute("agreeTarget", agreeTargetMap);
				mav = new ModelAndView("/mobile/trainingFee/trainingFeeAgree");
			} else if("N".equals(aboInfoMap.get("agreeflag"))) {
				// 서약서를 받는다.
				requestBox.put("targetType"   , "type1");
				requestBox.put("agreetypecode", "100"  );
				requestBox.put("delegtypecode", "0"  );
				mav = new ModelAndView("/mobile/trainingFee/trainingFeeAgree");
			} else {
				/**
				 * 제3자 동의서를 받고 메인 화면으로 이동 한다.
				 * 1. 제3자 동의서를 받아야 하는 사람이 존재 하는지 체크 한다.
				 */
				List<Map<String, Object>> agreeTargetMap = trainingFeeMainService.selectTrfeeAgreeThirdperson(requestBox);
				
				if(agreeTargetMap.size()==sizeNum) {
					/** 등록가능기간 */
					model.addAttribute("pfList", trainingFeeMainService.selectPF(requestBox));
					
					if("".equals(requestBox.get("pfyear"))) {
						requestBox.put("pfyear","0");
					}
					
					if("".equals(requestBox.get("procType"))) {
						requestBox.put("procType","group");
					}

					/** 기본 UI 표기(기본 셋팅 값) - 모든 동의서 및 정상이면 통과 */
					if( requestBox.get("typecnt").equals("1") ) {
						requestBox.put("procType", "person");
						List<Map<String, Object>> personList = trainingFeeMainService.selectMainList(requestBox);
						model.addAttribute("personList", personList);
						mav = new ModelAndView("/mobile/trainingFee/trainingFeeMainPerson");
					} else {
						if( requestBox.get("procType").equals("person") ) {
							List<Map<String, Object>> personList = trainingFeeMainService.selectMainList(requestBox);
							model.addAttribute("personList", personList);
						} else {
							requestBox.put("procType", "group");
							List<Map<String, Object>> groupList = trainingFeeMainService.selectMainList(requestBox);
							List<Map<String, Object>> groupTargetList = trainingFeeMainService.selectGroupTargetList(requestBox);
							
							model.addAttribute("groupList", groupList);
							model.addAttribute("groupTargetList", groupTargetList);
						}
						
						mav = new ModelAndView("/mobile/trainingFee/trainingFeeMain");	
					}
					
				} else {
					/** 제3자 동의서를 받아야 한다. */
					requestBox.put("targetType"   , "type4");
					requestBox.put("agreetypecode", "300"  );
					requestBox.put("delegtypecode", "0"  );
					model.addAttribute("agreeTarget", agreeTargetMap);
					mav = new ModelAndView("/mobile/trainingFee/trainingFeeAgree");
				}
				
			}
			
		}
		
		requestBox.put("trfeeUrl", mav.getViewName());
		//adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "mobile");
		model.addAttribute("analBox", analBox);
		model.addAttribute("scrData", requestBox);
		
		return mav;
	}
	
	/**
	 * 약관 서약서
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeAgreeText.do")
	public ModelAndView trainingFeeAgreeText(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		Map<String, String> dataList = trainingFeeMainService.selectTrFeeAgreeText(requestBox);
		String agreetext = dataList.get("agreetext");
		
		dataList.put("agreetext", StringUtil.replaceTag(agreetext));
		
		mav.addObject("dataList", dataList);
		
		return mav;
	}
	
	/**
	 * 약관 동의 저장
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveAgreeText.do")
	public ModelAndView saveTrainingFeePlan(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int result = 0;
		String sMsgText = "";
		
		requestBox.put("eventid", "I");
		requestBox.put("systemtype", "2");
		
		if( "100".equals(requestBox.get("agreetypecode")) ) {
			requestBox.put("systemtext", "[교육비동의관리] 교육비 서약서 동의");
			result = trainingFeeMainService.inserTrfeeAgreePledge(requestBox);
		} else if( "200".equals(requestBox.get("agreetypecode")) ) {
			requestBox.put("systemtext", "[교육비동의관리] 교육비 위임동의");
			result = trainingFeeMainService.inserTrfeeAgreeDeleg(requestBox);
		}  else if( "300".equals(requestBox.get("agreetypecode")) ) {
			requestBox.put("systemtext", "[교육비동의관리] 교육비 제3자동의");
			result = trainingFeeMainService.inserTrfeeThirdperson(requestBox);
		}
		
		trainingFeeCommonService.inserTrfeeSystemProcessLog(requestBox);
		
		resultMap.put("errCode", result);
		resultMap.put("errMsg" , sMsgText);
		
		rtnMap.put("result", resultMap);
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
		
	}
	
	/**
	 * 교육비 그룹 리스트 상세
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectGroupTargetList.do")
	public ModelAndView selectGroupTargetList(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, Object>> groupList = trainingFeeMainService.selectGroupTargetList(requestBox);
		
		mav.addObject("dataList", groupList);
		return mav;
	}
	
	/**
	 * pt 그룹 상세 레이어 팝업
	 * @param mav
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeMainLayerPop.do")
	public ModelAndView trainingFeeMainLayerPop(ModelAndView mav, ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		model.addAttribute("ptlist", trainingFeeMainService.selectPtList(requestBox));
		return mav;
	}
	
	/**
	 * 교육비 관련 도움말
	 * @param mav
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeMainInfoLayerPop.do")
	public ModelAndView trainingFeeMainInfoLayerPop(ModelAndView mav, ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		return mav;
	}
	
	/**
	 * 약관동의관리 전체
	 * @param mav
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeAgreeFull.do")
	public ModelAndView trainingFeeAgreeFull(ModelAndView mav, ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		String agreetext = "";
		
		/** 교육비 서약서 */
		Map<String, String> dataList = trainingFeeMainService.selectTrFeeAgreePledge(requestBox);
		agreetext = dataList.get("agreetext");
		
		dataList.put("agreetext", StringUtil.replaceTag(agreetext));
				
		model.addAttribute("agreePledge", dataList);
		
		/** 교육비 동의서 */
		agreetext = "";
		Map<String, String> agreeDeleg = trainingFeeMainService.selectTrFeeAgreeDelegFull(requestBox);
		
		if(agreeDeleg!=null){
			agreetext = agreeDeleg.get("agreetext");
			
			agreeDeleg.put("agreetext", StringUtil.replaceTag(agreetext));
			
			model.addAttribute("agreeDeleg", agreeDeleg);
			model.addAttribute("agreeDelegList", trainingFeeMainService.selectTrFeeAgreeDelegFullList(requestBox));
		}
		
		/** 교육비 제3자 동의서 */
		agreetext = "";
		Map<String, Object> thirdPerson = trainingFeeMainService.selectTrFeeThirdPerson(requestBox);
		
		if(thirdPerson!=null){
			agreetext = (String) thirdPerson.get("agreetext");
			
			thirdPerson.put("agreetext", StringUtil.replaceTag(agreetext));
			
			model.addAttribute("thirdPerson", thirdPerson);
			model.addAttribute("thirdPersonList", trainingFeeMainService.selectTrFeeThirdPersonList(requestBox));
		}
		
		model.addAttribute("scrData", requestBox);
		//adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "mobile");
				
		return mav;
	}
	
	/**
	 * 제3자 동의 변경
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateThirdpersonAgree.do")
	public ModelAndView updateThirdpersonAgree(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int result = 0;
		String sMsgText = "";
		
		requestBox.put("eventid", "U");
		requestBox.put("systemtype", "2");
		requestBox.put("systemtext", "[교육비동의관리] 교육비 제3자 동의 변경 저장");
		
		result = trainingFeeMainService.updateThirdpersonAgree(requestBox);
		trainingFeeCommonService.inserTrfeeSystemProcessLog(requestBox);
		
		resultMap.put("errCode", result);
		resultMap.put("errMsg" , sMsgText);
		
		rtnMap.put("result", resultMap);
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
		
	}
	
	/**
	 * 약관전체보기 POP
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeAgreePop.do")
	public ModelAndView trainingFeeAgreePop(ModelAndView mav, ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		String agreetext = "";
		
		/** 교육비 서약서 */
		Map<String, String> dataList = trainingFeeMainService.selectTrFeeAgreePledge(requestBox);
		agreetext = dataList.get("agreetext");
		
		dataList.put("agreetext", StringUtil.replaceTag(agreetext));
				
		model.addAttribute("agreePledge", dataList);
		
		/** 교육비 동의서 */
		Map<String, String> agreeDeleg = trainingFeeMainService.selectTrFeeAgreeDelegFull(requestBox);
		
		if(agreeDeleg!=null){
			agreetext = agreeDeleg.get("agreetext");
			
			agreeDeleg.put("agreetext", StringUtil.replaceTag(agreetext));
			
			model.addAttribute("agreeDeleg", agreeDeleg);
			model.addAttribute("agreeDelegList", trainingFeeMainService.selectTrFeeAgreeDelegFullList(requestBox));
		}
		
		/** 교육비 제3자 동의서 */
		agreetext = "";
		Map<String, Object> thirdPerson = trainingFeeMainService.selectTrFeeThirdPerson(requestBox);
		
		if(thirdPerson!=null){
			agreetext = (String) thirdPerson.get("agreetext");
			
			thirdPerson.put("agreetext", StringUtil.replaceTag(agreetext));
			
			model.addAttribute("thirdPerson", thirdPerson);
			model.addAttribute("thirdPersonList", trainingFeeMainService.selectTrFeeThirdPersonList(requestBox));
		} 
		
		model.addAttribute("scrData", requestBox);
		
		return mav;
	}

}