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

import com._4csoft.aof.board.service.BbsService;
import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.service.UIUnivCourseActiveBbsService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBbsVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveBbsCondition;
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
public class UIUnivCourseActiveBbsController extends BaseController {

	@Resource (name = "UIUnivCourseActiveBbsService")
	private UIUnivCourseActiveBbsService bbsService;
	
	BbsService ab;

	@Resource (name = "BoardService")
	private BoardService boardService;

	private final String BOARD_REFERENCE_TYPE = "course";

	/**
	 * 게시판 상세정보
	 * 
	 * @param referenceSeq
	 * @param boardType
	 * @return UIBoardRS
	 * @throws Exception
	 */
	public UIBoardRS getDetailBoard(Long referenceSeq, String boardType) throws Exception {

		return (UIBoardRS)boardService.getDetailByReference(BOARD_REFERENCE_TYPE, referenceSeq, "BOARD_TYPE::" + boardType.toUpperCase());
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
	@RequestMapping (value = { "/univ/course/bbs/{boardType}/list.do", "/mypage/univ/course/bbs/{boardType}/list.do", "/univ/course/bbs/{boardType}/listAdmin.do", "/univ/course/bbs/{boardType}/listAll.do"})
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "";
		
		log.debug("eee" + req.getServletPath());
		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		
		if (req.getServletPath().startsWith("/mypage/")) {
			viewName = "/univ/courseBbs/mypage/listBbs";
		}else if(req.getServletPath().endsWith("listAdmin.do")) {
			condition.setCurrentPage(0);
			condition.setSrchProfViewYn("Y");
			viewName = "/univ/courseBbs/listAsk";
		}else if(req.getServletPath().endsWith("listAll.do")) {
			condition.setCurrentPage(0);
			viewName = "/univ/courseBbs/listAsk";
		}else if(boardType.equals("ask")) {
			viewName = "/univ/courseBbs/listBbs";
		}else if(boardType.equals("celebrate")) {
			condition.setCurrentPage(0);
			viewName = "/univ/courseBbs/listCelebrate";
		}
		else {
			viewName = "/univ/courseBbs/listBbs";
		}
		
		condition.setSrchBoardTypeCd("BOARD_TYPE::" + boardType.toUpperCase());
		condition.setSrchCourseActiveSeq(bbs.getShortcutCourseActiveSeq());

		if (StringUtil.isNotEmpty(bbs.getShortcutCourseActiveSeq())) {
			UIBoardRS detailBoard = getDetailBoard(bbs.getShortcutCourseActiveSeq(), boardType);

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
				if (!"Y".equals(condition.getSrchSearchYn())) {
					mav.addObject("alwaysTopList", bbsService.getListCourseAlwaysTop(condition));
					condition.setSrchAlwaysTopYn("N");
				}
				mav.addObject("paginate", bbsService.getList(condition));

				mav.addObject("condition", condition);
				mav.addObject("detailBoard", detailBoard);
				mav.addObject("boardType", boardType);
			}
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
	@RequestMapping (value = { "/univ/course/bbs/{boardType}/detail.do", "/mypage/univ/course/bbs/{boardType}/detail.do" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "";
		if (req.getServletPath().startsWith("/mypage/")) {
			viewName = "/univ/courseBbs/mypage/detailBbs";
		} else {
			viewName = "/univ/courseBbs/detailBbs";
		}

		requiredSession(req);

		if (StringUtil.isNotEmpty(bbs.getShortcutCourseActiveSeq())) {
			UIBoardRS detailBoard = getDetailBoard(bbs.getShortcutCourseActiveSeq(), boardType);
			bbs.setCourseActiveSeq(bbs.getShortcutCourseActiveSeq());
			if (detailBoard != null) {
				mav.addObject("detailBoard", detailBoard);
				mav.addObject("detailBbs", bbsService.getDetail(bbs));
				mav.addObject("condition", condition);
				mav.addObject("categoryType", bbs.getShortcutCategoryTypeCd());
				mav.addObject("boardType", boardType);
			}
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
	@RequestMapping (value = { "/univ/course/bbs/{boardType}/create.do", "/mypage/univ/course/bbs/{boardType}/create.do" })
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "";
		if (req.getServletPath().startsWith("/mypage/")) {
			viewName = "/univ/courseBbs/mypage/createBbs";
		} else {
			viewName = "/univ/courseBbs/createBbs";
		}

		requiredSession(req);

		if (StringUtil.isNotEmpty(bbs.getShortcutCourseActiveSeq())) {
			UIBoardRS detailBoard = getDetailBoard(bbs.getShortcutCourseActiveSeq(), boardType);

			if (detailBoard != null) {
				if (StringUtil.isNotEmpty(bbs.getParentSeq())) {
					bbs.setBbsSeq(bbs.getParentSeq());
					mav.addObject("detailParentBbs", bbsService.getDetail(bbs));
				}
				mav.addObject("detailBoard", detailBoard);
				mav.addObject("condition", condition);
				mav.addObject("boardType", boardType);
			}
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
	@RequestMapping (value = { "/univ/course/bbs/{boardType}/edit.do", "/mypage/univ/course/bbs/{boardType}/edit.do" })
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "";
		if (req.getServletPath().startsWith("/mypage/")) {
			viewName = "/univ/courseBbs/mypage/editBbs";
		} else {
			viewName = "/univ/courseBbs/editBbs";
		}

		requiredSession(req);

		if (StringUtil.isNotEmpty(bbs.getShortcutCourseActiveSeq())) {
			UIBoardRS detailBoard = getDetailBoard(bbs.getShortcutCourseActiveSeq(), boardType);

			if (detailBoard != null) {
				mav.addObject("detailBoard", detailBoard);

				mav.addObject("detailBbs", bbsService.getDetail(bbs));
				mav.addObject("condition", condition);
				mav.addObject("boardType", boardType);
			}
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
	@RequestMapping (value = { "/univ/course/bbs/{boardType}/reply/list/ajax.do", "/mypage/univ/course/bbs/{boardType}/reply/list/ajax.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs)
			throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "";
		if (req.getServletPath().startsWith("/mypage/")) {
			viewName = "/univ/courseBbs/mypage/listReplyBbsAjax";
		} else {
			viewName = "/univ/courseBbs/listReplyBbsAjax";
		}

		requiredSession(req);

		UIUnivCourseActiveBbsCondition condition = new UIUnivCourseActiveBbsCondition();

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
	 * @param UIUnivCourseActiveBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/bbs/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		String boardType = "BOARD_TYPE::" + req.getParameter("boardType").toUpperCase();

		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=Y", "multiRegYn=N", "boardTypeCd=" + boardType, "alarmUseYn=N");

		// 답변글일경우
		if (bbs.getParentSeq() > 0 && bbs.getGroupLevel() == 2l) {
			// QNA 답변타입일 경우
			if ("BOARD_TYPE::QNA".equals(boardType)) {
				bbs.setTemplateTypeCd("MESSAGE_TEMPLATE_TYPE::QNA");
				bbs.setAlarmUseYn("Y");
				bbs.setSendScheduleCd("MESSAGE_SCHEDULE_TYPE::001");
			}
		}

		if (codes.get("CD.BOARD_TYPE.FREE").equals(boardType)) {// 자료사례공유

			bbs.setPushMessageType(UIUnivCourseActiveBbsService.COURSE_ACTIVE_SHARE_RESOURCE);
		} else if (codes.get("CD.BOARD_TYPE.NOTICE").equals(boardType)) { // 공지사항
			if(bbs.getEvaluateYns() != null){
				for(int i=0; i < bbs.getEvaluateYns().length; i++){
					//공지사항 등록시 채팅방사용여부 체크 후 태그 붙이기
					if("C".equals(bbs.getEvaluateYns()[i])){
						String Description = bbs.getDescription()+"<div style='text-align: center;' align='center'><a href='gochat://'><img src='/storage/image/course/bbs/notice/2016/10/04/5CMvIkMgmjB5NGscsS3F.jpg' width='300'></a></div><br/>";
						bbs.setDescription(Description);
					}else if("H".equals(bbs.getEvaluateYns()[i])){
						String Description = bbs.getDescription()+"<div style='text-align: center;' align='center'><a href='goreport://'><img src='/storage/image/course/bbs/notice/2016/10/04/4CMvIkMgmjB5NGscsS3F.jpg' width='300'></a></div><br/>";
						bbs.setDescription(Description);
					}else if("R".equals(bbs.getEvaluateYns()[i])){
						String Description = bbs.getDescription()+"<div style='text-align: center;' align='center'><a href='golive://'><img src='/storage/image/course/bbs/notice/2016/10/04/3CMvIkMgmjB5NGscsS3F.jpg' width='300'></a></div><br/>";
						bbs.setDescription(Description);
					}else if("T".equals(bbs.getEvaluateYns()[i])){
						String Description = bbs.getDescription()+"<div style='text-align: center;' align='center'><a href='goteam://'><img src='/storage/image/course/bbs/notice/2016/10/04/2CMvIkMgmjB5NGscsS3F.jpg' width='300'></a></div><br/>";
						bbs.setDescription(Description);
					}else if("S".equals(bbs.getEvaluateYns()[i])){
						String Description = bbs.getDescription()+"<div style='text-align: center;' align='center'><a href='gosurvey://'><img src='/storage/image/course/bbs/notice/2016/10/04/1CMvIkMgmjB5NGscsS3F.jpg' width='300'></a></div><br/>";
						bbs.setDescription(Description);
					}
				}
			}
			if(!"null".equals(bbs.getLinkText()) && bbs.getLinkText() != null && bbs.getLinkText() != ""){
				String Description = bbs.getDescription()+"<br/><br/>"+bbs.getLinkName()+"바로가기"+"<br/><a href='"+bbs.getLinkText()+"' target='_blank'>"+bbs.getLinkText()+"</a>";
				bbs.setDescription(Description);
			}
			bbs.setPushMessageType(UIUnivCourseActiveBbsService.COURSE_ACTIVE_NOTICE);
		} else if (codes.get("CD.BOARD_TYPE.RESOURCE").equals(boardType)) { // 과제방

			bbs.setPushMessageType(UIUnivCourseActiveBbsService.COURSE_ACTIVE_RESOURCE);
		} else if (codes.get("CD.BOARD_TYPE.QNA").equals(boardType)) { // 질문방

			bbs.setPushMessageType(UIUnivCourseActiveBbsService.COURSE_ACTIVE_HOMEWORK);
		}

		bbs.setBoardTypeCd(boardType);
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
	@RequestMapping ("/univ/course/bbs/update.do")
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
	@RequestMapping ("/univ/course/bbs/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		bbsService.deleteBbs(bbs);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시글 다중 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseActiveBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/bbs/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		List<UnivCourseActiveBbsVO> voList = new ArrayList<UnivCourseActiveBbsVO>();
		for (String index : bbs.getCheckkeys()) {
			UIUnivCourseActiveBbsVO o = new UIUnivCourseActiveBbsVO();
			o.setBoardSeq(bbs.getBoardSeqs()[Integer.parseInt(index)]);
			o.setBbsSeq(bbs.getBbsSeqs()[Integer.parseInt(index)]);
			if(bbs.getEvaluateYns() != null)
				o.setEvaluateYn(bbs.getEvaluateYns()[Integer.parseInt(index)]);
			o.setProfViewYn("Y");
			o.copyAudit(bbs);
			voList.add(o);
		}

		if (voList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", bbsService.updatelistBbs(voList));
		}
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
	@RequestMapping ("/univ/course/bbs/deletelist.do")
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

	/**
	 * 게시물 현황
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = { "/univ/course/bbs/stat/list.do" })
	public ModelAndView listCourseBbsStat(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", bbsService.getListBbsStatistics(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseBbs/listBbsStat");
		return mav;
	}
	
	@RequestMapping (value = { "/univ/course/bbs/{boardType}/ajax.do"})
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs, UIUnivCourseActiveBbsCondition condition, @PathVariable ("boardType") String boardType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0", "srchBeforeAfter=after");
		condition.setSrchBoardTypeCd("BOARD_TYPE::" + boardType.toUpperCase());
		condition.setSrchCourseActiveSeq(bbs.getShortcutCourseActiveSeq());

		if (StringUtil.isNotEmpty(bbs.getShortcutCourseActiveSeq())) {
			UIBoardRS detailBoard = getDetailBoard(bbs.getShortcutCourseActiveSeq(), boardType);
			
			if (detailBoard != null) {
				Long boardSeq = detailBoard.getBoard().getBoardSeq();

				condition.setSrchBoardSeq(boardSeq);
				Paginate<ResultSet> list =bbsService.getList(condition);
				if(list != null){
					if(list.getTotalCount() > 0){
						mav.addObject("paginate", list);
					}else{
						mav.addObject("paginate", null);
					}
				}else{
					mav.addObject("paginate", null);
				}
				
				mav.addObject("condition", condition);
				mav.addObject("detailBoard", detailBoard);
				mav.addObject("boardType", boardType);
			}
		}
		
		mav.setViewName("jsonView");
		return mav;
	}	
	
	@RequestMapping (value={"/univ/course/bbs/{boardType}/listBbsSession.do","/univ/course/bbs/{boardType}/listAdminSession.do"})
	public ModelAndView listSession(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs, UIUnivCourseActiveBbsCondition condition, @PathVariable ("boardType") String boardType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		
		String viewName = "/univ/courseBbs/listBbsSession";
		
		if(req.getServletPath().endsWith("listBbsSession.do")){
			viewName = "/univ/courseBbs/listBbsSession";
		}else{
			viewName = "/univ/courseBbs/listAdminSession";
		}
		
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchBoardTypeCd("BOARD_TYPE::" + boardType.toUpperCase());
		condition.setSrchCourseActiveSeq(bbs.getShortcutCourseActiveSeq());

		if (StringUtil.isNotEmpty(bbs.getShortcutCourseActiveSeq())) {
			UIBoardRS detailBoard = getDetailBoard(bbs.getShortcutCourseActiveSeq(), boardType);

			if (detailBoard != null) {
				Long boardSeq = detailBoard.getBoard().getBoardSeq();

				condition.setSrchBoardSeq(boardSeq);
				
				mav.addObject("paginate", bbsService.getList(condition));
				mav.addObject("condition", condition);
				mav.addObject("detailBoard", detailBoard);
				mav.addObject("boardType", boardType);
			}
		}
		
		mav.setViewName(viewName);
		return mav;
	}
}
