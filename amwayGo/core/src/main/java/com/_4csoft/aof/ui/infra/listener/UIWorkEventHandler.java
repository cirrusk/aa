/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.listener;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationListener;
import org.springframework.security.core.session.SessionInformation;

import com._4csoft.aof.infra.service.BookmarkService;
import com._4csoft.aof.infra.service.MessageSendService;
import com._4csoft.aof.infra.support.listener.WorkEvent;
import com._4csoft.aof.infra.support.security.SessionRegistry;
import com._4csoft.aof.infra.vo.MemberVO;

/**
 * @Project : aof5-infra
 * @Package : com._4csoft.aof.ui.infra.listener
 * @File : UIWorkEventHandler.java
 * @Title : 이벤트 핸들러
 * @date : 2014. 6. 11.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIWorkEventHandler implements ApplicationListener<WorkEvent> {
	protected final Log log = LogFactory.getLog(getClass());

	@Resource (name = "sessionRegistry")
	private SessionRegistry sessionRegistry;

	/**
	 * 각 EventID 별로 작업을 한다.
	 */
	public void onApplicationEvent(WorkEvent event) {
		String eventId = event.getEventId();

		if (MessageSendService.class.getName().equals(eventId)) {
			// 현재 로그인된 사용자의 Principals 를 가져온다.
			for (Object principal : sessionRegistry.getAllPrincipals()) {
				// 중복 세션(sessionIDs)이 존재하므로
				for (SessionInformation session : sessionRegistry.getAllSessions(principal, false)) {
					if (session.isExpired() == false) {
						setSession(session.getPrincipal(), event);
					}
				}
			}

		} else if (BookmarkService.class.getName().equals(eventId)) {
			// 현재 로그인된 사용자의 Principals 를 가져온다.
			for (Object principal : sessionRegistry.getAllPrincipals()) {
				// 중복 세션(sessionIDs)이 존재하므로
				for (SessionInformation session : sessionRegistry.getAllSessions(principal, false)) {
					if (session.isExpired() == false) {
						MemberVO sessionMember = (MemberVO)principal;
						MemberVO remoteMember = (MemberVO)event.getSource();
						sessionMember.setBookmarks(remoteMember.getBookmarks());
					}
				}
			}
		} else {
			log.warn("A eventId don`t have value.");
		}

		log.debug("Sync of session is successed.");
	}

	/**
	 * 
	 * 메시지 세션값을 변경한다.
	 * 
	 * @param principal
	 * @param event
	 */
	@SuppressWarnings ("unchecked")
	private void setSession(Object principal, WorkEvent event) {

		if (event.getSource() instanceof MemberVO) {
			MemberVO remoteMember = (MemberVO)event.getSource();
			MemberVO sessionMember = (MemberVO)principal;

			log.debug("RemoteIP is " + sessionMember.getRegIp());

			// 기존 쪽지수 +- 1 증가한다.
			int memoCount = sessionMember.getMemoCount() + remoteMember.getMemoCount();

			if (memoCount < 1) {
				sessionMember.setMemoCount(0);
			} else {
				sessionMember.setMemoCount(memoCount);
			}
		} else {
			for (MemberVO remoteMember : (List<MemberVO>)event.getSource()) {
				MemberVO sessionMember = (MemberVO)principal;

				log.debug("RemoteIP is " + sessionMember.getRegIp());

				// 기존 쪽지수 + 1 증가한다.
				if (sessionMember.getMemberSeq().equals(remoteMember.getMemberSeq())) {

					int memoCount = sessionMember.getMemoCount() + remoteMember.getMemoCount();

					if (memoCount < 1) {
						sessionMember.setMemoCount(0);
					} else {
						sessionMember.setMemoCount(memoCount);
					}

				}
			}
		}
	}
}
