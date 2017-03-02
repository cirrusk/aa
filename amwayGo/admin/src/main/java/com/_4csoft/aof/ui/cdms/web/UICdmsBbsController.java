/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.cdms.service.CdmsBbsService;
import com._4csoft.aof.cdms.vo.CdmsBbsVO;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.cdms.vo.UICdmsBbsVO;
import com._4csoft.aof.ui.cdms.vo.condition.UICdmsBbsCondition;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.cdms.web
 * @File : UICdmsBbsController.java
 * @Title : CDMS 개발게시판
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICdmsBbsController extends BaseController {

	@Resource (name = "CdmsBbsService")
	private CdmsBbsService bbsService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	/**
	 * 게시판 상세정보
	 * 
	 * @param referenceSeq
	 * @param boardType
	 * @return UIBoardRS
	 * @throws Exception
	 */
	public UIBoardRS getDetailBoard(String boardType) throws Exception {

		return (UIBoardRS)boardService.getDetailByReference("cdms", -1L, "BOARD_TYPE::" + boardType.toUpperCase());
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
	@RequestMapping (value = { "/cdms/bbs/{boardType}/list.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UICdmsBbsVO bbs,
			UICdmsBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "/cdms/bbs/listBbs";

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
			if ("notice".equals(boardType)) {
				if ("Y".equals(condition.getSrchSearchYn()) == false) {
					mav.addObject("alwaysTopList", bbsService.getListAlwaysTop(boardSeq));
					condition.setSrchAlwaysTopYn("N");
				}
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
	@RequestMapping (value = { "/cdms/bbs/{boardType}/detail.do" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UICdmsBbsVO bbs,
			UICdmsBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "/cdms/bbs/detailBbs";

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
	@RequestMapping (value = { "/cdms/bbs/{boardType}/create.do" })
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UICdmsBbsVO bbs,
			UICdmsBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "/cdms/bbs/createBbs";

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
	@RequestMapping (value = { "/cdms/bbs/{boardType}/edit.do" })
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UICdmsBbsVO bbs,
			UICdmsBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "/cdms/bbs/editBbs";

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
	@RequestMapping (value = { "/cdms/bbs/{boardType}/reply/list/ajax.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UICdmsBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "/cdms/bbs/listReplyBbsAjax";

		requiredSession(req);

		UICdmsBbsCondition condition = new UICdmsBbsCondition();

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
	 * @param UICdmsBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/bbs/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UICdmsBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N");
		bbsService.insertBbs(bbs, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시글 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/bbs/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UICdmsBbsVO bbs, UIAttachVO attach) throws Exception {
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
	 * @param UICdmsBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/bbs/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UICdmsBbsVO bbs) throws Exception {
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
	 * @param UICdmsBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/bbs/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UICdmsBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		List<CdmsBbsVO> voList = new ArrayList<CdmsBbsVO>();
		for (String index : bbs.getCheckkeys()) {
			UICdmsBbsVO o = new UICdmsBbsVO();
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
