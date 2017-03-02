package amway.com.academy.manager.reservation.baseClause.web;

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

import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;
import amway.com.academy.manager.common.util.SessionUtil;
import amway.com.academy.manager.reservation.baseClause.service.BaseClauseService;
import amway.com.academy.manager.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;

@Controller
@RequestMapping("/manager/reservation/baseClause")
public class BaseClauseController extends BasicReservationController{
	@Autowired
	private BaseClauseService baseClauseService;

	/**
	 * 약관 관리 페이지 이동
	 * @param codeVO
	 * @param model
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseClauseList.do")
	public String baseClauseListPage(CommonCodeVO codeVO, ModelMap model, ModelAndView mav) throws Exception{
		
		/** 검색 조건 조회*/
		// 약관 타입 코드 리스트
		model.addAttribute("clauseTypeCodeList", super.clauseTypeCodeList());
		
		return "/manager/reservation/baseClause/baseClauseList";
	}
	
	/**
	 * 약관 관리 리스트
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseClauseListAjax.do")
	public ModelAndView baseClauseListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(baseClauseService.baseClauseListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",baseClauseService.baseClauseListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 약관 관리 등록 폼
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseClauseInsertPop.do")
	public ModelAndView baseClauseInsertFormAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		/** 검색 조건 조회*/
		// 약관 타입 코드 리스트
		model.addAttribute("clauseTypeCodeList", super.clauseTypeCodeList());
		
		//필수 여부 코드 리스트
		model.addAttribute("mandatoryCodeList", super.mandatoryCodeList());
		
		model.addAttribute("layPopData",requestBox);
		
		return mav;
	}
	
	/**
	 * 약관 관리 등록
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseClauseInsertAjax.do")
	public ModelAndView baseClauseInsertAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			baseClauseService.baseClauseInsertAjax(requestBox);
			
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
	 * 약관 관리 상세 팝업
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/baseClauseDetailPop.do")
	public ModelAndView baseClauseDetailPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		/** 검색 조건 조회*/
		// 약관 타입 코드 리스트
		model.addAttribute("clauseTypeCodeList", super.clauseTypeCodeList());
		
		//필수 여부 코드 리스트
		model.addAttribute("mandatoryCodeList", super.mandatoryCodeList());
		
		model.addAttribute("layPopData",requestBox);
		
		model.addAttribute("baseClauseDatail", baseClauseService.baseClauseDatail(requestBox));
		
		return mav;
	}
	
	@RequestMapping(value = "/baseClauseUpdateAjax.do")
	public ModelAndView baseClauseUpdate(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		try{
			
			baseClauseService.baseClauseUpdate(requestBox);
			
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
}
