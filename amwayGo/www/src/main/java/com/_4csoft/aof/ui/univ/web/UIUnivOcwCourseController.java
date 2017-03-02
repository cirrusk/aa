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
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivOcwCourseVO;
import com._4csoft.aof.ui.univ.vo.UIUnivOcwEvaluateVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivOcwCourseCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCategoryRS;
import com._4csoft.aof.univ.service.UnivCategoryService;
import com._4csoft.aof.univ.service.UnivOcwContentsOrganizationService;
import com._4csoft.aof.univ.service.UnivOcwCourseService;
import com._4csoft.aof.univ.service.UnivOcwEvaluateService;
import com._4csoft.aof.univ.vo.UnivCategoryVO;
import com._4csoft.aof.univ.vo.UnivOcwContentsOrganizationVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivOcwController.java
 * @Title : OCW 메인
 * @date : 2014. 6. 23.
 * @author : 김현우
 * @descrption : OCW 메인
 */
@Controller
public class UIUnivOcwCourseController extends BaseController {

	@Resource (name = "UnivCategoryService")
	private UnivCategoryService categoryService;

	@Resource (name = "UnivOcwCourseService")
	private UnivOcwCourseService ocwCourseService;

	@Resource (name = "UnivOcwEvaluateService")
	private UnivOcwEvaluateService ocwEvaluateService;

	@Resource (name = "UnivOcwContentsOrganizationService")
	private UnivOcwContentsOrganizationService ocwContentsOrganizationService;

	/**
	 * 과정목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCourseCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=-1");

		// OCW 리스트 최초 접근시
		if (StringUtil.isEmpty(condition.getSrchGroupOrder())) {

			UnivCategoryVO cavo = new UnivCategoryVO();
			cavo.setCategorySeq((Long)req.getAttribute("categoryOcwDepth2Seq"));
			UIUnivCategoryRS rs = (UIUnivCategoryRS)categoryService.getDetail(cavo);
			condition.setSrchGroupOrder(rs.getCategory().getGroupOrder());
		}

		mav.addObject("paginate", ocwCourseService.getListUsrOcwCourse(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/ocw/course/listOcwCourse");

		return mav;
	}

	/**
	 * 과정 상세화면
	 * 
	 * @param req
	 * @param res
	 * @param ocwCourse
	 * @param condition
	 * @return
	 */
	@RequestMapping ("/univ/ocw/course/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCourseVO ocwCourse, UnivOcwContentsOrganizationVO ocwContents,
			UIUnivOcwCourseCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.addObject("condition", condition);

		mav.addObject("detail", ocwCourseService.getDetailOcwCourse(ocwCourse));
		mav.addObject("scoreAvg", ocwEvaluateService.getScoreAvg(ocwCourse.getOcwCourseActiveSeq()));
		mav.addObject("list", ocwContentsOrganizationService.getListOcwContentsOrganization(ocwContents));

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		if (ssMember != null) {
			UIUnivOcwEvaluateVO vo = new UIUnivOcwEvaluateVO();
			vo.setOcwCourseActiveSeq(ocwCourse.getOcwCourseActiveSeq());
			vo.setMemberSeq(ssMember.getMemberSeq());
			mav.addObject("myEvaluate", ocwEvaluateService.getDetailOcwEvaluate(vo));
		}

		mav.setViewName("/univ/ocw/course/detailOcwCourse");

		return mav;
	}

	/**
	 * 강의 상세
	 * 
	 * @param req
	 * @param res
	 * @param ocwCourse
	 * @param ocwContents
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/contents/item/detail.do")
	public ModelAndView detailItem(HttpServletRequest req, HttpServletResponse res, UIUnivOcwCourseVO ocwCourse, UnivOcwContentsOrganizationVO ocwContents,
			UIUnivOcwCourseCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.addObject("detail", ocwCourseService.getDetailOcwCourse(ocwCourse));
		mav.addObject("list", ocwContentsOrganizationService.getListOcwContentsOrganization(ocwContents));
		mav.addObject("detailContents", ocwContentsOrganizationService.getDetailUsrOcwContentsOrganization(ocwContents));

		mav.addObject("condition", condition);

		mav.setViewName("/univ/ocw/course/detailContentsOcwCourse");
		return mav;
	}

	/**
	 * 과정 평점 등록
	 * 
	 * @param req
	 * @param res
	 * @param ocwEvaluate
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/ocw/course/evaluate/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivOcwEvaluateVO ocwEvaluate) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, ocwEvaluate);
		ocwEvaluate.setMemberSeq(ocwEvaluate.getRegMemberSeq());
		ocwEvaluateService.insertOcwEvaluate(ocwEvaluate);

		mav.setViewName("/common/save");
		return mav;
	}
}
