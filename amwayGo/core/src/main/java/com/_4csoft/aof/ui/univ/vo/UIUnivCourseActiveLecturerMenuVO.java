/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseActiveLecturerMenuVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseActiveLecturerMenuVO.java
 * @Title : 개설과목 교강사 메뉴
 * @date : 2014. 2. 26.
 * @author : 김현우
 * @descrption : 개설과목 교강사 메뉴
 */
public class UIUnivCourseActiveLecturerMenuVO extends UnivCourseActiveLecturerMenuVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 멀티 수정 처리 : 개설과목 교강사 일련번호 */
	private Long[] courseActiveProfSeqs;

	/** 멀티 수정 처리 : 메뉴시퀀스 */
	private Long[] menuSeqs;

	/** 멀티 수정 처리 : 변경된 CRUD 데이터 */
	private String[] cruds;

	/** 멀티 수정 처리 : 구 CRUD 데이터 */
	private String[] oldCruds;

	public Long[] getCourseActiveProfSeqs() {
		return courseActiveProfSeqs;
	}

	public void setCourseActiveProfSeqs(Long[] courseActiveProfSeqs) {
		this.courseActiveProfSeqs = courseActiveProfSeqs;
	}

	public Long[] getMenuSeqs() {
		return menuSeqs;
	}

	public void setMenuSeqs(Long[] menuSeqs) {
		this.menuSeqs = menuSeqs;
	}

	public String[] getCruds() {
		return cruds;
	}

	public void setCruds(String[] cruds) {
		this.cruds = cruds;
	}

	public String[] getOldCruds() {
		return oldCruds;
	}

	public void setOldCruds(String[] oldCruds) {
		this.oldCruds = oldCruds;
	}

}
