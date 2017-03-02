/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseHomeworkTargetVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseHomeworkTargetVO.java
 * @Title : 과제 대상자
 * @date : 2014. 3. 4.
 * @author : 김현우
 * @descrption : UnivCourseHomeworkTargetVO.class 를 상속받아 사용
 */
public class UIUnivCourseHomeworkTargetVO extends UnivCourseHomeworkTargetVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 과제 점수 (대상자 보기 팝업에서 사용됨) */
	private Long homeworkScore;

	/** 다중 삭제할 체크키 */
	private Long[] targetApplyCheckkeys;

	/** 다중 등록 할 체크키 */
	private Long[] nonTargetApplyCheckkeys;

	public Long getHomeworkScore() {
		return homeworkScore;
	}

	public void setHomeworkScore(Long homeworkScore) {
		this.homeworkScore = homeworkScore;
	}

	public Long[] getTargetApplyCheckkeys() {
		return targetApplyCheckkeys;
	}

	public void setTargetApplyCheckkeys(Long[] targetApplyCheckkeys) {
		this.targetApplyCheckkeys = targetApplyCheckkeys;
	}

	public Long[] getNonTargetApplyCheckkeys() {
		return nonTargetApplyCheckkeys;
	}

	public void setNonTargetApplyCheckkeys(Long[] nonTargetApplyCheckkeys) {
		this.nonTargetApplyCheckkeys = nonTargetApplyCheckkeys;
	}

}
