/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.api;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BbsService;
import com._4csoft.aof.board.service.CommentService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.AttachUtil;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.AttachVO;
import com._4csoft.aof.infra.vo.base.AttachReferenceVO;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.board.vo.UICommentVO;
import com._4csoft.aof.ui.board.vo.resultset.UICommentRS;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;
import com._4csoft.aof.ui.infra.vo.UIPushMessageTargetVO;
import com._4csoft.aof.univ.support.UnivAttachReference.AttachType;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.board.api
 * @File : UICommentController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 23.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICommentController extends UIBaseController {

	@Resource (name = "CommentService")
	private CommentService commentService;
	
	@Resource (name = "BbsService")
	private BbsService bbsService;
	
	@Resource (name = "AttachUtil")
	private AttachUtil attachUtil;

	/**
	 * 댓글 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICommentVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/bbs/comment/insert")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		String resultCode = UIApiConstant._SUCCESS_CODE;
		UICommentVO comment = new UICommentVO();
		checkSession(req);

		try {
			comment.setBbsSeq(Long.parseLong(req.getParameter("bbsSeq")));
			comment.setDescription(HttpUtil.getParameter(req, "description"));
		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}

		// 필수값
		if (StringUtil.isEmpty(comment.getBbsSeq()) || StringUtil.isEmpty(comment.getDescription())) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}

		// 상위 게시물 존재 확인
		// BbsVO vo = new BbsVO();
		// vo.setBbsSeq(comment.getBbsSeq());
		// BbsSeqMapper
		// if (bbsService.getDetail(vo) == null) {
		// throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED) + " bbs not exist");
		// }

		requiredSession(req, comment);
		
		AttachVO voAttach = fileAttach(req);
		
		emptyValue(comment, "secretYn=N");
		commentService.insertComment(comment);
		
		if(voAttach != null){
			AttachReferenceVO voReference = new AttachReferenceVO("course_comment", "cs_comment", 
					"course/bbs/comment");
			
			voAttach.copyAudit(comment);
			attachUtil.insert(voAttach, comment.getCommentSeq(), voReference);
		}
		
/*		
		UIPushMessageTargetVO pushMessageTarget = new UIPushMessageTargetVO();
		pushMessageTarget.copyAudit(comment);
		//pushMessageTarget.setCourseActiveSeq(courseActiveBbs.getCourseActiveSeq());
		pushMessageTarget.setPushMessage("새로운 댓글 알림 ");

		// 구분자
		// IOS : §¿
		// Android : 
		// 메시지 타입 = 메시지타입 + 구분자 + 운영과정일련번호 + 구분자 +게시글 일련번호 + boardType + boardSeq + applyType 추가
		String pushMessageType = courseActiveBbs.getPushMessageType() + Constants.SEPARATOR + "" + Constants.SEPARATOR
				+ comment.getBbsSeq() + Constants.SEPARATOR + comment.getBoardTypeCd() + Constants.SEPARATOR + courseActiveBbs.getBoardSeq() + Constants.SEPARATOR;
		pushMessageTarget.setPushMessageType(pushMessageType);

		if (pushMessageTargetMapper.countMessageOfCourseApply(pushMessageTarget) > 0) {
			pushMessageTargetMapper.insertlistMessageOfCourseApply(pushMessageTarget);
		}
*/

		mav.addObject("resultCode", resultCode);
		mav.addObject("commentSeq", comment.getCommentSeq());
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
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
	@RequestMapping ("/api/bbs/comment/delete")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;
		UICommentVO comment = new UICommentVO();
		checkSession(req);

		try {
			comment.setBbsSeq(Long.parseLong(req.getParameter("bbsSeq")));
			comment.setCommentSeq(Long.parseLong(req.getParameter("commentSeq")));
		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}
		if (StringUtil.isEmpty(comment.getBbsSeq()) || StringUtil.isEmpty(comment.getCommentSeq())) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}
		ResultSet rs = commentService.getDetail(comment);
		if (rs == null) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED) + " comment not exist");
		} else {

			UICommentRS commentRS = (UICommentRS)rs;

			if (!commentRS.getComment().getBbsSeq().equals(comment.getBbsSeq())) {
				throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED) + " bbs not exist");

			}
		}

		requiredSession(req, comment);
		commentService.deleteComment(comment);

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}
}
