/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * 
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivOcwController.java
 * @Title : OCW 메인
 * @date : 2014. 6. 23.
 * @author : 김현우
 * @descrption : OCW 메인
 */
@Controller
public class UIUnivOcwController extends BaseController {

	@RequestMapping ("/univ/ocw/about.do")
	public ModelAndView about(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("/univ/ocw/aboutOcw");

		return mav;
	}
}
