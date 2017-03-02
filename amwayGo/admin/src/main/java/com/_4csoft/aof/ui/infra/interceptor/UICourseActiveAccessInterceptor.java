/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.interceptor;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com._4csoft.aof.infra.service.RolegroupMenuService;
import com._4csoft.aof.infra.service.RolegroupService;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.resultset.UIMemberRS;
import com._4csoft.aof.ui.session.service.UISessionService;
import com._4csoft.aof.ui.session.vo.condition.UISessionCondition;
import com._4csoft.aof.ui.univ.vo.UIUnivYearTermVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveRS;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivCourseActiveVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.infra.interceptor
 * @File : UICourseActiveAccessInterceptor.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 27.
 * @author : 김종규
 * @descrption : 개설과목 접근 권한 검사
 */
@Component
public class UICourseActiveAccessInterceptor extends HandlerInterceptorAdapter {

	@Resource (name = "RolegroupMenuService")
	protected RolegroupMenuService rolegroupMenuService;

	@Resource (name = "RolegroupService")
	protected RolegroupService rolegroupService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService yearTermService;
	
	@Resource (name = "UISessionService")
	private UISessionService sessionService;

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.web.servlet.handler.HandlerInterceptorAdapter#preHandle(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, java.lang.Object)
	 */
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		super.preHandle(request, response, handler);

		if (SessionUtil.isValid(request)) {
			UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(request);

			String shortcutCategoryTypeCd = HttpUtil.getParameter(request, "shortcutCategoryTypeCd", "");
			String shortcutYearTerm = HttpUtil.getParameter(request, "shortcutYearTerm", "");

			// 관리자 권한 이외 경우(ex) 교강사, 튜터 등
			if ("PROF".equals(ssMember.getCurrentRoleCfString())) {

				if (StringUtil.isNotEmpty(shortcutCategoryTypeCd)) {
					// 년도학기 combo
					request.setAttribute("comboListYearTerm", courseActiveService.getListChargeOfYearTerm(ssMember.getMemberSeq(), shortcutCategoryTypeCd));
				}

				if (StringUtil.isNotEmpty(shortcutYearTerm) && StringUtil.isNotEmpty(shortcutCategoryTypeCd)) {
					// 개설과목 목록 combo
					request.setAttribute("comboListCourseActive",
							courseActiveService.getListChargeOfCourseActive(ssMember.getMemberSeq(), shortcutYearTerm, shortcutCategoryTypeCd));
				}
			} else {
				Long shortcutCourseActiveSeq = HttpUtil.getParameter(request, "shortcutCourseActiveSeq", 0L);

				if (StringUtil.isNotEmpty(shortcutCourseActiveSeq)) {
					// 관리자 권한일 경우
					UnivCourseActiveVO courseActive = new UnivCourseActiveVO();
					courseActive.setCourseActiveSeq(shortcutCourseActiveSeq);
					UIUnivCourseActiveRS courseActiveRS = (UIUnivCourseActiveRS)courseActiveService.getDetailCourseActive(courseActive);
					request.setAttribute("comboDeatilCourseActive", courseActiveRS);
					
					/**
					 * 인재개발대회 추가를 인한 세션값 불러오기
					 */
					/*if(courseActiveRS != null){
						if("Y".equals(courseActiveRS.getCourseActive().getCompetitionYn())){
							UISessionCondition sessionCondition = new UISessionCondition();
							request.setAttribute("sessionList", sessionService.getList(sessionCondition));
						}
					}*/

					if (shortcutCategoryTypeCd.equals("CATEGORY_TYPE::DEGREE")) {
						UIUnivYearTermVO yearTerm = new UIUnivYearTermVO();
						yearTerm.setYearTerm(shortcutYearTerm);
						// 년도학기 combo
						request.setAttribute("comboYearTerm", yearTermService.getDetailYearTerm(yearTerm));
					}
				}
			}

		}
		return true;
	}
}
