/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.api;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.univ.dto.CourseApplyMemberDTO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseApplyRS;
import com._4csoft.aof.univ.service.UnivCourseApplyService;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.api
 * @File : UICourseApplyController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 23.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICourseApplyController extends UIBaseController {

	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyService univCourseApplyService;

	/**
	 * 수강신청자 조회 목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/applymember/list")
	public ModelAndView listApply(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		String resultCode = UIApiConstant._SUCCESS_CODE;
		checkSession(req);
		UIUnivCourseApplyCondition condition = new UIUnivCourseApplyCondition();

		requiredSession(req);

		condition.setSrchCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
		condition.setCurrentPage(Integer.parseInt(req.getParameter("currentPage")));
		condition.setPerPage(Integer.parseInt(req.getParameter("perPage")));

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 년도 학기 셋팅

		condition.setSrchApplyStatusCd("APPLY_STATUS::002");

		Paginate<ResultSet> paginate = univCourseApplyService.getListCourseApply(condition);

		int totalRowCount = 0;

		// List<CourseApplyMemberDTO> items = new ArrayList<CourseApplyMemberDTO>();
		List<CourseApplyMemberDTO> items = new ArrayList<CourseApplyMemberDTO>();

		if (paginate != null) {
			totalRowCount = paginate.getTotalCount();
			for (ResultSet rs : paginate.getItemList()) {
				UIUnivCourseApplyRS applyRS = (UIUnivCourseApplyRS)rs;
				CourseApplyMemberDTO dto = new CourseApplyMemberDTO();
				BeanUtils.copyProperties(dto, applyRS.getMember());
				BeanUtils.copyProperties(dto, applyRS.getApply());
				items.add(dto);
			}

		}
		mav.addObject("items", items);
		mav.addObject("totalRowCount", totalRowCount);
		mav.addObject("currentPage", condition.getCurrentPage());
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}
}
