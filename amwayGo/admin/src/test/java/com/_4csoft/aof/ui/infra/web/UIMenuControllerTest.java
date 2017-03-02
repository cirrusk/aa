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
import com._4csoft.aof.ui.infra.vo.UIMenuVO;
import com._4csoft.aof.ui.infra.vo.condition.UIMenuCondition;
import com._4csoft.aof.ui.infra.web.common.UIBindJunit;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIMenuControllerTest.java
 * @Title : Junit 테스트
 * @date : 2014. 5. 2.
 * @author : 김영학
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Transactional
public class UIMenuControllerTest extends UIBindJunit {

	private final static Log LOG = LogFactory.getLog(UIMenuControllerTest.class); // Junit 콘솔로그 세팅

	@Autowired
	private UIMenuController menuController; // Junit을 실행하기 위한 대상에 @Autowired Annotation을 작성하여 생성

	@Autowired
	private MemberServiceImpl memberService;

	@Test
	public void testList() {
		LOG.debug("testList junit");
		MockHttpServletRequest req = new MockHttpServletRequest(); // 테스트 메서드의 파라미터 셋팅을 위한 Request 객체생성
		MockHttpServletResponse res = new MockHttpServletResponse(); // 테스트 메서드의 파라미터 셋팅을 위한 Response 객체생성
		setLoginSession(req, memberService, "admin");

		UIMenuCondition condition = new UIMenuCondition();

		try {
			menuController.list(req, res, condition); // 테스트 메서드 수행
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Test
	public void testListPopup() {
		LOG.debug("testListPopup junit");
		MockHttpServletRequest req = new MockHttpServletRequest();
		MockHttpServletResponse res = new MockHttpServletResponse();

		setLoginSession(req, memberService, "admin");

		UIMenuCondition condition = new UIMenuCondition();

		try {
			menuController.listPopup(req, res, condition);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Test
	public void testDetail() {
		LOG.debug("testListPopup junit");
		MockHttpServletRequest req = new MockHttpServletRequest();
		MockHttpServletResponse res = new MockHttpServletResponse();

		setLoginSession(req, memberService, "admin");

		UIMenuVO menu = new UIMenuVO();
		menu.setMenuSeq(4L);

		UIMenuCondition condition = new UIMenuCondition();

		/*
		 * 실패케이스(필수파라미터 없음) 위의 testListPopup 메소드처럼 try catch 구문을 사용시에는 에러발생시 catch로 처리하기 때문에 테스트 결과가 성공으로 표시된다.
		 */
		try {
			menuController.detail(req, res, menu, condition);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
