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
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyAccessHistoryCondition;
import com._4csoft.aof.univ.service.UnivCourseApplyAccessHistoryService;
import com._4csoft.aof.univ.service.UnivYearTermService;

/**
 * 
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseApplyAccessHistoryController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 4. 14.
 * @author : 김영학
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseApplyAccessHistoryController extends BaseController {

	@Resource (name = "UnivCourseApplyAccessHistoryService")
	private UnivCourseApplyAccessHistoryService applyAccessHistoryService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	/**
	 * 교과목접속통계
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/course/apply/access/history/statistics/list.do")
	public ModelAndView courselistStatisctics(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyAccessHistoryCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String srchYn = HttpUtil.getParameter(req, "srchYn", "N");

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		if ("Y".equals(srchYn)) {

			if (StringUtil.isNotEmpty(condition.getSrchStartRegDate())) {
				condition.setSrchStartRegDate(DateUtil.convertStartDate(condition.getSrchStartRegDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
			}
			if (StringUtil.isNotEmpty(condition.getSrchEndRegDate())) {
				condition.setSrchEndRegDate(DateUtil.convertEndDate(condition.getSrchEndRegDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
			}
			mav.addObject("paginate", applyAccessHistoryService.getListForStatistics(condition));
		}

		mav.addObject("yearTerms", univYearTermService.getListYearTermAll());
		mav.addObject("years", univYearTermService.getListYearAll());

		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseApplyAccessHistory/listCourseApplyAccessHistoryStatistics");
		return mav;
	}
}
