package amway.com.academy.manager.lms.course.web;

import java.io.File;
import java.util.ArrayList;
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

import amway.com.academy.manager.common.commoncode.service.ManageCodeService;
import amway.com.academy.manager.lms.common.LmsCode;
import amway.com.academy.manager.lms.common.LmsExcelUtil;
import amway.com.academy.manager.lms.common.service.LmsCommonService;
import amway.com.academy.manager.lms.common.web.LmsCommonController;
import amway.com.academy.manager.lms.course.service.LmsCourseService;
import amway.com.academy.manager.lms.log.service.LmsLogService;
import amway.com.academy.manager.lms.offlineMg.service.LmsOfflineMgService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.web.JSONView;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :LmsCourseController.java
 * @DESC :코스객체 관리
 * @Author:김택겸
 * @DATE : 2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */

@Controller
@RequestMapping("/manager/lms/course")
public class LmsCourseController {
	
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsCourseController.class);	
	
	@Autowired
	LmsCourseService lmsCourseService;
	
	@Autowired
	LmsLogService lmsLogService;
	
	@Autowired
	LmsOfflineMgService lmsOfflineMgService;

	@Autowired
	LmsCommonService lmsCommonService;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/**
	 * 테마 목록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsCourseThemeListAjax.do")
    public ModelAndView lmsOnlineListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

    	// 리스트
		rtnMap.put("dataList",  lmsCourseService.selectLmsThemeList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	@RequestMapping(value = "/lmsConditionListAjax.do")
    public ModelAndView lmsConditionListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String blankStr = "";
		int check0 = 0;
		if(!blankStr.equals(requestBox.get("courseid"))){
	    	// 리스트
			List<DataBox> dataList = lmsCourseService.selectLmsCourseConditionList(requestBox);
			if( dataList != null && dataList.size() > check0 ) {
				rtnMap.put("totalcount",  dataList.size());
				rtnMap.put("dataList",  dataList);
			} else {
				rtnMap.put("totalcount",  "0");
				rtnMap.put("dataList",  dataList);
			}
			
		} else {
			//기본값 세팅 : ABO 회원 이상으로 검색일자 없이 세팅할 것
			List<DataBox> dataList = new ArrayList<DataBox>();
			
			String[] arrConditiontype = {"1","2"};
			String[] arrConditiontypename = {"노출권한","이용권한"};
			for( int i=0;i<2; i++) {
				DataBox tempMap = new DataBox();
				
				tempMap.put("conditionseq", (i+1) + "");
				tempMap.put("no", (i+1) + "");
				tempMap.put("conditiontype", arrConditiontype[i]);
				tempMap.put("conditiontypename", arrConditiontypename[i]);
				tempMap.put("conditionname", "ABO회원");
				tempMap.put("edudate", "");
				
				//기본값 세팅 : ABO회원으로 세팅할 것
				tempMap.put("abotypecode", LmsCommonController.ABOTYPECODE_BAISC);
				tempMap.put("abotypeabove", LmsCommonController.ABOTYPECODE_BAISC_VALUE);
				tempMap.put("pincode", "");
				tempMap.put("pinabove", "");
				tempMap.put("pinunder", "");
				tempMap.put("bonuscode", "");
				tempMap.put("bonusunder", "");
				tempMap.put("bonusabove", "");
				tempMap.put("agecode", "");
				tempMap.put("ageunder", "");
				tempMap.put("ageabove", "");
				tempMap.put("loacode", "");
				tempMap.put("diacode", "");
				tempMap.put("customercode", "");
				tempMap.put("consecutivecode", "");
				tempMap.put("businessstatuscode", "");
				tempMap.put("targetcode", "");
				tempMap.put("targetmember", "");
				tempMap.put("startdate", "");
				tempMap.put("enddate", "");
				
				dataList.add(tempMap);
			}
			rtnMap.put("totalcount",  "2");
			
			rtnMap.put("dataList",  dataList);
		}

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	@RequestMapping(value = "/lmsCourseConditionPop.do")
	public ModelAndView lmsCourseConditionPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		String targetmember = requestBox.get("targetmember");
		if(!targetmember.isEmpty()){
			// 개인정보 로그
			manageCodeService.selectCurrentAdNoHistory(requestBox);
		}
		
		//대상자 코드 및 대상자 조건 테이블에서 데이터 읽어 오기
		
		//대상자 조건(from ~ to) : 핀레벨, 보너스레벨, 나이
		//1. 핀레벨 조건 설정 읽기
		requestBox.put("targetmasterseq", "PINCODE");
		mav.addObject("pincodeList", lmsCourseService.selectLmsTargetConditionList(requestBox));
		
		//2. 보너스레벨 조건 설정 읽기
		requestBox.put("targetmasterseq", "BONUSCODE");
		mav.addObject("bonuscodeList", lmsCourseService.selectLmsTargetConditionList(requestBox));

		//3. 나이 조건 설정 읽기
		requestBox.put("targetmasterseq", "AGECODE");
		mav.addObject("agecodeList", lmsCourseService.selectLmsTargetConditionList(requestBox));
		
		//대상자 코드 : 회원타입, LOA, 업다이아, 다운라인구매여부, 연속주문횟수, 비즈니스상태
		//1.회원 읽기
		requestBox.put("targetmasterseq", "ABOTYPE");
		mav.addObject("abotypeList", lmsCourseService.selectLmsTargetCodeList(requestBox));

		//2.LOA 읽기
		requestBox.put("targetmasterseq", "LOACODE");
		mav.addObject("loacodeList", lmsCourseService.selectLmsTargetCodeList(requestBox));

		//3.다운라인 구매여부 읽기
		requestBox.put("targetmasterseq", "CUSTOMERCODE");
		mav.addObject("customercodeList", lmsCourseService.selectLmsTargetCodeList(requestBox));
		
		//4.연속주문횟수 읽기
		requestBox.put("targetmasterseq", "CONSECUTIVECODE");
		mav.addObject("consecutivecodeList", lmsCourseService.selectLmsTargetCodeList(requestBox));

		//5.비즈니스상태 읽기
		requestBox.put("targetmasterseq", "BUSINESSSTATUSCODE");
		mav.addObject("businessstatuscodeList", lmsCourseService.selectLmsTargetCodeList(requestBox));
		
		//시간 코드 읽기
		mav.addObject("hourList", LmsCode.getHourList());
		mav.addObject("minuteList", LmsCode.getMinuteList());
		mav.addObject("minute2List", LmsCode.getMinute2List());
		mav.addObject("secondList", LmsCode.getSecondList());
		
		// 현재 시간 읽기
		mav.addObject("nowDate", lmsCommonService.selectYYYYMMDDHHMISS(requestBox));
		
		// 어제 시간 읽기
		mav.addObject("yesterDate", lmsCommonService.selectYYYYMMDDHHMISSMINUS(requestBox));
		
		return mav;
	}
	
	@RequestMapping(value = "/lmsCourseConditionDiaAjax.do")
    public ModelAndView lmsCourseConditionDiaAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		String loacode = requestBox.get("loacode");
		String blankStr = "";
		rtnMap.put("result",  "1");
		if(!blankStr.equals(loacode)){
			requestBox.put("targetmasterseq", "DIACODE");
			
			List<DataBox> dataList = lmsCourseService.selectLmsCourseConditionDiaList(requestBox);
			rtnMap.put("dataList",  dataList);
		}

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	@RequestMapping(value = "/lmsCourseConditionSampleExcelDownload.do")
	public String lmsCourseConditionSampleExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{

		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "대상자정보엑셀등록샘플";
    	
		// 엑셀 헤더명 정의
		String[] headName = {"ABO번호"};
		String[] headId = {"UID"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String>> dataList = new ArrayList<Map<String, String>>();
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/lmsCourseConditionExcelSaveAjax.do")	
	public ModelAndView lmsCourseConditionExcelSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		//엑셀 데이터를 읽어서 회원인지 아닌지 확인이 필요함
		//문제가 있는 데이터는 오류 로그에 담아서 출력해 줄 것
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//1. 엑셀파일 데이터 읽기
		String targetexcelfile = requestBox.get("targetexcelfile");
		
		//ROOT_UPLOAD_DIR
		String filepath = LmsCommonController.ROOT_UPLOAD_DIR + File.separator + "excel" + File.separator + targetexcelfile;
		int totalColCount = 1; //전체 컬럼 갯수
		int startIndexRow = 1; //헤더제외
		String colChk = "Y"; //필수값 체크 Y.필수 N선택
		String colTypeChk = "S"; //I.숫자 S.문자
		
		Map<String,Object> retMap = LmsExcelUtil.readExcelFile(filepath, totalColCount, 0, startIndexRow, colChk, colTypeChk) ;
		
		String retStatus = retMap.get("status").toString();
		List<Map<String,String>> retFailList = (List<Map<String,String>>)retMap.get("failList");
		List<Map<String,String>> retSuccessList = (List<Map<String,String>>)retMap.get("successList");
		
		//실패 데이터 확인
		String failStr = "";
		int check0 = 0;
		if( retFailList != null && retFailList.size() > check0 ) {
			for( int i=0; i<retFailList.size(); i++ ) {
				Map<String,String> retFailMap = retFailList.get(i);
				StringBuffer failStrBuffer = new StringBuffer(failStr);
				failStrBuffer.append(retFailMap.get("data") + "\r\n");
				failStr = failStrBuffer.toString();
				//failStr += retFailMap.get("data") + "\r\n"; // PMD때문에 버퍼로 변경함
			}
		}
		
		//성공 데이터 확인
		//필요시 데이터 다시 한번 체크할 것 :--> 회원인지 확인할 것
		int successCount = 0;
		String uids = "";
		if( retSuccessList != null && retSuccessList.size() > check0 ) {
			successCount = retSuccessList.size();
			
			for( int i=0; i<retSuccessList.size(); i++ ) {
				Map<String,String> retSuccessMap = retSuccessList.get(i);
				
				boolean isValid = true;
				String errorMsg = "";
				String uid = "";
				for( int k=0; k<totalColCount; k++ ) {
				
					if( k == 0 ) {
						//회원인지 확인
						uid = retSuccessMap.get("col"+k);
						requestBox.put("uid", uid);
						String isUid = lmsOfflineMgService.lmsOfflineMgAddApplicantCheck(requestBox);
						String yStr = "Y";
						if( !yStr.equals(isUid) ) {
							isValid = false;
							errorMsg = (i+2) + "행 " + (k+1) + "번째의 데이터의 회원번호가 잘못되었습니다.\r\n";
						}
					}
				} //end col
				
				if(isValid) {
					StringBuffer uidsBuffer = new StringBuffer(uids);
					uidsBuffer.append(uid + ",");
					uids = uidsBuffer.toString();
				} else {
					retStatus = "F";
					Map<String,String> failMap = new HashMap<String,String>();
					failMap.put("row", (i+2)+"");
					failMap.put("data", errorMsg);
					retFailList.add(failMap);
					
					StringBuffer failStrBuffer = new StringBuffer(failStr);
					failStrBuffer.append(failMap.get("data"));
					
					failStr = failStrBuffer.toString();
					
					successCount --; 
				}
			}
		}
				
		//데이터 읽기 성공 시
		rtnMap.put("result", retStatus);
		if( retStatus.equals("S") ) {
			String blankStr = "";
			if( !blankStr.equals(uids) ) {uids = uids.substring(0,uids.length()-1);}
			rtnMap.put("uids", uids);
			
			requestBox.put("logtype", "E");
			requestBox.put("worktype", "1");
			requestBox.put("successcount", successCount);
			requestBox.put("failcount", retFailList.size());
			requestBox.put("logcontent", successCount + "건의 데이터를 저장하였습니다.");
			requestBox.put("courseid", "");
			
			Map<String,String> logMap = lmsLogService.insertLogAjax(requestBox);
			if( logMap != null && !logMap.isEmpty() ) {
				rtnMap.put("logresult", logMap.get("result"));
				rtnMap.put("logid", logMap.get("logid"));
				rtnMap.put("successcount", logMap.get("successcount"));
				rtnMap.put("failcount", logMap.get("failcount"));
				rtnMap.put("logcontent", logMap.get("logcontent"));
			} else {
				rtnMap.put("logresult", "fail");
			}
			
		} else if( retStatus.equals("F") ) {
			//로그를 남기고 실패 결과 넘기기
			requestBox.put("logtype", "E");
			requestBox.put("worktype", "1");
			requestBox.put("successcount", successCount);
			requestBox.put("failcount", retFailList.size());
			requestBox.put("logcontent", failStr);
			requestBox.put("courseid", "");
			
			Map<String,String> logMap = lmsLogService.insertLogAjax(requestBox);
			if( logMap != null && !logMap.isEmpty() ) {
				rtnMap.put("logresult", logMap.get("result"));
				rtnMap.put("logid", logMap.get("logid"));
				rtnMap.put("successcount", logMap.get("successcount"));
				rtnMap.put("failcount", logMap.get("failcount"));
				rtnMap.put("logcontent", logMap.get("logcontent"));
			} else {
				rtnMap.put("logresult", "fail");
			}
			
		} else {
			rtnMap.put("result", "E");
		}
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
}