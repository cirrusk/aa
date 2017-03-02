/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveySubjectVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveSurveyRS;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseActiveSurveyService;
import com._4csoft.aof.univ.vo.UnivCourseActiveSurveyVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveSurveyController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 17.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseActiveSurveyController extends BaseController {

	@Resource (name = "UnivCourseActiveSurveyService")
	private UnivCourseActiveSurveyService courseActiveSurveyService;

	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService univCourseActiveEvaluateService;

	/**
	 * 개설과목 설문 목록
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSurvey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/survey/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyVO courseActiveSurvey) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveSurvey.copyShortcut();
		// 설문지 구분용 값
		courseActiveSurvey.setSurveySubjectTypeCd("SURVEY_SUBJECT_TYPE::COURSE");

		mav.addObject("surveyList", courseActiveSurveyService.getList(courseActiveSurvey));
		mav.addObject("courseActiveSurvey", courseActiveSurvey);
		mav.setViewName("/univ/courseActiveElement/survey/listCourseActiveSurvey");

		// 평가비율
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(courseActiveSurvey.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		return mav;
	}

	/**
	 * 개설과목 설문 등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSurvey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/survey/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyVO courseActiveSurvey) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveSurvey.copyShortcut();

		mav.addObject("courseActiveSurvey", courseActiveSurvey);
		mav.setViewName("/univ/courseActiveElement/survey/createCourseActiveSurvey");

		return mav;
	}

	/**
	 * 개설과목 설문 상세보기
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSurvey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/survey/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyVO courseActiveSurvey) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveSurvey.copyShortcut();

		UIUnivCourseActiveSurveyRS rs = (UIUnivCourseActiveSurveyRS)courseActiveSurveyService.getDetail(courseActiveSurvey.getCourseActiveSurveySeq());

		mav.addObject("detail", rs);
		mav.addObject("courseActiveSurvey", courseActiveSurvey);
		mav.setViewName("/univ/courseActiveElement/survey/detailCourseActiveSurvey");

		return mav;
	}

	/**
	 * 개설과목 설문 수정화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSurvey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/survey/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyVO courseActiveSurvey) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveSurvey.copyShortcut();

		UIUnivCourseActiveSurveyRS rs = (UIUnivCourseActiveSurveyRS)courseActiveSurveyService.getDetail(courseActiveSurvey.getCourseActiveSurveySeq());

		mav.addObject("detail", rs);
		mav.addObject("courseActiveSurvey", courseActiveSurvey);
		mav.setViewName("/univ/courseActiveElement/survey/editCourseActiveSurvey");

		return mav;
	}

	/**
	 * 개설과목 설문 등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSurvey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/survey/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyVO courseActiveSurvey,
			UIUnivSurveySubjectVO surveySubject) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveSurvey, surveySubject);
		surveySubject.setSurveyPaperTypeCd("SURVEY_PAPER_TYPE::GENERAL");
		surveySubject.setSurveySubjectTypeCd("SURVEY_SUBJECT_TYPE::COURSE");

		courseActiveSurveyService.insert(courseActiveSurvey, surveySubject);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 설문 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSurvey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/survey/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyVO courseActiveSurvey,
			UIUnivSurveySubjectVO surveySubject) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveSurvey, surveySubject);

		courseActiveSurveyService.update(courseActiveSurvey, surveySubject);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 설문 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSurvey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/survey/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyVO courseActiveSurvey) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveSurvey);

		courseActiveSurveyService.delete(courseActiveSurvey);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 설문 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSurvey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/survey/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyVO courseActiveSurvey) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveSurvey);

		List<UnivCourseActiveSurveyVO> voList = new ArrayList<UnivCourseActiveSurveyVO>();
		for (String index : courseActiveSurvey.getCheckkeys()) {
			UnivCourseActiveSurveyVO o = new UnivCourseActiveSurveyVO();
			o.setCourseActiveSurveySeq(courseActiveSurvey.getCourseActiveSurveySeqs()[Integer.parseInt(index)]);
			o.setCourseActiveSeq(courseActiveSurvey.getCourseActiveSeq());
			o.setSurveyPaperSeq(courseActiveSurvey.getCourseActiveSurveySeqs()[Integer.parseInt(index)]);
			o.setSurveySubjectSeq(courseActiveSurvey.getSurveySubjectSeqs()[Integer.parseInt(index)]);
			o.copyAudit(courseActiveSurvey);

			voList.add(o);
		}

		if (voList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseActiveSurveyService.deleteList(voList));
		}

		mav.setViewName("/common/save");
		return mav;
	}

}
