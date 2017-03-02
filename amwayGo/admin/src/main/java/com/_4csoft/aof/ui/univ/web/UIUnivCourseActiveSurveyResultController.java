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

import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyPaperElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveSurveyRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivSurveyRS;
import com._4csoft.aof.univ.service.UnivCourseActiveSurveyAnswerService;
import com._4csoft.aof.univ.service.UnivCourseActiveSurveyService;
import com._4csoft.aof.univ.service.UnivSurveyPaperElementService;
import com._4csoft.aof.univ.service.UnivSurveyService;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveSurveyResultController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 24.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseActiveSurveyResultController extends BaseController {

	@Resource (name = "UnivCourseActiveSurveyService")
	private UnivCourseActiveSurveyService courseActiveSurveyService;

	@Resource (name = "UnivSurveyPaperElementService")
	private UnivSurveyPaperElementService univSurveyPaperElementService;

	@Resource (name = "UnivSurveyService")
	private UnivSurveyService surveyService;

	@Resource (name = "UnivCourseActiveSurveyAnswerService")
	private UnivCourseActiveSurveyAnswerService courseActiveSurveyAnswerService;

	/**
	 * 개설과목 설문 결과 목록
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSurvey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/result/survey/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyVO courseActiveSurvey) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveSurvey.copyShortcut();
		// 설문지 구분용 값
		courseActiveSurvey.setSurveySubjectTypeCd("SURVEY_SUBJECT_TYPE::COURSE");

		mav.addObject("surveyList", courseActiveSurveyService.getList(courseActiveSurvey));
		mav.addObject("courseActiveSurvey", courseActiveSurvey);
		mav.setViewName("/univ/surveyPaperResult/listCourseActiveSurveyResult");

		return mav;
	}

	/**
	 * 개설과목 설문 결과 상세정보
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSurvey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/result/survey/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyVO courseActiveSurvey) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveSurvey.copyShortcut();

		UIUnivCourseActiveSurveyRS rs = (UIUnivCourseActiveSurveyRS)courseActiveSurveyService.getDetail(courseActiveSurvey.getCourseActiveSurveySeq());

		if (rs != null) {

			UIUnivSurveyPaperElementVO univSurveyPaperElement = new UIUnivSurveyPaperElementVO();
			univSurveyPaperElement.setSurveyPaperSeq(rs.getCourseActiveSurvey().getSurveyPaperSeq());
			mav.addObject("listElement", univSurveyPaperElementService.getList(univSurveyPaperElement));
		}

		mav.addObject("detail", rs);
		mav.addObject("courseActiveSurvey", courseActiveSurvey);
		mav.setViewName("/univ/surveyPaperResult/detailCourseActiveSurveyResult");

		return mav;
	}

	/**
	 * 개설과목 설문 결과 문항 당 상세정보
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSurvey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/result/survey/detail/ajax.do")
	public ModelAndView detailSurveyAjax(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyAnswerVO vo,
			UIUnivCourseActiveSurveyVO courseActiveSurvey) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivSurveyVO surveyVO = new UIUnivSurveyVO();
		surveyVO.setSurveySeq(vo.getSurveySeq());
		UIUnivSurveyRS surveyRS = (UIUnivSurveyRS)surveyService.getDetail(surveyVO);
		mav.addObject("detailSurvey", surveyRS);

		if ("SURVEY_GENERAL_TYPE::ESSAY_ANSWER".equals(vo.getSurveyItemTypeCd())) {
			mav.addObject("surveyResult", courseActiveSurveyAnswerService.getEssayAnswerResult(vo));
		} else {
			mav.addObject("surveyResult", courseActiveSurveyAnswerService.getChoiceAnswerResult(vo));
		}

		mav.addObject("courseActiveSurvey", courseActiveSurvey);
		mav.setViewName("/univ/surveyPaperResult/detailCourseActiveSurveyResultAjax");
		return mav;
	}

}
