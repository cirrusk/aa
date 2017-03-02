/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;
import java.util.ArrayList;

import com._4csoft.aof.univ.vo.UnivCourseApplyAttendVO;

/**
 * 
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseApplyAttendVO.java
 * @Title : 수강생 출석
 * @date : 2014. 3. 13.
 * @author : 김현우
 * @descrption : 수강생 출석
 */
public class UIUnivCourseApplyAttendVO extends UnivCourseApplyAttendVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 이전 출석 상태 다중 업데이트용 */
	private String[] oldAttendTypeCds;

	/** 출석 상태 다중 업데이트용 */
	private String[] attendTypeCds;

	/** 개설과목구성정보 일련번호 다중 업데이트용 */
	private Long[] activeElementSeqs;

	/** 멀티 수정 시 */
	private ArrayList<String> attendTypeCdList;

	/** 출석부 입력 및 업데이트용 수강생 정보 */
	private Long[] courseApplySeqs;

	/** 출석부 입력 및 업데이트용 일련번호 정보 */
	private Long[] courseApplyAttendSeqs;

	public String[] getOldAttendTypeCds() {
		return oldAttendTypeCds;
	}

	public void setOldAttendTypeCds(String[] oldAttendTypeCds) {
		this.oldAttendTypeCds = oldAttendTypeCds;
	}

	public String[] getAttendTypeCds() {
		return attendTypeCds;
	}

	public void setAttendTypeCds(String[] attendTypeCds) {
		this.attendTypeCds = attendTypeCds;
	}

	public Long[] getActiveElementSeqs() {
		return activeElementSeqs;
	}

	public void setActiveElementSeqs(Long[] activeElementSeqs) {
		this.activeElementSeqs = activeElementSeqs;
	}

	public ArrayList<String> getAttendTypeCdList() {
		return attendTypeCdList;
	}

	public void setAttendTypeCdList(ArrayList<String> attendTypeCdList) {
		this.attendTypeCdList = attendTypeCdList;
	}

	public Long[] getCourseApplySeqs() {
		return courseApplySeqs;
	}

	public void setCourseApplySeqs(Long[] courseApplySeqs) {
		this.courseApplySeqs = courseApplySeqs;
	}

	public Long[] getCourseApplyAttendSeqs() {
		return courseApplyAttendSeqs;
	}

	public void setCourseApplyAttendSeqs(Long[] courseApplyAttendSeqs) {
		this.courseApplyAttendSeqs = courseApplyAttendSeqs;
	}

}
