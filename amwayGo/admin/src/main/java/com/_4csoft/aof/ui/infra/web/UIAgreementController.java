/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.ui.infra.service.UIAgreementService;
import com._4csoft.aof.ui.infra.vo.UIAgreementCodeVO;
import com._4csoft.aof.ui.infra.vo.condition.UIAgreementCondition;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIRolegroupController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIAgreementController extends BaseController {

	@Resource (name = "UIAgreementService")
	private UIAgreementService agreementService;

	/**
	 * 약관 관리 리스트
	 * 
	 * @param req
	 * @param res
	 * @param UIAgreementCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/agreement/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIAgreementCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", agreementService.getListAgreement(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/agreement/listAgreement");
		return mav;
	}
	
	/**
	 * 약관 관리 상세보기 페이지
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/agreement/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIAgreementCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("agreement", agreementService.getDetailAgreement(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/agreement/detailAgreement");
		return mav;
	}
	
	/**
	 * 약관 관리 등록페이지
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/agreement/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIAgreementCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		
		List<UIAgreementCodeVO> agreeCodeVO = agreementService.getListCode();
		
		mav.addObject("codes", agreeCodeVO);

		mav.setViewName("/agreement/createAgreement");
		return mav;
	}
	
	/**
	 * 약관관리 등록하기
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/agreement/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIAgreementCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		condition.setAgreementMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		agreementService.insertAgreement(condition);
		
		mav.setViewName("/common/save");
		return mav;
	}
	
	/**
	 * 약관동의 불러오기
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param activeCondition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/course/agreement/list/popup.do")
	public ModelAndView createlistNondegree(HttpServletRequest req, HttpServletResponse res, UIAgreementCondition condition) throws Exception {
			ModelAndView mav = new ModelAndView();

			requiredSession(req);
			emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");


			mav.addObject("paginate", agreementService.getListAgreement(condition));
			mav.addObject("condition", condition);

			mav.setViewName("/agreement/listAgreePopup");
			return mav;
	}
	
	/**
	 * 약관동의 팝업 불러오기
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param activeCondition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/agreement/popup.do")
	public ModelAndView detailPopup(HttpServletRequest req, HttpServletResponse res, UIAgreementCondition condition) throws Exception {
			ModelAndView mav = new ModelAndView();
			
			requiredSession(req);
	
			mav.addObject("agreement", agreementService.getDetailAgreement(condition));
			mav.addObject("condition", condition);
	
			mav.setViewName("/agreement/detailPopup");
			return mav;
	}

}
