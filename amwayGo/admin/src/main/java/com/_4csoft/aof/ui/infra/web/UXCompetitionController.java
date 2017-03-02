/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.ui.infra.service.UXCompetitionService;
import com._4csoft.aof.ui.infra.vo.UXCompetitionVO;

/**
 * @Project : aof5-demo-2-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UICompanyController.java
 * @Title : 소속
 * @date : 2013. 9. 2.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UXCompetitionController extends BaseController {

	@Resource (name = "UXCompetitionService")
	private UXCompetitionService competitionService;
	
	
	/**
	 * 대회여부 목록
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/competition/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		
		mav.addObject("detail", competitionService.getListCompetition());
		mav.setViewName("/infra/competition/listCompetition");
		return mav;
	}
	
	@RequestMapping ("/univ/competition/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UXCompetitionVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		competitionService.update(vo);
		mav.setViewName("/common/save");
		return mav;
	}
	
}
