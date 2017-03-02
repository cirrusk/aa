package com._4csoft.aof.ui.univ.dto;

import java.util.List;

import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.CodeVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseApplyRS;

public class CourseApplyDTO {
	
	private Long courseApplySeq;
	private Long courseActiveSeq;
	private String yearTerm;
	private String year;
	private Long courseMasterSeq;
	private String courseActiveTitle;
	private String studyStartDate;
	private String studyEndDate;
	private String completeYn;
	private String categoryTypeCd;
	private String categoryTypeCdValue;
	private String courseTypeCd;
	private String courseTypeCdValue;
	private Double avgProgressMeasure;
		
	public CourseApplyDTO(UIUnivCourseApplyRS rs, List<CodeVO> categoryCodeList, List<CodeVO> courseCodeList) {
		this.courseApplySeq = rs.getApply().getCourseApplySeq();
		this.courseActiveSeq = rs.getApply().getCourseActiveSeq();
		this.yearTerm = rs.getApply().getYearTerm();
		this.year =  StringUtil.substring(rs.getApply().getYearTerm(), 0, 4); 
		this.courseMasterSeq = rs.getApply().getCourseMasterSeq();
		this.courseActiveTitle = rs.getActive().getCourseActiveTitle();
		this.studyStartDate = rs.getActive().getStudyStartDate();
		this.studyEndDate = rs.getActive().getStudyEndDate();
		this.completeYn = rs.getApply().getCompletionYn();
		this.categoryTypeCd = rs.getCategory().getCategoryTypeCd();
		if(categoryCodeList != null && categoryCodeList.size() > 0){
			for(int index = 0; index < categoryCodeList.size(); index++){
				if(this.categoryTypeCd.equals(categoryCodeList.get(index).getCode())){
					this.categoryTypeCdValue = categoryCodeList.get(index).getCodeName();
					break;
				}
			}
		}else{
			this.categoryTypeCdValue = "";
		}
		
		this.courseTypeCd = rs.getActive().getCourseTypeCd();
		if(courseCodeList != null && courseCodeList.size() > 0){
			for(int index = 0; index < courseCodeList.size(); index++){
				if(this.courseTypeCd.equals(courseCodeList.get(index).getCode())){
					this.courseTypeCdValue = courseCodeList.get(index).getCodeName();
					break;
				}
			}
		}else{
			this.courseTypeCdValue = "";
		}
		
		this.avgProgressMeasure = rs.getApply().getAvgProgressMeasure();
	}

	public Long getCourseApplySeq() {
		return courseApplySeq;
	}

	public Long getCourseActiveSeq() {
		return courseActiveSeq;
	}

	public String getYearTerm() {
		return yearTerm;
	}

	public String getYear() {
		return year;
	}

	public Long getCourseMasterSeq() {
		return courseMasterSeq;
	}

	public String getCourseActiveTitle() {
		return courseActiveTitle;
	}

	public String getStudyStartDate() {
		return studyStartDate;
	}

	public String getStudyEndDate() {
		return studyEndDate;
	}

	public String getCompleteYn() {
		return completeYn;
	}

	public String getCategoryTypeCd() {
		return categoryTypeCd;
	}

	public String getCategoryTypeCdValue() {
		return categoryTypeCdValue;
	}

	public String getCourseTypeCd() {
		return courseTypeCd;
	}

	public String getCourseTypeCdValue() {
		return courseTypeCdValue;
	}

	public Double getAvgProgressMeasure() {
		return avgProgressMeasure;
	}
	
}
