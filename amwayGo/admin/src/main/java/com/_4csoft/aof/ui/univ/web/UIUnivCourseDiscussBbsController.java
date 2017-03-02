/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.UnivBaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussBbsVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveBbsCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseDiscussBbsCondition;
import com._4csoft.aof.univ.service.UnivCourseDiscussBbsService;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivDiscussBbsController.java
 * @Title : 토론 게시판
 * @date : 2014. 3. 20.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseDiscussBbsController extends UnivBaseController {

	@Resource (name = "UnivCourseDiscussBbsService")
	private UnivCourseDiscussBbsService bbsService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	private final String BOARD_REFERENCE_TYPE = "discuss";

	/**
	 * 게시판 상세정보
	 * 
	 * @param referenceSeq
	 * @param boardType
	 * @return UIBoardRS
	 * @throws Exception
	 */
	public UIBoardRS getDetailBoard(Long referenceSeq) throws Exception {

		return (UIBoardRS)boardService.getDetailByReference(BOARD_REFERENCE_TYPE, referenceSeq,
				"BOARD_TYPE::" + BOARD_REFERENCE_TYPE.toUpperCase(Locale.getDefault()));
	}

	/**
	 * 토론 게시판 리스트
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param courseApply
	 * @param discussBbs
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/discuss/result/bbs/list/iframe.do")
	public ModelAndView listDiscussBbs(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseDiscussBbsVO bbs, UIUnivCourseDiscussBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("courseApply", courseApply);

		UIBoardRS detailBoard = getDetailBoard(courseActive.getCourseActiveSeq());
		if (detailBoard != null) {
			Long boardSeq = detailBoard.getBoard().getBoardSeq();

			condition.setSrchBoardSeq(boardSeq);

			mav.addObject("paginate", bbsService.getList(condition));

			mav.addObject("condition", condition);
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("boardType", BOARD_REFERENCE_TYPE);
		}

		mav.setViewName("/univ/courseDiscussResult/board/bbs/listDiscussBbs");
		return mav;
	}

	/**
	 * 토론 답변글 목록
	 * 
	 * @param req
	 * @param res
	 * @param boardType
	 * @param bbs
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/discuss/result/reply/list/ajax.do")
	public ModelAndView listDiscussBbsReply(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivCourseActiveBbsCondition condition = new UIUnivCourseActiveBbsCondition();

		emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchParentSeq(bbs.getBbsSeq());

		mav.addObject("detailBbs", bbsService.getDetail(bbs));

		mav.addObject("paginate", bbsService.getListReply(condition));
		mav.addObject("boardType", BOARD_REFERENCE_TYPE);

		mav.setViewName("/univ/courseDiscussResult/board/bbs/listReplyDiscussBbsAjax");
		return mav;
	}

	/**
	 * 토론 게시글 상세
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param courseApply
	 * @param condition
	 * @param bbs
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/discuss/result/bbs/detail/iframe.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseDiscussBbsCondition condition, UIUnivCourseDiscussBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("courseApply", courseApply);

		if (StringUtil.isNotEmpty(bbs.getCourseActiveSeq())) {
			UIBoardRS detailBoard = getDetailBoard(bbs.getCourseActiveSeq());

			if (detailBoard != null) {
				mav.addObject("detailBoard", detailBoard);
				mav.addObject("detailBbs", bbsService.getDetail(bbs));
				mav.addObject("condition", condition);
				mav.addObject("boardType", BOARD_REFERENCE_TYPE);
				// 조회수 증가
//				bbsService.updateBbsViewCount(bbs);
			}
		}
		mav.setViewName("/univ/courseDiscussResult/board/bbs/detailDiscussBbs");
		return mav;
	}

	/**
	 * 토론 게시글 수정
	 * 
	 * @param req
	 * @param res
	 * @param bbs
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/discuss/bbs/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);
		setCourseActive(req, bbs);

		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=Y");
		bbsService.updateBbs(bbs, attach);

		mav.setViewName("/common/save");
		return mav;
	}

}
