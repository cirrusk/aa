/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseTeamProjectMutualevalVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseTeamProjectMutualevalVO.java
 * @Title : 개설과목 팀프로젝트 상호평가
 * @date : 2014. 3. 12.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseTeamProjectMutualevalVO extends UnivCourseTeamProjectMutualevalVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 게시글 수 */
	private Long bbsCount;

	/** 상호평가 점수 Array */
	private Double[] mutualScores;

	/** 수강생 일련번호 Array */
	private Long[] courseApplySeqs;

	/** 팀원 일련번호 Array */
	private Long[] teamMemberSeqs;

	/** 팀 일련번호 Array */
	private Long[] courseTeamSeqs;

	/** 바로가기 개설과목일련번호 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 */
	private String shortcutCategoryTypeCd;

	/**
	 * 바로가기 복사
	 */
	public void copyShortcut() {
		setCourseActiveSeq(this.shortcutCourseActiveSeq);
	}

	public Long getBbsCount() {
		return bbsCount;
	}

	public void setBbsCount(Long bbsCount) {
		this.bbsCount = bbsCount;
	}

	public Double[] getMutualScores() {
		return mutualScores;
	}

	public void setMutualScores(Double[] mutualScores) {
		this.mutualScores = mutualScores;
	}

	public Long[] getCourseApplySeqs() {
		return courseApplySeqs;
	}

	public void setCourseApplySeqs(Long[] courseApplySeqs) {
		this.courseApplySeqs = courseApplySeqs;
	}

	public Long[] getTeamMemberSeqs() {
		return teamMemberSeqs;
	}

	public void setTeamMemberSeqs(Long[] teamMemberSeqs) {
		this.teamMemberSeqs = teamMemberSeqs;
	}

	public Long[] getCourseTeamSeqs() {
		return courseTeamSeqs;
	}

	public void setCourseTeamSeqs(Long[] courseTeamSeqs) {
		this.courseTeamSeqs = courseTeamSeqs;
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
}
