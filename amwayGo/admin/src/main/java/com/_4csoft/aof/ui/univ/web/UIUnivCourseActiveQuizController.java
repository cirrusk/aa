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
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveExamPaperRS;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseActiveExamPaperService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.vo.UnivCourseActiveExamPaperVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveQuizController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 13.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */

@Controller
public class UIUnivCourseActiveQuizController extends BaseController {

	@Resource (name = "UnivCourseActiveExamPaperService")
	private UnivCourseActiveExamPaperService courseActiveExamPaperService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService univCourseActiveEvaluateService;

	/**
	 * 개설과목 퀴즈 목록
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		/** TODO : 코드 */
		courseActiveExamPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::QUIZ");

		mav.addObject("quizList", courseActiveExamPaperService.getList(courseActiveExamPaper));
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.setViewName("/univ/courseActiveElement/quiz/listCourseActiveQuiz");

		// 평가비율
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(courseActiveExamPaper.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		return mav;
	}

	/**
	 * 개설과목 퀴즈 상세보기
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		UIUnivCourseActiveExamPaperRS rs = (UIUnivCourseActiveExamPaperRS)courseActiveExamPaperService.getDetail(courseActiveExamPaper);

		mav.addObject("detail", rs);
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.setViewName("/univ/courseActiveElement/quiz/detailCourseActiveQuiz");

		return mav;
	}

	/**
	 * 개설과목 퀴즈 수정화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper,
			UIUnivCourseActiveVO courseActive) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		UIUnivCourseActiveExamPaperRS rs = (UIUnivCourseActiveExamPaperRS)courseActiveExamPaperService.getDetail(courseActiveExamPaper);

		mav.addObject("detail", rs);
		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.setViewName("/univ/courseActiveElement/quiz/editCourseActiveQuiz");

		return mav;
	}

	/**
	 * 개설과목 퀴즈 등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @param courseActive
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper,
			UIUnivCourseActiveVO courseActive) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		// 개설과목 상세 조회 - masterSeq
		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.setViewName("/univ/courseActiveElement/quiz/createCourseActiveQuiz");

		return mav;
	}

	/**
	 * 개설과목 퀴즈 등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		courseActiveExamPaperService.insertQuiz(courseActiveExamPaper, "QUIZ");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 퀴즈 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		courseActiveExamPaperService.updateQuiz(courseActiveExamPaper, "QUIZ");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 퀴즈 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		courseActiveExamPaperService.deleteQuiz(courseActiveExamPaper, "QUIZ");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 퀴즈 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/deletelist.do")
	public ModelAndView deleteList(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		List<UnivCourseActiveExamPaperVO> voList = new ArrayList<UnivCourseActiveExamPaperVO>();
		for (String index : courseActiveExamPaper.getCheckkeys()) {
			UnivCourseActiveExamPaperVO o = new UnivCourseActiveExamPaperVO();
			o.setCourseActiveExamPaperSeq(courseActiveExamPaper.getCourseActiveExamPaperSeqs()[Integer.parseInt(index)]);
			o.setExamPaperSeq(courseActiveExamPaper.getExamPaperSeqs()[Integer.parseInt(index)]);
			o.setCourseActiveSeq(courseActiveExamPaper.getCourseActiveSeq());
			o.copyAudit(courseActiveExamPaper);

			voList.add(o);
		}

		if (voList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseActiveExamPaperService.deletelistQuiz(voList, "QUIZ"));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 퀴즈 비율 수정
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/rate/update.do")
	public ModelAndView updaterate(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		List<UnivCourseActiveExamPaperVO> voList = new ArrayList<UnivCourseActiveExamPaperVO>();

		for (int index = 0; index < courseActiveExamPaper.getCourseActiveExamPaperSeqs().length; index++) {
			UnivCourseActiveExamPaperVO o = new UnivCourseActiveExamPaperVO();
			o.setCourseActiveExamPaperSeq(courseActiveExamPaper.getCourseActiveExamPaperSeqs()[index]);
			o.setCourseActiveSeq(courseActiveExamPaper.getCourseActiveSeq());
			o.setRate(courseActiveExamPaper.getRates()[index]);
			o.setMiddleFinalTypeCd(courseActiveExamPaper.getMiddleFinalTypeCds()[index]);
			o.copyAudit(courseActiveExamPaper);
			voList.add(o);
		}

		if (voList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseActiveExamPaperService.updateRate(voList));
		}

		mav.setViewName("/common/save");
		return mav;
	}

}
