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

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyExampleVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivSurveyCondition;
import com._4csoft.aof.univ.service.UnivSurveyService;
import com._4csoft.aof.univ.vo.UnivSurveyExampleVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivSurveyController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 20.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivSurveyController extends BaseController {

	@Resource (name = "UnivSurveyService")
	private UnivSurveyService univSurveyService;

	/**
	 * 설문문제 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/survey/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		// 온라인 오프라인 구분값 설정
		/** TODO : 코드 */
		condition.setSrchOnOffCd("ONOFF_TYPE::ON");

		mav.addObject("paginate", univSurveyService.getList(condition));
		mav.addObject("condition", condition);
		mav.setViewName("/univ/survey/listUnivSurvey");

		return mav;
	}

	/**
	 * 설문문제 팝업 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/survey/list/popup.do")
	public ModelAndView listpopup(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		// 온라인 오프라인 구분값 설정
		/** TODO : 코드 */
		condition.setSrchOnOffCd("ONOFF_TYPE::ON");

		mav.addObject("paginate", univSurveyService.getList(condition));
		mav.addObject("condition", condition);
		mav.setViewName("/univ/survey/listUnivSurveyPopup");

		return mav;
	}

	/**
	 * 설문문제 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param univSurvey
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/survey/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyVO univSurvey, UIUnivSurveyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", univSurveyService.getDetail(univSurvey));
		mav.addObject("condition", condition);
		mav.setViewName("/univ/survey/detailUnivSurvey");

		return mav;
	}

	/**
	 * 설문문제 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param univSurvey
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/survey/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyVO univSurvey, UIUnivSurveyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("univSurvey", univSurvey);
		mav.addObject("condition", condition);
		mav.setViewName("/univ/survey/createUnivSurvey");

		return mav;
	}

	/**
	 * 설문문제 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param univSurvey
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/survey/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyVO univSurvey, UIUnivSurveyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", univSurveyService.getDetail(univSurvey));
		mav.addObject("condition", condition);
		mav.setViewName("/univ/survey/editUnivSurvey");

		return mav;
	}

	/**
	 * 설문문제 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param univSurvey
	 * @param univSurveyExample
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/survey/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyVO univSurvey, UIUnivSurveyExampleVO univSurveyExample)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univSurvey, univSurveyExample);
		// 온라인 오프라인 구분값 설정
		/** TODO : 코드 */
		univSurvey.setOnOffCd("ONOFF_TYPE::ON");

		List<UnivSurveyExampleVO> listSurveyExample = new ArrayList<UnivSurveyExampleVO>();
		if (univSurveyExample.getSurveyExampleTitles() != null) {
			for (int i = 0; i < univSurveyExample.getSurveyExampleTitles().length; i++) {
				UIUnivSurveyExampleVO example = new UIUnivSurveyExampleVO();
				example.setSurveyExampleTitle(univSurveyExample.getSurveyExampleTitles()[i]);
				example.setSortOrder(univSurveyExample.getSortOrders()[i]);
				example.setMeasureScore(univSurveyExample.getMeasureScores()[i]);
				example.setRegMemberSeq(univSurveyExample.getRegMemberSeq());
				example.setRegIp(univSurveyExample.getRegIp());
				example.setUpdMemberSeq(univSurveyExample.getUpdMemberSeq());
				example.setUpdIp(univSurveyExample.getUpdIp());
				listSurveyExample.add(example);
			}
			if (!listSurveyExample.isEmpty()) {
				univSurvey.setListSurveyExample(listSurveyExample);
			}
		}

		univSurveyService.insertSurvey(univSurvey);

		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 설문문제 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param univSurvey
	 * @param univSurveyExample
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/survey/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyVO univSurvey, UIUnivSurveyExampleVO univSurveyExample)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univSurvey, univSurveyExample);
		// 온라인 오프라인 구분값 설정
		/** TODO : 코드 */
		univSurvey.setOnOffCd("ONOFF_TYPE::ON");

		List<UnivSurveyExampleVO> listSurveyExample = new ArrayList<UnivSurveyExampleVO>();
		for (int i = 0; i < univSurveyExample.getSurveyExampleTitles().length; i++) {
			UIUnivSurveyExampleVO example = new UIUnivSurveyExampleVO();
			example.setSurveyExampleSeq(univSurveyExample.getSurveyExampleSeqs()[i]);
			example.setSurveyExampleTitle(univSurveyExample.getSurveyExampleTitles()[i]);
			example.setSortOrder(univSurveyExample.getSortOrders()[i]);
			example.setMeasureScore(univSurveyExample.getMeasureScores()[i]);
			example.setRegMemberSeq(univSurveyExample.getRegMemberSeq());
			example.setRegIp(univSurveyExample.getRegIp());
			example.setUpdMemberSeq(univSurveyExample.getUpdMemberSeq());
			example.setUpdIp(univSurveyExample.getUpdIp());
			listSurveyExample.add(example);
		}
		if (!listSurveyExample.isEmpty()) {
			univSurvey.setListSurveyExample(listSurveyExample);
		}

		univSurveyService.updateSurvey(univSurvey);

		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 설문문제 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param univSurvey
	 * @param univSurveyExample
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/survey/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyVO univSurvey, UIUnivSurveyExampleVO univSurveyExample)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univSurvey, univSurveyExample);

		if (univSurveyExample.getSurveyExampleSeqs() != null) {
			List<UnivSurveyExampleVO> listSurveyExample = new ArrayList<UnivSurveyExampleVO>();
			for (int i = 0; i < univSurveyExample.getSurveyExampleSeqs().length; i++) {
				UIUnivSurveyExampleVO example = new UIUnivSurveyExampleVO();
				example.setSurveyExampleSeq(univSurveyExample.getSurveyExampleSeqs()[i]);
				example.setUpdMemberSeq(univSurveyExample.getUpdMemberSeq());
				example.setUpdIp(univSurveyExample.getUpdIp());
				listSurveyExample.add(example);
			}
			if (!listSurveyExample.isEmpty()) {
				univSurvey.setListSurveyExample(listSurveyExample);
			}
		}

		univSurveyService.deleteSurvey(univSurvey);

		mav.setViewName("/common/save");

		return mav;
	}

}
