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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.board.vo.BoardVO;
import com._4csoft.aof.ui.board.vo.UIBoardVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCoursePostEvaluateVO;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.service.UnivCoursePostEvaluateService;
import com._4csoft.aof.univ.vo.UnivCoursePostEvaluateVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCoursePostEvaluateController.java
 * @Title : 교과목구성정보 참여
 * @date : 2014. 2. 26.
 * @author : 김영학
 * @descrption : 참여 평가기준 등록
 */
@Controller
public class UIUnivCoursePostEvaluateController extends BaseController {

	@Resource (name = "BoardService")
	private BoardService boardService;

	@Resource (name = "UnivCoursePostEvaluateService")
	private UnivCoursePostEvaluateService coursePostEvaluateService;

	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService univCourseActiveEvaluateService;

	/**
	 * 참여 평가기준 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/join/edit.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCoursePostEvaluateVO postEvaluate) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		postEvaluate.copyShortcut();

		// 1.참여게시판을 가져오기
		mav.addObject("boardList", boardService.getListByReference("course", postEvaluate.getCourseActiveSeq()));

		// 2.이전에 등록했던 게시글 평가기준정보를 가져오기
		UIUnivCoursePostEvaluateVO postEvaluateVo = new UIUnivCoursePostEvaluateVO();
		postEvaluateVo.setCourseActiveSeq(postEvaluate.getCourseActiveSeq());
		postEvaluateVo.setPostType("board");

		mav.addObject("postEvaluate", postEvaluate);
		mav.addObject("listBoardPostEvaluate", coursePostEvaluateService.getList(postEvaluateVo));

		// 평가비율
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(postEvaluate.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		mav.setViewName("/univ/courseActiveElement/postEvaluate/editPostEvaluate");

		return mav;
	}

	/**
	 * 참여 평가기준 등록
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/join/updatelist.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIBoardVO boardVo, UIUnivCoursePostEvaluateVO coursePostEvaluateVo)
			throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req, boardVo, coursePostEvaluateVo);

		// [1]. 게시판 참여여부 수정 (체크된 게시판은 'Y', 체크안된 게시판은 'N'으로 변경한다.
		List<BoardVO> boardList = new ArrayList<BoardVO>();
		if (boardVo.getBoardSeqs() != null) {
			for (int index = 0; index < boardVo.getBoardSeqs().length; index++) {
				UIBoardVO o = new UIBoardVO();
				o.setBoardSeq(boardVo.getBoardSeqs()[index]);
				o.setJoinYn(boardVo.getJoinYns()[index]);
				o.copyAudit(boardVo);

				boardList.add(o);
			}
			boardService.updatelistBoard(boardList);
		}

		// [2]. 게시글 평가기준 등록
		List<UnivCoursePostEvaluateVO> coursePostEvaluateList = new ArrayList<UnivCoursePostEvaluateVO>();
		if (coursePostEvaluateVo.getPostEvaluateSeqs() != null) {
			for (int index = 0; index < coursePostEvaluateVo.getPostEvaluateSeqs().length; index++) {
				UIUnivCoursePostEvaluateVO o = new UIUnivCoursePostEvaluateVO();
				o.setPostEvaluateSeq(coursePostEvaluateVo.getPostEvaluateSeqs()[index]);
				o.setCourseActiveSeq(coursePostEvaluateVo.getCourseActiveSeq());
				o.setPostType(coursePostEvaluateVo.getPostType());
				o.setFromCount(coursePostEvaluateVo.getFromCounts()[index]);
				o.setToCount(coursePostEvaluateVo.getToCounts()[index]);
				o.setScore(coursePostEvaluateVo.getScores()[index]);
				o.setSortOrder(coursePostEvaluateVo.getSortOrders()[index]);
				o.copyAudit(coursePostEvaluateVo);
				coursePostEvaluateList.add(o);
			}
		}

		if (coursePostEvaluateList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", coursePostEvaluateService.saveCoursePostEvaluate(coursePostEvaluateList));
		}

		mav.setViewName("/common/save");

		return mav;
	}

}
