package amway.com.academy.manager.lms.test.web;

import java.io.File;
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

import com.jcraft.jsch.Logger;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.lms.common.LmsCode;
import amway.com.academy.manager.lms.common.LmsExcelUtil;
import amway.com.academy.manager.lms.common.web.LmsCommonController;
import amway.com.academy.manager.lms.log.service.LmsLogService;
import amway.com.academy.manager.lms.test.service.LmsTestPoolService;
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
 * @NAME :LmsTestPoolController.java
 * @DESC :문제은행 관리
 * @Author:김택겸
 * @DATE : 2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */

@Controller
@RequestMapping("/manager/lms/test")
public class LmsTestPoolController {
	
	@Autowired
	LmsTestPoolService lmsTestPoolService;
	
	@Autowired
	LmsLogService lmsLogService;

	@Autowired
	SessionUtil sessionUtil;
	
	/**
	 * 문제은행 화면으로 이동
	 * @param requestBox
	 * @param mav
	 * @return
	 */
	@RequestMapping(value="/lmsTestPool.do")
	public ModelAndView lmsTestPool(RequestBox requestBox, ModelAndView mav) {
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/test/lmsTestPool.do") );
		return mav;
	}
	
	/**
	 * 문제은행 목록을 보여준다.
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/lmsTestPoolAjax.do")
	public ModelAndView lmsTestPoolAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox.put("sortIndex", 0);
		
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(lmsTestPoolService.selectCategoryTestCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/

    	// 리스트
		rtnMap.put("dataList",  lmsTestPoolService.selectCategoryTestList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	@RequestMapping(value="/lmsTestPoolExcelDownload.do")
	public String lmsTestPoolExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		 
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "문제은행분류";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","문제분류명","문제수"};
		String[] headId = {"NO","CATEGORYNAME","TESTPOOLCOUNT"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String>> dataList = lmsTestPoolService.selectCategoryTestExcelList(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExportCountReverse(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/lmsTestPoolPop.do")
	public ModelAndView lmsTestPoolPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		String inputtype = requestBox.get("inputtype");
		String blankStr = "";
		if( inputtype.equals("U") ) { //update
			if(!blankStr.equals(requestBox.get("categoryid"))){
				rtnMap = lmsTestPoolService.selectCategoryTestDetail(requestBox);
			}
		}
		rtnMap.put("inputtype", inputtype);
		
		mav.addObject("detail", rtnMap);
		
		return mav;
	}
	
	@RequestMapping(value="/lmsTestPoolDeleteAjax.do")
	public ModelAndView lmsTestPoolDeleteAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*삭제파람 체크 시작*/
		requestBox.put("categoryids", requestBox.getVector("categoryid"));
		/*삭제파람 체크 끝*/
		
    	// 삭제처리
		int cnt = lmsTestPoolService.deleteCategoryTest(requestBox);
		rtnMap.put("cnt", cnt);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	@RequestMapping(value="/lmsTestPoolSaveAjax.do")
	public ModelAndView lmsTestPoolSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		mav.setView(new JSONView());
		
		//관리자 아이디 입력하기
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
		int result = 0;
		String inputtype =  requestBox.get("inputtype");
		if( inputtype.equals("I") ) {
			
			//get max id
			int maxCategoryId = lmsTestPoolService.selectMaxCategoryTestId(requestBox);
			requestBox.put("categoryid", maxCategoryId);
			
			result = lmsTestPoolService.insertCategoryTestAjax(requestBox);
			
		} else if( inputtype.equals("U") ) {
			result = lmsTestPoolService.updateCategoryTestAjax(requestBox);
			
		}
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("result", result);
		
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	@RequestMapping(value="/lmsTestPoolList.do")
	public ModelAndView lmsTestPoolList(RequestBox requestBox, ModelAndView mav) {
		//화면으로 그대로 보내줌
		
		mav.addObject("answerTypeList", LmsCode.getAnswerTypeList() );
		mav.addObject("useList", LmsCode.getUseList() );
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/test/lmsTestPool.do") );
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/lmsTestPoolListAjax.do")
	public ModelAndView lmsTestPoolListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		String sortKey = requestBox.get("sortKey");
		if("testpoolname".equals(sortKey)){
			requestBox.put("sortIndex", 1);
		}else{
			requestBox.put("sortIndex", 0);
		}
		
		//카테고리 정보 읽어오기
		Map<String, Object> rtnMap2 = lmsTestPoolService.selectCategoryTestDetail(requestBox);
		rtnMap.put("categoryname",  rtnMap2.get("categoryname"));
		
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(lmsTestPoolService.selectTestPoolCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/

    	// 리스트
		rtnMap.put("dataList",  lmsTestPoolService.selectTestPoolList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	@RequestMapping(value="/lmsTestPoolListExcelDownload.do")
	public String lmsTestPoolListExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		 
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "문제은행";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","문제명","문제유형","상태"};
		String[] headId = {"NO","TESTPOOLNAME","ANSWERTYPENAME","USEFLAGNAME"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String>> dataList = lmsTestPoolService.selectTestPoolExcelList(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExportCountReverse(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/lmsTestPoolListPop.do")
	public ModelAndView lmsTestPoolListPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		List<DataBox> dataList = null;
		String blankStr = "";
		int check4 = 4;
		String inputtype = requestBox.get("inputtype");
		if( inputtype.equals("U") ) { //update
			if(!blankStr.equals(requestBox.get("testpoolid"))){
				rtnMap = lmsTestPoolService.selectTestPoolDetail(requestBox);
				List<DataBox> dataList2 = lmsTestPoolService.selectTestPoolAnswerList(requestBox);
				
				String answertype = rtnMap.get("answertype").toString();

				if( "3".equals(answertype) ) {
					//주관식인 경우 
					rtnMap.put("answercount", "4");
					dataList = new ArrayList<DataBox>();
					for( int i=0; i<10; i++ ) {
						DataBox dbBox = new DataBox();
						dbBox.put("testpoolanswerseq", (i+1) + "");
						dbBox.put("testpoolanswername", "");
						dbBox.put("answercheck", "N"); //정답 Y
						if( i<check4 ) {
							dbBox.put("testpoolanswerdisplay", "Y");
						} else {
							dbBox.put("testpoolanswerdisplay", "N");
						}
						
						dataList.add(dbBox);
					}
				} else {
					//객관식인 경우
					dataList = new ArrayList<DataBox>();
					
					//입력한 답변 세팅
					int answercount = Integer.parseInt(rtnMap.get("answercount").toString());
					String[] objectanswerArr = rtnMap.get("objectanswer").toString().split("[,]");

					for( int i=0; i<answercount; i++ ) {
						//일거온 값 세팅하기
						DataBox dbBox = dataList2.get(i);
						
						dbBox.put("testpoolanswerseq", (i+1) + "");
						dbBox.put("testpoolanswername", dbBox.get("testpoolanswername"));
						dbBox.put("answercheck", "N"); //정답 Y
						//정답과 일치하는 답변은 정담 체크함
						for( int k=0; k<objectanswerArr.length; k++) {
							if( ((i+1)+"").equals(objectanswerArr[k]) ) {
								dbBox.put("answercheck", "Y"); //정답 Y
							}
						}
						dbBox.put("testpoolanswerdisplay", "Y");
						
						dataList.add(dbBox);
					}

					//10개 이하 세팅
					for( int i=answercount; i<10; i++ ) {
						DataBox dbBox = new DataBox();
						dbBox.put("testpoolanswerseq", (i+1) + "");
						dbBox.put("testpoolanswername", "");
						dbBox.put("answercheck", "N"); //정답 Y
						dbBox.put("testpoolanswerdisplay", "N");
						
						dataList.add(dbBox);
					}
				}
			}
		} else {
			rtnMap.put("categoryid", requestBox.get("categoryid"));
			rtnMap.put("answertype", "1");
			rtnMap.put("answercount", "4");
			
			//기본 문제 답변 세팅
			dataList = new ArrayList<DataBox>();
			for( int i=0; i<10; i++ ) {
				DataBox dbBox = new DataBox();
				dbBox.put("testpoolanswerseq", (i+1) + "");
				dbBox.put("testpoolanswername", "");
				if( i<check4 ) {
					dbBox.put("testpoolanswerdisplay", "Y");
				} else {
					dbBox.put("testpoolanswerdisplay", "N");
				}
				
				dataList.add(dbBox);
			}
		}
		rtnMap.put("inputtype", inputtype);
		
		mav.addObject("detail", rtnMap);
		mav.addObject("dataList", dataList);
		
		mav.addObject("answerTypeList", LmsCode.getAnswerTypeList() );
		mav.addObject("useList", LmsCode.getUseList() );
		
		return mav;
	}
	
	
	@RequestMapping(value = "/lmsTestPoolListSaveAjax.do")
    public ModelAndView lmsTestPoolListSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//관리자 아이디 입력하기
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
    	// 저장처리
		int cnt = 0;
		
		String inputtype = requestBox.get("inputtype");
		if("I".equals(inputtype)){
			cnt = lmsTestPoolService.insertTestPoolAjax(requestBox);
		}else{
			cnt = lmsTestPoolService.updateTestPoolAjax(requestBox);
		}
		rtnMap.put("cnt", cnt);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
    }
	
	@RequestMapping(value="/lmsTestPoolListDeleteAjax.do")
	public ModelAndView lmsTestPoolListDeleteAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*삭제파람 체크 시작*/
		requestBox.put("testpoolids", requestBox.getVector("testpoolid"));
		/*삭제파람 체크 끝*/
		
    	// 삭제처리
		int cnt = lmsTestPoolService.deleteTestPool(requestBox);
		rtnMap.put("cnt", cnt);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	@RequestMapping(value="/lmsTestPoolExcelPop.do")
	public ModelAndView lmsTestPoolExcelPop(RequestBox requestBox, ModelAndView mav) {
		//화면으로 그대로 보내줌
		mav.addObject("categoryid", requestBox.get("categoryid"));
		
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/lmsTestPoolPopupExcelSaveAjax.do")
	public ModelAndView lmsTestPoolPopupExcelSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//1. 엑셀파일 데이터 읽기
		String testpoolexcelfile = requestBox.get("testpoolexcelfile");
		
		//ROOT_UPLOAD_DIR
		String filepath = LmsCommonController.ROOT_UPLOAD_DIR + File.separator + "excel" + File.separator + testpoolexcelfile;
		final int total_col_count = 15; //전체 컬럼 갯수
		int startIndexRow = 1; //헤더제외
		String colChk = "Y,Y,Y,Y,N,N,N,N,N,N,N,N,N,N,N"; //필수값 체크 Y.필수 N선택
		String colTypeChk = "I,S,S,S,S,S,S,S,S,S,S,S,S,S,S"; //I.숫자 S.문자
		
		Map<String,Object> retMap = LmsExcelUtil.readExcelFile(filepath, total_col_count, 0, startIndexRow, colChk, colTypeChk) ;
		
		String retStatus = retMap.get("status").toString();
		List<Map<String,String>> retFailList = (List<Map<String,String>>)retMap.get("failList");
		List<Map<String,String>> retSuccessList = (List<Map<String,String>>)retMap.get("successList");
		
		//실패 데이터 확인
		String failStr = "";
		String blankStr = "";
		String str1 = "1";
		String str2 = "2";
		int check0 = 0;
		int check4 = 4;
		int check5 = 5;
		if( retFailList != null && retFailList.size() > check0 ) {
			for( int i=0; i<retFailList.size(); i++ ) {
				Map<String,String> retFailMap = retFailList.get(i);
				StringBuffer failStrBuffer = new StringBuffer(failStr);
				failStrBuffer.append( retFailMap.get("data") + "\r\n" );
				failStr = failStrBuffer.toString();
			}
		}
		
		//성공 데이터 확인
		//필요시 데이터 다시 한번 체크할 것 :--> 보기수와 보기갯수 체크
		int successCount = 0;
		if( retSuccessList != null && retSuccessList.size() > check0 ) {
			successCount = retSuccessList.size();
			
			for( int i=0; i<retSuccessList.size(); i++ ) {
				Map<String,String> retSuccessMap = retSuccessList.get(i);
				
				String testType = "";
				int sampleVal = 0;
				int sampleCount = 0;
				boolean isValid = true;
				String errorMsg = "";
				for( int k=0; k<total_col_count; k++ ) {
					
					if( k == 0 ) {
						//문제유형 체크
						testType = retSuccessMap.get("col"+k);
						if(!"1".equals(testType) && !"2".equals(testType) && !"3".equals(testType) ) {
							isValid = false;
							errorMsg = (i+2) + "행 " + (k+1) + "번째의 데이터가 잘못되었습니다.\r\n";
							break;
						}
					} else if( k == check4 ) {
						//객관식의 경우 보기수가 숫자가 아니면 에러 발생
						if(str1.equals(testType) || str2.equals(testType)) {
							if( LmsExcelUtil.fnCheckInteger(retSuccessMap.get("col"+k)) ) {
								sampleVal = Integer.parseInt(retSuccessMap.get("col"+k));
							} else {
								isValid = false;
								errorMsg = (i+2) + "행 " + (k+1) + "번째의 데이터가 잘못되었습니다.\r\n";
								break;
							}
						}
					} else if( k >= check5 ) {
						//보기갯수 확인
						if( !blankStr.equals(retSuccessMap.get("col"+k)) ) {
							sampleCount ++;
						}
					}
				} //end col
				
				if(isValid) {
					//객관식일 경우 보기수와 실제 보기 갯수 확인할 것
					if( str1.equals(testType) || str2.equals(testType) ) {
						if( sampleVal != sampleCount ) {
							retStatus = "F";
							isValid = false;
							Map<String,String> failMap = new HashMap<String,String>();
							failMap.put("row", (i+2)+"");
							failMap.put("data", (i+2)+"행의 보기수와 보기 갯수가 일치하지 않습니다.\r\n");
							retFailList.add(failMap);
							
							StringBuffer failStrBuffer = new StringBuffer(failStr);
							failStrBuffer.append( failMap.get("data") );
							failStr = failStrBuffer.toString();
							
							successCount --; 
						}
					}
					
					if(isValid) {
						StringBuffer failStrBuffer = new StringBuffer(failStr);
						failStr = failStrBuffer.toString();
					}
				} else {
					retStatus = "F";
					Map<String,String> failMap = new HashMap<String,String>();
					failMap.put("row", (i+2)+"");
					failMap.put("data", errorMsg);
					retFailList.add(failMap);
					
					StringBuffer failStrBuffer = new StringBuffer(failStr);
					failStrBuffer.append( failMap.get("data") );
					failStr = failStrBuffer.toString();
					
					successCount --; 
				}
			}
		}
				
		//데이터 읽기 성공 시
		rtnMap.put("result", retStatus);
		
		if( retStatus.equals("S") ) {
			//배열로 값을 넣는 중
			int cnt = lmsTestPoolService.insertTestPoolExcelAjax(requestBox, retSuccessList);
			if( cnt > 0 ) {
				//로그를 남기고 실패 결과 넘기기
				requestBox.put("logtype", "E");
				requestBox.put("worktype", "5");
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
			requestBox.put("worktype", "5");
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
	
	@RequestMapping(value="/lmsTestPoolSampleExcelDownload.do")
	public String lmsTestPoolSampleExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		 
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "문제엑셀등록샘플";
    	
		// 엑셀 헤더명 정의
		String[] headName = {"문제유형(선일형1 선다형2 주관식3)","문제명(관리용)","문제지문","정답","보기수","보기1","보기2","보기3","보기4","보기5","보기6","보기7","보기8","보기9","보기10"};
		String[] headId = {"ANSWERTYPE","TESTPOOLNAME","TESTPOOLNOTE","SAMPLECOUNT","TESTPOOLANSWER","SAMPLE1","SAMPLE2","SAMPLE3","SAMPLE4","SAMPLE5","SAMPLE6","SAMPLE7","SAMPLE8","SAMPLE9","SAMPLE10"};
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
}
