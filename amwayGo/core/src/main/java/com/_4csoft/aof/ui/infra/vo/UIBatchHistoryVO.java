/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.BatchHistoryVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UIBatchHistoryVO.java
 * @Title : 배치 이력 관리 VO
 * @date : 2014. 06. 03.
 * @author : 류정희
 * @descrption : 배치 이력 관리 VO 
 */
public class UIBatchHistoryVO extends BatchHistoryVO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	public String getDisplayRunningTime() {
		StringBuffer returnValue = new StringBuffer();
		if(StringUtil.isNotEmpty(super.getBatchRunningTime())){
			long time = super.getBatchRunningTime();
			int seconds = (int) (time / 1000) % 60 ;
			int minutes = (int) ((time / (1000*60)) % 60);
			int hours   = (int) ((time / (1000*60*60)) % 24);
			returnValue.append(hours);
			returnValue.append(" hr ");
			returnValue.append(minutes);
			returnValue.append(" min ");
			returnValue.append(seconds);
			returnValue.append(" sec");
		}
		return returnValue.toString();
	}
	
}
