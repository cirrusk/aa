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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.board.vo.BoardVO;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBbsVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveBbsCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseBbsResultCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveBbsService;
import com._4csoft.aof.univ.service.UnivCourseBbsResultService;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseBbsResultController.java
 * @Title : 참여 결과 컨트롤러
 * @date : 2014. 03. 17.
 * @author : 류정희
 * @descrption : 참여 결과 컨트롤러
 */
@Controller
public class UIUnivCourseBbsResultController extends BaseController {

	@Resource (name = "BoardService")
	private BoardService boardService;

	@Resource (name = "UnivCourseActiveBbsService")
	private UnivCourseActiveBbsService bbsService;

	@Resource (name = "UnivCourseBbsResultService")
	private UnivCourseBbsResultService bbsResultService;

	/**
	 * 참여 결과 참여자 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/bbs/result/member/list.do")
	public ModelAndView listMember(HttpServletRequest req, HttpServletResponse res, UIUnivCourseBbsResultCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchCourseActiveSeq(Long.parseLong(req.getParameter("shortcutCourseActiveSeq")));

		mav.addObject("boardList", boardService.getListByReference("course", Long.parseLong(req.getParameter("shortcutCourseActiveSeq"))));
		mav.addObject("paginate", bbsResultService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseBbsResult/listCourseBbsResultMember");

		return mav;
	}

	/**
	 * 참여 결과 게시판 목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/bbs/result/{boardType}/list.do")
	public ModelAndView listBbs(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType,
			UIUnivCourseBbsResultCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		String shortcutCourseActiveSeq = req.getParameter("shortcutCourseActiveSeq");

		if (StringUtil.isNotEmpty(shortcutCourseActiveSeq)) {

			condition.setSrchBoardTypeCd("BOARD_TYPE::" + boardType.toUpperCase());
			condition.setSrchCourseActiveSeq(Long.parseLong(shortcutCourseActiveSeq));

			// 검색조건 값이 있으면 searchYn을 셋팅.
			if (StringUtil.isNotEmpty(condition.getSrchBbsTypeCd())) {
				condition.setSrchSearchYn("Y");
			}
			if (StringUtil.isNotEmpty(condition.getSrchWord())) {
				condition.setSrchSearchYn("Y");
			}
			if (!"Y".equals(condition.getSrchSearchYn())) {
				mav.addObject("alwaysTopList", bbsService.getListCourseAlwaysTop(condition));
				condition.setSrchAlwaysTopYn("N");
			}

			mav.addObject("paginate", bbsService.getList(condition));
		}

		mav.addObject("boardList", boardService.getListByReference("course", Long.parseLong(req.getParameter("shortcutCourseActiveSeq"))));
		mav.addObject("boardType", boardType);
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseBbsResult/listCourseBbsResult");
		return mav;
	}

	/**
	 * 게시글 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param boardType
	 * @param bbs
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/bbs/result/{boardType}/detail.do")
	public ModelAndView detailBbs(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req);

		String shortcutCourseActiveSeq = req.getParameter("shortcutCourseActiveSeq");

		if (StringUtil.isNotEmpty(shortcutCourseActiveSeq)) {
			bbs.setCourseActiveSeq(Long.parseLong(shortcutCourseActiveSeq));
			bbs.setBoardTypeCd("BOARD_TYPE::" + boardType.toUpperCase());

			BoardVO vo = new BoardVO();
			vo.setBoardSeq(condition.getSrchBoardSeq());
			UIBoardRS detailBoard = (UIBoardRS)boardService.getDetail(vo);

			if (detailBoard != null) {
				mav.addObject("detailBoard", detailBoard);
				mav.addObject("detailBbs", bbsService.getDetail(bbs));
				mav.addObject("condition", condition);
				mav.addObject("boardType", boardType);
			}
		}

		mav.addObject("boardList", boardService.getListByReference("course", Long.parseLong(req.getParameter("shortcutCourseActiveSeq"))));
		mav.setViewName("/univ/courseBbsResult/detailCourseBbsResult");

		return mav;
	}

}
