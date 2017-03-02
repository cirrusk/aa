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

import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;

/**
 * @Project : aof5-demo-www
 * @Package : com._4csoft.aof.ui.infra.interceptor
 * @File : UIAccessInterceptor.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : Access Interceptor
 * @descrption : Controller가 실행되기 전 해당 메뉴의 CRUD 권한을 검사한다 required : session(roleGroupSeq), menuId or requestUri
 */
@Component
public class UIAccessInterceptor extends AccessInterceptor {

	@Resource (name = "CodeService")
	protected CodeService codeService;

	private List<String> excludeApiUrl;

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.web.servlet.handler.HandlerInterceptorAdapter#preHandle(javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, java.lang.Object)
	 */
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		super.preHandle(request, response, handler);

		// API 토큰 체크
		//TODO 토큰 임시 제거
/*		if (request.getServletPath().startsWith("/api")) {
			String accessToken = request.getParameter("accessToken");
			logger.debug("access_token :  " + accessToken);
			// APi 토큰 체크 제외URL
			boolean isExcludeApi = false;

			if (CollectionUtils.isNotEmpty(excludeApiUrl)) {
				for (String url : excludeApiUrl) {
					if (StringUtils.containsIgnoreCase(request.getRequestURI(), url)) {
						isExcludeApi = true;
						break;
					}
				}
			}
			if (!isExcludeApi) {
				if (!StringUtil.isEmpty(accessToken)) {
					checkAccessToken(request, accessToken);
				} else {
					throw new ApiServiceExcepion(UIApiConstant._INVALID_SECURE_CODE, "not token error");
				}
			}
		}*/

		return true;
	}

	/**
	 * 토큰 체크
	 * 
	 * @param request
	 * @param accessToken
	 * @throws Exception
	 */
	public void checkAccessToken(HttpServletRequest request, String accessToken) throws Exception {
		int encodekeyLength = 24;
		String decodeKeyString = null;
		// 서버를 재시작할 경우 복호화 에러가 발생함.
		try {
			decodeKeyString = StringUtil.decrypt(accessToken.substring(0, accessToken.length() - encodekeyLength),
					accessToken.substring(accessToken.length() - encodekeyLength));
		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_SESSTION, "token is invaild");
		}

		String tokenKey = "";
		long diffSecond = 0;
		try {
			String[] decodeKeys = StringUtil.split(decodeKeyString, "|", 2);
			tokenKey = decodeKeys[0]; // TOKEN_KEY
			String tokenDateString = decodeKeys[1]; // 요청 시간
			diffSecond = DateUtil.diffDate(tokenDateString, DateUtil.getToday("yyyyMMddHHmmss"), "yyyyMMddHHmmss");
		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._SYSTEM_ERROR, e.getMessage());
		}
		if (diffSecond > UIApiConstant._ACCESS_TOKEN_PERIOD) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_SECURE_CODE, "token time over");
		}

		if (!tokenKey.equals(UIApiConstant._LNK_CODE)) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_SECURE_CODE, "token secure error");
		}

	}

	public List<String> getExcludeApiUrl() {
		return excludeApiUrl;
	}

	public void setExcludeApiUrl(List<String> excludeApiUrl) {
		this.excludeApiUrl = excludeApiUrl;
	}

}
