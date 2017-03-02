package amway.com.academy.manager.reservation.basePlaza.web;

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
import amway.com.academy.manager.reservation.basePlaza.service.BasePlazaService;
import amway.com.academy.manager.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * pp정보 관리
 * @author KR620226
 *
 */
@Controller
@RequestMapping(value = "/manager/reservation/basePlaza")
public class BasePlazaController extends BasicReservationController {

	/**
	 * pp정보 SERVICE
	 */
	@Autowired
	public BasePlazaService basePlazaService;
	
	/**
	 * pp정보 조회 화면 이동 및 초기 설정
	 * 
	 * @param codeVO
	 * @param model
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePlazaList.do")
	public String basePlazaListPage(CommonCodeVO codeVO, 
			ModelMap model,
			ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		/** initializing **/
        List<?> useStateCodeList = super.useStateCodeList();
        
        /** select-box setting area **/
        rtnMap.put("useStateCodeList",  useStateCodeList);

        
        /** return value setting area **/
		model.addAttribute("useStateCodeList", useStateCodeList);
        
		/** finally forwarding page **/
		return "/manager/reservation/basePlaza/basePlazaList";
	}
	
	/**
	 * pp정보 목록 조회
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePlazaListAjax.do")
	public ModelAndView basePlazaListAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {

		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(basePlazaService.basePlazaListCountAjax(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		//리스트
		rtnMap.put("dataList", basePlazaService.basePlazaListAjax(requestBox));
		rtnMap.putAll(pageVO.toMapData());
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}

	/**
	 * pp등록 팝업
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePlazaInsertPop.do")
	public ModelAndView basePlazaInsertFormAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception{
		
		/** 검색 조건 조회*/
		//상태
		List<?> useStateCodeList = super.useStateCodeList();
		model.addAttribute("useStateCodeList", useStateCodeList);
		
		model.addAttribute("lyData", requestBox);
		
		return mav;
	}
	
//	@RequestMapping(value = "/reservationTypeDetailAjax.do")
//	public ModelAndView reservationTypeDetailAjax(ModelMap model, 
//			HttpServletRequest request, 
//			ModelAndView mav, 
//			RequestBox requestBox) throws Exception {
//		
//		mav.setView(new JSONView());
//		mav.addObject("JSON_OBJECT", reservationTypeService.reservationTypeDetailAjax(requestBox));
//		
//		return mav;
//	}
	
	/**
	 * pp 등록 
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePlazaInsertAjax.do")
	public ModelAndView basePlazaInsertAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
		
		try{
			
			basePlazaService.basePlazaInsertAjax(requestBox);
			
			basePlazaService.basePlazaHistoryInsert(requestBox);
			
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
	 * pp정보 수정 팝업
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePlazaUpdatePop.do")
	public ModelAndView basePlazaUpdateFormAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception{
		
		/** 검색 조건 조회*/
		//상태
		List<?> useStateCodeList = super.useStateCodeList();
		model.addAttribute("useStateCodeList", useStateCodeList);
		
		//상세 정보
		model.addAttribute("dataDetail", basePlazaService.basePlazaDetailAjax(requestBox));

		model.addAttribute("lyData", requestBox);
		
		return mav;
	}
	
	/**
	 * pp정보 수정
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePlazaUpdateAjax.do")
	public ModelAndView basePlazaUpdateAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
		
		try{
			
			basePlazaService.basePlazaUpdateAjax(requestBox);
			
			basePlazaService.basePlazaHistoryInsert(requestBox);
			
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
	
//	@RequestMapping(value = "/reservationTypeUpdateAjax.do")
//	public ModelAndView reservationTypeUpdateAjax(ModelMap model, 
//			HttpServletRequest request, 
//			ModelAndView mav, 
//			RequestBox requestBox) throws Exception {
//		
//		reservationTypeService.reservationTypeUpdateAjax(requestBox);
//		
//		return mav;
//	}
	
	/**
	 * pp 노출순서 지정 팝업
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePlazaRowChangeUpdatePop.do")
	public ModelAndView basePlazaRowChangeUpdateFormAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception{
		
		//리스트
		mav.addObject("dataList", basePlazaService.basePlazaRowChangeListAjax(requestBox));
		

		model.addAttribute("lyData", requestBox);
		
		return mav;
	}
	
	/**
	 *  pp 노출순서 지정
	 *  
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePlazaRowChangeUpdateAjax.do")
	public ModelAndView basePlazaRowChangeUpdateAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav,
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));

		try{
			
			basePlazaService.basePlazaRowChangeUpdateAjax(requestBox);
			
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
	 * pp정보 수정 이력 조회
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePlazaHistoryListPop.do")
	public ModelAndView basePlazaHistoryListFormAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception{
		
		//리스트
		mav.addObject("dataList", basePlazaService.basePlazaHistoryListAjax(requestBox));
		
		return mav;
	}
	
}
