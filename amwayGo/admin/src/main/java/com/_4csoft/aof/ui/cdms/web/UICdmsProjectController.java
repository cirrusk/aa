/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.cdms.service.CdmsBbsService;
import com._4csoft.aof.cdms.service.CdmsChargeService;
import com._4csoft.aof.cdms.service.CdmsCommentService;
import com._4csoft.aof.cdms.service.CdmsModuleService;
import com._4csoft.aof.cdms.service.CdmsOutputService;
import com._4csoft.aof.cdms.service.CdmsProjectCompanyService;
import com._4csoft.aof.cdms.service.CdmsProjectGroupService;
import com._4csoft.aof.cdms.service.CdmsProjectMemberService;
import com._4csoft.aof.cdms.service.CdmsProjectService;
import com._4csoft.aof.cdms.service.CdmsSectionService;
import com._4csoft.aof.cdms.vo.CdmsOutputVO;
import com._4csoft.aof.cdms.vo.CdmsProjectCompanyVO;
import com._4csoft.aof.cdms.vo.CdmsProjectMemberVO;
import com._4csoft.aof.cdms.vo.CdmsProjectVO;
import com._4csoft.aof.cdms.vo.CdmsSectionVO;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.FileUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.cdms.vo.UICdmsOutputVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectCompanyVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectMemberVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsSectionVO;
import com._4csoft.aof.ui.cdms.vo.condition.UICdmsBbsCondition;
import com._4csoft.aof.ui.cdms.vo.condition.UICdmsCommentCondition;
import com._4csoft.aof.ui.cdms.vo.condition.UICdmsProjectCondition;
import com._4csoft.aof.ui.cdms.vo.resultset.UICdmsModuleRS;
import com._4csoft.aof.ui.cdms.vo.resultset.UICdmsOutputRS;
import com._4csoft.aof.ui.cdms.vo.resultset.UICdmsProjectCompanyRS;
import com._4csoft.aof.ui.cdms.vo.resultset.UICdmsProjectRS;
import com._4csoft.aof.ui.cdms.vo.resultset.UICdmsSectionRS;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.cdms.web
 * @File : UICdmsProjectController.java
 * @Title : CDMS 프로젝트(과목)
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICdmsProjectController extends BaseController {

	@Resource (name = "CdmsProjectService")
	private CdmsProjectService projectService;

	@Resource (name = "CdmsProjectCompanyService")
	private CdmsProjectCompanyService projectCompanyService;

	@Resource (name = "CdmsProjectMemberService")
	private CdmsProjectMemberService projectMemberService;

	@Resource (name = "CdmsSectionService")
	private CdmsSectionService sectionService;

	@Resource (name = "CdmsOutputService")
	private CdmsOutputService outputService;

	@Resource (name = "CdmsModuleService")
	private CdmsModuleService moduleService;

	@Resource (name = "CdmsChargeService")
	private CdmsChargeService chargeService;

	@Resource (name = "CdmsCommentService")
	private CdmsCommentService commentService;

	@Resource (name = "CdmsBbsService")
	private CdmsBbsService bbsService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	@Resource (name = "CdmsProjectGroupService")
	private CdmsProjectGroupService projectGroupService;

	/**
	 * 프로젝트(과목) 메인(대쉬보드) 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/main.do")
	public ModelAndView main(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIBoardRS detailBoard = (UIBoardRS)boardService.getDetailByReference("cdms", -1L, "BOARD_TYPE::NOTICE");
		if (detailBoard != null) {
			Long boardSeq = detailBoard.getBoard().getBoardSeq();
			UICdmsBbsCondition condition = new UICdmsBbsCondition();

			condition.setSrchBoardSeq(boardSeq);

			mav.addObject("paginateNotice", bbsService.getList(condition));
		}
		mav.setViewName("/cdms/project/mainProject");
		return mav;
	}

	/**
	 * 프로젝트(과목) 메인(대쉬보드) 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/myproject/list.do")
	public ModelAndView listMy(HttpServletRequest req, HttpServletResponse res, UICdmsProjectCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		// 최신 개발그룹검색
		if (condition.getSrchProjectGroupSeq() == null) {
			condition.setSrchProjectGroupSeq(projectGroupService.getDetailMyGroup(SessionUtil.getMember(req).getMemberSeq()));
		}

		condition.setSrchSessionMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		mav.addObject("paginageMyProject", projectService.getMyProjectList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/cdms/project/listMyProject");
		return mav;
	}

	/**
	 * 프로젝트(과목) 목록 화면 / 과정선택 팝업 화면 / 프로젝트 진척현황 목록 화면 / 프로젝트 산출콘텐츠 관리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/cdms/project/list.do", "/cdms/project/list/popup.do", "/cdms/project/process/list.do", "/cdms/project/data/list.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UICdmsProjectCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		if ("/cdms/project/list.do".equals(req.getServletPath())) {
			mav.setViewName("/cdms/project/listProject");

		} else if ("/cdms/project/list/popup.do".equals(req.getServletPath())) {
			mav.setViewName("/cdms/project/listProjectPopup");

		} else if ("/cdms/project/process/list.do".equals(req.getServletPath())) {
			mav.setViewName("/cdms/project/listProjectProcess");

		} else if ("/cdms/project/data/list.do".equals(req.getServletPath())) {
			condition.setSrchCompleteYn("Y");
			mav.setViewName("/cdms/project/listProjectData");
		}
		mav.addObject("paginate", projectService.getList(condition));
		mav.addObject("condition", condition);

		return mav;
	}

	/**
	 * 프로젝트(과목) 상세정보 화면, 프로젝트(과목) 상세정보 Ajax 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectVO
	 * @param UICdmsProjectCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/cdms/project/detail.do", "/cdms/project/member/detail/iframe.do" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UICdmsProjectVO project, UICdmsProjectCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UICdmsProjectRS projectRS = (UICdmsProjectRS)projectService.getDetail(project);
		mav.addObject("detailProject", projectRS);
		// 참여업체
		mav.addObject("listProjectCompany", projectCompanyService.getListByProject(project.getProjectSeq()));
		// 참여인력
		mav.addObject("listProjectMember", projectMemberService.getListProject(project.getProjectSeq()));
		// 참여인력(프로젝트그룹 총괄PM)
		if (StringUtil.isNotEmpty(projectRS.getProject().getProjectGroupSeq())) {
			mav.addObject("listProjectGroupMember", projectMemberService.getListProjectGroup(projectRS.getProject().getProjectGroupSeq()));
		}
		mav.addObject("listSection", sectionService.getListByProject(project.getProjectSeq()));
		mav.addObject("listOutput", outputService.getListByProject(project.getProjectSeq()));
		mav.addObject("listModule", moduleService.getListByProject(project.getProjectSeq()));

		mav.addObject("condition", condition);

		if ("/cdms/project/member/detail/iframe.do".equals(req.getServletPath())) {
			mav.setViewName("/cdms/project/detailProjectMember");
		} else {
			mav.setViewName("/cdms/project/detailProject");
		}
		return mav;
	}

	/**
	 * 프로젝트(과목) 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UICdmsProjectCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);

		mav.addObject("listDefaultSection", sectionService.getListByProject(-1L));
		mav.addObject("listDefaultOutput", outputService.getListByProject(-1L));

		mav.setViewName("/cdms/project/createProject");
		return mav;
	}

	/**
	 * 프로젝트(과목) 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectVO
	 * @param UICdmsProjectCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UICdmsProjectVO project, UICdmsProjectCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 프로젝트 상세정보
		UICdmsProjectRS projectRS = (UICdmsProjectRS)projectService.getDetail(project);

		// 개발단계 목록
		List<ResultSet> listSection = sectionService.getListByProject(project.getProjectSeq());
		// 산출물 목록
		List<ResultSet> listOutput = outputService.getListByProject(project.getProjectSeq());
		// 차시모듈 목록
		List<ResultSet> listModule = moduleService.getListByProject(project.getProjectSeq());

		Date today = DateUtil.getToday();
		Date startDate = DateUtil.getFormatDate(projectRS.getProject().getStartDate(), Constants.FORMAT_DBDATETIME);
		String nextOutputEditableYn = today.after(startDate) ? "N" : "Y"; // 프로젝트가 시작되었으면 첫번째 산출물은 수정 불가능.

		int lengthOutput = listOutput.size();
		for (int x = 0; x < lengthOutput; x++) {
			UICdmsOutputRS outputRS = (UICdmsOutputRS)listOutput.get(x);
			if (x == 0 && StringUtil.isEmpty(outputRS.getOutput().getOutputCd())) { // 첫번째 산출물이 설정이 안되어있으면 수정 가능.
				nextOutputEditableYn = "Y";
			}
			outputRS.getOutput().setOutputEditableYn(nextOutputEditableYn);

			if ("Y".equals(outputRS.getOutput().getModuleYn())) { // 차시모듈이 적용된 산출물
				int count = 0; // 완료된 차시모듈의 수
				int lengthModule = listModule.size();
				for (int y = 0; y < lengthModule; y++) {
					UICdmsModuleRS moduleRS = (UICdmsModuleRS)listModule.get(y);
					if (outputRS.getOutput().getOutputIndex().equals(moduleRS.getModule().getOutputIndex())) {
						if ("CDMS_OUTPUT_STATUS::ACCEPT".equals(moduleRS.getModule().getOutputStatusCd())) { // 완료된 모듈 수 계산
							count++;
						}
					}
				}
				nextOutputEditableYn = count == projectRS.getProject().getModuleCount().intValue() ? "N" : "Y"; // 모든 차시모듈이 승인 되지 않았으면 수정 불가능

			} else {
				nextOutputEditableYn = "CDMS_OUTPUT_STATUS::ACCEPT".equals(outputRS.getOutput().getOutputStatusCd()) ? "N" : "Y"; // 산출물이 완료(승인) 되었으면 다음 산출물은 수정
																																	// 불가능
			}
		}

		int lengthSection = listSection.size();
		for (int x = 0; x < lengthSection; x++) {
			UICdmsSectionRS sectionRS = (UICdmsSectionRS)listSection.get(x);
			int count = 0; // 수정 불가능한 산출물의 수
			for (int y = 0; y < lengthOutput; y++) {
				UICdmsOutputRS outputRS = (UICdmsOutputRS)listOutput.get(y);
				if (sectionRS.getSection().getSectionIndex().equals(outputRS.getOutput().getSectionIndex())) {
					if ("N".equals(outputRS.getOutput().getOutputEditableYn())) { // 수정 불가능한 산출물 수 계산
						count++;
					}
				}
			}
			sectionRS.getSection().setSectionEditableYn(count > 0 ? "N" : "Y"); // 수정 불가능한 산출물이 존재하면 수정 불가능.
		}

		mav.addObject("detailProject", projectRS);
		mav.addObject("listSection", listSection);
		mav.addObject("listOutput", listOutput);
		mav.addObject("listModule", listModule);
		// 참여업체
		mav.addObject("listProjectCompany", projectCompanyService.getListByProject(project.getProjectSeq()));
		// 참여인력
		mav.addObject("listProjectMember", projectMemberService.getListProject(project.getProjectSeq()));
		// 참여인력(프로젝트그룹 총괄PM)
		if (StringUtil.isNotEmpty(projectRS.getProject().getProjectGroupSeq())) {
			mav.addObject("listProjectGroupMember", projectMemberService.getListProjectGroup(projectRS.getProject().getProjectGroupSeq()));
		}

		mav.addObject("condition", condition);

		mav.setViewName("/cdms/project/editProject");
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
	@RequestMapping ("/cdms/project/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UICdmsProjectVO project, UICdmsSectionVO section, UICdmsOutputVO output)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, project);

		List<CdmsProjectCompanyVO> companies = new ArrayList<CdmsProjectCompanyVO>();
		if (project.getCompanyTypeCds() != null) {
			for (int index = 0; index < project.getCompanyTypeCds().length; index++) {
				String companyTypeCd = project.getCompanyTypeCds()[index];
				String companySeq = project.getCompanySeqs()[index];

				if (StringUtil.isNotEmpty(companyTypeCd) && StringUtil.isNotEmpty(companySeq)) {
					for (String seq : companySeq.split(",")) {
						UICdmsProjectCompanyVO o = new UICdmsProjectCompanyVO();
						o.setCompanySeq(Long.parseLong(seq));
						o.setCompanyTypeCd(companyTypeCd);
						o.copyAudit(project);
						companies.add(o);
					}
				}
			}
		}
		List<CdmsProjectMemberVO> members = new ArrayList<CdmsProjectMemberVO>();
		if (project.getMemberCdmsTypeCds() != null) {
			for (int index = 0; index < project.getMemberCdmsTypeCds().length; index++) {
				String memberCdmsTypeCd = project.getMemberCdmsTypeCds()[index];
				String memberSeq = project.getMemberSeqs()[index];

				if (StringUtil.isNotEmpty(memberCdmsTypeCd) && StringUtil.isNotEmpty(memberSeq)) {
					for (String seq : memberSeq.split(",")) {
						UICdmsProjectMemberVO o = new UICdmsProjectMemberVO();
						o.setMemberSeq(Long.parseLong(seq));
						o.setMemberCdmsTypeCd(memberCdmsTypeCd);
						o.copyAudit(project);

						members.add(o);
					}
				}
			}
		}

		List<CdmsSectionVO> sections = new ArrayList<CdmsSectionVO>();
		if (section.getSectionNames() != null) {
			for (int index = 0; index < section.getSectionNames().length; index++) {
				UICdmsSectionVO o = new UICdmsSectionVO();
				o.setSectionIndex(section.getSectionIndexs()[index]);
				o.setSectionName(section.getSectionNames()[index]);
				o.copyAudit(project);

				sections.add(o);
			}
		}
		List<CdmsOutputVO> outputs = new ArrayList<CdmsOutputVO>();
		if (output.getOutputCds() != null) {
			for (int index = 0; index < output.getOutputCds().length; index++) {
				UICdmsOutputVO o = new UICdmsOutputVO();
				o.setSectionIndex(output.getOutputSectionIndexs()[index]);
				o.setOutputIndex(output.getOutputIndexs()[index]);
				o.copyAudit(project);

				outputs.add(o);
			}
		}

		// 달력에서 선택한 날짜(시작일) convert
		if (StringUtil.isNotEmpty(project.getStartDate())) {
			project.setStartDate(DateUtil.convertStartDate(project.getStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}
		// 달력에서 선택한 날짜(종료일) convert
		if (StringUtil.isNotEmpty(project.getEndDate())) {
			project.setEndDate(DateUtil.convertEndDate(project.getEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		}

		int result = projectService.insertProject(project, companies, members);

		mav.addObject("result", "{\"success\":\"" + result + "\", \"projectSeq\":\"" + project.getProjectSeq() + "\"}");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프로젝트(과목) 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UICdmsProjectVO project) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, project);

		List<CdmsProjectCompanyVO> companies = new ArrayList<CdmsProjectCompanyVO>();
		List<CdmsProjectCompanyVO> deleteCompanies = new ArrayList<CdmsProjectCompanyVO>();

		if (project.getCompanyTypeCds() != null) {
			for (int index = 0; index < project.getCompanyTypeCds().length; index++) {
				String companyTypeCd = project.getCompanyTypeCds()[index];
				String companySeq = project.getCompanySeqs()[index];
				String deleteCompanySeq = project.getDeleteCompanySeqs()[index];

				if (StringUtil.isNotEmpty(companyTypeCd) && StringUtil.isNotEmpty(companySeq)) {
					for (String seq : companySeq.split(",")) {
						UICdmsProjectCompanyVO o = new UICdmsProjectCompanyVO();
						o.setProjectSeq(project.getProjectSeq());
						o.setCompanySeq(Long.parseLong(seq));
						o.setCompanyTypeCd(companyTypeCd);
						o.copyAudit(project);

						companies.add(o);
					}
				}
				if (StringUtil.isNotEmpty(companyTypeCd) && StringUtil.isNotEmpty(deleteCompanySeq)) {
					for (String seq : deleteCompanySeq.split(",")) {
						UICdmsProjectCompanyVO o = new UICdmsProjectCompanyVO();
						o.setProjectSeq(project.getProjectSeq());
						o.setCompanySeq(Long.parseLong(seq));
						o.setCompanyTypeCd(companyTypeCd);
						o.copyAudit(project);

						deleteCompanies.add(o);
					}
				}
			}
		}
		List<CdmsProjectMemberVO> members = new ArrayList<CdmsProjectMemberVO>();
		List<CdmsProjectMemberVO> deleteMembers = new ArrayList<CdmsProjectMemberVO>();
		if (project.getMemberCdmsTypeCds() != null) {
			for (int index = 0; index < project.getMemberCdmsTypeCds().length; index++) {
				String memberCdmsTypeCd = project.getMemberCdmsTypeCds()[index];
				String memberSeq = project.getMemberSeqs()[index];
				String deleteMemberSeq = project.getDeleteMemberSeqs()[index];

				if (StringUtil.isNotEmpty(memberCdmsTypeCd) && StringUtil.isNotEmpty(memberSeq)) {
					for (String seq : memberSeq.split(",")) {
						UICdmsProjectMemberVO o = new UICdmsProjectMemberVO();
						o.setProjectSeq(project.getProjectSeq());
						o.setMemberSeq(Long.parseLong(seq));
						o.setMemberCdmsTypeCd(memberCdmsTypeCd);
						o.copyAudit(project);

						members.add(o);
					}
				}
				if (StringUtil.isNotEmpty(memberCdmsTypeCd) && StringUtil.isNotEmpty(deleteMemberSeq)) {
					for (String seq : deleteMemberSeq.split(",")) {
						UICdmsProjectMemberVO o = new UICdmsProjectMemberVO();
						o.setProjectSeq(project.getProjectSeq());
						o.setMemberSeq(Long.parseLong(seq));
						o.setMemberCdmsTypeCd(memberCdmsTypeCd);
						o.copyAudit(project);

						deleteMembers.add(o);
					}
				}
			}
		}

		// 차시수 변경되었으면 차시모듈 삭제.
		boolean clearModule = false;
		if (StringUtil.isNotEmpty(project.getOldModuleCount()) && StringUtil.isNotEmpty(project.getModuleCount())
				&& project.getOldModuleCount().equals(project.getModuleCount()) == false) {
			clearModule = true;
		}

		// 달력에서 선택한 날짜(시작일) convert
		if (StringUtil.isNotEmpty(project.getStartDate())) {
			project.setStartDate(DateUtil.convertStartDate(project.getStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}
		// 달력에서 선택한 날짜(종료일) convert
		if (StringUtil.isNotEmpty(project.getEndDate())) {
			project.setEndDate(DateUtil.convertEndDate(project.getEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		}

		int result = projectService.updateProject(project, companies, deleteCompanies, members, deleteMembers, clearModule);

		mav.addObject("result", "{\"success\":\"" + result + "\", \"projectSeq\":\"" + project.getProjectSeq() + "\"}");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프로젝트(과목) 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UICdmsProjectVO project) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, project);

		projectService.deleteProject(project);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프로젝트(과목) 개발단계 상세 화면
	 * 
	 * @param req
	 * @param res
	 * @param project
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/section/detail.do")
	public ModelAndView detailSection(HttpServletRequest req, HttpServletResponse res, UICdmsProjectVO project, UICdmsProjectCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 프로젝트 상세정보
		UICdmsProjectRS projectRS = (UICdmsProjectRS)projectService.getDetail(project);

		// 개발단계 목록
		List<ResultSet> listSection = sectionService.getListByProject(project.getProjectSeq());
		// 산출물 목록
		List<ResultSet> listOutput = outputService.getListByProject(project.getProjectSeq());
		// 차시모듈 목록
		List<ResultSet> listModule = moduleService.getListByProject(project.getProjectSeq());

		Date today = DateUtil.getToday();
		Date startDate = DateUtil.getFormatDate(projectRS.getProject().getStartDate(), Constants.FORMAT_DBDATETIME);
		String nextOutputEditableYn = today.after(startDate) ? "N" : "Y"; // 프로젝트가 시작되었으면 첫번째 산출물은 수정 불가능.
		String nextStartDate = projectRS.getProject().getStartDate();

		int lengthOutput = listOutput.size();
		for (int x = 0; x < lengthOutput; x++) {
			UICdmsOutputRS outputRS = (UICdmsOutputRS)listOutput.get(x);
			outputRS.getOutput().setOutputEditableYn(nextOutputEditableYn);
			outputRS.getOutput().setStartDate(nextStartDate);

			// 산출물이 완료(승인) 되었으면 다음 산출물은 수정 불가능
			nextOutputEditableYn = "Y".equals(outputRS.getOutput().getCompleteYn()) ? "N" : "Y";

			// 산출물 작업 시작일이 되었고 완료(승인)가 아니면 작업 가능
			if (StringUtil.isNotEmpty(outputRS.getOutput().getStartDate())) {
				Date sDate = DateUtil.getFormatDate(outputRS.getOutput().getStartDate(), Constants.FORMAT_DBDATETIME);
				outputRS.getOutput().setOutputWorkYn(today.after(sDate) && "Y".equals(outputRS.getOutput().getCompleteYn()) == false ? "Y" : "N");
			} else {
				outputRS.getOutput().setOutputWorkYn("N");
			}

			if (StringUtil.isNotEmpty(outputRS.getOutput().getEndDate())) {
				Date eDate = DateUtil.getFormatDate(outputRS.getOutput().getEndDate(), Constants.FORMAT_DBDATETIME);
				nextStartDate = DateUtil.getFormatString(DateUtil.addDate(eDate, 1), Constants.FORMAT_DBDATETIME_START);
			} else {
				nextStartDate = "";
			}
		}

		int lengthSection = listSection.size();
		for (int x = 0; x < lengthSection; x++) {
			UICdmsSectionRS sectionRS = (UICdmsSectionRS)listSection.get(x);
			int count = 0; // 수정 불가능한 산출물의 수
			int incomplete = 0; // 완료되지 않은 산출물의 수
			for (int y = 0; y < lengthOutput; y++) {
				UICdmsOutputRS outputRS = (UICdmsOutputRS)listOutput.get(y);
				if (sectionRS.getSection().getSectionIndex().equals(outputRS.getOutput().getSectionIndex())) {
					if ("N".equals(outputRS.getOutput().getOutputEditableYn())) { // 수정 불가능한 산출물 수 계산
						count++;
					}
					if ("N".equals(outputRS.getOutput().getCompleteYn())) { // 완료되지 않은 산출물 수 계산
						incomplete++;
					}
				}
			}
			// 수정 불가능한 산출물이 존재하면 수정 불가능.
			sectionRS.getSection().setSectionEditableYn(count > 0 ? "N" : "Y");

			// 완료되지 않은 산출물이 존재하면 미완료
			sectionRS.getSection().setSectionCompleteYn(incomplete > 0 ? "N" : "Y");
		}

		mav.addObject("detailProject", projectRS);
		mav.addObject("listSection", listSection);

		// 선택된 개발단계
		Long sectionIndex = HttpUtil.getParameter(req, "sectionIndex", 0L);
		if (StringUtil.isEmpty(sectionIndex)) {
			sectionIndex = projectRS.getProject().getCurrentSectionIndex();
		}
		if (StringUtil.isEmpty(sectionIndex) && listSection != null) {
			UICdmsSectionRS sectionRS = (UICdmsSectionRS)listSection.get(0);
			sectionIndex = sectionRS.getSection().getSectionIndex();
		}
		mav.addObject("currentSectionIndex", sectionIndex);

		if (StringUtil.isNotEmpty(sectionIndex)) {
			// 선택된 개발단계의 산출물 목록
			List<ResultSet> listOutputs = new ArrayList<ResultSet>();
			for (int x = 0; x < lengthOutput; x++) {
				UICdmsOutputRS outputRS = (UICdmsOutputRS)listOutput.get(x);
				if (sectionIndex.equals(outputRS.getOutput().getSectionIndex())) {
					listOutputs.add(outputRS);
				}
			}
			mav.addObject("listOutput", listOutputs);

			// 선택된 산출물
			Long outputIndex = HttpUtil.getParameter(req, "outputIndex", 0L);
			if (StringUtil.isEmpty(outputIndex) && listOutput != null) {
				UICdmsOutputRS outputRS = (UICdmsOutputRS)listOutputs.get(0);
				outputIndex = outputRS.getOutput().getOutputIndex();
			}
			mav.addObject("currentOutputIndex", outputIndex);

			if (StringUtil.isNotEmpty(outputIndex)) {
				// 산출물의 차시모듈 목록
				List<ResultSet> listModules = new ArrayList<ResultSet>();
				int lengthModule = listModule.size();
				for (int y = 0; y < lengthModule; y++) {
					UICdmsModuleRS moduleRS = (UICdmsModuleRS)listModule.get(y);
					if (outputIndex.equals(moduleRS.getModule().getOutputIndex())) {
						listModules.add(moduleRS);
					}
				}
				mav.addObject("listModule", listModules);

				// 산출물의 담당자 목록
				mav.addObject("listCharge", chargeService.getListByOutput(project.getProjectSeq(), sectionIndex, outputIndex));
			}

			// 다음 산출물
			boolean findCurrentOutput = false;
			for (int x = 0; x < lengthOutput; x++) {
				UICdmsOutputRS outputRS = (UICdmsOutputRS)listOutput.get(x);
				if (findCurrentOutput == true) {
					mav.addObject("nextOutput", outputRS);
					break;
				}
				if (sectionIndex.equals(outputRS.getOutput().getSectionIndex()) && outputIndex.equals(outputRS.getOutput().getOutputIndex())) {
					findCurrentOutput = true;
				}
			}
		}

		// 참여업체
		Map<Long, UICdmsProjectCompanyRS> mapProjectCompany = new HashMap<Long, UICdmsProjectCompanyRS>();
		List<ResultSet> listCompany = projectCompanyService.getListByProject(project.getProjectSeq());
		int lengthCompany = listCompany.size();
		for (int x = 0; x < lengthCompany; x++) {
			UICdmsProjectCompanyRS companyRS = (UICdmsProjectCompanyRS)listCompany.get(x);
			mapProjectCompany.put(companyRS.getProjectCompany().getCompanySeq(), companyRS);
		}
		mav.addObject("mapProjectCompany", mapProjectCompany);

		// 참여인력
		mav.addObject("listProjectMember", projectMemberService.getListProject(project.getProjectSeq()));
		// 참여인력(프로젝트그룹 총괄PM)
		if (StringUtil.isNotEmpty(projectRS.getProject().getProjectGroupSeq())) {
			mav.addObject("listProjectGroupMember", projectMemberService.getListProjectGroup(projectRS.getProject().getProjectGroupSeq()));
		}

		// 상태 값에 대한 갯수를 세기 위한 hashmap 생성
		mav.addObject("countMapStatusCds", new HashMap<String, Long>());

		mav.addObject("condition", condition);

		mav.setViewName("/cdms/project/detailProjectSection");
		return mav;
	}

	/**
	 * 프로젝트 진척현황정보 상세화면
	 * 
	 * @param req
	 * @param res
	 * @param project
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/process/detail.do")
	public ModelAndView detailProcess(HttpServletRequest req, HttpServletResponse res, UICdmsProjectVO project, UICdmsProjectCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 프로젝트 상세정보
		UICdmsProjectRS projectRS = (UICdmsProjectRS)projectService.getDetail(project);

		// 개발단계 목록
		List<ResultSet> listSection = sectionService.getListByProject(project.getProjectSeq());

		// 산출물 목록
		List<ResultSet> listOutput = outputService.getListByProject(project.getProjectSeq());

		int lengthSection = listSection != null ? listSection.size() : 0;
		int lengthOutput = listOutput != null ? listOutput.size() : 0;
		for (int x = 0; x < lengthSection; x++) {
			UICdmsSectionRS sectionRS = (UICdmsSectionRS)listSection.get(x);
			int incomplete = 0; // 완료되지 않은 산출물의 수
			for (int y = 0; y < lengthOutput; y++) {
				UICdmsOutputRS outputRS = (UICdmsOutputRS)listOutput.get(y);
				if (sectionRS.getSection().getSectionIndex().equals(outputRS.getOutput().getSectionIndex())) {
					if ("N".equals(outputRS.getOutput().getCompleteYn())) { // 완료되지 않은 산출물 수 계산
						incomplete++;
					}
				}
			}
			// 완료되지 않은 산출물이 존재하면 미완료 - 현 진행단계
			if (incomplete > 0) {
				mav.addObject("currentSection", sectionRS); // 현 진행단계
				break;
			}
		}

		int completed = 0; // 완료된 산출물의 수
		int registOutput = 0; // 등록된 산출물 수
		for (int y = 0; y < lengthOutput; y++) {
			UICdmsOutputRS outputRS = (UICdmsOutputRS)listOutput.get(y);
			if (StringUtil.isNotEmpty(outputRS.getOutput().getOutputCd())) {
				registOutput++;
			}
			if ("Y".equals(outputRS.getOutput().getCompleteYn())) { // 완료된 산출물 수 계산
				completed++;
			}
		}

		// 최종 작업(마지막 1개만)
		UICdmsCommentCondition conditionComment = new UICdmsCommentCondition();
		conditionComment.setCurrentPage(1);
		conditionComment.setPerPage(1);
		conditionComment.setSrchProjectSeq(project.getProjectSeq());
		Paginate<ResultSet> paginate = commentService.getListProcess(conditionComment);
		if (paginate != null) {
			if (paginate.getItemList() != null && paginate.getItemList().size() > 0) {
				mav.addObject("lastProcess", paginate.getItemList().get(0)); // 최종작업
			}
		}

		mav.addObject("detailProject", projectRS);
		mav.addObject("listSection", listSection);
		mav.addObject("countCompletedOutput", completed); // 완료된 산출물 수
		mav.addObject("countTotalOutput", registOutput); // 전체 산출물 수

		mav.addObject("condition", condition);

		mav.setViewName("/cdms/project/detailProjectProcess");
		return mav;
	}

	/**
	 * 산출콘텐츠 관리 다중 상태변경
	 * 
	 * @param req
	 * @param res
	 * @param UIBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/data/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UICdmsProjectVO project) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, project);

		List<CdmsProjectVO> projects = new ArrayList<CdmsProjectVO>();
		for (String index : project.getCheckkeys()) {
			UICdmsProjectVO o = new UICdmsProjectVO();
			o.setProjectSeq(project.getProjectSeqs()[Integer.parseInt(index)]);
			o.setCompleteYn(project.getCompleteYns()[Integer.parseInt(index)]);
			o.copyAudit(project);

			projects.add(o);
		}

		if (projects.size() > 0) {
			mav.addObject("result", projectService.updatelistProject(projects));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 프로젝트 산출물의 파일 상세 화면
	 * 
	 * @param req
	 * @param res
	 * @param project
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/file/detail.do")
	public ModelAndView detailFile(HttpServletRequest req, HttpServletResponse res, UICdmsProjectVO project) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("listSection", sectionService.getListByProject(project.getProjectSeq()));
		mav.addObject("listOutput", outputService.getListByProject(project.getProjectSeq()));
		mav.addObject("detailProject", projectService.getDetail(project));

		String rootPath = "/cdms/" + ((project.getProjectSeq() / 100 + 1) * 100) + "/" + project.getProjectSeq();

		mav.addObject("rootPath", rootPath);

		mav.setViewName("/cdms/project/detailProjectFile");
		return mav;
	}

	/**
	 * LCMS로 파일 또는 폴더 포팅
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/file/porting.do")
	public ModelAndView downloadFile(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		boolean success = false;
		String filepath = HttpUtil.getParameter(req, "filepath", "");
		String filename = HttpUtil.getParameter(req, "filename", "");

		if (StringUtil.isNotEmpty(filepath) && StringUtil.isNotEmpty(filename)) {
			String path = Constants.UPLOAD_PATH_FILE + filepath;
			File file = new File(path);
			if (file != null && file.exists()) {
				File srcFile = null;
				File destFile = new File(Constants.UPLOAD_PATH_LCMS + Constants.DIR_FTP + Constants.DIR_CDMS + "/" + DateUtil.getToday("yyyyMMdd") + "/"
						+ filename);

				String savePath = Constants.UPLOAD_PATH_FILE + Constants.DIR_TEMP + "/" + DateUtil.getToday("yyyy/MM/dd") + "/"
						+ StringUtil.getRandomString(20);
				String zipFilePath = savePath + "/" + file.getName() + ".zip";

				File saveDir = new File(savePath);
				if (saveDir.exists() == false) {
					saveDir.mkdirs();
				}

				List<String> addFilePaths = new ArrayList<String>();
				if (file.isDirectory()) {

					List<File> list = FileUtil.list(path);
					for (File f : list) {
						addFilePaths.add(f.getAbsolutePath());
					}

					srcFile = FileUtil.zip(zipFilePath, addFilePaths, "UTF-8");

				} else {
					addFilePaths.add(file.getAbsolutePath());
					srcFile = FileUtil.zip(zipFilePath, addFilePaths, "UTF-8");
				}
				if (srcFile != null && srcFile.exists()) {
					try {
						if (destFile.exists()) {
							destFile.delete();
						}
						FileUtil.moveFile(srcFile, destFile);
						success = true;
					} catch (Exception e) {
						success = false;
						throw new AofException(Errors.PROCESS_FILE.desc);
					}
				}
			}
		}
		mav.addObject("result", success);
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 회원 프로젝트 이력 목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/member/list/iframe.do")
	public ModelAndView listProjectMember(HttpServletRequest req, HttpServletResponse res, UICdmsProjectCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("listProjectMember", projectMemberService.getListProjectMember(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/cdms/project/listProjectMember");
		return mav;
	}

	/**
	 * 개발대상정보 복사 팝업
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/copy/popup.do")
	public ModelAndView copyPopup(HttpServletRequest req, HttpServletResponse res, UICdmsProjectVO project) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req, project);

		mav.addObject("detailProject", projectService.getDetail(project));
		mav.setViewName("/cdms/project/crateProjectCopyPopup");
		return mav;
	}

	/**
	 * 개발대상정보 복사
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsProjectVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/project/copy/insert.do")
	public ModelAndView copyInsert(HttpServletRequest req, HttpServletResponse res, UICdmsProjectVO project) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req, project);

		List<CdmsProjectVO> projects = new ArrayList<CdmsProjectVO>();
		// 달력에서 선택한 날짜(시작일) convert
		if (StringUtil.isNotEmpty(project.getStartDate())) {
			project.setStartDate(DateUtil.convertStartDate(project.getStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}
		// 달력에서 선택한 날짜(종료일) convert
		if (StringUtil.isNotEmpty(project.getEndDate())) {
			project.setEndDate(DateUtil.convertEndDate(project.getEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		}
		projects.add(project);

		mav.addObject("result", projectService.insertCopylistProject(projects));

		mav.setViewName("/common/save");
		return mav;
	}
}
