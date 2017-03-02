/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.scheduler;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com._4csoft.aof.infra.service.MessageReceiveService;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.scheduler.BaseJob;
import com._4csoft.aof.ui.infra.service.UIEmailSendService;
import com._4csoft.aof.ui.infra.vo.condition.UIMessageSendCondition;
import com._4csoft.aof.ui.infra.vo.resultset.UIMessageReceiveRS;

/**
 * 
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.scheduler
 * @File : UIEmailSendJob.java
 * @Title : 이메일발송 스케쥴러
 * @date : 2014. 6. 20.
 * @author : 김영학
 * @descrption : 발송대상 메세지를 조회하여 Email을 발송한다.
 */
@Component ("UIEmailSendJob")
public class UIEmailSendJob extends BaseJob implements Runnable {

	@Resource (name = "UIEmailSendService")
	private UIEmailSendService emailSendService;

	@Resource (name = "MessageReceiveService")
	private MessageReceiveService messageReceiveservice;

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Runnable#run()
	 */
	public void run() {

		Long batchSeq = 3L;
		String successFlag = "N";
		StringBuffer runLog = null;

		try {
			logger.debug("UIEmailSendJob start");
			
			runLog = new StringBuffer();
			super.batchStart(batchSeq, Thread.currentThread(), getClass().getName());

			// [1]. 메일발송대상 조회
			UIMessageSendCondition condition = new UIMessageSendCondition();
			condition.setCurrentPage(1);
			condition.setPerPage(1000);
			condition.setSrchMessageTypeCd("MESSAGE_TYPE::EMAIL");
			condition.setSrchSendScheduleCd("MESSAGE_SCHEDULE_TYPE::001");

			List<ResultSet> mailReceiveList = messageReceiveservice.getListByReceive(condition);

			// [2]. 발송대상이 존재하는 경우 메일 발송
			if (mailReceiveList != null && mailReceiveList.size() > 0) {

				boolean sendResult = false;
				
				// [3]. 메일발송
				for (int i = 0; i < mailReceiveList.size(); i++) {

					try{
						sendResult = emailSendService.send(mailReceiveList.get(i));
					} catch (Exception e) {
						logger.debug(e.getMessage());
						sendResult = false;
					}

					// 메일발송 성공,실패에 따른 메세지발송상태 업데이트셋팅
					if (sendResult) {
						UIMessageReceiveRS rs = (UIMessageReceiveRS)mailReceiveList.get(i);
						rs.getMessageReceive().setReceiveTypeCd("MESSAGE_RECEIVE_TYPE::002");
						rs.getMessageReceive().setUpdMemberSeq(1L);
						rs.getMessageReceive().setUpdIp("127.0.0.1");

					} else {
						UIMessageReceiveRS rs = (UIMessageReceiveRS)mailReceiveList.get(i);
						rs.getMessageReceive().setReceiveTypeCd("MESSAGE_RECEIVE_TYPE::005");
						rs.getMessageReceive().setUpdMemberSeq(1L);
						rs.getMessageReceive().setUpdIp("127.0.0.1");
						
					}

				}

				// [4]. 메일발송성공 대상 수신상태 업데이트
				for (int i = 0; i < mailReceiveList.size(); i++) {
					
					// 메세지 수신(발송)여부코드 업데이트
					try {
						UIMessageReceiveRS rs = (UIMessageReceiveRS)mailReceiveList.get(i);
						messageReceiveservice.updateMessageReceiveType(rs.getMessageReceive());
					} catch (Exception e) {
						logger.debug(e.getMessage());
					}

				}

			}

			successFlag = "Y";
			logger.debug("UIEmailSendJob end");
		} catch (Exception e) {
			logger.debug("UIEmailSendJob exception");
			logger.debug(e.getMessage());
			runLog.append("UIEmailSendJob exception : " + e.getMessage() + " \n");
			successFlag = "N";
		} finally {
			super.batchEnd(successFlag, runLog);
			runLog = null;
		}
	}
}
