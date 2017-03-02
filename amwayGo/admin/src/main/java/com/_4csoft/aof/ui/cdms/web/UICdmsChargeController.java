/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.cdms.service.CdmsChargeService;
import com._4csoft.aof.cdms.service.CdmsModuleService;
import com._4csoft.aof.cdms.service.CdmsOutputService;
import com._4csoft.aof.cdms.service.CdmsProjectMemberService;
import com._4csoft.aof.cdms.service.CdmsProjectService;
import com._4csoft.aof.cdms.service.CdmsSectionService;
import com._4csoft.aof.cdms.vo.CdmsChargeVO;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsChargeVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectVO;
import com._4csoft.aof.ui.cdms.vo.resultset.UICdmsOutputRS;
import com._4csoft.aof.ui.cdms.vo.resultset.UICdmsProjectRS;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Output : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.cdms.web
 * @File : UICdmsChargeController.java
 * @Title : CDMS 담당자
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICdmsChargeController extends BaseController {

	@Resource (name = "CdmsChargeService")
	private CdmsChargeService chargeService;

	@Resource (name = "CdmsSectionService")
	private CdmsSectionService sectionService;

	@Resource (name = "CdmsOutputService")
	private CdmsOutputService outputService;

	@Resource (name = "CdmsModuleService")
	private CdmsModuleService moduleService;

	@Resource (name = "CdmsProjectMemberService")
	private CdmsProjectMemberService projectMemberService;

	@Resource (name = "CdmsProjectService")
	private CdmsProjectService projectService;

	/**
	 * 담당자 상세 화면
	 * 
	 * @param req
	 * @param res
	 * @param charge
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/charge/detail/popup.do")
	public ModelAndView detailMember(HttpServletRequest req, HttpServletResponse res, UICdmsChargeVO charge) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("listSection", sectionService.getListByProject(charge.getProjectSeq()));
		mav.addObject("listOutput", outputService.getListByProject(charge.getProjectSeq()));
		mav.addObject("listCharge", chargeService.getListByProject(charge.getProjectSeq()));

		UICdmsProjectVO project = new UICdmsProjectVO();
		project.setProjectSeq(charge.getProjectSeq());
		mav.addObject("detailProject", projectService.getDetail(project));

		mav.setViewName("/cdms/charge/detailCharge");
		return mav;
	}

	/**
	 * 담당자 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param charge
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/charge/edit/popup.do")
	public ModelAndView editMember(HttpServletRequest req, HttpServletResponse res, UICdmsChargeVO charge) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 프로젝트 상세정보
		UICdmsProjectVO project = new UICdmsProjectVO();
		project.setProjectSeq(charge.getProjectSeq());
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
			outputRS.getOutput().setOutputEditableYn(nextOutputEditableYn);

			nextOutputEditableYn = "Y".equals(outputRS.getOutput().getCompleteYn()) ? "N" : "Y"; // 산출물이 완료(승인) 되었으면 다음 산출물은 수정 불가능
		}

		mav.addObject("detailProject", projectRS);
		mav.addObject("listSection", listSection);
		mav.addObject("listOutput", listOutput);
		mav.addObject("listModule", listModule);
		mav.addObject("listCharge", chargeService.getListByProject(project.getProjectSeq()));
		mav.addObject("listProjectMember", projectMemberService.getListProject(project.getProjectSeq()));

		mav.setViewName("/cdms/charge/editCharge");
		return mav;
	}

	/**
	 * 담당자 저장
	 * 
	 * @param req
	 * @param res
	 * @param charge
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/charge/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UICdmsChargeVO charge) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, charge);

		List<CdmsChargeVO> voList = new ArrayList<CdmsChargeVO>();
		if (charge.getMemberSeqs() != null) {
			for (int index = 0; index < charge.getMemberSeqs().length; index++) {
				if ("Y".equals(charge.getChargeEditableYns()[index])) {
					Long memberSeq = charge.getMemberSeqs()[index];

					UICdmsChargeVO o = new UICdmsChargeVO();
					o.setProjectSeq(charge.getProjectSeq());
					o.setSectionIndex(charge.getSectionIndexs()[index]);
					o.setOutputIndex(charge.getOutputIndexs()[index]);
					o.setModuleIndex(charge.getModuleIndexs()[index]);
					o.setMemberCdmsTypeCd(charge.getMemberCdmsTypeCds()[index]);
					o.setMemberSeq(memberSeq);
					o.copyAudit(charge);
					voList.add(o);
				}
			}
		}

		chargeService.savelistCharge(voList);

		mav.setViewName("/common/save");
		return mav;
	}
}
