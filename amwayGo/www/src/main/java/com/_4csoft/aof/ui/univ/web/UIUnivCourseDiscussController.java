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
import com._4csoft.aof.ui.infra.web.UnivBaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussVO;
import com._4csoft.aof.univ.service.UnivCourseDiscussService;

/**
 * 
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseDiscussController.java
 * @Title : 토론
 * @date : 2014. 3. 20.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseDiscussController extends UnivBaseController {

	@Resource (name = "UnivCourseDiscussService")
	private UnivCourseDiscussService univCourseDiscussService;

	/**
	 * 강의실의 토론 목록
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/discuss/list.do")
	public ModelAndView listDiscuss(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseDiscussVO discuss) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, discuss);
		setCourseActive(req, courseActive);

		discuss.setCourseActiveSeq(courseActive.getCourseActiveSeq());
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		discuss.setMemberSeq(ssMember.getMemberSeq());

		mav.addObject("itemList", univCourseDiscussService.getListAllCourseDiscussByUser(discuss));
		mav.addObject("courseApply", courseApply);

		mav.setViewName("/univ/classroom/discuss/listDiscuss");
		return mav;
	}

	/**
	 * 강의실의 토론 상세
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/discuss/detail.do")
	public ModelAndView detailDiscuss(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseDiscussVO discuss) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, discuss);
		setCourseActive(req, courseActive);

		discuss.setCourseActiveSeq(courseActive.getCourseActiveSeq());

		mav.addObject("detail", univCourseDiscussService.getDetailCourseDiscuss(discuss));
		mav.addObject("courseApply", courseApply);

		mav.setViewName("/univ/classroom/discuss/detailDiscuss");
		return mav;
	}

	/**
	 * 강의실의 토론 ajax 상세
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/discuss/detail/ajax.do")
	public ModelAndView detailDiscussAjax(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseDiscussVO discuss) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, discuss);

		mav.addObject("detail", univCourseDiscussService.getDetailCourseDiscussByUser(discuss));
		mav.addObject("courseApply", courseApply);

		mav.setViewName("/univ/classroom/include/homeDiscussListAjax");

		return mav;
	}

}
