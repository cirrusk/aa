package amway.com.academy.lms.myAcademy.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.lms.common.LmsCode;
import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.myAcademy.service.LmsMySurveyService;
import framework.com.cmm.lib.RequestBox;

/**
 * @author kr620237
 * 2016.08.11
 * 사용자 설문
 */
@Controller
@RequestMapping("/lms/myAcademy")
public class LmsMySurveyController {

	@Autowired
	LmsUtil lmsUtil;

	@Autowired
    private LmsMySurveyService lmsMySurveyService;
	
	@RequestMapping(value = "/lmsMySurvey.do")
	public ModelAndView lmsMySurvey(ModelMap model, RequestBox requestBox) throws Exception{
		
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		lmsUtil.setLmsSessionBoolean(requestBox);
		String yStr = "Y";
		if( !yStr.equals(requestBox.get("MemberYn")) ) {
			return new ModelAndView("/lms/common/sessionPop"); //session, sessionPop
		}
		
		model.addAttribute("sessionUid", requestBox.getString(LmsCode.userSessionUid));
		model.addAttribute("sessionName", requestBox.getString(LmsCode.userSessionName));
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("uid"))) {
			//1. 설문정보 읽기
			Map<String, Object> retMap = lmsMySurveyService.selectLmsSurvey(requestBox);
			model.addAttribute("data", retMap);
			
			//2.설문 예제 읽기
			List<Map<String, Object>> retList = lmsMySurveyService.selectLmsSurveySampleList(requestBox);
			int check0 = 0;
			if( retList != null && retList.size() > check0 ) {
				for( int i=0; i<retList.size(); i++ ) {
					Map<String, Object> tempMap = retList.get(i);
					tempMap.put("surveyname", tempMap.get("surveyname").toString().replaceAll("\n", "<br/>"));
					retList.set(i, tempMap);
				}
			}
			model.addAttribute("dataList", retList);
			
		}
		
		return new ModelAndView("/lms/myAcademy/lmsMySurveyPopup");
	}
	
	@SuppressWarnings("unused")
	@RequestMapping(value = "/lmsMySurveySubmitAjax.do")
	public ModelAndView lmsMySurveySubmitAjax(ModelMap model, RequestBox requestBox) throws Exception{

		ModelAndView mav = new ModelAndView("jsonView");
		
		lmsUtil.setLmsSessionBoolean(requestBox);
		mav.addObject("session", "T");
		String yStr = "Y";
		if( !yStr.equals(requestBox.get("MemberYn")) ) {
			mav.addObject("session", "F");
		}
		
		int upCount = 0;
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("uid"))) {
			
			//입력값 추출하기
			int surveyCount = requestBox.getInt("surveycount");
			Vector<Object> surveyseqArr = requestBox.getVector("surveyseq");
			Vector<Object> surveytypeArr = requestBox.getVector("surveytype");
			Vector<Object> samplecountArr = requestBox.getVector("samplecount");
			Vector<Object> responseArr = requestBox.getVector("response");
			
			List<Map<String,Object>> reponseList = new ArrayList<Map<String,Object>>();
			for( int i=0; i<surveyCount; i++ ) {
				Map<String,Object> retMap = new HashMap<String,Object>();
				
				retMap.put("surveyseq", (i+1) + "");
				String subjectResponse = "", objectResponse = "";
				List<Map<String,String>> opinionList = new ArrayList<Map<String,String>>();
				String str1 = "1";
				String str2 = "2";
				if( str1.equals(surveytypeArr.get(i).toString()) || str2.equals(surveytypeArr.get(i).toString()) ) {
					objectResponse = responseArr.get(i).toString();

					Vector<Object> directynArr = requestBox.getVector("directyn_" + (i+1));
					Vector<Object> opinioncontentArr = requestBox.getVector("opinioncontent_" + (i+1));
					
					for( int k=0; k<directynArr.size(); k++ ) {
						String tempDirectYn = "";
						if( directynArr.get(k) != null ) {
							tempDirectYn = directynArr.get(k).toString();
						}
						String tempOpinionContent = "";
						if( opinioncontentArr.get(k) != null ) {
							tempOpinionContent = opinioncontentArr.get(k).toString();
						}
						
						if( yStr.equals(tempDirectYn) && !blankStr.equals(tempOpinionContent) ) {
							Map<String,String> opinionMap = new HashMap<String,String>();
							opinionMap.put("opinionseq", (k+1)+"");
							opinionMap.put("opinioncontent", tempOpinionContent);
							
							opinionList.add(opinionMap);
						}
					}
				
					retMap.put("opinionList", opinionList);
				} else {
					subjectResponse = responseArr.get(i).toString();
					retMap.put("opinionList", opinionList);
				}
				
				retMap.put("subjectresponse", subjectResponse);
				retMap.put("objectresponse", objectResponse);
				
				reponseList.add(retMap);
			}
			
			//1. 답안지 제출하기
			upCount = lmsMySurveyService.submitLmsSurvey(requestBox, reponseList);
		}
		mav.addObject("result", upCount+"");
		
		return mav;		
	}
	
	
}
