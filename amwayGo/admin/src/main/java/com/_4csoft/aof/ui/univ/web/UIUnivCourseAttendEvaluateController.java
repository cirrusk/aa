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
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseAttendEvaluateVO;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseAttendEvaluateService;
import com._4csoft.aof.univ.vo.UnivCourseActiveElementVO;
import com._4csoft.aof.univ.vo.UnivCourseAttendEvaluateVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseAttendEvaluateController.java
 * @Title : 출석 평가기준 컨트롤러
 * @date : 2014. 3. 3.
 * @author : 김현우
 * @descrption : 출석 평가기준 컨트롤러
 */
@Controller
public class UIUnivCourseAttendEvaluateController extends BaseController {

	@Resource (name = "UnivCourseAttendEvaluateService")
	private UnivCourseAttendEvaluateService univCourseAttendEvaluateService;

	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService univCourseActiveEvaluateService;

	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService elementService;

	/**
	 * 출석 평가기준 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/online/edit.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseAttendEvaluateVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		vo.setCourseActiveSeq(vo.getShortcutCourseActiveSeq());
		vo.setOnoffCd("ONOFF_TYPE::ON");

		// 평가기준
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(vo.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		mav.addObject("list", univCourseAttendEvaluateService.getListCourseAttendEvaluate(vo));

		mav.setViewName("/univ/courseActiveElement/online/editAttendEvaluateOn");
		return mav;
	}

	/**
	 * 출석 평가기준 수정
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/online/update.do")
	public ModelAndView updateList(HttpServletRequest req, HttpServletResponse res, UIUnivCourseAttendEvaluateVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		List<UnivCourseAttendEvaluateVO> attendList = new ArrayList<UnivCourseAttendEvaluateVO>();

		for (int index = 0; index < vo.getAttendTypeCds().length; index++) {
			UnivCourseAttendEvaluateVO o = new UnivCourseAttendEvaluateVO();
			o.setCourseActiveSeq(vo.getCourseActiveSeq());
			o.setOnoffCd(vo.getOnoffCd());
			o.setMinusScore(vo.getMinusScores()[index]);
			o.setAttendTypeCd(vo.getAttendTypeCds()[index]);
			o.setCount(vo.getCounts()[index]);
			o.setPermissionCount(vo.getPermissionCounts()[index]);
			o.copyAudit(vo);
			attendList.add(o);
		}

		if (attendList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univCourseAttendEvaluateService.savelistCourseAttendEvaluate(attendList));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 출석 평가기준 오프라인 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/offline/edit.do")
	public ModelAndView listOffline(HttpServletRequest req, HttpServletResponse res, UIUnivCourseAttendEvaluateVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		vo.setCourseActiveSeq(vo.getShortcutCourseActiveSeq());
		vo.setOnoffCd("ONOFF_TYPE::OFF");

		mav.addObject("element", vo);

		UIUnivCourseActiveElementVO element = new UIUnivCourseActiveElementVO();
		element.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		element.setCourseActiveSeq(vo.getShortcutCourseActiveSeq());
		mav.addObject("listElement", elementService.getOfflineElementList(element));

		mav.addObject("list", univCourseAttendEvaluateService.getListCourseAttendEvaluate(vo));

		// 평가비율
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(vo.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		mav.setViewName("/univ/courseActiveElement/offline/editAttendEvaluateOff");
		return mav;
	}

	/**
	 * 출석 평가기준 수정
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/offline/update.do")
	public ModelAndView updateListOffline(HttpServletRequest req, HttpServletResponse res, UIUnivCourseAttendEvaluateVO vo, UIUnivCourseActiveElementVO element)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);
		requiredSession(req, element);

		List<UnivCourseActiveElementVO> elementList = new ArrayList<UnivCourseActiveElementVO>();
		for (int i = 0; i < element.getOfflineLessonCounts().length; i++) {
			UIUnivCourseActiveElementVO o = new UIUnivCourseActiveElementVO();
			o.setActiveElementSeq(element.getActiveElementSeqs()[i]);
			o.setCourseActiveSeq(element.getCourseActiveSeq());
			o.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
			o.setOfflineLessonCount(element.getOfflineLessonCounts()[i]);
			o.copyAudit(vo);

			elementList.add(o);
		}

		List<UnivCourseAttendEvaluateVO> attendList = new ArrayList<UnivCourseAttendEvaluateVO>();
		for (int index = 0; index < vo.getAttendTypeCds().length; index++) {
			UnivCourseAttendEvaluateVO o = new UnivCourseAttendEvaluateVO();
			o.setCourseActiveSeq(vo.getCourseActiveSeq());
			o.setOnoffCd(vo.getOnoffCd());
			o.setMinusScore(vo.getMinusScores()[index]);
			o.setAttendTypeCd(vo.getAttendTypeCds()[index]);
			o.setCount(vo.getCounts()[index]);
			o.setPermissionCount(vo.getPermissionCounts()[index]);
			o.copyAudit(vo);
			attendList.add(o);
		}

		if (attendList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univCourseAttendEvaluateService.savelistCourseAttendEvaluateOffline(attendList, elementList));
		}

		mav.setViewName("/common/save");
		return mav;
	}

}
