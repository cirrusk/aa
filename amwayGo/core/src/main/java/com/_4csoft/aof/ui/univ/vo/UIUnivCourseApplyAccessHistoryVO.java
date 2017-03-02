/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseApplyAccessHistoryVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseApplyAccessHistoryVO.java
 * @Title : 강의실접근 히스토리
 * @date : 2014. 4. 7.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseApplyAccessHistoryVO extends UnivCourseApplyAccessHistoryVO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/** 통계 수강인원 */
	private Long totalApplyCount;
	
	/** 통계 접속자수 */
	private Long totalAccessCount;
	
	/** 교과목 대표교수이름 */
	private String peofPresidentName;

	/** 교과목 과정유형 및 이슈타입 정보*/
	private String courseTypeName;
	
	public Long getTotalApplyCount() {
		return totalApplyCount;
	}

	public void setTotalApplyCount(Long totalApplyCount) {
		this.totalApplyCount = totalApplyCount;
	}

	public Long getTotalAccessCount() {
		return totalAccessCount;
	}

	public void setTotalAccessCount(Long totalAccessCount) {
		this.totalAccessCount = totalAccessCount;
	}

	public String getPeofPresidentName() {
		return peofPresidentName;
	}

	public void setPeofPresidentName(String peofPresidentName) {
		this.peofPresidentName = peofPresidentName;
	}

	public String getCourseTypeName() {
		return courseTypeName;
	}

	public void setCourseTypeName(String courseTypeName) {
		this.courseTypeName = courseTypeName;
	}

}
