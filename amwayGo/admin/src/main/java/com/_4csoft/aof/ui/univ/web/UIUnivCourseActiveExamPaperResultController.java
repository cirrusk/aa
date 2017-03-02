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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperTargetVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveExamPaperTargetCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveExamPaperRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseExamPaperRS;
import com._4csoft.aof.univ.service.UnivCourseActiveExamPaperService;
import com._4csoft.aof.univ.service.UnivCourseActiveExamPaperTargetService;
import com._4csoft.aof.univ.service.UnivCourseExamAnswerService;
import com._4csoft.aof.univ.service.UnivCourseExamPaperService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkService;
import com._4csoft.aof.univ.vo.UnivCourseActiveExamPaperTargetVO;
import com._4csoft.aof.univ.vo.UnivCourseApplyElementVO;
import com._4csoft.aof.univ.vo.UnivCourseExamAnswerVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveExamPaperResultController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 31.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseActiveExamPaperResultController extends BaseController {

	@Resource (name = "UnivCourseActiveExamPaperService")
	private UnivCourseActiveExamPaperService courseActiveExamPaperService;

	@Resource (name = "UnivCourseActiveExamPaperTargetService")
	private UnivCourseActiveExamPaperTargetService courseActiveExamPaperTargetService;

	@Resource (name = "UnivCourseExamPaperService")
	private UnivCourseExamPaperService courseExamPaperService;

	@Resource (name = "UnivCourseExamAnswerService")
	private UnivCourseExamAnswerService courseExamAnswerService;

	@Resource (name = "UnivCourseHomeworkService")
	private UnivCourseHomeworkService courseHomeworkService;

	/**
	 * 개설과목 시험결과 목록
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = { "/univ/course/active/exampaper/result/list.do", "/univ/course/active/exampaper/middle/result/list.do",
			"/univ/course/active/exampaper/final/result/list.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		if ("/univ/course/active/exampaper/middle/result/list.do".equals(req.getServletPath())) {
			mav.addObject("examType", "middle");
		} else if ("/univ/course/active/exampaper/final/result/list.do".equals(req.getServletPath())) {
			mav.addObject("examType", "final");
		}

		if ("CATEGORY_TYPE::DEGREE".equals(courseActiveExamPaper.getShortcutCategoryTypeCd())) {
			mav.setViewName("/univ/courseExamPaperResult/listCourseActiveExamPaperResult");
		} else {
			/** TODO : 코드 */
			courseActiveExamPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::EXAM");

			mav.addObject("examPaperList", courseActiveExamPaperService.getList(courseActiveExamPaper));
			mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
			mav.setViewName("/univ/courseExamPaperResult/listCourseActiveExamPaperNonDegreeResult");
		}

		return mav;
	}

	/**
	 * 개설과목 시험결과 상세보기 (비학위)
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @param targetCondition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/result/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper,
			UIUnivCourseActiveExamPaperTargetCondition targetCondition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		emptyValue(targetCondition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIUnivCourseActiveExamPaperRS rs = (UIUnivCourseActiveExamPaperRS)courseActiveExamPaperService.getDetail(courseActiveExamPaper);

		// 대상자 목록
		/** TODO : 코드 */
		mav.addObject("detail", rs);
		if (rs != null) {
			targetCondition.setSrchCourseActiveSeq(rs.getCourseActiveExamPaper().getCourseActiveSeq());
			targetCondition.setSrchReferenceSeq(rs.getCourseActiveExamPaper().getCourseActiveExamPaperSeq());
			targetCondition.setSrchBasicSupplementCd("BASIC_SUPPLEMENT::BASIC");
			targetCondition.setSrchReferenceTypeCd("COURSE_ELEMENT_TYPE::EXAM");
			targetCondition.setSrchApplyStatusCd("APPLY_STATUS::002");
			targetCondition.setSrchMemberStatusCd("MEMBER_STATUS::APPROVAL");
		}
		mav.addObject("paginate", courseActiveExamPaperTargetService.getListForExamResult(targetCondition));
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.addObject("condition", targetCondition);

		mav.setViewName("/univ/courseExamPaperResult/detailCourseActiveExamPaperNonDegreeResult");

		return mav;
	}

	/**
	 * 개설과목 시험결과 목록 - iframe
	 * 
	 * @param req
	 * @param res
	 * @param examType
	 * @param courseActiveExamPaper
	 * @param homework
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/exampaper/result/list/iframe.do")
	public ModelAndView listIframe(HttpServletRequest req, HttpServletResponse res, @PathVariable ("examType") String examType,
			UIUnivCourseActiveExamPaperVO courseActiveExamPaper, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();
		homework.copyShortcut();
		homework.setReplaceYn("Y");

		if ("middle".equals(examType)) {
			/** TODO : 코드 */
			courseActiveExamPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::MIDDLE");
			homework.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::MIDDLE");
		} else if ("final".equals(examType)) {
			/** TODO : 코드 */
			courseActiveExamPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::FINAL");
			homework.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::FINAL");
		}

		mav.addObject("examPaperList", courseActiveExamPaperService.getList(courseActiveExamPaper));
		mav.addObject("homeworkList", courseHomeworkService.getListHomeworkResult(homework));
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.addObject("examType", examType);
		mav.setViewName("/univ/courseExamPaperResult/listCourseActiveExamPaperResultIframe");

		return mav;
	}

	/**
	 * 개설과목 시험결과 상세보기 - iframe
	 * 
	 * @param req
	 * @param res
	 * @param examType
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/exampaper/result/detail/iframe.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, @PathVariable ("examType") String examType,
			UIUnivCourseActiveExamPaperVO courseActiveExamPaper, UIUnivCourseActiveExamPaperTargetCondition targetCondition) throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		emptyValue(targetCondition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIUnivCourseActiveExamPaperRS rs = (UIUnivCourseActiveExamPaperRS)courseActiveExamPaperService.getDetail(courseActiveExamPaper);

		// 대상자 목록
		/** TODO : 코드 */
		mav.addObject("detail", rs);
		if (rs != null) {
			targetCondition.setSrchCourseActiveSeq(rs.getCourseActiveExamPaper().getCourseActiveSeq());
			targetCondition.setSrchReferenceSeq(rs.getCourseActiveExamPaper().getCourseActiveExamPaperSeq());
			targetCondition.setSrchBasicSupplementCd(rs.getCourseActiveExamPaper().getBasicSupplementCd());
			if ("MIDDLE_FINAL_TYPE::MIDDLE".equals(rs.getCourseActiveExamPaper().getMiddleFinalTypeCd())) {
				targetCondition.setSrchReferenceTypeCd("COURSE_ELEMENT_TYPE::MIDEXAM");
				targetCondition.setSrchCourseWeekTypeCd("COURSE_WEEK_TYPE::MIDEXAM");
			} else if ("MIDDLE_FINAL_TYPE::FINAL".equals(rs.getCourseActiveExamPaper().getMiddleFinalTypeCd())) {
				targetCondition.setSrchReferenceTypeCd("COURSE_ELEMENT_TYPE::FINALEXAM");
				targetCondition.setSrchCourseWeekTypeCd("COURSE_WEEK_TYPE::FINALEXAM");
			}
			targetCondition.setSrchApplyStatusCd("APPLY_STATUS::002");
			targetCondition.setSrchMemberStatusCd("MEMBER_STATUS::APPROVAL");
		}
		mav.addObject("paginate", courseActiveExamPaperTargetService.getListForExamResult(targetCondition));
		mav.addObject("examType", examType);
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.addObject("condition", targetCondition);

		// 온라인 오프라인 시험 구분
		if (rs != null && StringUtil.isNotEmpty(rs.getCourseActiveExamPaper().getOnOffCd())) {
			if ("ONOFF_TYPE::OFF".equals(rs.getCourseActiveExamPaper().getOnOffCd())) {
				mav.setViewName("/univ/courseExamPaperResult/detailCourseActiveExamPaperResultOffLineIframe");
			} else {
				mav.setViewName("/univ/courseExamPaperResult/detailCourseActiveExamPaperResultOnLineIframe");
			}
		}

		return mav;
	}

	/**
	 * 개설과목 시험결과 채점하기 팝업
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @param courseApplyElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/result/detail/popup.do")
	public ModelAndView detailExamPaperPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper,
			UIUnivCourseApplyElementVO courseApplyElement, UIUnivCourseExamAnswerVO courseExamAnswer,
			UIUnivCourseActiveExamPaperTargetVO courseActiveExamPaperTarget) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivCourseActiveExamPaperRS detailCourseActiveExamPaper = (UIUnivCourseActiveExamPaperRS)courseActiveExamPaperService
				.getDetail(courseActiveExamPaper);
		UIUnivCourseExamPaperVO courseExamPaper = new UIUnivCourseExamPaperVO();
		courseExamPaper.setExamPaperSeq(detailCourseActiveExamPaper.getCourseActiveExamPaper().getExamPaperSeq());
		UIUnivCourseExamPaperRS detail = (UIUnivCourseExamPaperRS)courseExamPaperService.getDetail(courseExamPaper);
		mav.addObject("detailExamPaper", detail);

		courseExamAnswer.setExamPaperSeq(detail.getCourseExamPaper().getExamPaperSeq());
		mav.addObject("listExamAnswer", courseExamAnswerService.getList(courseExamAnswer));
		mav.addObject("detailCourseExamPaper", detailCourseActiveExamPaper);
		mav.addObject("courseApplyElement", courseApplyElement);
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.addObject("courseActiveExamPaperTarget", courseActiveExamPaperTarget);
		mav.setViewName("/univ/courseExamPaperResult/detailCourseActiveExamPaperResultPopup");

		return mav;
	}

	/**
	 * 시험, 퀴즈 채점 하기
	 * 
	 * @param req
	 * @param res
	 * @param courseExamAnswer
	 * @param courseActiveExamPaper
	 * @param courseApplyElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/course/exam/answer/update.do")
	public ModelAndView updateExamAnswer(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamAnswerVO courseExamAnswer,
			UIUnivCourseActiveExamPaperVO courseActiveExamPaper, UIUnivCourseApplyElementVO courseApplyElement,
			UIUnivCourseActiveExamPaperTargetVO courseActiveExamPaperTarget, UIUnivCourseExamPaperVO courseExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExamAnswer, courseActiveExamPaper, courseApplyElement, courseActiveExamPaperTarget);

		List<UnivCourseExamAnswerVO> courseExamAnswers = new ArrayList<UnivCourseExamAnswerVO>();
		if (courseExamAnswer.getCheckkeys() != null) {
			for (String index : courseExamAnswer.getCheckkeys()) {
				UnivCourseExamAnswerVO o = new UnivCourseExamAnswerVO();
				o.copyAudit(courseExamAnswer);
				o.setTakeScore(courseExamAnswer.getTakeScores()[Integer.parseInt(index)]);
				o.setExamAnswerSeq(courseExamAnswer.getExamAnswerSeqs()[Integer.parseInt(index)]);
				o.setComment(courseExamAnswer.getComments()[Integer.parseInt(index)]);

				courseExamAnswers.add(o);
			}
		}

		if (courseExamAnswers.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			UIUnivCourseExamPaperRS detail = (UIUnivCourseExamPaperRS)courseExamPaperService.getDetail(courseExamPaper);
			mav.addObject("result", courseExamAnswerService.updatelistEvaluateCourseExamAnswer(courseExamAnswers, detail.getCourseExamPaper(),
					courseApplyElement, courseActiveExamPaper, courseActiveExamPaperTarget));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 퀴즈결과 목록
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/result/list.do")
	public ModelAndView listQuiz(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		/** TODO : 코드 */
		courseActiveExamPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::QUIZ");

		mav.addObject("examPaperList", courseActiveExamPaperService.getList(courseActiveExamPaper));
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.setViewName("/univ/courseQuizResult/listCourseActiveQuizResult");

		return mav;
	}

	/**
	 * 개설과목 퀴즈결과 상세보기
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @param targetCondition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/quiz/result/detail.do")
	public ModelAndView detailQuiz(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper,
			UIUnivCourseActiveExamPaperTargetCondition targetCondition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		emptyValue(targetCondition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIUnivCourseActiveExamPaperRS rs = (UIUnivCourseActiveExamPaperRS)courseActiveExamPaperService.getDetail(courseActiveExamPaper);

		// 대상자 목록
		/** TODO : 코드 */
		mav.addObject("detail", rs);
		if (rs != null) {
			targetCondition.setSrchCourseActiveSeq(rs.getCourseActiveExamPaper().getCourseActiveSeq());
			targetCondition.setSrchReferenceSeq(rs.getCourseActiveExamPaper().getCourseActiveExamPaperSeq());
			targetCondition.setSrchBasicSupplementCd("BASIC_SUPPLEMENT::BASIC");
			targetCondition.setSrchReferenceTypeCd("COURSE_ELEMENT_TYPE::QUIZ");
			targetCondition.setSrchApplyStatusCd("APPLY_STATUS::002");
			targetCondition.setSrchMemberStatusCd("MEMBER_STATUS::APPROVAL");
		}
		mav.addObject("paginate", courseActiveExamPaperTargetService.getListForExamResult(targetCondition));
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.addObject("condition", targetCondition);

		mav.setViewName("/univ/courseQuizResult/detailCourseActiveQuizResult");

		return mav;
	}

	/**
	 * 오프라인 시험지 다중 채점하기
	 * 
	 * @param req
	 * @param res
	 * @param courseExamAnswer
	 * @param courseActiveExamPaper
	 * @param courseApplyElement
	 * @param courseActiveExamPaperTarget
	 * @param courseExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/exam/offline/answer/updatelist.do")
	public ModelAndView updateExamAnswerOffLine(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper,
			UIUnivCourseApplyElementVO courseApplyElement, UIUnivCourseActiveExamPaperTargetVO courseActiveExamPaperTarget) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseApplyElement, courseActiveExamPaperTarget);

		List<UnivCourseActiveExamPaperTargetVO> courseActiveExamPaperTargets = new ArrayList<UnivCourseActiveExamPaperTargetVO>();
		List<UnivCourseApplyElementVO> courseApplyElements = new ArrayList<UnivCourseApplyElementVO>();

		if (courseActiveExamPaperTarget.getTakeScores() != null) {
			for (int index = 0; index < courseActiveExamPaperTarget.getTakeScores().length; index++) {
				UnivCourseActiveExamPaperTargetVO target = new UnivCourseActiveExamPaperTargetVO();
				target.copyAudit(courseActiveExamPaperTarget);
				if (StringUtil.isNotEmpty(courseActiveExamPaperTarget.getActiveExamPaperTargetSeqs()[index])
						&& courseActiveExamPaperTarget.getActiveExamPaperTargetSeqs()[index] > 0) {
					target.setActiveExamPaperTargetSeq(courseActiveExamPaperTarget.getActiveExamPaperTargetSeqs()[index]);
				}
				target.setCourseActiveExamPaperSeq(courseActiveExamPaperTarget.getCourseActiveExamPaperSeq());
				target.setCourseApplySeq(courseActiveExamPaperTarget.getCourseApplySeqs()[index]);
				target.setScoreYn(courseActiveExamPaperTarget.getScoreYns()[index]);
				target.setTakeScore(courseActiveExamPaperTarget.getTakeScores()[index]);
				// 첨부파일 정보 저장 하기 위한 변환 및 값 세팅
				String info = null;
				String attachUploadInfo = null;
				String attachDeleteInfo = null;
				if (StringUtil.isNotEmpty(courseActiveExamPaperTarget.getAttachUploadInfos()[index])) {
					info = courseActiveExamPaperTarget.getAttachUploadInfos()[index];
					attachUploadInfo = info.replace("|", String.valueOf((char)0x01));
				}
				if (StringUtil.isNotEmpty(courseActiveExamPaperTarget.getAttachDeleteInfos()[index])) {
					attachDeleteInfo = courseActiveExamPaperTarget.getAttachDeleteInfos()[index];
				}
				target.setAttachUploadInfo(attachUploadInfo);
				target.setAttachDeleteInfo(attachDeleteInfo);

				courseActiveExamPaperTargets.add(target);

				UnivCourseApplyElementVO element = new UnivCourseApplyElementVO();
				element.copyAudit(courseApplyElement);
				element.setCourseActiveSeq(courseApplyElement.getCourseActiveSeq());
				element.setActiveElementSeq(courseApplyElement.getActiveElementSeq());
				element.setCourseApplySeq(courseActiveExamPaperTarget.getCourseApplySeqs()[index]);
				element.setTakeScore(courseActiveExamPaperTarget.getTakeScores()[index]);
				element.setEvaluateScore(courseActiveExamPaperTarget.getTakeScores()[index]);
				// update와 insert 분기 위해 다른 값 넘김
				element.setCompleteYn(courseActiveExamPaperTarget.getScoreYns()[index]);
				element.setBasicSupplementCd(courseActiveExamPaper.getBasicSupplementCd());

				courseApplyElements.add(element);
			}
		}

		if (courseActiveExamPaperTargets.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseExamAnswerService.updatelistEvaluateCourseExamOfflineAnswer(courseActiveExamPaperTargets, courseApplyElements));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 오프라인 시험지 상세보기
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaperTarget
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exam/offline/result/detail/popup.do")
	public ModelAndView detailofflineExam(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperTargetVO courseActiveExamPaperTarget)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detailCourseExamPaper", courseActiveExamPaperTargetService.getDetailForExamResult(courseActiveExamPaperTarget));

		mav.setViewName("/univ/courseExamPaperResult/detailCourseActiveExamPaperResultOffLinePopup");

		return mav;
	}

	/**
	 * 오프라인 시험지 채점하기
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaperTarget
	 * @param courseApplyElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/exam/offline/answer/update.do")
	public ModelAndView updateofflineExam(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperTargetVO courseActiveExamPaperTarget,
			UIUnivCourseApplyElementVO courseApplyElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaperTarget, courseApplyElement);

		mav.addObject("result", courseExamAnswerService.updateEvaluateCourseExamOfflineAnswer(courseActiveExamPaperTarget, courseApplyElement));

		mav.setViewName("/common/save");
		return mav;
	}

}
