/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import com._4csoft.aof.univ.vo.UnivCourseActiveElementVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseActiveElementVO.java
 * @Title : 주차관리
 * @date : 2014. 2. 26.
 * @author : 장용기
 * @descrption :
 * 
 */
public class UIUnivCourseActiveElementVO extends UnivCourseActiveElementVO {
	private static final long serialVersionUID = 1L;

	/** */
	private Long[] activeElementSeqs;

	/** */
	private Long[] courseActiveSeqs;

	/** */
	private Long[] referenceSeqs;

	/** */
	private Long[] oldReferenceSeqs;

	/** */
	private String[] referenceTypeCds;

	/** */
	private String[] activeElementTitles;

	/** */
	private String[] startDtimes;

	/** */
	private String[] endDtimes;

	/** */
	private Long[] startDays;

	/** */
	private Long[] endDays;

	/** */
	private String[] courseWeekTypeCds;

	/** */
	private Long[] offlineLessonCounts;

	/** */
	private Long[] sortOrders;

	/** 출석 인정 진도율 */
	private Long attendProgressValue;

	/** 평균 진도율 % */
	private Double totalProgressMeasure;

	/** 평균 진도율 전체 강의 갯수 */
	private Long totalItemCnt;

	/** 평균 출석 */
	private Double totalAttendMeasure;

	/** 전체 출석 수 */
	private Long attendTypeAttendCnt;

	/** 전체 결석 수 */
	private Long attendTypeAbsenceCnt;

	/** 전체 지각 수 */
	private Long attendTypePerceptionCnt;

	/** 총 학습 횟수 */
	private Long attemptTotal;

	/** 현재 학습이 시작된 상태인지 여부 */
	private String studyStartYn;

	/** 그룹매핑 키 */
	private Long contentsSeq;

	/** 바로가기 개설과목일련번호 */
	private Long shortcutCourseActiveSeq;

	/** 온라인 출석 수 */
	private Long onlineAttendTypeCnt;

	/** 온라인 부여 출석 수 */
	private Long onlineAttendCnt;

	/** 오프라인 출석 수 */
	private Long offlineAttendTypeCnt;

	/** 오프라인 부여 출석 수 */
	private Long offlineAttendCnt;

	/** 출제수 */
	private Long setCount;

	/** 강사명 */
	private String lectureName;

	/** 강사명 Array */
	private String[] lectureNames;

	public Long[] getActiveElementSeqs() {
		return activeElementSeqs;
	}

	public void setActiveElementSeqs(Long[] activeElementSeqs) {
		this.activeElementSeqs = activeElementSeqs;
	}

	public Long[] getCourseActiveSeqs() {
		return courseActiveSeqs;
	}

	public void setCourseActiveSeqs(Long[] courseActiveSeqs) {
		this.courseActiveSeqs = courseActiveSeqs;
	}

	public Long[] getReferenceSeqs() {
		return referenceSeqs;
	}

	public void setReferenceSeqs(Long[] referenceSeqs) {
		this.referenceSeqs = referenceSeqs;
	}

	public Long[] getOldReferenceSeqs() {
		return oldReferenceSeqs;
	}

	public void setOldReferenceSeqs(Long[] oldReferenceSeqs) {
		this.oldReferenceSeqs = oldReferenceSeqs;
	}

	public String[] getReferenceTypeCds() {
		return referenceTypeCds;
	}

	public void setReferenceTypeCds(String[] referenceTypeCds) {
		this.referenceTypeCds = referenceTypeCds;
	}

	public String[] getActiveElementTitles() {
		return activeElementTitles;
	}

	public void setActiveElementTitles(String[] activeElementTitles) {
		this.activeElementTitles = activeElementTitles;
	}

	public String[] getStartDtimes() {
		return startDtimes;
	}

	public void setStartDtimes(String[] startDtimes) {
		this.startDtimes = startDtimes;
	}

	public String[] getEndDtimes() {
		return endDtimes;
	}

	public void setEndDtimes(String[] endDtimes) {
		this.endDtimes = endDtimes;
	}

	public Long[] getStartDays() {
		return startDays;
	}

	public void setStartDays(Long[] startDays) {
		this.startDays = startDays;
	}

	public Long[] getEndDays() {
		return endDays;
	}

	public void setEndDays(Long[] endDays) {
		this.endDays = endDays;
	}

	public String[] getCourseWeekTypeCds() {
		return courseWeekTypeCds;
	}

	public void setCourseWeekTypeCds(String[] courseWeekTypeCds) {
		this.courseWeekTypeCds = courseWeekTypeCds;
	}

	public Long[] getSortOrders() {
		return sortOrders;
	}

	public void setSortOrders(Long[] sortOrders) {
		this.sortOrders = sortOrders;
	}

	public Long getContentsSeq() {
		return contentsSeq;
	}

	public void setContentsSeq(Long contentsSeq) {
		this.contentsSeq = contentsSeq;
	}

	public Long[] getOfflineLessonCounts() {
		return offlineLessonCounts;
	}

	public void setOfflineLessonCounts(Long[] offlineLessonCounts) {
		this.offlineLessonCounts = offlineLessonCounts;
	}

	public Long getAttendProgressValue() {
		return attendProgressValue;
	}

	public void setAttendProgressValue(Long attendProgressValue) {
		this.attendProgressValue = attendProgressValue;
	}

	public Double getTotalProgressMeasure() {
		return totalProgressMeasure;
	}

	public void setTotalProgressMeasure(Double totalProgressMeasure) {
		this.totalProgressMeasure = totalProgressMeasure;
	}

	public Long getTotalItemCnt() {
		return totalItemCnt;
	}

	public void setTotalItemCnt(Long totalItemCnt) {
		this.totalItemCnt = totalItemCnt;
	}

	public Double getTotalAttendMeasure() {
		return totalAttendMeasure;
	}

	public void setTotalAttendMeasure(Double totalAttendMeasure) {
		this.totalAttendMeasure = totalAttendMeasure;
	}

	public Long getAttendTypeAttendCnt() {
		return attendTypeAttendCnt;
	}

	public void setAttendTypeAttendCnt(Long attendTypeAttendCnt) {
		this.attendTypeAttendCnt = attendTypeAttendCnt;
	}

	public Long getAttendTypeAbsenceCnt() {
		return attendTypeAbsenceCnt;
	}

	public void setAttendTypeAbsenceCnt(Long attendTypeAbsenceCnt) {
		this.attendTypeAbsenceCnt = attendTypeAbsenceCnt;
	}

	public Long getAttendTypePerceptionCnt() {
		return attendTypePerceptionCnt;
	}

	public void setAttendTypePerceptionCnt(Long attendTypePerceptionCnt) {
		this.attendTypePerceptionCnt = attendTypePerceptionCnt;
	}

	public Long getOnlineAttendTypeCnt() {
		return onlineAttendTypeCnt;
	}

	public void setOnlineAttendTypeCnt(Long onlineAttendTypeCnt) {
		this.onlineAttendTypeCnt = onlineAttendTypeCnt;
	}

	public Long getOnlineAttendCnt() {
		return onlineAttendCnt;
	}

	public void setOnlineAttendCnt(Long onlineAttendCnt) {
		this.onlineAttendCnt = onlineAttendCnt;
	}

	public Long getOfflineAttendTypeCnt() {
		return offlineAttendTypeCnt;
	}

	public void setOfflineAttendTypeCnt(Long offlineAttendTypeCnt) {
		this.offlineAttendTypeCnt = offlineAttendTypeCnt;
	}

	public Long getOfflineAttendCnt() {
		return offlineAttendCnt;
	}

	public void setOfflineAttendCnt(Long offlineAttendCnt) {
		this.offlineAttendCnt = offlineAttendCnt;
	}

	public Long getAttemptTotal() {
		return attemptTotal;
	}

	public void setAttemptTotal(Long attemptTotal) {
		this.attemptTotal = attemptTotal;
	}

	public String getStudyStartYn() {
		return studyStartYn;
	}

	public void setStudyStartYn(String studyStartYn) {
		this.studyStartYn = studyStartYn;
	}

	public Long getSetCount() {
		return setCount;
	}

	public void setSetCount(Long setCount) {
		this.setCount = setCount;
	}

	/**
	 * 바로가기 값 복사(
	 */
	public void copyShortcut() {
		super.setCourseActiveSeq(this.getShortcutCourseActiveSeq());
	}

	public Long getShortcutCourseActiveSeq() {
		return shortcutCourseActiveSeq;
	}

	public void setShortcutCourseActiveSeq(Long shortcutCourseActiveSeq) {
		this.shortcutCourseActiveSeq = shortcutCourseActiveSeq;
	}

	public String getLectureName() {
		return lectureName;
	}

	public void setLectureName(String lectureName) {
		this.lectureName = lectureName;
	}

	public String[] getLectureNames() {
		return lectureNames;
	}

	public void setLectureNames(String[] lectureNames) {
		this.lectureNames = lectureNames;
	}

}
