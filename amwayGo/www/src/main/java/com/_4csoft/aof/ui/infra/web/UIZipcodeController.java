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

import com._4csoft.aof.infra.service.ZipcodeOldService;
import com._4csoft.aof.infra.service.ZipcodeService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.condition.UIZipcodeCondition;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIZipcodeController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 2.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIZipcodeController extends BaseController {

	@Resource (name = "ZipcodeOldService")
	private ZipcodeOldService zipcodeOldService;

	@Resource (name = "ZipcodeService")
	private ZipcodeService zipcodeService;

	/**
	 * 우편번호 찾기 팝업 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/zipcode/main/popup.do")
	public ModelAndView main(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIZipcodeCondition condition = new UIZipcodeCondition();
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0", "srchType=old", "srchKey=both");
		mav.addObject("condition", condition);

		mav.setViewName("/infra/zipcode/mainZipcodePopup");
		return mav;
	}

	/**
	 * 우편번호 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIZipcodeCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/zipcode/list.do")
	public ModelAndView listOld(HttpServletRequest req, HttpServletResponse res, UIZipcodeCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0", "srchKey=both");

		if ("new".equals(condition.getSrchType())) { // 신 주소체계
			if (StringUtil.isNotEmpty(condition.getSrchWord())) {
				mav.addObject("paginate", zipcodeService.getList(condition));
			}
		} else { // 구 주소체계
			if (StringUtil.isNotEmpty(condition.getSrchWord())) {
				mav.addObject("paginate", zipcodeOldService.getList(condition));
			}
		}
		mav.addObject("condition", condition);

		mav.setViewName("/infra/zipcode/listZipcode");
		return mav;
	}

}
