/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.security.AfterAuthenticationProcessing;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;

/**
 * @Project : aof5-admin
 * @Package : com._4csoft.aof.ui.infra.security
 * @File : UIAfterAuthenticationProcessing.java
 * @Title : After Authentication Processing
 * @date : 2013. 4. 23.
 * @author : 김종규
 * @descrption : 인증 처리 후 수행
 */
public class UIAfterAuthenticationProcessing implements AfterAuthenticationProcessing {

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.security.AfterAuthenticationProcessing#process(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse,
	 * org.springframework.security.core.Authentication)
	 */
	public void process(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws AuthenticationException {
		
		if (authentication.getPrincipal() instanceof UIMemberVO) {

			// 현재 롤그룹 세팅
			UIMemberVO member = (UIMemberVO)authentication.getPrincipal();
			String rolegroup = request.getParameter(Constants.J_ROLEGROUP);
			String roleCfString = request.getParameter(Constants.J_ROLECFSTRING);
			if (rolegroup != null && rolegroup.length() > 0) {
				member.setCurrentRolegroupSeq(Long.parseLong(rolegroup));
				member.setCurrentRoleCfString(roleCfString);
			} else {
				member.setCurrentRolegroupSeq(member.getRoleGroups().get(0).getRolegroupSeq());
				member.setCurrentRoleCfString(member.getRoleGroups().get(0).getCfString());
			}
			// 인증된 사용자의 userAgent와 ip 를 저장해 놓는다. - userAgent와 ip를 저장해야 하는 경우를 위해서.
			member.setUserAgent(request.getHeader("user-agent"));
			member.setIp(HttpUtil.getRemoteAddr(request));
		}
		
	}
}
