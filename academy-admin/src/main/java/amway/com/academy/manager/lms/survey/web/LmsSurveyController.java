package amway.com.academy.manager.lms.survey.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.lms.common.LmsCode;
import amway.com.academy.manager.lms.common.service.LmsCommonService;
import amway.com.academy.manager.lms.course.service.LmsCourseService;
import amway.com.academy.manager.lms.survey.service.LmsSurveyService;
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
 * @NAME :LmsSurveyController.java
 * @DESC :설문 관리
 * @Author:김택겸
 * @DATE : 2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */
@Controller
@RequestMapping("/manager/lms/survey")
public class LmsSurveyController {
	
	
	@Autowired
	LmsSurveyService lmsSurveyService;
	
	@Autowired
	LmsCourseService lmsCourseService;
	
	@Autowired
	LmsCommonService lmsCommonService;

	@Autowired
	SessionUtil sessionUtil;
	
	@RequestMapping(value = "/lmsSurvey.do")
	public ModelAndView lmsSurvey(RequestBox requestBox, ModelAndView mav) throws Exception {
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/survey/lmsSurvey.do") );
		return mav;
    }
	
	@RequestMapping(value = "/lmsSurveyAjax.do")
	public ModelAndView lmsSurveyAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
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
		pageVO.setTotalCount(lmsSurveyService.selectLmsSurveyCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/

    	// 리스트
		rtnMap.put("dataList",  lmsSurveyService.selectLmsSurveyList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
    }
	
	@RequestMapping(value = "/lmsSurveyExcelDownload.do")
	public String lmsSurveyExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		
		String sortKey = requestBox.get("sortKey");
		if("coursename".equals(sortKey)){
			requestBox.put("sortIndex", 1);
		}else{
			requestBox.put("sortIndex", 0);
		}
		
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "설문관리";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","교육분류","설문명","설문기간"};
		String[] headId = {"NO","CATEGORYTREENAME","COURSENAME","EDUDATE"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String>> dataList = lmsSurveyService.selectLmsSurveyExcelList(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExportCountReverse(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
	
	@RequestMapping(value = "/lmsSurveyDeleteAjax.do")
    public ModelAndView lmsSurveyDeleteAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*삭제파람 체크 시작*/
		requestBox.put("courseids", requestBox.getVector("courseid"));
		/*삭제파람 체크 끝*/
	
    	// 삭제처리
		int cnt = lmsSurveyService.deleteLmsSurveyAjax(requestBox);
		
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	@RequestMapping(value = "/lmsSurveyCopyAjax.do")
    public ModelAndView lmsSurveyCopyAjax(RequestBox requestBox, ModelAndView mav) throws Exception {

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
			
			cnt = lmsSurveyService.copyLmsSurveyAjax(requestBox);
		}
		
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/lmsSurveyWrite.do")
	public ModelAndView lmsSurveyWrite(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		mav.addObject("inputtype", requestBox.get("inputtype"));

		requestBox.put("coursetype", "V");
		if("U".equals(requestBox.get("inputtype"))){
			//1. 설문지 읽기
			rtnMap = lmsCourseService.selectLmsCourse(requestBox);
			mav.addObject("detail", rtnMap);
			
			//2.카테고리 읽기
			requestBox.put("categoryid", rtnMap.get("categoryid"));
			rtnMap = lmsCommonService.selectLmsCategoryCode3Depth(requestBox);
			mav.addObject("categoryIdMap", rtnMap);
			
			//3. 설문의 응답자가 있는지 확인
			int responseCount = lmsSurveyService.selectLmsSurveyResponseCount(requestBox);
			mav.addObject("responsecount", responseCount+"");
		} else {
			mav.addObject("responsecount", "0");
		}
		mav.addObject("hourList", LmsCode.getHourList());
		mav.addObject("minuteList", LmsCode.getMinuteList());
		mav.addObject("minute2List", LmsCode.getMinute2List());
		mav.addObject("secondList", LmsCode.getSecondList());
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/survey/lmsSurvey.do") );
		return mav;
	}
	
	@RequestMapping(value = "/lmsSurveyWriteAjax.do")
	public ModelAndView lmsSurveyWriteAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		//1. list lmsSurvey
		List<DataBox> surveyList = lmsSurveyService.selectLmsSurveyDetailList(requestBox);
		
		//2. list lmsSurveySample : 10 number
		List<DataBox> sampleList = lmsSurveyService.selectLmsSurveySampleList(requestBox);

		List<Map<String,String>> surveyGrid = new ArrayList<Map<String,String>>();
		for( int i=0; i<surveyList.size(); i++ ) {
			DataBox dataBox = (DataBox)surveyList.get(i);
			
			Map<String,String> retMap = new HashMap<String,String>(); 
			
			retMap.put("no", dataBox.getString("surveyseq"));
			retMap.put("surveyseq", dataBox.getString("surveyseq"));
			retMap.put("surveyname", dataBox.getString("surveyname"));
			retMap.put("surveytype", dataBox.getString("surveytype"));
			retMap.put("surveytypename", dataBox.getString("surveytypename"));
			retMap.put("samplecount", dataBox.getString("samplecount"));
			
			int idx = 0; 
			for( int k=0; k<sampleList.size(); k++ ) {
				DataBox dataBox2 = (DataBox)sampleList.get(k);
				
				if( retMap.get("surveyseq").equals( dataBox2.getString("surveyseq") ) ) {
					retMap.put("samplename_"+(idx+1), dataBox2.getString("samplename"));
					retMap.put("samplevalue_"+(idx+1), dataBox2.getString("samplevalue").replace("0", ""));
					retMap.put("directyn_"+(idx+1), dataBox2.getString("directyn"));
					
					idx ++;
				}
			}
			
			for(; idx<10; idx++) {
				retMap.put("samplename_"+(idx+1), "");
				retMap.put("samplevalue_"+(idx+1), "");
				retMap.put("directyn_"+(idx+1), "N");
			}
			
			surveyGrid.add(retMap);
		}
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  surveyGrid);
		
		return mav;
    }
	
	@RequestMapping(value = "/lmsSurveyPop.do")
	public ModelAndView lmsSurveyPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		List<DataBox> dataList = null;
		
		if("U".equals(requestBox.get("inputtype"))){
			//현재 넘어온 param값을 가지고 처리할 것
			
			int samplecount = requestBox.getInt("samplecount");
			
			dataList = new ArrayList<DataBox>();
			
			int idx = 0;
			for( ; idx<samplecount; idx++ ) {
				DataBox dbBox = new DataBox();
				dbBox.put("sampleseq", (idx+1) + "");
				dbBox.put("samplename", requestBox.get("samplename_"+(idx+1)));
				dbBox.put("directyn", requestBox.get("directyn_"+(idx+1)));
				dbBox.put("samplevalue", requestBox.get("samplevalue_"+(idx+1)));
				dbBox.put("sampledisplay", "Y");
				
				dataList.add(dbBox);
			}
			
			for( ; idx<10; idx++ ) {
				DataBox dbBox = new DataBox();
				dbBox.put("sampleseq", (idx+1) + "");
				dbBox.put("samplename", "");
				dbBox.put("directyn", "N");
				dbBox.put("samplevalue", "");
				dbBox.put("sampledisplay", "N");
				
				dataList.add(dbBox);
			}
			
		} else {
			requestBox.put("surveytype", "1");
			requestBox.put("samplecount", "4");
			int check4 = 4;
			dataList = new ArrayList<DataBox>();
			for( int i=0; i<10; i++ ) {
				DataBox dbBox = new DataBox();
				dbBox.put("sampleseq", (i+1) + "");
				dbBox.put("samplename", "");
				dbBox.put("directyn", "N");
				if( i<check4 ) {
					dbBox.put("sampledisplay", "Y");
				} else {
					dbBox.put("sampledisplay", "N");
				}
				
				dataList.add(dbBox);
			}
		}
		
		mav.addObject("detail", requestBox);
		mav.addObject("dataList", dataList);
		mav.addObject("surveyTypeList", LmsCode.getSurveyTypeList());
		
		return mav;
	}
	
	@RequestMapping(value = "/lmsSurveyWriteExcelDown.do")
	public String lmsSurveyWriteExcelDown(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		
		/**
		 * excel 출력을 위해 저장 되지 않은 엑시드 그리드의 데이터를 , 형태로 넘겨 받는다.
		 */
		String[] surveyseqArr = requestBox.getString("surveyseqArr").split("[,]");
		String[] surveynameArr = requestBox.getString("surveynameArr").split("[,]");
		String[] surveytypenameArr = requestBox.getString("surveytypenameArr").split("[,]");
		//엑셀 다운 형태의 list로 데이터 변경하기
		List<Map<String, String>> dataList = new ArrayList<Map<String, String>>();  
		for( int i=0; i<surveyseqArr.length; i++ ) {
			Map<String, String> retMap = new HashMap<String, String>();
			retMap.put("SURVEYSEQ", surveyseqArr[i]);
			retMap.put("SURVEYNAME", surveynameArr[i].replace("WNBC", ",").replace("WNB", ""));
			retMap.put("SURVEYTYPENAME", surveytypenameArr[i].replace("WNBC", ",").replace("WNB", ""));
			
			dataList.add(retMap);
		}
		
		// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "설문문항목록";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","설문문항명","설문유형"};
		String[] headId = {"SURVEYSEQ","SURVEYNAME","SURVEYTYPENAME"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
	
	@RequestMapping(value="/lmsSurveySaveAjax.do")
	public ModelAndView lmsSurveySaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		mav.setView(new JSONView());
		
		//관리자 아이디 입력하기
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
		String inputtype =  requestBox.get("inputtype");
		Vector<Object> surveyseqArr = requestBox.getVector("surveyseqArr");
		Vector<Object> surveynameArr = requestBox.getVector("surveynameArr");
		Vector<Object> surveytypeArr = requestBox.getVector("surveytypeArr");
		Vector<Object> samplecountArr = requestBox.getVector("samplecountArr");
		
		Vector<Object> directyn1Arr = requestBox.getVector("directyn_1Arr");
		Vector<Object> samplename1Arr = requestBox.getVector("samplename_1Arr");
		Vector<Object> samplevalue1Arr = requestBox.getVector("samplevalue_1Arr");
		Vector<Object> directyn2Arr = requestBox.getVector("directyn_2Arr");
		Vector<Object> samplename2Arr = requestBox.getVector("samplename_2Arr");
		Vector<Object> samplevalue2Arr = requestBox.getVector("samplevalue_2Arr");
		Vector<Object> directyn3Arr = requestBox.getVector("directyn_3Arr");
		Vector<Object> samplename3Arr = requestBox.getVector("samplename_3Arr");
		Vector<Object> samplevalue3Arr = requestBox.getVector("samplevalue_3Arr");
		Vector<Object> directyn4Arr = requestBox.getVector("directyn_4Arr");
		Vector<Object> samplename4Arr = requestBox.getVector("samplename_4Arr");
		Vector<Object> samplevalue4Arr = requestBox.getVector("samplevalue_4Arr");
		Vector<Object> directyn5Arr = requestBox.getVector("directyn_5Arr");
		Vector<Object> samplename5Arr = requestBox.getVector("samplename_5Arr");
		Vector<Object> samplevalue5Arr = requestBox.getVector("samplevalue_5Arr");
		Vector<Object> directyn6Arr = requestBox.getVector("directyn_6Arr");
		Vector<Object> samplename6Arr = requestBox.getVector("samplename_6Arr");
		Vector<Object> samplevalue6Arr = requestBox.getVector("samplevalue_6Arr");
		Vector<Object> directyn7Arr = requestBox.getVector("directyn_7Arr");
		Vector<Object> samplename7Arr = requestBox.getVector("samplename_7Arr");
		Vector<Object> samplevalue7Arr = requestBox.getVector("samplevalue_7Arr");
		Vector<Object> directyn8Arr = requestBox.getVector("directyn_8Arr");
		Vector<Object> samplename8Arr = requestBox.getVector("samplename_8Arr");
		Vector<Object> samplevalue8Arr = requestBox.getVector("samplevalue_8Arr");
		Vector<Object> directyn9Arr = requestBox.getVector("directyn_9Arr");
		Vector<Object> samplename9Arr = requestBox.getVector("samplename_9Arr");
		Vector<Object> samplevalue9Arr = requestBox.getVector("samplevalue_9Arr");
		Vector<Object> directyn10Arr = requestBox.getVector("directyn_10Arr");
		Vector<Object> samplename10Arr = requestBox.getVector("samplename_10Arr");
		Vector<Object> samplevalue10Arr = requestBox.getVector("samplevalue_10Arr");
		
		//데이터 입력하는 형태로 재 조함하기
		List<Map<String,Object>> surveyList = new ArrayList<Map<String,Object>>();
		for(int i=0; i<surveyseqArr.size(); i++ ) {
			Map<String,Object> retMap = new HashMap<String,Object>();
			
			retMap.put("surveyseq", (i+1)+"");
			retMap.put("surveyname", surveynameArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
			retMap.put("surveytype", surveytypeArr.get(i).toString());
			retMap.put("samplecount", samplecountArr.get(i).toString());

			List<Map<String,String>> sampleList = new ArrayList<Map<String,String>>();
			String str1 = "1";
			String str2 = "2";
			if(str1.equals(surveytypeArr.get(i).toString()) || str2.equals(surveytypeArr.get(i).toString())) {
				int samplecount = Integer.parseInt(samplecountArr.get(i).toString());
				
				for( int k=1; k<=samplecount; k++ ) {
					Map<String,String> retMap2 = new HashMap<String,String>();
					
					retMap2.put("sampleseq", k+"");
					
					String tempdirectyn = "";
					String tempsamplename = "";
					String tempsamplevalue = "";
					switch( k ) {
						case 1 :
							tempdirectyn = directyn1Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplename = samplename1Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplevalue = samplevalue1Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "0");
							break;
						case 2 :
							tempdirectyn = directyn2Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplename = samplename2Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplevalue = samplevalue2Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "0");
							break;
						case 3 :
							tempdirectyn = directyn3Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplename = samplename3Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplevalue = samplevalue3Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "0");
							break;
						case 4 :
							tempdirectyn = directyn4Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplename = samplename4Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplevalue = samplevalue4Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "0");
							break;
						case 5 :
							tempdirectyn = directyn5Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplename = samplename5Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplevalue = samplevalue5Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "0");
							break;
						case 6 :
							tempdirectyn = directyn6Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplename = samplename6Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplevalue = samplevalue6Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "0");
							break;
						case 7 :
							tempdirectyn = directyn7Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplename = samplename7Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplevalue = samplevalue7Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "0");
							break;
						case 8 :
							tempdirectyn = directyn8Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplename = samplename8Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplevalue = samplevalue8Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "0");
							break;
						case 9 :
							tempdirectyn = directyn9Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplename = samplename9Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplevalue = samplevalue9Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "0");
							break;
						case 10 :
							tempdirectyn = directyn10Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplename = samplename10Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "");
							tempsamplevalue = samplevalue10Arr.get(i).toString().replace("WNBC", ",").replace("WNB", "0");
							break;
						default:
							break;
					}
					
					retMap2.put("directyn", tempdirectyn);
					retMap2.put("samplename", tempsamplename);
					retMap2.put("samplevalue", tempsamplevalue);
					
					sampleList.add(retMap2);
				}
				
				retMap.put("sampleList", sampleList);
			} else {
				retMap.put("samplecount", "0");
			}
			
			surveyList.add(retMap);
		}
		
		int result = 0;
	
		if( inputtype.equals("I") ) {
			result = lmsSurveyService.insertLmsSurveyAjax(requestBox, surveyList);
		} else if( inputtype.equals("U") ) {
			result = lmsSurveyService.updateLmsSurveyAjax(requestBox, surveyList);
		}
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("result", result);
		
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
}