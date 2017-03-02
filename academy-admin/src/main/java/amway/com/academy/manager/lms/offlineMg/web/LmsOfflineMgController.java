package amway.com.academy.manager.lms.offlineMg.web;

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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.commoncode.service.ManageCodeService;
import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.lms.common.LmsCode;
import amway.com.academy.manager.lms.common.LmsExcelUtil;
import amway.com.academy.manager.lms.common.service.LmsCommonService;
import amway.com.academy.manager.lms.common.web.LmsCommonController;
import amway.com.academy.manager.lms.course.service.LmsCourseService;
import amway.com.academy.manager.lms.log.service.LmsLogService;
import amway.com.academy.manager.lms.offlineMg.service.LmsOfflineMgService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;


/**
 * @author kr620261
 * 작성일 : 20160811
 * 소스설명 : 오프라인 과정 운영 처리 컨트롤러
 */
@Controller
@RequestMapping("/manager/lms/manage/offline")
@SuppressWarnings("unchecked")
public class LmsOfflineMgController {
	
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsOfflineMgController.class);	
	
	@Autowired
	LmsOfflineMgService lmsOfflineMgService;
	
	@Autowired
	LmsCourseService lmsCourseService;
	
	@Autowired
	LmsCommonService lmsCommonService;
	
	@Autowired
	LmsLogService lmsLogService;
	
	@Autowired
	SessionUtil sessionUtil;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/**
	 * 오프라인Mg 관리 목록 빈화면
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOfflineMg.do")
	public ModelAndView lmsOffline(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		mav.addObject("apCodeList", lmsCommonService.selectLmsApCodeList(requestBox));
		mav.addObject("eduStatusList", lmsOfflineMgService.selectLmsEduStatusCodeList(requestBox));
		
		return mav;
    }	
	
	/**
	 * 오프라인Mg 목록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOfflineMgListAjax.do")
    public ModelAndView lmsOfflineMgListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsOfflineMgService.selectLmsOfflineMgCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
    	
    	
    	// 리스트
		rtnMap.put("dataList",  lmsOfflineMgService.selectLmsOfflineMgList(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
    /**
     * 오프라인Mg Excel  다운로드
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/lmsOfflineMgExcelDownload.do")
	public String lmsOfflineExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
    	// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "오프라인과정운영 목록";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","교육분류","오프라인테마","과정명","교육장소","교육기간","상태","신청","수료"};
		String[] headId = {"NO","CATEGORYTREENAME","THEMENAME","COURSENAME","APNAME","EDUDATE","EDUSTATUS","REQUESTCOUNT","FINISHCOUNT"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String> > dataList = lmsOfflineMgService.selectLmsOfflineMgListExcelDown(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExportCountReverse(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
    
    /**
     * //오프라인 Mg 상세 applicant 목록
     * @param requestBox
     * @param mav
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/lmsOfflineMgApplicantListAjax.do")
    public ModelAndView lmsOfflineMgApplicantListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
    	
    	
    	
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
		pageVO.setTotalCount(lmsOfflineMgService.selectLmsOfflineMgDetailApplicantCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
    	
    	// 리스트
		rtnMap.put("dataList",  lmsOfflineMgService.selectLmsOfflineMgApplicantListAjax(requestBox));
		
		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
    
    /**
     * 핀코드 리스트 조회
     * @param requestBox
     * @param mav
     * @return
     * @throws Exception
     */
	@RequestMapping(value="/lmsOfflineMgDetail.do")
    public ModelAndView lmsOfflineMgDetail(RequestBox requestBox, ModelAndView mav) throws Exception {
    	Map<String, Object> rtnMap = new HashMap<String, Object>();
    	String blankStr = "";
		if(!blankStr.equals(requestBox.get("courseid"))){
			rtnMap = lmsOfflineMgService.selectLmsOfflineDetail(requestBox);
			mav.addObject("detail", rtnMap);
			
		}
		
		 //핀코드 리스트 조회
		 mav.addObject("pincodelist", lmsOfflineMgService.selectLmsPinCodeList(requestBox));
		 mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/manage/offline/lmsOfflineMg.do") );
		 
		return mav;
    }
	/**
     * 핀코드 리스트 조회
     * @param requestBox
     * @param mav
     * @return
     * @throws Exception
     */
	@RequestMapping(value="/lmsOfflineMgDetailAjax.do")
    public ModelAndView lmsOfflineMgDetailAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
    	Map<String, Object> rtnMap = new HashMap<String, Object>();
    	String blankStr = "";
		if(!blankStr.equals(requestBox.get("courseid"))){
			rtnMap = lmsOfflineMgService.selectLmsOfflineDetail(requestBox);
			mav.addObject("detail", rtnMap);
			
		}
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	/**
	 * 신청자 삭제
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOfflineMgApplicantDeleteAjax.do")
    public ModelAndView lmsOfflineMgApplicantDeleteAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		/*삭제파람 체크 시작*/
		requestBox.put("uids", requestBox.getVector("uid"));
		requestBox.put("courseids", requestBox.getString("courseid"));
		/*삭제파람 체크 끝*/
		
    	// 삭제처리
		int cnt = lmsOfflineMgService.deleteLmsOfflineMgApplicant(requestBox);
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	//applicant 팝업 호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	 @RequestMapping(value="/applicant/lmsOfflineMgDetailApplicantPop.do")
	    public ModelAndView lmsOfflineMgDetailApplicantPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		 
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 String blankStr = "";
			if(!blankStr.equals(requestBox.get("courseid"))){
				rtnMap = lmsOfflineMgService.selectLmsOfflineDetail(requestBox);
				mav.addObject("detail", rtnMap);
				
			}
		 // 개인정보 로그
		 manageCodeService.selectCurrentAdNoHistory(requestBox);
		 mav.addObject("pincodelist", lmsOfflineMgService.selectLmsPinCodeList(requestBox));
		 return mav;
	 }
	
	 /**
	 //add applicant 목록 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/lmsOfflineMgDetailApplicantPopAjax.do")
	 public ModelAndView lmsOfflineMgDetailApplicantPopAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsOfflineMgService.selectLmsOfflineMgDetailApplicantPopCount(requestBox));
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		rtnMap.putAll(pageVO.toMapData());
		/*페이징 세팅 끝*/
		
		// 리스트
		rtnMap.put("dataList",  lmsOfflineMgService.selectLmsOfflineMgDetailApplicantPop(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("courseid", requestBox.get("courseid"));
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	 
	 /**
	 * 신청자 추가
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOfflineMgApplicantAddAjax.do")
    public ModelAndView lmsOfflineMgApplicantAddAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		rtnMap.putAll(lmsOfflineMgService.lmsOfflineMgApplicantAddAjax(requestBox));
	
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * sample excel down
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/lmsAddApplicantSampleExcelDownload.do")
	public String lmsTestPoolSampleExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		 
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "교육자신청샘플파일";
    	
		// 엑셀 헤더명 정의
		String[] headName = {"ABO번호","부사업자신청"};
		String[] headId = {"uid","togetherrequestflag"};
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
	
	/**
	 * sample addApplicant excel 
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/lmsOfflineMgAddApplicantExcelAjax.do")
	public ModelAndView lmsOfflineMgAddApplicantExcelAjax(RequestBox requestBox, ModelAndView mav) throws Exception{
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
		String togetherFlag = requestBox.get("togetherflag");
	
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//excel 파일 데이터 읽기
		String addapplicantexcelfile = requestBox.get("addapplicantexcelfile");

		//ROOT_UPLOAD_DIR
		String filepath = LmsCommonController.ROOT_UPLOAD_DIR + File.separator + "excel" + File.separator + addapplicantexcelfile;
		int totalColCount = 2; //전체 컬럼 갯수
		int startIndexRow = 1; //헤더제외
		String colChk = "Y,N"; //필수값 체크 Y.필수 N선택
		String colTypeChk = "S,S"; //I.숫자 S.문자
		
		Map<String,Object> retMap = LmsExcelUtil.readExcelFile(filepath, totalColCount, 0, startIndexRow, colChk, colTypeChk) ;
		
		//String retStatus = retMap.get("status").toString();
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
				//failStr += retFailMap.get("data") + "\r\n"; //버퍼로 바꿈
			}
		}
		
		//성공 데이터 확인
		//필요시 데이터 다시 한번 체크할 것 :--> 보기수와 보기갯수 체크
		int successCount = 0;
		//String successStr = "";
		boolean isValid = true;
		if( retSuccessList != null && retSuccessList.size() > check0 ) {
			successCount = retSuccessList.size();
			for( int i=0; i<retSuccessList.size(); i++ ) {
				//String errorMsg = "";
				
				Map<String,String> retSuccessMap = retSuccessList.get(i);
				requestBox.put("uid",retSuccessMap.get("col0"));
				requestBox.put("togetherrequestflag",retSuccessMap.get("col1"));
				
				
				String typeTest = requestBox.get("togetherrequestflag");
				//member테이블에 해당 uid가 있는지 Check하기
				String result = lmsOfflineMgService.lmsOfflineMgAddApplicantCheck(requestBox);
				
				if(togetherFlag.equals("Y"))
				{
					if(result.equals("N"))
					{	
						isValid = false;
						StringBuffer failStrBuffer = new StringBuffer(failStr);
						failStrBuffer.append((i+2)+"행의 ABO넘버가 멤버테이블에 존재하지 않습니다\r\n");
						failStr = failStrBuffer.toString();
						successCount--;
					}
					else if(result.equals("Y"))
					{
						if(typeTest.equals("Y") || typeTest.equals("N"))
						{
							StringBuffer failStrBuffer = new StringBuffer(failStr);
							failStr = failStrBuffer.toString();
						}
						else
						{	
								if(typeTest.equals(""))
								{	
									isValid = false;
									StringBuffer failStrBuffer = new StringBuffer(failStr);
									failStrBuffer.append((i+2)+"행의 부사업자신청 기호가 입력되지않았습니다.\r\n");
									failStr = failStrBuffer.toString();
									successCount--;
								}
								else
								{
									isValid = false;
									StringBuffer failStrBuffer = new StringBuffer(failStr);
									failStrBuffer.append((i+2)+"행의 부사업자 신청 기호가 잘못되었습니다.\r\n");
									failStr = failStrBuffer.toString();
									successCount--;
									
								}
						}
						
					}
				}
				else if(togetherFlag.equals("N"))
				{
					if(result.equals("N"))
					{	
						isValid = false;
						StringBuffer failStrBuffer = new StringBuffer(failStr);
						failStrBuffer.append((i+2)+"행의 ABO넘버가 멤버테이블에 존재하지 않습니다\r\n");
						failStr = failStrBuffer.toString();
						successCount--;
					}
					else if(result.equals("Y"))
					{
						// 부사업자 신청 불허일 경우 Y,N 넣어도 무조건 N로 넣어줌, 공백도 N으로 세팅함
						Map<String,String> tempMap = new HashMap<String,String>();
						tempMap.put("col0", requestBox.get("uid"));
						tempMap.put("col1", "N");
						
						retSuccessList.set(i, tempMap);
						
						/*
						if(typeTest.equals(""))
						{	
							StringBuffer failStrBuffer = new StringBuffer(failStr);
							failStr = failStrBuffer.toString();
						}
						else
						{	
							isValid = false;
							StringBuffer failStrBuffer = new StringBuffer(failStr);
							failStrBuffer.append((i+2)+"행의 부사업자신청 기호가 입력되어있습니다.\r\n");
							failStr = failStrBuffer.toString();
							successCount--;
						}
						*/
					}
				}
			}
		}
		
		if(isValid)
		{
			lmsOfflineMgService.lmsOfflineMgAddApplicantExcelAjax(requestBox,retSuccessList);
		}
		///로그등록
		
		requestBox.put("logtype", "E");
		requestBox.put("worktype", "2");
		requestBox.put("successcount", successCount);
		requestBox.put("failcount", retSuccessList.size()-successCount+retFailList.size());
		requestBox.put("logcontent", failStr+successCount+"건 성공했습니다. \r\n");
		
		Map<String,String> logMap =  lmsLogService.insertLogAjax(requestBox);
		if( logMap != null && !logMap.isEmpty() ) {
			rtnMap.put("logresult", logMap.get("result"));
			rtnMap.put("logid", logMap.get("logid"));
			rtnMap.put("successcount", logMap.get("successcount"));
			rtnMap.put("failcount", logMap.get("failcount"));
			rtnMap.put("logcontent", logMap.get("logcontent"));
		}
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	/**
	 * 좌석등록 탭 init 페이지 호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/seatRegister/lmsOfflineMgDetailSeatRegister.do")
	public ModelAndView lmsOfflineMgDetailSeatRegister(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		mav.addObject("courseid", requestBox.get("courseid"));
		mav.setViewName("/manager/lms/manage/offline/seatRegister/lmsOfflineMgDetailSeatRegister");
		return mav;
    }
	
	/**
	 * 좌석등록 탭 목록 호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOfflineMgDetailSeatRegisterAjax.do")
	public ModelAndView lmsOfflineMgDetailSeatRegisterAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int totalCount = lmsOfflineMgService.selectLmsOfflineMgDetailSeatCount(requestBox);
		
    	/*페이징 세팅 끝*/
    	
    	
    	//조회 목록
    	List<DataBox> initDataList = lmsOfflineMgService.selectLmsOfflineMgDetailSeat(requestBox);
    	
    	
    	//조회 목록을 3배수씩 재조립
    	@SuppressWarnings("rawtypes")
		List<Map> dataList = new ArrayList<Map>();
    	
    	int idx = 1;
    	int count = 1;
    	Map<String, Object> dataMap = new HashMap<String, Object>();
    	for(int i=0; i<initDataList.size();i++)
    	{
    		idx = (i+1) % 3;
    		
    		if(idx != 0)
    		{
    			count = idx;
    		}
    		else
    		{
    			count =3;
    		}
    		
    		dataMap.put("no"+count, initDataList.get(i).getString("no"));
    		dataMap.put("seatseq"+count, initDataList.get(i).getString("seatseq"));
    		dataMap.put("seatnumber"+count, initDataList.get(i).getString("seatnumber"));
    		dataMap.put("seattype"+count, initDataList.get(i).getString("seattype"));
    		dataMap.put("seatflag"+count, initDataList.get(i).getString("seatflag"));
    		
    		if( idx == 0 ) {
    			dataList.add(dataMap);
    			dataMap = new HashMap<String, Object>();
    		}
    	}
    	
    	//마지막남은 map 처리
    	if( idx != 0 ) {
    		for( int i=idx;i<3;i++) {
    			dataMap.put("no"+(i+1), "");
    			dataMap.put("seatseq"+(i+1), "");
	    		dataMap.put("seatnumber"+(i+1), "");
	    		dataMap.put("seattype"+(i+1), "");
	    		dataMap.put("seatflag"+(i+1), "");
	    		
    		}
    		dataList.add(dataMap);
    	}
    	
    	// 리스트
		rtnMap.put("dataList",  dataList);
		rtnMap.put("totalcount", totalCount);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 좌석 블록 해제
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsOfflineMgSeatUpdateAjax.do")
    public ModelAndView lmsOfflineMgSeatUpdateAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
    	// UPDATE 처리
		int cnt = lmsOfflineMgService.lmsOfflineMgSeatUpdate(requestBox);
		
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * SEAT sample excel down
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/lmsRegisterSeatSampleExcelDownload.do")
	public String lmsRegisterSeatSampleExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		 
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "좌석등록샘플파일";
    	
		// 엑셀 헤더명 정의
		String[] headName = {"좌석번호","VIP석여부"};
		String[] headId = {"seatnumber","seattype"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String>> dataList = new ArrayList<Map<String, String>>();
		Map<String, String> dataMap = new HashMap<String, String>();
		dataMap.put("seatnumber", "가1");
		dataMap.put("seattype", "N");
		dataList.add(dataMap);
		
		dataMap = new HashMap<String, String>();
		dataMap.put("seatnumber", "가2");
		dataMap.put("seattype", "N");
		dataList.add(dataMap);
		
		dataMap = new HashMap<String, String>();
		dataMap.put("seatnumber", "특1");
		dataMap.put("seattype", "Y");
		dataList.add(dataMap);
		
		dataMap = new HashMap<String, String>();
		dataMap.put("seatnumber", "특2");
		dataMap.put("seattype", "Y");
		dataList.add(dataMap);
		
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
	
	
	/**
	 * seat register excel 
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/lmsOfflineMgSeatRegisterExcelAjax.do")
	public ModelAndView lmsOfflineMgSeatRegisterExcelAjax(RequestBox requestBox, ModelAndView mav) throws Exception{
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//excel 파일 데이터 읽기
		String addapplicantexcelfile = requestBox.get("seatregisterexcelfile");

		//ROOT_UPLOAD_DIR
		String filepath = LmsCommonController.ROOT_UPLOAD_DIR + File.separator + "excel" + File.separator + addapplicantexcelfile;
		int totalColCount = 2; //전체 컬럼 갯수
		int startIndexRow = 1; //헤더제외
		String colChk = "Y,Y"; //필수값 체크 Y.필수 N선택
		String colTypeChk = "S,S"; //I.숫자 S.문자
		boolean isValid = true;
		
		Map<String,Object> retMap = LmsExcelUtil.readExcelFile(filepath, totalColCount, 0, startIndexRow, colChk, colTypeChk) ;
		
		List<Map<String,String>> retFailList = (List<Map<String,String>>)retMap.get("failList");
		List<Map<String,String>> retSuccessList = (List<Map<String,String>>)retMap.get("successList");
		
		
		//실패 데이터 확인
		String failStr = "";
		int check0 = 0;
		if( retFailList != null && retFailList.size() > check0 ) {
			isValid = false;
			for( int i=0; i<retFailList.size(); i++ ) {
				Map<String,String> retFailMap = retFailList.get(i);
				StringBuffer failStrBuffer = new StringBuffer(failStr);
				failStrBuffer.append(retFailMap.get("data") + "\r\n");
				failStr = failStrBuffer.toString();
			}
		}
		
		//LMSSEATSTUDENT테이블에 해당 과정 배정 되있는지 여부 확인( null 이면 없는 것)
		String result = lmsOfflineMgService.lmsOfflineMgSeatAssignCheck(requestBox);
		
		int successCount = retSuccessList.size();
		if(result == null)
		{	
			if( retSuccessList != null && retSuccessList.size() > check0 ) 
			{
				successCount = retSuccessList.size();
				for( int i=0; i<retSuccessList.size(); i++ ) 
				{
					
					Map<String,String> retSuccessMap = retSuccessList.get(i);
					requestBox.put("seattype",retSuccessMap.get("col0"));
					requestBox.put("seatnumber",retSuccessMap.get("col1"));
					
					String typeTest = requestBox.get("seatnumber");
					
					if(!typeTest.equals("Y") && !typeTest.equals("N"))
					{
						 // 좌석 타입이 없는 경우
						StringBuffer failStrBuffer = new StringBuffer(failStr);
						failStrBuffer.append((i+2)+"행의 VIP석 여부 기호가 잘못 입력되어있습니다.\r\n");
						failStr = failStrBuffer.toString();
						isValid = false;
						successCount--;
					}
				}
			}
		}
		else
		{
			isValid = false;
			StringBuffer failStrBuffer = new StringBuffer(failStr);
			failStrBuffer.append("해당 과정은 이미 1개 이상의 좌석이 배정되어있는 상태입니다.\r\n");
			failStrBuffer.append("따라서 좌석 재등록이 불가능합니다.\r\n");
			failStr = failStrBuffer.toString();
			successCount = 0;
		}
		
		if(isValid)
		{
			// 좌석 삭제하기
			lmsOfflineMgService.deleteLmsOfflineMgSeatExcelAjax(requestBox);
			// 좌석 인서트하기
			lmsOfflineMgService.lmsOfflineMgSeatRegisterExcelAjax(requestBox,retSuccessList);
		}
		///로그등록
		
		requestBox.put("logtype", "E");
		requestBox.put("worktype", "3");
		requestBox.put("successcount", successCount);
		requestBox.put("failcount", retSuccessList.size()-successCount+retFailList.size());
		requestBox.put("logcontent", failStr);
		
		Map<String,String> logMap =  lmsLogService.insertLogAjax(requestBox);
		if( logMap != null && !logMap.isEmpty() ) {
			rtnMap.put("logresult", logMap.get("result"));
			rtnMap.put("logid", logMap.get("logid"));
			rtnMap.put("successcount", logMap.get("successcount"));
			rtnMap.put("failcount", logMap.get("failcount"));
			rtnMap.put("logcontent", logMap.get("logcontent"));
		}
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	/**
	 * 출석처리 탭 init 페이지 호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/attend/lmsOfflineMgDetailAttendHandle.do")
	public ModelAndView lmsOfflineMgDetailAttend(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		 //핀코드 리스트 조회
		mav.addObject("pincodelist", lmsOfflineMgService.selectLmsPinCodeList(requestBox));
		
		//부사업자신청 허용 flag가져오기
		mav.addObject("togetherflag",lmsOfflineMgService.selectLmsOfflineMgTogetherFlag(requestBox));
		mav.addObject("courseid", requestBox.get("courseid"));
		mav.setViewName("/manager/lms/manage/offline/attend/lmsOfflineMgDetailAttendHandle");
		return mav;
    }
	
	/**
	 * Attend register Excel팝업 호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/attend/lmsOfflineMgDetailAttendExcelPop.do")
	public ModelAndView lmsOfflineMgDetailAttendExcelPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("courseid"))){
			rtnMap = lmsOfflineMgService.selectLmsOfflineDetail(requestBox);
			mav.addObject("detail", rtnMap);
			
		}
		
		return mav;
    }
	 
	 /**
	  * Attend Barcode 팝업 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/attend/lmsOfflineMgDetailAttendBarcodePop.do")
	public ModelAndView lmsOfflineMgDetailAttendBarcodePop(RequestBox requestBox, ModelAndView mav) throws Exception {
		 
		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("courseid"))){
			rtnMap = lmsOfflineMgService.selectLmsOfflineDetail(requestBox);
			mav.addObject("detail", rtnMap);
			 
		}
		 
		return mav;
	}
	 
	 /**
	 * 출석처리 탭 List 호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/attend/lmsOfflineMgAttendListAjax.do")
	public ModelAndView lmsOfflineMgAttendListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
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
		pageVO.setTotalCount(lmsOfflineMgService.selectLmsOfflineMgAttendListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
		
		
		//출석처리 탭 List 
    	rtnMap.put("dataList",  lmsOfflineMgService.selectLmsOfflineMgAttendListAjax(requestBox));
		
		
		mav.addObject("courseid", requestBox.get("courseid"));
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
    }
	
	/**
	 * 수료 UPDATE
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/attend/lmsOfflineMgAttendUpdateAjax.do")
    public ModelAndView lmsOfflineMgAttendUpdateAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		int cnt = lmsOfflineMgService.updateLmsOfflineMgAttendHandle(requestBox);
		
    	//UPDATE 처리
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * AttendRegister sample excel down
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/attend/lmsAttendResultSampleExcelDownload.do")
	public String lmsAttendResultSampleExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		 
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "출석결과등록샘플파일";
    	
		// 엑셀 헤더명 정의
		String[] headName = {"ABO번호"};
		String[] headId = {"uid"};
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
	
	/**
	 * seat register excel 
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/attend/lmsOfflineMgAttendRegisterExcelAjax.do")
	public ModelAndView lmsOfflineMgAttendRegisterExcelAjax(RequestBox requestBox, ModelAndView mav) throws Exception{
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		requestBox.put("attendflag", "M");
		requestBox.put("finishflag", "Y");
	
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//excel 파일 데이터 읽기
		String addapplicantexcelfile = requestBox.get("attendregisterexcelfile");

		//ROOT_UPLOAD_DIR
		String filepath = LmsCommonController.ROOT_UPLOAD_DIR + File.separator + "excel" + File.separator + addapplicantexcelfile;
		int totalColCount = 1; //전체 컬럼 갯수
		int startIndexRow = 1; //헤더제외
		String colChk = "Y"; //필수값 체크 Y.필수 N선택
		String colTypeChk = "S"; //I.숫자 S.문자
		boolean isValid = true;
		
		Map<String,Object> retMap = LmsExcelUtil.readExcelFile(filepath, totalColCount, 0, startIndexRow, colChk, colTypeChk) ;
		
		List<Map<String,String>> retFailList = (List<Map<String,String>>)retMap.get("failList");
		List<Map<String,String>> retSuccessList = (List<Map<String,String>>)retMap.get("successList");
		
		
		//실패 데이터 확인
		String failStr = "";
		int check0 = 0;
		if( retFailList != null && retFailList.size() > check0 ) {
			isValid = false;
			for( int i=0; i<retFailList.size(); i++ ) {
				Map<String,String> retFailMap = retFailList.get(i);
				StringBuffer failStrBuffer = new StringBuffer(failStr);
				failStrBuffer.append(retFailMap.get("data") + "\r\n");
				failStr = failStrBuffer.toString();
			}
		}
		
		
		int successCount = retSuccessList.size();
		if( retSuccessList != null && retSuccessList.size() > check0 ) 
		{
			successCount = retSuccessList.size();
			for( int i=0; i<retSuccessList.size(); i++ ) 
			{
				
				Map<String,String> retSuccessMap = retSuccessList.get(i);
				
				requestBox.put("uid",retSuccessMap.get("col0"));
				
				
				//수강생테이블에 해당 uid가 있는지 Check하기
				String result = lmsOfflineMgService.lmsOfflineMgAttendRegisterCheck(requestBox);
					
				if(result.equals("N"))
				{	
					isValid = false;
					StringBuffer failStrBuffer = new StringBuffer(failStr);
					failStrBuffer.append((i+2)+"행의 ABO넘버가 해당과정의 수강생이 아닙니다\r\n");
					failStr = failStrBuffer.toString();
					successCount--;
				}
				
			}
		}
		
		if(isValid)
		{	
			StringBuffer failStrBuffer = new StringBuffer(failStr);
			failStrBuffer.append("정상처리되었습니다.");
			failStr = failStrBuffer.toString();
			lmsOfflineMgService.insertLmsOfflineMgAttendHandle(requestBox,retSuccessList);
		}
		///로그등록
		
		requestBox.put("logtype", "E");
		requestBox.put("worktype", "2");
		requestBox.put("successcount", successCount);
		requestBox.put("failcount", retSuccessList.size()-successCount+retFailList.size());
		requestBox.put("logcontent", failStr);
		
		Map<String,String> logMap =  lmsLogService.insertLogAjax(requestBox);
		if( logMap != null && !logMap.isEmpty() ) {
			rtnMap.put("logresult", logMap.get("result"));
			rtnMap.put("logid", logMap.get("logid"));
			rtnMap.put("successcount", logMap.get("successcount"));
			rtnMap.put("failcount", logMap.get("failcount"));
			rtnMap.put("logcontent", logMap.get("logcontent"));
		}
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}

	/**
	 * 마감(페널티처리)하기
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/attend/lmsOfflineMgAttendFinishPenaltyAjax.do")
	@ResponseBody
	public ModelAndView lmsOfflineMgAttendFinishPenaltyAjax(ModelAndView mav,RequestBox requestBox) throws Exception
	{	
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//교육과정 마감 페널티처리하기
		String result = lmsOfflineMgService.lmsOfflineMgAttendFinishPenaltyAjax(requestBox);
		
		
		rtnMap.put("result", result);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	/**
	 * 페널티대상자 탭 init 페이지 호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/penalty/lmsOfflineMgDetailPenaltyList.do")
	public ModelAndView lmsOfflineMgDetailPenaltyList(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		 //핀코드 리스트 조회
		mav.addObject("pincodelist", lmsOfflineMgService.selectLmsPinCodeList(requestBox));
		
		mav.addObject("courseid", requestBox.get("courseid"));
		mav.setViewName("/manager/lms/manage/offline/penalty/lmsOfflineMgDetailPenaltyList");
		return mav;
    }
	
	 /**
	 * 페널티대상자 탭 List 호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/penalty/lmsOfflineMgDetailPenaltyListAjax.do")
	public ModelAndView lmsOfflineMgDetailPenaltyListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
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
		pageVO.setTotalCount(lmsOfflineMgService.selectLmsOfflineMgPenaltyListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
		
		
		//출석처리 탭 List 
    	rtnMap.put("dataList",  lmsOfflineMgService.selectLmsOfflineMgPenaltyListAjax(requestBox));
		
		
		mav.addObject("courseid", requestBox.get("courseid"));
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
    }
	
	/**
	 * 바코드 출석 처리하기
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/attend/lmsOfflineMgAttendBarcodeAjax.do")
	public ModelAndView lmsOfflineMgAttendBarcodeAjax(ModelAndView mav,RequestBox requestBox) throws Exception
	{	
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int step = 1;
		String placeFlag = "";
		String applicantCheck = "";
		String togetherCheck = "";
		//ABO번호 CHECK
		String uidCheck = lmsOfflineMgService.lmsOfflineMgAddApplicantCheck(requestBox);
		
		if(uidCheck.equals("Y"))
		{	
			//교육신청자인지 아닌지 확인하기
			applicantCheck = lmsOfflineMgService.lmsOfflineMgAttendRegisterCheck(requestBox);
		
			//동반신청과정이면서 동반신청인 경우 CHECK
			togetherCheck = lmsOfflineMgService.lmsOfflineMgAttendBarcodeTogetherCheck(requestBox);
		
			//교육신청자인 경우
			if(applicantCheck.equals("Y"))
			{
				//바코드 팝업 창  confirm구역에 보여줄 리스트 조회하기
				if(togetherCheck.equals("Y"))
				{	
					rtnMap.putAll(lmsOfflineMgService.lmsOfflineMgAttendBarcodeConfirmInfo(requestBox));
				}
				//동반자신청이 아닌 경우 출석 처리하고 좌석배정한뒤 회원정보 조회
				else if(togetherCheck.equals("N"))
				{
					rtnMap.putAll(lmsOfflineMgService.lmsOfflineMgAttendBarcodeMemberInfo(requestBox,step));
				}
			}
			//미신청자인 경우
			else if(applicantCheck.equals("N"))
			{
				//현장접수 가능 과정인지 조회
				placeFlag = lmsOfflineMgService.lmsOfflineMgAttendBarcodePlaceFlagCheck(requestBox);
				
				//수강신청하고 좌석 등록 하고 정보 가져오기
				if(placeFlag.equals("Y"))
				{
					rtnMap.putAll(lmsOfflineMgService.lmsOfflineMgAttendBarcodePlaceAsk(requestBox,step));
				}
				//alert용 회원정보 조회
				else if(placeFlag.equals("N"))
				{
					rtnMap.putAll(lmsOfflineMgService.lmsOfflineMgAttendBarcodeNoAppllicantInfo(requestBox));
				}
			}
		}
		else
		{
			rtnMap.put("comment", "해당 ABO번호는 존재 하지 않습니다");
		}
		
		rtnMap.put("uidCheck", uidCheck);
		rtnMap.put("placeFlag", placeFlag);
		rtnMap.put("applicantCheck", applicantCheck);
		rtnMap.put("togetherCheck", togetherCheck);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	/**
	 * 바코드 출석 처리하기(동반자신청과정이면서 동반신청인 경우)
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/attend/lmsOfflineMgAttendBarcodeMemberInfoConfirmAjax.do")
	public ModelAndView lmsOfflineMgAttendBarcodeMemberInfoConfirmAjax(ModelAndView mav,RequestBox requestBox) throws Exception
	{	
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int step = 2;
		
		rtnMap.putAll(lmsOfflineMgService.lmsOfflineMgAttendBarcodeMemberInfo(requestBox,step));
		
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	
	/**
	 * 바코드 출석 예외처리
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/attend/lmsOfflineMgAttendBarcodeExceptionAjax.do")
	public ModelAndView lmsOfflineMgAttendBarcodeExceptionAjax(ModelAndView mav,RequestBox requestBox) throws Exception
	{	
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int step = 3;
		
		//예외사항은 exceptionFlag 추가함
		requestBox.put("exceptionFlag", "Y");
		
		//ABO번호 CHECK
		String uidCheck = lmsOfflineMgService.lmsOfflineMgAddApplicantCheck(requestBox);
		String applicantCheck = "";
		
		if(uidCheck.equals("Y"))
		{	
			//교육신청자인지 아닌지 확인하기
			applicantCheck = lmsOfflineMgService.lmsOfflineMgAttendRegisterCheck(requestBox);
			
			//신청자인 경우
			if(applicantCheck.equals("Y"))
			{	
				//좌석배정한뒤 회원정보 조회
				rtnMap.putAll(lmsOfflineMgService.lmsOfflineMgAttendBarcodeMemberInfo(requestBox,step));
			}
			//미신청자인 경우
			else if(applicantCheck.equals("N"))
			{
				//수강신청하고 좌석 등록 하고 정보 가져오기
				rtnMap.putAll(lmsOfflineMgService.lmsOfflineMgAttendBarcodePlaceAsk(requestBox,step));
			}
			
		}
		else
		{
			rtnMap.put("comment", "해당 ABO번호는 존재 하지 않습니다");
		}
		
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
}