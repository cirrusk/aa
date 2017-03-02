/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.transaction.annotation.Transactional;

import com._4csoft.aof.infra.service.impl.MemberServiceImpl;
import com._4csoft.aof.ui.infra.vo.UIBookmarkVO;
import com._4csoft.aof.ui.infra.web.common.UIBindJunit;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIBookmarkControllerTest.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 4. 29.
 * @author : 김영학
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Transactional
public class UIBookmarkControllerTest extends UIBindJunit { // JUnit를 실행하고 DB Connection을 생성하기 위한 Super Class를 상속

	private final static Log LOG = LogFactory.getLog(UIBookmarkControllerTest.class); // Junit 콘솔로그 세팅

	@Autowired
	private UIBookmarkController bookMarkController; // Junit을 실행하기 위한 대상에 @Autowired Annotation을 작성하여 생성

	@Autowired
	private MemberServiceImpl memberService;

	@Test
	public void testList() {
		LOG.debug("testList junit");
		MockHttpServletRequest req = new MockHttpServletRequest(); // 테스트 메서드의 파라미터 셋팅을 위한 Request 객체생성
		MockHttpServletResponse res = new MockHttpServletResponse(); // 테스트 메서드의 파라미터 셋팅을 위한 Response 객체생성

		setLoginSession(req, memberService, "admin");

		UIBookmarkVO vo = new UIBookmarkVO();

		try {
			bookMarkController.list(req, res, vo);
		} catch (Exception e) {
			LOG.debug("에러");
			e.printStackTrace();
		} // 테스트 메서드 수행

	}

}
