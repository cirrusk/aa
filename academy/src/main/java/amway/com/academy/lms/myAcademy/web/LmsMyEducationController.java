package amway.com.academy.lms.myAcademy.web;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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
import amway.com.academy.lms.myAcademy.service.LmsMyEducationService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.DateUtil;



/**
 * @author KR620260
 *		date : 2016.08.19
 * lms 통합교육 컨트롤러
 */
@Controller
@RequestMapping("/lms/myAcademy")
public class LmsMyEducationController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsMyEducationController.class);

	@Autowired
	LmsUtil lmsUtil;

	@Autowired
	LmsCommonController lmsCommonController;

	/*
	 * Service
	 */
	@Autowired
    private LmsMyEducationService lmsMyEducationService;
	
	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	public static final int DEFYM = 200101;  // 기준 년월
	public static final int DEFYEAR = 2001;  // 기준 년도
	public static final int DIVMON = 9;  // 분기별 기준 9월
	public static final int ZERO = 0;
	
	/**
	 * LMS 통합교육 조회
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsMyEducation.do")
	public ModelAndView lmsMyEducation(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		ModelAndView mav = null;

		//하이브리스 영역에서 넘어온 변수를 가지고 로그인 및 세션 처리할 것
		Map<String,String> loginMap = lmsCommonController.lmsCommonHybrisLogin(requestBox);
		if( null == loginMap || !"SUCCESS".equals(loginMap.get("result")) ) {
			return new ModelAndView("/lms/common/login");
		}

		requestBox = lmsUtil.setLmsSessionBoolean(requestBox);
		if( !requestBox.get("MemberYn").equals("Y") ) { 	//세션 체크해서 없으면 특정 페이지로 이동시킴
			return new ModelAndView("/lms/common/session"); //session, sessionPop
		}
		
		// 현재일자, 시작달, 종료달, 시작일자, 종료일자, 설정달, 설정일자,  이전달, 다음달
		Calendar cal = Calendar.getInstance();
		DateFormat df = new SimpleDateFormat("yyyyMMdd");
		String toDay = DateUtil.getDateType("yyyyMMdd");
		String startdateYM = "", enddateYM = "", startdateYMD = "", enddateYMD = "", currdateYM = "", currdateYMD = "";
		String prevYM = "", nextYM = "", prevYear = "", nextYear = "";
		String currentYear = "", currentMon = "", pfYear = "", currentYearStamp = "";
		
		// 설정일자,  이전달, 다음달 설정
		if("".equals(requestBox.getString("currdateYM"))) {
			requestBox.put("currdateYM", toDay.substring(0, 6));
		}
		currdateYM = requestBox.getString("currdateYM");
		Date cDate = df.parse(currdateYM+"01");
		
		cal.setTime(cDate);
		cal.add(Calendar.MONTH, -1);
		prevYM = df.format(cal.getTime()).toString().substring(0, 6);
		if(Integer.parseInt(prevYM) < DEFYM) {
			prevYM = "";
		}
		
		if(currdateYM.equals(toDay.substring(0, 6))) {
			currdateYMD = toDay;
			nextYM = "";
		} else {
			cal.setTime(cDate);
			cal.add(Calendar.MONTH, 1);
			nextYM = df.format(cal.getTime()).toString().substring(0, 6);
			cal.add(Calendar.DATE, -1);
			currdateYMD = df.format(cal.getTime()).toString();
		}
		
		// 시작일자, 종료일자 설정
		cal.setTime(cDate);
		if(Integer.parseInt(currdateYM.substring(4,6)) < DIVMON) {  // 분기별 기준 9월이전일때.
			pfYear = df.format(cal.getTime()).toString().substring(0, 4);
			enddateYM = pfYear + "08";
			enddateYMD = pfYear + "0831";
			
			cal.add(Calendar.YEAR, -1);
			startdateYM = df.format(cal.getTime()).toString().substring(0, 4) + "09";
			startdateYMD = df.format(cal.getTime()).toString().substring(0, 4) + "0901";
		} else {
			startdateYM = df.format(cal.getTime()).toString().substring(0, 4) + "09";
			startdateYMD = df.format(cal.getTime()).toString().substring(0, 4) + "0901";
		
			cal.add(Calendar.YEAR, 1);
			pfYear = df.format(cal.getTime()).toString().substring(0, 4);
			enddateYM = pfYear + "08";
			enddateYMD = pfYear + "0831";
		}
		currentYear = currdateYM.substring(0,4);
		currentMon = currdateYM.substring(4,6);
		
		// 스탬프,  이전년도, 다음년도 설정
		if("".equals(requestBox.getString("currentYearStamp"))) {
			//requestBox.put("currentYearStamp", toDay.substring(0, 4));
			requestBox.put("currentYearStamp", lmsMyEducationService.selectLmsStampNowYear(requestBox).get("nowyear"));
		}
		currentYearStamp = requestBox.getString("currentYearStamp");
		Date cDateStamp = df.parse(currentYearStamp+"0101");
		
		cal.setTime(cDateStamp);
		cal.add(Calendar.YEAR, -1);
		prevYear = df.format(cal.getTime()).toString().substring(0, 4);
		if(Integer.parseInt(prevYear) < DEFYEAR) {
			prevYear = "";
		}
		
		cal.setTime(cDateStamp);
		cal.add(Calendar.YEAR, 1);
		nextYear = df.format(cal.getTime()).toString().substring(0, 4);
		if(Integer.parseInt(nextYear) > Integer.parseInt(toDay.substring(0, 4))) {
			nextYear = "";
		}


		requestBox.put("PFYear", pfYear.substring(2,4));
		requestBox.put("PFFullYear", pfYear);
		requestBox.put("currentYear", currentYear);
		requestBox.put("currentMon", currentMon);
		requestBox.put("currdateYM", currdateYM);
		requestBox.put("currdateYMD", currdateYMD);
		
		requestBox.put("startdateYM", startdateYM);
		requestBox.put("startdateYMD", startdateYMD);
		requestBox.put("enddateYM", enddateYM);
		requestBox.put("enddateYMD", enddateYMD);
		requestBox.put("prevYM", prevYM);
		requestBox.put("nextYM", nextYM);
		
		requestBox.put("currentYearStamp", currentYearStamp);
		requestBox.put("prevYear", prevYear);
		requestBox.put("nextYear", nextYear);
		
		int rtnCnt = 0;
		// 월 접속 일수
		rtnCnt = lmsMyEducationService.selectLmsConnectLogTot(requestBox); // 월 접속 일수 -전체
		requestBox.put("connDaytoTot", rtnCnt);
		
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsConnectLogCnt(requestBox); // 월 접속 일수 -설정달
		requestBox.put("connDaytoMon", rtnCnt);
		
		
		// 월 개근 주
		rtnCnt = 0;
		//rtnCnt = lmsMyEducationService.selectLmsConnectLogWeekTot(requestBox); // 개근주 -전체
		rtnCnt = lmsMyEducationService.selectLmsConnectLogWeekTot2(requestBox); // 개근주 -전체 연속
		requestBox.put("connWeektoTot", rtnCnt);
		
		String sConnectday = "";
		int iWeekcnt = 0;
		List<Map<String, Object>> connectList = lmsMyEducationService.selectLmsConnectLogWeekList(requestBox); // 개근주 -설정달
		if(!connectList.isEmpty() && connectList.size() > ZERO) {
			sConnectday = (String) connectList.get(0).get("connectday").toString();
			iWeekcnt = (Integer) Integer.parseInt(connectList.get(0).get("weekcnt").toString());
		}
		
		int weeknumcnt = 0;
		List<Map<String, Object>> connectList2 = lmsMyEducationService.selectLmsConnectLogWeekList2(requestBox); // 월 개근주 단순 출석 주  
		if(!connectList2.isEmpty() && connectList2.size() > ZERO) {
			weeknumcnt = (Integer) Integer.parseInt(connectList2.get(0).get("weeknumcnt").toString());
		}
		
		requestBox.put("connWeeklyStart", sConnectday);
		requestBox.put("connWeeklycnt", iWeekcnt);
		
		requestBox.put("weeknumcnt", weeknumcnt);
		
		requestBox.put("openflag", "Y");
		// 교육자료
		requestBox.put("coursetype", "D");
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsCourseStudentFinshTot(requestBox); // 상세보기 과정갯수 -전체
		requestBox.put("eduResourceTot", rtnCnt);
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsCourseStudentFinshCnt(requestBox); // 상세보기 과정갯수 -설정달
		requestBox.put("eduResourceCnt", rtnCnt);
		
		// 온라인강의
		requestBox.put("coursetype", "O"); // 온라인강의
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsCourseStudentFinshTot(requestBox); // 수강건수 -전체
		requestBox.put("onlineFinTot", rtnCnt);
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsCourseStudentFinshCnt(requestBox); // 수강건수 -설정달
		requestBox.put("onlineFinCnt", rtnCnt);
		
		// 오프라인강의
		requestBox.put("coursetype", "F");
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsCourseStudentFinshTot(requestBox); // 수료건수 -전체
		requestBox.put("offlineFinTot", rtnCnt);
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsCourseStudentFinshCnt(requestBox); // 수료건수 -설정달
		requestBox.put("offlineFinCnt", rtnCnt);
		
		// 라이브교육
		requestBox.put("coursetype", "L");
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsCourseStudentFinshTot(requestBox); // 수료건수 -전체
		requestBox.put("liveFinTot", rtnCnt);
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsCourseStudentFinshCnt(requestBox); // 수료건수 -설정달
		requestBox.put("liveFinCnt", rtnCnt);
		
		// SNS 공유
		requestBox.put("viewtype", "1");  // 1 SNS공유, 2좋아요, 3조회	
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsViewlogTot(requestBox); // SNS공유건수 -전체
		requestBox.put("logSNSTot", rtnCnt);
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsViewlogCnt(requestBox); // SNS공유건수 -설정달
		requestBox.put("logSNSCnt", rtnCnt);
		
		// 정규과정 수료
		//OO년도 정규과정 수료건수
		requestBox.put("coursetype", "R"); // 정규과정
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsCourseStudentFinshTot(requestBox); // 수강건수 -전체
		requestBox.put("StampRegularTot", rtnCnt);
		rtnCnt = 0;
		rtnCnt = lmsMyEducationService.selectLmsCourseStudentFinshCnt(requestBox); // 수강건수 -설정달
		requestBox.put("StampRegularCnt", rtnCnt);
		requestBox.put("currentYear", currentYear);
			
		//스템프발행
		List<Map<String, Object>> stampObtainList = lmsMyEducationService.selectLmsStampobtain(requestBox); // 스템프 발행 조회
		
		// 정규과정 스탬프
		List<Map<String, Object>> stampObtainRegularList = lmsMyEducationService.selectLmsStampRegular(requestBox); // 정규과정 스템프 발행 조회
		
		//일반 스템프 목록 조회
		requestBox.put("stamptype", "N");
		List<Map<String, Object>> stampNorList = lmsMyEducationService.selectLmsStampIdList(requestBox); // 스템프 항목 조회
		
		//정규과정 목록 조회
		requestBox.put("stamptype", "C");
		List<Map<String, Object>> stampCourseList = lmsMyEducationService.selectLmsStampIdList(requestBox); // 스템프 항목 조회
		
		model.addAttribute("stampList", stampObtainList);
		model.addAttribute("stampRegularList", stampObtainRegularList);
		model.addAttribute("stampNorList", stampNorList);
		model.addAttribute("stampCourseList", stampCourseList);
		
		model.addAttribute("scrData", requestBox);
		
		// adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
		model.addAttribute("analBox", analBox);
		// adobe analytics
		
		// 메인 화면 호출
		mav = new ModelAndView("/lms/myAcademy/lmsMyEducation");
		
		return mav;
		
	}
	
}
