/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.scheduler;

import java.util.Date;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.ui.infra.scheduler.BaseJob;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivMigEmsDbRS;
import com._4csoft.aof.univ.service.UnivMigEmsDbService;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.scheduler
 * @File : MigemsdbJob.java
 * @Title : 학사 DB 연동 JOB
 * @date : 2014. 06. 10.
 * @author : 류정희
 * @descrption : 학사 DB 연동 JOB
 */
@Component ("UIMigemsdbJob")
public class UIMigemsdbJob extends BaseJob implements Runnable {
	
	@Resource (name = "UnivMigEmsDbService")
	private UnivMigEmsDbService univMigEmsDbService;

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Runnable#run()
	 */
	public void run() {
		
		Long batchSeq = 2L;
		String successFlag = "N";
		StringBuffer runLog = null;
		
		try {
			logger.debug("UIMigemsdbJob start");
			
			runLog = new StringBuffer();
			super.batchStart(batchSeq, Thread.currentThread(), getClass().getName());

			// 학사 DB 연동 정보 조회
			UIUnivMigEmsDbRS detailUnivMigEmsDb = (UIUnivMigEmsDbRS)univMigEmsDbService.getDetail();
			runLog.append("UIMigemsdbJob 학사 DB 연동 정보 조회 완료 \n");
			
			if(detailUnivMigEmsDb != null){
				if(detailUnivMigEmsDb.getUnivMigEmsDb() != null){	
					//연동 기간 비교
					String start = detailUnivMigEmsDb.getUnivMigEmsDb().getStartDtime();
					String end = detailUnivMigEmsDb.getUnivMigEmsDb().getEndDtime();
					String now = DateUtil.getFormatString(new Date(), Constants.FORMAT_DBDATETIME);
					
					if(Long.parseLong(now) >= Long.parseLong(start) && Long.parseLong(now) <= Long.parseLong(end)){
						// 학사 DB 연동 프로시저 호출
						univMigEmsDbService.saveCallSynchronize(detailUnivMigEmsDb.getUnivMigEmsDb());
						runLog.append("UIMigemsdbJob 학사 DB 연동 프로시저 호출 완료 \n");
					}else{
						logger.debug("UIMigemsdbJob message : 연동기간이 아닙니다. 배치를 종료합니다.");
						runLog.append("UIMigemsdbJob 연동기간이 아닙니다. 배치를 종료합니다. \n");
					}
				}
			}

			successFlag = "Y";
			logger.debug("UIMigemsdbJob end");
		} catch (Exception e) {
			logger.debug("UIMigemsdbJob exception");
			logger.debug(e.getMessage());
			runLog.append("UIMigemsdbJob exception : " + e.getMessage() + " \n");
			successFlag = "N";
		} finally {
			super.batchEnd(successFlag, runLog);
			runLog = null;
		}
	}
}
