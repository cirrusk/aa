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

import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.web.UnivBaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyPaperAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyPaperElementVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveSurveyRS;
import com._4csoft.aof.univ.service.UnivCourseActiveSurveyPaperAnswerService;
import com._4csoft.aof.univ.service.UnivCourseActiveSurveyService;
import com._4csoft.aof.univ.service.UnivSurveyPaperElementService;
import com._4csoft.aof.univ.vo.UnivCourseActiveSurveyAnswerVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseSurveyPaperController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 18.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseSurveyPaperController extends UnivBaseController {

	@Resource (name = "UnivCourseActiveSurveyService")
	private UnivCourseActiveSurveyService courseActiveSurveyService;

	@Resource (name = "UnivSurveyPaperElementService")
	private UnivSurveyPaperElementService surveyPaperElementService;

	@Resource (name = "UnivCourseActiveSurveyPaperAnswerService")
	private UnivCourseActiveSurveyPaperAnswerService courseActiveSurveyPaperAnswerService;

	/**
	 * test용 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/surveypaper/test/list.do")
	public ModelAndView listTestData(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseActiveSurveyVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		setCourseActive(req, courseActive);

		mav.addObject("courseActive", courseActive);
		mav.addObject("courseApply", courseApply);

		mav.setViewName("/univ/classroom/surveyPaper/listSurveyPaper");
		return mav;
	}

	/**
	 * 개설과목 설문지 팝업
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/surveypaper/detail/popup.do")
	public ModelAndView detailpopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseActiveSurveyVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		setCourseActive(req, courseActive);

		UIUnivCourseActiveSurveyRS detail = (UIUnivCourseActiveSurveyRS)courseActiveSurveyService.getDetail(vo.getCourseActiveSurveySeq());

		if (detail != null) {
			UIUnivSurveyPaperElementVO elementVO = new UIUnivSurveyPaperElementVO();
			elementVO.setSurveyPaperSeq(detail.getCourseActiveSurvey().getSurveyPaperSeq());
			mav.addObject("listElement", surveyPaperElementService.getList(elementVO));
		}

		mav.addObject("detailSurveyPaper", detail);
		mav.addObject("courseActive", courseActive);
		mav.addObject("courseApply", courseApply);
		mav.setViewName("/univ/classroom/surveyPaper/detailSurveyPaperPopup");

		return mav;

	}

	/**
	 * 강의실 메인 설문 제출후 실행할 ajax
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/surveypaper/detail/ajax.do")
	public ModelAndView detailAjax(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		// 설문지 구분용 값
		vo.setSurveySubjectTypeCd("SURVEY_SUBJECT_TYPE::COURSE");

		mav.addObject("detailSurveyPaper", courseActiveSurveyService.getListForClassroom(vo));

		mav.setViewName("/univ/classroom/include/homeSurveyPaperListAjax");
		return mav;
	}

	/**
	 * 설문 응답
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/surveypaper/answer/insert.do")
	public ModelAndView insertsurvey(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveSurveyPaperAnswerVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		List<UnivCourseActiveSurveyAnswerVO> voList = new ArrayList<UnivCourseActiveSurveyAnswerVO>();
		if (vo.getSurveySeqs() != null) {
			for (int index = 0; index < vo.getSurveySeqs().length; index++) {
				UnivCourseActiveSurveyAnswerVO o = new UnivCourseActiveSurveyAnswerVO();
				o.copyAudit(vo);
				o.setSurveySeq(vo.getSurveySeqs()[index]);
				o.setMemberSeq(vo.getMemberSeq());
				o.setEssayAnswer(vo.getEssayAnswers()[index]);
				o.setSurveyAnswer1Yn(vo.getSurveyAnswer1Yns()[index]);
				o.setSurveyAnswer2Yn(vo.getSurveyAnswer2Yns()[index]);
				o.setSurveyAnswer3Yn(vo.getSurveyAnswer3Yns()[index]);
				o.setSurveyAnswer4Yn(vo.getSurveyAnswer4Yns()[index]);
				o.setSurveyAnswer5Yn(vo.getSurveyAnswer5Yns()[index]);
				o.setSurveyAnswer6Yn(vo.getSurveyAnswer6Yns()[index]);
				o.setSurveyAnswer7Yn(vo.getSurveyAnswer7Yns()[index]);
				o.setSurveyItemTypeCd(vo.getSurveyItemTypeCds()[index]);
				// 현재 교강사 정보 입력하는 프로세스 없음. 수정예정
				if (vo.getProfMemberSeqs() != null && StringUtil.isNotEmpty(vo.getProfMemberSeqs()[index])) {
					o.setProfMemberSeq(vo.getProfMemberSeqs()[index]);
				}

				voList.add(o);
			}
		}

		if (voList.size() > 0) {
			mav.addObject("result", courseActiveSurveyPaperAnswerService.insertSurveyAnswer(vo, voList));
		} else {
			mav.addObject("result", 0);
		}

		mav.setViewName("/common/save");
		return mav;

	}
}
