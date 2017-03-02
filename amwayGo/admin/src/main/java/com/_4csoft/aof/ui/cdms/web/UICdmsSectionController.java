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

import com._4csoft.aof.cdms.service.CdmsOutputService;
import com._4csoft.aof.cdms.service.CdmsSectionService;
import com._4csoft.aof.cdms.vo.CdmsOutputVO;
import com._4csoft.aof.cdms.vo.CdmsSectionVO;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.cdms.vo.UICdmsOutputVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsSectionVO;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Section : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.cdms.web
 * @File : UICdmsSectionController.java
 * @Title : CDMS 개발단계
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICdmsSectionController extends BaseController {

	@Resource (name = "CdmsSectionService")
	private CdmsSectionService sectionService;

	@Resource (name = "CdmsOutputService")
	private CdmsOutputService outputService;

	/**
	 * 개발단계 및 산출물 추가 등록
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView(json)
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/section/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		UICdmsSectionVO voSection = new UICdmsSectionVO();
		UICdmsOutputVO voOutput = new UICdmsOutputVO();
		requiredSession(req, voSection, voOutput);

		Long projectSeq = HttpUtil.getParameter(req, "projectSeq", 0L);
		voSection.setProjectSeq(projectSeq);
		voOutput.setProjectSeq(projectSeq);

		sectionService.insertSection(voSection, voOutput);

		mav.addObject("detailSection", sectionService.getDetail(voSection));
		mav.addObject("detailOutput", outputService.getDetail(voOutput));

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 개발단계 및 산출물 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param section
	 * @param output
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/section/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UICdmsSectionVO section, UICdmsOutputVO output) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, section, output);
		Long projectSeq = section.getProjectSeq();

		List<CdmsSectionVO> sections = new ArrayList<CdmsSectionVO>();
		if (section.getSectionIndexs() != null) {
			for (int index = 0; index < section.getSectionIndexs().length; index++) {
				if ("Y".equals(section.getSectionEditableYns()[index])) {
					Long sectionIndex = section.getSectionIndexs()[index];
					UICdmsSectionVO o = new UICdmsSectionVO();
					o.setProjectSeq(projectSeq);
					o.setSectionIndex(sectionIndex);
					o.setSectionName(section.getSectionNames()[index]);
					o.copyAudit(section);

					sections.add(o);
				}
			}
		}
		List<CdmsOutputVO> outputs = new ArrayList<CdmsOutputVO>();
		if (output.getOutputCds() != null) {
			for (int index = 0; index < output.getOutputCds().length; index++) {
				if ("Y".equals(output.getOutputEditableYns()[index])) {
					UICdmsOutputVO o = new UICdmsOutputVO();
					o.setProjectSeq(projectSeq);
					o.setSectionIndex(output.getOutputSectionIndexs()[index]);
					o.setOutputIndex(output.getOutputIndexs()[index]);
					o.setOutputCd(output.getOutputCds()[index]);
					o.setOutputName(output.getOutputNames()[index]);
					o.setEndDate(output.getEndDates()[index]);
					o.setModuleYn(output.getModuleYns()[index]);
					o.copyAudit(output);

					outputs.add(o);
				}
			}
		}
		int result = sectionService.updatelistSection(sections, outputs);

		mav.addObject("result", "{\"success\":\"" + result + "\", \"projectSeq\":\"" + projectSeq + "\"}");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개발단계 및 산출물 삭제
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView(json)
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/section/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		UICdmsSectionVO voSection = new UICdmsSectionVO();
		requiredSession(req, voSection);

		Long projectSeq = HttpUtil.getParameter(req, "projectSeq", 0L);
		Long sectionIndex = HttpUtil.getParameter(req, "sectionIndex", 0L);
		voSection.setProjectSeq(projectSeq);
		voSection.setSectionIndex(sectionIndex);

		mav.addObject("success", sectionService.deleteSection(voSection));

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 개발단계 목록
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView - json
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/section/list.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		Long projectSeq = HttpUtil.getParameter(req, "projectSeq", 0L);
		if (StringUtil.isNotEmpty(projectSeq)) {
			mav.addObject("listSection", sectionService.getListByProject(projectSeq));
		}
		mav.setViewName("jsonView");
		return mav;
	}

}
