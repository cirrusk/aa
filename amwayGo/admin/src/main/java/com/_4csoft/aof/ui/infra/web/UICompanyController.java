/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.CompanyMemberService;
import com._4csoft.aof.infra.service.CompanyService;
import com._4csoft.aof.infra.service.MemberService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.vo.CompanyVO;
import com._4csoft.aof.ui.infra.vo.UICompanyVO;
import com._4csoft.aof.ui.infra.vo.condition.UICompanyCondition;
import com._4csoft.aof.ui.infra.vo.condition.UIMemberCondition;

/**
 * @Project : aof5-demo-2-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UICompanyController.java
 * @Title : 소속
 * @date : 2013. 9. 2.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICompanyController extends BaseController {

	@Resource (name = "CompanyService")
	private CompanyService companyService;
	
	@Resource (name = "CompanyMemberService")
	private CompanyMemberService companyMemberService;
	
	@Resource (name = "MemberService")
	private MemberService memberService;

	/**
	 * 소속 목록 화면, 소속 목록 팝업 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICompanyCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/company/{companyType}/list.do", "/company/{companyType}/list/popup.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UICompanyCondition condition, @PathVariable ("companyType") String companyType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		if("cdms".equals(companyType)){
			condition.setSrchCompanyTypeCd("COMPANY_TYPE::CDMS");
		}
		
		mav.addObject("paginate", companyService.getList(condition));
		mav.addObject("condition", condition);
		mav.addObject("companyType", companyType);

		if (req.getServletPath().endsWith("popup.do")) {
			mav.setViewName("/infra/company/listCompanyPopup");
		} else {
			mav.setViewName("/infra/company/listCompany");
		}
		return mav;
	}

	/**
	 * 소속 상세 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICompanyVO
	 * @param UICompanyCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/company/{companyType}/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UICompanyVO company, UICompanyCondition condition, @PathVariable ("companyType") String companyType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", companyService.getDetail(company));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/company/detailCompany");
		return mav;
	}

	/**
	 * 소속 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICompanyCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/company/{companyType}/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UICompanyCondition condition, @PathVariable ("companyType") String companyType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);

		mav.setViewName("/infra/company/createCompany");
		return mav;
	}

	/**
	 * 소속 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICompanyVO
	 * @param UICompanyCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/company/{companyType}/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UICompanyVO company, UICompanyCondition condition, @PathVariable ("companyType") String companyType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", companyService.getDetail(company));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/company/editCompany");
		return mav;
	}

	/**
	 * 소속 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICompanyVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/company/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UICompanyVO company) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, company);

		companyService.insertCompany(company);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 소속 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICompanyVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/company/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UICompanyVO company) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, company);

		companyService.updateCompany(company);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 소속 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICompanyVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/company/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UICompanyVO company) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, company);
		
		int count = 0;
		if(companyMemberService.countMember(company.getCompanySeq()) > 0) {
			count = companyMemberService.countMember(company.getCompanySeq());
		} else {
			companyService.deleteCompany(company);
		}
		mav.addObject("result", count);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 소속 멀티 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/company/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UICompanyVO company) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, company);

		List<CompanyVO> companies = new ArrayList<CompanyVO>();
		for (String index : company.getCheckkeys()) {
			UICompanyVO o = new UICompanyVO();
			o.setCompanySeq(company.getCompanySeqs()[Integer.parseInt(index)]);
			o.copyAudit(company);

			companies.add(o);
		}

		if (companies.size() > 0) {
			mav.addObject("result", companyService.deletelistCompany(companies));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}
	
	/**
	 * 소속 멤버 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/company/member/list/ajax.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIMemberCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=10", "orderby=0");

		condition.setSrchMemberType("cdms");
		condition.setSrchCompanySeq(HttpUtil.getParameter(req, "srchCompanySeq", 0L));
		
		mav.addObject("paginate", memberService.getListAdmin(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/company/listCompanyMemberAjax");
		return mav;
	}

}
