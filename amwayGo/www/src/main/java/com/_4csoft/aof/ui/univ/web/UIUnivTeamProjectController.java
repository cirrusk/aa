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

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.UnivBaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectMutualevalVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTeamVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseTeamProjectBbsCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkAnswerService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectMutualevalService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectMutualevalVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivTeamProjectController.java
 * @Title : 팀프로젝트
 * @date : 2014. 3. 11.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivTeamProjectController extends UnivBaseController {

	@Resource (name = "UnivCourseTeamProjectService")
	private UnivCourseTeamProjectService univCourseTeamProjectService;

	@Resource (name = "UnivCourseTeamProjectTeamService")
	private UnivCourseTeamProjectTeamService univCourseTeamProjectTeamService;

	@Resource (name = "UnivCourseTeamProjectMutualevalService")
	private UnivCourseTeamProjectMutualevalService univCourseTeamProjectMutualevalService;

	@Resource (name = "UnivCourseHomeworkAnswerService")
	private UnivCourseHomeworkAnswerService univCourseHomeworkAnswerService;

	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService courseActiveElementService;

	/**
	 * 강의실의 팀프로젝트
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/teamproject/list.do")
	public ModelAndView listTeamProject(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseTeamProjectVO teamProject) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, teamProject);
		setCourseActive(req, courseActive);

		teamProject.setCourseActiveSeq(courseActive.getCourseActiveSeq());

		mav.addObject("itemList", univCourseTeamProjectService.getListAllCourseTeamProjectByUser(teamProject));
		mav.addObject("courseApply", courseApply);

		mav.setViewName("/univ/classroom/teamproject/listTeamProject");
		return mav;
	}

	/**
	 * 강의실의 팀 프로젝트 상세
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/teamproject/detail.do")
	public ModelAndView deatilTeamProject(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseTeamProjectVO teamProject, UIUnivCourseTeamProjectTeamVO projectTeam, UIUnivCourseTeamProjectBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, projectTeam, teamProject);
		setCourseActive(req, courseActive);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		projectTeam.setCourseActiveSeq(courseActive.getCourseActiveSeq());

		mav.addObject("condition", condition);
		mav.addObject("courseApply", courseApply);
		mav.addObject("detail", univCourseTeamProjectService.getDetailCourseTeamProject(teamProject));
		mav.addObject("teamList", univCourseTeamProjectTeamService.getListTeamProjectResult(projectTeam));

		mav.setViewName("/univ/classroom/teamproject/detailTeamProject");
		return mav;
	}

	/**
	 * 상호평가 리스트
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param teamProject
	 * @param projectTeam
	 * @param teamProjectMutualeval
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/teamproject/mutualeval/list.do")
	public ModelAndView listMutualeval(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseTeamProjectVO teamProject, UIUnivCourseTeamProjectTeamVO projectTeam, UIUnivCourseTeamProjectMutualevalVO teamProjectMutualeval,
			UIUnivCourseTeamProjectBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, projectTeam, teamProject, teamProjectMutualeval);
		setCourseActive(req, courseActive, teamProjectMutualeval);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		projectTeam.setCourseActiveSeq(courseActive.getCourseActiveSeq());

		mav.addObject("condition", condition);

		teamProjectMutualeval.setMutualMemberSeq(teamProjectMutualeval.getRegMemberSeq());
		mav.addObject("courseApply", courseApply);
		mav.addObject("detail", univCourseTeamProjectTeamService.getDetailCourseTeamProjectTeamByUser(projectTeam));
		mav.addObject("itemList", univCourseTeamProjectMutualevalService.getListMutualMember(teamProjectMutualeval));

		mav.setViewName("/univ/classroom/teamproject/mutualeval/listMutualeval");
		return mav;
	}

	/**
	 * 상호 평가 점수 저장
	 * 
	 * @param req
	 * @param res
	 * @param teamProjectMutualeval
	 * @param courseActive
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/teamproject/mutualeval/insert.do")
	public ModelAndView insertMutualeval(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectMutualevalVO teamProjectMutualeval,
			UIUnivCourseActiveVO courseActive, UIUnivCourseTeamProjectBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, teamProjectMutualeval);

		List<UnivCourseTeamProjectMutualevalVO> voList = new ArrayList<UnivCourseTeamProjectMutualevalVO>();

		Long[] teamMemberSeqs = teamProjectMutualeval.getTeamMemberSeqs();
		for (int i = 0; i < teamMemberSeqs.length; i++) {
			UnivCourseTeamProjectMutualevalVO vo = new UnivCourseTeamProjectMutualevalVO();
			vo.setCourseTeamSeq(teamProjectMutualeval.getCourseTeamSeqs()[i]);
			vo.setTeamMemberSeq(teamMemberSeqs[i]);
			vo.setCourseApplySeq(teamProjectMutualeval.getCourseApplySeqs()[i]);
			vo.setMutualMemberSeq(teamProjectMutualeval.getRegMemberSeq());

			if (teamProjectMutualeval.getMutualScores()[i] == null || teamProjectMutualeval.getMutualScores()[i].equals("")) {
				vo.setMutualScore(0.0);
			} else {
				vo.setMutualScore(teamProjectMutualeval.getMutualScores()[i]);
			}

			vo.copyAudit(teamProjectMutualeval);

			voList.add(vo);
		}

		mav.addObject("retult", univCourseTeamProjectMutualevalService.savelist(voList));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 과제물 상세 보기
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param courseApply
	 * @param teamProject
	 * @param projectTeam
	 * @param homeworkAnswer
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/teamproject/homework/detail.do")
	public ModelAndView deatilHomework(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseTeamProjectVO teamProject, UIUnivCourseTeamProjectTeamVO projectTeam, UIUnivCourseHomeworkAnswerVO homeworkAnswer,
			UIUnivCourseTeamProjectBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, projectTeam, teamProject);
		setCourseActive(req, courseActive, projectTeam, homeworkAnswer);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("condition", condition);
		mav.addObject("courseApply", courseApply);
		mav.addObject("detail", univCourseTeamProjectTeamService.getDetailCourseTeamProjectTeamByUser(projectTeam));
		mav.addObject("homework", univCourseHomeworkAnswerService.getDetailTeamProjectAnswerByUser(homeworkAnswer));

		mav.setViewName("/univ/classroom/teamproject/homework/detailHomework");
		return mav;
	}

	/**
	 * 다른팀의 과제물 상세보기
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param courseApply
	 * @param teamProject
	 * @param projectTeam
	 * @param homeworkAnswer
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/teamproject/homework/detail/popup.do")
	public ModelAndView deatilHomeworkPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkAnswerVO homeworkAnswer,
			UIUnivCourseTeamProjectBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		setCourseActive(req, homeworkAnswer);

		mav.addObject("homework", univCourseHomeworkAnswerService.getDetailTeamProjectAnswerByUser(homeworkAnswer));

		mav.setViewName("/univ/classroom/teamproject/homework/detailHomeworkPopup");
		return mav;
	}

	/**
	 * 과제물 상세 등록화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param courseApply
	 * @param teamProject
	 * @param projectTeam
	 * @param homeworkAnswer
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/teamproject/homework/create.do")
	public ModelAndView createHomework(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseTeamProjectVO teamProject, UIUnivCourseTeamProjectTeamVO projectTeam, UIUnivCourseHomeworkAnswerVO homeworkAnswer,
			UIUnivCourseActiveElementVO element, UIUnivCourseTeamProjectBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, projectTeam, teamProject);
		setCourseActive(req, courseActive, element, projectTeam, homeworkAnswer);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("condition", condition);
		mav.addObject("courseApply", courseApply);
		mav.addObject("detail", univCourseTeamProjectTeamService.getDetailCourseTeamProjectTeamByUser(projectTeam));

		mav.setViewName("/univ/classroom/teamproject/homework/createHomework");
		return mav;
	}

	/**
	 * 과제물 저장
	 * 
	 * @param req
	 * @param res
	 * @param homeworkAnswer
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/teamproject/homework/insert.do")
	public ModelAndView insertHomework(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkAnswerVO homeworkAnswer,
			UIUnivCourseApplyElementVO courseApplyElement, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, homeworkAnswer);
		setCourseActive(req, homeworkAnswer, courseApplyElement);

		mav.addObject("retult", univCourseHomeworkAnswerService.insertTeamProjecrtAnswer(homeworkAnswer, courseApplyElement, attach));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 과제물 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param courseApply
	 * @param teamProject
	 * @param projectTeam
	 * @param homeworkAnswer
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/teamproject/homework/edit.do")
	public ModelAndView editHomework(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO courseApply, UIUnivCourseTeamProjectVO teamProject,
			UIUnivCourseTeamProjectTeamVO projectTeam, UIUnivCourseHomeworkAnswerVO homeworkAnswer, UIUnivCourseActiveElementVO element,
			UIUnivCourseTeamProjectBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, projectTeam, teamProject);
		setCourseActive(req, homeworkAnswer, projectTeam, element);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("condition", condition);
		mav.addObject("courseApply", courseApply);
		mav.addObject("detail", univCourseTeamProjectTeamService.getDetailCourseTeamProjectTeamByUser(projectTeam));
		mav.addObject("homework", univCourseHomeworkAnswerService.getDetailTeamProjectAnswerByUser(homeworkAnswer));

		// TODO : 코드
		element.setReferenceTypeCd("COURSE_ELEMENT_TYPE::TEAMPROJECT");
		element.setReferenceSeq(teamProject.getCourseTeamProjectSeq());
		mav.addObject("elementDetail", courseActiveElementService.getDetailElementType(element));

		mav.setViewName("/univ/classroom/teamproject/homework/editHomework");
		return mav;
	}

	/**
	 * 과제물 수정
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param homeworkAnswer
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/teamproject/homework/update.do")
	public ModelAndView upateHomework(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive,
			UIUnivCourseHomeworkAnswerVO homeworkAnswer, UIUnivCourseApplyElementVO element, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, homeworkAnswer);
		setCourseActive(req, courseActive, homeworkAnswer);

		mav.addObject("retult", univCourseHomeworkAnswerService.updateTeamProjectAnswer(homeworkAnswer, element, attach));

		mav.setViewName("/common/save");
		return mav;
	}
}
