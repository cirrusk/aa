/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.interceptor;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;

import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCategoryCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCategoryRS;
import com._4csoft.aof.univ.service.UnivCategoryService;

/**
 * @Project : aof5-demo-www
 * @Package : com._4csoft.aof.ui.infra.interceptor
 * @File : UIOcwAccessInterceptor.java
 * @Title : OCW 전용 인터셉터
 * @date : 2013. 5. 8.
 * @author : 김현우
 * @descrption :
 */
@Component
public class UIOcwAccessInterceptor extends AccessInterceptor {

	@Resource (name = "UnivCategoryService")
	private UnivCategoryService categoryService;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.ui.infra.interceptor.AccessInterceptor#preHandle(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse,
	 * java.lang.Object)
	 */
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		request.setAttribute("servletPath", request.getServletPath());
		request.setAttribute("queryString", request.getQueryString());

		super.preHandle(request, response, handler);

		String currentMenuId = HttpUtil.getParameter(request, "currentMenuId", "001");

		// 대메뉴 OCW 선택시에만 카테고리 목록 가져옴
		if ("002".equalsIgnoreCase(currentMenuId)) {

			UIUnivCategoryRS categoryRoot = (UIUnivCategoryRS)categoryService.getDetailCategoryRoot("CATEGORY_TYPE::OCW");

			if (categoryRoot != null) {
				UIUnivCategoryCondition condition = new UIUnivCategoryCondition();
				condition.setSrchCategoryTypeCd(categoryRoot.getCategory().getCategoryTypeCd());
				condition.setSrchParentSeq(categoryRoot.getCategory().getGroupSeq());

				List<ResultSet> depth2list = categoryService.getList(condition);

				request.setAttribute("categoryOcwDepth2List", depth2list);

				Long categoryOcwDepth2 = HttpUtil.getParameter(request, "categoryOcwDepth2Seq", ((UIUnivCategoryRS)depth2list.get(0)).getCategory()
						.getCategorySeq());
				condition.setSrchParentSeq(categoryOcwDepth2);
				request.setAttribute("categoryOcwDepth2Seq", categoryOcwDepth2);

				List<ResultSet> depth3list = categoryService.getList(condition);

				if (depth3list != null) {
					request.setAttribute("categoryOcwDepth3List", depth3list);
				}

				request.setAttribute("categoryOcwDepth3Seq", HttpUtil.getParameter(request, "categoryOcwDepth3Seq", ""));
				request.setAttribute("srchCategorySeq", HttpUtil.getParameter(request, "srchCategorySeq", ""));
				request.setAttribute("srchGroupOrder", HttpUtil.getParameter(request, "srchGroupOrder", ""));

			}
		}

		return true;
	}
}
