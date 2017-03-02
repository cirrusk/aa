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
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussTemplateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCoursePostEvaluateVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseDiscussApplyCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseDiscussService;
import com._4csoft.aof.univ.service.UnivCourseDiscussTemplateService;
import com._4csoft.aof.univ.service.UnivCoursePostEvaluateService;
import com._4csoft.aof.univ.vo.UnivCourseDiscussVO;
import com._4csoft.aof.univ.vo.UnivCoursePostEvaluateVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseDiscussController.java
 * @Title : 토론
 * @date : 2014. 2. 27.
 * @author : 김영학
 * @descrption : 교과목 구성정보 토론
 */
@Controller
public class UIUnivCourseDiscussController extends BaseController {

	@Resource (name = "UnivCourseDiscussService")
	private UnivCourseDiscussService univCourseDiscussService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "UnivCoursePostEvaluateService")
	private UnivCoursePostEvaluateService coursePostEvaluateService;

	@Resource (name = "UnivCourseDiscussTemplateService")
	private UnivCourseDiscussTemplateService courseDiscussTemplateService;

	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService univCourseActiveEvaluateService;

	/**
	 * 토론 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param discuss
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/discuss/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseDiscussVO discuss)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		discuss.copyShortcut();

		mav.addObject("discuss", discuss);
		mav.addObject("itemList", univCourseDiscussService.getListCourseDiscuss(discuss));

		// 평가비율
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(discuss.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		mav.setViewName("/univ/courseActiveElement/discuss/listDiscuss");
		return mav;
	}

	/**
	 * 개설과목 토론 등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param discuss
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/discuss/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseDiscussVO discuss,
			UIUnivCourseDiscussTemplateVO template) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 탬플릿
		if (StringUtil.isNotEmpty(template.getTemplateSeq())) {
			mav.addObject("discussTemplate", courseDiscussTemplateService.getDetailCourseDiscussTemplate(template));
		}

		// masterSeq 알아오기위해 조회
		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));
		mav.addObject("discuss", discuss);

		mav.setViewName("/univ/courseActiveElement/discuss/createDiscuss");
		return mav;
	}

	/**
	 * 개설과목 토론 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param discuss
	 * @param postEvaluate
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/discuss/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussVO discuss, UIUnivCoursePostEvaluateVO postEvaluate,
			UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, discuss, postEvaluate);

		// [1].평가기준 등록
		List<UnivCoursePostEvaluateVO> coursePostEvaluateList = new ArrayList<UnivCoursePostEvaluateVO>();
		if (postEvaluate.getPostEvaluateSeqs() != null) {
			for (int index = 0; index < postEvaluate.getPostEvaluateSeqs().length; index++) {
				UIUnivCoursePostEvaluateVO o = new UIUnivCoursePostEvaluateVO();
				o.setPostEvaluateSeq(postEvaluate.getPostEvaluateSeqs()[index]);
				o.setCourseActiveSeq(postEvaluate.getCourseActiveSeq());
				o.setPostType(postEvaluate.getPostType());
				o.setFromCount(postEvaluate.getFromCounts()[index]);
				o.setToCount(postEvaluate.getToCounts()[index]);
				o.setScore(postEvaluate.getScores()[index]);
				o.setSortOrder(postEvaluate.getSortOrders()[index]);
				o.copyAudit(postEvaluate);
				coursePostEvaluateList.add(o);
			}
		}

		// [2]. 토론등록 (토론등록시 평가기준 같이 등록)
		univCourseDiscussService.insertCourseDiscuss(discuss, attach, coursePostEvaluateList);

		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 개설과목 토론 평가비율 다중수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param discuss
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/discuss/rate/updatelist.do")
	public ModelAndView updatelistRates(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussVO discuss) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, discuss);
		discuss.copyShortcut();

		List<UnivCourseDiscussVO> discussList = new ArrayList<UnivCourseDiscussVO>();
		for (int i = 0; i < discuss.getRates().length; i++) {
			UIUnivCourseDiscussVO o = new UIUnivCourseDiscussVO();
			o.setCourseActiveSeq(discuss.getCourseActiveSeq());
			o.setDiscussSeq(discuss.getDiscussSeqs()[i]);
			o.setRate(discuss.getRates()[i]);
			o.copyAudit(discuss);

			discussList.add(o);
		}

		if (discussList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univCourseDiscussService.updatelistCourseDiscuss(discussList));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 토론 다중 삭제
	 * 
	 * @param req
	 * @param res
	 * @param discuss
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/discuss/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussVO discuss) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, discuss);

		List<UnivCourseDiscussVO> discussList = new ArrayList<UnivCourseDiscussVO>();

		for (String index : discuss.getCheckkeys()) {
			UIUnivCourseDiscussVO o = new UIUnivCourseDiscussVO();
			o.setCourseActiveSeq(discuss.getShortcutCourseActiveSeq());
			o.setDiscussSeq(discuss.getDiscussSeqs()[Integer.parseInt(index)]);
			o.copyAudit(discuss);
			discussList.add(o);
		}

		if (discussList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univCourseDiscussService.deletelistCourseDiscuss(discussList));
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 토론 상세화면
	 * 
	 * @param req
	 * @param res
	 * @param discuss
	 * @param postEvaluate
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/discuss/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseDiscussVO discuss,
			UIUnivCoursePostEvaluateVO postEvaluate) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));

		// 토론데이터 조회
		mav.addObject("detail", univCourseDiscussService.getDetailCourseDiscuss(discuss));

		// 평가기준데이터 조회
		mav.addObject("listBoardPostEvaluate", coursePostEvaluateService.getList(postEvaluate));

		mav.setViewName("/univ/courseActiveElement/discuss/detailDiscuss");

		return mav;
	}

	/**
	 * 토론 수정화면
	 * 
	 * @param req
	 * @param res
	 * @param discuss
	 * @param postEvaluate
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/discuss/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussVO discuss, UIUnivCoursePostEvaluateVO postEvaluate,
			UIUnivCourseDiscussTemplateVO template) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 탬플릿111
		if (StringUtil.isNotEmpty(template.getTemplateSeq())) {
			mav.addObject("discussTemplate", courseDiscussTemplateService.getDetailCourseDiscussTemplate(template));
		}

		// 토론데이터 조회
		mav.addObject("detail", univCourseDiscussService.getDetailCourseDiscuss(discuss));

		// 평가기준데이터 조회
		mav.addObject("listBoardPostEvaluate", coursePostEvaluateService.getList(postEvaluate));

		mav.setViewName("/univ/courseActiveElement/discuss/editDiscuss");
		return mav;
	}

	/**
	 * 토론 수정
	 * 
	 * @param req
	 * @param res
	 * @param discuss
	 * @param postEvaluate
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/discuss/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussVO discuss, UIUnivCoursePostEvaluateVO postEvaluate,
			UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, discuss, postEvaluate);

		// [1]. 토론 데이터 수정
		univCourseDiscussService.updateCourseDiscuss(discuss, attach);

		// [2]. 게시글 평가기준 등록
		List<UnivCoursePostEvaluateVO> coursePostEvaluateList = new ArrayList<UnivCoursePostEvaluateVO>();
		if (postEvaluate.getPostEvaluateSeqs() != null) {
			for (int index = 0; index < postEvaluate.getPostEvaluateSeqs().length; index++) {
				UIUnivCoursePostEvaluateVO o = new UIUnivCoursePostEvaluateVO();
				o.setPostEvaluateSeq(postEvaluate.getPostEvaluateSeqs()[index]);
				o.setCourseActiveSeq(postEvaluate.getCourseActiveSeq());
				o.setPostType(postEvaluate.getPostType());
				o.setFromCount(postEvaluate.getFromCounts()[index]);
				o.setToCount(postEvaluate.getToCounts()[index]);
				o.setScore(postEvaluate.getScores()[index]);
				o.setSortOrder(postEvaluate.getSortOrders()[index]);
				o.copyAudit(postEvaluate);
				coursePostEvaluateList.add(o);
			}
			coursePostEvaluateService.saveCoursePostEvaluate(coursePostEvaluateList);
		}

		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 토론 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param discuss
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/discuss/result/list.do")
	public ModelAndView listResult(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseDiscussVO discuss)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		discuss.copyShortcut();

		mav.addObject("discuss", discuss);
		mav.addObject("itemList", univCourseDiscussService.getListAllCourseDiscussByProf(discuss));
		mav.setViewName("/univ/courseDiscussResult/listDiscussResult");
		return mav;
	}

	/**
	 * 개설과목 토론결과 상세화면
	 * 
	 * @param req
	 * @param res
	 * @param discuss
	 * @param postEvaluate
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/discuss/result/detail.do")
	public ModelAndView detailResult(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseDiscussVO discuss,
			UIUnivCoursePostEvaluateVO postEvaluate) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));

		// 토론데이터 조회
		mav.addObject("detail", univCourseDiscussService.getDetailCourseDiscuss(discuss));

		// 평가기준데이터 조회
		postEvaluate.setReferenceSeq(discuss.getDiscussSeq());
		mav.addObject("listBoardPostEvaluate", coursePostEvaluateService.getList(postEvaluate));

		mav.setViewName("/univ/courseDiscussResult/detailDiscussResult");

		return mav;
	}

	/**
	 * 개설과목 토론결과 토론자목록
	 * 
	 * @param req
	 * @param res
	 * @param discuss
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/discuss/result/apply/list/iframe.do")
	public ModelAndView listApplyResult(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussVO discuss,
			UIUnivCourseDiscussApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 토론데이터 조회
		mav.addObject("paginate", univCourseDiscussService.getListCourseDiscussByApply(condition));

		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseDiscussResult/apply/listDiscussApply");

		return mav;
	}

	@RequestMapping ("/univ/course/discuss/result/apply/list/takescore/update.do")
	public ModelAndView updatelistTakeScore(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussVO discuss) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, discuss);

		List<UnivCourseDiscussVO> discussApplyList = new ArrayList<UnivCourseDiscussVO>();

		for (String index : discuss.getCheckkeys()) {
			UnivCourseDiscussVO o = new UnivCourseDiscussVO();
			o.setCourseActiveSeq(discuss.getCourseActiveSeq());
			o.setActiveElementSeq(discuss.getActiveElementSeq());
			o.setDiscussSeq(discuss.getDiscussSeq());
			o.setCourseApplySeq(discuss.getCourseApplySeqs()[Integer.parseInt(index)]);
			o.setMemberSeq(discuss.getMemberSeqs()[Integer.parseInt(index)]);
			o.setStartDtime(discuss.getStartDtimes()[Integer.parseInt(index)]);
			o.setEndDtime(discuss.getEndDtimes()[Integer.parseInt(index)]);
			o.copyAudit(discuss);
			discussApplyList.add(o);
		}

		if (discussApplyList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univCourseDiscussService.updatelistCourseDiscussTakeScore(discussApplyList));
		}

		mav.setViewName("/common/save");

		return mav;
	}
}
