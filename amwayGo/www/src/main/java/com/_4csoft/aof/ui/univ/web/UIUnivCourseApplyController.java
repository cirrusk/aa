/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.util.Calendar;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivYearTermVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveRS;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseApplyService;
import com._4csoft.aof.univ.service.UnivYearTermService;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseApplyController.java
 * @date : 2014. 3. 3.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseApplyController extends BaseController {
	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyService courseApplyService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService univCourseActiveService;

	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyService univCourseApplyService;

	/**
	 * 마이페이지 > 학위과정 > 수강과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/mypage/course/apply/list.do")
	public ModelAndView listMypageDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		condition.setSrchApplyType("ING"); // 수강중인과목
		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::DEGREE");
		// 현재년도학기 구하기
		UIUnivYearTermVO vo = (UIUnivYearTermVO)univYearTermService.getSystemYearTerm(SessionUtil.getMember(req).getCurrentRoleCfString());
		condition.setSrchYearTerm(vo.getYearTerm());

		// 년도학기 정보 가져오기
		mav.addObject("nowYearTerm", vo);
		// 검색 조건 년도학기 정보
		mav.addObject("srchYearTerm", univYearTermService.getDetailYearTerm(vo));
		mav.addObject("paginate", courseApplyService.getListMyCourse(condition));
		mav.addObject("condition", condition);
		// 검색 조건의 년도학기 select box
		mav.addObject("yearTerms", univYearTermService.getListYearTermAll());

		mav.setViewName("/mypage/courseApply/listCourseApply");

		return mav;
	}

	/**
	 * 마이페이지 > 학위과정 > 수강과목 대기목록 화면 ajax
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/mypage/course/apply/list/ajax.do")
	public ModelAndView listMypageDegreeAjax(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		condition.setSrchApplyType("WAIT"); // 대기중인과목
		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::DEGREE");
		// 현재년도학기 구하기
		UIUnivYearTermVO vo = (UIUnivYearTermVO)univYearTermService.getSystemYearTerm(SessionUtil.getMember(req).getCurrentRoleCfString());
		if (StringUtil.isEmpty(condition.getSrchYearTerm())) {
			condition.setSrchYearTerm(vo.getYearTerm());
		}

		vo.setYearTerm(condition.getSrchYearTerm());
		// 검색 조건 년도학기 정보
		mav.addObject("srchYearTerm", univYearTermService.getDetailYearTerm(vo));
		mav.addObject("paginate", courseApplyService.getListMyCourse(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/mypage/courseApply/listCourseApplyAjax");

		return mav;
	}

	/**
	 * 마이페이지 > 학위과정 > 복습과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/mypage/course/apply/review/list.do")
	public ModelAndView listMypageDegreeReview(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		condition.setSrchApplyType("REVIEW"); // 복습과목
		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::DEGREE");

		// 현재년도학기 구하기
		UIUnivYearTermVO vo = (UIUnivYearTermVO)univYearTermService.getSystemYearTerm(SessionUtil.getMember(req).getCurrentRoleCfString());
		if (StringUtil.isEmpty(condition.getSrchYearTerm())) {
			condition.setSrchYearTerm(vo.getYearTerm());
		}

		// 년도학기 정보 가져오기
		mav.addObject("nowYearTerm", vo);
		// 검색 년도학기 정보 가져오기
		vo.setYearTerm(condition.getSrchYearTerm());
		mav.addObject("srchYearTerm", univYearTermService.getDetailYearTerm(vo));
		// 검색 조건의 년도학기 select box
		mav.addObject("yearTerms", univYearTermService.getListYearTermAll());
		mav.addObject("paginate", courseApplyService.getListMyCourse(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/mypage/courseApply/listCourseApplyReview");

		return mav;
	}

	/**
	 * 마이페이지 > 비학위과정 > 수강과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/mypage/course/apply/non/list.do")
	public ModelAndView listMypageNonDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		condition.setSrchApplyType("ING"); // 수강중인과목
		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::NONDEGREE");
		condition.setSrchYear(Integer.toString(DateUtil.getTodayYear()));

		// 현재년도학기 구하기
		UIUnivYearTermVO vo = (UIUnivYearTermVO)univYearTermService.getSystemYearTerm(SessionUtil.getMember(req).getCurrentRoleCfString());
		condition.setSrchYearTerm(vo.getYearTerm());

		// 년도학기 정보 가져오기
		mav.addObject("nowYearTerm", vo);

		mav.addObject("nowYear", Integer.toString(DateUtil.getTodayYear()));
		mav.addObject("paginate", courseApplyService.getListMyCourse(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/mypage/courseApply/listCourseApplyNon");
		return mav;
	}

	/**
	 * 마이페이지 > 비학위과정 > 수강과목 대기목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/mypage/course/apply/non/list/ajax.do")
	public ModelAndView listMypageNonDegreeAjax(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		condition.setSrchApplyType("WAIT"); // 대기중인과목
		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::NONDEGREE");

		mav.addObject("nowYear", Integer.toString(DateUtil.getTodayYear()));
		mav.addObject("paginate", courseApplyService.getListMyCourse(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/mypage/courseApply/listCourseApplyNonAjax");
		return mav;
	}

	/**
	 * 마이페이지 > 비학위과정 >복습과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/mypage/course/apply/non/review/list.do")
	public ModelAndView listMypageNonDegreeReview(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		condition.setSrchApplyType("REVIEW"); // 복습과목
		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::NONDEGREE");
		if (StringUtil.isEmpty(condition.getSrchYear())) {
			condition.setSrchYear(Integer.toString(DateUtil.getTodayYear()));
		}

		// 현재년도학기 구하기
		UIUnivYearTermVO vo = (UIUnivYearTermVO)univYearTermService.getSystemYearTerm(SessionUtil.getMember(req).getCurrentRoleCfString());
		condition.setSrchYearTerm(vo.getYearTerm());

		// 년도학기 정보 가져오기
		mav.addObject("nowYearTerm", vo);

		mav.addObject("paginate", courseApplyService.getListMyCourse(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/mypage/courseApply/listCourseApplyNonReview");

		return mav;
	}
	
	/**
	 * 마이페이지 > MOOC > 수강과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/mypage/course/apply/mooc/list.do")
	public ModelAndView listMypageMooc(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		condition.setSrchApplyType("ING"); // 수강중인과목
		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::MOOC");
		condition.setSrchYear(Integer.toString(DateUtil.getTodayYear()));

		// 현재년도학기 구하기
		UIUnivYearTermVO vo = (UIUnivYearTermVO)univYearTermService.getSystemYearTerm(SessionUtil.getMember(req).getCurrentRoleCfString());
		condition.setSrchYearTerm(vo.getYearTerm());

		// 년도학기 정보 가져오기
		mav.addObject("nowYearTerm", vo);

		mav.addObject("nowYear", Integer.toString(DateUtil.getTodayYear()));
		mav.addObject("paginate", courseApplyService.getListMyCourse(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/mypage/courseApply/listCourseApplyMooc");
		return mav;
	}

	/**
	 * 마이페이지 > MOOC > 수강과목 대기목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/mypage/course/apply/mooc/list/ajax.do")
	public ModelAndView listMypageMoocAjax(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		condition.setSrchApplyType("WAIT"); // 대기중인과목
		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::MOOC");

		mav.addObject("nowYear", Integer.toString(DateUtil.getTodayYear()));
		mav.addObject("paginate", courseApplyService.getListMyCourse(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/mypage/courseApply/listCourseApplyNonAjax");
		return mav;
	}

	/**
	 * 마이페이지 > 비학위과정 >복습과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/mypage/course/apply/mooc/review/list.do")
	public ModelAndView listMypageMoocReview(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		condition.setSrchApplyType("REVIEW"); // 복습과목
		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::MOOC");
		if (StringUtil.isEmpty(condition.getSrchYear())) {
			condition.setSrchYear(Integer.toString(DateUtil.getTodayYear()));
		}

		// 현재년도학기 구하기
		UIUnivYearTermVO vo = (UIUnivYearTermVO)univYearTermService.getSystemYearTerm(SessionUtil.getMember(req).getCurrentRoleCfString());
		condition.setSrchYearTerm(vo.getYearTerm());

		// 년도학기 정보 가져오기
		mav.addObject("nowYearTerm", vo);

		mav.addObject("paginate", courseApplyService.getListMyCourse(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/mypage/courseApply/listCourseApplyMoocReview");

		return mav;
	}

	/**
	 * 비학위 & MOOC 수강신청
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseApplyVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/course/apply/non/insert.do")
	public ModelAndView insertNon(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		UIUnivCourseActiveVO active = new UIUnivCourseActiveVO();
		active.setCourseActiveSeq(vo.getCourseActiveSeq());
		UIUnivCourseActiveRS rs = (UIUnivCourseActiveRS)univCourseActiveService.getDetailCourseActive(active);
		
		// 자동승인여부
		if("APPLY_TYPE::AUTO".equals(rs.getCourseActive().getApplyTypeCd())){
			vo.setApplyStatusCd("APPLY_STATUS::002");
			// 상시제
			if("COURSE_TYPE::ALWAYS".equals(rs.getCourseActive().getCourseTypeCd())){
				Calendar cal = Calendar.getInstance();
				cal.setTime(DateUtil.getToday());
				cal.add(Calendar.DATE, rs.getCourseActive().getStudyDay().intValue());
				
				vo.setStudyStartDate(DateUtil.getToday("yyyyMMdd000000"));
				vo.setStudyEndDate(DateUtil.getFormatString(cal.getTime(), "yyyyMMdd000000"));
				
				cal.add(Calendar.DATE, rs.getCourseActive().getResumeDay().intValue());
				vo.setResumeEndDate(DateUtil.getFormatString(cal.getTime(), "yyyyMMdd000000"));
				
			} else {
				vo.setStudyStartDate(rs.getCourseActive().getStudyStartDate());
				vo.setStudyEndDate(rs.getCourseActive().getStudyEndDate());
				vo.setResumeEndDate(rs.getCourseActive().getResumeEndDate());
			}
		} else {
			vo.setApplyStatusCd("APPLY_STATUS::001");
		}

		vo.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		courseApplyService.insertCourseApply(vo);
		
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 비학위 & MOOC 수강신청
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseApplyVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/course/apply/non/update.do")
	public ModelAndView updateNon(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		courseApplyService.updateCourseApply(vo);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 수료증 발급 팝업
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/certificate/popup.do")
	public ModelAndView getDetailCertificatePopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive,
			UIUnivCourseApplyVO courseApply) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 개설과목 셋팅
		courseActive.copyShortcut();
		mav.addObject("getDetail", univCourseActiveService.getDetailCourseActive(courseActive));

		mav.addObject("getDetailApply", univCourseApplyService.getDetail(courseApply));

		mav.setViewName("/mypage/courseApply/getDetailCertificatePopup");
		return mav;
	}

	/**
	 * 메인메뉴 정보용 ajax
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/menuinfo/ajax.do")
	public ModelAndView menuInfoAjax(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 현재년도학기 구하기
		UIUnivYearTermVO vo = (UIUnivYearTermVO)univYearTermService.getSystemYearTerm(SessionUtil.getMember(req).getCurrentRoleCfString());
		// 년도학기 정보 가져오기
		mav.addObject("menuNowYearTerm", vo);

		// 현재 강의 목록
		UIUnivCourseApplyCondition applyCondition = new UIUnivCourseApplyCondition();
		emptyValue(applyCondition, "currentPage=0");
		applyCondition.setSrchApplyType("ING"); // 수강중인과목
		applyCondition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		applyCondition.setSrchYearTerm(vo.getYearTerm());
		mav.addObject("menuApplyList", courseApplyService.getListMyCourse(applyCondition));

		mav.setViewName("/mypage/courseApply/menuInfoAjax");
		return mav;
	}

}
