package amway.com.academy.manager.reservation.expSubscriber.web;

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

import amway.com.academy.manager.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;
import amway.com.academy.manager.reservation.expSubscriber.service.ExpSubscriberService;
import amway.com.academy.manager.reservation.roomSubscriber.service.RoomSubscriberService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

@RequestMapping(value = "/manager/reservation/expSubscriber")
@Controller
public class ExpSubscriberContoller extends BasicReservationController{

	@Autowired
	private ExpSubscriberService expSubscriberService;
	
	@Autowired
	private RoomSubscriberService roomSubscriberService;
	
	/**
	 * 측정/체험_예약자 관리 페이지  호출
	 * @param codeVO
	 * @param model
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expSubscriberList.do")
	public String expSubscriberListPage(CommonCodeVO codeVO, ModelMap model, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		/**--------------------------------검색 조건 조회-------------------------------------------*/
		// sessionApno
		String sessionApno = requestBox.getSession("sessionApno");
		//PP 코드 리스트
		model.addAttribute("ppCodeList", super.ppCodeList(sessionApno));
		//시설타입 코드 리스트
		model.addAttribute("expTypeCodeList", expSubscriberService.searchExpTypeCodeList(requestBox));
		//상태 코드 리스트
		model.addAttribute("reservationProgressFormCodeList", super.reservationProgressFormCodeList());
		
		//회원구분 코드리스트
		model.addAttribute("divisionMemverCodeList", super.divisionMemverCodeList());
		//검색조건 코드 리스트
		model.addAttribute("searchAccountTypeList", super.searchAccountTypeList());
		
//		model.addAttribute("reservationManagerSessionCodeList", super.reservationManagerSessionCodeList());
		/**--------------------------------------------------------------------------------*/
		
		return "/manager/reservation/expSubscriber/expSubscriberList";
	}
	
	/**
	 * 측정/체험_예약자 관리  리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expSubscriberListAjax.do")
	public ModelAndView expSubscriberListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(expSubscriberService.expSubscriberListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		/* customer needs : kr620207 */
		String sortOrderColumn = (String) requestBox.getString("sortColumn");
		if ("PURCHASEDATE".equals(sortOrderColumn)){
			requestBox.put("sortOrderColumn", "PURCHASEDATETIME");
		}
		
		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",expSubscriberService.expSubscriberListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 측정/체험_예약자 관리
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/adminExpCancel.do")
	public ModelAndView adminExpCancelAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			expSubscriberService.adminExpCancelAjax(requestBox);
			
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
	 * 측정/체험_노쇼 지정/해지
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expNoShowConfirmChkeck.do")
	public ModelAndView expNoShowConfirmChkeck(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			expSubscriberService.expNoShowConfirmChkeck(requestBox);
			
			// 불참(no show) 체험 패널티 지정/해제 등록 (rsvseq, roomseq, typeseq, cookmastercode)
			expSubscriberService.noShowExpPenaltyInsert(requestBox);
			
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
	 * 측정/체험_pp선택시 해당 프로그램 타입 지정
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
//	@RequestMapping(value = "/searchProgramTypeAjax.do")
//	public ModelAndView searchProgramTypeAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
//		
//		Map<String, Object> rtnMap = new HashMap<String, Object>();
//		
//		// 리스트
//		rtnMap.put("dataList", expSubscriberService.searchProgramTypeAjax(requestBox));
//		mav.setView(new JSONView());
//		mav.addObject("JSON_OBJECT",  rtnMap);
//		
//		return mav;
//	}
//	
	@RequestMapping(value = "/searchExpSessionNameListAjax.do")
	public ModelAndView searchExpSessionNameListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		// 리스트
		rtnMap.put("dataList", basicReservationService.searchExpSessionNameList(requestBox));
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		
		return mav;
	}
	
	/**
	 * 엑셀 다운로드
	 * @param requestBox
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expSubscriberExcelDownload.do")
	public String expSubscriberExcelDownload(RequestBox requestBox, ModelMap model,	HttpServletRequest request) throws Exception{
		
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "측정체험예약자현황목록";
		// 엑셀 헤더명 정의
		String[] headName = {"No","이름","회원구분","예약자번호","핀/나이/지역","PP","프로그램 명","프로그램타입","예약일", "세션", "시간", "신청일", "사유", "예약 상태"};
		String[] headId = {"ROW_NUM","USERNAME","MEMBERDIVISON","ACCOUNT","TEMP","PPNAME","PRODUCTNAME","TYPENAME","RESERVATIONDATE","SESSIONNAME", "SESSIONTIME", "PURCHASEDATE", "ADMINFIRSTREASON", "PAYMENTSTATUSNAME"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String>> dataList = expSubscriberService.expSubscriberExcelDownload(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
		
		return "excelDownload";
	}
}
