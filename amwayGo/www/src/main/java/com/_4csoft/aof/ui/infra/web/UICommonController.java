/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BbsService;
import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.infra.service.MemberService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.ui.board.vo.condition.UIBbsCondition;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.resultset.UIMemberRS;

/**
 * @Project : aof5-demo-www
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UICommonController.java
 * @Title : UICommon Controller
 * @date : 2013. 5. 24.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICommonController extends BaseController {
	protected final Log log = LogFactory.getLog(getClass());

	@Resource (name = "BbsService")
	private BbsService bbsService;

	@Resource (name = "BoardService")
	private BoardService boardService;
	
	@Resource (name = "MemberService")
	private MemberService memberService;

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
	 * 로그인 후 로드되는 첫 페이지
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/common/greeting.do")
	public ModelAndView greeting(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		
		String viewName = "/common/greeting";

		// 메인화면 게시판 내용
		UIBbsCondition bbsCondition = new UIBbsCondition();
		emptyValue(bbsCondition, "currentPage=1", "perPage=5", "orderby=0");
		UIBoardRS detailBoard = null;
		
		// 공지사항
		detailBoard = getDetailBoard("notice");

		if (detailBoard != null) {
			Long boardSeq = detailBoard.getBoard().getBoardSeq();

			bbsCondition.setSrchBoardSeq(boardSeq);
			mav.addObject("noticeList", bbsService.getList(bbsCondition));
		}

		// Q&A
		detailBoard = getDetailBoard("qna");

		if (detailBoard != null) {
			Long boardSeq = detailBoard.getBoard().getBoardSeq();

			bbsCondition.setSrchBoardSeq(boardSeq);
			mav.addObject("qnaList", bbsService.getList(bbsCondition));
		}
		
		// FAQ
		detailBoard = getDetailBoard("faq");
		
		if (detailBoard != null) {
			Long boardSeq = detailBoard.getBoard().getBoardSeq();
			
			bbsCondition.setSrchBoardSeq(boardSeq);
			mav.addObject("faqList", bbsService.getList(bbsCondition));
		}

		// 비밀번호 변경날짜 확인
		UIMemberVO member = new UIMemberVO();
		member.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		UIMemberRS rs = (UIMemberRS)memberService.getDetail(member);
		
		if(req.getHeader("referer").indexOf("jsp") > -1){
			if(rs.getMember().getMigLastTime() == null || "".equals(rs.getMember().getMigLastTime())) {
				if(DateUtil.getToday().after(DateUtil.getFormatDate(rs.getMember().getPlanPasswordUpdDtime(), Constants.FORMAT_DBDATETIME))) {
					member.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
					mav.addObject("member", member);
					mav.addObject("updateType", "modify");
					viewName = "/mypage/member/editPassword";
				}
			}
		}
		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 이용약관 페이지 이동
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/terms/agree.do")
	public ModelAndView agree(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/common/termsAgree");
		return mav;
	}

	/**
	 * 개인정보취급방침 페이지 이동
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/terms/privacy.do")
	public ModelAndView privacy(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/common/termsPrivacy");
		return mav;
	}

	/**
	 * 이메일무단수집거부 페이지 이동
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/terms/email/reject.do")
	public ModelAndView emailReject(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/common/termsEmailReject");
		return mav;
	}

	/**
	 * 학사서비스
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/school/frame/school.do")
	public ModelAndView school(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/common/frameSchool");
		return mav;
	}

	/**
	 * 시험, 설문 등 팝업 열려 있을 때 세션 타임 복구 위해 필요한 메소드
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/ping/ajax.do")
	public ModelAndView ping(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * api를 테스트 할 수 있는 페이지
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/api/index.do")
	public ModelAndView indexApi(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("/common/api/index");
		return mav;
	}
	
	/**
	 * api 페이지
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/api/file.do")
	public ModelAndView fileApi(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("/common/api/" + HttpUtil.getParameter(req, "filename", "empty"));
		return mav;
	}
	
}
