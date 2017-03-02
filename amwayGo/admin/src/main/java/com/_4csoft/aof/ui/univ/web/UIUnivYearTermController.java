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
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivYearTermVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivYearTermCondition;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivYearTermVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivYearTermController.java
 * @Title : 년도학기
 * @date : 2014. 2. 18.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivYearTermController extends BaseController {

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	/**
	 * 년도 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/yearterm/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivYearTermCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=0", "perPage=0", "orderby=0");

		// 시스템에 설정된 년도학기
		MemberVO ssMember = SessionUtil.getMember(req);

		UIUnivYearTermVO yearTermVO = new UIUnivYearTermVO();
		if (StringUtil.isEmpty(condition.getSrchYearTerm())) {
			UnivYearTermVO univYearTermVO = (UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm");
			yearTermVO.setYearTerm(univYearTermVO.getYearTerm());
			condition.setSrchYearTerm(univYearTermVO.getYearTerm());
		} else {
			yearTermVO.setYearTerm(condition.getSrchYearTerm());
		}

		// 초기 학기 데이터가 없을 경우 기본 4학기를 생성한다.(솔루션 정책)
		univYearTermService.insertDefaultYearTerm(yearTermVO);

		mav.addObject("detail", univYearTermService.getDetailYearTerm(yearTermVO));
		// 검색 조건의 년도학기
		mav.addObject("yearTerms", univYearTermService.getListYearTermAll());

		mav.addObject("condition", condition);

		mav.setViewName("/univ/yearterm/listYearTerm");
		return mav;
	}

	/**
	 * 년도학기 기본값 관리 신규등록/수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/yearterm/save.do")
	public ModelAndView save(HttpServletRequest req, HttpServletResponse res, UIUnivYearTermVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		/*vo.setOpenAdminDate(DateUtil.convertStartDate(vo.getOpenAdminDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		vo.setOpenProfDate(DateUtil.convertStartDate(vo.getOpenProfDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		vo.setOpenStudentDate(DateUtil.convertStartDate(vo.getOpenStudentDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		vo.setStudyStartDate(DateUtil.convertStartDate(vo.getStudyStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		vo.setStudyEndDate(DateUtil.convertEndDate(vo.getStudyEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));

		vo.setPlanRegStartDtime(DateUtil.convertStartDate(vo.getPlanRegStartDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
				Constants.FORMAT_TIMEZONE));
		vo.setPlanRegEndDtime(DateUtil.convertEndDate(vo.getPlanRegEndDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));

		vo.setMiddleExamUpdStartDtime(DateUtil.convertStartDate(vo.getMiddleExamUpdStartDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
				Constants.FORMAT_TIMEZONE));
		vo.setMiddleExamUpdEndDtime(DateUtil.convertEndDate(vo.getMiddleExamUpdEndDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
				Constants.FORMAT_TIMEZONE));

		vo.setFinalExamUpdStartDtime(DateUtil.convertStartDate(vo.getFinalExamUpdStartDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
				Constants.FORMAT_TIMEZONE));
		vo.setFinalExamUpdEndDtime(DateUtil.convertEndDate(vo.getFinalExamUpdEndDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
				Constants.FORMAT_TIMEZONE));

		vo.setGradeMakeStartDtime(DateUtil.convertStartDate(vo.getGradeMakeStartDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
				Constants.FORMAT_TIMEZONE));
		vo.setGradeMakeEndDtime(DateUtil.convertEndDate(vo.getGradeMakeEndDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
				Constants.FORMAT_TIMEZONE));*/

		if (univYearTermService.countYearTerm(vo) > 0) {
			univYearTermService.updateYearTerm(vo);
		} else {
			univYearTermService.insertYearTerm(vo);
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 학습일자 중복 검사 json
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/yearterm/duplicate.do")
	public ModelAndView duplicate(HttpServletRequest req, HttpServletResponse res, UIUnivYearTermVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		vo.setOpenAdminDate(DateUtil.convertStartDate(vo.getOpenAdminDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		vo.setOpenProfDate(DateUtil.convertStartDate(vo.getOpenProfDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		vo.setOpenStudentDate(DateUtil.convertStartDate(vo.getOpenStudentDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		/** TODO : 코드 */
		String[] openType = { "admin", "prof", "user" };

		for (int i = 0; i < openType.length; i++) {
			vo.setOpenType(openType[i]);
			int duplicated = univYearTermService.getDuplicateOpenType(vo);

			if (duplicated < 1) {
				mav.addObject("duplicated", openType[i]);
				break;
			}
		}

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 강의실 입장 제한 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/limit/list.do")
	public ModelAndView listCourseActiveLimit(HttpServletRequest req, HttpServletResponse res, UIUnivYearTermCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 기본값 검색 시작년도학기 셋팅
		if (StringUtil.isEmpty(condition.getSrchStartYearTerm())) {
			condition.setSrchStartYearTerm(DateUtil.getTodayYear() + "10");
		}

		// 기본값 검색 종료년도학기 셋팅
		if (StringUtil.isEmpty(condition.getSrchEndYearTerm())) {
			condition.setSrchEndYearTerm(DateUtil.getTodayYear() + "21");
		}
		/** TODO : 코드 */
		mav.addObject("term1st", "10");// 1학기
		mav.addObject("term4th", "21");// 겨울학기
		mav.addObject("itemList", univYearTermService.getCourseActiveLimitList(condition));

		mav.addObject("condition", condition);

		mav.setViewName("/univ/limit/listCourseActiveLimit");
		return mav;
	}

	/**
	 * 강의실 입장 제한변경 처리
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/limit/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UIUnivYearTermVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		List<UnivYearTermVO> uniYearTerms = new ArrayList<UnivYearTermVO>();
		for (int i = 0; i < vo.getYearTerms().length; i++) {
			UIUnivYearTermVO o = new UIUnivYearTermVO();
			o.setYearTerm(vo.getYearTerms()[i]);
			o.setReviewOpenYn(vo.getReviewOpenYns()[i]);
			o.copyAudit(vo);
			uniYearTerms.add(o);
		}

		if (uniYearTerms.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univYearTermService.updatelistYearTerm(uniYearTerms));
		}

		mav.setViewName("/common/save");
		return mav;
	}
}
