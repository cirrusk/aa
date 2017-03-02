/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.interceptor;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;

import com._4csoft.aof.infra.service.MemberAccessHistoryService;
import com._4csoft.aof.infra.service.RolegroupMenuService;
import com._4csoft.aof.infra.service.RolegroupService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.infra.vo.RolegroupVO;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberAccessHistoryVO;
import com._4csoft.aof.ui.infra.vo.resultset.UIRolegroupRS;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveLecturerVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveLecturerMenuRS;
import com._4csoft.aof.univ.service.UnivCourseActiveLecturerMenuService;
import com._4csoft.aof.univ.service.UnivCourseActiveLecturerService;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.interceptor
 * @File : UIAccessInterceptor.java
 * @Title : Access Interceptor
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : Controller가 실행되기 전 해당 메뉴의 CRUD 권한을 검사한다 required : session(roleGroupSeq), menuId or requestUri
 */
@Component
public class UIAccessInterceptor extends AccessInterceptor {

	@Resource (name = "RolegroupMenuService")
	protected RolegroupMenuService rolegroupMenuService;

	@Resource (name = "RolegroupService")
	protected RolegroupService rolegroupService;

	@Resource (name = "UnivCourseActiveLecturerMenuService")
	protected UnivCourseActiveLecturerMenuService courseActiveLecturerMenuService;

	@Resource (name = "UnivCourseActiveLecturerService")
	protected UnivCourseActiveLecturerService courseActiveLecturerService;
	
	@Resource (name = "MemberAccessHistoryService")
	protected MemberAccessHistoryService memberAccessHistoryService;

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.web.servlet.handler.HandlerInterceptorAdapter#preHandle(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, java.lang.Object)
	 */
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		super.preHandle(request, response, handler);

		// excludeUrl
		if ("true".equals((String)request.getAttribute("excludeUrl"))) {
			return true;
		}

		MemberVO ssMember = null;
		// allow rolegroup
		Object object = SessionUtil.getMember(request);
		if (object != null && (object instanceof MemberVO)) {
			ssMember = (MemberVO)object;
		}
		if (ssMember == null) {
			logger.trace("session member is null");
			accessDeny(request); // 관리자 사이트이므로 세션이 없으면 안된다
		}

		if (StringUtil.isEmpty(ssMember.getCurrentRolegroupSeq())) {
			logger.trace("currentRolegroupSeq is null");
			accessDeny(request);
		}
		List<ResultSet> rolegroupList = rolegroupService.getListCache();

		if (allowRolegroup != null && allowRolegroup.size() > 0) {
			boolean allow = false;
			for (String allowRole : allowRolegroup) {
				for (int i = 0; i < rolegroupList.size(); i++) {
					UIRolegroupRS rs = (UIRolegroupRS)rolegroupList.get(i);
					RolegroupVO rolegroup = rs.getRolegroup();
					if (allowRole.equals(rolegroup.getRoleCd())) {
						allow = true;
					}
				}
			}
			if (allow == false) {
				logger.trace(request, "|AccessInterceptor:rolegroup access denied");
				accessDeny(request);
			}
		}

		boolean accessible = false;
		String requestUri = request.getServletPath();
		String requestMenuId = request.getParameter("currentMenuId");

		List<ResultSet> menuList = rolegroupMenuService.getListCache(ssMember.getCurrentRolegroupSeq());
		List<ResultSet> subMenuList = new ArrayList<ResultSet>();
		subMenuList.addAll(menuList);

		Long shortcutCourseActiveSeq = HttpUtil.getParameter(request, "shortcutCourseActiveSeq", 0L);
		String shortcutCourseTypeCd = HttpUtil.getParameter(request, "shortcutCourseTypeCd", "");

		// 교강사, 조교, 튜터 롤그룹으로 입장시 현재 개설과목의 메뉴권한과 권한상태(개설과목 내부에서 교강사,조교,튜터 지정을 따로 한다.)를 가져온다.
		if ("PROF".equals(ssMember.getCurrentRoleCfString()) || "ASSIST".equals(ssMember.getCurrentRoleCfString())
				|| "TUTOR".equals(ssMember.getCurrentRoleCfString())) {

			if (StringUtil.isNotEmpty(shortcutCourseActiveSeq)) {
				UIUnivCourseActiveLecturerVO vo = new UIUnivCourseActiveLecturerVO();
				vo.setCourseActiveSeq(shortcutCourseActiveSeq);
				vo.setMemberSeq(ssMember.getMemberSeq());
				request.setAttribute("appCourseActiveLecturer", courseActiveLecturerService.getDetailCourseActiveLecturerByMember(vo));

				List<ResultSet> memberMenuList = courseActiveLecturerMenuService.getListCourseActiveLecturerMenu(ssMember.getMemberSeq(),
						shortcutCourseActiveSeq);

				int len = subMenuList.size() - 1;
				for (int i = len; i >= 0; i--) {
					UIRolegroupRS rs = (UIRolegroupRS)subMenuList.get(i);
					boolean matched = false;
					String crud = "";
					for (int y = 0; y < memberMenuList.size(); y++) {
						UIUnivCourseActiveLecturerMenuRS lecturerRS = (UIUnivCourseActiveLecturerMenuRS)memberMenuList.get(y);
						if (lecturerRS.getUnivCourseActiveLecturerMenu().getMenuSeq().equals(rs.getRolegroupMenu().getMenuSeq())) {
							matched = true;
							crud = lecturerRS.getUnivCourseActiveLecturerMenu().getCrud();
							break;
						}
					}
					if (matched == true) {
						rs.getRolegroupMenu().setCrud(crud);
					} else {
						if ("FormActiveParam".equals(rs.getMenu().getDependent())) {
							subMenuList.remove(i);
						}
					}
				}
			}
		} else if ("ADM".equals(ssMember.getCurrentRoleCfString())) { // 관리자일시 해당 개설과목의 대표 교수를 찾아온다.

			// 비표준 상시제 팀프로젝트 메뉴삭제
			if ("COURSE_TYPE::ALWAYS".equals(shortcutCourseTypeCd)) {
				final String[] excludeMenu = { "TEAMPROJECT", "OFFLINE" };

				int len = subMenuList.size() - 1;
				for (int i = len; i >= 0; i--) {
					UIRolegroupRS rs = (UIRolegroupRS)subMenuList.get(i);

					for (int j = 0; j < excludeMenu.length; j++) {
						if (excludeMenu[j].equals(rs.getMenu().getCfString())) {
							subMenuList.remove(i);
						}
					}
				}
			}

			if (StringUtil.isNotEmpty(shortcutCourseActiveSeq)) {
				request.setAttribute("appCourseActiveLecturer", courseActiveLecturerService.getDetailCourseActiveLecturerByPresident(shortcutCourseActiveSeq));
			}
		}

		String requestCrud = "R";
		if (requestUri != null && requestUri.length() > 0) {
			String subUri = requestUri.substring(requestUri.lastIndexOf("/") + 1);
			if (subUri.startsWith("insert") || subUri.startsWith("create")) {
				requestCrud = "C";
			} else if (subUri.startsWith("update") || subUri.startsWith("edit") || subUri.startsWith("save")) {
				requestCrud = "U";
			} else if (subUri.startsWith("delete")) {
				requestCrud = "D";
			} else if (subUri.startsWith("excel")) {
				requestCrud = "E";
			}
		}

		if (subMenuList != null && subMenuList.size() > 0) {
			request.setAttribute("appMenuList", subMenuList);

			// menuSeq 가 있을때, menuSeq가 일치하는 메뉴를 찾아 crud를 검사한다.
			if (requestMenuId != null && requestMenuId.length() > 0) {
				requestMenuId = StringUtil.decrypt(requestMenuId, Constants.ENCODING_KEY);

				// post 방식으로 request 일 경우에만 access 가능
				if ("post".equalsIgnoreCase(request.getMethod())) {
					for (int i = 0; i < subMenuList.size(); i++) {
						UIRolegroupRS rs = (UIRolegroupRS)subMenuList.get(i);
						String crud = rs.getRolegroupMenu().getCrud();
						String menuId = String.valueOf(rs.getMenu().getMenuId());
						if (requestMenuId.equals(menuId)) {
							if (crud.indexOf(requestCrud) > -1) {
								request.setAttribute("appCurrentMenu", rs);
								accessible = true;
								break;
							}
						}
					}
				} else {
					logger.trace(request, "reqeust GET");
				}
			} else {
				// menuSeq 가 없을때, requestUri 가 일치하는 메뉴를 찾아 crud를 검사한다.
				for (int i = 0; i < subMenuList.size(); i++) {
					UIRolegroupRS rs = (UIRolegroupRS)subMenuList.get(i);
					String crud = rs.getRolegroupMenu().getCrud();
					String url = rs.getMenu().getUrl();
					if (requestUri.equals(url)) {
						if (crud.indexOf(requestCrud) > -1) {
							request.setAttribute("appCurrentMenu", rs);
							accessible = true;
							break;
						}
					}
				}
			}
		} else {
			logger.trace(request, "menu list is null or emtpy");
		}
		String startPage = Constants.START_PAGE;
		if (requestUri.equals(startPage)) {
			accessible = true;
		}

		if (accessible == false) {
			logger.trace(request, "requestUri:" + requestUri + ":access denied");
			accessDeny(request);
		}

		// 개인정보 열람 기록
		if (historyUrl != null) {
			PathMatcher matcher = new AntPathMatcher();
			for (String pattern : historyUrl) {
				if (matcher.match(pattern, requestUri)) {
					String[] process = { "update", "delete", "detail","excel" };
					for (int i = 0; i < process.length; i++) {
						if (requestUri.indexOf(process[i]) > -1) {
							UIMemberAccessHistoryVO vo = new UIMemberAccessHistoryVO();

							Enumeration<?> paramNames = request.getParameterNames();

							StringBuilder sb = new StringBuilder();
							while (paramNames.hasMoreElements()) {
								String parameter = (String)paramNames.nextElement();
								sb.append(parameter).append("=").append(request.getParameter(parameter)).append(Constants.SEPARATOR);
							}

							vo.setParam(sb.toString());
							vo.setMemberSeq(SessionUtil.getMember(request).getMemberSeq());
							vo.setCrud(StringUtil.toUpperCase(process[i].substring(0, 1)));
							vo.setUrl(requestUri);
							vo.setRegMemberSeq(ssMember.getMemberSeq());
							vo.setRegIp(HttpUtil.getRemoteAddr(request));
							vo.setUpdMemberSeq(ssMember.getMemberSeq());
							vo.setUpdIp(HttpUtil.getRemoteAddr(request));

							memberAccessHistoryService.insert(vo);
						}
					}
				}
			}
		}

		logger.trace(request.getServletPath() + " accessible");
		return true;
	}
}
