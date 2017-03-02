/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.scheduler;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com._4csoft.aof.infra.service.MemberService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.MailUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.resultset.UIMemberRS;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.infra.scheduler
 * @File : ChangeAdminInfoJob.java
 * @Title : 관리자 정보 변경 배치
 * @date : 2014. 06. 30.
 * @author : 류정희
 * @descrption : 관리자 정보 변경 배치
 */
@Component ("UIChangeAdminInfoJob")
public class ChangeAdminInfoJob extends BaseJob implements Runnable {
	
	@Resource (name = "MemberService")
	private MemberService memberService;
	
	@Resource (name = "MailUtil")
	protected MailUtil mailUtil;

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Runnable#run()
	 */
	public void run() {
		
		Long batchSeq = 4L;
		String successFlag = "N";
		StringBuffer runLog = null;
		Long adminSeq = 1L;
		
		try {
			
			runLog = new StringBuffer();
			
			logger.debug("[UIChangeAdminInfoJob] Start !!!");
			runLog.append("[UIChangeAdminInfoJob] Start !!! \n");
			
			super.batchStart(batchSeq, Thread.currentThread(), getClass().getName());
			
			//관리자 정보 조회
			UIMemberVO member = new UIMemberVO();
			member.setMemberSeq(adminSeq);
			
			UIMemberRS adminInfo = (UIMemberRS)memberService.getDetail(member);
			
			//관리자 정보 변경일 검사
			if(adminInfo != null){
				
				runLog.append("\n");
				runLog.append("[UIChangeAdminInfoJob] AdminInfo Read Start !!! \n");
				
				runLog.append("\n");
				runLog.append("MemberId : " + adminInfo.getMember().getMemberId() + "\n");
				runLog.append("UpdDtime : " + adminInfo.getMember().getUpdDtime() + "\n");
				
				Long diffCount = DateUtil.diffDate(adminInfo.getMember().getUpdDtime(), DateUtil.getToday(Constants.FORMAT_DBDATETIME), Constants.FORMAT_DBDATETIME);
				
				runLog.append("DiffCount : " + diffCount + "\n");

				runLog.append("\n");
				runLog.append("[UIChangeAdminInfoJob] AdminInfo Read End !!! \n");
				
				//관리자 정보 변경
				if(diffCount >= 7L){
					
					runLog.append("\n");
					runLog.append("[UIChangeAdminInfoJob] AdminInfo Change Start !!! \n");
					
					String changeInfo = StringUtil.getRandomString(6);
					
					adminInfo.getMember().setPassword(changeInfo);
					adminInfo.getMember().setMemberSeq(1L);
					adminInfo.getMember().setRegMemberSeq(1L);
					adminInfo.getMember().setUpdMemberSeq(1L);
					adminInfo.getMember().setRegIp("127.0.0.1");
					adminInfo.getMember().setUpdIp("127.0.0.1");
					
					int success = memberService.updatePassword(adminInfo.getMember());
					
					runLog.append("\n");
					runLog.append("[UIChangeAdminInfoJob] AdminInfo Change End !!! \n");
					
					//관리자 정보 변경 메일 발송
					if(success != 0){
						
						runLog.append("\n");
						runLog.append("[UIChangeAdminInfoJob] Mail Send Start !!! \n");
						
						Map<String, String> mailMap = new HashMap<String, String>();
						mailMap.put("노성용", "sungyong2@4csoft.com");
						mailMap.put("김종규", "jkk88@4csoft.com");
						mailMap.put("서진철", "jcseo@4csoft.com");
						mailMap.put("장용기", "yongki@4csoft.com");
						mailMap.put("김현우", "klizalid777@4csoft.com");
						mailMap.put("이한구", "giant194@4csoft.com");
						mailMap.put("류정희", "ryujh@4csoft.com");
						mailMap.put("박정호", "chun32@4csoft.com");
						
						String sender = "AOF5 BATCH SYSTEM";
						String title = "[AOF5DEMO] 관리자 계정정보 변경 메일입니다.";
						
						StringBuffer content = new StringBuffer();
						content.append("AOF5 BATCH SYSTEM 에서 관리자 정보를 변경하였습니다. <br/>");
						content.append("<br/>");
						content.append("관리자 ID : " + adminInfo.getMember().getMemberId() + " <br/>");
						content.append("관리자 PW : " + changeInfo + " <br/>");
						content.append("<br/>");
						content.append("감사합니다. <br/>");
						
						Iterator<String> iterator = mailMap.keySet().iterator();
					    
						while(iterator.hasNext()){
					        String key = (String) iterator.next();
							runLog.append(key + " [" + mailMap.get(key) + "] Mail Send ... ");
							
							/* "받는사람 이메일", "받는사람 이름", "보내는사람 이름", "제목", "내용", "html", "파일" */
							boolean result = mailUtil.send(mailMap.get(key), key, sender, title, content.toString(), "html", null);
							runLog.append("(" + result + ") \n");
					    }
					    
						runLog.append("\n");
						runLog.append("[UIChangeAdminInfoJob] Mail Send End !!! \n");
					}
					
				}else{
					runLog.append("\n");
					runLog.append("[UIChangeAdminInfoJob] AdminInfo Keep !!! \n");
				}
				
			}else{
				runLog.append("\n");
				runLog.append("[UIChangeAdminInfoJob] AdminInfo is Null !!! \n");
			}
			
			successFlag = "Y";
			
			runLog.append("\n");
			runLog.append("[UIChangeAdminInfoJob] End !!! \n");
			logger.debug("[UIChangeAdminInfoJob] End !!!");
			
		} catch (Exception exception) {
			
			StringWriter errors = new StringWriter();
			exception.printStackTrace(new PrintWriter(errors));

			runLog.append("\n");
			runLog.append("[UIChangeAdminInfoJob] Exception : " + errors.toString() + " \n");
			logger.debug("[UIChangeAdminInfoJob] Exception : " + errors.toString());
			
			successFlag = "N";
		
		} finally {
			
			super.batchEnd(successFlag, runLog);
			runLog = null;
			
		}	
	}
	
}
