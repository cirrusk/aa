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

import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivOcwCommentAgreeVO;
import com._4csoft.aof.ui.univ.vo.UIUnivOcwCommentVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivOcwCommentCondition;
import com._4csoft.aof.univ.service.UnivOcwCommentService;

/**
 * 
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivOcwCommentController.java
 * @Title : ocw 댓글
 * @date : 2014. 5. 15.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivOcwCommentController extends BaseController {

	@Resource (name = "UnivOcwCommentService")
	private UnivOcwCommentService ocwCommentService;

	/**
	 * 댓글 목록 화면 (팝업)
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivOcwCommentCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/comment/list/popup.do")
	public ModelAndView popup(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCommentCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);

		mav.setViewName("/univ/ocwCourse/comment/commentPopup");
		return mav;
	}

	/**
	 * 댓글 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivOcwCommentCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/comment/list/ajax.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCommentCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=0", "perPage=10", "orderby=0");

		mav.addObject("paginate", ocwCommentService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/ocwCourse/comment/listCommentAjax");
		return mav;
	}

	/**
	 * 댓글 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivOcwCommentVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/comment/edit/popup.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCommentVO comment) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", ocwCommentService.getDetail(comment));

		mav.setViewName("/univ/ocwCourse/comment/editCommentPopup");
		return mav;
	}

	/**
	 * 댓글 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivOcwCommentVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/comment/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCommentVO comment) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, comment);

		emptyValue(comment, "secretYn=N");
		ocwCommentService.insertOcwComment(comment);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 댓글 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivOcwCommentVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/comment/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCommentVO comment) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, comment);

		emptyValue(comment, "secretYn=N");
		ocwCommentService.updateOcwComment(comment);

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
	@RequestMapping ("/univ/ocw/course/comment/agree/update.do")
	public ModelAndView updateAgree(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCommentAgreeVO commentAgree) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, commentAgree);
		commentAgree.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		commentAgree.setAgreeYn("Y");

		mav.addObject("result", ocwCommentService.updateOcwCommentAgreeCount(commentAgree));

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
	@RequestMapping ("/univ/ocw/course/comment/disagree/update.do")
	public ModelAndView updateDisagree(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCommentAgreeVO commentAgree) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, commentAgree);
		commentAgree.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		commentAgree.setAgreeYn("N");

		mav.addObject("result", ocwCommentService.updateOcwCommentDisagreeCount(commentAgree));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 댓글 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivOcwCommentVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/comment/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCommentVO comment) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, comment);

		ocwCommentService.deleteOcwComment(comment);

		mav.setViewName("/common/save");
		return mav;
	}

}
