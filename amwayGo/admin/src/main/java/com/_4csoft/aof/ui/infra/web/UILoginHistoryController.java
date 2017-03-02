/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.BookmarkService;
import com._4csoft.aof.infra.service.LoginHistoryService;
import com._4csoft.aof.infra.service.LoginStatusService;
import com._4csoft.aof.infra.service.MemberService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.security.SessionRegistry;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.support.validator.InfraValidator;
import com._4csoft.aof.infra.vo.BookmarkVO;
import com._4csoft.aof.ui.infra.vo.UILoginHistoryVO;
import com._4csoft.aof.ui.infra.vo.UILoginStatusVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.condition.UILoginHistoryCondition;
import com._4csoft.aof.ui.infra.vo.condition.UIMemberCondition;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivYearTermVO;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UILoginController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UILoginHistoryController extends BaseController {

	@Resource (name = "LoginHistoryService")
	private LoginHistoryService loginHistoryService;

	@Resource (name = "LoginStatusService")
	private LoginStatusService loginStatusService;

	@Resource (name = "MemberService")
	private MemberService memberService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;
	
	@Resource (name = "BookmarkService")
	private BookmarkService bookMarkService;

	@Resource (name = "sessionRegistry")
	private SessionRegistry sessionRegistry;
	
	@Resource (name = "UIInfraValidator")
	protected InfraValidator validator;
	
	private final int SUCCESS = 0;
	private final int LOGIN_FAILURE = 1101;
	private final int LOGIN_CONCURRENT = 1102;
	private final int LOGIN_CONCURRENT_CONFIRM = 1103;

	/**
	 * 로그인 인증 결과 처리
	 * 
	 * <pre>
	 * 로그인 성공시 : 로그인 기록 저장 후 /common/security.jsp 로 forward
	 * 로그인 실패,동시접속,동시접속확인 :  /common/security.jsp 로 forward
	 * 로그아웃 성공시 :  /common/security.jsp 로 forward
	 * type : json이면 json으로 결과 리턴.
	 * </pre>
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/login/process.do")
	public ModelAndView successLogin(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		int resultCode = SUCCESS;
		String param = HttpUtil.getParameter(req, "param", "");
		String type = HttpUtil.getParameter(req, "type", "");
		
		if ("success".equals(param)) {
			UILoginHistoryVO voLoginHistory = new UILoginHistoryVO();
			UILoginStatusVO voLoginStatus = new UILoginStatusVO();

			requiredSession(req, voLoginHistory, voLoginStatus);

			UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
			voLoginHistory.setMemberSeq(ssMember.getMemberSeq());
			voLoginHistory.setRolegroupSeq(ssMember.getCurrentRolegroupSeq());
			voLoginHistory.setSessionId(req.getSession().getId());
			voLoginHistory.setUserAgent(ssMember.getUserAgent());
			voLoginHistory.setSite(Constants.SYSTEM_DOMAIN);
			voLoginHistory.setDevice(StringUtil.detectDevice(voLoginHistory.getUserAgent()));
			loginHistoryService.insertLoginHistory(voLoginHistory);

			voLoginStatus.setMemberSeq(ssMember.getMemberSeq());
			voLoginStatus.setSite(Constants.SYSTEM_DOMAIN);
			voLoginStatus.setSessionId(req.getSession().getId());
			loginStatusService.insertLoginStatus(voLoginStatus);

			// 즐겨찾기
			BookmarkVO bookmark = new BookmarkVO();
			bookmark.setRoleGroupSeq(ssMember.getCurrentRolegroupSeq());
			bookmark.setMemberSeq(ssMember.getMemberSeq());

			ssMember.setBookmarks(bookMarkService.getList(bookmark));

			// 롤그룹의 권한에 따라 시스템에 설정된 년도학기를 셋팅한다.
			/** TODO : 코드 */
			UnivYearTermVO yearTerm = univYearTermService.getSystemYearTerm(ssMember.getCurrentRoleCfString());
			if (yearTerm == null) {
				// 현재 년도의 1학기로 셋팅한다.
				yearTerm = new UnivYearTermVO();
				String defaultTerm = "10";
				yearTerm.setYearTerm(DateUtil.getTodayYear() + defaultTerm);
			} else {
				ssMember.getExtendData().put("systemYearTerm", yearTerm);
			}

			SessionUtil.updateSessionMember(req, sessionRegistry);

			resultCode = SUCCESS;
			
		} else if ("failure".equals(param)) {
			resultCode = LOGIN_FAILURE;

		} else if ("concurrent".equals(param)) {
			resultCode = LOGIN_CONCURRENT;

		} else if ("concurrentConfirm".equals(param)) {
			resultCode = LOGIN_CONCURRENT_CONFIRM;

		} else if ("logout".equals(param)) {
			resultCode = SUCCESS;
		}
		
		if ("json".equals(type)) {
			mav.addObject("resultCode", resultCode);
			mav.setViewName("jsonView");
		} else {
			mav.setViewName("forward:/common/security.jsp");

		}
		return mav;
	}

	/**
	 * 접속통계
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/login/history/statistics/list.do")
	public ModelAndView listStatisctics(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String srchYn = HttpUtil.getParameter(req, "srchYn", "N");
		if ("Y".equals(srchYn)) {
			UILoginHistoryCondition condition = new UILoginHistoryCondition();
			condition.setSrchYn(srchYn);
			condition.setSrchStatisticsType(HttpUtil.getParameter(req, "srchStatisticsType", "day"));
			condition.setSrchStartRegDate(HttpUtil.getParameter(req, "srchStartRegDate", DateUtil.getToday(Constants.FORMAT_DATE)));
			condition.setSrchEndRegDate(HttpUtil.getParameter(req, "srchEndRegDate", DateUtil.getToday(Constants.FORMAT_DATE)));

			UIMemberCondition conditionMember = new UIMemberCondition();
			conditionMember.setSrchStatisticsType(condition.getSrchStatisticsType());
			conditionMember.setSrchStartRegDate(condition.getSrchStartRegDate());
			conditionMember.setSrchEndRegDate(condition.getSrchEndRegDate());

			if (StringUtil.isNotEmpty(condition.getSrchStartRegDate())) {
				condition.setSrchStartRegDate(DateUtil.convertStartDate(condition.getSrchStartRegDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
			}
			if (StringUtil.isNotEmpty(condition.getSrchEndRegDate())) {
				condition.setSrchEndRegDate(DateUtil.convertEndDate(condition.getSrchEndRegDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
			}
			mav.addObject("listLogin", loginHistoryService.getListStatistics(condition));
			mav.addObject("detailLogin", loginHistoryService.getDetailStatistics());

			mav.addObject("listMember", memberService.getListStatistics(conditionMember));
			mav.addObject("detailMember", memberService.getDetailStatistics());

			mav.addObject("condition", condition);
		}

		mav.setViewName("/infra/loginHistory/listLoginHistoryStatistics");
		return mav;
	}
	
	
}
