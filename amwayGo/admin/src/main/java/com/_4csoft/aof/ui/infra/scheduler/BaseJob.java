/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.scheduler;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Date;

import javax.annotation.Resource;

import com._4csoft.aof.infra.service.BatchHistoryService;
import com._4csoft.aof.infra.service.BatchService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.LogUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.UIBatchHistoryVO;
import com._4csoft.aof.ui.infra.vo.UIBatchVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.infra.scheduler
 * @File : BaseJob.java
 * @Title : JOB 실행 이력 관리
 * @date : 2014. 06. 05.
 * @author : 류정희
 * @descrption : JOB 실행 이력 관리
 */
public class BaseJob {

	protected final LogUtil logger = new LogUtil("SCHEDULER_LOGGER");

	@Resource (name = "BatchService")
	private BatchService batchService;
	
	@Resource(name = "BatchHistoryService")
	private BatchHistoryService batchHistoryService;
	
	private Long batchSeq;
	private Long batchHistorySeq;
	private String className;
	private Thread selfThread;
	private StringBuffer batchRunLog = null;
	private StringBuffer historyLog = null;
	private Date startDate = null;
	private String startTime = null;
	private String successFlag = "N";
	
	public void batchStart(Long batchSeq, Thread selfThread, String className){
		logger.info("[BaseJob.batchStart] Data Setting Start!!!");
		logger.info("[BaseJob.batchStart] BatchSeq   : " + batchSeq.toString());
		logger.info("[BaseJob.batchStart] ClassName  : " + className);
		logger.info("[BaseJob.batchStart] ThreadName : " + selfThread.getName());
		logger.info("[BaseJob.batchStart] ThreadId   : " + selfThread.getId());
		logger.info("[BaseJob.batchStart] Data Setting End  !!!");
		
		this.batchSeq = batchSeq;
		this.className = className;
		this.selfThread = selfThread;

		starthistory();
	}
	
	public void batchEnd(String successFlag, StringBuffer batchRunLog){
		if("Y".equals(successFlag)){
			this.successFlag = successFlag;
		}
		this.batchRunLog = batchRunLog;
		
		endHistory();
	}
	
	private void starthistory(){
		logger.info("[BaseJob.history] Batch history Start!!!");

		if(StringUtil.isNotEmpty(batchSeq) && StringUtil.isNotEmpty(className)){
			try {
				
				startDate = new Date();
				startTime = DateUtil.getFormatString(startDate, Constants.FORMAT_DBDATETIME);
				
				//Create Start History
				batchHistorySeq = createStartHistory(startTime);
				
			} catch (Exception exception) {
				
				StringWriter errors = new StringWriter();
				exception.printStackTrace(new PrintWriter(errors));
				
				logger.debug("[BaseJob.starthistory] Exception : " + errors.toString());
				
				batchRunLog.append("\n");
				batchRunLog.append("Exception : " + errors.toString());
				
			}
		}
    }
	
	private void endHistory(){
		Date endDate = new Date();
		String endTime = DateUtil.getFormatString(endDate, Constants.FORMAT_DBDATETIME);
		Long runTime = endDate.getTime() - startDate.getTime();
		
		//Create End History
		try {
			createEndStartHistory(successFlag, endTime, runTime);
		} catch (Exception exception) {
			StringWriter errors = new StringWriter();
			exception.printStackTrace(new PrintWriter(errors));
			
			logger.debug("[BaseJob.endHistory] Exception : " + errors.toString());
			
		}
		
		logger.info("[BaseJob.history] Batch history End  !!!");
	}

	private Long createStartHistory(String startTime) throws Exception{
		UIBatchHistoryVO history = new UIBatchHistoryVO();
		
		history.setBatchSeq(batchSeq);
		history.setBatchStartDtime(startTime);
		history.setBatchEndDtime(startTime);
		history.setBatchYn("N");
		history.setBatchLog(startLog(startTime).toString());
		history.setBatchRunningTime(0L);
		
		//system 고정
		history.setMemberSeq(1L);
		history.setRegMemberSeq(1L);
		history.setUpdMemberSeq(1L);
		history.setRegIp("127.0.0.1");
		history.setUpdIp("127.0.0.1");

		return batchHistoryService.insert(history);
	}
	
	private void createEndStartHistory(String success, String endTime, Long runTime) throws Exception{
		UIBatchHistoryVO history = new UIBatchHistoryVO();

		history.setBatchHistorySeq(batchHistorySeq);
		history.setBatchSeq(batchSeq);
		history.setBatchEndDtime(endTime);
		history.setBatchRunningTime(runTime);
		history.setBatchYn(success);
		history.setBatchLog(endLog(endTime, runTime).toString());
		
		//system 고정
		history.setMemberSeq(1L);
		history.setRegMemberSeq(1L);
		history.setUpdMemberSeq(1L);
		history.setRegIp("127.0.0.1");
		history.setUpdIp("127.0.0.1");
		
		batchHistoryService.update(history);
		
		UIBatchVO batch = new UIBatchVO();
		batch.setBatchSeq(batchSeq);
		batch.setBatchRunningTime(runTime);
		batch.setBatchYn(success);
		batch.setBatchCompletetionDtime(startTime);
		
		//system 고정
		batch.setMemberSeq(1L);
		batch.setRegMemberSeq(1L);
		batch.setUpdMemberSeq(1L);
		batch.setRegIp("127.0.0.1");
		batch.setUpdIp("127.0.0.1");
		
		batchService.updateRunData(batch);
	}
	
	private StringBuffer startLog(String startTime){
		historyLog = new StringBuffer();
		historyLog.append("\n");
		
		historyLog.append("============================================================\n");
		historyLog.append("BATCH LOG \n");
		historyLog.append("============================================================\n");
		
		historyLog.append("\n");
		
		historyLog.append("ClassName  : " + className + "\n");
		historyLog.append("BatchSeq   : " + batchSeq.toString() + "\n");
		historyLog.append("StartTime  : " + startTime + "\n");
		historyLog.append("ThreadName : " + selfThread.getName() + "\n");
		historyLog.append("ThreadId   : " + selfThread.getId() + "\n");
		
		historyLog.append("\n");
		historyLog.append("\n");

		return historyLog;
	}
	
	private StringBuffer endLog(String endTime, Long runTime){
		String convertRunTime  = String.format("%1$TM:%1$TS", runTime);
		
		historyLog.append(batchRunLog.toString());
		
		historyLog.append("\n");
		historyLog.append("\n");
		
		historyLog.append("EndTime        : " + endTime + "\n");
		historyLog.append("RunMillisecond : " + runTime + "\n");
		historyLog.append("RunTime        : " + convertRunTime + "\n");
		
		historyLog.append("\n");

		historyLog.append("============================================================\n");
		historyLog.append("BATCH LOG \n");
		historyLog.append("============================================================");

		return historyLog;
	}

}
