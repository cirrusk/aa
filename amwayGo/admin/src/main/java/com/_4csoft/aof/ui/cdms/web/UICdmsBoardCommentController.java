/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.CommentService;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.board.vo.UICommentAgreeVO;
import com._4csoft.aof.ui.board.vo.UICommentVO;
import com._4csoft.aof.ui.board.vo.condition.UICommentCondition;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.cdms.web
 * @File : UICdmsBoardCommentController.java
 * @Title : CDMS 게시판 댓글
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICdmsBoardCommentController extends BaseController {

	@Resource (name = "CommentService")
	private CommentService commentService;

	/**
	 * 댓글 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICommentCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/board/comment/list/ajax.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UICommentCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=10", "orderby=0");

		mav.addObject("paginate", commentService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/cdms/board/comment/listCommentAjax");
		return mav;
	}

	/**
	 * 댓글 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICommentVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/board/comment/edit/popup.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UICommentVO comment) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", commentService.getDetail(comment));

		mav.setViewName("/cdms/board/comment/editCommentPopup");
		return mav;
	}

	/**
	 * 댓글 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICommentVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/board/comment/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UICommentVO comment) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, comment);

		if (StringUtil.isEmpty(comment.getSecretYn())) {
			comment.setSecretYn("N");
		}
		commentService.insertComment(comment);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 댓글 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICommentVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/board/comment/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UICommentVO comment) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, comment);

		if (StringUtil.isEmpty(comment.getSecretYn())) {
			comment.setSecretYn("N");
		}
		commentService.updateComment(comment);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 댓글 찬성수 증가 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICommentAgreeVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/board/comment/agree/update.do")
	public ModelAndView updateAgree(HttpServletRequest req, HttpServletResponse res, UICommentAgreeVO commentAgree) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, commentAgree);
		commentAgree.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		commentAgree.setAgreeYn("Y");

		mav.addObject("result", commentService.updateCommentAgreeCount(commentAgree));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 댓글 반대수 증가 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICommentAgreeVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/board/comment/disagree/update.do")
	public ModelAndView updateDisagree(HttpServletRequest req, HttpServletResponse res, UICommentAgreeVO commentAgree) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, commentAgree);
		commentAgree.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		commentAgree.setAgreeYn("N");

		mav.addObject("result", commentService.updateCommentDisagreeCount(commentAgree));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 댓글 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICommentVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/board/comment/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UICommentVO comment) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, comment);

		commentService.deleteComment(comment);

		mav.setViewName("/common/save");
		return mav;
	}

}
