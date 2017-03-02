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

import com._4csoft.aof.infra.service.BatchHistoryService;
import com._4csoft.aof.ui.infra.vo.condition.UIBatchHistoryCondition;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIBatchController.java
 * @Title : 배치 관리 컨트롤러
 * @date : 2014. 06. 09.
 * @author : 류정희
 * @descrption : 배치 관리 컨트롤러
 */
@Controller
public class UIBatchHistoryController extends BaseController {
	
	@Resource (name = "BatchHistoryService")
	private BatchHistoryService batchHistoryService;
	
	/**
	 * 배치 이력 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/infra/batch/history/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIBatchHistoryCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		requiredSession(req);

		mav.addObject("batchHistoryList", batchHistoryService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/batch/listBatchHistory");
		
		return mav;
	}

}
