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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.board.vo.BoardVO;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.board.vo.condition.UIBoardCondition;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBbsVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivYearTermVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveBbsCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveRS;
import com._4csoft.aof.univ.service.UnivCourseActiveBbsService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivCourseActiveVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveBbsController.java
 * @Title : 과정 게시판 컨트롤러
 * @date : 2014. 03. 19.
 * @author : 류정희
 * @descrption : 과정 게시판 컨트롤러
 */
@Controller
public class UIUnivCourseActiveBbsController extends BaseController {

	@Resource (name = "UnivCourseActiveBbsService")
	private UnivCourseActiveBbsService bbsService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;
	
	@Resource (name = "UnivYearTermService")
	private UnivYearTermService yearTermService;

	@Resource (name = "BoardService")
	private BoardService boardService;
	
	private final String BOARD_REFERENCE_TYPE = "course";
	
	private final String NEWS_LIMIT_NUMBER = "3";

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
	@RequestMapping (value = { "/usr/classroom/course/bbs/{boardType}/list.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		
		condition.setSrchBoardTypeCd("BOARD_TYPE::" + boardType.toUpperCase());
		condition.setSrchCourseActiveSeq(Long.parseLong(req.getAttribute("_CLASS_courseActiveSeq").toString()));

		// 검색조건 값이 있으면 searchYn을 셋팅.
		if (StringUtil.isNotEmpty(condition.getSrchBbsTypeCd())) {
			condition.setSrchSearchYn("Y");
		}
		if (StringUtil.isNotEmpty(condition.getSrchWord())) {
			condition.setSrchSearchYn("Y");
		}
		if ("Y".equals(condition.getSrchSearchYn()) == false) {
			mav.addObject("alwaysTopList", bbsService.getListCourseAlwaysTop(condition));
			condition.setSrchAlwaysTopYn("N");
		}
		if("one2one".equals(boardType) || "appeal".equals(boardType)){
			condition.setSrchRegMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		}
		if("appeal".equals(boardType)){
			//1. 과정정보 조회
			UnivCourseActiveVO courseActiveVo = new UnivCourseActiveVO();
			Long courseActiveSeq = Long.parseLong(req.getAttribute("_CLASS_courseActiveSeq").toString());
			courseActiveVo.setCourseActiveSeq(courseActiveSeq);
			UIUnivCourseActiveRS result = (UIUnivCourseActiveRS)courseActiveService.getDetailCourseActive(courseActiveVo);

			//2. 학기정보 조회(등록 신청기간)
			if(result != null){
				String yearTerm = result.getCourseActive().getYearTerm();
				UIUnivYearTermVO yearTermVo = new UIUnivYearTermVO();
				yearTermVo.setYearTerm(yearTerm);
				mav.addObject("yearTerm", yearTermService.getDetailYearTerm(yearTermVo));
			}
		};
		
		BoardVO vo = new BoardVO();
		vo.setBoardSeq(condition.getSrchBoardSeq());
		UIBoardRS detailBoard = (UIBoardRS)boardService.getDetail(vo);
		
		mav.addObject("paginate", bbsService.getList(condition));
		mav.addObject("condition", condition);
		mav.addObject("detailBoard", detailBoard);
		mav.addObject("boardType", boardType);

		mav.setViewName("/univ/classroom/courseBbs/listBbs");
		
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
	@RequestMapping (value = { "/usr/classroom/course/bbs/{boardType}/detail.do" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
			
		BoardVO vo = new BoardVO();
		vo.setBoardSeq(condition.getSrchBoardSeq());
		UIBoardRS detailBoard = (UIBoardRS)boardService.getDetail(vo);

		if (detailBoard != null) {
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("detailBbs", bbsService.getDetail(bbs));
			mav.addObject("condition", condition);
			mav.addObject("boardType", boardType);
			
			bbsService.updateBbsViewCount(bbs);
		}
		
		mav.setViewName("/univ/classroom/courseBbs/detailBbs");
		
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
	@RequestMapping (value = { "/usr/classroom/course/bbs/{boardType}/create.do" })
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		BoardVO vo = new BoardVO();
		vo.setBoardSeq(condition.getSrchBoardSeq());
		UIBoardRS detailBoard = (UIBoardRS)boardService.getDetail(vo);

		if (detailBoard != null) {
			if (StringUtil.isNotEmpty(bbs.getParentSeq())) {
				bbs.setBbsSeq(bbs.getParentSeq());
				mav.addObject("detailParentBbs", bbsService.getDetail(bbs));
			}
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("condition", condition);
			mav.addObject("boardType", boardType);
		}

		mav.setViewName("/univ/classroom/courseBbs/createBbs");
		
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
	@RequestMapping (value = { "/usr/classroom/course/bbs/{boardType}/edit.do" })
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		BoardVO vo = new BoardVO();
		vo.setBoardSeq(condition.getSrchBoardSeq());
		UIBoardRS detailBoard = (UIBoardRS)boardService.getDetail(vo);

		if (detailBoard != null) {
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("detailBbs", bbsService.getDetail(bbs));
			mav.addObject("condition", condition);
			mav.addObject("boardType", boardType);
		}
		
		mav.setViewName("/univ/classroom/courseBbs/editBbs");
		
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
	@RequestMapping (value = { "/usr/classroom/course/bbs/{boardType}/reply/list/ajax.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivCourseActiveBbsCondition condition = new UIUnivCourseActiveBbsCondition();

		emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchParentSeq(bbs.getBbsSeq());

		mav.addObject("detailBbs", bbsService.getDetail(bbs));
		mav.addObject("paginate", bbsService.getListReply(condition));
		mav.addObject("boardType", boardType);

		mav.setViewName("/univ/classroom/courseBbs/listReplyBbsAjax");
		
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
	@RequestMapping ("/usr/classroom/course/bbs/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);
		
		String boardType = "BOARD_TYPE::" + req.getParameter("boardType").toUpperCase();
		Long courseActiveSeq = Long.parseLong(req.getAttribute("_CLASS_courseActiveSeq").toString());
		
		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=Y", "multiRegYn=N", "boardTypeCd=" + boardType, "courseActiveSeq=" + courseActiveSeq, "alarmUseYn=N");
		
		//답변글일경우
		if(bbs.getParentSeq() > 0 && bbs.getGroupLevel() == 2l){
			//QNA 답변타입일 경우
			if("BOARD_TYPE::QNA".equals(boardType)){
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
	 * @param UIUnivCourseActiveBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/course/bbs/update.do")
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
	@RequestMapping ("/usr/classroom/course/bbs/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		bbsService.deleteBbs(bbs);

		mav.setViewName("/common/save");
		
		return mav;
	}
	
	/**
	 * 과정 게시판정보 (bbsClassroom)
	 * 
	 * @param referenceSeq
	 * @param boardType
	 * @return UIBoardRS
	 * @throws Exception
	 */
	@RequestMapping("/usr/classroom/course/bbs/list/ajax.do")
	public ModelAndView getCourseBbsAjax(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIUnivCourseApplyVO applyVo) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		// 강의실 게시판 메뉴 구성 정보
		UIBoardCondition condition = new UIBoardCondition();
		condition.setSrchReferenceSeq(vo.getCourseActiveSeq());
		condition.setSrchReferenceType(BOARD_REFERENCE_TYPE);
		condition.setSrchUseYn("Y");
		condition.setCourseApplySeq(applyVo.getCourseApplySeq());
		condition.setSrchNewsLimitNumber(NEWS_LIMIT_NUMBER);
		
		mav.addObject("bbsNewsCntList", boardService.getNewsCount(condition));

		mav.setViewName("/univ/classroom/include/bbsClassroomAjax");
		
		return mav;
	}
	
	/**
	 * 과정 게시판 새소식(homeClassroom)
	 * 
	 * @param referenceSeq
	 * @param boardType
	 * @return UIBoardRS
	 * @throws Exception
	 */
	@RequestMapping("/usr/classroom/course/bbs/news/list/ajax.do")
	public ModelAndView getCourseBbsNewsListAjax(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIUnivCourseApplyVO applyVo) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		// 강의실 게시판 메뉴 구성 정보
		UIBoardCondition condition = new UIBoardCondition();
		condition.setSrchReferenceSeq(vo.getCourseActiveSeq());
		condition.setSrchReferenceType(BOARD_REFERENCE_TYPE);
		condition.setSrchUseYn("Y");
		condition.setCourseApplySeq(applyVo.getCourseApplySeq());
		condition.setSrchNewsLimitNumber(NEWS_LIMIT_NUMBER);
		
		mav.addObject("bbsNewsCntList", boardService.getNewsCount(condition));
		
		mav.setViewName("/univ/classroom/include/bbsClassroomNewsListAjax");
		
		return mav;
	}

}
