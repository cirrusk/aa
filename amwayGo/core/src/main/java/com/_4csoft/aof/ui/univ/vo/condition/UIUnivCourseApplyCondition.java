package com._4csoft.aof.ui.univ.vo.condition;

import java.io.Serializable;

import com._4csoft.aof.infra.vo.base.SearchConditionVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo.condition
 * @File : UIUnivCourseApplyCondition.java
 * @Title : 수강
 * @date : 2014. 3. 5.
 * @author : 장용기
 * @descrption :
 */
public class UIUnivCourseApplyCondition extends SearchConditionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/**  */
	private Long srchMemberSeq;

	/**  */
	private String srchYearTerm;

	/**  */
	private String srchYear;

	/**  */
	private String srchCategoryTypeCd;

	/**  */
	private String srchApplyType;

	/**  */
	private String srchCategoryName;

	/** 검색 개설과목 일련번호 */
	private Long srchCourseActiveSeq;

	/** 검색 수강신청 상태코드 */
	private String srchApplyStatusCd;

	/** 검색 회원 구분 */
	private String srchMemberEmsTypeCd;

	/** 검색 신청 구분 */
	private String srchApplyKindCd;

	/** 학습부진자조회 과제제출 검색 */
	private String srchHomeworkSubmitTypeCd;

	/** 학습부진자조회 퀴즈응시 검색 */
	private String srchQuizSubmitTypeCd;

	/** 학습부진자조회 팀프로젝트 제출 검색 */
	private String srchTeamprojectSubmitTypeCd;

	/** 학습부진자조회 중간고사 응시 검색 */
	private String srchMidExamSubmitTypeCd;

	/** 학습부진자조회 기말고사 응시 검색 */
	private String srchFinalExamSubmitTypeCd;
	
	/** 학습부진자조회 시험 응시 검색 */
	private String srchExamSubmitTypeCd;

	/** 학습부진자조회 진도율 검색 */
	private Double srchProgressMeasure;

	/** 학습부진자조회 온라인 결석 검색 */
	private Long srchOnlineAbsenceTypeCnt;

	/** 학습부진자조회 온라인 결석 검색 */
	private Long srchOfflineAbsenceTypeCnt;

	/** 검색에서 제외 시킬 강의실 */
	private Long srchNotInCourseActiveSeq;
	
	/** 검색 약관동의 버전 */
	private Long srchVersion;
	
	/** 수료여부 검색 */
	private String srchCompleteYn;
	
	/** 과정구분코드 */
    private String srchCourseTypeCd;
    
    private String srchCompetitionYn;

	public Long getSrchMemberSeq() {
		return srchMemberSeq;
	}

	public void setSrchMemberSeq(Long srchMemberSeq) {
		this.srchMemberSeq = srchMemberSeq;
	}

	public String getSrchYearTerm() {
		return srchYearTerm;
	}

	public void setSrchYearTerm(String srchYearTerm) {
		this.srchYearTerm = srchYearTerm;
	}

	public String getSrchYear() {
		return srchYear;
	}

	public void setSrchYear(String srchYear) {
		this.srchYear = srchYear;
	}

	public String getSrchCategoryTypeCd() {
		return srchCategoryTypeCd;
	}

	public void setSrchCategoryTypeCd(String srchCategoryTypeCd) {
		this.srchCategoryTypeCd = srchCategoryTypeCd;
	}

	public String getSrchApplyType() {
		return srchApplyType;
	}

	public void setSrchApplyType(String srchApplyType) {
		this.srchApplyType = srchApplyType;
	}

	public String getSrchCategoryName() {
		return srchCategoryName;
	}

	public void setSrchCategoryName(String srchCategoryName) {
		this.srchCategoryName = srchCategoryName;
	}

	public String getSrchCategoryNameDB() {
		return srchCategoryName.replaceAll("%", "\\\\%");
	}

	public Long getSrchCourseActiveSeq() {
		return srchCourseActiveSeq;
	}

	public void setSrchCourseActiveSeq(Long srchCourseActiveSeq) {
		this.srchCourseActiveSeq = srchCourseActiveSeq;
	}

	public String getSrchApplyStatusCd() {
		return srchApplyStatusCd;
	}

	public void setSrchApplyStatusCd(String srchApplyStatusCd) {
		this.srchApplyStatusCd = srchApplyStatusCd;
	}

	public String getSrchMemberEmsTypeCd() {
		return srchMemberEmsTypeCd;
	}

	public void setSrchMemberEmsTypeCd(String srchMemberEmsTypeCd) {
		this.srchMemberEmsTypeCd = srchMemberEmsTypeCd;
	}

	public String getSrchApplyKindCd() {
		return srchApplyKindCd;
	}

	public void setSrchApplyKindCd(String srchApplyKindCd) {
		this.srchApplyKindCd = srchApplyKindCd;
	}

	public String getSrchHomeworkSubmitTypeCd() {
		return srchHomeworkSubmitTypeCd;
	}

	public void setSrchHomeworkSubmitTypeCd(String srchHomeworkSubmitTypeCd) {
		this.srchHomeworkSubmitTypeCd = srchHomeworkSubmitTypeCd;
	}

	public String getSrchQuizSubmitTypeCd() {
		return srchQuizSubmitTypeCd;
	}

	public void setSrchQuizSubmitTypeCd(String srchQuizSubmitTypeCd) {
		this.srchQuizSubmitTypeCd = srchQuizSubmitTypeCd;
	}

	public String getSrchTeamprojectSubmitTypeCd() {
		return srchTeamprojectSubmitTypeCd;
	}

	public void setSrchTeamprojectSubmitTypeCd(String srchTeamprojectSubmitTypeCd) {
		this.srchTeamprojectSubmitTypeCd = srchTeamprojectSubmitTypeCd;
	}

	public String getSrchMidExamSubmitTypeCd() {
		return srchMidExamSubmitTypeCd;
	}

	public void setSrchMidExamSubmitTypeCd(String srchMidExamSubmitTypeCd) {
		this.srchMidExamSubmitTypeCd = srchMidExamSubmitTypeCd;
	}

	public String getSrchFinalExamSubmitTypeCd() {
		return srchFinalExamSubmitTypeCd;
	}

	public void setSrchFinalExamSubmitTypeCd(String srchFinalExamSubmitTypeCd) {
		this.srchFinalExamSubmitTypeCd = srchFinalExamSubmitTypeCd;
	}

	public String getSrchExamSubmitTypeCd() {
		return srchExamSubmitTypeCd;
	}

	public void setSrchExamSubmitTypeCd(String srchExamSubmitTypeCd) {
		this.srchExamSubmitTypeCd = srchExamSubmitTypeCd;
	}

	public Double getSrchProgressMeasure() {
		return srchProgressMeasure;
	}

	public void setSrchProgressMeasure(Double srchProgressMeasure) {
		this.srchProgressMeasure = srchProgressMeasure;
	}

	public Long getSrchOnlineAbsenceTypeCnt() {
		return srchOnlineAbsenceTypeCnt;
	}

	public void setSrchOnlineAbsenceTypeCnt(Long srchOnlineAbsenceTypeCnt) {
		this.srchOnlineAbsenceTypeCnt = srchOnlineAbsenceTypeCnt;
	}

	public Long getSrchOfflineAbsenceTypeCnt() {
		return srchOfflineAbsenceTypeCnt;
	}

	public void setSrchOfflineAbsenceTypeCnt(Long srchOfflineAbsenceTypeCnt) {
		this.srchOfflineAbsenceTypeCnt = srchOfflineAbsenceTypeCnt;
	}

	public Long getSrchNotInCourseActiveSeq() {
		return srchNotInCourseActiveSeq;
	}

	public void setSrchNotInCourseActiveSeq(Long srchNotInCourseActiveSeq) {
		this.srchNotInCourseActiveSeq = srchNotInCourseActiveSeq;
	}

	public String getSrchCompleteYn() {
		return srchCompleteYn;
	}

	public void setSrchCompleteYn(String srchCompleteYn) {
		this.srchCompleteYn = srchCompleteYn;
	}

	public String getSrchCourseTypeCd() {
		return srchCourseTypeCd;
	}

	public void setSrchCourseTypeCd(String srchCourseTypeCd) {
		this.srchCourseTypeCd = srchCourseTypeCd;
	}

	public String getSrchCompetitionYn() {
		return srchCompetitionYn;
	}

	public void setSrchCompetitionYn(String srchCompetitionYn) {
		this.srchCompetitionYn = srchCompetitionYn;
	}
	
	public Long getSrchVersion() {
		return srchVersion;
	}

	public void setSrchVersion(Long srchVersion) {
		this.srchVersion = srchVersion;
	}

}
