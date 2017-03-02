/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.api;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.dto.UICategoryDTO;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCategoryCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCategoryRS;
import com._4csoft.aof.univ.service.UnivCategoryService;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.infra.api
 * @File : UICategoryController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 16.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICategoryController extends UIBaseController {
	@Resource (name = "UnivCategoryService")
	private UnivCategoryService categoryService;

	/**
	 * 
	 * @param req
	 * @param res
	 * @param categoryType
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/category/{categoryType}/list")
	public ModelAndView listCategory(HttpServletRequest req, HttpServletResponse res, @PathVariable ("categoryType") String categoryType) throws Exception {
		ModelAndView mav = new ModelAndView();

		String resultCode = UIApiConstant._SUCCESS_CODE;

		UIUnivCategoryCondition condition = new UIUnivCategoryCondition();
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::" + categoryType.toUpperCase());

		condition.setSrchParentSeq((HttpUtil.getParameter(req, "srchParentSeq", 0L)));

		// 학위인 경우 학기정보 필수
		if ("CATEGORY_TYPE::DEGREE".equals(condition.getSrchCategoryTypeCd())) {
			condition.setSrchYearTerm((HttpUtil.getParameter(req, "srchYearTerm")));
			if (StringUtil.isEmpty(condition.getSrchYearTerm())) {
				throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
			}
		} else {

		}
		List<ResultSet> resultList = categoryService.getList(condition);

		List<UICategoryDTO> items = new ArrayList<UICategoryDTO>();

		for (ResultSet rs : resultList) {
			UIUnivCategoryRS categoryRs = (UIUnivCategoryRS)rs;
			UICategoryDTO item = new UICategoryDTO(categoryRs.getCategory().getCategorySeq(), categoryRs.getCategory().getCategoryName(), categoryRs
					.getCategory().getChildCount());
			items.add(item);
		}
		String resultMessage = getErorrMessage(resultCode);

		mav.addObject("items", items);
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);

		mav.setViewName("jsonView");
		return mav;
	}
}
