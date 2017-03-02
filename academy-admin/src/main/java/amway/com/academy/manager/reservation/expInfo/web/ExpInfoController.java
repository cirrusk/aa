package amway.com.academy.manager.reservation.expInfo.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSessionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;
import amway.com.academy.manager.reservation.expInfo.service.ExpInfoService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.web.JSONView;

/**
 * 측정/체험 예약 현황
 * @author KR620226
 *
 */
@Controller
@RequestMapping(value = "/manager/reservation/expInfo")
public class ExpInfoController extends BasicReservationController {

	@Autowired
	public ExpInfoService expInfoService;
	
	/**
	 * 측정/체험 예약 현황 목록 화면 및 초기설정
	 * 
	 * @param codeVO
	 * @param model
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoList.do")
	public String expPenaltyListPage(CommonCodeVO codeVO, 
			ModelMap model,
			ModelAndView mav,
			RequestBox requestBox) throws Exception {
		
		/* 사용자의 담당 AP */
		String allowApCode = (String) requestBox.getSession("sessionApno");
		
		/** initializing **/
        List<?> ppCodeList = super.ppCodeList(allowApCode);
        List<?> expTypeCodeList = super.expTypeInfoCodeList();
        List<?> reservationYearCodeList = super.reservationYearCodeList();
        List<?> reservationMonthCodeList = super.reservationMonthCodeList();
        DataBox reservationToday = super.reservationToday();
        
        model.addAttribute("ppCodeList", ppCodeList);
        model.addAttribute("expTypeCodeList", expTypeCodeList);
        model.addAttribute("reservationYearCodeList", reservationYearCodeList);
        model.addAttribute("reservationMonthCodeList", reservationMonthCodeList);
        model.addAttribute("reservationToday", reservationToday);
        
		/** finally forwarding page **/
		return "/manager/reservation/expInfo/expInfoList";
	}
	
	/**
	 * 해당 pp 측정/체험 프로그램 목록 조회
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expProgramListAjax.do")
	public ModelAndView expProgramListAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {

		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		List<DataBox> expProgramList = expInfoService.expProgramListAjax(requestBox);
		rtnMap.put("expProgramList", expProgramList);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 해당 pp 해당 측정/체험타입 년 월 별 예약 현황 조회
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoListAjax.do")
	public ModelAndView expInfoListAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//해당 월 조회
		List<DataBox> expInfoCalendar = expInfoService.expInfoCalendarAjax(requestBox);
		rtnMap.put("expInfoCalendar", expInfoCalendar);

		//예약 현황 세션 조회
		List<DataBox> expInfoList = expInfoService.expInfoListAjax(requestBox);
		rtnMap.put("expInfoList", expInfoList);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 측정/체험 예약현황 운영자 예약
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoAdminReservationInsertPop.do")
	public ModelAndView expInfoAdminReservationInsertForm(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
		
		mav.addObject("dataList", expInfoService.expInfoAdminReservationSelectAjax(requestBox));
		mav.addObject("listtype", requestBox);
			
		return mav;
	}
	
	/**
	 * 측정/체험 예약현황 목록 운영자 예약
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoAdminReservationListInsertAjax.do")
	public ModelAndView expInfoAdminReservationListInsertAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
			expInfoService.expInfoAdminReservationListInsertAjax(requestBox);
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
			
		} catch ( SqlSessionException e ){
			
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 측정/체험 예약현황 운영자 예약 취소 화면
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoAdminReservationCancelPop.do")
	public ModelAndView expInfoAdminReservationCancelForm(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		mav.addObject("dataList", expInfoService.expInfoAdminReservationCancelSelectAjax(requestBox));
		mav.addObject("listtype", requestBox);
		
		return mav;
	}
	
	/**
	 * 측정/체험 예약현황 목록 운영자 예약 취소
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoAdminReservationListCancelUpdateAjax.do")
	public ModelAndView expInfoAdminReservationListCancelUpdateAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
			expInfoService.expInfoAdminReservationListCancelUpdateAjax(requestBox);
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
			
		} catch ( SqlSessionException e ){
			
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * pp, 측정/체험, 년, 월, 일 정보 조회
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoSessionSelectPop.do")
	public ModelAndView expInfoSessionSelectDetailForm(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		mav.addObject("data", expInfoService.expInfoSessionSelectAjax(requestBox));
		mav.addObject("listtype", requestBox);
		
		return mav;
	}
	
	/**
	 * pp, 측정/체험, 년, 월, 일 세션 정보 목록 조회
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoSessionListAjax.do")
	public ModelAndView expInfoSessionListAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			rtnMap.put("expInfoSessionList", expInfoService.expInfoSessionListAjax(requestBox));
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
			
		} catch ( SqlSessionException e ){
			
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 운영자 예약
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoAdminReservationInsertAjax.do")
	public ModelAndView expInfoAdminReservationInsertAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
			expInfoService.expInfoAdminReservationInsertAjax(requestBox);
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
			
		} catch ( SqlSessionException e ){
			
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}

	/**
	 * 운영자 예약 취소
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expInfoAdminReservationCancelUpdateAjax.do")
	public ModelAndView expInfoAdminReservationCancelUpdateAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
			expInfoService.expInfoAdminReservationCancelUpdateAjax(requestBox);
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
			
		} catch ( SqlSessionException e ){
			
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 시설 패널티 현황 목록 조회(엑셀 다운로드)
	 * 
	 * @param requestBox
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
//	@RequestMapping(value = "/roomPenaltyListExcelDownload.do")
//	public String roomPenaltyListExcelDownload(
//			RequestBox requestBox, 
//			ModelMap model, 
//			HttpServletRequest request) throws Exception {
//		
////		if( requestBox.get("searchcoursetype").equals("") ) {
////			requestBox.put("searchcoursetype", "O");
////		}
//		 
//		 // 1. init
//    	Map<String, Object> head = new HashMap<String, Object>();
//    	
//    	String fileNm = "시설패널티현황목록";
//		// 엑셀 헤더명 정의
//		String[] head_name = {"No","ABO NO.","ABO 이름","패널티 유형","패널티 내용","적용 일자","프로그램 타입","제한시작일", "제한종료일"};
//		String[] head_id = {"HISTORYSEQ","ACCOUNT","ABONAME","TYPECODE","APPLYTYPECODE","GRANTDATE","TYPENAME","LIMITSTARTDATE","LIMITENDDATE"};
//		head.put("head_name", head_name);
//		head.put("head_id", head_id);
//
//    	// 2. 파일 이름
//		String sFileName = fileNm + ".xlsx";
//		
//		// 3. excel 양식 구성
//		List<Map<String, String>> dataList = roomPenaltyService.roomPenaltyExcelListSelect(requestBox);
//		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
//		model.addAttribute("type", "xlsx");
//		model.addAttribute("fileName", sFileName);
//		model.addAttribute("workbook", workbook);
//		
//		return "excelDownload";
//	}
	
}
