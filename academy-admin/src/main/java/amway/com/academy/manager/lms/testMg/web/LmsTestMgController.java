package amway.com.academy.manager.lms.testMg.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.lms.common.LmsCode;
import amway.com.academy.manager.lms.course.service.LmsCourseService;
import amway.com.academy.manager.lms.testMg.service.LmsTestMgService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :LmsTestMgController.java
 * @DESC :시험지 관리
 * @Author:김택겸
 * @DATE : 2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */
@Controller
@RequestMapping("/manager/lms/testMg")
public class LmsTestMgController {
	
	@Autowired
	LmsTestMgService lmsTestMgService;
	
	@Autowired
	LmsCourseService lmsCourseService;
	
	@Autowired
	SessionUtil sessionUtil;

	
	/**
	 * 시험지 관리 화면으로 이동
	 * @param requestBox
	 * @param mav
	 * @return
	 */
	@RequestMapping(value="/lmsTestMg.do")
	public ModelAndView lmsTestMg(RequestBox requestBox, ModelAndView mav) {
		
		mav.addObject("lmsCategoryList",  lmsTestMgService.selectLmsTestMgCategoryList());
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/testMg/lmsTestMg.do") );
		return mav;
	}
	
	/**
	 * 시험지 관리 목록 조회 
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/lmsTestMgAjax.do")
	public ModelAndView lmsTestMgAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		
		pageVO.setTotalCount(lmsTestMgService.selectLmsTestMgCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/

    	// 리스트
		rtnMap.put("dataList", lmsTestMgService.selectLmsTestMgList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	
	@RequestMapping(value = "/lmsTestMgExcelDownload.do")
	public String lmsTestMgExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		
		String sortKey = requestBox.get("sortKey");
		if("coursename".equals(sortKey)){
			requestBox.put("sortIndex", 1);
		}else{
			requestBox.put("sortIndex", 0);
		}
		
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "시험지관리";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","시험분류","시험지명","평가기간"};
		String[] headId = {"NO","CATEGORYTREENAME","COURSENAME","EDUDATE"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String>> dataList = lmsTestMgService.selectLmsTestMgExcelList(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExportCountReverse(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/lmsTestMgPop.do")
	public ModelAndView lmsTestPoolPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		String searchcategoryid = requestBox.get("searchcategoryid");
		
		//문제 분류 읽기
		List<DataBox> categoryList = lmsTestMgService.selectLmsTestMgCategoryList();
		List<Map<String,String>> testSubmitList = new ArrayList<Map<String,String>>(); //시험문제출제기준정보
		
		String inputtype = requestBox.get("inputtype");
		String blankStr = "";
		int check0 = 0;
		if( inputtype.equals("U") ) { //update
			if(!blankStr.equals(requestBox.get("courseid"))){
				//1. 시험지 기본 정보 읽기
				rtnMap = lmsCourseService.selectLmsCourse(requestBox);
				mav.addObject("detail", rtnMap);
				
				requestBox.put("categoryid", rtnMap.get("categoryid"));
				
				//2. 시험 상세 정보 읽기
				rtnMap = lmsTestMgService.selectLmsTestMgDetail(requestBox);
				mav.addObject("detail2", rtnMap);

				//3.시험지 풀 정보 읽기 :--> categoryId 필요함, 반드시 1,2,3 나옴
				List<Map<String,String>> listTestPoolTotalList = lmsTestMgService.selectLmsTestPoolTotalList(requestBox);
				
				//4. 시험 출제 정보 읽기 : list
				List<Map<String,String>> list = lmsTestMgService.selectLmsTestMgSubmitList(requestBox);

				//5. 시험지 풀 정보를 code값 만큼 매치하고 시험 출제 정보와도 매치한다.
				for(int i=0; i<listTestPoolTotalList.size(); i++) {
					Map<String,String> tempMap = listTestPoolTotalList.get(i);
					
					for(int k=0; k<list.size(); k++) {
						Map<String,String> temp2Map = list.get(k);
						if( tempMap.get("answertype").equals( temp2Map.get("answertype")) ) {
							tempMap.put("testcount", temp2Map.get("testcount"));
							tempMap.put("testpoint", temp2Map.get("testpoint"));
							break;
						}
					}
					
					testSubmitList.add(tempMap);
				}
			}
		} else {
			
			//입력일 경우
			//1. 카테고리 번호를 세팅한다.
			if( !blankStr.equals(searchcategoryid) ) {
				requestBox.put("categoryid", requestBox.get("searchcategoryid"));
			} else {
				if( categoryList != null && categoryList.size() > check0 ) {
					requestBox.put("categoryid", categoryList.get(0).get("categoryid") );
				}
			}
			
			//카테고리 번호 세팅하기
			rtnMap.put("categoryid", requestBox.get("categoryid"));
			mav.addObject("detail", rtnMap);

			//시험지 풀 정보 읽기 :--> categoryId 필요함, 반드시 1,2,3 나옴
			if( !blankStr.equals(requestBox.get("categoryid")) ) {
				testSubmitList = lmsTestMgService.selectLmsTestPoolTotalList(requestBox);
			} else {
				for(int i=1;i<=3;i++) {
					Map<String,String> tempMap = new HashMap<String,String>();
					tempMap.put("answertype", i+"");
					tempMap.put("answercount", "0");
					tempMap.put("testcount", "0");
					tempMap.put("testpoint", "0");
					
					testSubmitList.add(tempMap);
				}	
			}
			
			//온라인 / 오프라인 세팅
			rtnMap.put("testtype", "O");
			mav.addObject("detail2", rtnMap);
		}
		
		mav.addObject("testSubmitList", testSubmitList);
		
		mav.addObject("lmsCategoryList", categoryList);
		mav.addObject("hourList", LmsCode.getHourList());
		mav.addObject("minuteList", LmsCode.getMinuteList());
		mav.addObject("minute2List", LmsCode.getMinute2List());
		
		return mav;
	}
	
	@RequestMapping(value="/lmsTestMgTestPoolAjax.do")
	public ModelAndView lmsTestMgTestPoolAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("categoryid"))){
			
			//1.시험지 풀 정보 읽기 :--> categoryId 필요함, 반드시 1,2,3 나옴
			rtnMap.put("dataList", lmsTestMgService.selectLmsTestPoolTotalList(requestBox));
		} else {
			rtnMap.put("dataList", null);
		}

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	
	@RequestMapping(value="/lmsTestMgSaveAjax.do")
	public ModelAndView lmsTestMgSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//관리자 아이디 입력하기
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
				
		int cnt = 0;
		
		if("I".equals(requestBox.get("inputtype"))){
			//1. insert lmsCourse
			//2. insert lmsTest
			//3. insert lmsTestSubmit (3set)
			cnt = lmsTestMgService.insertLmsTestMgAjax(requestBox);
		} else {
			//1. update lmsCourse
			//2. update lmsTest
			//3. delete lmsTestSubmit
			//4. insert lmsTestSubmit (3set)
			cnt = lmsTestMgService.updateLmsTestMgAjax(requestBox);
		}
		
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	@RequestMapping(value="/lmsTestMgDeleteAjax.do")
	public ModelAndView lmsTestMgDeleteAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*삭제파람 체크 시작*/
		requestBox.put("courseids", requestBox.getVector("courseid"));
		/*삭제파람 체크 끝*/
	
    	// 삭제처리
		int cnt = lmsTestMgService.deleteLmsTestMgAjax(requestBox);
		
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
}

