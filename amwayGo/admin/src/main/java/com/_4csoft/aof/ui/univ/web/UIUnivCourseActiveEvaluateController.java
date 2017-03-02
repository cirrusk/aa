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
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.vo.UnivCourseActiveEvaluateVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveEvaluateController.java
 * @Title : 평가기준
 * @date : 2014. 2. 26.
 * @author : 장용기
 * @descrption : 교과목구성정보 > 평가기준설정
 * 
 */
@Controller
public class UIUnivCourseActiveEvaluateController extends BaseController {
	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService univCourseActiveEvaluateService;
	
	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService univCourseActiveService;

	/**
	 * 평가기준 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/evaluate/edit.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveEvaluateVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		vo.copyShortcut();

		mav.addObject("list", univCourseActiveEvaluateService.getList(vo));
		
		// 개설과목 정보
		UIUnivCourseActiveVO courseActive = new UIUnivCourseActiveVO();
		courseActive.setCourseActiveSeq(vo.getCourseActiveSeq());
		mav.addObject("getDetail", univCourseActiveService.getDetailCourseActive(courseActive));

		mav.setViewName("/univ/courseActiveElement/courseActiveEvaluate/editCourseActiveEvaluate");
		return mav;
	}
	
	/**
	 * 평가기준 수정
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseActiveEvaluateVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/evaluate/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveEvaluateVO vo, UIUnivCourseActiveVO courseActive) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo, courseActive);
		List<UnivCourseActiveEvaluateVO> list = new ArrayList<UnivCourseActiveEvaluateVO>();

		if (vo.getEvaluateSeqs().length > 0) {
			for (int i = 0; i < vo.getEvaluateSeqs().length; i++) {
				UIUnivCourseActiveEvaluateVO o = new UIUnivCourseActiveEvaluateVO();
				o.setEvaluateSeq(vo.getEvaluateSeqs()[i]);
				o.setCourseActiveSeq(vo.getCourseActiveSeq());
				o.setEvaluateTypeCd(vo.getEvaluateTypeCds()[i]);
				o.setScore(vo.getScores()[i]);
				o.setLimitScore(vo.getLimitScores()[i]);
				o.copyAudit(vo);
				list.add(o);
			}
		}

		univCourseActiveEvaluateService.saveCourseActiveEvaluate(list);

		// 평가등급 수정
		univCourseActiveService.updateCourseActive(courseActive);
		
		mav.setViewName("/common/save");
		return mav;
	}
}
