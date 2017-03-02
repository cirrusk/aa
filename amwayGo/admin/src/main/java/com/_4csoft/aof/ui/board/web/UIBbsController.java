/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BbsService;
import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.board.vo.BbsVO;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.board.vo.UIBbsVO;
import com._4csoft.aof.ui.board.vo.condition.UIBbsCondition;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.board.web
 * @File : UIBbsController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIBbsController extends BaseController {

	@Resource (name = "BbsService")
	private BbsService bbsService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	/**
	 * 게시판 상세정보
	 * 
	 * @param boardType
	 * @return UIBoardRS
	 * @throws Exception
	 */
	public UIBoardRS getDetailBoard(String boardType) throws Exception {

		return (UIBoardRS)boardService.getDetailByReference("system", -1L, "BOARD_TYPE::" + boardType.toUpperCase());
	}

	/**
	 * 게시글 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param boardType
	 * @param bbs
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/system/bbs/{boardType}/list.do", "/mypage/system/bbs/{boardType}/list.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIBbsVO bbs,
			UIBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "";
		if (req.getServletPath().startsWith("/mypage/")) {
			viewName = "/board/bbs/mypage/listBbs";
		} else {
			viewName = "/board/bbs/listBbs";
		}

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIBoardRS detailBoard = getDetailBoard(boardType);

		if (detailBoard != null) {
			Long boardSeq = detailBoard.getBoard().getBoardSeq();

			condition.setSrchBoardSeq(boardSeq);

			// 검색조건 값이 있으면 searchYn을 셋팅.
			if (StringUtil.isNotEmpty(condition.getSrchBbsTypeCd())) {
				condition.setSrchSearchYn("Y");
			}
			if (StringUtil.isNotEmpty(condition.getSrchWord())) {
				condition.setSrchSearchYn("Y");
			}
			if ("Y".equals(condition.getSrchSearchYn()) == false) {
				mav.addObject("alwaysTopList", bbsService.getListAlwaysTop(boardSeq));
				condition.setSrchAlwaysTopYn("N");
			}
			if (req.getServletPath().startsWith("/mypage/") && "staff".equals(boardType)) { // 교직원게시판일 경우 대상자가 현재 롤그룹과 일치하는 것만 검색한다.
				condition.setSrchTargetRolegroup("BBS_TARGET_ROLEGROUP::" + SessionUtil.getMember(req).getCurrentRoleCfString());
				// 교직원 게시판의 경우 자신이 작성한 글이 보여야 하므로 조건 추가
				condition.setSrchStaffYn("Y");
				condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
			}
			mav.addObject("paginate", bbsService.getList(condition));

			mav.addObject("condition", condition);
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("boardType", boardType);
		}
		mav.setViewName(viewName);
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
	@RequestMapping (value = { "/system/bbs/{boardType}/detail.do", "/mypage/system/bbs/{boardType}/detail.do" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIBbsVO bbs,
			UIBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "";
		if (req.getServletPath().startsWith("/mypage/")) {
			viewName = "/board/bbs/mypage/detailBbs";
		} else {
			viewName = "/board/bbs/detailBbs";
		}

		requiredSession(req);

		UIBoardRS detailBoard = getDetailBoard(boardType);

		if (detailBoard != null) {
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("detailBbs", bbsService.getDetail(bbs));
			mav.addObject("condition", condition);
			mav.addObject("boardType", boardType);

/*			if (req.getServletPath().startsWith("/mypage/") && "staff".equals(boardType)) { // 마이페이지의 교직원게시판일 경우 조회수 증가
				bbsService.updateBbsViewCount(bbs);
			}*/
		}
		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 게시글 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param boardType
	 * @param bbs
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/system/bbs/{boardType}/create.do", "/mypage/system/bbs/{boardType}/create.do" })
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIBbsVO bbs,
			UIBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "";
		if (req.getServletPath().startsWith("/mypage/")) {
			viewName = "/board/bbs/mypage/createBbs";
		} else {
			viewName = "/board/bbs/createBbs";
		}

		requiredSession(req);

		UIBoardRS detailBoard = getDetailBoard(boardType);

		if (detailBoard != null) {
			if (StringUtil.isNotEmpty(bbs.getParentSeq())) {
				bbs.setBbsSeq(bbs.getParentSeq());
				mav.addObject("detailParentBbs", bbsService.getDetail(bbs));
			}
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("condition", condition);
			mav.addObject("boardType", boardType);
		}
		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 게시글 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param boardType
	 * @param bbs
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/system/bbs/{boardType}/edit.do", "/mypage/system/bbs/{boardType}/edit.do" })
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIBbsVO bbs,
			UIBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "";
		if (req.getServletPath().startsWith("/mypage/")) {
			viewName = "/board/bbs/mypage/editBbs";
		} else {
			viewName = "/board/bbs/editBbs";
		}

		requiredSession(req);

		UIBoardRS detailBoard = getDetailBoard(boardType);

		if (detailBoard != null) {
			mav.addObject("detailBoard", detailBoard);

			mav.addObject("detailBbs", bbsService.getDetail(bbs));
			mav.addObject("condition", condition);
			mav.addObject("boardType", boardType);
		}
		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 답변글 목록
	 * 
	 * @param req
	 * @param res
	 * @param boardType
	 * @param bbs
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/system/bbs/{boardType}/reply/list/ajax.do", "/mypage/system/bbs/{boardType}/reply/list/ajax.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "";
		if (req.getServletPath().startsWith("/mypage/")) {
			viewName = "/board/bbs/mypage/listReplyBbsAjax";
		} else {
			viewName = "/board/bbs/listReplyBbsAjax";
		}

		requiredSession(req);

		UIBbsCondition condition = new UIBbsCondition();

		emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchParentSeq(bbs.getBbsSeq());

		mav.addObject("detailBbs", bbsService.getDetail(bbs));

		mav.addObject("paginate", bbsService.getListReply(condition));
		mav.addObject("boardType", boardType);

		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 게시글 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/system/bbs/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		String boardType = "BOARD_TYPE::" + req.getParameter("boardType").toUpperCase();
		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "alarmUseYn=N");

		// 답변글일경우
		if (bbs.getParentSeq() > 0 && bbs.getGroupLevel() == 2l) {
			// QNA 답변타입일 경우
			if ("BOARD_TYPE::QNA".equals(boardType)) {
				bbs.setTemplateTypeCd("MESSAGE_TEMPLATE_TYPE::QNA");
				bbs.setAlarmUseYn("Y");
				bbs.setSendScheduleCd("MESSAGE_SCHEDULE_TYPE::001");
			}
		}

		bbsService.insertBbs(bbs, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시글 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/system/bbs/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N");
		bbsService.updateBbs(bbs, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시글 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/system/bbs/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		bbsService.deleteBbs(bbs);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시글 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/system/bbs/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		List<BbsVO> voList = new ArrayList<BbsVO>();
		for (String index : bbs.getCheckkeys()) {
			UIBbsVO o = new UIBbsVO();
			o.setBoardSeq(bbs.getBoardSeqs()[Integer.parseInt(index)]);
			o.setBbsSeq(bbs.getBbsSeqs()[Integer.parseInt(index)]);
			o.copyAudit(bbs);
			voList.add(o);
		}

		if (voList.size() > 0) {
			mav.addObject("result", bbsService.deletelistBbs(voList));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

}
