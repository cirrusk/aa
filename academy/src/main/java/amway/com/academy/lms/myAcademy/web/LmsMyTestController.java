package amway.com.academy.lms.myAcademy.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.lms.common.LmsCode;
import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.myAcademy.service.LmsMyTestService;
import framework.com.cmm.lib.RequestBox;

/**
 * @author kr620237
 * 2016.08.11
 * 사용자 온라인 시험
 */
@Controller
@RequestMapping("/lms/myAcademy")
public class LmsMyTestController {

	@Autowired
	LmsUtil lmsUtil;

	@Autowired
    private LmsMyTestService lmsMyTestService;
	
	@RequestMapping(value = "/lmsMyTest.do")
	public ModelAndView lmsMyTest(ModelMap model, RequestBox requestBox) throws Exception{
		
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		lmsUtil.setLmsSessionBoolean(requestBox);
		String yStr = "Y";
		String blankStr = "";
		int check0 = 0;
		if( !yStr.equals(requestBox.get("MemberYn")) ) {
			return new ModelAndView("/lms/common/sessionPop"); //session, sessionPop
		}
		
		model.addAttribute("sessionUid", requestBox.getString(LmsCode.userSessionUid));
		model.addAttribute("sessionName", requestBox.getString(LmsCode.userSessionName));
		
		if(!blankStr.equals(requestBox.get("uid"))) {
			//1. 시험정보 읽기 : 시험(course), 시험상세(test), 시험제출(student)
			Map<String, Object> testMap = lmsMyTestService.selectLmsTest(requestBox);

			//2.1 시험남은 시간 계산하기
			int limittime = lmsMyTestService.selectLmsTestLimitTime(requestBox);
			if( limittime < check0 ) {limittime = 0;}
			testMap.put("limittimesecond", ""+limittime);
			
			//2. 답안지 없으면 답안지 생성
			if( "0".equals(testMap.get("answercount").toString()) ) {
				lmsMyTestService.insertLmsTestAnswer(requestBox);
			}
			
			//3. 답안지 화면 노출 :--> 마지막 문제로 이동할 것
			int idx = 0;
			List<Map<String, Object>> testList = lmsMyTestService.selectLmsTestAnswerList(requestBox);
			if( testList != null && testList.size() > check0 ) {
				idx = testList.size();
				for( int i=0; i<testList.size(); i++ ) {
					Map<String, Object> tempMap = testList.get(i);
					tempMap.put("testpoolnote", tempMap.get("testpoolnote").toString().replaceAll("\n", "<br/>"));
					testList.set(i, tempMap);
				}
			}	
			model.addAttribute("dataList", testList);
			
			testMap.put("answercount", idx + "");
			model.addAttribute("data", testMap);
		}
		
		return new ModelAndView("/lms/myAcademy/lmsMyTestPopup");
	}
	
	@RequestMapping(value = "/lmsMyTestInitAjax.do")
	public ModelAndView lmsMyTestInitAjax(ModelMap model, RequestBox requestBox) throws Exception{

		ModelAndView mav = new ModelAndView("jsonView");
		
		//세션 체크해서 없으면 특정 페이지로 이동시킴
		lmsUtil.setLmsSessionBoolean(requestBox);
		mav.addObject("session", "T");
		String yStr = "Y";
		if( !yStr.equals(requestBox.get("MemberYn")) ) {
			mav.addObject("session", "F");
		}
		
		int upCount = 0;
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("uid"))) {
			//1. 시험시작 정보 입력 :--> 시험시작 정보 없을때만 입력함
			upCount = lmsMyTestService.updateLmsMyTestInit(requestBox);
		}
		mav.addObject("result", upCount+"");
		
		return mav;		
	}
	
	@RequestMapping(value = "/lmsMyTestAnswerAjax.do")
	public ModelAndView lmsMyTestAsnwerAjax(ModelMap model, RequestBox requestBox) throws Exception{

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
			//1. 답안지 정보 업데이트 하기
			upCount = lmsMyTestService.updateLmsTestAnswer(requestBox);
		}
		mav.addObject("result", upCount+"");
		
		return mav;		
	}
	
	@RequestMapping(value = "/lmsMyTestAnswerSubmitAjax.do")
	public ModelAndView lmsMyTestAnswerSubmitAjax(ModelMap model, RequestBox requestBox) throws Exception{

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
			//1. 답안지 제출하기
			upCount = lmsMyTestService.submitLmsTestAnswer(requestBox);
		}
		mav.addObject("result", upCount+"");
		
		return mav;		
	}
	
	
}
