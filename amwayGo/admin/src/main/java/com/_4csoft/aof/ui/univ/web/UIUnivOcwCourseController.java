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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.lcms.service.LcmsContentsOrganizationService;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.lcms.vo.UILcmsContentsOrganizationVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivOcwContentsOrganizationVO;
import com._4csoft.aof.ui.univ.vo.UIUnivOcwCourseVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivOcwCourseCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivOcwContentsOrganizationService;
import com._4csoft.aof.univ.service.UnivOcwCourseService;
import com._4csoft.aof.univ.service.UnivOcwEvaluateService;

/**
 * 
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivOcwCourseController.java
 * @Title : ocw 과목
 * @date : 2014. 5. 8.
 * @author : 김현우
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivOcwCourseController extends BaseController {

	@Resource (name = "UnivOcwCourseService")
	private UnivOcwCourseService ocwCourseService;

	@Resource (name = "UnivOcwEvaluateService")
	private UnivOcwEvaluateService ocwEvaluateService;

	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService elementService;

	@Resource (name = "UnivOcwContentsOrganizationService")
	private UnivOcwContentsOrganizationService ocwContentsOrganizationService;

	@Resource (name = "LcmsContentsOrganizationService")
	private LcmsContentsOrganizationService organizationService;

	/**
	 * ocw 과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCourseCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 관리자 이외 사용자는 담당 과목만 볼수 있다.
		/** TODO : 코드 */
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		if (!"ADM".equals(ssMember.getCurrentRoleCfString())) {
			condition.setSrchMemberSeq(ssMember.getMemberSeq());
		}

		// 학위 과목
		/** TODO : 코드 */
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::OCW");
		if (StringUtil.isEmpty(condition.getSrchCourseActiveStatusCd())) {
			condition.setSrchCourseActiveStatusCd("COURSE_ACTIVE_STATUS::OPEN");
		}

		mav.addObject("paginate", ocwCourseService.getListOcwCourse(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/ocwCourse/listOcwCourse");
		return mav;
	}

	/**
	 * ocw 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param ocwCourse
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCourseVO ocwCourse, UIUnivOcwCourseCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", ocwCourseService.getDetailOcwCourse(ocwCourse));
		mav.addObject("scoreAvg", ocwEvaluateService.getScoreAvg(ocwCourse.getOcwCourseActiveSeq()));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/ocwCourse/detailOcwCourse");
		return mav;
	}

	/**
	 * ocw 과목 신규등록화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCourseCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);

		mav.setViewName("/univ/ocwCourse/createOcwCourse");
		return mav;
	}

	/**
	 * ocw 과목 신규등록화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCourseVO ocwCourse, UIUnivOcwCourseCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", ocwCourseService.getDetailOcwCourse(ocwCourse));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/ocwCourse/editOcwCourse");
		return mav;
	}

	/**
	 * ocw 과목 신규등록
	 * 
	 * @param req
	 * @param res
	 * @param ocwCourseVO
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCourseVO ocwCourse) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, ocwCourse);
		emptyValue(ocwCourse, "limitOpenYn=N", "count=0");

		ocwCourse.setStudyStartDate(DateUtil.convertStartDate(ocwCourse.getStudyStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
				Constants.FORMAT_TIMEZONE));
		if (StringUtil.isNotEmpty(ocwCourse.getStudyEndDate())) {
			ocwCourse.setStudyEndDate(DateUtil.convertStartDate(ocwCourse.getStudyEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}
		ocwCourseService.insertOcwCourse(ocwCourse);

		mav.addObject("result", ocwCourse.getOcwCourseActiveSeq() + "," + ocwCourse.getCourseActiveSeq());
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * ocw 과목 수정
	 * 
	 * @param req
	 * @param res
	 * @param ocwCourseVO
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCourseVO ocwCourse) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, ocwCourse);
		emptyValue(ocwCourse, "limitOpenYn=N", "count=0");

		ocwCourse.setStudyStartDate(DateUtil.convertStartDate(ocwCourse.getStudyStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
				Constants.FORMAT_TIMEZONE));
		if (StringUtil.isNotEmpty(ocwCourse.getStudyEndDate())) {
			ocwCourse.setStudyEndDate(DateUtil.convertStartDate(ocwCourse.getStudyEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}
		ocwCourseService.updateOcwCourse(ocwCourse);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * ocw 과목 구성정보 수정화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = { "/univ/ocw/course/organization/edit.do", "/univ/ocw/course/organization/mapper/edit.do" })
	public ModelAndView editOrganization(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveElementVO activeElement,
			UIUnivOcwCourseVO ocwCourse, UIUnivOcwCourseCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", ocwCourseService.getDetailOcwCourse(ocwCourse));

		activeElement.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		if ("/univ/ocw/course/organization/edit.do".equals(req.getServletPath())) {
			mav.addObject("list", elementService.getList(activeElement));
		} else {
			UILcmsContentsOrganizationVO org = new UILcmsContentsOrganizationVO();
			org.setContentsSeq(activeElement.getContentsSeq());

			if (elementService.countList(activeElement) > organizationService.getListBrowseContents(org).size()) {
				mav.addObject("list", elementService.getGroupElementMappingList(activeElement));
			} else {
				mav.addObject("list", elementService.getGroupMappingList(activeElement));
			}
		}

		mav.addObject("condition", condition);

		mav.setViewName("/univ/ocwCourse/editOcwCourseOraganization");

		return mav;
	}

	/**
	 * ocw 차시 학습요소 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param ocwCourse
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/organization/contents/edit/ajax.do")
	public ModelAndView editOrganizationContents(HttpServletRequest req, HttpServletResponse res, UIUnivOcwContentsOrganizationVO contentsOrga)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		mav.addObject("detail", ocwContentsOrganizationService.getDetailOcwContentsOrganization(contentsOrga));

		mav.setViewName("/univ/ocwCourse/editOcwContentsOrganizationAjax");
		return mav;
	}

	/**
	 * ocw 차시 학습요소 상세정보 수정
	 * 
	 * @param req
	 * @param res
	 * @param ocwCourseVO
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/organization/contents/update.do")
	public ModelAndView updateOrganizationContents(HttpServletRequest req, HttpServletResponse res, UIUnivOcwContentsOrganizationVO contentsOrga)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, contentsOrga);

		if (StringUtil.isEmpty(contentsOrga.getOcwOrganizaionSeq())) {
			// 신규등록
			ocwContentsOrganizationService.insertOcwContentsOrganization(contentsOrga);
		} else {
			// 수정
			ocwContentsOrganizationService.updateOcwContentsOrganization(contentsOrga);
		}

		mav.setViewName("/common/save");
		return mav;
	}

}