/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyPaperElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyPaperVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivSurveyPaperCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivSurveyPaperElementRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivSurveyPaperRS;
import com._4csoft.aof.univ.service.UnivSurveyPaperElementService;
import com._4csoft.aof.univ.service.UnivSurveyPaperService;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivSurveyPaperController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 24.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivSurveyPaperController extends BaseController {

	@Resource (name = "UnivSurveyPaperService")
	private UnivSurveyPaperService univSurveyPaperService;

	@Resource (name = "UnivSurveyPaperElementService")
	private UnivSurveyPaperElementService univSurveyPaperElementService;

	/**
	 * 설문지 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/surveypaper/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyPaperCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		// 온라인 오프라인 구분값 설정
		/** TODO : 코드 */
		condition.setSrchOnOffCd("ONOFF_TYPE::ON");

		mav.addObject("paginate", univSurveyPaperService.getList(condition));
		mav.addObject("condition", condition);
		mav.setViewName("/univ/surveypaper/listUnivSurveyPaper");

		return mav;
	}

	/**
	 * 설문지 목록 화면 - iframe
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/surveypaper/list/popup.do")
	public ModelAndView listIframe(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyPaperCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		// 온라인 오프라인 구분값 설정
		/** TODO : 코드 */
		condition.setSrchOnOffCd("ONOFF_TYPE::ON");

		mav.addObject("paginate", univSurveyPaperService.getList(condition));
		mav.addObject("condition", condition);
		mav.setViewName("/univ/surveypaper/listUnivSurveyPaperPopup");

		return mav;
	}

	/**
	 * 설문지 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param univSurveyPaper
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/surveypaper/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyPaperVO univSurveyPaper, UIUnivSurveyPaperCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivSurveyPaperRS detail = (UIUnivSurveyPaperRS)univSurveyPaperService.getDetail(univSurveyPaper);

		if (detail != null) {
			mav.addObject("detail", detail);

			UIUnivSurveyPaperElementVO univSurveyPaperElement = new UIUnivSurveyPaperElementVO();
			univSurveyPaperElement.setSurveyPaperSeq(detail.getUnivSurveyPaper().getSurveyPaperSeq());
			mav.addObject("listElement", univSurveyPaperElementService.getList(univSurveyPaperElement));
		}

		mav.addObject("condition", condition);
		mav.setViewName("/univ/surveypaper/detailUnivSurveyPaper");

		return mav;
	}

	/**
	 * 설문지 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param univSurveyPaper
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/surveypaper/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyPaperVO univSurveyPaper, UIUnivSurveyPaperCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("univSurveyPaper", univSurveyPaper);
		mav.addObject("condition", condition);

		mav.setViewName("/univ/surveypaper/createUnivSurveyPaper");
		return mav;
	}

	/**
	 * 설문지 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param univSurveyPaper
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/surveypaper/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyPaperVO univSurveyPaper, UIUnivSurveyPaperCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", univSurveyPaperService.getDetail(univSurveyPaper));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/surveypaper/editUnivSurveyPaper");
		return mav;
	}

	/**
	 * 설문지 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param univSurveyPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/surveypaper/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyPaperVO univSurveyPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univSurveyPaper);

		// 온라인 오프라인 구분값 설정
		/** TODO : 코드 */
		univSurveyPaper.setOnOffCd("ONOFF_TYPE::ON");

		int result = univSurveyPaperService.insertSurveyPaper(univSurveyPaper);

		mav.addObject("result", "{\"success\":\"" + result + "\",\"surveyPaperSeq\":\"" + univSurveyPaper.getSurveyPaperSeq() + "\"}");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 설문지 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param univSurveyPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/surveypaper/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyPaperVO univSurveyPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univSurveyPaper);

		univSurveyPaperService.updateSurveyPaper(univSurveyPaper);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 설문지 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param univSurveyPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/surveypaper/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyPaperVO univSurveyPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univSurveyPaper);
		
		UIUnivSurveyPaperElementVO surveyPaperElement = new UIUnivSurveyPaperElementVO();
		surveyPaperElement.setSurveyPaperSeq(univSurveyPaper.getSurveyPaperSeq());
		List<ResultSet> rs = univSurveyPaperElementService.getList(surveyPaperElement);
		
		if (rs != null && rs.size() > 0) {
			Long[] surveySeqs = new Long[rs.size()];
			for (int i=0; i < rs.size(); i++) {
				UIUnivSurveyPaperElementRS surveyPaperElementRS = (UIUnivSurveyPaperElementRS)rs.get(i);
				surveySeqs[i] = surveyPaperElementRS.getUnivSurvey().getSurveySeq();
			}
			univSurveyPaper.setSurveySeqs(surveySeqs);
		}

		univSurveyPaperService.deleteSurveyPaper(univSurveyPaper);

		mav.setViewName("/common/save");
		return mav;
	}
	
	/**
	 * 설문지 미리보기
	 * 
	 * @param req
	 * @param res
	 * @param univSurveyPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/surveypaper/preview/popup.do")
	public ModelAndView preview(HttpServletRequest req, HttpServletResponse res, UIUnivSurveyPaperVO univSurveyPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		
		UIUnivSurveyPaperRS detail = (UIUnivSurveyPaperRS)univSurveyPaperService.getDetail(univSurveyPaper);
		
		if (detail != null) {
			UIUnivSurveyPaperElementVO elementVO = new UIUnivSurveyPaperElementVO();
			elementVO.setSurveyPaperSeq(detail.getUnivSurveyPaper().getSurveyPaperSeq());
			mav.addObject("detailSurveyPaper", detail);
			mav.addObject("listElement", univSurveyPaperElementService.getList(elementVO));
		}
		
		mav.setViewName("/univ/surveypaper/previewUnivSurveyPaper");
		return mav;
	}

}
