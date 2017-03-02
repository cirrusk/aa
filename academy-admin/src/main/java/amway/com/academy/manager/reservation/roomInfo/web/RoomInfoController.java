package amway.com.academy.manager.reservation.roomInfo.web;

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
import amway.com.academy.manager.reservation.roomInfo.service.RoomInfoService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.web.JSONView;

/**
 * 시설 예약 현황
 * @author KR620226
 *
 */
@Controller
@RequestMapping(value = "/manager/reservation/roomInfo")
public class RoomInfoController extends BasicReservationController {

	@Autowired
	public RoomInfoService roomInfoService;
	
	/**
	 * 시설 예약 현황 목록 화면 및 초기설정
	 * 
	 * @param codeVO
	 * @param model
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoList.do")
	public String roomPenaltyListPage(CommonCodeVO codeVO, 
			ModelMap model,
			ModelAndView mav,
			RequestBox requestBox) throws Exception {
		
		/** initializing **/
		/* 사용자의 담당 AP */
		String allowApCode = (String) requestBox.getSession("sessionApno");
		
        List<?> ppCodeList = super.ppCodeList(allowApCode);
        List<?> roomTypeCodeList = super.roomTypeInfoCodeList();
        List<?> reservationYearCodeList = super.reservationYearCodeList();
        List<?> reservationMonthCodeList = super.reservationMonthCodeList();
        DataBox reservationToday = super.reservationToday();
        
        model.addAttribute("ppCodeList", ppCodeList);
        model.addAttribute("roomTypeCodeList", roomTypeCodeList);
        model.addAttribute("reservationYearCodeList", reservationYearCodeList);
        model.addAttribute("reservationMonthCodeList", reservationMonthCodeList);
        model.addAttribute("reservationToday", reservationToday);
        
		/** finally forwarding page **/
		return "/manager/reservation/roomInfo/roomInfoList";
	}
	
	/**
	 * 해당 pp 시설 타입 목록 조회
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomTypeListAjax.do")
	public ModelAndView roomTypeListAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {

		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		List<DataBox> roomTypeList = roomInfoService.roomTypeListAjax(requestBox);
		rtnMap.put("roomTypeList", roomTypeList);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 해당 pp 해당 시설타입 년 월 별 예약 현황 조회
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoListAjax.do")
	public ModelAndView roomInfoListAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//해당 월 조회
		List<DataBox> roomInfoCalendar = roomInfoService.roomInfoCalendarAjax(requestBox);
		rtnMap.put("roomInfoCalendar", roomInfoCalendar);

		//예약 현황 세션 조회
		List<DataBox> roomInfoList = roomInfoService.roomInfoListAjax(requestBox);
		rtnMap.put("roomInfoList", roomInfoList);
		
		/** 파티션룸 체크 param-roomseq
		 * case1 파티션룸이 아님 (null)
		 * 	- 추가 조회 없음
		 * case2 합쳐진 파티션룸 (R1 + R2)
		 *  - RSVSAMEROOMINFO에서 해당 ROOMSEQ를 PARENTROOMSEQ로 갖고있는 시설들의 날짜별 예약정보 조회 
		 * case3 합쳐지지 않은 파티션룸 (R1, R2)
		 *  - PARENTROOMSEQ 로 날짜별 예약정보 조회
		 *  */
		List<DataBox> partitionRoomSeqList = roomInfoService.partitionRoomSeqList(requestBox);
		
		List<DataBox> partitionRoomFirstRsvList = null;
		List<DataBox> partitionRoomSecondRsvList = null;
		
		if(partitionRoomSeqList.isEmpty()){
			partitionRoomFirstRsvList = null;
		}else if(1 == partitionRoomSeqList.size()){
			requestBox.put("roomSeq", partitionRoomSeqList.get(0).get("roomseq"));
			partitionRoomFirstRsvList = roomInfoService.roomInfoListAjax(requestBox);
		}else{
			requestBox.put("roomSeq", partitionRoomSeqList.get(0).get("roomseq"));
			partitionRoomFirstRsvList = roomInfoService.roomInfoListAjax(requestBox);
			
			requestBox.put("roomSeq", partitionRoomSeqList.get(1).get("roomseq"));
			partitionRoomSecondRsvList = roomInfoService.roomInfoListAjax(requestBox);
		}
		
		rtnMap.put("partitionRoomFirstRsvList", partitionRoomFirstRsvList);
		rtnMap.put("partitionRoomSecondRsvList", partitionRoomSecondRsvList);
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 시설 예약현황 운영자 예약
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoAdminReservationInsertPop.do")
	public ModelAndView roomInfoAdminReservationInsertForm(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
		
		mav.addObject("dataList", roomInfoService.roomInfoAdminReservationSelectAjax(requestBox));
		mav.addObject("listtype", requestBox);
		
		return mav;
	}
	
	/**
	 * 시설 예약현황 목록 운영자 예약
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoAdminReservationListInsertAjax.do")
	public ModelAndView roomInfoAdminReservationListInsertAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
			roomInfoService.roomInfoAdminReservationListInsertAjax(requestBox);
			
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
	 * 시설 예약현황 운영자 예약 취소 화면
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoAdminReservationCancelPop.do")
	public ModelAndView roomInfoAdminReservationCancelForm(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		mav.addObject("dataList", roomInfoService.roomInfoAdminReservationCancelSelectAjax(requestBox));
		mav.addObject("listtype", requestBox);
		
		return mav;
	}
	
	/**
	 * 시설 예약현황 목록 운영자 예약 취소
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoAdminReservationListCancelUpdateAjax.do")
	public ModelAndView roomInfoAdminReservationListCancelUpdateAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
			roomInfoService.roomInfoAdminReservationListCancelUpdateAjax(requestBox);
			
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
	 * pp, 시설, 년, 월, 일 정보 조회
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoSessionSelectPop.do")
	public ModelAndView roomInfoSessionSelectDetailForm(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		mav.addObject("data", roomInfoService.roomInfoSessionSelectAjax(requestBox));
		mav.addObject("listtype", requestBox);
		
		return mav;
	}
	
	/**
	 * pp, 시설, 년, 월, 일 세션 정보 목록 조회
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomInfoSessionListAjax.do")
	public ModelAndView roomInfoSessionListAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			rtnMap.put("roomInfoSessionList", roomInfoService.roomInfoSessionListAjax(requestBox));
			
			/** 파티션룸 체크 param-roomseq
			 * case1 파티션룸이 아님 (null)
			 * 	- 추가 조회 없음
			 * case2 합쳐진 파티션룸 (R1 + R2)
			 *  - RSVSAMEROOMINFO에서 해당 ROOMSEQ를 PARENTROOMSEQ로 갖고있는 시설들의 날짜별 예약정보 조회 
			 * case3 합쳐지지 않은 파티션룸 (R1, R2)
			 *  - PARENTROOMSEQ 로 날짜별 예약정보 조회
			 *  */
			List<DataBox> partitionRoomSeqList = roomInfoService.partitionRoomSeqList(requestBox);
			
			List<DataBox> partitionRoomFirstSessionList = null;
			List<DataBox> partitionRoomSecondSessionList = null;
			
			if(partitionRoomSeqList.isEmpty()){
				partitionRoomFirstSessionList = null;
			}else if(1 == partitionRoomSeqList.size()){
				requestBox.put("roomSeq", partitionRoomSeqList.get(0).get("roomseq"));
				partitionRoomFirstSessionList = roomInfoService.roomInfoSessionListAjax(requestBox);
			}else{
				requestBox.put("roomSeq", partitionRoomSeqList.get(0).get("roomseq"));
				partitionRoomFirstSessionList = roomInfoService.roomInfoSessionListAjax(requestBox);
				
				requestBox.put("roomSeq", partitionRoomSeqList.get(1).get("roomseq"));
				partitionRoomSecondSessionList = roomInfoService.roomInfoSessionListAjax(requestBox);
			}
			
			rtnMap.put("partitionRoomFirstSessionList", partitionRoomFirstSessionList);
			rtnMap.put("partitionRoomSecondSessionList", partitionRoomSecondSessionList);
			
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
	@RequestMapping(value = "/roomInfoAdminReservationInsertAjax.do")
	public ModelAndView roomInfoAdminReservationInsertAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
			roomInfoService.roomInfoAdminReservationInsertAjax(requestBox);
			
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
	@RequestMapping(value = "/roomInfoAdminReservationCancelUpdateAjax.do")
	public ModelAndView roomInfoAdminReservationCancelUpdateAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
			roomInfoService.roomInfoAdminReservationCancelUpdateAjax(requestBox);
			
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
