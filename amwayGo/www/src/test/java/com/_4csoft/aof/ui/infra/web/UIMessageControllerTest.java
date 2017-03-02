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
import com._4csoft.aof.ui.infra.vo.condition.UIMessageReceiveCondition;
import com._4csoft.aof.ui.infra.web.common.UIBindJunit;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIMessageControllerTest.java
 * @Title : JUnit 테스트
 * @date : 2014. 5. 2.
 * @author : 김영학
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Transactional
public class UIMessageControllerTest extends UIBindJunit {

	private final static Log LOG = LogFactory.getLog(UIMessageControllerTest.class); // Junit 콘솔로그 세팅

	@Autowired
	private UIMessageController messageController;

	@Autowired
	private MemberServiceImpl memberService;

	@Test
	public void testMessage() {
		LOG.debug("testMessage junit");
		MockHttpServletRequest req = new MockHttpServletRequest(); // 테스트 메서드의 파라미터 셋팅을 위한 Request 객체생성
		MockHttpServletResponse res = new MockHttpServletResponse(); // 테스트 메서드의 파라미터 셋팅을 위한 Response 객체생성

		setLoginSession(req, memberService, "antimagic");

		try {
			messageController.message(req, res);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Test
	public void testList() throws Exception {
		LOG.debug("testList junit");
		MockHttpServletRequest req = new MockHttpServletRequest(); // 테스트 메서드의 파라미터 셋팅을 위한 Request 객체생성
		MockHttpServletResponse res = new MockHttpServletResponse(); // 테스트 메서드의 파라미터 셋팅을 위한 Response 객체생성

		setLoginSession(req, memberService, "antimagic");

		UIMessageReceiveCondition condition = new UIMessageReceiveCondition();

		messageController.list(req, res, condition);

	}

}
