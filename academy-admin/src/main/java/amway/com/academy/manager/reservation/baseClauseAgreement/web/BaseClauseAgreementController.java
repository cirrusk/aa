package amway.com.academy.manager.reservation.baseClauseAgreement.web;


import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;
import amway.com.academy.manager.reservation.baseClauseAgreement.service.BaseClauseAgreementService;
import amway.com.academy.manager.reservation.basicPackage.web.BasicReservationController;
import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;

@Controller
@RequestMapping("/manager/reservation/baseClauseAgreement")
public class BaseClauseAgreementController extends BasicReservationController{
	@Autowired
	private BaseClauseAgreementService baseClauseAgreementService;

	@RequestMapping(value = "/baseClauseAgreementList.do")
	public String baseClauseAgreementListPage(CommonCodeVO codeVO, ModelMap model, ModelAndView mav) throws Exception{
		/**--------------------------------검색 조건 조회-------------------------------------------*/
		//약관 타입
		model.addAttribute("clauseTypeCodeList", super.clauseTypeCodeList());
		//회원 구분
		model.addAttribute("divisionMemverCodeList", super.divisionMemverCodeList());
		//동의 여부
		model.addAttribute("agreementCodeList", super.agreementCodeList());
		//검색 조건 리스트
		model.addAttribute("searchAccountTypeList", super.searchAccountTypeList());
		/**--------------------------------------------------------------------------------*/
		
		return "/manager/reservation/baseClauseAgreement/baseClauseAgreementList";
	}
	
	@RequestMapping(value = "/baseClauseAgreementListAjax.do")
	public ModelAndView baseClauseAgreementListAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(baseClauseAgreementService.baseClauseAgreementListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",baseClauseAgreementService.baseClauseAgreementListAjax(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
}
