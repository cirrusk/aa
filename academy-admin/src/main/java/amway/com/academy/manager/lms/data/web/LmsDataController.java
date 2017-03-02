package amway.com.academy.manager.lms.data.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

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
import amway.com.academy.manager.lms.data.service.LmsDataService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :LmsDataController.java
 * @DESC :교육자료상세 관리
 * @Author:김택겸
 * @DATE : 2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */

@Controller
@RequestMapping("/manager/lms/course")
public class LmsDataController {
	
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsDataController.class);	
	
	@Autowired
	LmsDataService lmsDataService;
	
	@Autowired
	LmsCourseService lmsCourseService;
	
	@Autowired
	LmsCommonService lmsCommonService;
	
	@Autowired
	SessionUtil sessionUtil;
	
	/**
	 * 교육자료 관리 목록 빈화면
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsData.do")
	public ModelAndView lmsData(RequestBox requestBox, ModelAndView mav) throws Exception {
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/course/lmsData.do") );
		mav.addObject("dataTypeList", LmsCode.getDataList());
		return mav;
    }	
	
	/**
	 * 교육자료 목록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsDataListAjax.do")
    public ModelAndView lmsDataListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsDataService.selectLmsDataCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/

    	// 리스트
		rtnMap.put("dataList",  lmsDataService.selectLmsDataList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
    /**
     * 교육자료 Excel  다운로드
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/lmsDataExcelDownload.do")
	public String lmsDataExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
    	// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "교육자료목록";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","교육분류","교육자료명","자료유형","등록일","상태"};
		String[] headId = {"NO","CATEGORYTREENAME","COURSENAME","DATATYPENAME","REGISTRANTDATE","OPENFLAGNAME"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String> > dataList = lmsDataService.selectLmsDataListExcelDown(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExportCountReverse(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
	
	/**
	 * 교육자료 삭제
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsDataDeleteAjax.do")
    public ModelAndView lmsDataDeleteAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*삭제파람 체크 시작*/
		requestBox.put("courseids", requestBox.getVector("courseid"));
		/*삭제파람 체크 끝*/
		
    	// 삭제처리
		int cnt = lmsDataService.deleteLmsData(requestBox);
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 교육자료 복사
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsDataCopyAjax.do")
    public ModelAndView lmsDataCopyAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
    	// 복사처리
		int cnt = 0;
		String blankStr = "";
		if( !blankStr.equals(requestBox.getVector("courseid"))) {
			
			String courseids = "";
			Vector<Object> vector = requestBox.getVector("courseid");
			for( int i=vector.size(); i>0; i-- ) {
				StringBuffer courseidsBuffer = new StringBuffer(courseids);
				courseidsBuffer.append( vector.get(i-1).toString() + "," );
				courseids = courseidsBuffer.toString();
			}
			if( !courseids.equals("") ) {
				courseids = courseids.substring(0, courseids.length()-1);
			}
			
			//복사할 설문번호 얻기
			requestBox.put("courseids", courseids);
			
			cnt = lmsDataService.copyLmsDataAjax(requestBox);
		}
		
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 교육자료 등록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/lmsDataWrite.do")
	public ModelAndView lmsDataWrite(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("courseid"))){
			rtnMap = lmsCourseService.selectLmsCourse(requestBox);
			mav.addObject("detail", rtnMap);
			requestBox.put("categoryid", rtnMap.get("categoryid"));
			rtnMap = lmsCommonService.selectLmsCategoryCode3Depth(requestBox);
			mav.addObject("categoryIdMap", rtnMap);
			rtnMap = lmsDataService.selectLmsData(requestBox);
			mav.addObject("detail2", rtnMap);
		}
		mav.addObject("hourList", LmsCode.getHourList());
		mav.addObject("minuteList", LmsCode.getMinuteList());
		mav.addObject("minute2List", LmsCode.getMinute2List());
		mav.addObject("secondList", LmsCode.getSecondList());
		mav.addObject("dataTypeList", LmsCode.getDataList());
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/course/lmsData.do") );
		return mav;
    }	
	

	/**
	 * 교육자료저장 저장
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsDataSaveAjax.do")
    public ModelAndView lmsDataSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//관리자 아이디 입력하기
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		//파람값 체크
		requestBox.put("coursetype", "D");
		requestBox.put("cancelterm", "0");
		
    	// 저장처리
		int cnt = 0;
		String courseid = requestBox.get("courseid");
		if("".equals(courseid)){
			cnt = lmsDataService.insertLmsData(requestBox);
		}else{
			cnt = lmsDataService.updateLmsData(requestBox);
		}
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
}


