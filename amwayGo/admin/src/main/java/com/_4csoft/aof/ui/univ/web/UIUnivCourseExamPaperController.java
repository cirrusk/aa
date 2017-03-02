/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamPaperElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseExamPaperCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseExamPaperRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseMasterRS;
import com._4csoft.aof.univ.service.UnivCourseActiveLecturerService;
import com._4csoft.aof.univ.service.UnivCourseExamItemService;
import com._4csoft.aof.univ.service.UnivCourseExamPaperElementService;
import com._4csoft.aof.univ.service.UnivCourseExamPaperService;
import com._4csoft.aof.univ.service.UnivCourseExamService;
import com._4csoft.aof.univ.service.UnivCourseMasterService;
import com._4csoft.aof.univ.vo.UnivCourseActiveLecturerVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseExamPaperController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 4.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseExamPaperController extends BaseController {

	@Resource (name = "UnivCourseExamPaperService")
	private UnivCourseExamPaperService courseExamPaperService;

	@Resource (name = "UnivCourseExamService")
	private UnivCourseExamService courseExamService;

	@Resource (name = "UnivCourseExamItemService")
	private UnivCourseExamItemService courseExamItemService;

	@Resource (name = "UnivCourseExamPaperElementService")
	private UnivCourseExamPaperElementService courseExamPaperElementService;

	@Resource (name = "UnivCourseActiveLecturerService")
	private UnivCourseActiveLecturerService univCourseActiveLecturerService;

	@Resource (name = "UnivCourseMasterService")
	private UnivCourseMasterService univCourseMasterService;

	/**
	 * 시험지 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperCondition condition) throws Exception {
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

		mav.addObject("paginate", courseExamPaperService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/examPaper/listCourseExamPaper");
		return mav;
	}

	/**
	 * 시험지 목록 화면 - popup
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/list/popup.do")
	public ModelAndView listIframe(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=5", "orderby=0");

		if (StringUtil.isEmpty(condition.getPopupFirstYn())) { // 최초검색시 값 셋팅
			UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
			String currentRoleCfString = ssMember.getCurrentRoleCfString();

			if (!"ADM".equals(currentRoleCfString) && !StringUtil.isEmpty(condition.getSrchCourseActiveSeq())) { // 관리자 롤그룹이 아닐시
				UnivCourseActiveLecturerVO vo = new UnivCourseActiveLecturerVO();
				vo.setCourseActiveSeq(condition.getSrchCourseActiveSeq());
				vo.setMemberSeq(ssMember.getMemberSeq());
				UnivCourseActiveLecturerVO lecVo = univCourseActiveLecturerService.getDetailCourseActiveLecturerByMember(vo);
				condition.setSrchProfSessionMemberSeq(lecVo.getProfMemberSeq());
				condition.setSrchProfMemberName(lecVo.getProfMemberName());
			}
			UIUnivCourseMasterVO masterVo = new UIUnivCourseMasterVO();
			masterVo.setCourseMasterSeq(condition.getSrchCourseMasterSeq());
			UIUnivCourseMasterRS rs = (UIUnivCourseMasterRS)univCourseMasterService.getDetailCourseMaster(masterVo);

			condition.setSrchCourseTitle(rs.getCourseMaster().getCourseTitle());
		}

		mav.addObject("paginate", courseExamPaperService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/examPaper/listCourseExamPaperPopup");
		return mav;
	}

	/**
	 * 시험지 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseExamPaper
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperVO courseExamPaper,
			UIUnivCourseExamPaperCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivCourseExamPaperRS detail = (UIUnivCourseExamPaperRS)courseExamPaperService.getDetail(courseExamPaper);

		if (detail != null) {
			mav.addObject("detail", detail);
			if ("Y".equals(detail.getCourseExamPaper().getRandomYn())) {

				mav.addObject("listExamItem", courseExamItemService.getListSingleAll(detail.getCourseExamPaper().getCourseMasterSeq()));

				Map<String, String> map = new HashMap<String, String>();
				if (detail.getCourseExamPaper().getRandomOption() != null) {
					String[] randomOption = detail.getCourseExamPaper().getRandomOption().split(",");
					if (randomOption != null) {
						for (String option : randomOption) {
							String[] pair = option.split("=");
							if (pair != null && pair.length == 2) {
								map.put(pair[0], pair[1]);
							}
						}
					}
				}
				mav.addObject("randomOption", map);
			} else {
				UIUnivCourseExamPaperElementVO courseExamPaperElement = new UIUnivCourseExamPaperElementVO();
				courseExamPaperElement.setExamPaperSeq(detail.getCourseExamPaper().getExamPaperSeq());
				mav.addObject("listElement", courseExamPaperElementService.getList(courseExamPaperElement));
			}
		}

		mav.addObject("condition", condition);

		mav.setViewName("/univ/examPaper/detailCourseExamPaper");
		return mav;
	}

	/**
	 * 시험지 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseExamPaper
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperVO courseExamPaper,
			UIUnivCourseExamPaperCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("courseExamPaper", courseExamPaper);
		mav.addObject("condition", condition);

		mav.setViewName("/univ/examPaper/createCourseExamPaper");
		return mav;
	}

	/**
	 * 시험지 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseExamPaper
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperVO courseExamPaper, UIUnivCourseExamPaperCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivCourseExamPaperRS detail = (UIUnivCourseExamPaperRS)courseExamPaperService.getDetail(courseExamPaper);

		if (detail != null) {
			mav.addObject("detail", detail);
			UIUnivCourseExamVO courseExam = new UIUnivCourseExamVO();
			courseExam.setCourseMasterSeq(detail.getCourseExamPaper().getCourseMasterSeq());
			mav.addObject("listGroupKey", courseExamService.getListGroupKey(courseExam));
		}
		mav.addObject("condition", condition);

		mav.setViewName("/univ/examPaper/editCourseExamPaper");
		return mav;
	}

	/**
	 * groupkey 목록
	 * 
	 * @param req
	 * @param res
	 * @param courseExam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/groupkeys/ajax.do")
	public ModelAndView groupkeys(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamVO courseExam) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("listGroupKey", courseExamService.getListGroupKey(courseExam));

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 시험지 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperVO courseExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExamPaper);

		if (StringUtil.isEmpty(courseExamPaper.getOpenYn())) {
			courseExamPaper.setOpenYn("N");
		}

		int result = courseExamPaperService.insertExamPaper(courseExamPaper);

		mav.addObject("result", "{\"success\":\"" + result + "\",\"examPaperSeq\":\"" + courseExamPaper.getExamPaperSeq() + "\"}");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 시험지 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperVO courseExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExamPaper);

		if (StringUtil.isEmpty(courseExamPaper.getOpenYn())) {
			courseExamPaper.setOpenYn("N");
		}

		courseExamPaperService.updateExamPaper(courseExamPaper);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 시험지 랜덤옵션 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/option/update.do")
	public ModelAndView updateOption(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperVO courseExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExamPaper);

		courseExamPaperService.updateExamPaperRandomOption(courseExamPaper);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 시험지 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperVO courseExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExamPaper);

		courseExamPaperService.deleteExamPaper(courseExamPaper);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 시험지 미리보기
	 * 
	 * @param req
	 * @param res
	 * @param courseExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/exampaper/preview/popup.do")
	public ModelAndView preview(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamPaperVO courseExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivCourseExamPaperRS detail = (UIUnivCourseExamPaperRS)courseExamPaperService.getDetail(courseExamPaper);

		if (detail != null) {
			mav.addObject("detailExamPaper", detail);
			mav.addObject("listExam", courseExamPaperService.listExam(detail.getCourseExamPaper(), HttpUtil.getParameter(req, "paperNumber", 1L)));
		}

		mav.setViewName("/univ/examPaper/previewCourseExamPaperPopup");
		return mav;
	}

}
