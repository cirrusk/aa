/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.vo;

import java.io.Serializable;

import com._4csoft.aof.lcms.vo.LcmsLearnerDatamodelVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.vo
 * @File : UILcmsLearnerDatamodelVO.java
 * @Title : 학습자 데이터 모델
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UILcmsLearnerDatamodelVO extends LcmsLearnerDatamodelVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** */
	private Long sumSessionTime;

	/** */
	private Long sumAttempt;

	/** */
	private Double sumProgressMeasure;

	/** */
	private Double avgProgressMeasure;

	/** */
	private Long[] datamodelSeqs;

	/** */
	private String[] attempts;

	/** */
	private String[] sessionTimes;

	/** */
	private String[] progressMeasures;

	/** */
	private String[] oldProgressMeasures;

	/** */
	private String[] completionStatuses;

	/** */
	private String[] oldCompletionStatuses;

	/** */
	private Long[] organizationSeqs;

	/** */
	private Long[] itemSeqs;

	public Long getSumSessionTime() {
		return sumSessionTime;
	}

	public void setSumSessionTime(Long sumSessionTime) {
		this.sumSessionTime = sumSessionTime;
	}

	public Long getSumAttempt() {
		return sumAttempt;
	}

	public void setSumAttempt(Long sumAttempt) {
		this.sumAttempt = sumAttempt;
	}

	public Double getSumProgressMeasure() {
		return sumProgressMeasure;
	}

	public void setSumProgressMeasure(Double sumProgressMeasure) {
		this.sumProgressMeasure = sumProgressMeasure;
	}

	public Double getAvgProgressMeasure() {
		return avgProgressMeasure;
	}

	public void setAvgProgressMeasure(Double avgProgressMeasure) {
		this.avgProgressMeasure = avgProgressMeasure;
	}

	public Long[] getDatamodelSeqs() {
		return datamodelSeqs;
	}

	public void setDatamodelSeqs(Long[] datamodelSeqs) {
		this.datamodelSeqs = datamodelSeqs;
	}

	public String[] getAttempts() {
		return attempts;
	}

	public void setAttempts(String[] attempts) {
		this.attempts = attempts;
	}

	public String[] getSessionTimes() {
		return sessionTimes;
	}

	public void setSessionTimes(String[] sessionTimes) {
		this.sessionTimes = sessionTimes;
	}

	public String[] getProgressMeasures() {
		return progressMeasures;
	}

	public void setProgressMeasures(String[] progressMeasures) {
		this.progressMeasures = progressMeasures;
	}

	public String[] getOldProgressMeasures() {
		return oldProgressMeasures;
	}

	public void setOldProgressMeasures(String[] oldProgressMeasures) {
		this.oldProgressMeasures = oldProgressMeasures;
	}

	public String[] getCompletionStatuses() {
		return completionStatuses;
	}

	public void setCompletionStatuses(String[] completionStatuses) {
		this.completionStatuses = completionStatuses;
	}

	public String[] getOldCompletionStatuses() {
		return oldCompletionStatuses;
	}

	public void setOldCompletionStatuses(String[] oldCompletionStatuses) {
		this.oldCompletionStatuses = oldCompletionStatuses;
	}

	public Long[] getOrganizationSeqs() {
		return organizationSeqs;
	}

	public void setOrganizationSeqs(Long[] organizationSeqs) {
		this.organizationSeqs = organizationSeqs;
	}

	public Long[] getItemSeqs() {
		return itemSeqs;
	}

	public void setItemSeqs(Long[] itemSeqs) {
		this.itemSeqs = itemSeqs;
	}

}
