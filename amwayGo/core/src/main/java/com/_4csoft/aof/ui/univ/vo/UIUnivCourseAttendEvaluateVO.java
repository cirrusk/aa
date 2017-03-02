/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseAttendEvaluateVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseAttendEvaluateVO.java
 * @Title : 출석 평가기준
 * @date : 2014. 3. 3.
 * @author : 김현우
 * @descrption : 출석 평가기준
 */
public class UIUnivCourseAttendEvaluateVO extends UnivCourseAttendEvaluateVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 멀티 수정 처리 : 출석구분 */
	private String[] attendTypeCds;

	/** 멀티 수정 처리 : 감점 */
	private Double[] minusScores;

	/** 멀티 수정 처리 : 결석 전환 횟수 */
	private Long[] counts;

	/** 멀티 수정 처리 : 결석 허용 횟수 */
	private Long[] permissionCounts;

	public String[] getAttendTypeCds() {
		return attendTypeCds;
	}

	public void setAttendTypeCds(String[] attendTypeCds) {
		this.attendTypeCds = attendTypeCds;
	}

	public Double[] getMinusScores() {
		return minusScores;
	}

	public void setMinusScores(Double[] minusScores) {
		this.minusScores = minusScores;
	}

	public Long[] getCounts() {
		return counts;
	}

	public void setCounts(Long[] counts) {
		this.counts = counts;
	}

	public Long[] getPermissionCounts() {
		return permissionCounts;
	}

	public void setPermissionCounts(Long[] permissionCounts) {
		this.permissionCounts = permissionCounts;
	}

}
