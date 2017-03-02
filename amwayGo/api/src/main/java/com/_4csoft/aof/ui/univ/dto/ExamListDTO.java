/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;
import java.util.List;

/**
 * @Project : lgaca-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : ExamListDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 27.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class ExamListDTO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/** cs_course_master_seq : 교과목 일련번호 */
	private Long courseMasterSeq;

	private Long examSeq;

	/** 문제저장시 사용할 변수 examItemVO */
	private Long examItemSeq;

	/** 문제저장시 사용할 변수 examItemVO */
	private String examItemTitle;

	/** 문제저장시 사용할 변수 examItemVO */
	private String examItemTypeCd;
	private String examItemType;

	/** 문제저장시 사용할 변수 examItemVO */
	private String examItemDifficultyCd;
	private String examItemDifficulty;
	// 문항 Example
	private List<ExamExampleDTO> lisExamExample;

	public Long getCourseMasterSeq() {
		return courseMasterSeq;
	}

	public void setCourseMasterSeq(Long courseMasterSeq) {
		this.courseMasterSeq = courseMasterSeq;
	}

	public Long getExamSeq() {
		return examSeq;
	}

	public void setExamSeq(Long examSeq) {
		this.examSeq = examSeq;
	}

	public Long getExamItemSeq() {
		return examItemSeq;
	}

	public void setExamItemSeq(Long examItemSeq) {
		this.examItemSeq = examItemSeq;
	}

	public String getExamItemTitle() {
		return examItemTitle;
	}

	public void setExamItemTitle(String examItemTitle) {
		this.examItemTitle = examItemTitle;
	}

	public String getExamItemTypeCd() {
		return examItemTypeCd;
	}

	public void setExamItemTypeCd(String examItemTypeCd) {
		this.examItemTypeCd = examItemTypeCd;
	}

	public String getExamItemDifficultyCd() {
		return examItemDifficultyCd;
	}

	public void setExamItemDifficultyCd(String examItemDifficultyCd) {
		this.examItemDifficultyCd = examItemDifficultyCd;
	}

	public String getExamItemType() {
		return examItemType;
	}

	public void setExamItemType(String examItemType) {
		this.examItemType = examItemType;
	}

	public String getExamItemDifficulty() {
		return examItemDifficulty;
	}

	public void setExamItemDifficulty(String examItemDifficulty) {
		this.examItemDifficulty = examItemDifficulty;
	}

	public List<ExamExampleDTO> getLisExamExample() {
		return lisExamExample;
	}

	public void setLisExamExample(List<ExamExampleDTO> lisExamExample) {
		this.lisExamExample = lisExamExample;
	}
}
