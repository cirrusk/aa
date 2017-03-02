/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActivePlanVO;
import com._4csoft.aof.univ.service.UnivCourseActivePlanService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseMasterController.java
 * @Title : 강의계획서
 * @date : 2014. 2. 18.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseActivePlanController extends BaseController {

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "UnivCourseActivePlanService")
	private UnivCourseActivePlanService courseActivePlanService;

	/**
	 * 강의계획서 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/plan/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActivePlanVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		// 검색 조건의 년도학기
		mav.addObject("yearTerms", courseActiveService.getListChargeOfYearTerm(ssMember.getMemberSeq(), vo.getShortcutCategoryTypeCd()));

		// 강의계획서 상세 가져오기
		mav.addObject("detail", courseActivePlanService.getDetailCourseActivePlan(vo));

		mav.setViewName("/univ/courseActiveElement/courseActivePlan/editActivePlan");
		return mav;
	}

	/**
	 * 강의계획서 상세
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/plan/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActivePlanVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		// 검색 조건의 년도학기
		mav.addObject("yearTerms", courseActiveService.getListChargeOfYearTerm(ssMember.getMemberSeq(), vo.getShortcutCategoryTypeCd()));

		vo.setCourseActiveSeq(vo.getShortcutCourseActiveSeq());
		// 강의계획서 상세 가져오기
		mav.addObject("detail", courseActivePlanService.getDetailCourseActivePlan(vo));

		mav.setViewName("/univ/courseActiveElement/courseActivePlan/detailActivePlan");
		return mav;
	}

	/**
	 * 강의계획서 수정
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/plan/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActivePlanVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		courseActivePlanService.saveCourseActivePlan(vo);

		mav.setViewName("/common/save");
		return mav;
	}

}
