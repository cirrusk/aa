package com._4csoft.aof.ui.guide.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.guide.web
 * @File : UIGuideController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 9. 2.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIGuideController extends BaseController {

	/**
	 * 개발 가이드 목록 페이지
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/guide/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/guide/listGuide");
		return mav;
	}

	/**
	 * 개발 가이드 상세 페이지
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/guide/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/guide/detailGuide");
		return mav;
	}

	/**
	 * 개발 가이드 상세 정보 페이지
	 * 
	 * @param req
	 * @param res
	 * @param guideType
	 * @param guideId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/guide/{guideType}/{guideId}.do")
	public ModelAndView item(HttpServletRequest req, HttpServletResponse res, @PathVariable ("guideType") String guideType,
			@PathVariable ("guideId") String guideId) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String viewName = "/guide/" + guideType + "/" + guideId;
		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * json 목록 데이타
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/guide/json.do")
	public ModelAndView json(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/guide/jsonGuide");
		return mav;
	}

}
