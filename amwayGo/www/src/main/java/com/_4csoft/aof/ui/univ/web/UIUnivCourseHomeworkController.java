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

import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.UnivBaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseHomeworkAnswerRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseHomeworkRS;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkAnswerService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkService;
import com._4csoft.aof.univ.vo.UnivCourseHomeworkAnswerVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseHomeworkController.java
 * @Title : 과제 컨트롤러
 * @date : 2014. 03. 10.
 * @author : 류정희
 * @descrption : 과제 컨트롤러
 */
@Controller
public class UIUnivCourseHomeworkController extends UnivBaseController {

	@Resource (name = "UnivCourseHomeworkService")
	private UnivCourseHomeworkService courseHomeworkService;

	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService elementService;

	@Resource (name = "UnivCourseHomeworkAnswerService")
	private UnivCourseHomeworkAnswerService courseHomeworkAnswerService;

	/**
	 * 과제 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/homework/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);
		setCourseActive(req, vo);

		Long courseApplySeq = Long.parseLong(req.getParameter("courseApplySeq"));

		homework.setShortcutCourseActiveSeq(vo.getCourseActiveSeq());
		homework.setCourseActiveSeq(vo.getCourseActiveSeq());
		homework.setCourseApplySeq(courseApplySeq);
		homework.setMemberSeq(vo.getRegMemberSeq());

		requiredSession(req);
		homework.copyShortcut();

		mav.addObject("itemList", courseHomeworkService.getListHomeworkUsr(homework));
		mav.addObject("homework", homework);
		mav.addObject("courseActive", vo);

		mav.setViewName("/univ/classroom/homework/listHomework");
		return mav;
	}

	/**
	 * 과제 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param univCourseHomework
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = { "/usr/classroom/homework/detail.do", "/usr/classroom/homework/detail/popup.do" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		setCourseActive(req, vo);

		UIUnivCourseHomeworkRS rs = (UIUnivCourseHomeworkRS)courseHomeworkService.getDetailHomeworkUsr(homework);
		UIUnivCourseHomeworkAnswerRS answerResult = null;

		if (rs != null) {
			if (rs.getAnswer() != null) {
				UnivCourseHomeworkAnswerVO answer = new UnivCourseHomeworkAnswerVO();
				answer.setHomeworkAnswerSeq(rs.getAnswer().getHomeworkAnswerSeq());

				answerResult = (UIUnivCourseHomeworkAnswerRS)courseHomeworkAnswerService.getDetailHomeworkAnswer(answer);
			}
		}

		mav.addObject("detail", rs);
		mav.addObject("answer", answerResult);
		mav.addObject("homework", homework);
		mav.addObject("courseActive", vo);

		if (req.getServletPath().endsWith("popup.do")) {
			mav.addObject("decorator", "popup");
		} else {
			mav.addObject("decorator", "classroom");
		}

		mav.setViewName("/univ/classroom/homework/detailHomework");
		return mav;
	}

	/**
	 * 과제제출 팝업 화면
	 * 
	 * @param req
	 * @param res
	 * @param univCourseHomework
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/homework/create/answer/popup.do")
	public ModelAndView createHomeworkAnswerPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIUnivCourseHomeworkVO homework)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		setCourseActive(req, vo);

		UIUnivCourseHomeworkRS rs = (UIUnivCourseHomeworkRS)courseHomeworkService.getDetailHomeworkUsr(homework);
		UIUnivCourseHomeworkAnswerRS answerResult = null;

		if (rs != null) {
			if (rs.getAnswer() != null) {
				UnivCourseHomeworkAnswerVO answer = new UnivCourseHomeworkAnswerVO();
				answer.setHomeworkAnswerSeq(rs.getAnswer().getHomeworkAnswerSeq());

				answerResult = (UIUnivCourseHomeworkAnswerRS)courseHomeworkAnswerService.getDetailHomeworkAnswer(answer);
			}
		}

		mav.addObject("detail", rs);
		mav.addObject("homework", homework);
		mav.addObject("homeworkInfo", courseHomeworkService.getDetailHomework(homework));
		mav.addObject("answer", answerResult);
		mav.addObject("courseActive", vo);
		mav.setViewName("/univ/classroom/homework/createHomeworkAnswerPopup");

		return mav;
	}

	/**
	 * 과제제출
	 * 
	 * @param req
	 * @param res
	 * @param univCourseHomework
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/homework/insert/answer.do")
	public ModelAndView insertHomeworkAnswer(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIUnivCourseHomeworkVO homework,
			UIUnivCourseHomeworkAnswerVO homeworkAnswer, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		int success = 0;

		requiredSession(req, homeworkAnswer, attach);
		setCourseActive(req, vo);

		success = courseHomeworkAnswerService.insertHomeworkAnswer(homeworkAnswer, attach);

		mav.addObject("result", success);
		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 과제수정
	 * 
	 * @param req
	 * @param res
	 * @param univCourseHomework
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/homework/update/answer.do")
	public ModelAndView updateHomeworkAnswer(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIUnivCourseHomeworkVO homework,
			UIUnivCourseHomeworkAnswerVO homeworkAnswer, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		int success = 0;

		requiredSession(req, homeworkAnswer, attach);
		setCourseActive(req, vo);

		success = courseHomeworkAnswerService.updateHomeworkAnswerUsr(homeworkAnswer, attach);

		mav.addObject("result", success);
		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 과제결과 팝업 화면
	 * 
	 * @param req
	 * @param res
	 * @param univCourseHomework
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/homework/detail/answer/popup.do")
	public ModelAndView detailHomeworkAnswerPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIUnivCourseHomeworkAnswerVO answer)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		setCourseActive(req, vo);

		UIUnivCourseHomeworkAnswerRS answerResult = null;

		if (answer.getHomeworkAnswerSeq() != null && answer.getHomeworkAnswerSeq() > 0) {
			answerResult = (UIUnivCourseHomeworkAnswerRS)courseHomeworkAnswerService.getDetailHomeworkAnswer(answer);
		}

		mav.addObject("answer", answerResult);
		mav.addObject("courseActive", vo);
		mav.setViewName("/univ/classroom/homework/detailHomeworkAnswerPopup");

		return mav;
	}

}
