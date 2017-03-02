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
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.service.UIUnivCourseTeamProjectBbsService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectBbsVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTeamVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveBbsCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseTeamProjectBbsCondition;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseTeamProjectBbsController.java
 * @Title : 팀프로젝트 게시판
 * @date : 2014. 3. 11.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseTeamProjectBbsController extends BaseController {

	@Resource (name = "UIUnivCourseTeamProjectBbsService")
	private UIUnivCourseTeamProjectBbsService bbsService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	@Resource (name = "UnivCourseTeamProjectTeamService")
	private UnivCourseTeamProjectTeamService univCourseTeamProjectTeamService;

	private final String BOARD_REFERENCE_TYPE = "teamproject";

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
	 * 강의실의 팀 프로젝트 상세
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/bbs/teamproject/list.do")
	public ModelAndView listTeamProjectBbs(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectVO teamProject,
			UIUnivCourseTeamProjectTeamVO projectTeam, UIUnivCourseTeamProjectBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		projectTeam.copyShortcut();

		// 팀프로젝트 상세 정보
		mav.addObject("detail", univCourseTeamProjectTeamService.getDetailCourseTeamProjectTeamByUser(projectTeam));

		UIBoardRS detailBoard = getDetailBoard(projectTeam.getCourseActiveSeq());
		if (detailBoard != null) {
			Long boardSeq = detailBoard.getBoard().getBoardSeq();

			condition.setSrchBoardSeq(boardSeq);
			condition.setSrchCourseActiveSeq(projectTeam.getCourseActiveSeq());
			condition.setSrchCourseTeamProjectseq(projectTeam.getCourseTeamProjectSeq());
			condition.setSrchCourseTeamSeq(projectTeam.getCourseTeamSeq());

			// 검색조건 값이 있으면 searchYn을 셋팅.
			if (StringUtil.isNotEmpty(condition.getSrchBbsTypeCd())) {
				condition.setSrchSearchYn("Y");
			}
			if (StringUtil.isNotEmpty(condition.getSrchWord())) {
				condition.setSrchSearchYn("Y");
			}
			if (!"Y".equals(condition.getSrchSearchYn())) {
				mav.addObject("alwaysTopList", bbsService.getListAlwaysTop(boardSeq));
				condition.setSrchAlwaysTopYn("N");
			}

			mav.addObject("paginate", bbsService.getList(condition));

			mav.addObject("condition", condition);
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("boardType", BOARD_REFERENCE_TYPE);
		}

		mav.setViewName("/univ/teamProjectResult/board/bbs/listBbs");
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
	@RequestMapping (value = { "/univ/bbs/teamproject/detail.do" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTeamVO projectTeam,
			UIUnivCourseTeamProjectBbsCondition condition, UIUnivCourseTeamProjectBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		projectTeam.copyShortcut();

		mav.addObject("detail", univCourseTeamProjectTeamService.getDetailCourseTeamProjectTeamByUser(projectTeam));

		bbs.copyShortcut();
		if (StringUtil.isNotEmpty(bbs.getCourseActiveSeq())) {
			UIBoardRS detailBoard = getDetailBoard(bbs.getCourseActiveSeq());

			if (detailBoard != null) {
				mav.addObject("detailBoard", detailBoard);
				mav.addObject("detailBbs", bbsService.getDetail(bbs));
				mav.addObject("condition", condition);
				mav.addObject("boardType", BOARD_REFERENCE_TYPE);
			}
		}
		mav.setViewName("/univ/teamProjectResult/board/bbs/detailBbs");
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
	@RequestMapping (value = { "/univ/bbs/teamproject/create.do" })
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseTeamProjectVO teamProject,
			UIUnivCourseTeamProjectTeamVO projectTeam, UIUnivCourseTeamProjectBbsVO bbs, UIUnivCourseActiveBbsCondition condition) throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		projectTeam.copyShortcut();
		bbs.copyShortcut();

		mav.addObject("detail", univCourseTeamProjectTeamService.getDetailCourseTeamProjectTeamByUser(projectTeam));
		mav.addObject("bbs", bbs);

		UIBoardRS detailBoard = getDetailBoard(bbs.getCourseActiveSeq());

		if (detailBoard != null) {
			if (StringUtil.isNotEmpty(bbs.getParentSeq())) {
				bbs.setBbsSeq(bbs.getParentSeq());
				mav.addObject("detailParentBbs", bbsService.getDetail(bbs));
			}
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("condition", condition);
			mav.addObject("boardType", BOARD_REFERENCE_TYPE);
		}
		mav.setViewName("/univ/teamProjectResult/board/bbs/createBbs");
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
	@RequestMapping (value = { "/univ/bbs/teamproject/edit.do" })
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTeamVO projectTeam, UIUnivCourseTeamProjectBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		projectTeam.copyShortcut();
		bbs.copyShortcut();
		mav.addObject("bbs", bbs);

		mav.addObject("detail", univCourseTeamProjectTeamService.getDetailCourseTeamProjectTeamByUser(projectTeam));

		if (StringUtil.isNotEmpty(bbs.getCourseActiveSeq())) {
			UIBoardRS detailBoard = getDetailBoard(bbs.getCourseActiveSeq());

			if (detailBoard != null) {
				mav.addObject("detailBoard", detailBoard);

				mav.addObject("detailBbs", bbsService.getDetail(bbs));
				mav.addObject("condition", condition);
				mav.addObject("boardType", BOARD_REFERENCE_TYPE);
			}
		}
		mav.setViewName("/univ/teamProjectResult/board/bbs/editBbs");
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
	@RequestMapping (value = { "/univ/bbs/teamproject/reply/list/ajax.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		bbs.copyShortcut();

		UIUnivCourseActiveBbsCondition condition = new UIUnivCourseActiveBbsCondition();
		emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchParentSeq(bbs.getBbsSeq());

		mav.addObject("detailBbs", bbsService.getDetail(bbs));

		mav.addObject("paginate", bbsService.getListReply(condition));
		mav.addObject("boardType", BOARD_REFERENCE_TYPE);

		mav.setViewName("/univ/teamProjectResult/board/bbs/listReplyBbsAjax");
		return mav;
	}

	/**
	 * 게시글 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseTeamProjectBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/bbs/teamproject/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);
		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=Y");

		bbs.copyShortcut();
		bbs.setPushMessageType(UIUnivCourseTeamProjectBbsService.COURSE_ACTIVE_TEAMPROJECT);
		bbs.setBoardTypeCd("BOARD_TYPE::TEAMPROJECT");

		bbsService.insertBbs(bbs, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시글 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseTeamProjectBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/bbs/teamproject/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);
		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=Y");

		bbs.copyShortcut();
		bbsService.updateBbs(bbs, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시글 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseTeamProjectBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/bbs/teamproject/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		bbs.copyShortcut();
		bbsService.deleteBbs(bbs);

		mav.setViewName("/common/save");
		return mav;
	}
}
