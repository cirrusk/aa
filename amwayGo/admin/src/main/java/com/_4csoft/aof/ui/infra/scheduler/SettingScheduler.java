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
import java.util.List;
import java.util.Map;
import java.util.concurrent.ScheduledFuture;

import javax.annotation.Resource;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Component;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;

import com._4csoft.aof.infra.service.BatchService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.ConfigUtil;
import com._4csoft.aof.infra.support.util.LogUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIBatchVO;
import com._4csoft.aof.ui.infra.vo.resultset.UIBatchRS;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.scheduler
 * @File : SettingScheduler.java
 * @Title : Setting Scheduler
 * @date : 2013. 5. 6.
 * @author : 김종규
 * @descrption : Setting에서 설정한 job schedule을 실행한다.
 */
@Component ("UISettingScheduler")
public class SettingScheduler {
	protected final LogUtil logger = new LogUtil("SCHEDULER_LOGGER");
	
	@Resource (name = "BatchService")
	private BatchService batchService;

	@Resource (name = "UIThreadPoolTaskScheduler")
	protected ThreadPoolTaskScheduler tps;

	@SuppressWarnings ("rawtypes")
	protected Map<String, ScheduledFuture> scheduled = new HashMap<String, ScheduledFuture>();

	protected ConfigUtil config = ConfigUtil.getInstance();

	@SuppressWarnings ("rawtypes")
	@Scheduled (fixedDelay = 86400000)
	public void run() {
		try {
			logger.debug("SettingScheduler run");
			WebApplicationContext context = ContextLoader.getCurrentWebApplicationContext();

			String contextName = context.getServletContext().getServletContextName();
			if ("TRUE".equalsIgnoreCase(System.getProperty(Constants.SCHEDULE_USE)) == true) {
				logger.debug("ServletContextName[" + contextName + "] prepare a schedule.");
			} else {
				logger.debug("ServletContextName[" + contextName + "] is not scheduling.");
				return;
			}

			Iterator<String> iterator = scheduled.keySet().iterator();
			while (iterator.hasNext()) {
				String key = (String)iterator.next();
				ScheduledFuture sf = scheduled.get(key);
				if (sf != null) {
					sf.cancel(true);
				}
			}

			tps.setPoolSize(10);

			UIBatchVO vo = new UIBatchVO();
			vo.setScheduleReload("Y");
			List<ResultSet> list = batchService.getList(vo);

			if (list != null) {
				logger.debug("batchService jobSchedule is [" + list.size() + "]");
				boolean scheduleSetting = false;
				
				for (ResultSet data : list) {
					UIBatchRS jobData = (UIBatchRS)data;
					String jobs = jobData.getBatch().getBatchSchedule();
					String jobId = jobData.getBatch().getBatchId();
					
					logger.debug("jobSchedule info [JobId : " + jobId + "], [Schedule : " + jobs + "]");
					logger.debug("jobSchedule info [EditYn : " + jobData.getBatch().getEditYn() + "], [StatusCd : " + jobData.getBatch().getBatchStatusCd() + "]");
					
					if("Y".equals(jobData.getBatch().getEditYn()) && "BATCH_STATUS::RUN".equals(jobData.getBatch().getBatchStatusCd())){
						// 스케줄 적용
						scheduleSetting = true;
					} else if("Y".equals(jobData.getBatch().getEditYn()) && "BATCH_STATUS::STOP".equals(jobData.getBatch().getBatchStatusCd())){
						// 스케줄 제거
						if(scheduled.get(jobId) != null){
							scheduled.remove(jobId);
							logger.debug("setting remove - [" + jobs + "]");
						}
						scheduleSetting = false;
					} else if("N".equals(jobData.getBatch().getEditYn()) && "BATCH_STATUS::RUN".equals(jobData.getBatch().getBatchStatusCd())){
						if(scheduled.get(jobId) != null){
							// 스케줄 미적용
							scheduleSetting = false;
						}else{
							// 스케줄 생성
							scheduleSetting = true;
						}
					}

					// 반영 완료 적용
					jobData.getBatch().setEditYn("N");
					batchService.updateEditFlag(jobData.getBatch());
					
					if(scheduleSetting == true){
						String[] prop = jobs.split("=");
						if (prop != null && prop.length == 3) {
							logger.debug("setting is - [" + jobs + "]");
							int time = -1;
							String cron = "";
							if ("time".equalsIgnoreCase(prop[1]) || "delay".equalsIgnoreCase(prop[1])) {
								try {
									time = Integer.parseInt(prop[2]);
								} catch (Exception e) {
									continue;
								}
							} else if ("cron".equalsIgnoreCase(prop[1])) {
								cron = prop[2];
							} else {
								continue;
							}

							Runnable runable = null;
							
							try {
								runable = (Runnable)context.getBean(prop[0]);
							} catch (Exception exception) {
								StringWriter errors = new StringWriter();
								exception.printStackTrace(new PrintWriter(errors));
								logger.debug("Job runable exception : " + errors.toString());
							}

							if (runable == null) {
								logger.debug("Bean id " + prop[0] + " is null");
								continue;
							}

							if (time < 0 && StringUtil.isNotEmpty(cron)) { // cron
								scheduled.put(prop[0], tps.schedule(runable, new CronTrigger(cron)));

							} else if (time > 0 && "time".equalsIgnoreCase(prop[1])) { // job 실행을 time 후에 실행
								scheduled.put(prop[0], tps.scheduleAtFixedRate(runable, time * 1000 * 60));

							} else if (time > 0 && "delay".equalsIgnoreCase(prop[1])) { // job 실행이 끝난 후 time 후에 실행
								scheduled.put(prop[0], tps.scheduleWithFixedDelay(runable, time * 1000 * 60));

							} else {
								continue;
							}
						} else {
							logger.debug("setting is invalid - [" + jobs + "]");
						}
					}
				}
			} else {
				logger.debug("batchService jobSchedule is null");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
