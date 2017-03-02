/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.scheduler;

import org.springframework.stereotype.Component;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.scheduler
 * @File : InfraJob.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 6. 7.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Component ("UIInfraJob")
public class InfraJob extends BaseJob implements Runnable {
	
	// 배치에서 사용되는 어노테이션, 전역변수 추가 영역 시작 ----------------------------------------
	
	
	// 배치에서 사용되는 어노테이션, 전역변수 추가 영역 종료 ----------------------------------------

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Runnable#run()
	 */
	public void run() {
		
		// cs_batch 테이블에 등록한 정보의 cs_batch_seq 선언
		Long batchSeq = 1L;
		
		// 배치 성공 실패 변수 선언
		String successFlag = "N";
		
		// DB에 저장할 배치 로그 선언
		StringBuffer runLog = null;
		
		try {
			
			// logger 형태의 로그는 파일로 생성됩니다.
			logger.debug("UIInfraJob start");
			
			// 스케줄에 의해 INSTANCE가 생성되어 있어 전역변수가 공유됩니다.
			// run이 실행될때 마다 runLog를 초기화 해야 합니다.
			runLog = new StringBuffer();
			
			// DB에 저장할 배치 정보를 상속클래스에 전달하기 위해 batchStart 메소드를 실행합니다.
			// extends BaseJob 선언이 필요합니다.
			super.batchStart(batchSeq, Thread.currentThread(), getClass().getName());
			
			
			// 배치에서 수행되는 로직 추가 영역 시작 ----------------------------------------
			
			
			// runLog.append 형태의 로그는 DB에 저장됩니다.
			runLog.append("UIInfraJob run ....");
			Thread.sleep(5 * 1000);
			
			
			// 배치에서 수행되는 로직 추가 영역 종료 ----------------------------------------

			
			// 배치가 정상적으로 수행되었으면 배치 성공 실패 변수를 변경합니다.
			successFlag = "Y";
			
			logger.debug("UIInfraJob end");
			
		} catch (Exception e) {
			
			// 배치의 오류를 로그에 저장합니다.
			logger.debug("UIInfraJob exception : " + e.getMessage());
			runLog.append("UIInfraJob exception : " + e.getMessage());
			
			// 배치가 비정상적으로 수행되었으면 배치 성공 실패 변수를 변경합니다.
			successFlag = "N";
		
		} finally {
			
			// DB에 저장할 배치 정보를 상속클래스에 전달하기 위해 batchEnd 메소드를 실행합니다.
			// extends BaseJob 선언이 필요합니다.
			super.batchEnd(successFlag, runLog);
			
			// 배치 수행 로그 초기화
			runLog = null;
			
		}	
	}
	
}
