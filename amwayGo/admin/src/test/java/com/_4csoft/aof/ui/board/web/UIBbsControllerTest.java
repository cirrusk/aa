/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.web;

import static org.junit.Assert.fail;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.transaction.annotation.Transactional;

import com._4csoft.aof.board.service.BbsService;
import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.infra.service.impl.MemberServiceImpl;
import com._4csoft.aof.ui.board.vo.UIBbsVO;
import com._4csoft.aof.ui.board.vo.condition.UIBbsCondition;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.common.UIBindJunit;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.board.web
 * @File    : UIBbsControllerTest.java
 * @Title   : {간단한 프로그램의 명칭을 기록}
 * @date    : 2014. 5. 19.
 * @author  : 김영학
 * @descrption :
 * {상세한 프로그램의 용도를 기록}
 */
@Transactional
public class UIBbsControllerTest extends UIBindJunit{
	
	private final static Log LOG = LogFactory.getLog(UIBbsControllerTest.class); // Junit 콘솔로그 세팅
	
	@Autowired
	private UIBbsController bbsController;
	
	@Autowired
	private BbsService bbsService;

	@Autowired
	private BoardService boardService;
	
	@Autowired
	private MemberServiceImpl memberService;
	
	
	@Test
	public void testList() throws Exception{
		
		LOG.debug("testList junit");
		
		MockHttpServletRequest req = new MockHttpServletRequest(); // 테스트 메서드의 파라미터 셋팅을 위한 Request 객체생성
		MockHttpServletResponse res = new MockHttpServletResponse(); // 테스트 메서드의 파라미터 셋팅을 위한 Response 객체생성
		
		setLoginSession(req, memberService, "admin");
		
		req.setServletPath("/system/bbs/{boardType}/detail.do");
		
		UIBbsCondition condition = new UIBbsCondition();
		
		String boardType = "qna";
		
		UIBbsVO bbs = new UIBbsVO();
		
		bbsController.list(req, res, boardType, bbs, condition);	

	}

	/**
	 * Test method for {@link com._4csoft.aof.ui.board.web.UIBbsController#detail(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, java.lang.String, com._4csoft.aof.ui.board.vo.UIBbsVO, com._4csoft.aof.ui.board.vo.condition.UIBbsCondition)}.
	 * @throws Exception 
	 */
	@Test
	public void testDetail() throws Exception {
		
		LOG.debug("testDetail junit");
		
		MockHttpServletRequest req = new MockHttpServletRequest(); // 테스트 메서드의 파라미터 셋팅을 위한 Request 객체생성
		MockHttpServletResponse res = new MockHttpServletResponse(); // 테스트 메서드의 파라미터 셋팅을 위한 Response 객체생성
		
		setLoginSession(req, memberService, "admin");
		
		req.setServletPath("/system/bbs/{boardType}/detail.do");
		String boardType = "qna";
		UIBbsVO bbs = new UIBbsVO();
		
		bbs.setBbsSeq(384l);
		UIBbsCondition condition = new UIBbsCondition();
		
		bbsController.detail(req, res, boardType, bbs, condition);
			
	}

	/**
	 * Test method for {@link com._4csoft.aof.ui.board.web.UIBbsController#create(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, java.lang.String, com._4csoft.aof.ui.board.vo.UIBbsVO, com._4csoft.aof.ui.board.vo.condition.UIBbsCondition)}.
	 * @throws Exception 
	 */
	@Test
	public void testCreate() throws Exception {
		
		LOG.debug("testCreate junit");
		
		MockHttpServletRequest req = new MockHttpServletRequest(); // 테스트 메서드의 파라미터 셋팅을 위한 Request 객체생성
		MockHttpServletResponse res = new MockHttpServletResponse(); // 테스트 메서드의 파라미터 셋팅을 위한 Response 객체생성
		
		setLoginSession(req, memberService, "admin");
		
		req.setServletPath("/system/bbs/{boardType}/detail.do");
		
		String boardType = "qna";
		
		UIBbsVO bbs = new UIBbsVO();

		UIBbsCondition condition = new UIBbsCondition();
		
		//신규등록페이지 
		bbsController.create(req, res, boardType, bbs, condition);
		
		//답변글 등록페이지
		bbs.setParentSeq(384l);
		bbsController.create(req, res, boardType, bbs, condition);
				
	}

	/**
	 * Test method for {@link com._4csoft.aof.ui.board.web.UIBbsController#edit(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, java.lang.String, com._4csoft.aof.ui.board.vo.UIBbsVO, com._4csoft.aof.ui.board.vo.condition.UIBbsCondition)}.
	 * @throws Exception 
	 */
	@Test
	public void testEdit() throws Exception{
		
		LOG.debug("testEdit junit");
		
		MockHttpServletRequest req = new MockHttpServletRequest(); // 테스트 메서드의 파라미터 셋팅을 위한 Request 객체생성
		MockHttpServletResponse res = new MockHttpServletResponse(); // 테스트 메서드의 파라미터 셋팅을 위한 Response 객체생성
		
		setLoginSession(req, memberService, "admin");
		
		req.setServletPath("/system/bbs/{boardType}/detail.do");
		
		String boardType = "qna";
		
		UIBbsVO bbs = new UIBbsVO();
	
		UIBbsCondition condition = new UIBbsCondition();
		
		try {
			//필수데이터 없는 에러발생
			bbsController.edit(req, res, boardType, bbs, condition);
		} catch (Exception e) {
			
			bbs.setBbsSeq(384l);
			bbsController.edit(req, res, boardType, bbs, condition);
		}
		
	}
	
	
	/**
	 * Test method for {@link com._4csoft.aof.ui.board.web.UIBbsController#list(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, java.lang.String, com._4csoft.aof.ui.board.vo.UIBbsVO)}.
	 * @throws Exception 
	 */
	@Test
	public void testReplyList() throws Exception {
	
		LOG.debug("testEdit junit");
		
		MockHttpServletRequest req = new MockHttpServletRequest(); // 테스트 메서드의 파라미터 셋팅을 위한 Request 객체생성
		MockHttpServletResponse res = new MockHttpServletResponse(); // 테스트 메서드의 파라미터 셋팅을 위한 Response 객체생성
		
		setLoginSession(req, memberService, "admin");
		
		req.setServletPath("/system/bbs/{boardType}/detail.do");
		
		String boardType = "qna";
		
		UIBbsVO bbs = new UIBbsVO();
		bbs.setBbsSeq(384l); //답변글 없는 게시글
		bbsController.list(req, res, boardType, bbs);
		
		bbs.setBbsSeq(375l); //답변글 있는 게시글
		bbsController.list(req, res, boardType, bbs);
		
	}

	/**
	 * Test method for {@link com._4csoft.aof.ui.board.web.UIBbsController#insert(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com._4csoft.aof.ui.board.vo.UIBbsVO, com._4csoft.aof.ui.infra.vo.UIAttachVO)}.
	 * @throws Exception 
	 */
	@Test
	public void testInsert() throws Exception {
		
		LOG.debug("testInsert junit");
		
		MockHttpServletRequest req = new MockHttpServletRequest(); // 테스트 메서드의 파라미터 셋팅을 위한 Request 객체생성
		MockHttpServletResponse res = new MockHttpServletResponse(); // 테스트 메서드의 파라미터 셋팅을 위한 Response 객체생성
		
		setLoginSession(req, memberService, "admin");
		
		req.setServletPath("/system/bbs/{boardType}/detail.do");
		req.setParameter("boardType", "notice");
		
		//등록 파라미터 셋팅
		UIBbsVO bbs = new UIBbsVO();
		bbs.setBoardSeq(1l);
		bbs.setParentSeq(0l);
		bbs.setGroupLevel(1l);
		bbs.setBbsTitle("Junit TEST 공지");
		bbs.setDescription("Junit 테스트 공지합니다");
		bbs.setBbsTypeCd("BBS_TYPE_NOTICE");
		bbs.setHtmlYn("Y");
		
		UIAttachVO attach = new UIAttachVO();
		
		bbsController.insert(req, res, bbs, attach);
	}

	/**
	 * Test method for {@link com._4csoft.aof.ui.board.web.UIBbsController#update(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com._4csoft.aof.ui.board.vo.UIBbsVO, com._4csoft.aof.ui.infra.vo.UIAttachVO)}.
	 */
	@Test
	public void testUpdate() {
		fail("Not yet implemented");
	}

	/**
	 * Test method for {@link com._4csoft.aof.ui.board.web.UIBbsController#delete(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com._4csoft.aof.ui.board.vo.UIBbsVO)}.
	 */
	@Test
	public void testDelete() {
		fail("Not yet implemented");
	}

	/**
	 * Test method for {@link com._4csoft.aof.ui.board.web.UIBbsController#deletelist(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com._4csoft.aof.ui.board.vo.UIBbsVO)}.
	 */
	@Test
	public void testDeletelist() {
		fail("Not yet implemented");
	}

}
