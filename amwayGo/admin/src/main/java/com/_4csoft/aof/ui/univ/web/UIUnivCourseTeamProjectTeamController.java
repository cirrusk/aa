/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jxls.reader.XLSDataReadException;
import net.sf.jxls.reader.XLSReadStatus;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Codes;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.parser.ExcelParser;
import com._4csoft.aof.infra.support.util.AttachUtil;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.support.view.ExcelDownloadView;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.service.UIUnivCourseTeamProjectTeamService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTeamVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseTeamProjectTeamRS;
import com._4csoft.aof.univ.service.UnivCourseApplyService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectMemberService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectMemberVO;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectTeamVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseTeamProjectTeamController.java
 * @Title : 개설과목 팀프로젝트 팀
 * @date : 2014. 2. 25.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseTeamProjectTeamController extends BaseController {

	@Resource (name = "UnivCourseTeamProjectService")
	private UnivCourseTeamProjectService courseTeamProjectService;

	@Resource (name = "UnivCourseTeamProjectTeamService")
	private UnivCourseTeamProjectTeamService courseTeamProjectTeamService;
	
	@Resource (name = "UIUnivCourseTeamProjectTeamService")
	private UIUnivCourseTeamProjectTeamService UIcourseTeamProjectTeamService;	

	@Resource (name = "UnivCourseTeamProjectMemberService")
	private UnivCourseTeamProjectMemberService courseTeamProjectMemberService;

	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyService courseApplyService;

	@Resource (name = "AttachUtil")
	private AttachUtil attachUtil;

	private Codes codes = Codes.getInstance();
	private final String JXLS_PATH = "infra/jxls/";
	private final String JXLS_UPLOAD_PATH = JXLS_PATH + "upload/";
	private final String JXLS_DOWNLOAD_PATH = JXLS_PATH + "download/";

	/**
	 * 팀프로젝트 팀 생성
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/team/insert.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTeamVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		if (codes.get("CD.TEAM_WAY.RANDOM").equals(vo.getTeamWay())) {
			// 자동 팀 설정
			UIcourseTeamProjectTeamService.insertRandomCourseTeamProjectTeam(vo);
		} else {
			// 수동 팀 설정
			UIcourseTeamProjectTeamService.insertManualCourseTeamProjectTeam(vo);
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프로젝트 팀 구성 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/team/popup.do")
	public ModelAndView createProjectTeam(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectVO teamProject,
			UIUnivCourseTeamProjectTeamVO teamProjectTeam) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 팀프로젝트 상세
		mav.addObject("detail", courseTeamProjectService.getDetailCourseTeamProject(teamProject));
		// 프로젝트팀 목록
		mav.addObject("itemList", courseTeamProjectService.getListCourseTeamProject(teamProject));

		mav.setViewName("/univ/courseActiveElement/teamProject/createTeamProjectTeamPopup");
		return mav;
	}
	
	/**
	 * 프로젝트 팀 일괄등록 팝업
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/excel/popup.do")
	public ModelAndView createProjectTeamExcel(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectVO teamProject,
			UIUnivCourseTeamProjectTeamVO teamProjectTeam) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		
		mav.addObject("detail", teamProject);

		mav.setViewName("/univ/courseActiveElement/teamProject/teamExcelPopup");
		return mav;
	}	

	/**
	 * 프로젝트 팀원 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param projectTeamMamber
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/member/popup.do")
	public ModelAndView editProjectTeamMember(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectMemberVO projectTeamMamber)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 팀프로젝트의 팀 목록
		mav.addObject("teamList", courseTeamProjectTeamService.getListAllCourseTeamProjectTeam(projectTeamMamber.getCourseTeamProjectSeq()));
		// 미 배정된 수강생 목록
		mav.addObject("unAssignMemberList", courseTeamProjectMemberService.getListUnAssignTeamMember(projectTeamMamber));
		// 배정된 수강생 목록
		mav.addObject("assignMemberList", courseTeamProjectMemberService.getListAssignTeamMember(projectTeamMamber));

		mav.addObject("projectTeamMamber", projectTeamMamber);

		mav.setViewName("/univ/courseActiveElement/teamProject/createProjectTeamMemberPopup");
		return mav;
	}

	/**
	 * 프로젝트 팀원 다중수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param projectTeamMamber
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/member/updatelist.do")
	public ModelAndView updatelistTeamMember(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTeamVO courseTeamProjectTeam,
			UIUnivCourseTeamProjectMemberVO projectTeamMamber) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseTeamProjectTeam, projectTeamMamber);

		// 대기자 -> 팀원 할당
		List<UnivCourseTeamProjectMemberVO> assignTeamMembers = new ArrayList<UnivCourseTeamProjectMemberVO>();
		if (projectTeamMamber.getUnassignTeamMemberSeqs() != null) {
			for (int i = 0; i < projectTeamMamber.getUnassignTeamMemberSeqs().length; i++) {

				/** TODO : 코드 */
				if (projectTeamMamber.getUnassignTransferYns()[i].equals("Y")) {
					//
					UnivCourseTeamProjectMemberVO o = new UnivCourseTeamProjectMemberVO();
					o.setCourseTeamSeq(projectTeamMamber.getUnassignCourseTeamSeqs()[i]);
					o.setTeamMemberSeq(projectTeamMamber.getUnassignTeamMemberSeqs()[i]);
					o.setChiefYn(projectTeamMamber.getUnassignChiefYns()[i]);

					o.copyAudit(projectTeamMamber);

					assignTeamMembers.add(o);
				}
			}
		}

		// 팀원 -> 대기자 할당
		List<UnivCourseTeamProjectMemberVO> unassignTeamMembers = new ArrayList<UnivCourseTeamProjectMemberVO>();
		if (projectTeamMamber.getAssignTeamMemberSeqs() != null) {
			for (int i = 0; i < projectTeamMamber.getAssignTeamMemberSeqs().length; i++) {

				/** TODO : 코드 */
				if (projectTeamMamber.getAssignTransferYns()[i].equals("Y")) {
					//
					UnivCourseTeamProjectMemberVO o = new UnivCourseTeamProjectMemberVO();
					o.setCourseTeamSeq(projectTeamMamber.getAssignCourseTeamSeqs()[i]);
					o.setTeamMemberSeq(projectTeamMamber.getAssignTeamMemberSeqs()[i]);

					o.copyAudit(projectTeamMamber);

					unassignTeamMembers.add(o);
				}
			}
		}

		// 팀원 -> 팀장 or 팀장 -> 팀으로 역할 변경
		List<UnivCourseTeamProjectMemberVO> chiefTeamMembers = new ArrayList<UnivCourseTeamProjectMemberVO>();
		if (projectTeamMamber.getAssignTeamMemberSeqs() != null) {

			for (int i = 0; i < projectTeamMamber.getAssignTeamMemberSeqs().length; i++) {

				/** TODO : 코드 */
				if (projectTeamMamber.getAssignTransferYns()[i].equals("N")) {
					if (!projectTeamMamber.getOldAssignChiefYns()[i].equals(projectTeamMamber.getAssignChiefYns()[i])) {

						UnivCourseTeamProjectMemberVO o = new UnivCourseTeamProjectMemberVO();
						o.setCourseTeamSeq(projectTeamMamber.getAssignCourseTeamSeqs()[i]);
						o.setTeamMemberSeq(projectTeamMamber.getAssignTeamMemberSeqs()[i]);
						o.setChiefYn(projectTeamMamber.getAssignChiefYns()[i]);
						o.copyAudit(projectTeamMamber);

						chiefTeamMembers.add(o);
					}

				}
			}
		}

		// 팀 이동
		List<UnivCourseTeamProjectMemberVO> transferTeamMembers = new ArrayList<UnivCourseTeamProjectMemberVO>();
		if (projectTeamMamber.getAssignTeamMemberSeqs() != null) {

			for (int i = 0; i < projectTeamMamber.getAssignTeamMemberSeqs().length; i++) {

				/** TODO : 코드 */
				if (projectTeamMamber.getAssignTransferYns()[i].equals("N")) {

					if (!projectTeamMamber.getOldAssignCourseTeamSeqs()[i].equals(projectTeamMamber.getAssignCourseTeamSeqs()[i])) {
						UnivCourseTeamProjectMemberVO o = new UnivCourseTeamProjectMemberVO();
						o.setCourseTeamSeq(projectTeamMamber.getAssignCourseTeamSeqs()[i]);
						o.setOldCourseTeamSeq(projectTeamMamber.getOldAssignCourseTeamSeqs()[i]);
						o.setTeamMemberSeq(projectTeamMamber.getAssignTeamMemberSeqs()[i]);
						o.setChiefYn(projectTeamMamber.getAssignChiefYns()[i]);
						o.copyAudit(projectTeamMamber);

						transferTeamMembers.add(o);
					}
				}
			}
		}
		courseTeamProjectMemberService.updatelistCourseTeamProjectMember(courseTeamProjectTeam, assignTeamMembers, unassignTeamMembers, chiefTeamMembers,
				transferTeamMembers);
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프로젝트 팀 구성 조회 화면
	 * 
	 * @param req
	 * @param res
	 * @param teamProject
	 * @param teamProjectTeam
	 * @param projectTeamMamber
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/team/detail/popup.do")
	public ModelAndView detailProjectTeam(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectVO teamProject,
			UIUnivCourseTeamProjectTeamVO teamProjectTeam, UIUnivCourseTeamProjectMemberVO projectTeamMamber) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 미 배정된 수강생 목록
		List<ResultSet> unassignMemberList = courseTeamProjectMemberService.getListUnAssignTeamMember(projectTeamMamber);

		if (StringUtil.isEmpty(projectTeamMamber.getCourseTeamSeq())) {
			mav.addObject("unassignMemberCount", unassignMemberList.size());
			mav.addObject("memberList", unassignMemberList);
		} else {
			// 미 배정된 수강생 목록
			mav.addObject("unassignMemberCount", unassignMemberList.size());

			// 배정된 수강생 목록
			mav.addObject("memberList", courseTeamProjectMemberService.getListAssignTeamMember(projectTeamMamber));
		}
		// 팀프로젝트의 팀 목록
		mav.addObject("teamList", courseTeamProjectTeamService.getListAllCourseTeamProjectTeam(projectTeamMamber.getCourseTeamProjectSeq()));
		mav.addObject("totalApplyMember", courseApplyService.countByCourseApplySeq(projectTeamMamber.getCourseActiveSeq()));

		mav.addObject("detail", courseTeamProjectService.getDetailCourseTeamProject(teamProject));
		mav.addObject("projectTeamMamber", projectTeamMamber);

		mav.setViewName("/univ/courseActiveElement/teamProject/deailProjectTeamMemberPopup");
		return mav;
	}

	/**
	 * 개설과목 팀프로젝트 복사 처리
	 * 
	 * @param req
	 * @param res
	 * @param projectTeam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/copy/insert.do")
	public ModelAndView copyTeamMember(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTeamVO projectTeam) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, projectTeam);

		// 복사할(source) 팀 목록을 가져온다.
		List<ResultSet> resultSets = courseTeamProjectTeamService.getListAllCourseTeamProjectTeam(projectTeam.getSourceCourseTeamProjectSeq());

		List<UnivCourseTeamProjectTeamVO> voList = new ArrayList<UnivCourseTeamProjectTeamVO>();
		for (ResultSet rs : resultSets) {
			UIUnivCourseTeamProjectTeamRS teamRS = (UIUnivCourseTeamProjectTeamRS)rs;
			UnivCourseTeamProjectTeamVO vo = teamRS.getCourseTeamProjectTeam();

			// 복사될(target) 팀프로젝트 일련번호를 넣는다.
			vo.setCourseTeamProjectSeq(projectTeam.getTargetCourseTeamProjectSeq());
			vo.setSourceCourseTeamSeq(vo.getCourseTeamSeq());
			vo.copyAudit(projectTeam);

			voList.add(vo);
		}
		int result = courseTeamProjectTeamService.insertlistCopingProjectTeam(voList);

		if (result > 0) {
			mav.addObject("result", result);
		} else {
			mav.addObject("result", 0);
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 팀원 정보 목록 Ajax
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/teamproject/member/ajax.do")
	public ModelAndView saveMedia(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectMemberVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		List<UnivCourseTeamProjectMemberVO> voList = new ArrayList<UnivCourseTeamProjectMemberVO>();
		for (String index : vo.getCheckkeys()) {
			UIUnivCourseTeamProjectMemberVO o = new UIUnivCourseTeamProjectMemberVO();
			o.setCourseTeamSeq(vo.getCourseTeamSeqs()[Integer.parseInt(index)]);

			voList.add(o);
		}

		mav.addObject("result", courseTeamProjectMemberService.getListAssignTeamMember(voList));

		mav.setViewName("jsonView");
		return mav;
	}
	
	/**
	 * 팀원 일괄 업로드용도의 엑셀 템플릿 다운로드
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/template/excel.do")
	public ModelAndView downloadExcelTeamTemplate(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		mav.addObject(ExcelDownloadView.TEMPLATE_FILE_NAME, JXLS_DOWNLOAD_PATH + "teamTemplate");
		mav.addObject(ExcelDownloadView.DOWNLOAD_FILE_NAME, "팀원_일괄_템플릿_" + DateUtil.getToday("yyyyMMdd"));

		mav.setViewName("excelView");

		return mav;
	}
	
	/**
	 * 팀원 엑셀 업로드
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/teamproject/excel/save.do")
	public ModelAndView uploadExcelApply(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectVO vo, UIUnivCourseTeamProjectTeamVO team,
			UIAttachVO attach) throws Exception {
		requiredSession(req, team);
																						
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/common/save");

		File saveFile = null;
		try {
			attachUtil.copyToBean(attach);
			saveFile = new File(Constants.UPLOAD_PATH_FILE + attach.getSavePath() + "/" + attach.getSaveName());

			List<UnivCourseTeamProjectMemberVO> members = new ArrayList<UnivCourseTeamProjectMemberVO>();
			Map<String, Object> rowDataes = new HashMap<String, Object>();
			rowDataes.put("members", members);

			ExcelParser excelParse = new ExcelParser();

			UIUnivCourseTeamProjectMemberVO memberTeam = null;
			XLSReadStatus readStatus = null;
			memberTeam = new UIUnivCourseTeamProjectMemberVO();
			memberTeam.copyAudit(vo);
			team.setRegMemberSeq(SessionUtil.getMember(req).getMemberSeq());
			team.setUpdMemberSeq(SessionUtil.getMember(req).getMemberSeq());

			readStatus = excelParse.parse(rowDataes, saveFile, JXLS_UPLOAD_PATH + "teamTemplate-jxls-config");

			if (readStatus.isStatusOK()) {

				int successCount = UIcourseTeamProjectTeamService.insertlistMember(members, team);

				mav.addObject("result", "{\"success\":" + successCount + "}");
			} else {
				mav.addObject("result", "{\"success\":-1}");
			}
		} catch (XLSDataReadException xlsException) {
			if (saveFile != null && saveFile.exists()) {
				saveFile.delete();
			}
			xlsException.printStackTrace();
			log.error(xlsException);

			mav.addObject("result", "{\"success\":-1,\"error\": \"" + xlsException.getCellName() + "\",\"message\": \"" + xlsException.getMessage() + "\"}");

			return mav;
		} finally {
			if (saveFile != null && saveFile.exists()) {
				saveFile.delete();
			}
		}
		return mav;
	}
}
