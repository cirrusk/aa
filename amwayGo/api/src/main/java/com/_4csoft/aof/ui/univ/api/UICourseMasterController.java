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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;
import com._4csoft.aof.ui.univ.dto.CourseMasterDTO;
import com._4csoft.aof.ui.univ.dto.CourseMasterListDTO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseMasterCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseMasterRS;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseMasterService;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.api
 * @File : UICourseMasterController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 16.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICourseMasterController extends UIBaseController {

	@Resource (name = "UnivCourseMasterService")
	private UnivCourseMasterService courseMasterService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	/**
	 * 학위 교과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseMasterCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/coursemaster/{categoryType}/list")
	public ModelAndView listCourseMaster(HttpServletRequest req, HttpServletResponse res, @PathVariable ("categoryType") String categoryType) throws Exception {
		ModelAndView mav = new ModelAndView();

		String resultCode = UIApiConstant._SUCCESS_CODE;

		UIUnivCourseMasterCondition condition = new UIUnivCourseMasterCondition();
		try {
			condition.setCurrentPage(Integer.parseInt(req.getParameter("currentPage")));
			condition.setPerPage(Integer.parseInt(req.getParameter("perPage")));
			condition.setSrchKey(HttpUtil.getParameter(req, "srchKey"));
			condition.setSrchWord(HttpUtil.getParameter(req, "srchWord"));
		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::" + categoryType.toUpperCase());

		Paginate<ResultSet> paginate = courseMasterService.getListCourseMaster(condition);
		List<CourseMasterListDTO> items = new ArrayList<CourseMasterListDTO>();
		if (paginate != null && paginate.getItemList().size() > 0) {
			for (ResultSet rs : paginate.getItemList()) {
				UIUnivCourseMasterRS courseMasterRS = (UIUnivCourseMasterRS)rs;
				CourseMasterListDTO dto = new CourseMasterListDTO();
				BeanUtils.copyProperties(dto, courseMasterRS.getCourseMaster());
				dto.setCategoryString(courseMasterRS.getCategory().getCategoryString());
				dto.setCompleteDivision(getCodeName(dto.getCompleteDivisionCd()));
				dto.setCourseStatus(getCodeName(dto.getCourseStatusCd()));
				items.add(dto);
			}
			mav.addObject("totalCount", paginate.getTotalCount());
			mav.addObject("currentPage", paginate.getCondition().getCurrentPage());
			mav.addObject("perPage", paginate.getCondition().getPerPage());

		} else {
			mav.addObject("totalCount", 0);
			mav.addObject("currentPage", condition.getCurrentPage());
			mav.addObject("perPage", condition.getPerPage());
		}

		mav.addObject("items", items);
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 학위 교과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseMasterCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/coursemaster/{courseMasterSeq}/detail")
	public ModelAndView detailCourseMaster(HttpServletRequest req, HttpServletResponse res, @PathVariable ("courseMasterSeq") String courseMasterSeq)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		String resultCode = UIApiConstant._SUCCESS_CODE;
		UIUnivCourseMasterVO vo = new UIUnivCourseMasterVO();

		try {
			vo.setCourseMasterSeq(Long.valueOf(courseMasterSeq.trim()));
		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}

		ResultSet rs = courseMasterService.getDetailCourseMaster(vo);
		CourseMasterDTO dto = new CourseMasterDTO();
		if (rs != null) {
			UIUnivCourseMasterRS courseMasterRS = (UIUnivCourseMasterRS)rs;
			BeanUtils.copyProperties(dto, courseMasterRS.getCourseMaster());
			dto.setCategoryString(courseMasterRS.getCategory().getCategoryString());
			dto.setCompleteDivision(getCodeName(dto.getCompleteDivisionCd()));
			dto.setCourseStatus(getCodeName(dto.getCourseStatusCd()));
		}

		mav.addObject("item", dto);
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}

}
