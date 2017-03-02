package amway.com.academy.manager.reservation.expPenalty.web;

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

import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;
import amway.com.academy.manager.reservation.expPenalty.service.ExpPenaltyService;
import amway.com.academy.manager.reservation.expSubscriber.service.ExpSubscriberService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.ExcelUtil;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * 측정/체험 패널티 현황
 * @author KR620226
 *
 */
@Controller
@RequestMapping(value = "/manager/reservation/expPenalty")
public class ExpPenaltyController extends BasicReservationController {

	/**
	 * 측정/체험 패널티 SERVICE
	 */
	@Autowired
	public ExpPenaltyService expPenaltyService;
	
	@Autowired
	public ExpSubscriberService expSubscriberService;
	
	/**
	 * 측정/체험 패널티 현황 목록 화면 및 초기설정
	 * 
	 * @param codeVO
	 * @param model
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expPenaltyList.do")
	public String expPenaltyListPage(CommonCodeVO codeVO, 
			ModelMap model,
			ModelAndView mav) throws Exception {
//		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		/** initializing **/
        List<?> penaltyTypeCodeList = super.penaltyTypeCodeList();
        List<?> penaltyApplyTypeCodeList = super.penaltyApplyTypeCodeList();
        List<?> searchAccountTypeList = super.searchAccountTypeList();
        
        /** select-box setting area **/
//        rtnMap.put("penaltyTypeCodeList",  penaltyTypeCodeList);
//        rtnMap.put("penaltyApplyTypeCodeList",  penaltyApplyTypeCodeList);
        
        model.addAttribute("penaltyTypeCodeList", penaltyTypeCodeList);
        model.addAttribute("penaltyApplyTypeCodeList", penaltyApplyTypeCodeList);
        model.addAttribute("searchAccountTypeList", searchAccountTypeList);
        
		/** finally forwarding page **/
		return "/manager/reservation/expPenalty/expPenaltyList";
	}
	
	/**
	 * 측정/체험 패널티 현황 목록 조회
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expPenaltyListAjax.do")
	public ModelAndView roomPenaltyListAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {

		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(expPenaltyService.expPenaltyListCountAjax(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		//리스트
		rtnMap.put("dataList", expPenaltyService.expPenaltyListAjax(requestBox));
		rtnMap.putAll(pageVO.toMapData());
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 측정/체험 패널티 현황 상세보기
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expPenaltyDetailPop.do")
	public ModelAndView expPenaltyDetailFormAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception{
		
		//리스트
		model.addAttribute("dataDetail", expPenaltyService.expPenaltyDetailAjax(requestBox));
		
		return mav;
	}
	
	/**
	 * 측정/체험 패널티 해제
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expPenaltyCancelLimitUpdateAjax.do")
	public ModelAndView expPenaltyCancelLimitUpdateAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
		
		try{
			
			expPenaltyService.expPenaltyCancelLimitUpdateAjax(requestBox);
			expSubscriberService.expNoShowConfirmChkeck(requestBox);
			
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
	 * 측정/체험 패널티 현황 목록 조회(엑셀 다운로드)
	 * 
	 * @param requestBox
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/expPenaltyListExcelDownload.do")
	public String expPenaltyListExcelDownload(
			RequestBox requestBox, 
			ModelMap model, 
			HttpServletRequest request) throws Exception {
		
//		if( requestBox.get("searchcoursetype").equals("") ) {
//			requestBox.put("searchcoursetype", "O");
//		}
		 
		 // 1. init
    	Map<String, Object> head = new HashMap<String, Object>();
    	
    	String fileNm = "측정체험패널티현황목록";
		// 엑셀 헤더명 정의
		String[] headName = {"No","이름","회원구분","예약자번호","패널티유형","패널티내용","적용일자","프로그램타입","제한시작일", "제한종료일"};
		String[] headId = {"ROW_NUM","ABONAME","TEMP","ACCOUNT","TYPECODE","APPLYTYPECODE","GRANTDATE","TYPENAME","LIMITSTARTDATE","LIMITENDDATE"};
		head.put("headName", headName);
		head.put("headId", headId);

    	// 2. 파일 이름
		String sFileName = fileNm + ".xlsx";
		
		// 3. excel 양식 구성
		List<Map<String, String>> dataList = expPenaltyService.expPenaltyExcelListSelect(requestBox);
		XSSFWorkbook workbook = ExcelUtil.getExcelExport(dataList, sFileName, head, "");
		model.addAttribute("type", "xlsx");
		model.addAttribute("fileName", sFileName);
		model.addAttribute("workbook", workbook);
		
		return "excelDownload";
	}
	
}
