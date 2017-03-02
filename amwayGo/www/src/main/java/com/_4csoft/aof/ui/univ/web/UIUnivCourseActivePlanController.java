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

import com._4csoft.aof.ui.infra.web.UnivBaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActivePlanVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.univ.service.UnivCourseActivePlanService;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseMasterController.java
 * @Title : 강의계획서
 * @date : 2014. 2. 18.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseActivePlanController extends UnivBaseController {

	@Resource (name = "UnivCourseActivePlanService")
	private UnivCourseActivePlanService courseActivePlanService;

	/**
	 * 강의계획서 상세
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/usr/classroom/plan/detail/popup.do", "/usr/common/course/plan/detail/popup.do" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseActivePlanVO vo)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		setCourseActive(req, courseActive);

		vo.setCourseActiveSeq(courseActive.getCourseActiveSeq());
		// 강의계획서 상세 가져오기
		mav.addObject("detail", courseActivePlanService.getDetailCourseActivePlan(vo));

		mav.setViewName("/univ/classroom/plan/detailPlanPopup");
		return mav;
	}

}
