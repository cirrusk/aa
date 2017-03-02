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

import com._4csoft.aof.cdms.service.CdmsModuleService;
import com._4csoft.aof.cdms.vo.CdmsCommentVO;
import com._4csoft.aof.cdms.vo.CdmsModuleVO;
import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.ui.cdms.vo.UICdmsCommentVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsModuleVO;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Output : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.cdms.web
 * @File : UICdmsModuleController.java
 * @Title : CDMS 차시모듈
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICdmsModuleController extends BaseController {

	@Resource (name = "CdmsModuleService")
	private CdmsModuleService moduleService;

	@Resource (name = "CodeService")
	private CodeService codeService;

	/**
	 * 차시모듈 (검수요청, 승인, 반려 처리)
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView(json)
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/module/status/update.do")
	public ModelAndView updateStatus(HttpServletRequest req, HttpServletResponse res, UICdmsModuleVO module) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, module);

		List<CdmsModuleVO> modules = new ArrayList<CdmsModuleVO>();
		List<CdmsCommentVO> comments = new ArrayList<CdmsCommentVO>();
		for (String index : module.getCheckkeys()) {
			UICdmsModuleVO o = new UICdmsModuleVO();
			o.setProjectSeq(module.getProjectSeq());
			o.setSectionIndex(module.getSectionIndex());
			o.setOutputIndex(module.getOutputIndex());
			o.setNextSectionIndex(module.getNextSectionIndex());
			o.setNextOutputIndex(module.getNextOutputIndex());
			o.setModuleIndex(module.getModuleIndexs()[Integer.parseInt(index)]);
			o.setOutputStatusCd(module.getOutputStatusCd());
			o.setCompleteYn("CDMS_OUTPUT_STATUS::ACCEPT".equals(module.getOutputStatusCd()) ? "Y" : "N");
			o.copyAudit(module);
			modules.add(o);

			UICdmsCommentVO comment = new UICdmsCommentVO();
			comment.setProjectSeq(module.getProjectSeq());
			comment.setSectionIndex(module.getSectionIndex());
			comment.setOutputIndex(module.getOutputIndex());
			comment.setModuleIndex(module.getModuleIndexs()[Integer.parseInt(index)]);
			comment.setOutputStatusCd(module.getOutputStatusCd());
			comment.setAutoYn("Y");
			comment.setIp(HttpUtil.getRemoteAddr(req));
			comment.setDescription(module.getAutoDescriptions()[Integer.parseInt(index)]);
			comment.copyAudit(module);
			comments.add(comment);
		}

		if (modules.size() > 0 && comments.size() > 0) {
			mav.addObject("result", moduleService.savelistModule(modules, comments));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");

		return mav;
	}

}
