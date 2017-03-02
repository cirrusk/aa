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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivYearTermVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivYearTermService;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 3.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseActiveController extends BaseController {

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;
	
	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;
	
	/**
	 * 개설과목 > 학위과정 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/univ/course/active/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 현재년도학기 구하기
		UIUnivYearTermVO vo = (UIUnivYearTermVO) univYearTermService.getSystemYearTerm(SessionUtil.getMember(req).getCurrentRoleCfString());
		if(!"/usr/univ/course/apply/list/ajax.do".equals(req.getServletPath())){
			condition.setSrchYearTerm(vo.getYearTerm());
		}
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::DEGREE");
		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		
		mav.addObject("nowYearTerm", vo);
		mav.addObject("paginate", courseActiveService.getListCourseActiveUser(condition));
		mav.addObject("condition", condition);
		
		mav.setViewName("/univ/courseActive/listCourseActive");
		return mav;
	}

	/**
	 * 개설과목 > 비학위과정 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/univ/course/active/{courseType}/list.do")
	public ModelAndView listNon(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveCondition condition, @PathVariable ("courseType") String courseType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 현재년도
		condition.setSrchYear(Integer.toString(DateUtil.getTodayYear()));
		if("non".equals(courseType)){
			condition.setSrchCategoryTypeCd("CATEGORY_TYPE::NONDEGREE");
		} else if("mooc".equals(courseType)) {
			condition.setSrchCategoryTypeCd("CATEGORY_TYPE::MOOC");
		}
		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		
		mav.addObject("paginate", courseActiveService.getListCourseActiveUser(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseActive/listCourseActive"+ StringUtil.capitalize(courseType));
		return mav;
	}

}
