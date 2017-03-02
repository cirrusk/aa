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
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.service.UIUnivCourseQuizAnswerService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseQuizAnswerVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseQuizAnswerCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseQuizAnswerRS;

/**
 * @Project : lgaca-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseQuizAnswerController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 13.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseQuizAnswerController extends BaseController {

	@Resource (name = "UIUnivCourseQuizAnswerService")
	private UIUnivCourseQuizAnswerService courseQuizAnswerService;

	/**
	 * 퀴즈 결과
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/answer/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseQuizAnswerCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		Long courseActiveSeq = HttpUtil.getParameter(req, "shortcutCourseActiveSeq", 0L);
		condition.setSrchCourseActiveSeq(courseActiveSeq);
		
		mav.addObject("paginate", courseQuizAnswerService.getListQuiz(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/quizResult/listQuizResult");
		return mav;
	}

	/**
	 * 퀴즈 응답 결과
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/answer/detail/ajax.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseQuizAnswerVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("itemList", courseQuizAnswerService.getListQuizAnswer(vo));

		mav.setViewName("/univ/quizResult/detailQuizResultAjax");
		return mav;
	}
	
	/**
	 * 퀴즈 응답 결과 팝업
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/answer/detail/popup.do")
	public ModelAndView detailPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseQuizAnswerVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		requiredSession(req);
		UIUnivCourseQuizAnswerRS answerRS = (UIUnivCourseQuizAnswerRS)courseQuizAnswerService.getDetailQuiz(vo);
		mav.addObject("detail",answerRS);
		if(answerRS != null){
			if("EXAM_ITEM_TYPE::004".equals(answerRS.getCourseExamItem().getExamItemTypeCd())){
				mav.addObject("itemList", courseQuizAnswerService.getListQuizShortAnswer(vo));
			}else{
				mav.addObject("itemList", courseQuizAnswerService.getListQuizAnswer(vo));
			}
		}
		mav.addObject("vo", vo);
		
		mav.setViewName("/univ/quizResult/detailQuizResultPopup");
		return mav;
	}
	
	
	/**
	 * 퀴즈 응답 결과 팝업
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/session/list.do")
	public ModelAndView detailSessionRoom(HttpServletRequest req, HttpServletResponse res, UIUnivCourseQuizAnswerVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		requiredSession(req);
		 
		//mav.addObject("itemList", courseQuizAnswerService.getListQuizAnswer(vo));
		mav.addObject("vo", vo);
		
		mav.setViewName("/univ/quizResult/listQuizSession");
		return mav;
	}
	
	/**
	 * 퀴즈 결과
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/answer/listSession.do")
	public ModelAndView listAnswer(HttpServletRequest req, HttpServletResponse res, UIUnivCourseQuizAnswerCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		Long courseActiveSeq = HttpUtil.getParameter(req, "shortcutCourseActiveSeq", 0L);
		condition.setSrchCourseActiveSeq(courseActiveSeq);

		mav.addObject("paginate", courseQuizAnswerService.getListQuiz(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/quizResult/listQuizResult");
		return mav;
	}
	
	/**
	 * 퀴즈 응답 ajax
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/answer/detail/ajax2.do")
	public ModelAndView ajax(HttpServletRequest req, HttpServletResponse res, UIUnivCourseQuizAnswerVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		requiredSession(req);
		UIUnivCourseQuizAnswerRS answerRS = (UIUnivCourseQuizAnswerRS)courseQuizAnswerService.getDetailQuiz(vo);
		mav.addObject("detail",answerRS);
		if(answerRS != null){
			if("EXAM_ITEM_TYPE::004".equals(answerRS.getCourseExamItem().getExamItemTypeCd())){
				mav.addObject("itemList", courseQuizAnswerService.getListQuizShortAnswer(vo));
			}else{
				mav.addObject("itemList", courseQuizAnswerService.getListQuizAnswer(vo));
			}
		}
		mav.setViewName("jsonView");
		return mav;
	}
	
	/**
	 * 퀴즈 결과
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/answer/session/list.do")
	public ModelAndView listSession(HttpServletRequest req, HttpServletResponse res, UIUnivCourseQuizAnswerCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		Long courseActiveSeq = HttpUtil.getParameter(req, "shortcutCourseActiveSeq", 0L);
		condition.setSrchCourseActiveSeq(courseActiveSeq);
		
		mav.addObject("paginate", courseQuizAnswerService.getListQuiz(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/quizResult/listQuizResultSession");
		return mav;
	}
	
	/**
	 * 퀴즈 결과 목록 ajax
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/answer/session/ajax.do")
	public ModelAndView listAjax(HttpServletRequest req, HttpServletResponse res, UIUnivCourseQuizAnswerCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		Long courseActiveSeq = HttpUtil.getParameter(req, "shortcutCourseActiveSeq", 0L);
		condition.setSrchCourseActiveSeq(courseActiveSeq);
		
		Paginate<ResultSet> list =courseQuizAnswerService.getListQuiz(condition);
		if(list != null){
			if(list.getTotalCount() > 0){
				mav.addObject("paginate", list);
			}else{
				mav.addObject("paginate", null);
			}
		}else{
			mav.addObject("paginate", null);
		}
		
		mav.addObject("condition", condition);

		mav.setViewName("jsonView");
		return mav;
	}
}
