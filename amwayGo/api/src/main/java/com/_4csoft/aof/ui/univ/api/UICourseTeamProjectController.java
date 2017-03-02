/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.api;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.univ.dto.CourseTeamProjectDTO;
import com._4csoft.aof.ui.univ.dto.CourseTeamProjectListDTO;
import com._4csoft.aof.ui.univ.dto.CourseTeamProjectTeamDTO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseTeamProjectMemberRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseTeamProjectRS;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectMemberService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectMutualevalService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectMemberVO;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.api
 * @File : UICourseTeamProjectController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 20.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICourseTeamProjectController extends UIBaseController {
	@Resource (name = "UnivCourseTeamProjectService")
	private UnivCourseTeamProjectService univCourseTeamProjectService;

	@Resource (name = "UnivCourseTeamProjectTeamService")
	private UnivCourseTeamProjectTeamService univCourseTeamProjectTeamService;

	@Resource (name = "UnivCourseTeamProjectMutualevalService")
	private UnivCourseTeamProjectMutualevalService univCourseTeamProjectMutualevalService;

	@Resource (name = "UnivCourseTeamProjectMemberService")
	private UnivCourseTeamProjectMemberService courseTeamProjectMemberService;

	/**
	 * 강의실의 팀프로젝트 리스트
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/classroom/teamproject/listdata")
	public ModelAndView teamProjectListdata(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;
		checkSession(req);
		UIUnivCourseTeamProjectVO teamProject = new UIUnivCourseTeamProjectVO();
		teamProject.setCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
		
		requiredSession(req, teamProject);
		List<ResultSet> rsList = univCourseTeamProjectService.getListCourseTeamProject(teamProject);

		List<CourseTeamProjectListDTO> items = new ArrayList<CourseTeamProjectListDTO>();
		for (ResultSet rs : rsList) {
			UIUnivCourseTeamProjectRS courseTeamProjectRS = (UIUnivCourseTeamProjectRS)rs;
			CourseTeamProjectListDTO dto = new CourseTeamProjectListDTO();
			
			BeanUtils.copyProperties(dto, courseTeamProjectRS.getCourseTeamProject());
			
			items.add(dto);
		}

		mav.addObject("items", items);

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}
	
	/**
	 * 강의실의 팀프로젝트
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/classroom/teamproject/list")
	public ModelAndView listTeamProject(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;
		checkSession(req);
		UIUnivCourseTeamProjectVO teamProject = new UIUnivCourseTeamProjectVO();
		teamProject.setCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
		if(StringUtil.isNotEmpty(req.getParameter("courseTeamProjectSeq"))){
			teamProject.setCourseTeamProjectSeq(Long.parseLong(req.getParameter("courseTeamProjectSeq")));
		}
		requiredSession(req, teamProject);
		teamProject.setSrchTotalTeamYn("Y");
		List<ResultSet> rsList = univCourseTeamProjectService.getListAllCourseTeamProjectByUser(teamProject);

		List<CourseTeamProjectDTO> items = new ArrayList<CourseTeamProjectDTO>();
		for (ResultSet rs : rsList) {
			UIUnivCourseTeamProjectRS courseTeamProjectRS = (UIUnivCourseTeamProjectRS)rs;
			CourseTeamProjectDTO dto = new CourseTeamProjectDTO();
			BeanUtils.copyProperties(dto, courseTeamProjectRS.getCourseTeamProjectTeam());
			BeanUtils.copyProperties(dto, courseTeamProjectRS.getCourseTeamProject());

			// 팀별 게시물수
			dto.setBbsCount(courseTeamProjectRS.getCourseActiveBbs().getBbsCount());
			// 팀별 최근 게시물수
			dto.setNewsCnt(courseTeamProjectRS.getCourseActiveBbs().getNewsCnt());

			UnivCourseTeamProjectMemberVO projectMemberVO = new UnivCourseTeamProjectMemberVO();
			projectMemberVO.setCourseTeamProjectSeq(courseTeamProjectRS.getCourseTeamProject().getCourseTeamProjectSeq());
			projectMemberVO.setCourseTeamSeq(courseTeamProjectRS.getCourseTeamProjectTeam().getCourseTeamSeq());

			List<ResultSet> teamMemberRsList = courseTeamProjectMemberService.getListAssignTeamMember(projectMemberVO);

			List<CourseTeamProjectTeamDTO> memberlist = new ArrayList<CourseTeamProjectTeamDTO>();
			dto.setMyTeamYn("N");
			if (teamMemberRsList != null) {
				for (ResultSet memberrs : teamMemberRsList) {
					UIUnivCourseTeamProjectMemberRS projectMemberRS = (UIUnivCourseTeamProjectMemberRS)memberrs;
					CourseTeamProjectTeamDTO memberDto = new CourseTeamProjectTeamDTO();
					BeanUtils.copyProperties(memberDto, projectMemberRS.getCourseTeamProjectMember());

					memberDto.setCourseTeamProjectSeq(courseTeamProjectRS.getCourseTeamProject().getCourseTeamProjectSeq());
					memberDto.setTeamMemberName(projectMemberRS.getMember().getMemberName());
					memberDto.setCompanyName(projectMemberRS.getMember().getCompanyName());

					// 내가 속한 팀여부를 구분한다.
					if (projectMemberRS.getCourseTeamProjectMember().getTeamMemberSeq().equals(SessionUtil.getMember(req).getMemberSeq())) {
						dto.setMyTeamYn("Y");
					}
					memberlist.add(memberDto);
				}
			}
			dto.setMemberlist(memberlist);
			items.add(dto);
		}

		mav.addObject("items", items);

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}

}
