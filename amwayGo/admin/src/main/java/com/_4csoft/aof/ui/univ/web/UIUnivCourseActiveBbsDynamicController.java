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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.board.vo.UIBoardVO;
import com._4csoft.aof.ui.board.vo.condition.UIBoardCondition;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBbsVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveBbsCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveBbsService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.vo.UnivCourseActiveBbsVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveBbsController.java
 * @Title : 개설과목 게시글
 * @date : 2014. 2. 26.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseActiveBbsDynamicController extends BaseController {

	@Resource (name = "UnivCourseActiveBbsService")
	private UnivCourseActiveBbsService bbsService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	private final String BOARD_REFERENCE_TYPE = "course";

	/**
	 * 게시판 상세정보
	 * 
	 * @param referenceSeq
	 * @param boardType
	 * @return UIBoardRS
	 * @throws Exception
	 */
	public UIBoardRS getDetailBoard(Long boardSeq) throws Exception {
		UIBoardVO vo = new UIBoardVO();
		vo.setBoardSeq(boardSeq);
		return (UIBoardRS)boardService.getDetail(vo);
	}

	/**
	 * 개설과목 생성게시판 메인
	 * 
	 * @param req
	 * @param res
	 * @param bbs
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/bbs/dynamic/main.do")
	public ModelAndView main(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		// 년도학기 combo
		mav.addObject("yearTerms", courseActiveService.getListChargeOfYearTerm(ssMember.getMemberSeq(), bbs.getShortcutCategoryTypeCd()));

		if (StringUtil.isNotEmpty(bbs.getShortcutCourseActiveSeq())) {
			UIBoardCondition condition = new UIBoardCondition();
			condition.setCurrentPage(0);
			condition.setSrchReferenceType(BOARD_REFERENCE_TYPE);
			condition.setSrchBoardTypeCd("BOARD_TYPE::DYNAMIC");
			condition.setSrchUseYn("Y");
			condition.setSrchReferenceSeq(bbs.getShortcutCourseActiveSeq());

			mav.addObject("paginateBoard", boardService.getList(condition));
		}
		mav.setViewName("/univ/courseBbsDynamic/mainBbsDynamic");
		return mav;
	}

	/**
	 * 개설과목 생성게시판 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param boardSeq
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/bbs/dynamic/{boardSeq}/list/iframe.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardSeq") Long boardSeq, UIUnivCourseActiveBbsCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIBoardRS detailBoard = getDetailBoard(boardSeq);

		if (detailBoard != null) {
			condition.setSrchBoardSeq(boardSeq);
			condition.setSrchBoardTypeCd("BOARD_TYPE::DYNAMIC");

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

			mav.addObject("condition", condition);
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("boardType", "dynamic");
			mav.addObject("boardSeq", boardSeq);
		}
		mav.setViewName("/univ/courseBbsDynamic/listBbsDynamicIframe");
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
	@RequestMapping ("/univ/course/bbs/dynamic/{boardSeq}/detail/iframe.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardSeq") Long boardSeq, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req);

		UIBoardRS detailBoard = getDetailBoard(boardSeq);
		if (detailBoard != null) {
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("detailBbs", bbsService.getDetail(bbs));
			mav.addObject("condition", condition);
			mav.addObject("boardType", "dynamic");
			mav.addObject("boardSeq", boardSeq);
		}
		mav.setViewName("/univ/courseBbsDynamic/detailBbsDynamicIframe");
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
	@RequestMapping ("/univ/course/bbs/dynamic/{boardSeq}/create/iframe.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardSeq") Long boardSeq, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIBoardRS detailBoard = getDetailBoard(boardSeq);
		if (detailBoard != null) {
			if (StringUtil.isNotEmpty(bbs.getParentSeq())) {
				bbs.setBbsSeq(bbs.getParentSeq());
				mav.addObject("detailParentBbs", bbsService.getDetail(bbs));
			}
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("condition", condition);
			mav.addObject("boardType", "dynamic");
			mav.addObject("boardSeq", boardSeq);
		}
		mav.setViewName("/univ/courseBbsDynamic/createBbsDynamicIframe");
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
	@RequestMapping ("/univ/course/bbs/dynamic/{boardSeq}/edit/iframe.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardSeq") Long boardSeq, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIBoardRS detailBoard = getDetailBoard(boardSeq);

		if (detailBoard != null) {
			mav.addObject("detailBoard", detailBoard);

			mav.addObject("detailBbs", bbsService.getDetail(bbs));
			mav.addObject("condition", condition);
			mav.addObject("boardType", "dynamic");
			mav.addObject("boardSeq", boardSeq);
		}
		mav.setViewName("/univ/courseBbsDynamic/editBbsDynamicIframe");
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
	@RequestMapping ("/univ/course/bbs/dynamic/{boardSeq}/reply/list/ajax.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardSeq") Long boardSeq, UIUnivCourseActiveBbsVO bbs)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivCourseActiveBbsCondition condition = new UIUnivCourseActiveBbsCondition();

		emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchParentSeq(bbs.getBbsSeq());

		mav.addObject("detailBbs", bbsService.getDetail(bbs));

		mav.addObject("paginate", bbsService.getListReply(condition));
		mav.addObject("boardType", "dynamic");
		mav.addObject("boardSeq", boardSeq);

		mav.setViewName("/univ/courseBbsDynamic/listReplyBbsDynamicAjax");
		return mav;
	}

	/**
	 * 게시글 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseActiveBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/bbs/dynamic/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=Y", "multiRegYn=N", "boardTypeCd=BOARD_TYPE::DYNAMIC", "popupYn=N", "alarmUseYn=N");
		bbsService.insertBbs(bbs, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시글 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseActiveBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/bbs/dynamic/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=Y");
		bbsService.updateBbs(bbs, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시글 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseActiveBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/bbs/dynamic/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs) throws Exception {
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
	 * @param UIUnivCourseActiveBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/bbs/dynamic/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		List<UnivCourseActiveBbsVO> voList = new ArrayList<UnivCourseActiveBbsVO>();
		for (String index : bbs.getCheckkeys()) {
			UIUnivCourseActiveBbsVO o = new UIUnivCourseActiveBbsVO();
			o.setBbsSeq(bbs.getBbsSeqs()[Integer.parseInt(index)]);
			o.copyAudit(bbs);
			voList.add(o);
		}

		if (voList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", bbsService.deletelistBbs(voList));
		}
		mav.setViewName("/common/save");
		return mav;
	}
}
