package amway.com.academy.manager.lms.offline.web;

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
import amway.com.academy.manager.lms.offline.service.LmsOfflineService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :LmsOfflineController.java
 * @DESC :오프라인강의 상세 관리
 * @Author:KR620243
 * @DATE : 2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */

@Controller
@RequestMapping("/manager/lms/course")
public class LmsOfflineController {
	
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsOfflineController.class);	
	
	@Autowired
	LmsOfflineService lmsOfflineService;
	
	@Autowired
	LmsCourseService lmsCourseService;
	
	@Autowired
	LmsCommonService lmsCommonService;
	
	@Autowired
	SessionUtil sessionUtil;
	
	/**
	 * 오프라인 관리 목록 빈화면
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOffline.do")
	public ModelAndView lmsOffline(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		mav.addObject("apCodeList", lmsCommonService.selectLmsApCodeList(requestBox));
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/course/lmsOffline.do") );
		return mav; 
    }	
	
	/**
	 * 오프라인 목록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOfflineListAjax.do")
    public ModelAndView lmsOfflineListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsOfflineService.selectLmsOfflineCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/

    	// 리스트
		rtnMap.put("dataList",  lmsOfflineService.selectLmsOfflineList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
    /**
     * 오프라인 Excel  다운로드
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/lmsOfflineExcelDownload.do")
	public String lmsOfflineExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
    	// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "오프라인과정목록";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","교육분류","브랜드/테마","과정명","교육장소","교육기간","상태","페널티"};
		String[] headId = {"NO","CATEGORYTREENAME","THEMENAME","COURSENAME","APNAME","EDUDATE","OPENFLAGNAME","PENALTYFLAGNAME"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String> > dataList = lmsOfflineService.selectLmsOfflineListExcelDown(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExportCountReverse(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
	
	/**
	 * 오프라인 삭제
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOfflineDeleteAjax.do")
    public ModelAndView lmsOfflineDeleteAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*삭제파람 체크 시작*/
		requestBox.put("courseids", requestBox.getVector("courseid"));
		/*삭제파람 체크 끝*/
		
    	// 삭제처리
		int cnt = lmsOfflineService.deleteLmsOffline(requestBox);
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 오프라인 등록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/lmsOfflineWrite.do")
	public ModelAndView lmsOfflineWrite(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		requestBox.put("coursetype", "F");
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("courseid"))){
			rtnMap = lmsCourseService.selectLmsCourse(requestBox);
			mav.addObject("detail", rtnMap);
			requestBox.put("categoryid", rtnMap.get("categoryid"));
			requestBox.put("openflag", rtnMap.get("openflag"));
			rtnMap = lmsCommonService.selectLmsCategoryCode3Depth(requestBox);
			mav.addObject("categoryIdMap", rtnMap);
			rtnMap = lmsOfflineService.selectLmsOffline(requestBox);
			mav.addObject("detail2", rtnMap);
			
			requestBox.put("apseq", rtnMap.get("apseq"));
			mav.addObject("roomCodeList", lmsCommonService.selectLmsRoomCodeList(requestBox));
		}
		mav.addObject("hourList", LmsCode.getHourList());
		mav.addObject("minuteList", LmsCode.getMinuteList());
		mav.addObject("minute2List", LmsCode.getMinute2List());
		mav.addObject("secondList", LmsCode.getSecondList());
		mav.addObject("apCodeList", lmsCommonService.selectLmsApCodeList(requestBox));
		mav.addObject("themeList", lmsCourseService.selectLmsThemeList(requestBox));
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/course/lmsOffline.do") );
		return mav;
    }	
	

	/**
	 * 오프라인 저장
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOfflineSaveAjax.do")
    public ModelAndView lmsOfflineSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//관리자 아이디 입력하기
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		//파람값 체크

		requestBox.put("coursetype", "F"); // 오프라인과정으로 설정
		
    	// 저장처리
		int cnt = 0;
		String courseid = requestBox.get("courseid");
		if("".equals(courseid)){
			cnt = lmsOfflineService.insertLmsOffline(requestBox);
		}else{
			cnt = lmsOfflineService.updateLmsOffline(requestBox);
		}
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
}


