/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.util.HttpUtil;

/**
 * @Project : aof5-demo-www
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UICommonController.java
 * @Title : UICommon Controller
 * @date : 2013. 5. 24.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICommonController extends BaseController {
	protected final Log log = LogFactory.getLog(getClass());

	/**
	 * api를 테스트 할 수 있는 페이지
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/api/index.do")
	public ModelAndView indexApi(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("/common/api/index");
		return mav;
	}

	/**
	 * api 페이지
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/api/file.do")
	public ModelAndView fileApi(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("/common/api/" + HttpUtil.getParameter(req, "filename", "empty"));
		return mav;
	}

}
