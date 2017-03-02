package amway.com.academy.manager.lms.regular.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.lms.common.LmsCode;
import amway.com.academy.manager.lms.common.service.LmsCommonService;
import amway.com.academy.manager.lms.course.service.LmsCourseService;
import amway.com.academy.manager.lms.regular.service.LmsRegularService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :LmsRegularController.java
 * @DESC :정규과정 상세 관리
 * @Author:KR620243
 * @DATE : 2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */

@Controller
@RequestMapping("/manager/lms/course")
public class LmsRegularController {
	
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsRegularController.class);	
	
	@Autowired
	LmsRegularService lmsRegularService;
	
	@Autowired
	LmsCourseService lmsCourseService;
	
	@Autowired
	LmsCommonService lmsCommonService;
	
	@Autowired
	SessionUtil sessionUtil;
	
	/**
	 * 정규과정 관리 목록 빈화면
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegular.do")
	public ModelAndView lmsRegular(RequestBox requestBox, ModelAndView mav) throws Exception {
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/course/lmsRegular.do") );
		return mav;
    }	
	
	/**
	 * 정규과정 목록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegularListAjax.do")
    public ModelAndView lmsRegularListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*페이징 세팅 시작*/
		// 정렬 셋팅
		String sortKey = requestBox.get("sortKey");
		if("coursename".equals(sortKey)){
			requestBox.put("sortIndex", 1);
		}else{
			requestBox.put("sortIndex", 0);
		}
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(lmsRegularService.selectLmsRegularCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/

    	// 리스트
		rtnMap.put("dataList",  lmsRegularService.selectLmsRegularList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	   /**
     * 정규과정 Excel  다운로드
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/lmsRegularExcelDownload.do")
	public String lmsRegularExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
    	// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "정규과정과정목록";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","교육분류","정규과정명","교육기간","상태"};
		String[] headId = {"NO","CATEGORYTREENAME","COURSENAME","EDUDATE","OPENFLAGNAME"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String> > dataList = lmsRegularService.selectLmsRegularListExcelDown(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExportCountReverse(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
	
	/**
	 * 정규과정과정 삭제
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegularDeleteAjax.do")
    public ModelAndView lmsRegularDeleteAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*삭제파람 체크 시작*/
		requestBox.put("courseids", requestBox.getVector("courseid"));
		/*삭제파람 체크 끝*/
		
    	// 삭제처리
		int cnt = lmsRegularService.deleteLmsRegular(requestBox);
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 정규과정 등록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/lmsRegularWrite.do")
	public ModelAndView lmsRegularWrite(RequestBox requestBox, ModelAndView mav) throws Exception {
		requestBox.put("coursetype", "R");
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("courseid"))){
			rtnMap = lmsCourseService.selectLmsCourse(requestBox);
			mav.addObject("detail", rtnMap);
			requestBox.put("categoryid", rtnMap.get("categoryid"));
			
			rtnMap = lmsCommonService.selectLmsCategoryCode3Depth(requestBox);
			mav.addObject("categoryIdMap", rtnMap);
			
			rtnMap = lmsRegularService.selectLmsRegular(requestBox);
			mav.addObject("detail2", rtnMap);
		}else{
			rtnMap.put("studentcount", "0");
			mav.addObject("detail2", rtnMap);
		}
		mav.addObject("stampList", lmsRegularService.selectLmsRegularStampList(requestBox));
		mav.addObject("themeList", lmsCourseService.selectLmsThemeList(requestBox));
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/course/lmsRegular.do") );
		
		// 현재 시간 읽기
		mav.addObject("nowDate", lmsCommonService.selectYYYYMMDDHHMISS(requestBox));
		
		return mav;
    }	
	
	
	/**
	 * 정규과정 수강생 숫자 체크
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/lmsRegularWriteStudentAjax.do")
	public ModelAndView lmsRegularWriteStudentAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		requestBox.put("coursetype", "R");
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("courseid"))){
			rtnMap = lmsRegularService.selectLmsRegular(requestBox);
		}else{
			rtnMap.put("studentcount", "0");
		}
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }	
	
	/**
	 * 정규과정저장 저장
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegularSaveAjax.do")
    public ModelAndView lmsRegularSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//관리자 아이디 입력하기
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		//파람값 체크
		
		requestBox.put("coursetype", "R");
		
    	// 저장처리
		int cnt = 0;
		String courseid = requestBox.get("courseid");
		if("".equals(courseid)){
			cnt = lmsRegularService.insertLmsRegular(requestBox);
		}else{
			cnt = lmsRegularService.updateLmsRegular(requestBox);
		}
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 정규과정 과정등록 검색 목록 빈화면
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegularCourseSearch.do")
	public ModelAndView lmsRegularCourseSearch(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		mav.addObject("courseTypeList", LmsCode.getCourseTypeList2());
		
		return mav;
    }	
	
	/**
	 * 정규과정 과정등록 검색 목록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegularCourseSearchAjax.do")
    public ModelAndView lmsRegularCourseSearchAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*페이징 세팅 시작*/
		// 정렬 셋팅
		String sortKey = requestBox.get("sortKey");
		if("coursename".equals(sortKey)){
			requestBox.put("sortIndex", 1);
		}else{
			requestBox.put("sortIndex", 0);
		}
		String searchcoursetype = requestBox.get("searchcoursetype");
		PageVO pageVO = new PageVO(requestBox);
		if("F".equals(searchcoursetype)){ // 오프라인인경우 테마로 묶은 리스트가 필요함
			pageVO.setTotalCount(lmsRegularService.selectLmsRegularCourseThemeCount(requestBox));
		}else{
			pageVO.setTotalCount(lmsRegularService.selectLmsRegularCourseCount(requestBox));
		}
		
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/

    	// 리스트
    	if("F".equals(searchcoursetype)){ // 오프라인인경우 테마로 묶은 리스트가 필요함
    		rtnMap.put("dataList",  lmsRegularService.selectLmsRegularCourseThemeList(requestBox));
    	}else{
    		rtnMap.put("dataList",  lmsRegularService.selectLmsRegularCourseList(requestBox));
    	}

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 정규과정 과정등록 검색 목록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegularOffCourseListAjax.do")
    public ModelAndView lmsRegularOffCourseListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {

		Map<String, Object> rtnMap = new HashMap<String, Object>();
   		rtnMap.put("dataList",  lmsRegularService.selectLmsRegularOffCourseList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }

	/**
	 * 정규과정 스텝 유닛 합친 목록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegularStepUnitSumListAjax.do")
    public ModelAndView lmsRegularStepUnitSumListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {

		Map<String, Object> rtnMap = new HashMap<String, Object>();
   		rtnMap.put("stepList",  lmsRegularService.selectLmsRegularStepUnitSumList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 온라인,  라이브, 교육자료, 설문지 수정 상세
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/lmsRegularCourseEdit.do")
	public ModelAndView lmsRegularCourseEdit(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("courseid"))){
			rtnMap = lmsRegularService.selectLmsRegularStepUnitEditDetail(requestBox);
			mav.addObject("detail", rtnMap);
		}
		mav.addObject("hourList", LmsCode.getHourList());
		mav.addObject("minute2List", LmsCode.getMinute2List());
		return mav;
    }	
	
	/**
	 * 정규과정 스텝유닛별 수정 온라인,  라이브, 교육자료, 설문지
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegularCourseEditSaveAjax.do")
    public ModelAndView lmsRegularCourseEditSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//관리자 아이디 입력하기
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));

    	// 저장처리
		int cnt = lmsRegularService.updateLmsRegularStepUnitEdit(requestBox);
		rtnMap.put("result", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	
	/**
	 * 평가 수정 상세
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/lmsRegularCourseEditTest.do")
	public ModelAndView lmsRegularCourseEditTest(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("courseid"))){
			rtnMap = lmsRegularService.selectLmsRegularStepUnitEditDetail(requestBox);
			mav.addObject("detail", rtnMap);
			
			rtnMap = lmsRegularService.selectLmsRegularStepUnitEditTestDetail(requestBox);
			mav.addObject("detail2", rtnMap);
		}
		mav.addObject("hourList", LmsCode.getHourList());
		mav.addObject("minute2List", LmsCode.getMinute2List());
		return mav;
    }	
	
	/**
	 * 정규과정 스텝유닛별 수정 시험
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegularCourseEditTestSaveAjax.do")
    public ModelAndView lmsRegularCourseEditTestSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//관리자 아이디 입력하기
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));

    	// 저장처리
		int cnt = lmsRegularService.updateLmsRegularStepUnitEdit(requestBox);
		// 시험저장
		cnt += lmsRegularService.updateLmsRegularStepUnitEditTest(requestBox);
		rtnMap.put("result", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 오프라인 수정 상세
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/lmsRegularCourseEditOff.do")
	public ModelAndView lmsRegularCourseEditOff(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("courseid"))){
			rtnMap = lmsRegularService.selectLmsRegularStepUnitEditDetail(requestBox);
			mav.addObject("detail", rtnMap);
			
			rtnMap = lmsRegularService.selectLmsRegularStepUnitEditOffDetail(requestBox);
			mav.addObject("detail2", rtnMap);
			
			requestBox.put("apseq", rtnMap.get("apseq"));
			mav.addObject("roomCodeList", lmsCommonService.selectLmsRoomCodeList(requestBox));
		}
		mav.addObject("hourList", LmsCode.getHourList());
		mav.addObject("minute2List", LmsCode.getMinute2List());
		mav.addObject("apCodeList", lmsCommonService.selectLmsApCodeList(requestBox));
		return mav;
    }	
	
	/**
	 * 정규과정 스텝유닛별 수정 오프라인
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegularCourseEditOffSaveAjax.do")
    public ModelAndView lmsRegularCourseEditOffSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//관리자 아이디 입력하기
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));

    	// 저장처리
		int cnt = lmsRegularService.updateLmsRegularStepUnitEdit(requestBox);
		// 오프라인 저장
		cnt += lmsRegularService.updateLmsRegularStepUnitEditOff(requestBox);
		rtnMap.put("result", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
}