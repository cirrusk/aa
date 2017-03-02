/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.cdms.service.CdmsCommentService;
import com._4csoft.aof.cdms.service.CdmsOutputService;
import com._4csoft.aof.cdms.service.CdmsProjectService;
import com._4csoft.aof.cdms.service.CdmsSectionService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsCommentVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectVO;
import com._4csoft.aof.ui.cdms.vo.condition.UICdmsCommentCondition;
import com._4csoft.aof.ui.cdms.vo.resultset.UICdmsCommentRS;
import com._4csoft.aof.ui.cdms.vo.resultset.UICdmsOutputRS;
import com._4csoft.aof.ui.cdms.vo.resultset.UICdmsProjectRS;
import com._4csoft.aof.ui.cdms.vo.resultset.UICdmsSectionRS;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Section : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.cdms.web
 * @File : UICdmsSectionController.java
 * @Title : CDMS 산출물 댓글
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICdmsCommentController extends BaseController {

	@Resource (name = "CdmsCommentService")
	private CdmsCommentService commentService;

	@Resource (name = "CdmsProjectService")
	private CdmsProjectService projectService;

	@Resource (name = "CdmsSectionService")
	private CdmsSectionService sectionService;

	@Resource (name = "CdmsOutputService")
	private CdmsOutputService outputService;

	/**
	 * 댓글 목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/comment/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UICdmsCommentCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=10", "orderby=0");

		mav.addObject("paginate", commentService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/cdms/comment/listComment");
		return mav;
	}

	/**
	 * 댓글 목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = {"/cdms/comment/process/list.do","/cdms/comment/process/list/iframe.do"})
	public ModelAndView listProcess(HttpServletRequest req, HttpServletResponse res, UICdmsCommentCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req);

		Long projectSeq = condition.getSrchProjectSeq();

		String viewType = HttpUtil.getParameter(req, "viewType", "list");
		if ("calendar".equals(viewType)) {

			// 프로젝트 상세정보
			UICdmsProjectVO project = new UICdmsProjectVO();
			project.setProjectSeq(projectSeq);
			UICdmsProjectRS projectRS = (UICdmsProjectRS)projectService.getDetail(project);

			if (projectRS != null) {

				// 프로젝트 기간
				Date sDate = DateUtil.getFormatDate(projectRS.getProject().getStartDate(), Constants.FORMAT_DBDATETIME);
				Date eDate = DateUtil.getFormatDate(projectRS.getProject().getEndDate(), Constants.FORMAT_DBDATETIME);
				List<Date> listDate = new ArrayList<Date>();
				while (eDate.after(sDate)) {
					listDate.add(sDate);
					sDate = DateUtil.addDate(sDate, 1);
				}
				mav.addObject("listDate", listDate);

				// 개발단계 목록
				Map<Long, ResultSet> mapSection = new HashMap<Long, ResultSet>();
				List<ResultSet> listSection = sectionService.getListByProject(projectSeq);
				mav.addObject("listSection", listSection);

				int lengthSection = listSection.size();
				for (int x = 0; x < lengthSection; x++) {
					UICdmsSectionRS sectionRS = (UICdmsSectionRS)listSection.get(x);
					mapSection.put(sectionRS.getSection().getSectionIndex(), sectionRS);
				}

				// 산출물 목록
				List<ResultSet> listOutput = outputService.getListByProject(project.getProjectSeq());
				String nextStartDate = projectRS.getProject().getStartDate();

				Map<String, ResultSet> mapStartSection = new HashMap<String, ResultSet>();
				Map<String, ResultSet> mapEndSection = new HashMap<String, ResultSet>();
				Map<String, ResultSet> mapStartOutput = new HashMap<String, ResultSet>();
				Map<String, ResultSet> mapEndOutput = new HashMap<String, ResultSet>();

				Long startedSectionIndex = 0L;
				UICdmsOutputRS startedRS = null;
				int lengthOutput = listOutput.size();
				for (int x = 0; x < lengthOutput; x++) {
					UICdmsOutputRS rs = (UICdmsOutputRS)listOutput.get(x);
					rs.getOutput().setStartDate(nextStartDate);

					if (StringUtil.isNotEmpty(rs.getOutput().getStartDate())) {
						mapStartOutput.put(rs.getOutput().getStartDate(), rs);

						// 새 작업단계 시작
						if (startedSectionIndex.equals(rs.getOutput().getSectionIndex()) == false) {
							startedSectionIndex = rs.getOutput().getSectionIndex();
							mapStartSection.put(rs.getOutput().getStartDate(), mapSection.get(startedSectionIndex));

							// 전 작업단계 종료
							if (startedRS != null && StringUtil.isNotEmpty(startedRS.getOutput().getEndDate())) {
								Date eDateOutput = DateUtil.getFormatDate(startedRS.getOutput().getEndDate(), Constants.FORMAT_DBDATETIME);
								mapEndSection.put(DateUtil.getFormatString(eDateOutput, Constants.FORMAT_DBDATETIME_START),
										mapSection.get(startedRS.getOutput().getSectionIndex()));
							}
						}
					}
					if (StringUtil.isNotEmpty(rs.getOutput().getEndDate())) {
						Date eDateOutput = DateUtil.getFormatDate(rs.getOutput().getEndDate(), Constants.FORMAT_DBDATETIME);
						mapEndOutput.put(DateUtil.getFormatString(eDateOutput, Constants.FORMAT_DBDATETIME_START), rs);
						nextStartDate = DateUtil.getFormatString(DateUtil.addDate(eDateOutput, 1), Constants.FORMAT_DBDATETIME_START);
					}
					startedRS = rs;

				}
				// 마지막 작업단계 종료
				if (startedRS != null && StringUtil.isNotEmpty(startedRS.getOutput().getEndDate())) {
					Date eDateOutput = DateUtil.getFormatDate(startedRS.getOutput().getEndDate(), Constants.FORMAT_DBDATETIME);
					mapEndSection.put(DateUtil.getFormatString(eDateOutput, Constants.FORMAT_DBDATETIME_START),
							mapSection.get(startedRS.getOutput().getSectionIndex()));
				}

				mav.addObject("mapStartOutput", mapStartOutput); // 시작 산출물
				mav.addObject("mapEndOutput", mapEndOutput); // 종료 산출물

				mav.addObject("mapStartSection", mapStartSection); // 시작 개발단계
				mav.addObject("mapEndSection", mapEndSection); // 종료 개발단계

				// 공정정보
				Map<String, List<ResultSet>> mapProcess = new LinkedHashMap<String, List<ResultSet>>();
				condition.setCurrentPage(0);
				condition.setOrderby(1);
				Paginate<ResultSet> paginate = commentService.getListProcess(condition);
				if (paginate != null) {
					List<ResultSet> listItem = paginate.getItemList();
					if (listItem != null) {
						for (int index = 0; index < listItem.size(); index++) {
							UICdmsCommentRS rs = (UICdmsCommentRS)listItem.get(index);
							Date rDate = DateUtil.getFormatDate(rs.getComment().getRegDtime(), Constants.FORMAT_DBDATETIME);
							String key = DateUtil.getFormatString(rDate, Constants.FORMAT_DBDATETIME_START);

							List<ResultSet> list = mapProcess.get(key);
							if (list == null) {
								list = new ArrayList<ResultSet>();
							}
							list.add(rs);

							mapProcess.put(key, list);
						}
					}
				}
				mav.addObject("mapProcess", mapProcess);
			}

		} else if ("list".equals(viewType)) {
			emptyValue(condition, "currentPage=1", "perPage=10", "orderby=0");
			mav.addObject("paginate", commentService.getListProcess(condition));
			mav.addObject("condition", condition);
		}

		if("/cdms/comment/process/list/iframe.do".equals(req.getServletPath())){
			mav.setViewName("/cdms/comment/listCommentProcessMember");
		} else {
			mav.setViewName("/cdms/comment/listCommentProcess");
		}
		return mav;
	}

	/**
	 * 댓글 등록
	 * 
	 * @param req
	 * @param res
	 * @param comment
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/comment/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UICdmsCommentVO comment) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, comment);

		comment.setIp(HttpUtil.getRemoteAddr(req));

		commentService.insertComment(comment);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 댓글 삭제
	 * 
	 * @param req
	 * @param res
	 * @param comment
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/comment/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UICdmsCommentVO comment) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			requiredSession(req, comment);

			commentService.deleteComment(comment);

			mav.addObject("success", true);

		} catch (Exception e) {
			mav.addObject("success", false);
		}
		mav.setViewName("jsonView");
		return mav;
	}

}
