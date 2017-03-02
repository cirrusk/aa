package amway.com.academy.manager.lms.statistics.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.commoncode.service.ManageCodeService;
import amway.com.academy.manager.lms.common.service.LmsCommonService;
import amway.com.academy.manager.lms.statistics.service.LmsStatisticsService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;



@Controller
@RequestMapping("/manager/lms/statistics")
public class LmsStatisticsController {
	
	
	@Autowired
	LmsStatisticsService lmsStatisticsService;
	
	@Autowired
	LmsCommonService lmsCommonService;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/**
	 * 월별 교육현황 빈화면
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsStatisticsEduPerMonth.do")
	public ModelAndView lmsStatisticsEduPerMonth(RequestBox requestBox, ModelAndView mav) throws Exception {
			//회계년도 가져오기
			int year = lmsStatisticsService.selectLmsYear();
			mav.addObject("year", year);
		return mav;
    }	
	
	/**
	 * 월별 교육현황 화면 분기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsStatisticsEduPerMonthSelectChange.do")
	public ModelAndView lmsStatisticsEduPerMonthSelectChange(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		List<DataBox> dataList = new ArrayList<DataBox>();
		int type = requestBox.getInt("type");
		
		int check1 = 1;
		int check2 = 2;
		int check3 = 3;
		int check4 = 4;
		int check5 = 5;
		int check6 = 6;
		
		//페이지 분기
		if(type==check1)
		{		
			//월별 아카데미 현황
			dataList = lmsStatisticsService.lmsStatisticsAcademyStatusPerMonth(requestBox);
			mav.setViewName("/manager/lms/statistics/lmsStatisticsAcademyStatusPerMonth");
		}
		else
		{
			if(type==check2 || type==check3 || type==check4 || type==check5)
			{	
				String courseType = "";
				int viewType = 0;
				
				//교육자료 조회수 상위 20
				if(type==check2){
					courseType = "D";
					viewType = 3;
				}
				//온라인 조회수 상위 20
				else if(type==check3)
				{
					courseType = "O";
					viewType = 3;
				}
				//교육자료 좋아요 상위 20
				else if(type==check4)
				{
					courseType = "D";
					viewType = 2;
				}
				//온라인 좋아요 상위 20
				else if(type==check5)
				{
					courseType = "O";
					viewType = 2;
				}
				
				requestBox.put("coursetype", courseType);
				requestBox.put("viewtype", viewType);
				dataList = lmsStatisticsService.lmsStatisticsPerMonthTop20(requestBox);
			}
			else if(type==check6)
			{
				//오프라인과정 참석자 상위 10
				dataList = lmsStatisticsService.lmsStatistisOfflineAttendPerMonthTop10(requestBox);
				
			}
			mav.setViewName("/manager/lms/statistics/lmsStatisticsPerMonthRanking");
		}
		mav.addObject("dataList",dataList);
		
		return mav;
    }
	
	 /**
     * 월별 교육 현황 통계 Excel  다운로드
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/lmsStatisticsEduPerMonthExcelDownload.do")
	public String lmsStatisticsEduPerMonthExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
    	
    	// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	List<Map<String, String> > dataList = new ArrayList<Map<String,String>>();
    	
    	String fileNm = "";
		String sFileName = "";
		
		int check1 = 1;
		int check2 = 2;
		int check3 = 3;
		int check4 = 4;
		int check5 = 5;
		int check6 = 6;
		
		int type = requestBox.getInt("type");

		if(type == check1)
		{		
			// 2. 파일 이름
			fileNm = "월별_교육_현황_통계";
			// 3. excel 양식 구성
			
			// 엑셀 헤더명 정의
			String[] headName = {"구분","9월","10월","11월","12월","1월","2월","3월","4월","5월","6월","7월","8월","계","지난달 대비 증감(%)"};
			String[] headId = {"flag","september","october","november","december","january","february","march","april","may","june","july","august","totalcnt","pct2"};
			
			head.put("head_name", headName);
			head.put("head_id", headId);

			//월별 아카데미 현황
			dataList = lmsStatisticsService.lmsStatisticsAcademyStatusPerMonthExcelDown(requestBox);
		}
		else if(type==2 || type==3 || type==4 || type==5)
		{	
			String colName = "조회수";
			String courseType = "";
			int viewType = 0;

			if(type==check2)
			{
				courseType = "D";
				viewType = 3;
				// 2. 파일 이름
				fileNm = "교육자료_조회수_상위20";
			}
			else if(type==check3)
			{
				courseType = "O";
				viewType = 3;
				// 2. 파일 이름
				fileNm = "온라인_조회수_상위20";
			}
			else if(type==check4)
			{
				courseType = "D";
				viewType = 2;
				colName = "좋아요수";
				// 2. 파일 이름
				fileNm = "교육자료_좋아요_상위20";
			}
			else if (type==check5) {
				courseType = "O";
				viewType = 2;
				colName = "좋아요수";
				// 2. 파일 이름
				fileNm = "온라인_좋아요_상위20";
			}
			
			// 3. excel 양식 구성
			// 엑셀 헤더명 정의
			String[] headName = {"순위","교육분류","과정/자료명",colName};
			String[] headId = {"RANK","CATEGORYTREENAME","COURSENAME","VIEWCOUNT"};
			
			head.put("headName", headName);
			head.put("headId", headId);
			
			
			requestBox.put("coursetype", courseType);
			requestBox.put("viewtype", viewType);
			//교육자료,온라인 조회수 상위 20
			dataList = lmsStatisticsService.lmsStatisticsPerMonthTop20ExcelDown(requestBox);
		}
		else if(type==check6)
		{	
			fileNm="오프라인과정_참석자_상위10";
			
			// 3. excel 양식 구성
			// 엑셀 헤더명 정의
			String[] headName = {"순위","교육분류","과정/자료명","참석수"};
			String[] headId = {"RANK","CATEGORYTREENAME","COURSENAME","VIEWCOUNT"};
			
			head.put("head_name", headName);
			head.put("head_id", headId);
			//오프라인과정 참석자 상위 10
			dataList = lmsStatisticsService.lmsStatistisOfflineAttendPerMonthTop10ExcelDown(requestBox);
			
		}
		
		sFileName = fileNm + ".xlsx";
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
    
	/**
	 * 온라인과정 보고서 빈화면
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsReportOnlineCourse.do")
	public ModelAndView lmsReportOnlineCourse(RequestBox requestBox, ModelAndView mav) throws Exception {
		return mav;
    }
	/**
	 * 라이브과정 보고서 빈화면
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsReportLiveCourse.do")
	public ModelAndView lmsReportLiveCourse(RequestBox requestBox, ModelAndView mav) throws Exception {
		return mav;
	}
	/**
	 * 오프라인과정 보고서 빈화면
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsReportOfflineCourse.do")
	public ModelAndView lmsReportOfflineCourse(RequestBox requestBox, ModelAndView mav) throws Exception {
		mav.addObject("apCodeList", lmsCommonService.selectLmsApCodeList(requestBox));
		return mav;
	}
	
	
	/**
	 * 온라인,라이브,오프라인과정 보고서 목록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsReportListAjax.do")
    public ModelAndView lmsReportListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsStatisticsService.lmsReportListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
    	
    	
    	// 온라인,라이브과정보고서 목록
		rtnMap.put("dataList",  lmsStatisticsService.lmsReportListAjax(requestBox));
		
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
	 @RequestMapping(value="/lmsReportDetailPop.do")
	    public ModelAndView lmsReportDetailPop(RequestBox requestBox, ModelAndView mav) throws Exception {
			
			// 개인정보 로그
			manageCodeService.selectCurrentAdNoHistory(requestBox);
		 
		 	mav.addObject("data",lmsStatisticsService.selectLmsReportPopData(requestBox));
			mav.addObject("pincodelist", lmsStatisticsService.selectLmsPinCodeList(requestBox));
		 return mav;
	 }
	 
	/**
	 * 과정보고서 팝업 목록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsReportPopListAjax.do")
    public ModelAndView lmsReportPopListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsStatisticsService.lmsReportPopListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
    	
    	
    	// 레이어팝업 리스트
		rtnMap.put("dataList",  lmsStatisticsService.lmsReportPopListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	 /**
     * 보고서 엑셀 다운
     * @param request
     * @param model
     * @return String
     * @throws Exception
     */
    @RequestMapping(value = "/lmsReportExcelDownload.do")
	public String lmsReportExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
    	
		requestBox.put("totalcount", lmsStatisticsService.lmsReportListCount(requestBox));
    	
    	// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	List<Map<String, String> > dataList = new ArrayList<Map<String,String>>();
    	
    	String fileNm = "";
		String sFileName = "";
		
		String type = requestBox.getString("coursetype");

		if(type.equals("O"))
		{		
			// 2. 파일 이름
			fileNm = "온라인과정보고서";
			// 3. excel 양식 구성
			
			// 엑셀 헤더명 정의
			String[] headName = {"NO","교육부류","과정명","수료","좋아요","보관함","상태"};
			String[] headId = {"NO","CATEGORYTREENAME","COURSENAME","FINISHCOUNT","LIKECOUNT","KEEPCOUNT","OPENFLAG"};
			
			head.put("head_name", headName);
			head.put("head_id", headId);

		}
		else
		{
			if(type.equals("F"))
			{
				fileNm = "오프라인과정보고서";
			}
			else if(type.equals("L"))
			{
				fileNm = "라이브과정보고서";
			}
			// 3. excel 양식 구성
			
			// 엑셀 헤더명 정의
			String[] headName = {"NO","교육부류","테마명","과정명","수료","좋아요","SNS공유","상태"};
			String[] headId = {"NO","CATEGORYTREENAME","THEMENAME","COURSENAME","FINISHCOUNT","LIKECOUNT","SNSCOUNT","OPENFLAG"};
			
			head.put("headName", headName);
			head.put("headId", headId);
		}
		
		//과정보고서 엑셀용 데이터
		dataList = lmsStatisticsService.lmsReportExcelDownload(requestBox);
		
		sFileName = fileNm + ".xlsx";
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
    
	/**
	 * 정규과정 보고서 빈화면
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsReportRegularCourse.do")
	public ModelAndView lmsReportRegularCourse(RequestBox requestBox, ModelAndView mav) throws Exception {
		return mav;
	}
	
	/**
	 * 정규과정 MaxStepCount
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/lmsReportRegularStepCount.do")
	public String lmsReportRegularStepCount(RequestBox requestBox, Model model) throws Exception {
		//단계수 조회
		int stepCount =  lmsStatisticsService.selectLmsRegularStepCount(requestBox);
		return stepCount+"";
	}
	
	/**
	 * 정규과정보고서 리스트
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsReportRegularCourseListAjax.do")
    public ModelAndView lmsReportRegularCourseListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
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
		pageVO.setTotalCount(lmsStatisticsService.lmsReportRegularCourseListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
    	
    	
    	// 정규과정보고서 리스트
		rtnMap.put("dataList",  lmsStatisticsService.lmsReportRegularCourseListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	 /**
     * 보고서 엑셀 다운
     * @param request
     * @param model
     * @return String
     * @throws Exception
     */
    @RequestMapping(value = "/lmsReportRegularCurseExcelDownload.do")
	public String lmsReportRegularCurseExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
    	
		requestBox.put("totalCount", lmsStatisticsService.lmsReportRegularCourseListCount(requestBox));
    	
		//단계수 조회
		int stepCount =  lmsStatisticsService.selectLmsRegularStepCount(requestBox);
		requestBox.put("stepcount", stepCount);
    	
    	// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	List<Map<String, String> > dataList = new ArrayList<Map<String,String>>();
    	
    	String fileNm = "";
		String sFileName = "";
		
		// 2. 파일 이름
		fileNm = "정규과정보고서";
		// 3. excel 양식 구성
		
		// 엑셀 헤더명 정의
		String[] headName = new String[11+stepCount];
		String[] headId		= new String[11+stepCount];
		
		headName[0]="NO"; headName[1]="교육분류"; headName[2]="정규과정테마"; headName[3]="과정명"; headName[4]="상태"; headName[5]="과정수";
		headName[6]="신청자"; headName[7]="이수자"; headName[8]="이수율"; headName[9+stepCount]="좋아요"; headName[10+stepCount]="SNS공유";
		
		headId[0]="NO"; headId[1]="CATEGORYTREENAME"; headId[2]="THEMENAME"; headId[3]="COURSENAME"; headId[4]="OPENFLAG"; 
		headId[5]="STEPCOURSECOUNT"; headId[6]="REQUESTCOUNT"; headId[7]="FINISHCOUNT"; headId[8]="FINISHPERCENT"; 
		headId[9+stepCount]="LIKECOUNT"; headId[10+stepCount]="SNSCOUNT";
		
		for(int i=1;i<=stepCount;i++)
		{
			headName[8+i] = i+"단계";
			headId[8+i]="STEP"+i;
		}
		
		head.put("headName", headName);
		head.put("headId", headId);
		
		
		//정규과정보고서 엑셀용 데이터
		dataList = lmsStatisticsService.lmsReportRegularCurseExcelDownload(requestBox);
		
		sFileName = fileNm + ".xlsx";
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
    

}


 




















































