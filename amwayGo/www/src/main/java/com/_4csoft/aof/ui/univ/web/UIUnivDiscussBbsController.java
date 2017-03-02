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

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.UnivBaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussBbsVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveBbsCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseDiscussBbsCondition;
import com._4csoft.aof.univ.service.UnivCourseDiscussBbsService;
import com._4csoft.aof.univ.service.UnivCourseDiscussService;

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
public class UIUnivDiscussBbsController extends UnivBaseController {

	@Resource (name = "UnivCourseDiscussBbsService")
	private UnivCourseDiscussBbsService bbsService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	@Resource (name = "UnivCourseDiscussService")
	private UnivCourseDiscussService univCourseDiscussService;

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

		return (UIBoardRS)boardService.getDetailByReference(BOARD_REFERENCE_TYPE, referenceSeq, "BOARD_TYPE::" + BOARD_REFERENCE_TYPE.toUpperCase());
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
	@RequestMapping ("/usr/classroom/bbs/discuss/list/iframe.do")
	public ModelAndView listDiscussBbs(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseDiscussBbsVO bbs, UIUnivCourseDiscussVO discuss, UIUnivCourseDiscussBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);
		setCourseActive(req, courseActive, discuss, bbs);

		discuss.setCourseActiveSeq(courseActive.getCourseActiveSeq());
		mav.addObject("detail", univCourseDiscussService.getDetailCourseDiscussByUser(discuss));
		mav.addObject("courseApply", courseApply);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("courseApply", courseApply);

		UIBoardRS detailBoard = getDetailBoard(courseActive.getCourseActiveSeq());
		if (detailBoard != null) {
			Long boardSeq = detailBoard.getBoard().getBoardSeq();

			condition.setSrchBoardSeq(boardSeq);

			mav.addObject("paginate", bbsService.getList(condition));
			mav.addObject("detailBoard", detailBoard);
		}
		mav.addObject("condition", condition);
		mav.addObject("boardType", BOARD_REFERENCE_TYPE);

		mav.setViewName("/univ/classroom/discuss/board/bbs/listDiscussBbs");
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
	@RequestMapping ("/usr/classroom/bbs/discuss/reply/list/ajax.do")
	public ModelAndView listDiscussBbsReply(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivCourseActiveBbsCondition condition = new UIUnivCourseActiveBbsCondition();

		emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchParentSeq(bbs.getBbsSeq());

		mav.addObject("detailBbs", bbsService.getDetail(bbs));

		mav.addObject("paginate", bbsService.getListReply(condition));
		mav.addObject("boardType", BOARD_REFERENCE_TYPE);

		mav.setViewName("/univ/classroom/discuss/board/bbs/listReplyDiscussBbsAjax");
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
	@RequestMapping ("/usr/classroom/bbs/discuss/detail/iframe.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseDiscussBbsCondition condition, UIUnivCourseDiscussVO discuss, UIUnivCourseDiscussBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		setCourseActive(req, courseActive, discuss, bbs);

		discuss.setCourseActiveSeq(courseActive.getCourseActiveSeq());
		mav.addObject("detail", univCourseDiscussService.getDetailCourseDiscussByUser(discuss));

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("courseApply", courseApply);

		if (StringUtil.isNotEmpty(bbs.getCourseActiveSeq())) {
			UIBoardRS detailBoard = getDetailBoard(bbs.getCourseActiveSeq());

			if (detailBoard != null) {
				mav.addObject("detailBoard", detailBoard);
				mav.addObject("detailBbs", bbsService.getDetail(bbs));
				// 조회수 증가
				bbsService.updateBbsViewCount(bbs);
			}

			mav.addObject("condition", condition);
			mav.addObject("boardType", BOARD_REFERENCE_TYPE);
		}
		mav.setViewName("/univ/classroom/discuss/board/bbs/detailDiscussBbs");
		return mav;
	}

	/**
	 * 토론 게시판 등록 화면
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
	@RequestMapping ("/usr/classroom/bbs/discuss/create/iframe.do")
	public ModelAndView createDiscussBbs(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseDiscussBbsVO bbs, UIUnivCourseDiscussVO discuss, UIUnivCourseDiscussBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req);
		setCourseActive(req, courseActive, discuss, bbs);

		discuss.setCourseActiveSeq(courseActive.getCourseActiveSeq());
		mav.addObject("detail", univCourseDiscussService.getDetailCourseDiscussByUser(discuss));

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("courseApply", courseApply);
		mav.addObject("bbs", bbs);

		UIBoardRS detailBoard = getDetailBoard(bbs.getCourseActiveSeq());

		if (detailBoard != null) {
			if (StringUtil.isNotEmpty(bbs.getParentSeq())) {
				bbs.setBbsSeq(bbs.getParentSeq());
				mav.addObject("detailParentBbs", bbsService.getDetail(bbs));
			}
			mav.addObject("detailBoard", detailBoard);
		}
		mav.addObject("condition", condition);
		mav.addObject("boardType", BOARD_REFERENCE_TYPE);
		mav.setViewName("/univ/classroom/discuss/board/bbs/createDiscussBbs");
		return mav;
	}

	@RequestMapping ("/usr/classroom/bbs/discuss/edit/iframe.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply,
			UIUnivCourseDiscussBbsVO bbs, UIUnivCourseDiscussVO discuss, UIUnivCourseDiscussBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		setCourseActive(req, courseActive, discuss, bbs);

		discuss.setCourseActiveSeq(courseActive.getCourseActiveSeq());
		mav.addObject("detail", univCourseDiscussService.getDetailCourseDiscussByUser(discuss));

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("bbs", bbs);
		mav.addObject("courseApply", courseApply);

		if (StringUtil.isNotEmpty(bbs.getCourseActiveSeq())) {
			UIBoardRS detailBoard = getDetailBoard(bbs.getCourseActiveSeq());

			if (detailBoard != null) {
				mav.addObject("detailBoard", detailBoard);
				mav.addObject("detailBbs", bbsService.getDetail(bbs));
			}

			mav.addObject("condition", condition);
			mav.addObject("boardType", BOARD_REFERENCE_TYPE);
		}
		mav.setViewName("/univ/classroom/discuss/board/bbs/editDiscussBbs");
		return mav;
	}

	/**
	 * 토론 게시글 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param bbs
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/bbs/discuss/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);
		setCourseActive(req, bbs);

		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=Y");
		bbs.setMemberSeq(bbs.getRegMemberSeq());
		bbsService.insertBbs(bbs, attach);

		mav.setViewName("/common/save");
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
	@RequestMapping ("/usr/classroom/bbs/discuss/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);
		setCourseActive(req, bbs);

		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=Y");
		bbsService.updateBbs(bbs, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 토론 게시글 삭제
	 * 
	 * @param req
	 * @param res
	 * @param bbs
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/bbs/discuss/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseDiscussBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);
		setCourseActive(req, bbs);

		bbsService.deleteBbs(bbs);

		mav.setViewName("/common/save");
		return mav;
	}

}
