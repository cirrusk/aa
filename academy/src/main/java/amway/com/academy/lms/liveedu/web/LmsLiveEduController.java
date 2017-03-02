package amway.com.academy.lms.liveedu.web;

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
import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.common.web.LmsCommonController;
import amway.com.academy.lms.liveedu.service.LmsLiveEduService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;


/**
 * @author KR620260
 *		date : 2016.08.16
 * lms 라이브교육 컨트롤러
 */
@Controller
@RequestMapping("/lms/liveedu")
public class LmsLiveEduController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsLiveEduController.class);

	@Autowired
	LmsUtil lmsUtil;

	@Autowired
	LmsCommonController lmsCommonController;

	/*
	 * Service
	 */
	@Autowired
    private LmsLiveEduService lmsLiveEduService;

	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	// CONDITIONTYPE 변수값 설정.
	private String conditiontypeCode = "2";	 //조회구분 1:노출 2:신청
    
	private static final int ZERO = 0;
	
	/**
	 * LMS 라이브교육 시청
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsLiveEdu.do")
	public ModelAndView lmsLiveEdu(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;
		
		//조회조건, 변수 설정
		requestBox.put("coursetype", "L");  // 라이브교육 강제 설정 "L"
		requestBox.put("categoryid", "");  // 
		requestBox.put("conditiontype", conditiontypeCode); //조회구분 1:노출 2:신청
		

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
		
		String sPlayYn = "N";
		String sCourseId = "";
		String sOpenFlag = "";

		// 리스트
    	List<Map<String, Object>> courseList = lmsLiveEduService.selectLiveEduList(requestBox);
    	String yStr = "Y";
    	if(!courseList.isEmpty() && courseList.size() > ZERO)  {
    		if( yStr.equals(courseList.get(0).get("mainplayyn")) || yStr.equals(courseList.get(0).get("replayyn")) ) {
    			sPlayYn = "Y";
    		}
    		sCourseId = courseList.get(0).get("courseid").toString();
    		sOpenFlag = courseList.get(0).get("openflag").toString();
    	}
    	
    	if( "Y".equals(sPlayYn)) {
    		/* 유효성 체크를 정규과정, 라이브교육 한번에 그대로 가고 단계 처리만 분계해서 한다. 아래 소스로 변경
    		if( "".equals(requestBox.getString( "courseid")) ) {
    			requestBox.put( "courseid", sCourseId);
    		}
    		requestBox.put("stepcourseid", requestBox.getString( "courseid"));
    		*/
   			requestBox.put( "courseid", sCourseId);
    		requestBox.put("stepcourseid", sCourseId);    		
    		
    		//정규 강좌의 경우 단계 완료 처리할 것
    		if( sOpenFlag.equals("C") ) {
    			lmsLiveEduService.updateFinishProcess2(requestBox);
    		} else {
    			//일반 라이브 과정 수료 처리
    			lmsLiveEduService.updateFinishProcess(requestBox);
    		}
    		
			// 사용전 원상태로 복원
			requestBox.put("courseid", requestBox.getString( "stepcourseid"));
    	}
    	
    	model.addAttribute("courseList", courseList);
    	model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
    	
		// 메인 화면 호출
		mav = new ModelAndView("/lms/liveedu/lmsLiveEdu");
		
		return mav;
	}
	
}
