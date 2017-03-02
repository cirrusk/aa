/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.session.api;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.session.service.UISessionService;
import com._4csoft.aof.ui.session.vo.condition.UISessionCondition;

/**
 * @Project : lgaca-api
 * @Package : com._4csoft.aof.ui.session.api
 * @File : UISessionController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 8. 17.
 * @author : 조성훈
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UISessionController extends UIBaseController {
	
	@Resource (name = "UISessionService")
	private UISessionService uiSessionService;

	/**
	 * session list
	 * 
	 * @param req
	 * @param res
	 * @return json
	 * @throws Exception
	 */
	@RequestMapping ("/api/session/list")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		UISessionCondition conditionVO = new UISessionCondition();

		
		//TODO TEST
		Paginate<ResultSet> p =  uiSessionService.getList(conditionVO);
		ResultSet rs = uiSessionService.getDetail(conditionVO) ;
		

		mav.setViewName("jsonView");

		return mav;
	}
	
}
