package amway.com.academy.manager.lms.regularMg.web;


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
import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.lms.common.LmsCode;
import amway.com.academy.manager.lms.common.LmsExcelUtil;
import amway.com.academy.manager.lms.common.service.LmsCommonService;
import amway.com.academy.manager.lms.common.web.LmsCommonController;
import amway.com.academy.manager.lms.course.service.LmsCourseService;
import amway.com.academy.manager.lms.log.service.LmsLogService;
import amway.com.academy.manager.lms.offlineMg.service.LmsOfflineMgService;
import amway.com.academy.manager.lms.regularMg.service.LmsRegularMgService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;
/**
 * @author kr620261
 * 작성일 : 20160811
 * 소스설명 : 정규 과정 운영 처리 컨트롤러
 */
@Controller
@RequestMapping("/manager/lms/manage/regular")
public class LmsRegularMgController {
	
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsRegularMgController.class);	
	
	@Autowired
	LmsRegularMgService lmsRegularMgService;
	
	@Autowired
	LmsCourseService lmsCourseService;
	
	@Autowired
	LmsCommonService lmsCommonService;
	
	@Autowired
	LmsLogService lmsLogService;
	
	@Autowired
	LmsOfflineMgService lmsOfflineMgService;
	
	@Autowired
	SessionUtil sessionUtil;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/**
	 * 정규과정 관리 목록 빈화면
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegularMg.do")
	public ModelAndView lmsOffline(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		mav.addObject("eduStatusList", lmsRegularMgService.selectLmsEduStatusCodeList(requestBox));
		
		return mav;
    }	
	
	/**
	 * 정규과정 목록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsRegularMgListAjax.do")
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
		pageVO.setTotalCount(lmsRegularMgService.selectLmsRegularMgCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/

    	// 리스트
		rtnMap.put("dataList",  lmsRegularMgService.selectLmsRegularMgList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	 /**
     * 정규과정Mg Excel  다운로드
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/lmsRegularMgExcelDownload.do")
	public String lmsOfflineExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
    	
    	// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "정규과정운영 목록";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","교육분류","정규과정명","교육기간","상태","신청","수료"};
		String[] headId = {"NO","CATEGORYTREENAME","COURSENAME","EDUDATE","EDUSTATUS","REQUESTCOUNT","FINISHCOUNT"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String> > dataList = lmsRegularMgService.selectLmsRegularMgListExcelDown(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExportCountReverse(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
    
    /**
	 * 정규과정 상세 Info
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/lmsRegularMgDetail.do")
    public ModelAndView lmsRegularMgDetail(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

    	// 정규 과정 상세 Info
		rtnMap = lmsRegularMgService.lmsRegularMgDetail(requestBox);
		
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/manage/regular/lmsRegularMg.do") );
		mav.addObject("detail",rtnMap);

		return mav;
    }
	
    /**
	 * 정규과정 상세 Info 가져오기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/lmsRegularMgDetailAjax.do")
    public ModelAndView lmsRegularMgDetailAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

    	// 정규 과정 상세 Info
		rtnMap = lmsRegularMgService.lmsRegularMgDetail(requestBox);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
    }
	
	/**
	 *  교육현황 탭 불러오기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eduStatus/lmsRegularMgDetailEduStatus.do")
    public ModelAndView lmsRegularMgDetailEduStatus(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		mav.addObject("courseid", requestBox.get("courseid"));
		mav.setViewName("/manager/lms/manage/regular/eduStatus/lmsRegularMgDetailEduStatus");

		return mav;
    }
	
	/**
	 *  교육현황 탭 리스트 가져오기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eduStatus/lmsRegularMgDetailEduStatusListAjax.do")
	public ModelAndView lmsRegularMgDetailEduStatusListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("stepList",  lmsRegularMgService.lmsRegularMgDetailEduStatusListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
		
	/**
	 *  교육신청자 탭 페이지 불러오기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/applicant/lmsRegularMgDetailApplicant.do")
    public ModelAndView lmsRegularMgDetailApplicant(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		//핀코드 리스트 조회
		mav.addObject("pincodelist", lmsRegularMgService.selectLmsPinCodeList(requestBox));
		mav.addObject("courseid", requestBox.get("courseid"));
		mav.setViewName("/manager/lms/manage/regular/applicant/lmsRegularMgDetailApplicant");

		return mav;
    }
	
	/**
	 *  교육신청자 탭 리스트 가져오기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/applicant/lmsRegularMgApplicantListAjax.do")
	public ModelAndView lmsRegularMgApplicantListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsRegularMgService.lmsRegularMgApplicantListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
		
		
		rtnMap.put("applicantList",  lmsRegularMgService.lmsRegularMgApplicantListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
		
	/**
	 * 정규과정 신청자 삭제
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/applicant/lmsRegularMgApplicantDeleteAjax.do")
    public ModelAndView lmsRegularMgApplicantDeleteAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
    	// 삭제처리
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		int cnt = lmsRegularMgService.lmsRegularMgApplicantDeleteAjax(requestBox);
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
	 @RequestMapping(value="/applicant/lmsRegularMgDetailApplicantPop.do")
	    public ModelAndView lmsOfflineMgDetailApplicantPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		 
			// 개인정보 로그
			manageCodeService.selectCurrentAdNoHistory(requestBox);
		 
			Map<String, Object> rtnMap = new HashMap<String, Object>();
			String blankStr = "";
				if(!blankStr.equals(requestBox.get("courseid"))){
					//엑셀 업로드 탭 용 List조회
					rtnMap = lmsRegularMgService.selectLmsRegularMgApplicantPopDetail(requestBox);
					mav.addObject("detail", rtnMap);
					
				}
			//검색용 pincode조회
			mav.addObject("pincodelist", lmsRegularMgService.selectLmsPinCodeList(requestBox));
			//정규과정 내에 오프라인 과정이 있을 경우 apList가져오기
			mav.addObject("aplist",lmsRegularMgService.lmsRegularMgApplicantPopApList(requestBox));
			return mav;
	 }
		 
	 /**
	 //add applicant 목록 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/applicant/lmsRegularMgDetailApplicantPopAjax.do")
	 public ModelAndView lmsRegularMgDetailApplicantPopAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsRegularMgService.selectLmsRegularMgDetailApplicantPopCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
    	
    	// 리스트
		rtnMap.put("dataList",  lmsRegularMgService.selectLmsRegularMgDetailApplicantPop(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("courseid", requestBox.get("courseid"));
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
		 
 	/**
	 * 정규과정Mg 신청자 추가
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/applicant/lmsRegularMgApplicantAddAjax.do")
    public ModelAndView lmsRegularMgApplicantAddAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		rtnMap.putAll( lmsRegularMgService.lmsRegularMgApplicantAddAjax(requestBox));
		
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
	@RequestMapping(value="/applicant/lmsAddApplicantSampleExcelDownload.do")
	public String lmsTestPoolSampleExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		 
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "정규과정_교육신청자샘플파일";
    	
		// 엑셀 헤더명 정의
		String[] headName = {"ABO번호","부사업자신청","교육장소"};
		String[] headId = {"uid","togetherrequestflag","apseq"};
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
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/applicant/lmsRegularMgAddApplicantExcelAjax.do")
	public ModelAndView lmsRegularMgAddApplicantExcelAjax(RequestBox requestBox, ModelAndView mav) throws Exception{
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
		String togetherFlag = requestBox.get("togetherflag");
		
		//정규과정에 오프라인과정이 포함되어있는지 확인하는 변수
		String checkKey = requestBox.get("checkkey");
	
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//excel 파일 데이터 읽기
		String addapplicantexcelfile = requestBox.get("addapplicantexcelfile");

		//ROOT_UPLOAD_DIR
		String filepath = LmsCommonController.ROOT_UPLOAD_DIR + File.separator + "excel" + File.separator + addapplicantexcelfile;
		int totalColCount = 3; //전체 컬럼 갯수
		int startIndexRow = 1; //헤더제외
		String colChk = "Y,N,N"; //필수값 체크 Y.필수 N선택
		String colTypeChk = "S,S,S"; //I.숫자 S.문자
		
		Map<String,Object> retMap = LmsExcelUtil.readExcelFile(filepath, totalColCount, 0, startIndexRow, colChk, colTypeChk) ;
		
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
			}
		}
		
		//성공 데이터 확인
		//필요시 데이터 다시 한번 체크할 것 :--> 보기수와 보기갯수 체크
		int successCount = 0;
		boolean isValid = true;
		if( retSuccessList != null && retSuccessList.size() > check0 ) {
			successCount = retSuccessList.size();
			for( int i=0; i<retSuccessList.size(); i++ ) {
				
				Map<String,String> retSuccessMap = retSuccessList.get(i);
				requestBox.put("uid",retSuccessMap.get("col0"));
				requestBox.put("togetherrequestflag",retSuccessMap.get("col1"));
				requestBox.put("apseq",retSuccessMap.get("col2"));
					
				String typeTest = requestBox.get("togetherrequestflag");
				String apseqTest = requestBox.get("apseq");
				//member테이블에 해당 uid가 있는지 Check하기
				String result = lmsRegularMgService.lmsRegularMgAboNumberCheck(requestBox);
				
				//정규과정에 오프라인 과정이 포함되어있는 경우
				if(checkKey.equals("T"))
				{	

					if(result.equals("N"))
					{
						isValid = false;
						StringBuffer failStrBuffer = new StringBuffer(failStr);
						failStrBuffer.append((i+2)+"행의 ABO넘버가 멤버테이블에 존재하지 않습니다.\r\n");
						failStr = failStrBuffer.toString();
						successCount--;
					}
					//멤버에 UID존재함
					else if(result.equals("Y"))
					{
						// 부사업자 체크
						if("Y".equals(togetherFlag)){
							if(typeTest.equals(""))
							{	
								isValid = false;
								StringBuffer failStrBuffer = new StringBuffer(failStr);
								failStrBuffer.append((i+2)+"행의 부사업자신청 기호가 입력되지않았습니다.\r\n");
								failStr = failStrBuffer.toString();
								successCount--;
							}
							else if(!typeTest.equals("Y") && !typeTest.equals("N"))
							{
								isValid = false;
								StringBuffer failStrBuffer = new StringBuffer(failStr);
								failStrBuffer.append((i+2)+"행에 입력하신 부사업자 신청 기호가 잘못되었습니다.\r\n");
								failStr = failStrBuffer.toString();
								successCount--;
								
							}
						}else{
							
							//부사업자 불허일 경우 Y,N가 있으면 그냥 N로 세팅함
							Map<String,String> tempMap = new HashMap<String,String>();
							tempMap.put("col0", requestBox.get("uid"));
							tempMap.put("col1", "N");
							tempMap.put("col2", requestBox.get("apseq"));
							
							retSuccessList.set(i, tempMap);
							
							/*
							if(!typeTest.equals(""))
							{	
								isValid = false;
								StringBuffer failStrBuffer = new StringBuffer(failStr);
								failStrBuffer.append((i+2)+"행에 부사업자 신청 기호가 입력되어있습니다.\r\n");
								failStr = failStrBuffer.toString();
								successCount--;
							}
							*/
						}
						if(!isValid){continue;}
						
						if(apseqTest.equals(""))
						{
							isValid = false;
							StringBuffer failStrBuffer = new StringBuffer(failStr);
							failStrBuffer.append((i+2)+"행의 교육장소가 입력되지않았습니다.\r\n");
							failStr = failStrBuffer.toString();
							successCount--;
						}
						else
						{
							//교육장소 존재 여부 Check
							String checkApseq = lmsRegularMgService.lmsRegularMgAddApplicantCheckApseq(requestBox);
							//교육장소 존재
							if(checkApseq.equals("Y"))
							{
								StringBuffer failStrBuffer = new StringBuffer(failStr);
								failStr = failStrBuffer.toString();
							}
							else
							{
								isValid = false;
								StringBuffer failStrBuffer = new StringBuffer(failStr);
								failStrBuffer.append((i+2)+"행의 교육장소가 잘못입력 되어 있습니다.\r\n");
								failStr = failStrBuffer.toString();
								successCount--;
								
							}
						}
					}
				}
				//정규과정에 오프라인 과정이 포함되어 있지 않은 경우
				else if(checkKey.equals("F"))
				{
					if(result.equals("N"))
					{
						isValid = false;
						StringBuffer failStrBuffer = new StringBuffer(failStr);
						failStrBuffer.append((i+2)+"행의 ABO넘버가 멤버테이블에 존재하지 않습니다.\r\n");
						failStr = failStrBuffer.toString();
						successCount--;
					}
					//멤버에 UID존재함
					else if(result.equals("Y"))
					{
						if(apseqTest == null || apseqTest.equals("") )
						{
							StringBuffer failStrBuffer = new StringBuffer(failStr);
							failStr = failStrBuffer.toString();
						}
						else
						{
							isValid = false;
							StringBuffer failStrBuffer = new StringBuffer(failStr);
							failStrBuffer.append((i+2)+"행에 교육장소가 입력되어있습니다.\r\n");
							failStr = failStrBuffer.toString();
							successCount--;
						}
					}
				}//정규과정에 오프라인 과정이 포하뫼어 았지 않은 경우
			}////end for
		}////end if
		
		rtnMap.put("cnt", 0);
		rtnMap.put("comment", "");
		//EXCEL로 수강신청
		if(isValid)
		{
			rtnMap.putAll(lmsRegularMgService.lmsRegularMgAddApplicantExcelAjax(requestBox,retSuccessList));
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
	 *  교육신청자 탭 페이지 불러오기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/course/lmsRegularMgDetailCourse.do")
    public ModelAndView lmsRegularMgDetailCourse(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		mav.addObject("courseid", requestBox.get("courseid"));
		//단계명리스트 조회
		mav.addObject("stepNameList",lmsRegularMgService.lmsRegularMgDetailStepList(requestBox));
		
		mav.setViewName("/manager/lms/manage/regular/course/lmsRegularMgDetailCourse");
		
		
		return mav;
    }
	
	 /**
	 *  stepCourseId 가져오기 
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/course/lmsRegularMgDetailStepCourseList.do")
    public ModelAndView lmsRegularMgDetailStepCourseList(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		rtnMap.put("stepseq", requestBox.get("stepseq"));
		
		//하위과정 조회
		rtnMap.put("stepCourseList",lmsRegularMgService.lmsRegularMgDetailStepCourseList(requestBox));
		//검색용 pincodeList 조회
		rtnMap.put("pincodelist", lmsRegularMgService.selectLmsPinCodeList(requestBox));
		//단계정보 조회
		rtnMap.putAll(lmsRegularMgService.lmsRegularMgDetailStepInfo(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
		
	/**
	 *  change StepCourseId에 따른 init 페이지 불러오기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/course/lmsRegularMgChangeStepCourse.do")
	public ModelAndView lmsRegularMgChangeStepCourse(RequestBox requestBox, ModelAndView mav,HttpServletRequest request) throws Exception {
		
		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		//courseType 조회
		String courseType = lmsRegularMgService.lmsRegularMgChagedCourseType(requestBox);
		
		if(courseType.equals("F"))
		{	
			
			mav.addObject("stepseq",requestBox.get("stepseq"));
			mav.addObject("stepcourseid",requestBox.get("stepcourseid"));
			//오프라인 과정 정보 조회
			mav.addObject("offlineCourse", lmsRegularMgService.lmsRegularMgOfflineCourseInfo(requestBox));
			mav.setViewName("/manager/lms/manage/regular/course/lmsRegularMgDetailOfflineCourse");
		}
		else if(courseType.equals("O") || courseType.equals("L") || courseType.equals("D"))
		{	
			
			mav.addObject("coursetype",courseType);
			//검색용 pincodeList 조회
			 mav.addObject("pincodelist", lmsRegularMgService.selectLmsPinCodeList(requestBox));
			//과정 정보 조회
			mav.addObject("courseData", lmsRegularMgService.lmsRegularMgOnlineLiveDataInfo(requestBox));
			mav.addObject("stepseq",requestBox.get("stepseq"));
			mav.setViewName("/manager/lms/manage/regular/course/lmsRegularMgDetailOnlineLiveDataCourse");
		}
		else if(courseType.equals("T"))
		{	
			
			//검색용 pincodeList 조회
			mav.addObject("pincodelist", lmsRegularMgService.selectLmsPinCodeList(requestBox));
			//시험 정보 조회
			
			mav.addObject("stepseq",requestBox.get("stepseq"));
			//과정 정보 조회
			mav.addObject("courseData", lmsRegularMgService.lmsRegularMgTestCourseInfo(requestBox));
			mav.setViewName("/manager/lms/manage/regular/course/lmsRegularMgDetailTestCourse");
		}
		else if(courseType.equals("V"))
		{
			mav.addObject("stepseq",requestBox.get("stepseq"));
			mav.addObject("stepcourseid",requestBox.get("stepcourseid"));
			//설문 과정 정보 조회
			mav.addObject("courseData", lmsRegularMgService.lmsRegularMgServeyCourseInfo(requestBox));
			mav.setViewName("/manager/lms/manage/regular/course/lmsRegularMgDetailServeyCourse");
		}
		
		return mav;
	}
	
    /**
	 * 정규과정 구성과정 정보 Info 가져오기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/course/lmsRegularMgChangeStepCourseAjax.do")
    public ModelAndView lmsRegularMgChangeStepCourseAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

    	// 정규 과정 구성 과정 정보 Info
		rtnMap = lmsRegularMgService.lmsRegularMgOfflineCourseInfo(requestBox);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
    }
	
	
	 /**
	 //student 목록 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/course/lmsRegularMgOnlineLiveDataListAjax.do")
	 public ModelAndView lmsRegularMgOnlineLiveDataListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsRegularMgService.lmsRegularMgOnlineLiveDataStudentListAjaxCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
    	
    	// 교육과정 탭 Online Course Student리스트
		rtnMap.put("studentList",  lmsRegularMgService.lmsRegularMgOnlineLiveDataStudentListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
		 
	 /**
	 //step student 목록 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/course/lmsRegularMgDetailStepStudentListAjax.do")
    public ModelAndView lmsRegularMgDetailStepStudentListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsRegularMgService.lmsRegularMgDetailStepStudentListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
    	
    	// step Student 리스트
		rtnMap.put("dataList",  lmsRegularMgService.lmsRegularMgDetailStepStudentListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
		 
	 /**
	 //정규과정Mg Detail 온라인,라이브,교육자료 과정 수료 처리
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/course/lmsRegularMgOnlineLiveDataFinishUpdateAjax.do")
	 public ModelAndView lmsRegularMgOnlineLiveDataFinishUpdateAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 
		 //스텝 하위 온라인,라이브,교육자료 과정 수료 처리
		 int cnt = lmsRegularMgService.lmsRegularMgOnlineLiveDataFinishUpdateAjax(requestBox);
		 
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	 }
		 
	 /**
	  * 오프라인과정 좌석등록 탭 페이지 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value = "/course/lmsRegularMgDetailOfflineCourseSeat.do")
    public ModelAndView lmsRegularMgDetailOfflineCourseSeat(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		mav.addObject("stepcourseid", requestBox.get("stepcourseid"));
		mav.setViewName("/manager/lms/manage/regular/course/lmsRegularMgDetailOfflineCourseSeat");
		
		return mav;
    }
		
	 /**
	  * 오프라인과정 출석처리 탭 페이지 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value = "/course/lmsRegularMgDetailOfflineAttendHandle.do")
    public ModelAndView lmsRegularMgDetailOfflineAttendHandle(RequestBox requestBox, ModelAndView mav) throws Exception {

		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		//검색용 pincodeList 조회
		 mav.addObject("pincodelist", lmsRegularMgService.selectLmsPinCodeList(requestBox));
		
		//부사업자신청 허용 flag가져오기
		mav.addObject("togetherflag",lmsRegularMgService.selectLmsRegularMgOfflineTogetherFlag(requestBox));
		mav.addObject("stepcourseid", requestBox.get("stepcourseid"));
		mav.setViewName("/manager/lms/manage/regular/course/lmsRegularMgDetailOfflineAttendHandle");
		
		return mav;
    }
			
			
	/**
	 * 수료 UPDATE
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/course/lmsRegularMgOfflineAttendUpdateAjax.do")
    public ModelAndView lmsRegularMgOfflineAttendUpdateAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		int cnt = lmsRegularMgService.lmsRegularMgOfflineAttendUpdateAjax(requestBox);
		
    	//UPDATE 처리
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
		
	/**
	//오프라인 출석결과 엑셀등록 팝업 호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	 @RequestMapping(value="/course/lmsRegularMgDetailOfflineAttendExcelPop.do")
	    public ModelAndView lmsRegularMgDetailOfflineAttendExcelPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 rtnMap.putAll(lmsRegularMgService.lmsRegularMgDetailOfflineAttendPopInfo(requestBox));
		 mav.addObject("detail", rtnMap);
		return mav;
	 }
		 
	 /**
		 * 오프라인 출석결과 엑셀등록 
		 * @param requestBox
		 * @param mav
		 * @return
		 * @throws Exception
		 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/course/lmsRegularMgOfflineAttendRegisterExcelAjax.do")
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
				String result = lmsRegularMgService.lmsRegularMgAttendRegisterCheck(requestBox);
					
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
			lmsRegularMgService.insertLmsRegularMgAttendHandle(requestBox,retSuccessList);
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
	  * Attend Barcode 팝업 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/course/lmsRegularMgDetailOfflineAttendBarcodePop.do")
	 public ModelAndView lmsOfflineMgDetailAttendBarcodePop(RequestBox requestBox, ModelAndView mav) throws Exception {
		 
		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		 
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 rtnMap.putAll(lmsRegularMgService.lmsRegularMgDetailOfflineAttendPopInfo(requestBox));
		 mav.addObject("detail", rtnMap);
		 
		 return mav;
	 }
		 
	 /**
		 * 바코드 출석 처리하기
		 * @param mav
		 * @param requestBox
		 * @return
		 * @throws Exception
		 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/course/lmsRegularMgDetailOfflineAttendBarcodeAjax.do")
	public ModelAndView lmsRegularMgDetailOfflineAttendBarcodeAjax(ModelAndView mav,RequestBox requestBox) throws Exception
	{	
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int step = 1;
		String applicantCheck = "";
		String togetherCheck = "";
		//ABO번호 CHECK
		String uidCheck = lmsRegularMgService.lmsRegularMgAboNumberCheck(requestBox);
		
		if(uidCheck.equals("Y"))
		{	
			
			//교육신청자인지 아닌지 확인하기
			applicantCheck = lmsRegularMgService.lmsRegularMgAttendRegisterCheck(requestBox);
		
			//동반신청과정이면서 동반신청인 경우 CHECK
			togetherCheck = lmsRegularMgService.lmsRegularMgAttendBarcodeTogetherCheck(requestBox);
		
			//교육신청자인 경우
			if(applicantCheck.equals("Y"))
			{
				//바코드 팝업 창  confirm구역에 보여줄 리스트 조회하기
				if(togetherCheck.equals("Y"))
				{	
					rtnMap.putAll(lmsRegularMgService.lmsRegularMgAttendBarcodeConfirmInfo(requestBox));
				}
				//동반자신청이 아닌 경우 출석 처리하고 좌석배정한뒤 회원정보 조회
				else if(togetherCheck.equals("N"))
				{
					rtnMap.putAll(lmsRegularMgService.lmsRegularMgAttendBarcodeMemberInfo(requestBox,step));
				}
			}
			//미신청자인 경우
			else if(applicantCheck.equals("N"))
			{
				rtnMap.putAll(lmsRegularMgService.lmsRegularMgAttendBarcodeNoAppllicantInfo(requestBox));
			}
		}
		else
		{
			rtnMap.put("comment", "해당 ABO번호는 존재 하지 않습니다");
		}
		
		rtnMap.put("uidCheck", uidCheck);
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
	@SuppressWarnings("unchecked")
	@RequestMapping("/course/lmsRegularMgDetailOfflineAttendBarcodeMemberInfoConfirmAjax.do")
	public ModelAndView lmsRegularMgDetailOfflineAttendBarcodeMemberInfoConfirmAjax(ModelAndView mav,RequestBox requestBox) throws Exception
	{	
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int step = 2;
		
		rtnMap.putAll(lmsRegularMgService.lmsRegularMgAttendBarcodeMemberInfo(requestBox,step));
		
		
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
	@SuppressWarnings("unchecked")
	@RequestMapping("/course/lmsRegularMgDetailOfflineAttendBarcodeExceptionAjax.do")
	public ModelAndView lmsRegularMgDetailOfflineAttendBarcodeExceptionAjax(ModelAndView mav,RequestBox requestBox) throws Exception
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
			applicantCheck = lmsRegularMgService.lmsRegularMgAttendRegisterCheck(requestBox);
			
			//신청자인 경우
			if(applicantCheck.equals("Y"))
			{
				//좌석배정한뒤 회원정보 조회
				rtnMap.putAll(lmsRegularMgService.lmsRegularMgAttendBarcodeMemberInfo(requestBox,step));
			}
			//미신청자인 경우
			else if(applicantCheck.equals("N"))
			{
				//교육부 요청으로 예외처리할 것 : 오프라인 강의에만 수강생 추가 후 좌석배치 --> 오프라인 예외처리 붙이기
				//stepcourseid를 courseid로 세팅할 것
				requestBox.put("courseid", requestBox.get("stepcourseid"));
				rtnMap.putAll(lmsOfflineMgService.lmsOfflineMgAttendBarcodePlaceAsk2(requestBox,step));
				//rtnMap.put("comment", "수강 신청자가 아닙니다.");
			}
		}
		else
		{
			rtnMap.put("comment", "해당 ABO번호는 존재 하지 않습니다");
		}
		
		rtnMap.put("uidCheck", uidCheck);
		rtnMap.put("applicantCheck", applicantCheck);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	 /**
	 //student 목록 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/course/lmsRegularMgTestListAjax.do")
    public ModelAndView lmsRegularMgTestListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsRegularMgService.lmsRegularMgTestListAjaxCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
    	
    	// 교육과정 탭 Test Student리스트
		rtnMap.put("studentList",  lmsRegularMgService.lmsRegularMgTestListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
		 
	 /**
	 //정규과정Mg Detail Test 과정 수료 처리
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/course/lmsRegularMgTestFinishUpdateAjax.do")
    public ModelAndView lmsRegularMgTestFinishUpdateAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
	
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		 
		//스텝 하위  Test 과정 수료 처리
		int cnt = lmsRegularMgService.lmsRegularMgTestFinishUpdateAjax(requestBox);
		 
		rtnMap.put("cnt", cnt);
		
		DataBox courseData = lmsRegularMgService.lmsRegularMgTestCourseInfo(requestBox);
		if(courseData != null){
			rtnMap.put("finishcount", courseData.getString("finishcount"));
		}
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    } 
		 
	 /**
	  * 개인별 답지 팝업 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/course/lmsRegularMgDetailTestAnswerPop.do")
	 public ModelAndView lmsRegularMgDetailTestAnswerPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		 
		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		 
		 Map<String,Object> data = new HashMap<String, Object>();
		 
		 data = lmsRegularMgService.lmsRegularMgDetailTestList(requestBox);
		 
		 //문제 리스트 가져오기
		 mav.addObject("testlist",data.get("testList"));
		//답변리스트 가져오기
		 mav.addObject("answerlist", data.get("answerList"));
		//시험 정보 가져오기
		 mav.addObject("info",lmsRegularMgService.lmsRegularMgDetailTestStudentInfo(requestBox));
		 
		 mav.addObject("uidlist",requestBox.getVector("uidlist"));
		 
		 mav.addObject("stepcourseid",requestBox.get("stepcourseid"));
		 
		 return mav;
	 }
		 
	 /**
	  * 개인별 답지 팝업 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/course/lmsRegularMgDetailTestAnswerPopChange.do")
	 public ModelAndView lmsRegularMgDetailTestAnswerPopChange(RequestBox requestBox, ModelAndView mav) throws Exception {
	 
		 Map<String,Object> data = new HashMap<String, Object>();
		 
		 data = lmsRegularMgService.lmsRegularMgDetailTestList(requestBox);
		 
		 //문제 리스트 가져오기
		 mav.addObject("testlist",data.get("testList"));
		//답변리스트 가져오기
		 mav.addObject("answerlist", data.get("answerList"));
		//시험 정보 가져오기
		 mav.addObject("info",lmsRegularMgService.lmsRegularMgDetailTestStudentInfo(requestBox));
		 
		 mav.addObject("uidlist",requestBox.getVector("uidlist"));
		 
		 mav.addObject("stepcourseid",requestBox.get("stepcourseid"));
		 
		 return mav;
	 }
		 
		 
	/**
	//주관식 점수 엑설 Popup호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	 @RequestMapping(value="/course/lmsRegularMgDetailTestSubjectExcelPop.do")
	    public ModelAndView lmsRegularMgDetailTestSubjectExcelPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		 String coursename = lmsRegularMgService.lmsRegularMgDetailTestSubjectExcelPop(requestBox);
			mav.addObject("coursename",coursename);
		 
		return mav;
	 }
	 
	 /**
     * 주관식 점수 등록 Excel  다운로드
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/course/lmsRegularMgDetailTestSubjectExcelDown.do")
	public String lmsRegularMgDetailTestSubjectExcelDown(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
    	
    	// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "주관식_점수_등록";
		// 엑셀 헤더명 정의
		String[] headName = {"ABO번호","점수"};
		String[] headId = {"UID","SUBJECTPOINT"};
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
	 * subjectPoint register excel 
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
    @SuppressWarnings("unchecked")
	@RequestMapping(value="/course/lmsRegularMgDetailTestSubjectExcelAjax.do")
	public ModelAndView lmsRegularMgDetailTestSubjectExcelAjax(RequestBox requestBox, ModelAndView mav) throws Exception{
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
		
	
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//excel 파일 데이터 읽기
		String subjectpointexcelfile = requestBox.get("subjectpointexcelfile");

		//ROOT_UPLOAD_DIR
		String filepath = LmsCommonController.ROOT_UPLOAD_DIR + File.separator + "excel" + File.separator + subjectpointexcelfile;
		int totalColCount = 2; //전체 컬럼 갯수
		int startIndexRow = 1; //헤더제외
		String colChk = "Y,Y"; //필수값 체크 Y.필수 N선택
		String colTypeChk = "S,I"; //I.숫자 S.문자
		
		Map<String,Object> retMap = LmsExcelUtil.readExcelFile(filepath, totalColCount, 0, startIndexRow, colChk, colTypeChk) ;
		
		List<Map<String,String>> retFailList = (List<Map<String,String>>)retMap.get("failList");
		List<Map<String,String>> retSuccessList = (List<Map<String,String>>)retMap.get("successList");
		
		
		//실패 데이터 확인
		String failStr = "";
		int check0 = 0;
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
		//String successStr = "";
		boolean isValid = true;
		
		String testType = requestBox.get("testtesttype"); //시험 유형
		
		LOGGER.debug("testType = " + testType);
		
		if( retSuccessList != null && retSuccessList.size() > check0 ) {
			successCount = retSuccessList.size();
			for( int i=0; i<retSuccessList.size(); i++ ) {
				//String errorMsg = "";
				
				Map<String,String> retSuccessMap = retSuccessList.get(i);
				requestBox.put("uid",retSuccessMap.get("col0"));
				requestBox.put("subjectpoint",retSuccessMap.get("col1"));
				
				String subjectPoint = requestBox.get("subjectpoint");
				
				//member테이블에 해당 uid가 있는지 Check하기
				String result = lmsRegularMgService.lmsRegularMgAboNumberCheck(requestBox);
					
				if(result.equals("N"))
				{
					isValid = false;
					StringBuffer failStrBuffer = new StringBuffer(failStr);
					failStrBuffer.append( (i+2)+"행의 ABO넘버가 멤버테이블에 존재하지 않습니다.\r\n" );
					failStr = failStrBuffer.toString();
					successCount--;
				}
				//멤버에 UID존재함
				else if(result.equals("Y"))
				{
					if(subjectPoint.equals(""))
					{
						isValid = false;
						StringBuffer failStrBuffer = new StringBuffer(failStr);
						failStrBuffer.append( (i+2)+"행의 점수가 입력되지않았습니다.\r\n" );
						failStr = failStrBuffer.toString();
						successCount--;
					}
					String fStr = "F";
					int check100 = 100;
					if( fStr.equals(testType) ) { //오프라인시험은 100점 이내로 할 것
						if(Integer.parseInt(subjectPoint) > check100)
						{
							isValid = false;
							StringBuffer failStrBuffer = new StringBuffer(failStr);
							failStrBuffer.append( (i+2)+"행의 점수가 100점 보다 높습니다.\r\n" );
							failStr = failStrBuffer.toString();
							successCount--;
						}
					} else {
						if(Integer.parseInt(subjectPoint) > requestBox.getInt("testsubjectpoint"))
						{
							isValid = false;
							StringBuffer failStrBuffer = new StringBuffer(failStr);
							failStrBuffer.append( (i+2)+"행의 점수가 시험의 정해진 주관식 점수 보다 높습니다.\r\n" );
							failStr = failStrBuffer.toString();
							successCount--;
						}
					}
				}
			}
		}
		rtnMap.put("cnt", 0);
		rtnMap.put("comment", "");
		//EXCEL로 수강신청
		if(isValid)
		{
			rtnMap.putAll(lmsRegularMgService.lmsRegularMgTestSubjectExcelAjax(requestBox,retSuccessList));
		}
		
		///로그등록
		
		requestBox.put("logtype", "E");
		requestBox.put("worktype", "4");
		requestBox.put("successcount", successCount);
		requestBox.put("failcount", retSuccessList.size()-successCount+retFailList.size());
		requestBox.put("logcontent", failStr+requestBox.get("comment"));
		
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
	 //정규과정Mg Detail Test 과정 객관식 재채점
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/course/lmsRegularMgTestObjectRemarking.do")
    public ModelAndView lmsRegularMgTestObjectRemarking(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//스텝 하위  Test 과정 객관식 재채점 처리
		int cnt = lmsRegularMgService.lmsRegularMgTestObjectRemarking(requestBox);
		rtnMap.put("cnt", cnt);

		DataBox courseData = lmsRegularMgService.lmsRegularMgTestCourseInfo(requestBox);
		if(courseData != null){
			rtnMap.put("finishcount", courseData.getString("finishcount"));
		}
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    } 
	
	
	 /**
	 //정규과정Mg Detail Test 과정 수료자 읽기
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/course/lmsRegularMgTestReadPassManNum.do")
   public ModelAndView lmsRegularMgTestReadPassManNum(RequestBox requestBox, ModelAndView mav) throws Exception {

		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		DataBox courseData = lmsRegularMgService.lmsRegularMgTestCourseInfo(requestBox);
		if(courseData != null){
			rtnMap.put("finishcount", courseData.getString("finishcount"));
		}
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
   } 
	
	/**
	//주관식 개별 채점 Pop 호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/course/lmsRegularMgTestEachSubjectPop.do")
    public ModelAndView lmsRegularMgTestEachSubjectPop(RequestBox requestBox, ModelAndView mav) throws Exception {

		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		String coursename = lmsRegularMgService.lmsRegularMgDetailTestSubjectExcelPop(requestBox);
		mav.addObject("coursename",coursename);
		//핀코드 리스트 조회
		mav.addObject("pincodelist", lmsRegularMgService.selectLmsPinCodeList(requestBox));
		 
		return mav;
	}
	 
	/**
	//주관식 개별 채점 Pop List
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/course/lmsRegularMgTestEachSubjectPopAjax.do")
	public ModelAndView lmsRegularMgTestEachSubjectPopAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		 
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
		pageVO.setTotalCount(lmsRegularMgService.lmsRegularMgTestListAjaxCount(requestBox));
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		rtnMap.putAll(pageVO.toMapData());
		/*페이징 세팅 끝*/
		requestBox.put("order", "SUBJECTPOINT");
		 
		// 교육과정 탭 Test Student리스트
		rtnMap.put("studentList",  lmsRegularMgService.lmsRegularMgTestListAjax(requestBox));
		 
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
			
		return mav;
	}
	 
	/**
	//주관식 개별 답변 Pop 호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/course/lmsRegularMgDetailTestSubjectAnswerPop.do")
	public ModelAndView lmsRegularMgDetailTestSubjectAnswerPop(RequestBox requestBox, ModelAndView mav) throws Exception {

		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		//시험 정보 가져오기
		mav.addObject("info",lmsRegularMgService.lmsRegularMgDetailTestSubjectAnswerPop(requestBox));
		
		//주관식 답변 가져오기
		 mav.addObject("subjectlist",lmsRegularMgService.lmsRegularMgDetailEachTestSubjectAnswer(requestBox));
		 mav.addObject("uidlist",requestBox.getVector("uidlist"));
		 
		 mav.addObject("stepcourseid",requestBox.get("stepcourseid"));
		return mav;
	 }
		 
	/**
	//주관식 개별 답변 Pop 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/course/lmsRegularMgDetailTestSubjectAnswerPopChange.do")
	 public ModelAndView lmsRegularMgDetailTestSubjectAnswerPopChange(RequestBox requestBox, ModelAndView mav) throws Exception {
			
		 //시험 정보 가져오기
		 mav.addObject("info",lmsRegularMgService.lmsRegularMgDetailTestSubjectAnswerPop(requestBox));
		 
		 //주관식 답변 가져오기
		 mav.addObject("subjectlist",lmsRegularMgService.lmsRegularMgDetailEachTestSubjectAnswer(requestBox));
		 mav.addObject("uidlist",requestBox.getVector("uidlist"));
		 
		 mav.addObject("stepcourseid",requestBox.get("stepcourseid"));
		 return mav;
	 }
		 
	 /**
	 //정규과정Mg Detail Test 과정 주관식 개별 채점
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/course/lmsRegularMgDetailEachSubjectPointUpdate.do")
	    public ModelAndView lmsRegularMgDetailEachSubjectPointUpdate(RequestBox requestBox, ModelAndView mav) throws Exception {
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		 
		 //주관식 개별 채점
		 int cnt = lmsRegularMgService.lmsRegularMgDetailEachSubjectPointUpdate(requestBox);
		 
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	 } 
	 
	 /**
	  * 설문과정 설문결과 탭 페이지 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value = "/course/lmsRegularMgDetailSurveyCourseResult.do")
	public ModelAndView lmsRegularMgDetailSurveyCourseResult(RequestBox requestBox, ModelAndView mav) throws Exception {
			
		//설문결과 가져오기
		Map<String,Object> data = new HashMap<String, Object>();
		 
		 data = lmsRegularMgService.lmsRegularMgDetailSurveyList(requestBox);
		 
		 //질문 리스트 가져오기
		 mav.addObject("surveyList",data.get("surveyList"));
		//Object 보기 리스트 가져오기
		 mav.addObject("sampleObjectList", data.get("sampleObjectList"));
		 //Subject 보기 리스트 가져오기
		 mav.addObject("sampleSubjectList", data.get("sampleSubjectList"));
		
		
		mav.addObject("stepcourseid", requestBox.get("stepcourseid"));
		mav.setViewName("/manager/lms/manage/regular/course/lmsRegularMgDetailSurveyCourseResult");
		
		return mav;
    }
		
	 /**
	  * 설문과정 설문대상자 탭 페이지 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value = "/course/lmsRegularMgDetailSurveyCourseStudent.do")
	public ModelAndView lmsRegularMgDetailSurveyCourseStudent(RequestBox requestBox, ModelAndView mav) throws Exception {
			
		//핀코드 리스트 조회
		mav.addObject("pincodelist", lmsRegularMgService.selectLmsPinCodeList(requestBox));
		mav.setViewName("/manager/lms/manage/regular/course/lmsRegularMgDetailSurveyCourseStudent");
		
		return mav;
	}
			
	 /**
	 //student 목록 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/course/lmsRegularMgDetailSurveyCourseListAjax.do")
    public ModelAndView lmsRegularMgDetailSurveyCourseListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsRegularMgService.lmsRegularMgDetailSurveyCourseListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
    	
    	// 설문대상자 탭 Test Student리스트
		rtnMap.put("studentList",  lmsRegularMgService.lmsRegularMgDetailSurveyCourseListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	 
	 /**
	  * 개인별 설문지 팝업 호출
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/course/lmsRegularMgDetailSurveyResponsePop.do")
	 public ModelAndView lmsRegularMgDetailSurveyResponsePop(RequestBox requestBox, ModelAndView mav) throws Exception {
		 
		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		 
		 Map<String,Object> data = new HashMap<String, Object>();
		 
		 data = lmsRegularMgService.lmsRegularMgDetailSurveyResponsePop(requestBox);
		 
		 //설문 답변가져오기
		 mav.addObject("responseList1",data.get("responseList1"));
		//선다형 답변 가져오기
		 mav.addObject("responseList2", data.get("responseList2"));
		
		 
		 mav.addObject("uidlist",requestBox.getVector("uidlist"));
		 
		 return mav;
	 }
	 
	 /**
	  * 개인별 설문지 팝업 호출 change
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/course/lmsRegularMgDetailSurveyResponsePopChange.do")
	 public ModelAndView lmsRegularMgDetailSurveyResponsePopChange(RequestBox requestBox, ModelAndView mav) throws Exception {
		 
		 Map<String,Object> data = new HashMap<String, Object>();
		 
		 data = lmsRegularMgService.lmsRegularMgDetailSurveyResponsePop(requestBox);
		 
		 //설문 답변가져오기
		 mav.addObject("responseList1",data.get("responseList1"));
		 //선다형 답변 가져오기
		 mav.addObject("responseList2", data.get("responseList2"));
		 
		 //회원정보
		 mav.addObject("info",lmsRegularMgService.lmsRegularMgDetailSurveyResponsePopInfo(requestBox));
		 
		 mav.addObject("uidlist",requestBox.getVector("uidlist"));
		 
		 
		 return mav;
	 }
		
	 /**
	   *  수료처리 탭 페이지 불러오기
	   * @param requestBox
	   * @param mav
	   * @return
	   * @throws Exception
	   */
	 @RequestMapping(value = "/finish/lmsRegularMgDetailFinishHandle.do")
	 public ModelAndView lmsRegularMgDetailFinishHandle(RequestBox requestBox, ModelAndView mav) throws Exception {
	   
		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		 
		 //핀코드 리스트 조회
		 mav.addObject("pincodelist", lmsRegularMgService.selectLmsPinCodeList(requestBox));
		   
		 //단계 조회
		 mav.addObject("steplist", lmsRegularMgService.selectLmsStepList(requestBox));
		 //전체 수료자수 및 수강생 수
		 mav.addObject("total", lmsRegularMgService.selectRegularMgFinishTotal(requestBox));
		 mav.addObject("courseid",requestBox.get("courseid"));
		   
		 mav.setViewName("/manager/lms/manage/regular/finish/lmsRegularMgDetailFinishHandle");
		 return mav;
	}
	  
	@RequestMapping(value = "/finish/lmsRegularMgDetailFinishHandleListAjax.do")
	public ModelAndView lmsRegularMgDetailFinishHandleListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
	   
		/*페이징 세팅 시작*/
		// 정렬 셋팅
		String sortKey = requestBox.get("sortKey");
		if("coursename".equals(sortKey)){
			requestBox.put("sortIndex", 1);
		}else{
			requestBox.put("sortIndex", 0);
		}
	   
		//수료자 카운트
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(lmsRegularMgService.lmsRegularMgFinishListCount(requestBox));
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		rtnMap.putAll(pageVO.toMapData());
		/*페이징 세팅 끝*/
	   
		//수료자 정보 읽기
		List<DataBox> finishList = lmsRegularMgService.lmsRegularMgFinishListAjax(requestBox);
		//수료자 스탭 수료 정보 읽기
		List<DataBox> finishStepList = lmsRegularMgService.lmsRegularMgFinishStepList(requestBox);
	    int check0 = 0;
		if( finishList != null && finishList.size() > check0 ) {
			for( int i=0; i<finishList.size(); i++ ) {
				DataBox retBox = finishList.get(i);
	     
				String uid = retBox.getString("uid");
				if( finishStepList != null && finishStepList.size() > check0 ) {
					for( int k=0; k<finishStepList.size(); k++ ) {
						DataBox retBox2 = finishStepList.get(k);
	       
						if( uid.equals( retBox2.getString("uid") )) {
							retBox.put("stepseq_" + retBox2.getString("stepseq"), retBox2.getString("finishflagname"));
						}
					}
				}
				finishList.set(i, retBox);
			}
		}
	   
		rtnMap.put("finishList", finishList);
	   
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	  
	/**
	 //정규과정Mg 수료 처리
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/course/lmsRegularMgFinishUpdateAjax.do")
	public ModelAndView lmsRegularMgFinishUpdateAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
	 
		//정규과정 수료 처리
		int cnt = lmsRegularMgService.lmsRegularMgFinishUpdateAjax(requestBox);
	 
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
		 
	 /**
	     * 정규과정Mg Survey Result Excel  다운로드
	     * @param request
	     * @param model
	     * @return
	     * @throws Exception
	     */
    @RequestMapping(value = "/lmsRegularMgSurveyExcelDownload.do")
	public String lmsRegularMgSurveyExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		    	
    	// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "설문 결과 통계";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","질문","척도평균","답변","답변수","선택비율"};
		String[] headId = {"SURVEYSEQ","SURVEYNAME","AVGVALUE","SAMPLENAME","CNT","PCT"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String> > dataList = lmsRegularMgService.lmsRegularMgSurveyExcelDownload(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
}
