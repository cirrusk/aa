package amway.com.academy.manager.lms.dwTarget.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
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
import amway.com.academy.manager.lms.common.LmsExcelUtil;
import amway.com.academy.manager.lms.common.web.LmsCommonController;
import amway.com.academy.manager.lms.dwTarget.service.LmsDwTargetService;
import amway.com.academy.manager.lms.log.service.LmsLogService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :LmsDwTargetController.java
 * @DESC :추천조건 등록
 * @Author:김택겸
 * @DATE : 2016-09-09 최초작성
 *      -----------------------------------------------------------------------------
 */
@Controller
@RequestMapping("/manager/lms/course")
public class LmsDwTargetController {
	
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsDwTargetController.class);
	
	@Autowired
	LmsDwTargetService lmsDwTargetService;
	
	@Autowired
	LmsLogService lmsLogService;
	
	@Autowired
	SessionUtil sessionUtil;
	
	@SuppressWarnings("static-access")
	@RequestMapping(value="/lmsDwTarget.do")
	public ModelAndView lmsDwTarget(RequestBox requestBox, ModelAndView mav) {
		
		//현재년도 구하기
		Calendar cal = Calendar.getInstance();
		int year = cal.get ( cal.YEAR );
		
		mav.addObject("baseyear", "2016");
		mav.addObject("endyear", (year+1) + "");
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/course/lmsDwTarget.do") );
		return mav;
	}
	
	@RequestMapping(value="/lmsDwTargetAjax.do")
	public ModelAndView lmsDwTargetAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*페이징 세팅 시작*/
		// 정렬 셋팅
		requestBox.put("sortIndex", 1);
		
		PageVO pageVO = new PageVO(requestBox);
		
		pageVO.setTotalCount(lmsDwTargetService.selectLmsDwTargetCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());

    	// 리스트
		rtnMap.put("dataList", lmsDwTargetService.selectLmsDwTargetList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	
	@RequestMapping(value = "/lmsDwTargetPopSampleExcelDownload.do")
	public String lmsDwTargetPopSampleExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		
		requestBox.put("sortIndex", 1);
		
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "추천조건등록";
		// 엑셀 헤더명 정의
		String[] headName = {"ABO번호","전년 매출 성장율 대비 성장","전년 매출 성장율 대비 하락","전년 신규 성장율 대비 성장","전년 신규 성장율 대비 하락"};
		String[] headId = {"UID","BUSINESSSTATUSCODE1","BUSINESSSTATUSCODE2","BUSINESSSTATUSCODE3","BUSINESSSTATUSCODE4"};
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
	
	@SuppressWarnings("static-access")
	@RequestMapping(value = "/lmsDwTargetPop.do")
	public ModelAndView lmsDwTargetPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		//현재년도 구하기
		Calendar cal = Calendar.getInstance();
		int year = cal.get ( cal.YEAR );
		int month = cal.get ( cal.MONTH );
		
		mav.addObject("baseyear", "2016");
		mav.addObject("endyear", (year+1) + "");
		
		mav.addObject("thisyear", year +"");
		mav.addObject("thismonth", (month+1) +"");

		return mav;
	}
	
	@RequestMapping(value="/lmsDwTargetPopupExcelSaveAjax.do")
	public ModelAndView lmsDwTargetPopupExcelSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//1. 엑셀파일 데이터 읽기
		String dwtargetexcelfile = requestBox.get("dwtargetexcelfile");
		
		//ROOT_UPLOAD_DIR
		String filepath = LmsCommonController.ROOT_UPLOAD_DIR + File.separator + "excel" + File.separator + dwtargetexcelfile;
		int totalColCount = 5; //전체 컬럼 갯수
		int startIndexRow = 1; //헤더제외

		String colChk = "Y,Y,Y,Y,Y"; //필수값 체크 Y.필수 N선택
		String colTypeChk = "S,S,S,S,S"; //I.숫자 S.문자
		
		Map<String,Object> retMap = LmsExcelUtil.readExcelFile(filepath, totalColCount, 0, startIndexRow, colChk, colTypeChk) ;
		
		String retStatus = retMap.get("status").toString();
		@SuppressWarnings("unchecked")
		List<Map<String,String>> retFailList = (List<Map<String,String>>)retMap.get("failList");
		@SuppressWarnings("unchecked")
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
				// failStr += retFailMap.get("data") + "\r\n"; 버퍼로 변경
			}
		}
		
		//성공 데이터 확인
		//필요시 데이터 다시 한번 체크할 것 :--> 보기수와 보기갯수 체크
		int successCount = 0;
		String yStr = "Y";
		String nStr = "N";
		//String successStr = "";
		if( retSuccessList != null && retSuccessList.size() > check0 ) {
			successCount = retSuccessList.size();
			
			for( int i=0; i<retSuccessList.size(); i++ ) {
				Map<String,String> retSuccessMap = retSuccessList.get(i);
				
				String testType = "";
				boolean isValid = true;
				String errorMsg = "";
				for( int k=0; k<totalColCount; k++ ) {
					//successStr += retSuccessMap.get("col"+k) + " ";
					
					//성장단계 입력갑 Y 아니면 N
					testType = retSuccessMap.get("col"+k);
					if( k != 0  && !yStr.equals(testType) && !nStr.equals(testType)) {
						isValid = false;
						errorMsg = (i+2) + "행 " + (k+1) + "번째의 데이터가 잘못되었습니다.\r\n";
						break;
					}
				} //end col
				
				if(!isValid) {
					retStatus = "F";
					Map<String,String> failMap = new HashMap<String,String>();
					failMap.put("row", (i+2)+"");
					failMap.put("data", errorMsg);
					retFailList.add(failMap);
					
					StringBuffer failStrBuffer = new StringBuffer(failStr);
					failStrBuffer.append(failMap.get("data"));
					failStr = failStrBuffer.toString(); 
					//failStr += failMap.get("data"); 버퍼로 변경
					
					successCount --; 
				}
			}
		}
				
		//데이터 읽기 성공 시
		rtnMap.put("result", retStatus);
		
		if( retStatus.equals("S") ) {
			//배열로 값을 넣는 중
			int cnt = lmsDwTargetService.insertDwTargetExcelAjax(requestBox, retSuccessList);
			if( cnt > 0 ) {
				//로그를 남기고 실패 결과 넘기기
				requestBox.put("logtype", "E");
				requestBox.put("worktype", "A");
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
			} else {
				rtnMap.put("result", "E");
			}
		} else if( retStatus.equals("F") ) {
			//로그를 남기고 실패 결과 넘기기
			requestBox.put("logtype", "E");
			requestBox.put("worktype", "A");
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