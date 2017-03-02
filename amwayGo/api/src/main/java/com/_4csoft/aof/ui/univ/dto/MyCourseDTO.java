package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.ui.board.dto.SystemBoardDTO;
import com._4csoft.aof.ui.infra.vo.condition.UIAgreementCondition;

public class MyCourseDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	private String applyType;
	private String courseActiveTitle;
	private Long courseActiveSeq;
	private Long courseApplySeq;
	/** cs_course_master_seq : 교과목 일련번호 */
	private Long courseMasterSeq;
	private String studyStartDate;
	private String studyEndDate;
	private String resumeEndDate;
	private String resumeYn;
	private String cancelYn;
	private Double avgProgressMeasure;
	private Long categorySeq;
	private String categoryString;
	private String categoryTypeCd;
	private String categoryType;
	private String courseTypeCd;
	private String courseType;
	private String timeTableUrl;
	private String courseTitle;
	private Long workDay1;
	private Long workDay2;
	/** 시간표 1 */
	private String timetable1;

	/** 시간표 2 */
	private String timetable2;

	/** 시간표 3 */
	private String timetable3;

	/** 시간표 4 */
	private String timetable4;

	/** 시간표 5 */
	private String timetable5;

	/** 시간표 6 */
	private String timetable6;
	
	/** 썸네일 */
	private String thumNail;

	/** 팀프로젝트 최신글 */
	private Long teamBbsNewCnt;

	/** 총 일수 */
	private Long fullDay;
	private Long dDay;
	private List<MyCourseLecturerDTO> lecturerList;
	private List<SystemBoardDTO> boardList;
	
	/** 약관동의 여부*/
	private String courseAgreementYn;
	/** 약관 정보*/
	private List<UIAgreementCondition> agreeList;

	/** HR_PRACTICE */
	private String hrPractice;

	/** EXTERNEL_PRACTICE */
	private String externelPractice;

	/** PANEL_DISCUSSION */
	private String panelDiscussion;

	public Long getTeamBbsNewCnt() {
		return teamBbsNewCnt;
	}

	public void setTeamBbsNewCnt(Long teamBbsNewCnt) {
		this.teamBbsNewCnt = teamBbsNewCnt;
	}

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

	public String getCategoryType() {
		return categoryType;
	}

	public void setCategoryType(String categoryType) {
		this.categoryType = categoryType;
	}

	public String getCourseTypeCd() {
		return courseTypeCd;
	}

	public void setCourseTypeCd(String courseTypeCd) {
		this.courseTypeCd = courseTypeCd;
	}

	public String getCourseType() {
		return courseType;
	}

	public void setCourseType(String courseType) {
		this.courseType = courseType;
	}

	public Long getCourseMasterSeq() {
		return courseMasterSeq;
	}

	public void setCourseMasterSeq(Long courseMasterSeq) {
		this.courseMasterSeq = courseMasterSeq;
	}

	public List<MyCourseLecturerDTO> getLecturerList() {
		return lecturerList;
	}

	public void setLecturerList(List<MyCourseLecturerDTO> lecturerList) {
		this.lecturerList = lecturerList;
	}

	public String getTimeTableUrl() {
		return timeTableUrl;
	}

	public void setTimeTableUrl(String timeTableUrl) {
		this.timeTableUrl = timeTableUrl;
	}

	public Long getCategorySeq() {
		return categorySeq;
	}

	public void setCategorySeq(Long categorySeq) {
		this.categorySeq = categorySeq;
	}

	public String getCourseTitle() {
		return courseTitle;
	}

	public void setCourseTitle(String courseTitle) {
		this.courseTitle = courseTitle;
	}

	public Long getdDay() {
		return dDay;
	}

	public void setdDay(Long dDay) {
		this.dDay = dDay;
	}

	public List<SystemBoardDTO> getBoardList() {
		return boardList;
	}

	public void setBoardList(List<SystemBoardDTO> boardList) {
		this.boardList = boardList;
	}
	
	public List<UIAgreementCondition> getAgreeList() {
		return agreeList;
	}

	public void setAgreeList(List<UIAgreementCondition> agreeList) {
		this.agreeList = agreeList;
	}

	public Long getFullDay() {
		return fullDay;
	}

	public void setFullDay(Long fullDay) {
		this.fullDay = fullDay;
	}

	public Long getWorkDay1() {
		return workDay1;
	}

	public void setWorkDay1(Long workDay1) {
		this.workDay1 = workDay1;
	}

	public Long getWorkDay2() {
		return workDay2;
	}

	public void setWorkDay2(Long workDay2) {
		this.workDay2 = workDay2;
	}

	public String getTimetable1() {
		return timetable1;
	}

	public void setTimetable1(String timetable1) {
		this.timetable1 = timetable1;
	}

	public String getTimetable2() {
		return timetable2;
	}

	public void setTimetable2(String timetable2) {
		this.timetable2 = timetable2;
	}

	public String getTimetable3() {
		return timetable3;
	}

	public void setTimetable3(String timetable3) {
		this.timetable3 = timetable3;
	}

	public String getTimetable4() {
		return timetable4;
	}

	public void setTimetable4(String timetable4) {
		this.timetable4 = timetable4;
	}

	public String getTimetable5() {
		return timetable5;
	}

	public void setTimetable5(String timetable5) {
		this.timetable5 = timetable5;
	}

	public String getTimetable6() {
		return timetable6;
	}

	public void setTimetable6(String timetable6) {
		this.timetable6 = timetable6;
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
	
	public String getThumNail() {
		return thumNail;
	}

	public void setThumNail(String thumNail) {
		this.thumNail = thumNail;
	}

	public String getCourseAgreementYn() {
		return courseAgreementYn;
	}

	public void setCourseAgreementYn(String courseAgreementYn) {
		this.courseAgreementYn = courseAgreementYn;
	}
}
