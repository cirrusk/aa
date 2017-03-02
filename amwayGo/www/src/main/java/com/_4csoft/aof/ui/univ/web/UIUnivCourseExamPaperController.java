/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.web.UnivBaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperTargetVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamPaperVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveExamPaperRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseExamPaperRS;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseActiveExamPaperService;
import com._4csoft.aof.univ.service.UnivCourseActiveExamPaperTargetService;
import com._4csoft.aof.univ.service.UnivCourseApplyElementService;
import com._4csoft.aof.univ.service.UnivCourseApplyService;
import com._4csoft.aof.univ.service.UnivCourseExamAnswerService;
import com._4csoft.aof.univ.service.UnivCourseExamPaperService;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseExamPaperController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 27.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseExamPaperController extends UnivBaseController {

	@Resource (name = "UnivCourseExamPaperService")
	protected UnivCourseExamPaperService courseExamPaperService;

	@Resource (name = "UnivCourseExamAnswerService")
	protected UnivCourseExamAnswerService courseExamAnswerService;

	@Resource (name = "UnivCourseApplyElementService")
	protected UnivCourseApplyElementService courseApplyElementService;

	@Resource (name = "UnivCourseActiveElementService")
	protected UnivCourseActiveElementService courseActiveElementService;

	@Resource (name = "UnivCourseActiveExamPaperService")
	protected UnivCourseActiveExamPaperService courseActiveExamPaperService;

	@Resource (name = "UnivCourseApplyService")
	protected UnivCourseApplyService courseApplyService;

	@Resource (name = "UnivCourseActiveExamPaperTargetService")
	protected UnivCourseActiveExamPaperTargetService courseActiveExamPaperTargetService;

	/**
	 * 개설과목 시험지 응시 팝업
	 * 
	 * @param req
	 * @param res
	 * @param courseExamPaper
	 * @param courseExamAnswer
	 * @param courseApply
	 * @param courseApplyElement
	 * @param courseActiveElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/exampaper/detail/layer.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamAnswerVO courseExamAnswer, UIUnivCourseApplyVO courseApply,
			UIUnivCourseApplyElementVO courseApplyElement, UIUnivCourseActiveElementVO courseActiveElement, UIUnivCourseActiveExamPaperVO courseActiveExamPaper)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper, courseApplyElement);

		UIUnivCourseActiveExamPaperRS detailCourseActiveExamPaper = (UIUnivCourseActiveExamPaperRS)courseActiveExamPaperService
				.getDetailByApplyMember(courseActiveExamPaper);
		mav.addObject("detailCourseExamPaper", detailCourseActiveExamPaper);
		UIUnivCourseExamPaperVO courseExamPaper = new UIUnivCourseExamPaperVO();
		courseExamPaper.setExamPaperSeq(detailCourseActiveExamPaper.getCourseActiveExamPaper().getExamPaperSeq());
		UIUnivCourseExamPaperRS detail = (UIUnivCourseExamPaperRS)courseExamPaperService.getDetail(courseExamPaper);
		mav.addObject("detailExamPaper", detail);

		mav.addObject("scoreTypeCd", detail.getCourseExamPaper().getScoreTypeCd());
		mav.addObject("score", detail.getCourseExamPaper().getExamPaperScore());

		// apply_element 값 입력
		if ("MIDDLE_FINAL_TYPE::QUIZ".equals(detailCourseActiveExamPaper.getCourseActiveExamPaper().getMiddleFinalTypeCd())
				|| "MIDDLE_FINAL_TYPE::EXAM".equals(detailCourseActiveExamPaper.getCourseActiveExamPaper().getMiddleFinalTypeCd())) {
			courseApplyElement.setBasicSupplementCd("BASIC_SUPPLEMENT::BASIC");
		} else {
			courseApplyElement.setBasicSupplementCd(detailCourseActiveExamPaper.getCourseActiveExamPaper().getBasicSupplementCd());
		}
		courseApplyElement.setReplaceYn("N");
		courseApplyElement.setEvaluateYn("Y");

		courseExamAnswerService.insertCourseExamAnswer(courseActiveExamPaper, detail.getCourseExamPaper(), courseApplyElement);

		courseExamAnswer.setExamPaperSeq(detail.getCourseExamPaper().getExamPaperSeq());
		List<ResultSet> listExamAnswer = courseExamAnswerService.getList(courseExamAnswer);
		mav.addObject("listExamAnswer", listExamAnswer);

		mav.addObject("detailCourseApply", courseApplyService.getDetail(courseApply));
		mav.addObject("detailCourseApplyElement", courseApplyElementService.getDetail(courseApplyElement));

		mav.setViewName("/univ/classroom/examPaper/detailCourseExamPaperPopup");
		return mav;
	}

	/**
	 * 강의실 메인 시험 제출후 실행할 ajax
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/exampaper/detail/ajax.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("targetNumber", HttpUtil.getParameter(req, "targetNumber", ""));
		mav.addObject("detailExamPaper", courseActiveExamPaperService.getExamPaperByApplyMember(courseActiveExamPaper));

		mav.setViewName("/univ/classroom/include/homeExamPaperListAjax");
		return mav;
	}

	/**
	 * 강의실 메인 퀴즈 제출후 실행할 ajax
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/quiz/detail/ajax.do")
	public ModelAndView detailQuiz(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::QUIZ");
		courseActiveExamPaper.setReferenceTypeCd("COURSE_ELEMENT_TYPE::QUIZ");

		mav.addObject("detailQuiz", courseActiveExamPaperService.getQuizByApplyMember(courseActiveExamPaper));

		mav.setViewName("/univ/classroom/include/homeQuizListAjax");
		return mav;
	}

	/**
	 * 강의실 메인 비학위시험 제출후 실행할 ajax
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/exampaper/nondegree/detail/ajax.do")
	public ModelAndView detailNonDegreeExamPaper(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper)
			throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::EXAM");
		courseActiveExamPaper.setReferenceTypeCd("COURSE_ELEMENT_TYPE::EXAM");

		mav.addObject("detailExamPaperNonDegree", courseActiveExamPaperService.getQuizByApplyMember(courseActiveExamPaper));

		mav.setViewName("/univ/classroom/include/homeExamPaperNonDegreeListAjax");
		return mav;
	}

	/**
	 * 강의실 메인 시험 결과 보기
	 * 
	 * @param req
	 * @param res
	 * @param courseExamAnswer
	 * @param courseApply
	 * @param courseApplyElement
	 * @param courseActiveElement
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/exampaper/result/detail/layer.do")
	public ModelAndView detailResult(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamAnswerVO courseExamAnswer,
			UIUnivCourseApplyVO courseApply, UIUnivCourseApplyElementVO courseApplyElement, UIUnivCourseActiveElementVO courseActiveElement,
			UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper, courseApplyElement);

		UIUnivCourseActiveExamPaperRS detailCourseActiveExamPaper = (UIUnivCourseActiveExamPaperRS)courseActiveExamPaperService
				.getDetailByApplyMember(courseActiveExamPaper);
		mav.addObject("detailCourseExamPaper", detailCourseActiveExamPaper);
		UIUnivCourseExamPaperVO courseExamPaper = new UIUnivCourseExamPaperVO();
		courseExamPaper.setExamPaperSeq(detailCourseActiveExamPaper.getCourseActiveExamPaper().getExamPaperSeq());
		UIUnivCourseExamPaperRS detail = (UIUnivCourseExamPaperRS)courseExamPaperService.getDetail(courseExamPaper);
		mav.addObject("detailExamPaper", detail);

		mav.addObject("scoreTypeCd", detail.getCourseExamPaper().getScoreTypeCd());
		mav.addObject("score", detail.getCourseExamPaper().getExamPaperScore());

		// apply_element 값 입력
		if (StringUtil.isNotEmpty(detailCourseActiveExamPaper.getCourseActiveExamPaper().getBasicSupplementCd())) {
			courseApplyElement.setBasicSupplementCd(detailCourseActiveExamPaper.getCourseActiveExamPaper().getBasicSupplementCd());
		} else {
			courseApplyElement.setBasicSupplementCd("BASIC_SUPPLEMENT::BASIC");
		}
		courseApplyElement.setReplaceYn("N");
		courseApplyElement.setEvaluateYn("Y");

		courseExamAnswerService.insertCourseExamAnswer(courseActiveExamPaper, detail.getCourseExamPaper(), courseApplyElement);

		courseExamAnswer.setExamPaperSeq(detail.getCourseExamPaper().getExamPaperSeq());
		List<ResultSet> listExamAnswer = courseExamAnswerService.getList(courseExamAnswer);
		mav.addObject("listExamAnswer", listExamAnswer);

		mav.setViewName("/univ/classroom/examPaper/detailCourseExamAnswerPopup");
		return mav;
	}

	/**
	 * 강의실 메인 오프라인 시험 결과 보기
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaperTarget
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/exampaper/offline/result/detail/layer.do")
	public ModelAndView detailofflineExam(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperTargetVO courseActiveExamPaperTarget)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detailCourseExamPaper", courseActiveExamPaperTargetService.getDetailForExamResult(courseActiveExamPaperTarget));

		mav.setViewName("/univ/classroom/examPaper/detailCourseExamOfflineAnswerPopup");

		return mav;
	}

}
