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

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.board.vo.BoardVO;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.board.vo.UIBoardVO;
import com._4csoft.aof.ui.board.vo.condition.UIBoardCondition;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBoardVO;
import com._4csoft.aof.univ.service.UnivCourseActiveService;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.board.web
 * @File : UIBoardController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseActiveBoardController extends BaseController {

	@Resource (name = "BoardService")
	private BoardService boardService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	private final String REFERENCE_TYPE_COURSE = "course";

	/**
	 * 게시판 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseActiveBoardVO
	 * @param UIBoardCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/board/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBoardVO board, UIBoardCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 년도학기 combo
		mav.addObject("yearTerms", courseActiveService.getListChargeOfYearTerm(ssMember.getMemberSeq(), board.getShortcutCategoryTypeCd()));

		if (StringUtil.isNotEmpty(board.getShortcutCourseActiveSeq())) {
			condition.setSrchReferenceSeq(board.getShortcutCourseActiveSeq());
			condition.setSrchReferenceType(REFERENCE_TYPE_COURSE);

			mav.addObject("paginate", boardService.getList(condition));
			mav.addObject("condition", condition);
		}
		mav.setViewName("/univ/courseBoard/listBoard");
		return mav;
	}

	/**
	 * 게시판 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param board
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/board/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBoardVO board) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		// 년도학기 combo
		mav.addObject("yearTerms", courseActiveService.getListChargeOfYearTerm(ssMember.getMemberSeq(), board.getShortcutCategoryTypeCd()));

		mav.setViewName("/univ/courseBoard/createBoard");
		return mav;
	}

	/**
	 * 게시판 설정 수정화면
	 * 
	 * @param req
	 * @param res
	 * @param board
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/board/edit/popup.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBoardVO board) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detailBoard", boardService.getDetail(board));

		mav.setViewName("/univ/courseBoard/editBoardPopup");
		return mav;
	}

	/**
	 * 게시판 설정 등록
	 * 
	 * @param req
	 * @param res
	 * @param board
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/board/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBoardVO board) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, board);

		boardService.insertBoard(board);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시판 설정 수정
	 * 
	 * @param req
	 * @param res
	 * @param board
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/board/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBoardVO board) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, board);

		boardService.updateBoard(board);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시판 멀티 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/board/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBoardVO board) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, board);

		List<BoardVO> voList = new ArrayList<BoardVO>();
		if (board.getBoardSeqList() != null) {
			for (int i = 0; i < board.getBoardSeqList().size(); i++) {
				UIBoardVO o = new UIBoardVO();
				o.setBoardSeq(board.getBoardSeqList().get(i));
				o.setUseYn(board.getUseYnList().get(i));
				o.setSecretYn(board.getSecretYnList().get(i));
				o.setEditorYn(board.getEditorYnList().get(i));
				o.setCommentYn(board.getCommentYnList().get(i));
				o.setReplyTypeCd(board.getReplyTypeCdList().get(i));
				o.setAttachCount(board.getAttachCountList().get(i));
				o.setAttachSize(board.getAttachSizeList().get(i));
				o.copyAudit(board);

				voList.add(o);
			}
		}

		if (voList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", boardService.updatelistBoard(voList));
		}
		mav.setViewName("/common/save");
		return mav;
	}

}
