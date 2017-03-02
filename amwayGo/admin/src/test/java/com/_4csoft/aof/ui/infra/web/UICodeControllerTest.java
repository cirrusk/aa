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
import com._4csoft.aof.ui.infra.vo.condition.UICodeCondition;
import com._4csoft.aof.ui.infra.web.common.UIBindJunit;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UICodeControllerTest.java
 * @Title : Junit 테스트
 * @date : 2014. 5. 2.
 * @author : 김영학
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Transactional
public class UICodeControllerTest extends UIBindJunit {

	private final static Log LOG = LogFactory.getLog(UICodeControllerTest.class);

	@Autowired
	private MemberServiceImpl memberService;

	@Autowired
	private UICodeController codeController;

	@Test
	public void testListCodegrup() {
		LOG.debug("testListCodegrup junit");
		MockHttpServletRequest req = new MockHttpServletRequest();
		MockHttpServletResponse res = new MockHttpServletResponse();

		setLoginSession(req, memberService, "admin");

		UICodeCondition condition = new UICodeCondition();

		try {
			codeController.listCodegrup(req, res, condition);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
