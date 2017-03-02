package amway.com.academy.manager.lms.lmsStamp.web;

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
import amway.com.academy.manager.lms.common.service.LmsCommonService;
import amway.com.academy.manager.lms.lmsStamp.service.LmsStampService;
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
 * @NAME :LmsStampController.java
 * @DESC :스탬프 관리
 * @Author:KR620261
 * @DATE : 2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */
@Controller
@RequestMapping("/manager/lms/advantage")
public class LmsStampController {
	
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsStampController.class);	
	
	@Autowired
	LmsStampService lmsStampService;
	
	@Autowired
	LmsCommonService lmsCommonService;
	
	@Autowired
	SessionUtil sessionUtil;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/**
	 * 스템프 관리 page
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsStamp.do")
	public ModelAndView lmsStamp(RequestBox requestBox, ModelAndView mav) throws Exception {
		 mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/advantage/lmsStamp.do") );
		return mav;
    }	
	
	/**
	 * 스템프 관리 조회
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsStampListAjax.do")
    public ModelAndView lmsStampListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*페이징 세팅 시작*/
		// 정렬 셋팅
		String sortKey = requestBox.get("sortKey");
		if("stampname".equals(sortKey)){
			requestBox.put("sortIndex", 1);
		}else{
			requestBox.put("sortIndex", 0);
		}
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(lmsStampService.selectLmsStampCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/

    	// 리스트
		rtnMap.put("dataList",  lmsStampService.selectLmsStampList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
    /**
     * 스탬프 Excel  다운로드
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping(value = "/lmsStampExcelDownload.do")
	public String lmsStampExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
    	// 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "스탬프목록";
		// 엑셀 헤더명 정의
		String[] headName = {"No.","스탬프명","조건","구분"};
		String[] headId = {"NO","STAMPNAME","STAMPCONDITION","STAMPTYPENAME"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String> > dataList = lmsStampService.selectLmsStampListExcelDown(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExportCountReverse(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	}
	
	/**
	 * 스템프 삭제
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsStampDeleteAjax.do")
    public ModelAndView lmsStampDeleteAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*삭제파람 체크 시작*/
		requestBox.put("stampids", requestBox.getVector("stampid"));
		/*삭제파람 체크 끝*/
		
    	// 삭제처리
		int cnt = lmsStampService.deleteLmsStamp(requestBox);
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 스템프 등록
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/lmsStampWrite.do")
	public ModelAndView lmsStampPop(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("stampid"))){
			rtnMap = lmsStampService.selectLmsStamp(requestBox);
		}
		mav.addObject("detail", rtnMap);
		
		// 보너스레벨 코드 리스트
		requestBox.put("codemasterseq", "BONUSCODE");
		mav.addObject("bonusList", lmsCommonService.selectLmsCommonCodeList(requestBox));
		
		// 핀레벨 코드 리스트
		requestBox.put("codemasterseq", "PINCODE");
		mav.addObject("pinList", lmsCommonService.selectLmsCommonCodeList(requestBox));
		
		return mav;
    }	
	

	/**
	 * 스템프 저장
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsStampSaveAjax.do")
    public ModelAndView lmsStampSaveAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		//관리자 아이디 입력하기
		requestBox.put("adminid", requestBox.getSession( LmsCode.adminSessionId ));
    	// 저장처리
		int cnt = 0;
		String stampid = requestBox.get("stampid");
		if("".equals(stampid)){
			cnt = lmsStampService.insertLmsStamp(requestBox);
		}else{
			cnt = lmsStampService.updateLmsStamp(requestBox);
		}
		rtnMap.put("cnt", cnt);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	
	/**
	 * 스템프 랭킹 page
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsStampRanking.do")
	public ModelAndView lmsStampRanking(RequestBox requestBox, ModelAndView mav) throws Exception {
		
		//스탬프 종류 가져오기
		List<DataBox> stampList = lmsStampService.seletLmsStampList();
		
		//기본 회계기간 가져오기
		Map<String,String> date = lmsStampService.selectLmsStampDate();
		requestBox.putAll(date);
		
		//스탬프 통계 정보 가져오기
		DataBox info = lmsStampService.selectLmsStampRankingInfo(requestBox);
		
		mav.addObject("stampList", stampList);
		mav.addObject("date",date);
		mav.addObject("info",info);
		
		return mav;
    }
	  /**
	 *  회원 탭 불러오기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsStampMemberList.do")
	public ModelAndView lmsStampMemberList(RequestBox requestBox, ModelAndView mav) throws Exception {

		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		mav.setViewName("/manager/lms/advantage/lmsStampMemberTab");
		return mav;
	}
	
	/**
	//회원 탭 리스트
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/lmsStampMemberListAjax.do")
	public ModelAndView lmsStampMemberListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*페이징 세팅 시작*/
		// 정렬 셋팅
		String sortKey = requestBox.get("sortKey");
		if("stampname".equals(sortKey)){
			requestBox.put("sortIndex", 1);
		}else{
			requestBox.put("sortIndex", 0);
		}
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(lmsStampService.lmsStampMemberListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
		
	    	
    	//회원 목록
		List<DataBox> dataList = lmsStampService.lmsStampMemberListAjax(requestBox);
		 
		//스탬프 통계 정보 가져오기
		DataBox info = lmsStampService.selectLmsStampRankingInfo(requestBox);
		
		rtnMap.put("dataList", dataList);
		rtnMap.putAll(info);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	
	/**
	 *  스탬프종류 탭 불러오기
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsStampKind.do")
	public ModelAndView lmsStampKind(RequestBox requestBox, ModelAndView mav) throws Exception {
		mav.setViewName("/manager/lms/advantage/lmsStampKindTab");
		return mav;
	}
	
	/**
	//스탬프종류 탭 리스트
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/lmsStampKindListAjax.do")
	public ModelAndView lmsStampKindListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*페이징 세팅 시작*/
		// 정렬 셋팅
		String sortKey = requestBox.get("sortKey");
		if("stampname".equals(sortKey)){
			requestBox.put("sortIndex", 1);
		}else{
			requestBox.put("sortIndex", 0);
		}
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(lmsStampService.lmsStampKindListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
		
	    //스탬프 목록
		List<DataBox> dataList = lmsStampService.lmsStampKindListAjax(requestBox);
		 
		//스탬프 통계 정보 가져오기
		DataBox info = lmsStampService.selectLmsStampKindInfo(requestBox);
		
		rtnMap.put("dataList", dataList);
		rtnMap.putAll(info);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	 
	/**
	//stamp획득자 팝업 호출
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	 @RequestMapping(value="/lmsStampObtainMemberPop.do")
	    public ModelAndView lmsStampObtainMemberPop(RequestBox requestBox, ModelAndView mav) throws Exception {

		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		 
		 return mav;
	 }
		 
	 /**
	 //stamp획득자 팝업 리스트
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/lmsStampObtainMemberPopAjax.do")
	 public ModelAndView lmsStampObtainMemberPopAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*페이징 세팅 시작*/
		// 정렬 셋팅
		String sortKey = requestBox.get("sortKey");
		if("stampname".equals(sortKey)){
			requestBox.put("sortIndex", 1);
		}else{
			requestBox.put("sortIndex", 0);
		}
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(lmsStampService.lmsStampObtainMemberPopAjaxCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
		
	    //스탬프 획득자 목록
		List<DataBox> dataList = lmsStampService.lmsStampObtainMemberPopAjax(requestBox);
		
		rtnMap.put("dataList", dataList);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	 }
	 
	 /**
     * StampKind Excel  다운로드
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
	 @RequestMapping(value = "/lmsStampKindExcelDownload.do")
	 public String lmsStampKindExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "스탬프종류_목록";
		// 엑셀 헤더명 정의
		String[] headName = {"랭킹.","스탬프명","구분","획득자수"};
		String[] headId = {"RANK","STAMPNAME","STAMPTYPE","OBTAINCNT"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String> > dataList = lmsStampService.lmsStampKindListExcelDown(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
	  
		return "excelDownload";
	 }
	 
	 /**
	 * 스템프 랭킹 page
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsStampStatus.do")
	public ModelAndView lmsStampStatus(RequestBox requestBox, ModelAndView mav) throws Exception {

		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		//스탬프 종류 가져오기
		List<DataBox> stampList = lmsStampService.seletLmsStampList();
		//기본 회계기간 가져오기
		Map<String,String> date = lmsStampService.selectLmsStampDate();
		mav.addObject("stampList", stampList);
		mav.addObject("date", date);
		return mav;
    }
		
	/**
	//스탬프종류 탭 리스트
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/lmsStampStatusListAjax.do")
	public ModelAndView lmsStampStatusListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*페이징 세팅 시작*/
		// 정렬 셋팅
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(lmsStampService.lmsStampStatusListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
	
	    //스탬프현황 목록
		List<DataBox> dataList = lmsStampService.lmsStampStatusListAjax(requestBox);
		 
		rtnMap.put("dataList", dataList);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
		 
	/**
	 * 페널티 관리 page
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/lmsPenaltyManage.do")
	public ModelAndView lmsPenaltyManage(RequestBox requestBox, ModelAndView mav) throws Exception {

		// 개인정보 로그
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		mav.addObject("managerMenuAuth", sessionUtil.getManagerMenuAuth(requestBox, "/manager/lms/advantage/lmsPenaltyManage.do") );
		return mav;
    }
		  
	/**
	 //스탬프종류 탭 리스트
	  * @param requestBox
	  * @param mav
	  * @return
	  * @throws Exception
	  */
	@RequestMapping(value="/lmsPenaltyManageListAjax.do")
    public ModelAndView lmsPenaltyManageListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		/*페이징 세팅 시작*/
		// 정렬 셋팅
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(lmsStampService.lmsPenaltyManageListCount(requestBox));
    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
    	rtnMap.putAll(pageVO.toMapData());
    	/*페이징 세팅 끝*/
	
	    //페널티관리 목록
		List<DataBox> dataList = lmsStampService.lmsPenaltyManageListAjax(requestBox);
		 
		
		rtnMap.put("dataList", dataList);
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
	@RequestMapping(value = "/lmsPenaltyClearAjax.do")
	public ModelAndView lmsOfflineMgAttendUpdateAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페널티 해제
		lmsStampService.lmsPenaltyClearAjax(requestBox);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
}