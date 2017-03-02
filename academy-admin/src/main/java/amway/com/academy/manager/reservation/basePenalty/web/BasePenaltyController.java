package amway.com.academy.manager.reservation.basePenalty.web;

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
import amway.com.academy.manager.reservation.basePenalty.service.BasePenaltyService;
import amway.com.academy.manager.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;

/**
 * 패널티 정책 관리
 * @author KR620226
 *
 */
@Controller
@RequestMapping(value = "/manager/reservation/basePenalty")
public class BasePenaltyController extends BasicReservationController {

	/**
	 * 패널티 정책 SERVICE
	 */
	@Autowired
	public BasePenaltyService basePenaltyService;
	
	/**
	 * 패널티 정책 조회 화면 이동 및 초기 설정
	 * 
	 * @param codeVO
	 * @param model
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePenaltyList.do")
	public String basePenaltyListPage(CommonCodeVO codeVO, 
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
		return "/manager/reservation/basePenalty/basePenaltyList";
	}
	
	/**
	 * 패널티 정책 목록 조회
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePenaltyListAjax.do")
	public ModelAndView basePenaltyListAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {

		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(basePenaltyService.basePenaltyListCountAjax(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		//리스트
		rtnMap.put("dataList", basePenaltyService.basePenaltyListAjax(requestBox));
		rtnMap.putAll(pageVO.toMapData());
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}

	/**
	 * 취소 패널티 등록 화면
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePenaltyCencelInsertPop.do")
	public ModelAndView basePenaltyCencelInsertFormAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception{
		
		mav.addObject("listtype", requestBox);
		
		return mav;
	}
	
	/**
	 * 취소 패널티 등록
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePenaltyCencelInsertAjax.do")
	public ModelAndView basePenaltyCencelInsertAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
		
		try{
			
			basePenaltyService.basePenaltyCencelInsertAjax(requestBox);
			
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
	 * 패널티 정책 No Show 패널티 등록 화면
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePenaltyNoShowInsertPop.do")
	public ModelAndView basePenaltyNoShowInsertFormAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception{
		
		mav.addObject("listtype", requestBox);
		
		return mav;
	}

	/**
	 * 패널티 정책 요리명장 패널티 등록 화면
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePenaltyCookingInsertPop.do")
	public ModelAndView basePenaltyCookingInsertFormAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception{
		
		List<?> penaltyTypeCodeList = super.penaltyTypeCodeList();
		model.addAttribute("penaltyTypeCodeList", penaltyTypeCodeList);
		
		List<?> periodTypeCodeListType2 = super.periodTypeCodeListType2();
		model.addAttribute("periodTypeCodeListType2", periodTypeCodeListType2);
		
		mav.addObject("listtype", requestBox);
		
		return mav;
	}
	
	/**
	 * 패널티 정책 수정 화면
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePenaltyUpdatePop.do")
	public ModelAndView basePenaltyUpdateFormAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception{
		
		/** 검색 조건 조회*/
		//상태
		List<?> stateCodeList = super.stateCodeList();
		model.addAttribute("stateCodeList", stateCodeList);
		
		//상세 정보
		model.addAttribute("dataDetail", basePenaltyService.basePenaltyDetailAjax(requestBox));
		
		mav.addObject("listtype", requestBox);
		
		return mav;
	}
	
	/**
	 * 패널티 수정
	 * 
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/basePenaltyUpdateAjax.do")
	public ModelAndView basePenaltyUpdateAjax(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav, 
			RequestBox requestBox) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		requestBox.put("sessionAccount", requestBox.getSession(SessionUtil.sessionAdno));
		
		try{
			
			basePenaltyService.basePenaltyUpdateAjax(requestBox);
			
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
	
//	@RequestMapping(value = "/basePlazaUpdateAjax.do")
//	public ModelAndView basePlazaUpdateAjax(ModelMap model, 
//			HttpServletRequest request, 
//			ModelAndView mav, 
//			RequestBox requestBox) throws Exception {
//		
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//		Map<String, Object> rtnMap = new HashMap<String, Object>();
//		
//		try{
//			
//			basePlazaService.basePlazaUpdateAjax(requestBox);
//			
//			basePlazaService.basePlazaHistoryInsert(requestBox);
//			
//			resultMap.put("errCode", "0");
//			resultMap.put("errMsg", "");
//			
//		} catch ( Exception e ){
//			
//			e.printStackTrace();
//			resultMap.put("errCode", "-1");
//			resultMap.put("errMsg", e.toString());
//		} finally {
//		}
//		
//		rtnMap.put("result", resultMap);
//		mav.setView(new JSONView());
//		mav.addObject("JSON_OBJECT", rtnMap);
//		
//		return mav;
//	}
	
//	@RequestMapping(value = "/basePlazaRowChangeUpdatePop.do")
//	public ModelAndView basePlazaRowChangeUpdateFormAjax(ModelMap model, 
//			HttpServletRequest request, 
//			ModelAndView mav, 
//			RequestBox requestBox) throws Exception{
//		
//		//리스트
//		mav.addObject("dataList", basePlazaService.basePlazaRowChangeListAjax(requestBox));
//		
//		return mav;
//	}
	
//	@RequestMapping(value = "/basePlazaRowChangeUpdateAjax.do")
//	public ModelAndView basePlazaRowChangeUpdateAjax(ModelMap model, 
//			HttpServletRequest request, 
//			ModelAndView mav,
//			RequestBox requestBox) throws Exception {
//		
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//		Map<String, Object> rtnMap = new HashMap<String, Object>();
//		
//		try{
//			
//			basePlazaService.basePlazaRowChangeUpdateAjax(requestBox);
//			
//			resultMap.put("errCode", "0");
//			resultMap.put("errMsg", "");
//			
//		} catch ( Exception e ){
//			
//			e.printStackTrace();
//			resultMap.put("errCode", "-1");
//			resultMap.put("errMsg", e.toString());
//		} finally {
//		}
//		
//		rtnMap.put("result", resultMap);
//		mav.setView(new JSONView());
//		mav.addObject("JSON_OBJECT", rtnMap);
//		
//		return mav;
//	}
	
//	@RequestMapping(value = "/basePlazaHistoryListPop.do")
//	public ModelAndView basePlazaHistoryListFormAjax(ModelMap model, 
//			HttpServletRequest request, 
//			ModelAndView mav, 
//			RequestBox requestBox) throws Exception{
//		
//		//리스트
//		mav.addObject("dataList", basePlazaService.basePlazaHistoryListAjax(requestBox));
//		
//		return mav;
//	}
	
}
