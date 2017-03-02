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

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamItemVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseExamCondition;
import com._4csoft.aof.univ.service.UnivCourseExamItemService;
import com._4csoft.aof.univ.service.UnivCourseExamService;
import com._4csoft.aof.univ.vo.UnivCourseExamExampleVO;
import com._4csoft.aof.univ.vo.UnivCourseExamItemVO;
import com._4csoft.aof.univ.vo.UnivCourseExamVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseExamController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 26.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseExamController extends BaseController {

	@Resource (name = "UnivCourseExamService")
	private UnivCourseExamService courseExamService;

	@Resource (name = "UnivCourseExamItemService")
	private UnivCourseExamItemService courseExamItemService;

	/**
	 * 시험문제 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		String currentRoleCfString = ssMember.getCurrentRoleCfString();

		// TODO: PROF_TYPE 사용
		if ("PROF".equals(currentRoleCfString)) {// 교강사일시 검색조건 추가
			condition.setSrchProfSessionMemberSeq(ssMember.getMemberSeq());
			condition.setSrchProfMemberName(ssMember.getMemberName());
		} else if ("ASSIST".equals(currentRoleCfString) || "TUTOR".equals(currentRoleCfString)) {// 조교, 튜터일시
			condition.setSrchAssistMemberSeq(ssMember.getMemberSeq());
		}
		
		mav.addObject("paginate", courseExamService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/exam/listCourseExam");
		return mav;
	}

	/**
	 * 시험문제 목록 화면 - 팝업
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/list/popup.do")
	public ModelAndView listPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=10", "orderby=0");

		mav.addObject("paginate", courseExamService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/exam/listCourseExamPopup");
		return mav;
	}

	/**
	 * 시험문제 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamVO courseExam, UIUnivCourseExamCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", courseExamService.getDetail(courseExam));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/exam/detailCourseExam");
		return mav;
	}

	/**
	 * 시험문제 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamVO courseExam, UIUnivCourseExamCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("courseExam", courseExam);
		mav.addObject("condition", condition);

		mav.setViewName("/univ/exam/createCourseExam");
		return mav;
	}

	/**
	 * 문항추가
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/item/create.do")
	public ModelAndView createItem(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamVO courseExam) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("courseExam", courseExam);

		mav.setViewName("/univ/exam/createCourseExamItem");
		return mav;
	}

	/**
	 * 시험문제 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamVO courseExam, UIUnivCourseExamCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", courseExamService.getDetail(courseExam));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/exam/editCourseExam");
		return mav;
	}

	/**
	 * 시험문제 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamVO courseExam) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExam);

		UnivCourseExamItemVO courseExamItem = new UnivCourseExamItemVO();
		List<UnivCourseExamItemVO> listCourseExamItem = new ArrayList<UnivCourseExamItemVO>();

		courseExam.setExamTitle(courseExam.getExamItemTitle());
		if (StringUtil.isEmpty(courseExam.getOpenYn())) {
			courseExam.setOpenYn("N");
		}

		courseExamItem.setExamItemTitle(courseExam.getExamItemTitle());
		courseExamItem.setDescription(courseExam.getExamItemDescription());
		courseExamItem.setComment(courseExam.getExamItemComment());
		courseExamItem.setExamItemTypeCd(courseExam.getExamItemTypeCd());
		courseExamItem.setExamItemDifficultyCd(courseExam.getExamItemDifficultyCd());
		courseExamItem.setExamItemAlignCd(courseExam.getExamItemAlignCd());
		courseExamItem.setExamItemExampleCount(courseExam.getExamItemExampleCount());

		if (StringUtil.isNotEmpty(courseExam.getExamItemFilePath())) {
			courseExamItem.setExamFileTypeCd(courseExam.getExamItemFileTypeCd());
			courseExamItem.setFilePath(courseExam.getExamItemFilePath());
			courseExamItem.setFilePathType(courseExam.getExamItemFilePathType());
		}

		courseExamItem.setGroupKey(courseExam.getGroupKey());
		courseExamItem.setSortOrder(courseExam.getExamItemSortOrder());
		courseExamItem.setCorrectAnswer(courseExam.getCorrectAnswer());
		courseExamItem.setSimilarAnswer(courseExam.getSimilarAnswer());
		courseExamItem.setProfMemberSeq(courseExam.getProfMemberSeq());
		courseExamItem.setExamItemScore(courseExam.getExamItemScore());
		courseExamItem.setRegMemberSeq(courseExam.getRegMemberSeq());
		courseExamItem.setRegIp(courseExam.getRegIp());
		courseExamItem.setUpdMemberSeq(courseExam.getUpdMemberSeq());
		courseExamItem.setUpdIp(courseExam.getUpdIp());

		if (courseExam.getExamExampleSortOrders() != null) {

			List<UnivCourseExamExampleVO> listCourseExamExample = new ArrayList<UnivCourseExamExampleVO>();
			for (int index = 0; index < courseExam.getExamExampleSortOrders().length; index++) {
				UnivCourseExamExampleVO example = new UnivCourseExamExampleVO();

				example.setSortOrder(courseExam.getExamExampleSortOrders()[index]);
				example.setCorrectYn(courseExam.getExamExampleCorrectYns()[index]);

				/** TODO : 코드 */
				if ("EXAM_ITEM_TYPE::003".equals(courseExam.getExamItemTypeCd())) {
					example.setExamItemExampleTitle(index == 0 ? "O" : "X");
				} else {
					example.setExamItemExampleTitle(courseExam.getExamExampleTitles()[index]);
				}

				if (courseExam.getExamExampleFilePaths() != null) {
					if (StringUtil.isNotEmpty(courseExam.getExamExampleFilePaths()[index])) {
						example.setExamFileTypeCd(courseExam.getExamExampleFileTypeCds()[index]);
						example.setFilePath(courseExam.getExamExampleFilePaths()[index]);
						example.setFilePathType(courseExam.getExamExampleFilePathTypes()[index]);
					} else {
						example.setExamFileTypeCd("");
						example.setFilePath("");
						example.setFilePathType("");
					}
				}

				example.setRegMemberSeq(courseExam.getRegMemberSeq());
				example.setRegIp(courseExam.getRegIp());
				example.setUpdMemberSeq(courseExam.getUpdMemberSeq());
				example.setUpdIp(courseExam.getUpdIp());
				listCourseExamExample.add(example);
			}
			if (!listCourseExamExample.isEmpty()) {
				courseExamItem.setListCourseExamExample(listCourseExamExample);
			}
		}
		listCourseExamItem.add(courseExamItem);
		courseExam.setListCourseExamItem(listCourseExamItem);

		courseExamService.insertExam(courseExam);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 시험문제 저장 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/item/insert.do")
	public ModelAndView insertItem(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamVO courseExam) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExam);

		UnivCourseExamItemVO courseExamItem = new UnivCourseExamItemVO();

		courseExamItem.setExamSeq(courseExam.getExamSeq());
		courseExamItem.setExamItemTitle(courseExam.getExamItemTitle());
		courseExamItem.setDescription(courseExam.getExamItemDescription());
		courseExamItem.setComment(courseExam.getExamItemComment());
		courseExamItem.setExamItemTypeCd(courseExam.getExamItemTypeCd());
		courseExamItem.setExamItemDifficultyCd(courseExam.getExamItemDifficultyCd());
		courseExamItem.setExamItemAlignCd(courseExam.getExamItemAlignCd());

		if (StringUtil.isNotEmpty(courseExam.getExamItemFilePath())) {
			courseExamItem.setExamFileTypeCd(courseExam.getExamItemFileTypeCd());
			courseExamItem.setFilePath(courseExam.getExamItemFilePath());
			courseExamItem.setFilePathType(courseExam.getExamItemFilePathType());
		}

		courseExamItem.setSortOrder(courseExam.getExamItemSortOrder());
		courseExamItem.setCorrectAnswer(courseExam.getCorrectAnswer());
		courseExamItem.setSimilarAnswer(courseExam.getSimilarAnswer());
		courseExamItem.setProfMemberSeq(courseExam.getProfMemberSeq());
		courseExamItem.setExamItemScore(courseExam.getExamItemScore());
		courseExamItem.setRegMemberSeq(courseExam.getRegMemberSeq());
		courseExamItem.setRegIp(courseExam.getRegIp());
		courseExamItem.setUpdMemberSeq(courseExam.getUpdMemberSeq());
		courseExamItem.setUpdIp(courseExam.getUpdIp());

		if (courseExam.getExamExampleSortOrders() != null) {

			List<UnivCourseExamExampleVO> listCourseExamExample = new ArrayList<UnivCourseExamExampleVO>();
			for (int index = 0; index < courseExam.getExamExampleSortOrders().length; index++) {
				UnivCourseExamExampleVO example = new UnivCourseExamExampleVO();
				example.setSortOrder(courseExam.getExamExampleSortOrders()[index]);
				example.setCorrectYn(courseExam.getExamExampleCorrectYns()[index]);
				/** TODO : 코드 */
				if ("EXAM_ITEM_TYPE::003".equals(courseExam.getExamItemTypeCd())) {
					example.setExamItemExampleTitle(index == 0 ? "O" : "X");
				} else {
					example.setExamItemExampleTitle(courseExam.getExamExampleTitles()[index]);
				}

				if (courseExam.getExamExampleFilePaths() != null) {
					example.setExamFileTypeCd(courseExam.getExamExampleFileTypeCds()[index]);
					example.setFilePath(courseExam.getExamExampleFilePaths()[index]);
					example.setFilePathType(courseExam.getExamExampleFilePathTypes()[index]);
				}

				example.setRegMemberSeq(courseExam.getRegMemberSeq());
				example.setRegIp(courseExam.getRegIp());
				example.setUpdMemberSeq(courseExam.getUpdMemberSeq());
				example.setUpdIp(courseExam.getUpdIp());
				listCourseExamExample.add(example);
			}
			if (!listCourseExamExample.isEmpty()) {
				courseExamItem.setListCourseExamExample(listCourseExamExample);
			}
		}

		courseExamItemService.insertExamItem(courseExamItem);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 시험문제 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamVO courseExam) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExam);

		if (StringUtil.isEmpty(courseExam.getOpenYn())) {
			courseExam.setOpenYn("N");
		}

		courseExamService.updateExam(courseExam);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 시험문제 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamVO courseExam) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExam);

		UnivCourseExamItemVO courseExamItem = new UnivCourseExamItemVO();
		List<UnivCourseExamItemVO> listCourseExamItem = new ArrayList<UnivCourseExamItemVO>();
		List<UnivCourseExamExampleVO> listCourseExamExample = new ArrayList<UnivCourseExamExampleVO>();

		courseExamItem.setExamSeq(courseExam.getExamSeq());
		courseExamItem.setExamItemSeq(courseExam.getExamItemSeq());
		courseExamItem.setUpdMemberSeq(courseExam.getUpdMemberSeq());
		courseExamItem.setUpdIp(courseExam.getUpdIp());

		if (courseExam.getExamExampleSeqs() != null) {
			for (int i = 0; i < courseExam.getExamExampleSeqs().length; i++) {
				UnivCourseExamExampleVO example = new UnivCourseExamExampleVO();
				example.setExamExampleSeq(courseExam.getExamExampleSeqs()[i]);
				example.setUpdMemberSeq(courseExam.getUpdMemberSeq());
				example.setUpdIp(courseExam.getUpdIp());
				listCourseExamExample.add(example);
			}
		}
		if (!listCourseExamExample.isEmpty()) {
			courseExamItem.setListCourseExamExample(listCourseExamExample);
		}
		listCourseExamItem.add(courseExamItem);
		courseExam.setListCourseExamItem(listCourseExamItem);

		courseExamService.deleteExam(courseExam);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 문제문항 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseExamItem
	 * @param courseExam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/item/edit.do")
	public ModelAndView editItem(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamItemVO courseExamItem, UIUnivCourseExamVO courseExam)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detailExam", courseExamService.getDetail(courseExam));
		mav.addObject("detail", courseExamItemService.getDetail(courseExamItem));

		mav.setViewName("/univ/exam/editCourseExamItem");
		return mav;
	}

	/**
	 * 문제문항 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/item/update.do")
	public ModelAndView updateItem(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamVO courseExam) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExam);

		UnivCourseExamVO exam = null;
		UnivCourseExamItemVO courseExamItem = new UnivCourseExamItemVO();

		if (StringUtil.isNotEmpty(courseExam.getCourseMasterSeq())) {
			exam = new UnivCourseExamVO();
			exam.setExamSeq(courseExam.getExamSeq());
			exam.setCourseMasterSeq(courseExam.getCourseMasterSeq());
			exam.setGroupKey(courseExam.getGroupKey());
			exam.setExamTitle(courseExam.getExamItemTitle());
			exam.setUseYn(courseExam.getUseYn());
			if (StringUtil.isEmpty(courseExam.getOpenYn())) {
				courseExam.setOpenYn("N");
			}
			exam.setOpenYn(courseExam.getOpenYn());
			exam.setRegMemberSeq(courseExam.getRegMemberSeq());
			exam.setRegIp(courseExam.getRegIp());
			exam.setUpdMemberSeq(courseExam.getUpdMemberSeq());
			exam.setUpdIp(courseExam.getUpdIp());
		}

		courseExamItem.setExamSeq(courseExam.getExamSeq());
		courseExamItem.setExamItemSeq(courseExam.getExamItemSeq());
		courseExamItem.setExamItemTitle(courseExam.getExamItemTitle());
		courseExamItem.setDescription(courseExam.getExamItemDescription());
		courseExamItem.setComment(courseExam.getExamItemComment());
		courseExamItem.setExamItemTypeCd(courseExam.getExamItemTypeCd());
		courseExamItem.setExamItemDifficultyCd(courseExam.getExamItemDifficultyCd());
		courseExamItem.setExamItemAlignCd(courseExam.getExamItemAlignCd());
		courseExamItem.setExamItemExampleCount(courseExam.getExamItemExampleCount());

		if (StringUtil.isNotEmpty(courseExam.getExamItemFilePath())) {
			courseExamItem.setExamFileTypeCd(courseExam.getExamItemFileTypeCd());
			courseExamItem.setFilePath(courseExam.getExamItemFilePath());
			courseExamItem.setFilePathType(courseExam.getExamItemFilePathType());
		} else {
			courseExamItem.setExamFileTypeCd("");
			courseExamItem.setFilePath("");
			courseExamItem.setFilePathType("");
		}

		courseExamItem.setSortOrder(courseExam.getExamItemSortOrder());
		courseExamItem.setCorrectAnswer(courseExam.getCorrectAnswer());
		courseExamItem.setSimilarAnswer(courseExam.getSimilarAnswer());
		courseExamItem.setProfMemberSeq(courseExam.getProfMemberSeq());
		courseExamItem.setExamItemScore(courseExam.getExamItemScore());
		courseExamItem.setRegMemberSeq(courseExam.getRegMemberSeq());
		courseExamItem.setRegIp(courseExam.getRegIp());
		courseExamItem.setUpdMemberSeq(courseExam.getUpdMemberSeq());
		courseExamItem.setUpdIp(courseExam.getUpdIp());

		// 보기 추가 및 삭제 등 변경 일어났을 때 처리 하기 위한 설정값
		int examTitlesLength = courseExam.getExamExampleTitles().length;

		if (courseExam.getExamExampleSortOrders() != null) {
			List<UnivCourseExamExampleVO> listCourseExamExample = new ArrayList<UnivCourseExamExampleVO>();
			for (int index = 0; index < courseExam.getExamExampleSortOrders().length; index++) {
				UnivCourseExamExampleVO example = new UnivCourseExamExampleVO();
				example.setSortOrder(courseExam.getExamExampleSortOrders()[index]);
				example.setCorrectYn(courseExam.getExamExampleCorrectYns()[index]);
				example.setExamExampleSeq(courseExam.getExamExampleSeqs()[index]);
				example.setExamItemSeq(courseExam.getExamItemSeq());

				if (index < examTitlesLength) {
					/** TODO : 코드 */
					if ("EXAM_ITEM_TYPE::003".equals(courseExam.getExamItemTypeCd())) {
						example.setExamItemExampleTitle(index == 0 ? "O" : "X");
					} else {
						example.setExamItemExampleTitle(courseExam.getExamExampleTitles()[index]);
					}
				}

				if (courseExam.getExamExampleFilePaths() != null) {
					if (StringUtil.isNotEmpty(courseExam.getExamExampleFilePaths()[index])) {
						example.setExamFileTypeCd(courseExam.getExamExampleFileTypeCds()[index]);
						example.setFilePath(courseExam.getExamExampleFilePaths()[index]);
						example.setFilePathType(courseExam.getExamExampleFilePathTypes()[index]);
					} else {
						example.setExamFileTypeCd("");
						example.setFilePath("");
						example.setFilePathType("");
					}
				}

				example.setRegMemberSeq(courseExam.getRegMemberSeq());
				example.setRegIp(courseExam.getRegIp());
				example.setUpdMemberSeq(courseExam.getUpdMemberSeq());
				example.setUpdIp(courseExam.getUpdIp());
				listCourseExamExample.add(example);
			}
			if (!listCourseExamExample.isEmpty()) {
				courseExamItem.setListCourseExamExample(listCourseExamExample);
			}
		}

		courseExamItemService.updateExamItem(courseExamItem, exam);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 문제문항 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exam/item/delete.do")
	public ModelAndView deleteItem(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamVO courseExam) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExam);

		UnivCourseExamItemVO courseExamItem = new UnivCourseExamItemVO();
		List<UnivCourseExamExampleVO> listCourseExamExample = new ArrayList<UnivCourseExamExampleVO>();

		courseExamItem.setExamSeq(courseExam.getExamSeq());
		courseExamItem.setExamItemSeq(courseExam.getExamItemSeq());
		courseExamItem.setUpdMemberSeq(courseExam.getUpdMemberSeq());
		courseExamItem.setUpdIp(courseExam.getUpdIp());

		if (courseExam.getExamExampleSeqs() != null) {
			for (int i = 0; i < courseExam.getExamExampleSeqs().length; i++) {
				UnivCourseExamExampleVO example = new UnivCourseExamExampleVO();
				example.setExamExampleSeq(courseExam.getExamExampleSeqs()[i]);
				example.setUpdMemberSeq(courseExam.getUpdMemberSeq());
				example.setUpdIp(courseExam.getUpdIp());
				listCourseExamExample.add(example);
			}
		}
		if (!listCourseExamExample.isEmpty()) {
			courseExamItem.setListCourseExamExample(listCourseExamExample);
		}
		courseExamItemService.deleteExamItem(courseExamItem);

		mav.setViewName("/common/save");
		return mav;
	}

}
