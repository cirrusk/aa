/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.filter.OncePerRequestFilter;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.infra.filter
 * @File : UIRequestFilter.java
 * @Title : request filter
 * @date : 2014. 4. 30.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIRequestFilter extends OncePerRequestFilter {

	public final int REGEX_FLAG = Pattern.CASE_INSENSITIVE | Pattern.DOTALL;
	public final List<Pattern> XSS_PATERNS = Arrays.asList(Pattern.compile("<script", REGEX_FLAG));
	public final List<String> XSS_EXCEPT_URL = Arrays.asList("/lcms/resource/insertversion.do", "/lcms/organization/unzipfile.do",
			"/lcms/organization/insert.do");
	public final String XSS_EXCEPT_PARAM = "aofNote";

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.web.filter.OncePerRequestFilter#doFilterInternal(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse,
	 * javax.servlet.FilterChain)
	 */
	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

		// 동적으로 암호화 키를 생성한다.
		if (request.getSession().getAttribute(Constants.SECURITY_ENCODING_KEY) == null) {
			request.getSession().setAttribute(Constants.SECURITY_ENCODING_KEY, StringUtil.getRandomString(24));
		}

		// layer 등에서 callback 함수를 parameter로 사용할 때.
		// do로 시작 해야 하고, 세미콜론(;)이 없어야 한다.
		String callbackParameter = HttpUtil.getParameter(request, "callback", "");
		if (StringUtil.isNotEmpty(callbackParameter)) {
			if (callbackParameter.startsWith("do") == false || callbackParameter.indexOf(";") >= 0) {
				throwXssException(request, response);
			}
		}

		// xss pattern 의 예외 상황
		// XSS_EXCEPT_URL 일치할 경우에 XSS_EXCEPT_PARAM의 값이 Session의 memberSeq와 일치하는 경우
		boolean xssExceptUrl = false;
		if (XSS_EXCEPT_URL.contains(request.getServletPath())) {
			String aofNote = request.getParameter(XSS_EXCEPT_PARAM);
			if (aofNote != null) {
				try {
					String decodedNote = StringUtil.decrypt(aofNote, (String)request.getSession().getAttribute(Constants.SECURITY_ENCODING_KEY));
					Long seq = Long.parseLong(decodedNote);
					if (seq.equals(SessionUtil.getMember(request).getMemberSeq())) {
						xssExceptUrl = true;
					}
				} catch (Exception e) {
					xssExceptUrl = false;
				}
			}
		}

		if (xssExceptUrl == false) {
			// cross site script 검사
			Enumeration<?> paramNames = request.getParameterNames();
			while (paramNames.hasMoreElements()) {
				String paramName = (String)paramNames.nextElement();
				String[] paramValues = request.getParameterValues(paramName);
				if (paramValues.length == 1) {
					if (findXssParameter(paramValues[0])) {
						throwXssException(request, response);
					}
				} else if (paramValues.length > 1) {
					for (int i = 0; i < paramValues.length; i++) {
						if (findXssParameter(paramValues[i])) {
							throwXssException(request, response);
						}
					}
				}
			}
		}
		filterChain.doFilter(request, response);
	}

	/**
	 * xss exception을 발생시킨다
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 */
	public void throwXssException(HttpServletRequest request, HttpServletResponse response) throws ServletException {
		request.setAttribute("XSS_EXCEPTION", Errors.INVALID_PARAMETER.desc);
		throw new ServletException(Errors.INVALID_PARAMETER.desc);
	}

	/**
	 * cross site script 검사
	 * 
	 * @param value
	 * @return
	 */
	public boolean findXssParameter(String value) {
		boolean found = false;
		for (Pattern pattern : XSS_PATERNS) {
			Matcher matcher = pattern.matcher(value);
			if (matcher.find()) {
				found = true;
				break;
			}
		}
		return found;
	}
}
