/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo.condition;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.infra.vo.condition
 * @File : UIBatchhistoryCondition.java
 * @Title : 배치 이력 관리 Condition
 * @date : 2014. 06. 10
 * @author : 류정희
 * @descrption : 배치 이력 관리 Condition
 */
public class UIBatchHistoryCondition extends SearchConditionVO implements Serializable {
	protected final Log log = LogFactory.getLog(getClass());
	private static final long serialVersionUID = 1L;
	
	private Long srchBatchSeq;
	private String srchStarDate;
	private int srchStarHour;
	private String srchEndDate;
	private int srchEndHour;
	
	public Long getSrchBatchSeq() {
		return srchBatchSeq;
	}
	public void setSrchBatchSeq(Long srchBatchSeq) {
		this.srchBatchSeq = srchBatchSeq;
	}
	public String getSrchStarDate() {
		return srchStarDate;
	}
	public void setSrchStarDate(String srchStarDate) {
		this.srchStarDate = srchStarDate;
	}
	public int getSrchStarHour() {
		return srchStarHour;
	}
	public void setSrchStarHour(int srchStarHour) {
		this.srchStarHour = srchStarHour;
	}
	public String getSrchEndDate() {
		return srchEndDate;
	}
	public void setSrchEndDate(String srchEndDate) {
		this.srchEndDate = srchEndDate;
	}
	public int getSrchEndHour() {
		return srchEndHour;
	}
	public void setSrchEndHour(int srchEndHour) {
		this.srchEndHour = srchEndHour;
	}
	
	@SuppressWarnings ("deprecation")
	public String getSrchStartDtime() {
		String srchStartDtime = null;
		try {
			if(StringUtil.isNotEmpty(srchStarDate)){
				SimpleDateFormat formatter = new SimpleDateFormat(Constants.FORMAT_DATE);
				Date srchDate = formatter.parse(srchStarDate);
				srchDate.setHours(srchStarHour);
				srchDate.setMinutes(0);
				srchDate.setSeconds(0);
				srchStartDtime = DateUtil.getFormatString(srchDate, Constants.FORMAT_DBDATETIME);
			}			
		} catch (Exception exception) {
			log.debug("UIBatchHistoryCondition.getSrchStartDtime error : " + exception.getMessage());
			srchStartDtime = null;
		}
		return srchStartDtime;
	}
	
	@SuppressWarnings ("deprecation")
	public String getSrchEndDtime() {
		String srchEndDtime = null;
		try {
			if(StringUtil.isNotEmpty(srchEndDate)){
				SimpleDateFormat formatter = new SimpleDateFormat(Constants.FORMAT_DATE);
				Date srchDate = formatter.parse(srchEndDate);
				srchDate.setHours(srchEndHour);
				srchDate.setMinutes(59);
				srchDate.setSeconds(59);
				srchEndDtime = DateUtil.getFormatString(srchDate, Constants.FORMAT_DBDATETIME);
			}			
		} catch (Exception exception) {
			log.debug("UIBatchHistoryCondition.getSrchEndDtime error : " + exception.getMessage());
			srchEndDtime = null;
		}
		return srchEndDtime;
	}

}
