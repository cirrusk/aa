/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.lcms.service.LcmsContentsOrganizationService;
import com._4csoft.aof.lcms.service.LcmsLearnerDatamodelService;
import com._4csoft.aof.ui.infra.web.UnivBaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveElementController.java
 * @Title : 주차 정보
 * @date : 2014. 3. 12.
 * @author : 김현우
 * @descrption : 주차 정보
 * 
 */

@Controller
public class UIUnivCourseActiveElementController extends UnivBaseController {
	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService elementService;

	@Resource (name = "LcmsContentsOrganizationService")
	private LcmsContentsOrganizationService organizationService;

	@Resource (name = "LcmsLearnerDatamodelService")
	private LcmsLearnerDatamodelService learnerDatamodel;

	@Resource (name = "CodeService")
	private CodeService codeService;

	/**
	 * 주차 목록 화면 (2014-04-01 이전 UI에서 사용중)
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param courseApply
	 * @param activeElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/course/active/element/organization/list.do")
	public ModelAndView listOrganization(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseActiveElementVO activeElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, activeElement);
		setCourseActive(req, courseActive);

		activeElement.setCourseActiveSeq(courseActive.getCourseActiveSeq());
		activeElement.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		activeElement.setCourseWeekTypeCd("COURSE_WEEK_TYPE::LECTURE");
		activeElement.setCourseApplySeq(courseApply.getCourseApplySeq());

		// 평균 진도율
		mav.addObject("totalProgress", elementService.getTotalResultDatamodelGroup(activeElement));

		// 나의 진도율
		mav.addObject("applyTotalProgress", elementService.getTotalResultDatamodelGroupApply(activeElement));

		// 주차
		mav.addObject("itemList", elementService.getListResultDatamodel(activeElement));

		mav.addObject("courseApply", courseApply);
		mav.addObject("courseActive", courseActive);
		mav.setViewName("/univ/classroom/courseActiveElement/listActiveElementOraganization");
		return mav;
	}

	/**
	 * 주차 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param courseApply
	 * @param activeElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/course/active/element/organization/list/ajax.do")
	public ModelAndView listOrganizationAjax(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive,
			UIUnivCourseApplyVO courseApply, UIUnivCourseActiveElementVO activeElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, activeElement);
		setCourseActive(req, courseActive);

		activeElement.setCourseActiveSeq(courseActive.getCourseActiveSeq());
		activeElement.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		activeElement.setCourseWeekTypeCd("COURSE_WEEK_TYPE::LECTURE");
		activeElement.setCourseApplySeq(courseApply.getCourseApplySeq());

		// 주차
		mav.addObject("itemList", elementService.getListResultDatamodel(activeElement));

		mav.setViewName("/univ/classroom/include/studyClassroomAjax");
		return mav;
	}

	/**
	 * 전체 진도 총합 정보 json으로 가져오기
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param courseApply
	 * @param activeElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/course/active/element/organization/total/json.do")
	public ModelAndView totalOrganizationJson(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive,
			UIUnivCourseApplyVO courseApply, UIUnivCourseActiveElementVO activeElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, activeElement);

		activeElement.setCourseActiveSeq(courseActive.getCourseActiveSeq());
		activeElement.setCourseApplySeq(courseApply.getCourseApplySeq());

		// 평균 진도율
		mav.addObject("totalProgress", elementService.getTotalResultDatamodelGroup(activeElement));

		// 나의 진도율
		mav.addObject("applyTotalProgress", elementService.getTotalResultDatamodelGroupApply(activeElement));

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 전체 진도 총합 정보 json으로 가져오기
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param courseApply
	 * @param activeElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/course/active/element/organization/now/study/json.do")
	public ModelAndView nowFirstStudyJson(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseActiveElementVO activeElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, activeElement);

		mav.addObject("firstStudy",
				learnerDatamodel.getFirstStudy(courseActive.getCourseActiveSeq(), courseApply.getCourseApplySeq(), courseActive.getCourseTypeCd()));

		mav.setViewName("jsonView");
		return mav;
	}

}
