/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.LoginHistoryVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UILoginHistoryVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILoginHistoryVO extends LoginHistoryVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 통계일 */
	private String statisticsDate;

	/** 통계수 */
	private Long statisticsCount;

	/** 통계 전체수 */
	private Long totalCount;

	/** 통계 오늘수 */
	private Long todayCount;

	/** 통계 어제수 */
	private Long yesterdayCount;

	/** 통계 이번달 수 */
	private Long thisMonthCount;

	public String getStatisticsDate() {
		return statisticsDate;
	}

	public void setStatisticsDate(String statisticsDate) {
		this.statisticsDate = statisticsDate;
	}

	public Long getStatisticsCount() {
		return statisticsCount;
	}

	public void setStatisticsCount(Long statisticsCount) {
		this.statisticsCount = statisticsCount;
	}

	public Long getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(Long totalCount) {
		this.totalCount = totalCount;
	}

	public Long getTodayCount() {
		return todayCount;
	}

	public void setTodayCount(Long todayCount) {
		this.todayCount = todayCount;
	}

	public Long getYesterdayCount() {
		return yesterdayCount;
	}

	public void setYesterdayCount(Long yesterdayCount) {
		this.yesterdayCount = yesterdayCount;
	}

	public Long getThisMonthCount() {
		return thisMonthCount;
	}

	public void setThisMonthCount(Long thisMonthCount) {
		this.thisMonthCount = thisMonthCount;
	}

}
