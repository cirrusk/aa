/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.cdms.service.CdmsProjectGroupService;
import com._4csoft.aof.cdms.service.CdmsProjectService;
import com._4csoft.aof.cdms.vo.CdmsProjectCompanyVO;
import com._4csoft.aof.cdms.vo.CdmsProjectMemberVO;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectCompanyVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectGroupVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectMemberVO;
import com._4csoft.aof.ui.cdms.vo.condition.UICdmsProjectCondition;
import com._4csoft.aof.ui.cdms.vo.condition.UICdmsProjectGroupCondition;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.cdms.web
 * @File : UICdmsProjectGroupController.java
 * @Title : 프로젝트 그룹
 * @date : 2014. 3. 14.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICdmsProjectGroupController extends BaseController {

	@Resource (name = "CdmsProjectGroupService")
	private CdmsProjectGroupService projectGroupService;

	@Resource (name = "CdmsProjectService")
	private CdmsProjectService projectService;

	/**
	 * 프로젝트 그룹 목록 검색 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectGroupCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/cdms/project/group/list.do", "/cdms/project/group/list/popup.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UICdmsProjectGroupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		String viewName = "/cdms/projectGroup/listProjectGroup";
		if (req.getServletPath().endsWith("/popup.do")) {
			viewName += "Popup";
		}
		mav.addObject("paginate", projectGroupService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 프로젝트(과목) 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectGroupVO
	 * @param UICdmsProjectGroupCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/group/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UICdmsProjectGroupVO projectGroup, UICdmsProjectGroupCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", projectGroupService.getDetail(projectGroup));
		mav.addObject("condition", condition);

		// 단위개발목록
		UICdmsProjectCondition conditionProject = new UICdmsProjectCondition();
		conditionProject.setCurrentPage(0);
		conditionProject.setSrchProjectGroupSeq(projectGroup.getProjectGroupSeq());
		Paginate<ResultSet> paginate = projectService.getList(conditionProject);
		if (paginate != null) {
			mav.addObject("listProject", paginate.getItemList());
		}
		mav.setViewName("/cdms/projectGroup/detailProjectGroup");
		return mav;
	}

	/**
	 * 프로젝트(과목) 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectGroupCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/group/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UICdmsProjectGroupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);

		mav.setViewName("/cdms/projectGroup/createProjectGroup");
		return mav;
	}

	/**
	 * 프로젝트(과목) 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectGroupVO
	 * @param UICdmsProjectGroupCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/group/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UICdmsProjectGroupVO projectGroup, UICdmsProjectGroupCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", projectGroupService.getDetail(projectGroup));

		mav.addObject("condition", condition);

		mav.setViewName("/cdms/projectGroup/editProjectGroup");
		return mav;
	}

	/**
	 * 프로젝트(과목) 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param project
	 * @param section
	 * @param output
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/group/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UICdmsProjectGroupVO projectGroup) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, projectGroup);

		List<CdmsProjectCompanyVO> companies = new ArrayList<CdmsProjectCompanyVO>();
		if (projectGroup.getCompanyTypeCds() != null) {
			for (int index = 0; index < projectGroup.getCompanyTypeCds().length; index++) {
				String companyTypeCd = projectGroup.getCompanyTypeCds()[index];
				String companySeq = projectGroup.getCompanySeqs()[index];

				if (StringUtil.isNotEmpty(companyTypeCd) && StringUtil.isNotEmpty(companySeq)) {
					for (String seq : companySeq.split(",")) {
						UICdmsProjectCompanyVO o = new UICdmsProjectCompanyVO();
						o.setCompanySeq(Long.parseLong(seq));
						o.setCompanyTypeCd(companyTypeCd);
						o.copyAudit(projectGroup);
						companies.add(o);
					}
				}
			}
		}
		List<CdmsProjectMemberVO> members = new ArrayList<CdmsProjectMemberVO>();
		if (projectGroup.getMemberCdmsTypeCds() != null) {
			for (int index = 0; index < projectGroup.getMemberCdmsTypeCds().length; index++) {
				String memberCdmsTypeCd = projectGroup.getMemberCdmsTypeCds()[index];
				String memberSeq = projectGroup.getMemberSeqs()[index];

				if (StringUtil.isNotEmpty(memberCdmsTypeCd) && StringUtil.isNotEmpty(memberSeq)) {
					for (String seq : memberSeq.split(",")) {
						UICdmsProjectMemberVO o = new UICdmsProjectMemberVO();
						o.setMemberSeq(Long.parseLong(seq));
						o.setMemberCdmsTypeCd(memberCdmsTypeCd);
						o.copyAudit(projectGroup);

						members.add(o);
					}
				}
			}
		}

		projectGroupService.insertProjectGroup(projectGroup, companies, members);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프로젝트(과목) 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectGroupVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/group/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UICdmsProjectGroupVO projectGroup) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, projectGroup);

		List<CdmsProjectCompanyVO> companies = new ArrayList<CdmsProjectCompanyVO>();
		List<CdmsProjectCompanyVO> deleteCompanies = new ArrayList<CdmsProjectCompanyVO>();

		if (projectGroup.getCompanyTypeCds() != null) {
			for (int index = 0; index < projectGroup.getCompanyTypeCds().length; index++) {
				String companyTypeCd = projectGroup.getCompanyTypeCds()[index];
				String companySeq = projectGroup.getCompanySeqs()[index];
				String deleteCompanySeq = projectGroup.getDeleteCompanySeqs()[index];

				if (StringUtil.isNotEmpty(companyTypeCd) && StringUtil.isNotEmpty(companySeq)) {
					for (String seq : companySeq.split(",")) {
						UICdmsProjectCompanyVO o = new UICdmsProjectCompanyVO();
						o.setProjectGroupSeq(projectGroup.getProjectGroupSeq());
						o.setCompanySeq(Long.parseLong(seq));
						o.setCompanyTypeCd(companyTypeCd);
						o.copyAudit(projectGroup);

						companies.add(o);
					}
				}
				if (StringUtil.isNotEmpty(companyTypeCd) && StringUtil.isNotEmpty(deleteCompanySeq)) {
					for (String seq : deleteCompanySeq.split(",")) {
						UICdmsProjectCompanyVO o = new UICdmsProjectCompanyVO();
						o.setProjectGroupSeq(projectGroup.getProjectGroupSeq());
						o.setCompanySeq(Long.parseLong(seq));
						o.setCompanyTypeCd(companyTypeCd);
						o.copyAudit(projectGroup);

						deleteCompanies.add(o);
					}
				}
			}
		}

		List<CdmsProjectMemberVO> members = new ArrayList<CdmsProjectMemberVO>();
		List<CdmsProjectMemberVO> deleteMembers = new ArrayList<CdmsProjectMemberVO>();
		if (projectGroup.getMemberCdmsTypeCds() != null) {
			for (int index = 0; index < projectGroup.getMemberCdmsTypeCds().length; index++) {
				String memberCdmsTypeCd = projectGroup.getMemberCdmsTypeCds()[index];
				String memberSeq = projectGroup.getMemberSeqs()[index];
				String deleteMemberSeq = projectGroup.getDeleteMemberSeqs()[index];

				if (StringUtil.isNotEmpty(memberCdmsTypeCd) && StringUtil.isNotEmpty(memberSeq)) {
					for (String seq : memberSeq.split(",")) {
						UICdmsProjectMemberVO o = new UICdmsProjectMemberVO();
						o.setProjectGroupSeq(projectGroup.getProjectGroupSeq());
						o.setMemberSeq(Long.parseLong(seq));
						o.setMemberCdmsTypeCd(memberCdmsTypeCd);
						o.copyAudit(projectGroup);

						members.add(o);
					}
				}
				if (StringUtil.isNotEmpty(memberCdmsTypeCd) && StringUtil.isNotEmpty(deleteMemberSeq)) {
					for (String seq : deleteMemberSeq.split(",")) {
						UICdmsProjectMemberVO o = new UICdmsProjectMemberVO();
						o.setProjectGroupSeq(projectGroup.getProjectGroupSeq());
						o.setMemberSeq(Long.parseLong(seq));
						o.setMemberCdmsTypeCd(memberCdmsTypeCd);
						o.copyAudit(projectGroup);

						deleteMembers.add(o);
					}
				}
			}
		}

		projectGroupService.updateProjectGroup(projectGroup, companies, deleteCompanies, members, deleteMembers);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프로젝트(과목) 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectGroupVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/group/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UICdmsProjectGroupVO projectGroup) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, projectGroup);

		projectGroupService.deleteProjectGroup(projectGroup);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프로젝트 그룹명 중복검사
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/group/duplicate/json.do")
	public ModelAndView duplicate(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		Long projectGroupSeq = HttpUtil.getParameter(req, "projectGroupSeq", 0L);
		String groupName = HttpUtil.getParameter(req, "groupName", "");

		boolean duplicated = true;
		if (projectGroupService.countGroupName(groupName, projectGroupSeq) > 0) {
			duplicated = true;
		} else {
			duplicated = false;
		}

		mav.addObject("duplicated", duplicated);
		mav.setViewName("jsonView");
		return mav;
	}

}
