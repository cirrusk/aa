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

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivYearTermVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivMonitoringController.java
 * @Title : 모니터링
 * @date : 2014. 3. 11.
 * @author : 장용기
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseActiveMonitoringController extends BaseController {

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	/**
	 * 학위 모니터링 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/monitoring/list.do")
	public ModelAndView listDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		// 시스템에 설정된 년도학기
		if (StringUtil.isEmpty(condition.getSrchYearTerm())) {
			if (ssMember.getExtendData().get("systemYearTerm") == null) {
				// 현재 년도의 1학기로 셋팅한다.
				String defaultTerm = "10";
				String yearTerm = DateUtil.getTodayYear() + defaultTerm;
				condition.setSrchYearTerm(yearTerm);
			} else {
				UnivYearTermVO univYearTermVO = (UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm");
				condition.setSrchYearTerm(univYearTermVO.getYearTerm());
			}
		}

		// 학위 과목
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::DEGREE");
		// 검색 조건의 년도학기
		mav.addObject("yearTerms", univYearTermService.getListYearTermAll());
		mav.addObject("paginate", courseActiveService.getListCourseActive(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/monitoring/listMonitoring");
		return mav;
	}
	
	/**
	 * 비학위 모니터링 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/monitoring/non/list.do")
	public ModelAndView listNonDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		// 시스템에 설정된 년도
		if (StringUtil.isEmpty(condition.getSrchYear())) {
			if (ssMember.getExtendData().get("systemYearTerm") == null) {
				// 현재 년도로 셋팅한다.
				condition.setSrchYear(String.valueOf(DateUtil.getTodayYear()));
			} else {
				UnivYearTermVO univYearTermVO = (UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm");
				condition.setSrchYear(univYearTermVO.getYear());
			}
		}

		// 비학위 과목
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::NONDEGREE");
		// 검색 조건의 년도
		mav.addObject("years", univYearTermService.getListYearAll());
		mav.addObject("paginate", courseActiveService.getListCourseActive(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/monitoring/listMonitoringNon");
		return mav;
	}
	
	/**
	 * MOOC 모니터링 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/monitoring/mooc/list.do")
	public ModelAndView listTrust(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		// 시스템에 설정된 년도
		if (StringUtil.isEmpty(condition.getSrchYear())) {
			if (ssMember.getExtendData().get("systemYearTerm") == null) {
				// 현재 년도로 셋팅한다.
				condition.setSrchYear(String.valueOf(DateUtil.getTodayYear()));
			} else {
				UnivYearTermVO univYearTermVO = (UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm");
				condition.setSrchYear(univYearTermVO.getYear());
			}
		}

		// 비학위 과목
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::MOOC");
		// 검색 조건의 년도
		mav.addObject("years", univYearTermService.getListYearAll());
		mav.addObject("paginate", courseActiveService.getListCourseActive(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/monitoring/listMonitoringMooc");
		return mav;
	}

}
