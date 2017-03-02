/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.FileUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.AttachVO;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectMutualevalVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTeamVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTemplateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseTeamProjectBbsCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseTeamProjectTeamRS;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkAnswerService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectMemberService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectMutualevalService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectTemplateService;
import com._4csoft.aof.univ.vo.UnivCourseHomeworkAnswerVO;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectTemplateVO;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseTeamProjectController.java
 * @Title : 개설과목 팀프로젝트
 * @date : 2014. 2. 25.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseTeamProjectController extends BaseController {

	@Resource (name = "UnivCourseTeamProjectService")
	private UnivCourseTeamProjectService courseTeamProjectService;

	@Resource (name = "UnivCourseTeamProjectTeamService")
	private UnivCourseTeamProjectTeamService courseTeamProjectTeamService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "UnivCourseTeamProjectTemplateService")
	private UnivCourseTeamProjectTemplateService courseTeamProjectTemplateService;

	@Resource (name = "UnivCourseTeamProjectMutualevalService")
	private UnivCourseTeamProjectMutualevalService courseTeamProjectMutualevalService;

	@Resource (name = "UnivCourseHomeworkAnswerService")
	private UnivCourseHomeworkAnswerService courseHomeworkAnswerService;

	@Resource (name = "UnivCourseTeamProjectMemberService")
	private UnivCourseTeamProjectMemberService courseTeamProjectMemberService;

	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService univCourseActiveEvaluateService;

	/**
	 * 개설과목 팀프로젝트 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/list.do")
	public ModelAndView listTeamProject(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterVO courseMaster,
			UIUnivCourseTeamProjectVO teamProject) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		teamProject.copyShortcut();

		mav.addObject("teamProject", teamProject);
		mav.addObject("itemList", courseTeamProjectService.getListCourseTeamProject(teamProject));

		// 평가비율
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(teamProject.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		mav.setViewName("/univ/courseActiveElement/teamProject/listTeamProject");
		return mav;
	}

	/**
	 * 개설과목 팀프로젝트 등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseTeamProjectVO teamProject,
			UIUnivCourseTeamProjectTemplateVO template) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 탬플릿
		if (StringUtil.isNotEmpty(template.getTemplateSeq())) {
			mav.addObject("template", courseTeamProjectTemplateService.getDetailCourseTeamProjectTemplate(template));
		}

		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));
		mav.addObject("teamProject", teamProject);
		mav.setViewName("/univ/courseActiveElement/teamProject/createTeamProject");
		return mav;
	}

	/**
	 * 팀프로젝트 수정화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param teamProject
	 * @param template
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseTeamProjectVO teamProject)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));
		mav.addObject("detail", courseTeamProjectService.getDetailCourseTeamProject(teamProject));
		mav.addObject("teamProject", teamProject);

		mav.setViewName("/univ/courseActiveElement/teamProject/editTeamProject");
		return mav;
	}

	/**
	 * 팀프로젝트 상세화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param teamProject
	 * @param template
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseTeamProjectVO teamProject)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));
		mav.addObject("detail", courseTeamProjectService.getDetailCourseTeamProject(teamProject));
		mav.addObject("teamProject", teamProject);

		mav.setViewName("/univ/courseActiveElement/teamProject/detailTeamProject");
		return mav;
	}

	/**
	 * 개설과목 팀프로젝트 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param teamProject
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectVO teamProject,
			UnivCourseTeamProjectTemplateVO template, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, teamProject);

		courseTeamProjectService.insertCourseTeamProject(teamProject, template, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 팀프로젝트 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param teamProject
	 * @param template
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectVO teamProject,
			UnivCourseTeamProjectTemplateVO template, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, teamProject);

		courseTeamProjectService.updateCourseTeamProject(teamProject, template, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 팀프로젝트 다중수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param teamProject
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/rate/updatelist.do")
	public ModelAndView updatelistRates(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectVO teamProject) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, teamProject);
		teamProject.copyShortcut();

		List<UnivCourseTeamProjectVO> teamProjects = new ArrayList<UnivCourseTeamProjectVO>();
		for (int i = 0; i < teamProject.getRates().length; i++) {
			UIUnivCourseTeamProjectVO o = new UIUnivCourseTeamProjectVO();
			o.setCourseTeamProjectSeq(teamProject.getCourseTeamProjectSeqs()[i]);
			o.setRate(teamProject.getRates()[i]);
			o.setCourseActiveSeq(teamProject.getCourseActiveSeq());
			o.copyAudit(teamProject);

			teamProjects.add(o);
		}

		if (teamProjects.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseTeamProjectService.updatelistCourseTeamProject(teamProjects));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 팀프로젝트 다중 삭제
	 * 
	 * @param req
	 * @param res
	 * @param teamProject
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectVO teamProject) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, teamProject);
		teamProject.copyShortcut();

		List<UnivCourseTeamProjectVO> teamProjects = new ArrayList<UnivCourseTeamProjectVO>();
		for (String index : teamProject.getCheckkeys()) {
			UIUnivCourseTeamProjectVO o = new UIUnivCourseTeamProjectVO();
			o.setCourseTeamProjectSeq(teamProject.getCourseTeamProjectSeqs()[Integer.parseInt(index)]);
			o.setCourseActiveSeq(teamProject.getCourseActiveSeq());
			o.copyAudit(teamProject);
			teamProjects.add(o);
		}
		if (teamProjects.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseTeamProjectService.deletelistCourseTeamProject(teamProjects));
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 팀프로젝트 결과 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/teamproject/result/list.do")
	public ModelAndView listTeamProjectResult(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterVO courseMaster,
			UIUnivCourseTeamProjectVO teamProject) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		teamProject.copyShortcut();

		mav.addObject("teamProject", teamProject);
		mav.addObject("itemList", courseTeamProjectService.getListCourseTeamProject(teamProject));

		mav.setViewName("/univ/teamProjectResult/listTeamProjectResult");
		return mav;
	}

	/**
	 * 팀 프로젝트 결과 상세
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/teamproject/result/detail.do")
	public ModelAndView deatilTeamProjectResult(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectVO teamProject,
			UIUnivCourseTeamProjectTeamVO projectTeam, UIUnivCourseTeamProjectBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		teamProject.copyShortcut();
		projectTeam.copyShortcut();

		mav.addObject("condition", condition);
		mav.addObject("detail", courseTeamProjectService.getDetailCourseTeamProject(teamProject));
		mav.addObject("teamList", courseTeamProjectTeamService.getListTeamProjectResult(projectTeam));

		mav.setViewName("/univ/teamProjectResult/detailTeamProjectResult"); 
		return mav;
	}

	/**
	 * 상호평가 리스트
	 * 
	 * @param req
	 * @param res
	 * @param teamProject
	 * @param projectTeam
	 * @param teamProjectMutualeval
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/teamproject/mutualeval/list.do")
	public ModelAndView listMutualeval(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectVO teamProject,
			UIUnivCourseTeamProjectTeamVO projectTeam, UIUnivCourseTeamProjectMutualevalVO teamProjectMutualeval, UIUnivCourseTeamProjectBbsCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		projectTeam.copyShortcut();
		teamProjectMutualeval.copyShortcut();

		mav.addObject("condition", condition);
		mav.addObject("detail", courseTeamProjectTeamService.getDetailCourseTeamProjectTeamByUser(projectTeam));
		mav.addObject("itemList", courseTeamProjectMutualevalService.getListMutualEvalOfProjectTeam(teamProjectMutualeval));

		mav.setViewName("/univ/teamProjectResult/mutualeval/listMutualeval");
		return mav;
	}

	/**
	 * 개설과목 팀프로젝트 점수 저장
	 * 
	 * @param req
	 * @param res
	 * @param teamProject
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/teamproject/score/updatelist.do")
	public ModelAndView updatelistScores(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkAnswerVO homeworkAnswer,
			UIUnivCourseApplyElementVO element) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, homeworkAnswer);

		homeworkAnswer.copyShortcut();

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		if ("PROF".equals(ssMember.getCurrentRoleCfString()) || "ADM".equals(ssMember.getCurrentRoleCfString())) {
			List<UnivCourseHomeworkAnswerVO> homeworkAnswers = new ArrayList<UnivCourseHomeworkAnswerVO>();
			for (int i = 0; i < homeworkAnswer.getCourseTeamSeqs().length; i++) {
				// 초기점수나 수정된 점수만 저장한다.
				if (homeworkAnswer.getOldHomeworkScores()[i] == null || !homeworkAnswer.getHomeworkScores()[i].equals(homeworkAnswer.getOldHomeworkScores()[i])) {
					UIUnivCourseHomeworkAnswerVO o = new UIUnivCourseHomeworkAnswerVO();
					o.setCourseActiveSeq(homeworkAnswer.getCourseActiveSeq());
					o.setCourseTeamSeq(homeworkAnswer.getCourseTeamSeqs()[i]);
					o.setHomeworkScore(homeworkAnswer.getHomeworkScores()[i]);
					o.setProfCommentMemberSeq(homeworkAnswer.getRegMemberSeq());

					o.copyAudit(homeworkAnswer);

					homeworkAnswers.add(o);
				}
			}

			if (homeworkAnswers.isEmpty()) {
				mav.addObject("result", 0);
			} else {
				mav.addObject("result", courseHomeworkAnswerService.savelistTeamProjectAnswer(homeworkAnswers, element));
			}
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 팀프로젝트 평가 팝업
	 * 
	 * @param req
	 * @param res
	 * @param projectTeam
	 * @param answer
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/teamproject/eval/popup.do")
	public ModelAndView createEvalTeamProject(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTeamVO projectTeam,
			UIUnivCourseHomeworkAnswerVO answer) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		projectTeam.copyShortcut();
		answer.copyShortcut();

		// 팀프로젝트 상세
		mav.addObject("detail", courseTeamProjectTeamService.getDetailCourseTeamProjectTeamByUser(projectTeam));

		// 제출/평가정보
		mav.addObject("eval", courseHomeworkAnswerService.getDetailTeamProjectAnswerByUser(answer));

		mav.setViewName("/univ/teamProjectResult/detailEvalPopup");
		return mav;
	}

	/**
	 * 팀프로젝트 평가 저장
	 * 
	 * @param req
	 * @param res
	 * @param homeworkAnswer
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/teamproject/eval/save.do")
	public ModelAndView saveEvalTeamProject(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkAnswerVO homeworkAnswer,
			UIUnivCourseApplyElementVO element) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, homeworkAnswer);
		homeworkAnswer.copyShortcut();

		if (courseHomeworkAnswerService.countTeamProjectAnswer(homeworkAnswer) > 0) {
			mav.addObject("result", courseHomeworkAnswerService.updateTeamProjectAnswer(homeworkAnswer, element, null));
		} else {
			mav.addObject("result", courseHomeworkAnswerService.insertTeamProjecrtAnswer(homeworkAnswer, element, null));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개인별 상호평가 상세정보
	 * 
	 * @param req
	 * @param res
	 * @param projectMember
	 * @param mutualeval
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/teamproject/personal/eval/popup.do")
	public ModelAndView createPersonalEvalTeamProject(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectMemberVO projectMember,
			UIUnivCourseTeamProjectMutualevalVO mutualeval) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mutualeval.copyShortcut();
		projectMember.setTeamMemberSeq(mutualeval.getMutualMemberSeq());

		mav.addObject("detail", courseTeamProjectMemberService.getDetail(projectMember));
		mav.addObject("itemList", courseTeamProjectMutualevalService.getListMutualMember(mutualeval));

		mav.setViewName("/univ/teamProjectResult/mutualeval/detailMutualevalPopup");
		return mav;
	}

	/**
	 * 팀프로젝트 첨부파일 일괄 다운로드
	 * 
	 * @param req
	 * @param res
	 * @param projectTeam
	 * @throws Exception
	 */
	@RequestMapping ("/univ/teamproject/collective/file/response.do")
	public void collectiveFileResponse(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTeamVO projectTeam) throws Exception {

		requiredSession(req);

		List<ResultSet> rsList = courseTeamProjectTeamService.getListTeamProjectResult(projectTeam);

		String copyDirectory = Constants.UPLOAD_PATH_FILE + "/" + StringUtil.getRandomString(20);

		List<String> tempDownloadPaths = new ArrayList<String>();
		for (ResultSet resultSet : rsList) {// 팀 목록
			UIUnivCourseTeamProjectTeamRS teamProjectTeamRS = ((UIUnivCourseTeamProjectTeamRS)resultSet);
			UIUnivCourseHomeworkAnswerVO courseHomeworkAnswer = teamProjectTeamRS.getCourseHomeworkAnswer();
			List<AttachVO> attachList = courseHomeworkAnswer.getUnviAttachList();

			for (AttachVO fileInfo : attachList) {// 파일 목록
				String copyFileName = teamProjectTeamRS.getCourseTeamProjectTeam().getTeamTitle() + "_" + teamProjectTeamRS.getMember().getMemberName() + "_"
						+ fileInfo.getRealName();
				String targetFileFullPath = Constants.UPLOAD_PATH_FILE + fileInfo.getSavePath() + "/" + fileInfo.getSaveName();
				String copyFileFullPath = copyDirectory + "/" + copyFileName;

				FileUtil.createFile(copyDirectory, copyFileName);
				FileUtil.copy(targetFileFullPath, copyFileFullPath);

				tempDownloadPaths.add(copyFileFullPath);
			}
		}

		String collectiveFileName = "TeamProject.zip";
		String collectiveFileFullPath = Constants.UPLOAD_PATH_FILE + "/" + collectiveFileName;

		FileUtil.zip(collectiveFileFullPath, tempDownloadPaths, "UTF-8");
		File collectiveFile = new File(collectiveFileFullPath);

		try {
			responseFile(res, collectiveFile, collectiveFileName, "application/octet-stream");
		} catch (Exception e) {
			log.debug("collectiveFileResponse responseFile error : " + e.getMessage());
		}

		try {
			FileUtil.deleteDirectory(copyDirectory);
		} catch (Exception e) {
			log.debug("collectiveFileResponse deleteDirectory error : " + e.getMessage());
		}

		try {
			FileUtil.delete(collectiveFileFullPath);
		} catch (Exception e) {
			log.debug("collectiveFileResponse deleteFile error : " + e.getMessage());
		}

	}

	/**
	 * 파일 응답
	 * 
	 * @param response
	 * @param downloadName
	 * @param file
	 * @throws Exception
	 */
	public void responseFile(HttpServletResponse response, File file, String downloadName, String contentType) throws Exception {

		FileInputStream fin = null;
		BufferedInputStream bis = null;
		ServletOutputStream sos = null;

		if (contentType == null || contentType.length() == 0) {
			contentType = "application/octet-stream";
		}
		try {
			response.setContentType(contentType);
			response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(downloadName, "UTF-8") + ";");
			if (file.length() > 0) {
				response.setHeader("Content-Length", String.valueOf(file.length()));
			}
			response.setHeader("Content-Type", contentType);
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setHeader("Pragma", "no-cache");
			response.setHeader("Expires", "0");
			if (file.exists()) {
				fin = new FileInputStream(file);
				bis = new BufferedInputStream(fin);

				sos = response.getOutputStream();
				int read = 0;
				while ((read = bis.read()) != -1) {
					sos.write(read);
				}
			}
		} catch (Exception e) {
			throw new AofException(Errors.PROCESS_FILE.desc);
		} finally {
			if (sos != null) {
				sos.close();
			}
			if (bis != null) {
				bis.close();
			}
			if (fin != null) {
				fin.close();
			}
		}

	}
}
