/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

/**
 * @Project : lgaca-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : ExamExampleDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 28.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class ExamExampleDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** cs_exam_example_seq : 문항보기 일련번호 */
	private Long examExampleSeq;

	/** cs_exam_item_seq : 문제문항 일련번호 */
	private Long examItemSeq;

	/** cs_exam_item_example_title */
	private String examItemExampleTitle;

	/** cs_correct_yn */
	private String correctYn;

	/** cs_exma_file_type_cd */
	private String examFileTypeCd;

	/** cs_file_path */
	private String filePath;

	/** cs_file_path_type */
	private String filePathType;

	/** cs_sort_order */
	private Long sortOrder;

	public Long getExamExampleSeq() {
		return examExampleSeq;
	}

	public void setExamExampleSeq(Long examExampleSeq) {
		this.examExampleSeq = examExampleSeq;
	}

	public Long getExamItemSeq() {
		return examItemSeq;
	}

	public void setExamItemSeq(Long examItemSeq) {
		this.examItemSeq = examItemSeq;
	}

	public String getExamItemExampleTitle() {
		return examItemExampleTitle;
	}

	public void setExamItemExampleTitle(String examItemExampleTitle) {
		this.examItemExampleTitle = examItemExampleTitle;
	}

	public String getCorrectYn() {
		return correctYn;
	}

	public void setCorrectYn(String correctYn) {
		this.correctYn = correctYn;
	}

	public String getExamFileTypeCd() {
		return examFileTypeCd;
	}

	public void setExamFileTypeCd(String examFileTypeCd) {
		this.examFileTypeCd = examFileTypeCd;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getFilePathType() {
		return filePathType;
	}

	public void setFilePathType(String filePathType) {
		this.filePathType = filePathType;
	}

	public Long getSortOrder() {
		return sortOrder;
	}

	public void setSortOrder(Long sortOrder) {
		this.sortOrder = sortOrder;
	}

}
