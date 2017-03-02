/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseActiveLecturerVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseActiveLecturerVO.java
 * @Title : 개설과목 교강사 VO
 * @date : 2014. 2. 26.
 * @author : 김현우
 * @descrption : 개설과목 교강사 VO
 */
public class UIUnivCourseActiveLecturerVO extends UnivCourseActiveLecturerVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 개설과목 교강사 다중삭제 변수 */
	private Long[] courseActiveProfSeqs;

	/** 개설과목 교강사 다중등록 멤버변수 */
	private Long[] memberSeqs;

	private String hrPractice;
	private String externelPractice;
	private String panelDiscussion;

	public Long[] getCourseActiveProfSeqs() {
		return courseActiveProfSeqs;
	}

	public void setCourseActiveProfSeqs(Long[] courseActiveProfSeqs) {
		this.courseActiveProfSeqs = courseActiveProfSeqs;
	}

	public Long[] getMemberSeqs() {
		return memberSeqs;
	}

	public void setMemberSeqs(Long[] memberSeqs) {
		this.memberSeqs = memberSeqs;
	}

	public String getHrPractice() {
		return hrPractice;
	}

	public void setHrPractice(String hrPractice) {
		this.hrPractice = hrPractice;
	}

	public String getExternelPractice() {
		return externelPractice;
	}

	public void setExternelPractice(String externelPractice) {
		this.externelPractice = externelPractice;
	}

	public String getPanelDiscussion() {
		return panelDiscussion;
	}

	public void setPanelDiscussion(String panelDiscussion) {
		this.panelDiscussion = panelDiscussion;
	}

}
