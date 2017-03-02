package amway.com.academy.manager.reservation.roomSubscriber.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSessionException;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;
import amway.com.academy.manager.reservation.basicPackage.service.BasicReservationService;
import amway.com.academy.manager.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;
import amway.com.academy.manager.reservation.roomSubscriber.service.RoomSubscriberService;

@Controller
@RequestMapping("/manager/reservation/roomSubscriber")
public class RoomSubscriberController extends BasicReservationController{
	@Autowired
	private RoomSubscriberService roomSubscriberService;
	
	@Autowired
	private BasicReservationService basicReservationService;
	/**
	 * 예약자 관리 페이지 호출
	 * @param codeVO
	 * @param model
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomSubscriberList.do")
	public String roomSubscriberListPage(CommonCodeVO codeVO, ModelMap model, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		/**--------------------------------검색 조건 조회-------------------------------------------*/
		
		// sessionApno
		String sessionApno = requestBox.getSession("sessionApno");
		//PP 코드 리스트
		model.addAttribute("ppCodeList", super.ppCodeList(sessionApno));
		//시설타입 코드 리스트
		model.addAttribute("roomtypecodelist", roomSubscriberService.searchRoomTypeCodeList(requestBox));
		//상태 코드 리스트
		model.addAttribute("reservationProgressFormCodeList", super.reservationProgressFormCodeList());
		
		//회원구분 코드리스트
		model.addAttribute("divisionMemverCodeList", super.divisionMemverCodeList());
		//검색조건 코드 리스트
		model.addAttribute("searchAccountTypeList", super.searchAccountTypeList());
		
		/**--------------------------------------------------------------------------------*/
		
		return "/manager/reservation/roomSubscriber/roomSubscriberList";
	}

	/**
	 * 예약자 관리 리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomSubscriberListAjax.do")
	public ModelAndView roomSubscriberListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(roomSubscriberService.roomSubscriberListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		/* customer needs : kr620207 */
		String sortOrderColumn = (String) requestBox.getString("sortColumn");
		if ("PURCHASEDATE".equals(sortOrderColumn)){
			requestBox.put("sortOrderColumn", "PURCHASEDATETIME");
		}
		
		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",roomSubscriberService.roomSubscriberListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 환불 내역 상세보기(아직 미완성)
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/roomRefundHistoryPop.do")
	public ModelAndView roomRefundHistoryPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		//TODO : 예약자 환불내역 상세보기 
		mav.addObject("roomRefundHistory", roomSubscriberService.roomRefundHistory(requestBox));
		
		return mav;
	}
	
	/**
	 * 예약자 관리 no show 유무 갱신
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/noShowCodeUpdateAjax.do")
	public ModelAndView noShowCodeUpdateAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{ 
			
   			roomSubscriberService.noShowCodeUpdateAjax(requestBox);
			
			// 불참(no show) 시설 패널티 지정/해제 등록 (rsvseq,roomseq, typeseq, cookmastercode)
			roomSubscriberService.noShowRoomPenaltyInsert(requestBox);
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
			
		} catch ( SqlSessionException e )
		{
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
	 * 예약자 관리 관리자 예약 취소(코드 갱신)
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/adminRoomCancelAjax.do")
	public ModelAndView adminRoomCancelAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			roomSubscriberService.adminRoomCancelAjax(requestBox);
			
			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
			
		} catch ( SqlSessionException e )
		{
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
	 * 해당 pp의 셀렉트 박스 조회
	 * @param model
	 * @param mav
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
//	@RequestMapping(value = "/searchRoomTypeAjax.do")
//	public ModelAndView searchRoomTypeAjax(ModelMap model,ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{
//		
//		Map<String, Object> rtnMap = new HashMap<String, Object>();
//		
//		// 리스트
//		rtnMap.put("dataList", roomSubscriberService.searchRoomTypeAjax(requestBox));
//		mav.setView(new JSONView());
//		mav.addObject("JSON_OBJECT",  rtnMap);
//		
//		return mav;
//	}
	
	@RequestMapping(value = "/searchSessionNameListAjax.do")
	public ModelAndView searchSessionNameListAjax(ModelMap model,ModelAndView mav, HttpServletRequest request, RequestBox requestBox) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		// 리스트
		rtnMap.put("dataList", basicReservationService.searchSessionNameList(requestBox));
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	@RequestMapping(value = "/roomSubscriberExcelDownload.do")
	public String roomSubscriberExcelDownload(RequestBox requestBox, ModelMap model, HttpServletRequest request) throws Exception{

		 // 1. init
   	Map<String, Object> head = new HashMap<String, Object>();
   	
   		String fileNm = "시설예약자현황목록";
		// 엑셀 헤더명 정의
		String[] headName = {"No","예약자","회원구분","핀/나이/지역","PP","시설명","시설타입","예약일", "세션", "시간", "신청일", "금액", "사유", "예약 상태"};
		String[] headId = {"ROW_NUM","ACCOUNT","MEMBERDIVISON","TEMP","PPNAME","ROOMNAME","TYPENAME","RESERVATIONDATE","SESSIONNAME", "SESSIONTIME", "PURCHASEDATE", "PAYMENTAMOUNT", "ADMINFIRSTREASON", "PAYMENTSTATUSNAME"};
		head.put("headName", headName);
		head.put("headId", headId);

   	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String>> dataList = roomSubscriberService.roomSubscriberExcelDownload(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
		
		return "excelDownload";
	}
}
