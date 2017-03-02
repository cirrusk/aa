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
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamPaperElementVO;
import com._4csoft.aof.univ.service.UnivCourseExamPaperElementService;
import com._4csoft.aof.univ.vo.UnivCourseExamPaperElementVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseExamPaperElementController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 4.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseExamPaperElementController extends BaseController {

	@Resource (name = "UnivCourseExamPaperElementService")
	private UnivCourseExamPaperElementService courseExamPaperElementService;

	/**
	 * 시험지문제 다중 등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExamPaperElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/element/insertlist.do")
	public ModelAndView insertlist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperElementVO courseExamPaperElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExamPaperElement);

		List<UnivCourseExamPaperElementVO> courseExamPaperElements = new ArrayList<UnivCourseExamPaperElementVO>();
		if (courseExamPaperElement.getExamSeqs() != null) {
			for (int index = 0; index < courseExamPaperElement.getExamSeqs().length; index++) {
				UnivCourseExamPaperElementVO o = new UnivCourseExamPaperElementVO();
				o.setExamSeq(courseExamPaperElement.getExamSeqs()[index]);
				o.setPaperNumber(courseExamPaperElement.getPaperNumbers()[index]);
				o.setSortOrder(courseExamPaperElement.getSortOrders()[index]);
				o.setExamPaperSeq(courseExamPaperElement.getExamPaperSeq());
				o.setRegMemberSeq(courseExamPaperElement.getRegMemberSeq());
				o.setRegIp(courseExamPaperElement.getRegIp());
				o.setUpdMemberSeq(courseExamPaperElement.getUpdMemberSeq());
				o.setUpdIp(courseExamPaperElement.getUpdIp());
				/** TODO : 코드 */
				o.setOnOffCd("on");
				courseExamPaperElements.add(o);
			}
		}
		if (courseExamPaperElements.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseExamPaperElementService.savelistExamPaperElement(courseExamPaperElements));
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 시험지문제 다중 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExamPaperElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/element/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperElementVO courseExamPaperElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExamPaperElement);

		List<UnivCourseExamPaperElementVO> courseExamPaperElements = new ArrayList<UnivCourseExamPaperElementVO>();
		for (int index = 0; index < courseExamPaperElement.getExamSeqs().length; index++) {
			UnivCourseExamPaperElementVO o = new UnivCourseExamPaperElementVO();
			o.setExamSeq(courseExamPaperElement.getExamSeqs()[index]);
			o.setExamPaperSeq(courseExamPaperElement.getExamPaperSeqs()[index]);
			o.setSortOrder(courseExamPaperElement.getSortOrders()[index]);
			o.setPaperNumber(courseExamPaperElement.getPaperNumbers()[index]);
			o.setUpdMemberSeq(courseExamPaperElement.getUpdMemberSeq());
			o.setUpdIp(courseExamPaperElement.getUpdIp());
			courseExamPaperElements.add(o);
		}

		if (courseExamPaperElements.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseExamPaperElementService.savelistExamPaperElement(courseExamPaperElements));
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 시험지문제 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExamPaperElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/element/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperElementVO courseExamPaperElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExamPaperElement);

		List<UnivCourseExamPaperElementVO> courseExamPaperElements = new ArrayList<UnivCourseExamPaperElementVO>();
		for (String index : courseExamPaperElement.getCheckkeys()) {
			UnivCourseExamPaperElementVO o = new UnivCourseExamPaperElementVO();
			o.setExamSeq(courseExamPaperElement.getExamSeqs()[Integer.parseInt(index)]);
			o.setExamPaperSeq(courseExamPaperElement.getExamPaperSeqs()[Integer.parseInt(index)]);
			o.setUpdMemberSeq(courseExamPaperElement.getUpdMemberSeq());
			o.setUpdIp(courseExamPaperElement.getUpdIp());
			courseExamPaperElements.add(o);
		}

		if (courseExamPaperElements.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseExamPaperElementService.deletelistExamPaperElement(courseExamPaperElements));
		}
		mav.setViewName("/common/save");
		return mav;
	}
}
