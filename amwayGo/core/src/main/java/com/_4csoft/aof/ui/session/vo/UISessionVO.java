/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.session.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.BaseVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.session.vo
 * @File    : UISessionVO.java
 * @Title   : {간단한 프로그램의 명칭을 기록}
 * @date    : 2015. 8. 17.
 * @author  : 조성훈
 * @descrption :
 * {상세한 프로그램의 용도를 기록}
 */
public class UISessionVO extends BaseVO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/** seq */
	private Long sessionSeq;
	
	/** 시작시간 */
	private String sessionStartDate;
	
	/** 종료시간 */
	private String sessionEndDate;
	
	/** 분류코드 */
	private String classificationCode;
	
	/** 분류명 */
	private String classificationNm;
	
	/** 세션코드 */
	private String sessionCode;
	
	/** 세션명 */
	private String sessionName;
	
	/** 행사장위치 */
	private String eventLocation;
	
	/** 발표자명 */
	private String presenterName;
	
	/** 발표자직함 */
	private String presenterAppellation;
	
	/** 부발표자명 */
	private String subPresenterName;
	
	/** 부발표자직함 */
	private String subPresenterAppellation;
	
	/** 발표자소속 */
	private String presenterAttach;
	
	/** description */
	private String description;

	public Long getSessionSeq() {
		return sessionSeq;
	}

	public void setSessionSeq(Long sessionSeq) {
		this.sessionSeq = sessionSeq;
	}

	public String getSessionStartDate() {
		return sessionStartDate;
	}

	public void setSessionStartDate(String sessionStartDate) {
		this.sessionStartDate = sessionStartDate;
	}

	public String getSessionEndDate() {
		return sessionEndDate;
	}

	public void setSessionEndDate(String sessionEndDate) {
		this.sessionEndDate = sessionEndDate;
	}

	public String getClassificationCode() {
		return classificationCode;
	}

	public void setClassificationCode(String classificationCode) {
		this.classificationCode = classificationCode;
	}

	public String getClassificationNm() {
		return classificationNm;
	}

	public void setClassificationNm(String classificationNm) {
		this.classificationNm = classificationNm;
	}

	public String getSessionCode() {
		return sessionCode;
	}

	public void setSessionCode(String sessionCode) {
		this.sessionCode = sessionCode;
	}

	public String getSessionName() {
		return sessionName;
	}

	public void setSessionName(String sessionName) {
		this.sessionName = sessionName;
	}

	public String getEventLocation() {
		return eventLocation;
	}

	public void setEventLocation(String eventLocation) {
		this.eventLocation = eventLocation;
	}

	public String getPresenterName() {
		return presenterName;
	}

	public void setPresenterName(String presenterName) {
		this.presenterName = presenterName;
	}

	public String getPresenterAppellation() {
		return presenterAppellation;
	}

	public void setPresenterAppellation(String presenterAppellation) {
		this.presenterAppellation = presenterAppellation;
	}

	public String getSubPresenterName() {
		return subPresenterName;
	}

	public void setSubPresenterName(String subPresenterName) {
		this.subPresenterName = subPresenterName;
	}

	public String getSubPresenterAppellation() {
		return subPresenterAppellation;
	}

	public void setSubPresenterAppellation(String subPresenterAppellation) {
		this.subPresenterAppellation = subPresenterAppellation;
	}

	public String getPresenterAttach() {
		return presenterAttach;
	}

	public void setPresenterAttach(String presenterAttach) {
		this.presenterAttach = presenterAttach;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
}
