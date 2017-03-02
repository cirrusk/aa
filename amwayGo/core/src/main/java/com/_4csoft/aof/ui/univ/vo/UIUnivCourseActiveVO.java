/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.infra.vo.AttachVO;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.univ.vo.UnivCourseActiveVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseActiveVO.java
 * @Title : 개설 과목
 * @date : 2014. 2. 25.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveVO extends UnivCourseActiveVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 바로가기 개설과목일련번호 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 */
	private String shortcutCategoryTypeCd;

	/** 바로가기 년도학기 */
	private String shortcutYearTerm;

	/** 개설과목 수강신청 확인 카운트 */
	private Long applyCount;

	/** 교과목 일련번호 Array */
	private Long[] courseMasterSeqs;

	/** 개설과목 일련번호 Array */
	private Long[] courseActiveSeqs;

	/** 소속학과 Array */
	private Long[] categoryOrganizationSeqs;

	/** 교과목 명 Array */
	private String[] courseActiveTitles;

	/** 년도학기 */
	private String yeatTerm;

	/** 분류 부모일련번호 */
	private Long parentSeq;

	/** 개설 과목 ResultSet */
	private ResultSet courseActiveRS;

	/** 분반 Array */
	private Long[] divisions;

	/** 이전 학기 */
	private String beforeYearTerm;

	/** 대상 개설과목 일련번호 Array */
	private Long[] targetCourseActiveSeqs;

	/** 원본 개설과목 일련번호 Array */
	private Long[] sourceCourseActiveSeqs;

	/** 구성정보 복사요소 */
	private String[] courseElementTypes;

	/** 구성정보요소 */
	private String courseElementType;

	/** 분반수 */
	private Long divisionCount;

	/** 첨부파일 목록 */
	private List<AttachVO> attachList;

	/** 학습 일수 */
	private Long workDay;

	/** 학습 일수(몇박) */
	private Long workDay1;

	/** 학습 일수(몇일) */
	private Long workDay2;

	/** 총 일수 */
	private Long fullDay;

	/** 평일을 제외한 디데이 */
	private Long dDay;

	/** 과정 진행 상태 */
	private String applyType;

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
	
	/** 인재개발대회 여부 */
	private String competitionYn;
	
	/** 그룹방 제목 */
	private String courseGroupTitle;
	
	/** 정보 폐기 기간 */
	private String expireStartDate;
	
	/** 정보 폐기 기간 */
	private String expireEndDate;
	
	/** 썸네일 */
	private String thumNail;
	
	/** 약관동의목록 1~3 */
	private Long agreementSeq1;
	private Long agreementSeq2;
	private Long agreementSeq3;
	
	private String agreementTilte1;
	private String agreementTilte2;
	private String agreementTilte3;
	
	private String agreementContent1;
	private String agreementContent2;
	private String agreementContent3;

	/** 약관동의 여부 */
	private String courseAgreementYn;
	/**
	 * 바로가기 복사
	 */
	public void copyShortcut() {
		super.setCourseActiveSeq(this.shortcutCourseActiveSeq);
	}

	public Long getShortcutCourseActiveSeq() {
		return shortcutCourseActiveSeq;
	}

	public void setShortcutCourseActiveSeq(Long shortcutCourseActiveSeq) {
		this.shortcutCourseActiveSeq = shortcutCourseActiveSeq;
	}

	public String getShortcutCategoryTypeCd() {
		return shortcutCategoryTypeCd;
	}

	public void setShortcutCategoryTypeCd(String shortcutCategoryTypeCd) {
		this.shortcutCategoryTypeCd = shortcutCategoryTypeCd;
	}

	public String getShortcutYearTerm() {
		return shortcutYearTerm;
	}

	public void setShortcutYearTerm(String shortcutYearTerm) {
		this.shortcutYearTerm = shortcutYearTerm;
	}

	public Long getApplyCount() {
		return applyCount;
	}

	public void setApplyCount(Long applyCount) {
		this.applyCount = applyCount;
	}

	public Long[] getCourseMasterSeqs() {
		return courseMasterSeqs;
	}

	public void setCourseMasterSeqs(Long[] courseMasterSeqs) {
		this.courseMasterSeqs = courseMasterSeqs;
	}

	public Long[] getCategoryOrganizationSeqs() {
		return categoryOrganizationSeqs;
	}

	public void setCategoryOrganizationSeqs(Long[] categoryOrganizationSeqs) {
		this.categoryOrganizationSeqs = categoryOrganizationSeqs;
	}

	public String[] getCourseActiveTitles() {
		return courseActiveTitles;
	}

	public void setCourseActiveTitles(String[] courseActiveTitles) {
		this.courseActiveTitles = courseActiveTitles;
	}

	public Long[] getCourseActiveSeqs() {
		return courseActiveSeqs;
	}

	public void setCourseActiveSeqs(Long[] courseActiveSeqs) {
		this.courseActiveSeqs = courseActiveSeqs;
	}

	public Long getParentSeq() {
		return parentSeq;
	}

	public void setParentSeq(Long parentSeq) {
		this.parentSeq = parentSeq;
	}

	public Long[] getDivisions() {
		return divisions;
	}

	public void setDivisions(Long[] divisions) {
		this.divisions = divisions;
	}

	public String getBeforeYearTerm() {
		return beforeYearTerm;
	}

	public void setBeforeYearTerm(String beforeYearTerm) {
		this.beforeYearTerm = beforeYearTerm;
	}

	public String getYeatTerm() {
		return yeatTerm;
	}

	public void setYeatTerm(String yeatTerm) {
		this.yeatTerm = yeatTerm;
	}

	public ResultSet getCourseActiveRS() {
		return courseActiveRS;
	}

	public void setCourseActiveRS(ResultSet courseActiveRS) {
		this.courseActiveRS = courseActiveRS;
	}

	public Long[] getTargetCourseActiveSeqs() {
		return targetCourseActiveSeqs;
	}

	public void setTargetCourseActiveSeqs(Long[] targetCourseActiveSeqs) {
		this.targetCourseActiveSeqs = targetCourseActiveSeqs;
	}

	public Long[] getSourceCourseActiveSeqs() {
		return sourceCourseActiveSeqs;
	}

	public void setSourceCourseActiveSeqs(Long[] sourceCourseActiveSeqs) {
		this.sourceCourseActiveSeqs = sourceCourseActiveSeqs;
	}

	public String[] getCourseElementTypes() {
		return courseElementTypes;
	}

	public void setCourseElementTypes(String[] courseElementTypes) {
		this.courseElementTypes = courseElementTypes;
	}

	public String getCourseElementType() {
		return courseElementType;
	}

	public void setCourseElementType(String courseElementType) {
		this.courseElementType = courseElementType;
	}

	public Long getDivisionCount() {
		return divisionCount;
	}

	public void setDivisionCount(Long divisionCount) {
		this.divisionCount = divisionCount;
	}

	public List<AttachVO> getAttachList() {
		return attachList;
	}

	public void setAttachList(List<AttachVO> attachList) {
		this.attachList = attachList;
	}

	public String getApplyType() {
		return applyType;
	}

	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}

	public Long getdDay() {
		return dDay;
	}

	public void setdDay(Long dDay) {
		this.dDay = dDay;
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

	public Long getWorkDay() {
		return workDay;
	}

	public void setWorkDay(Long workDay) {
		this.workDay = workDay;
	}

	public String getCompetitionYn() {
		return competitionYn;
	}

	public void setCompetitionYn(String competitionYn) {
		this.competitionYn = competitionYn;
	}
	
	public String getExpireStartDate(){
		return expireStartDate;
	}
	
	public void setExpireStartDate(String expireStartDate) {
		this.expireStartDate = expireStartDate;
	}
	
	public String getExpireEndDate(){
		return expireEndDate;
	}
	
	public void setExpireEndDate(String expireEndDate) {
		this.expireEndDate = expireEndDate;
	}
	
	public String getThumNail() {
		return thumNail;
	}

	public void setThumNail(String thumNail) {
		this.thumNail = thumNail;
	}
	
	public Long getAgreementSeq1() {
		return agreementSeq1;
	}

	public void setAgreementSeq1(Long agreementSeq1) {
		this.agreementSeq1 = agreementSeq1;
	}

	public Long getAgreementSeq2() {
		return agreementSeq2;
	}

	public void setAgreementSeq2(Long agreementSeq2) {
		this.agreementSeq2 = agreementSeq2;
	}

	public Long getAgreementSeq3() {
		return agreementSeq3;
	}

	public void setAgreementSeq3(Long agreementSeq3) {
		this.agreementSeq3 = agreementSeq3;
	}

	public String getCourseGroupTitle() {
		return courseGroupTitle;
	}

	public void setCourseGroupTitle(String courseGroupTitle) {
		this.courseGroupTitle = courseGroupTitle;
	}

	public String getCourseAgreementYn() {
		return courseAgreementYn;
	}

	public void setCourseAgreementYn(String courseAgreementYn) {
		this.courseAgreementYn = courseAgreementYn;
	}

	public String getAgreementTilte1() {
		return agreementTilte1;
	}

	public void setAgreementTilte1(String agreementTilte1) {
		this.agreementTilte1 = agreementTilte1;
	}

	public String getAgreementTilte2() {
		return agreementTilte2;
	}

	public void setAgreementTilte2(String agreementTilte2) {
		this.agreementTilte2 = agreementTilte2;
	}

	public String getAgreementTilte3() {
		return agreementTilte3;
	}

	public void setAgreementTilte3(String agreementTilte3) {
		this.agreementTilte3 = agreementTilte3;
	}

	public String getAgreementContent1() {
		return agreementContent1;
	}

	public void setAgreementContent1(String agreementContent1) {
		this.agreementContent1 = agreementContent1;
	}

	public String getAgreementContent2() {
		return agreementContent2;
	}

	public void setAgreementContent2(String agreementContent2) {
		this.agreementContent2 = agreementContent2;
	}

	public String getAgreementContent3() {
		return agreementContent3;
	}

	public void setAgreementContent3(String agreementContent3) {
		this.agreementContent3 = agreementContent3;
	}
	
}
