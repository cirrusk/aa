/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyPaperElementVO;
import com._4csoft.aof.univ.service.UnivSurveyPaperElementService;
import com._4csoft.aof.univ.vo.UnivSurveyPaperElementVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivSurveyPapeElementrController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 24.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivSurveyPapeElementrController extends BaseController {

	@Resource (name = "UnivSurveyPaperElementService")
	private UnivSurveyPaperElementService univSurveyPaperElementService;

	/**
	 * 설문지문제 다중 등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param univSurveyPaperElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/surveypaperelement/insertlist.do")
	public ModelAndView insertlist(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyPaperElementVO univSurveyPaperElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univSurveyPaperElement);

		List<UnivSurveyPaperElementVO> univSurveyPaperElements = new ArrayList<UnivSurveyPaperElementVO>();
		if (univSurveyPaperElement.getSurveySeqs() != null) {
			for (int index = 0; index < univSurveyPaperElement.getSurveySeqs().length; index++) {
				UnivSurveyPaperElementVO o = new UnivSurveyPaperElementVO();
				o.setSurveySeq(univSurveyPaperElement.getSurveySeqs()[index]);
				o.setSortOrder(univSurveyPaperElement.getSortOrders()[index]);
				o.setSurveyPaperSeq(univSurveyPaperElement.getSurveyPaperSeq());
				o.setRegMemberSeq(univSurveyPaperElement.getRegMemberSeq());
				o.setRegIp(univSurveyPaperElement.getRegIp());
				o.setUpdMemberSeq(univSurveyPaperElement.getUpdMemberSeq());
				o.setUpdIp(univSurveyPaperElement.getUpdIp());
				univSurveyPaperElements.add(o);
			}
		}

		if (univSurveyPaperElements.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univSurveyPaperElementService.savelistSurveyPaperElement(univSurveyPaperElements));
		}
		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 설문지문제 다중 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param univSurveyPaperElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/surveypaperelement/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyPaperElementVO univSurveyPaperElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univSurveyPaperElement);

		List<UnivSurveyPaperElementVO> univSurveyPaperElements = new ArrayList<UnivSurveyPaperElementVO>();
		for (int index = 0; index < univSurveyPaperElement.getSurveySeqs().length; index++) {
			UnivSurveyPaperElementVO o = new UnivSurveyPaperElementVO();
			o.setSurveySeq(univSurveyPaperElement.getSurveySeqs()[index]);
			o.setSurveyPaperSeq(univSurveyPaperElement.getSurveyPaperSeqs()[index]);
			o.setSortOrder(univSurveyPaperElement.getSortOrders()[index]);
			o.setUpdMemberSeq(univSurveyPaperElement.getUpdMemberSeq());
			o.setUpdIp(univSurveyPaperElement.getUpdIp());
			univSurveyPaperElements.add(o);
		}

		if (univSurveyPaperElements.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univSurveyPaperElementService.savelistSurveyPaperElement(univSurveyPaperElements));
		}
		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 설문지문제 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param univSurveyPaperElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/surveypaperelement/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyPaperElementVO univSurveyPaperElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univSurveyPaperElement);

		List<UnivSurveyPaperElementVO> univSurveyPaperElements = new ArrayList<UnivSurveyPaperElementVO>();
		for (String index : univSurveyPaperElement.getCheckkeys()) {
			UnivSurveyPaperElementVO o = new UnivSurveyPaperElementVO();
			o.setSurveySeq(univSurveyPaperElement.getSurveySeqs()[Integer.parseInt(index)]);
			o.setSurveyPaperSeq(univSurveyPaperElement.getSurveyPaperSeqs()[Integer.parseInt(index)]);
			o.setUpdMemberSeq(univSurveyPaperElement.getUpdMemberSeq());
			o.setUpdIp(univSurveyPaperElement.getUpdIp());
			univSurveyPaperElements.add(o);
		}

		if (univSurveyPaperElements.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univSurveyPaperElementService.deletelistSurveyPaperElement(univSurveyPaperElements));
		}
		mav.setViewName("/common/save");

		return mav;
	}

}
