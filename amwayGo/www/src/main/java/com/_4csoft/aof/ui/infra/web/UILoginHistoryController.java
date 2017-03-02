/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.LoginHistoryService;
import com._4csoft.aof.infra.service.LoginStatusService;
import com._4csoft.aof.infra.service.MemberService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.security.SessionRegistry;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.UILoginHistoryVO;
import com._4csoft.aof.ui.infra.vo.UILoginStatusVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;

/**
 * @Project : aof5-demo-www
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

	@Resource (name = "sessionRegistry")
	private SessionRegistry sessionRegistry;

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

			// 로그인시 추가 데이터가 있으면 member.map에 담는다.
			if (!"".equals(ssMember.getExtendData().get("extendData"))) {
				ObjectMapper mapper = new ObjectMapper();
				Map<String, Object> map = mapper.readValue(ssMember.getExtendData().get("extendData").toString(), Map.class);
				for (String key : map.keySet()) {
					for (Iterator localIterator = ((List)map.get(key)).iterator(); localIterator.hasNext();) {
						Object obj = localIterator.next();

						ssMember.getExtendData().put(((Map)obj).get("name").toString(), ((Map)obj).get("value").toString());

						if ("observerYn".equals(((Map)obj).get("name").toString())) {
							ssMember.setObserverModeYn(((Map)obj).get("value").toString());
						}
					}
				}
			}

			if (!"".equals(ssMember.getObserverModeYn())) {
				String courseApplySeq = "-1";
				if(StringUtil.isNotEmpty(HttpUtil.getParameter(req, "courseApplySeq", ""))){
					courseApplySeq = HttpUtil.getParameter(req, "courseApplySeq", "");
				}
				req.setAttribute("courseApplySeq", courseApplySeq);
			}

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
}
