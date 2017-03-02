package com._4csoft.aof.ui.api.dto;

import java.io.Serializable;

public class MyCourseDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String applyType;
	private String courseActiveTitle;
	private Long courseActiveSeq;
	private Long courseApplySeq;
	private String studyStartDate;
	private String studyEndDate;
	private String resumeEndDate;
	private String resumeYn;
	private String cancelYn;
	private Double avgProgressMeasure;
	private String categoryString;
	private String categoryTypeCd;
	
	public String getApplyType() {
		return applyType;
	}
	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}
	public String getCourseActiveTitle() {
		return courseActiveTitle;
	}
	public void setCourseActiveTitle(String courseActiveTitle) {
		this.courseActiveTitle = courseActiveTitle;
	}
	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}
	public void setCourseActiveSeq(Long courseActiveSeq) {
		this.courseActiveSeq = courseActiveSeq;
	}
	public Long getCourseApplySeq() {
		return courseApplySeq;
	}
	public void setCourseApplySeq(Long courseApplySeq) {
		this.courseApplySeq = courseApplySeq;
	}
	public String getStudyStartDate() {
		return studyStartDate;
	}
	public void setStudyStartDate(String studyStartDate) {
		this.studyStartDate = studyStartDate;
	}
	public String getStudyEndDate() {
		return studyEndDate;
	}
	public void setStudyEndDate(String studyEndDate) {
		this.studyEndDate = studyEndDate;
	}
	public String getResumeEndDate() {
		return resumeEndDate;
	}
	public void setResumeEndDate(String resumeEndDate) {
		this.resumeEndDate = resumeEndDate;
	}
	public String getResumeYn() {
		return resumeYn;
	}
	public void setResumeYn(String resumeYn) {
		this.resumeYn = resumeYn;
	}
	public String getCancelYn() {
		return cancelYn;
	}
	public void setCancelYn(String cancelYn) {
		this.cancelYn = cancelYn;
	}
	public Double getAvgProgressMeasure() {
		return avgProgressMeasure;
	}
	public void setAvgProgressMeasure(Double avgProgressMeasure) {
		this.avgProgressMeasure = avgProgressMeasure;
	}
	public String getCategoryString() {
		return categoryString;
	}
	public void setCategoryString(String categoryString) {
		this.categoryString = categoryString;
	}
	public String getCategoryTypeCd() {
		return categoryTypeCd;
	}
	public void setCategoryTypeCd(String categoryTypeCd) {
		this.categoryTypeCd = categoryTypeCd;
	}
	
}
