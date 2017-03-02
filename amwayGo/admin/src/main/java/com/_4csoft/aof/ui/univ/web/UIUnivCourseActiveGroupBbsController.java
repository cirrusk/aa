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
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBbsVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveBbsCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveBbsService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivCourseActiveVO;
import com._4csoft.aof.univ.vo.UnivYearTermVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveGroupBbsController.java
 * @Title : 개설과목 게시글
 * @date : 2014. 3. 27.
 * @author : 김영학
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseActiveGroupBbsController extends BaseController {

	@Resource (name = "UnivCourseActiveBbsService")
	private UnivCourseActiveBbsService bbsService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService activeService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

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
	 * 게시글 목록 화면 (Mypage)
	 * 
	 * @param req
	 * @param res
	 * @param boardType
	 * @param bbs
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/mypage/univ/course/group/bbs/{boardType}/list.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		String viewName = "/univ/courseBbs/mypage/listBbs";

		requiredSession(req);

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchBoardTypeCd("BOARD_TYPE::" + boardType.toUpperCase());
		condition.setSrchMemberSeq(ssMember.getMemberSeq());
		condition.setSrchTargetRolegroup(ssMember.getCurrentRoleCfString());

		// 성적이의신청 미답변 목록 체크검색
		if ("appeal".equals(boardType)) {
			if (StringUtil.isEmpty(condition.getSrchReplyOnlyCheckYn())) {
				condition.setSrchReplyOnlyCheckYn("N");
			}
		} else {
			condition.setSrchReplyOnlyCheckYn("N");
		}

		// 게시판 상세정보
		UIBoardRS detailBoard = getDetailBoard(-1l, boardType);

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
				mav.addObject("alwaysTopList", bbsService.getMyPageBbsAlwaysTopList(condition));
				condition.setSrchAlwaysTopYn("N");
			}

			// 현재 년도계산
			String systemYear = DateUtil.getTodayYear() + "";

			// 학위 비학위 검색조건 (최초 접근시)
			if (StringUtil.isEmpty(condition.getSrchCategoryTypeCd())) {
				condition.setSrchCategoryTypeCd("CATEGORY_TYPE::DEGREE");

				// 시스템에 설정된 년도학기
				if (StringUtil.isEmpty(condition.getSrchYearTerm())) {
					if (ssMember.getExtendData().get("systemYearTerm") == null) {
						// 현재 년도의 1학기로 셋팅한다.
						String defaultTerm = "10";
						String yearTerm = DateUtil.getTodayYear() + defaultTerm;
						condition.setSrchYearTerm(yearTerm);
						condition.setSrchYear(systemYear);
					} else {
						UnivYearTermVO univYearTermVO = (UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm");
						condition.setSrchYearTerm(univYearTermVO.getYearTerm());
						condition.setSrchYear(systemYear);
					}
				}
			}

			// yearTerm 데이터 조회
			List<UnivYearTermVO> tempYearTermList = univYearTermService.getListYearTermAll();
			List<UnivYearTermVO> yearTermList = new ArrayList<UnivYearTermVO>();

			// 해당년도의 yearTerm만 추출
			for (int i = 0; i < tempYearTermList.size(); i++) {
				UnivYearTermVO univYearTermVO = tempYearTermList.get(i);
				if (systemYear.equals(univYearTermVO.getYear())) {
					yearTermList.add(univYearTermVO);
				}
			}

			// year 데이터 조회
			List<String> tempYearList = univYearTermService.getListYearAll();
			List<String> yearList = new ArrayList<String>();

			// 해당년도의 year만 추출
			for (int i = 0; i < tempYearList.size(); i++) {
				String year = tempYearList.get(i);
				if (systemYear.equals(year)) {
					yearList.add(year);
				}
			}

			mav.addObject("yearTerms", yearTermList);
			mav.addObject("years", yearList);

			mav.addObject("paginate", bbsService.getMyPageBbsList(condition));

			mav.addObject("condition", condition);
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("boardType", boardType);
		}

		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 게시글 상세정보 화면 (myPage)
	 * 
	 * @param req
	 * @param res
	 * @param boardType
	 * @param bbs
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/mypage/univ/course/group/bbs/{boardType}/detail.do" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		String viewName = "/univ/courseBbs/mypage/detailBbs";

		requiredSession(req);

		UIBoardRS detailBoard = getDetailBoard(-1l, boardType);

		if (detailBoard != null) {
			mav.addObject("detailBoard", detailBoard);
			mav.addObject("detailBbs", bbsService.getMyPageBbsDetail(bbs.getBbsSeq()));
			mav.addObject("detailCourseActiveBbs", bbsService.getMyPageCourseActiveBbsList(bbs.getBbsSeq()));
			mav.addObject("condition", condition);
			mav.addObject("boardType", boardType);
		}

		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 게시글 신규등록 화면 (myPage)
	 * 
	 * @param req
	 * @param res
	 * @param boardType
	 * @param bbs
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/mypage/univ/course/group/bbs/{boardType}/create.do" })
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "/univ/courseBbs/mypage/createBbs";

		requiredSession(req);

		UIBoardRS detailBoard = getDetailBoard(-1l, boardType);

		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		condition.setSrchTargetRolegroup(SessionUtil.getMember(req).getCurrentRoleCfString());

		if (detailBoard != null) {
			if (StringUtil.isNotEmpty(bbs.getParentSeq())) {
				bbs.setBbsSeq(bbs.getParentSeq());
				mav.addObject("detailParentBbs", bbsService.getMyPageBbsDetail(bbs.getBbsSeq()));
				mav.addObject("detailCourseActiveBbs", bbsService.getMyPageCourseActiveBbsList(bbs.getBbsSeq()));
			}

			// 해당유저가 설정가능한 모든 교과목정보를 조회
			mav.addObject("courseActive", activeService.getListByCourseActiveUser(condition));

			mav.addObject("detailBoard", detailBoard);
			mav.addObject("condition", condition);
			mav.addObject("boardType", boardType);
		}

		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 게시글 수정 화면 (mypage)
	 * 
	 * @param req
	 * @param res
	 * @param boardType
	 * @param bbs
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/mypage/univ/course/group/bbs/{boardType}/edit.do" })
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs,
			UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		String viewName = "/univ/courseBbs/mypage/editBbs";

		requiredSession(req);

		UIBoardRS detailBoard = getDetailBoard(-1l, boardType);

		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		condition.setSrchTargetRolegroup(SessionUtil.getMember(req).getCurrentRoleCfString());

		if (detailBoard != null) {
			mav.addObject("detailBoard", detailBoard);

			// 해당유저가 설정가능한 모든 교과목정보를 조회
			mav.addObject("courseActive", activeService.getListByCourseActiveUser(condition));

			mav.addObject("detailBbs", bbsService.getMyPageBbsDetail(bbs.getBbsSeq()));
			mav.addObject("detailCourseActiveBbs", bbsService.getMyPageCourseActiveBbsList(bbs.getBbsSeq()));
			mav.addObject("condition", condition);
			mav.addObject("boardType", boardType);
		}

		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 답변글 목록 (myPage)
	 * 
	 * @param req
	 * @param res
	 * @param boardType
	 * @param bbs
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/mypage/univ/course/group/bbs/{boardType}/reply/list/ajax.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("boardType") String boardType, UIUnivCourseActiveBbsVO bbs)
			throws Exception {
		ModelAndView mav = new ModelAndView();
		String viewName = "/univ/courseBbs/mypage/listReplyBbsAjax";

		requiredSession(req);

		UIUnivCourseActiveBbsCondition condition = new UIUnivCourseActiveBbsCondition();

		emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchParentSeq(bbs.getBbsSeq());

		mav.addObject("detailBbs", bbsService.getMyPageBbsDetail(bbs.getBbsSeq()));
		mav.addObject("paginate", bbsService.getListReply(condition));
		mav.addObject("boardType", boardType);

		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 게시글 신규등록 처리 (myPage)
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseActiveBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/mypage/univ/course/group/bbs/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		String boardType = "BOARD_TYPE::" + req.getParameter("boardType").toUpperCase();
		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=N", "multiRegYn=N", "boardTypeCd=" + boardType, "alarmUseYn=N");
		
		//답변글일경우
		if(bbs.getParentSeq() > 0 && bbs.getGroupLevel() == 2l){
			//QNA 답변타입일 경우
			if("BOARD_TYPE::QNA".equals(boardType)){
				bbs.setTemplateTypeCd("MESSAGE_TEMPLATE_TYPE::QNA");
				bbs.setAlarmUseYn("Y");
				bbs.setSendScheduleCd("MESSAGE_SCHEDULE_TYPE::001");
			}
		}
		
		List<UnivCourseActiveVO> courseActiveList = new ArrayList<UnivCourseActiveVO>();

		if (bbs.getCourseActiveSeqs() != null) {
			for (Long seq : bbs.getCourseActiveSeqs()) {
				UIUnivCourseActiveVO o = new UIUnivCourseActiveVO();
				o.setCourseActiveSeq(seq);

				courseActiveList.add(o);
			}
			// courseActive 멀티등록시
			if (courseActiveList.size() > 1) {
				bbs.setMultiRegYn("Y");
			}
		}

		bbsService.insertMyPageCourseBbs(bbs, attach, courseActiveList);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시글 수정 처리 (myPage)
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseActiveBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/mypage/univ/course/group/bbs/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		String boardType = "BOARD_TYPE::" + req.getParameter("boardType").toUpperCase();
		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=N", "multiRegYn=N", "boardTypeCd=" + boardType);

		List<UnivCourseActiveVO> courseActiveList = new ArrayList<UnivCourseActiveVO>();
		if (bbs.getCourseActiveSeqs() != null) {
			for (Long seq : bbs.getCourseActiveSeqs()) {
				UIUnivCourseActiveVO o = new UIUnivCourseActiveVO();
				o.setCourseActiveSeq(seq);

				courseActiveList.add(o);
			}
		}

		bbsService.updateMyPageCourseBbs(bbs, attach, courseActiveList);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 게시글 삭제 처리 (myPage)
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseActiveBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/mypage/univ/course/group/bbs/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveBbsVO bbs) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, bbs);

		bbsService.deleteBbs(bbs);

		mav.setViewName("/common/save");
		return mav;
	}

}
