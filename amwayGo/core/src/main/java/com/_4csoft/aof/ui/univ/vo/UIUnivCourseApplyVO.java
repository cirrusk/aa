package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseApplyVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseApplyVO.java
 * @Title : 수강
 * @date : 2014. 3. 5.
 * @author : 장용기
 * @descrption :
 * 
 */
public class UIUnivCourseApplyVO extends UnivCourseApplyVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 바로가기 개설과목일련번호 */
	private Long shortcutCourseActiveSeq;

	/** 바로가기 분류 구분 */
	private String shortcutCategoryTypeCd;

	/** 바로가기 분류 구분 */
	private String shortcutCourseTypeCd;

	/** 바로가기 년도학기 */
	private String shortcutYearTerm;

	/** 교과목 일련번호 Array */
	private Long[] courseMasterSeqs;

	/** 개설 과목 일련번호 Array */
	private Long[] courseActiveSeqs;

	/** 년도학기 Array */
	private String[] yeatTerms;

	/** 멤버일련번호 Array */
	private Long[] memberSeqs;

	/** 수강생 일련번호 Array */
	private Long[] courseApplySeqs;

	/** 수강 상태 Array */
	private String[] applyStatusCds;

	/** 신청 구분 Array */
	private String[] applyKindCds;

	/** 온라인출석 점수 */
	private Double[] onAttendScores;

	/** 진도 점수 */
	private Double[] progressScores;

	/** 중간고사 점수 */
	private Double[] middleExamScores;

	/** 기말고사 점수 */
	private Double[] finalExamScores;

	/** 과제 점수 */
	private Double[] homeworkScores;

	/** 팀프로젝트 점수 */
	private Double[] teamprojectScores;

	/** 토론 점수 */
	private Double[] discussScores;

	/** 퀴즈 점수 */
	private Double[] quizScores;

	/** 참여 점수 */
	private Double[] joinScores;

	/** 오프라인출석 점수 */
	private Double[] offAttendScores;

	/** 시험점수 */
	private Double[] examScores;

	/** 획득점수 */
	private Double[] addScores;

	/** 가산 점수 */
	private Double[] takeScores;

	/** 최종점수 */
	private Double[] finalScores;

	/** 환산학점 */
	private String[] gradeLevelCds;

	/** 순위 */
	private Long[] rankings;

	/** 수료여부 */
	private String[] completionYns;

	/** 아이디 */
	private String memberId;
	
	/** HR_PRACTICE */
	private String hrPractice;
	
	/** EXTERNEL_PRACTICE */
	private String externelPractice;
	
	/** PANEL_DISCUSSION */
	private String panelDiscussion;

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

	/**
	 * 바로가기 복사
	 */
	public void copyShortcut() {
		super.setCourseActiveSeq(this.shortcutCourseActiveSeq);
	}

	public Long[] getMemberSeqs() {
		return memberSeqs;
	}

	public void setMemberSeqs(Long[] memberSeqs) {
		this.memberSeqs = memberSeqs;
	}

	public Long[] getCourseApplySeqs() {
		return courseApplySeqs;
	}

	public void setCourseApplySeqs(Long[] courseApplySeqs) {
		this.courseApplySeqs = courseApplySeqs;
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

	public Long[] getCourseMasterSeqs() {
		return courseMasterSeqs;
	}

	public void setCourseMasterSeqs(Long[] courseMasterSeqs) {
		this.courseMasterSeqs = courseMasterSeqs;
	}

	public String[] getYeatTerms() {
		return yeatTerms;
	}

	public void setYeatTerms(String[] yeatTerms) {
		this.yeatTerms = yeatTerms;
	}

	public Long[] getCourseActiveSeqs() {
		return courseActiveSeqs;
	}

	public void setCourseActiveSeqs(Long[] courseActiveSeqs) {
		this.courseActiveSeqs = courseActiveSeqs;
	}

	public String[] getApplyStatusCds() {
		return applyStatusCds;
	}

	public void setApplyStatusCds(String[] applyStatusCds) {
		this.applyStatusCds = applyStatusCds;
	}

	public String[] getApplyKindCds() {
		return applyKindCds;
	}

	public void setApplyKindCds(String[] applyKindCds) {
		this.applyKindCds = applyKindCds;
	}

	public Double[] getOnAttendScores() {
		return onAttendScores;
	}

	public void setOnAttendScores(Double[] onAttendScores) {
		this.onAttendScores = onAttendScores;
	}

	public Double[] getProgressScores() {
		return progressScores;
	}

	public void setProgressScores(Double[] progressScores) {
		this.progressScores = progressScores;
	}

	public Double[] getMiddleExamScores() {
		return middleExamScores;
	}

	public void setMiddleExamScores(Double[] middleExamScores) {
		this.middleExamScores = middleExamScores;
	}

	public Double[] getFinalExamScores() {
		return finalExamScores;
	}

	public void setFinalExamScores(Double[] finalExamScores) {
		this.finalExamScores = finalExamScores;
	}

	public Double[] getHomeworkScores() {
		return homeworkScores;
	}

	public void setHomeworkScores(Double[] homeworkScores) {
		this.homeworkScores = homeworkScores;
	}

	public Double[] getTeamprojectScores() {
		return teamprojectScores;
	}

	public void setTeamprojectScores(Double[] teamprojectScores) {
		this.teamprojectScores = teamprojectScores;
	}

	public Double[] getDiscussScores() {
		return discussScores;
	}

	public void setDiscussScores(Double[] discussScores) {
		this.discussScores = discussScores;
	}

	public Double[] getQuizScores() {
		return quizScores;
	}

	public void setQuizScores(Double[] quizScores) {
		this.quizScores = quizScores;
	}

	public Double[] getJoinScores() {
		return joinScores;
	}

	public void setJoinScores(Double[] joinScores) {
		this.joinScores = joinScores;
	}

	public Double[] getOffAttendScores() {
		return offAttendScores;
	}

	public void setOffAttendScores(Double[] offAttendScores) {
		this.offAttendScores = offAttendScores;
	}

	public Double[] getExamScores() {
		return examScores;
	}

	public void setExamScores(Double[] examScores) {
		this.examScores = examScores;
	}

	public Double[] getAddScores() {
		return addScores;
	}

	public void setAddScores(Double[] addScores) {
		this.addScores = addScores;
	}

	public Double[] getTakeScores() {
		return takeScores;
	}

	public void setTakeScores(Double[] takeScores) {
		this.takeScores = takeScores;
	}

	public Double[] getFinalScores() {
		return finalScores;
	}

	public void setFinalScores(Double[] finalScores) {
		this.finalScores = finalScores;
	}

	public String[] getGradeLevelCds() {
		return gradeLevelCds;
	}

	public void setGradeLevelCds(String[] gradeLevelCds) {
		this.gradeLevelCds = gradeLevelCds;
	}

	public Long[] getRankings() {
		return rankings;
	}

	public void setRankings(Long[] rankings) {
		this.rankings = rankings;
	}

	public String[] getCompletionYns() {
		return completionYns;
	}

	public void setCompletionYns(String[] completionYns) {
		this.completionYns = completionYns;
	}

	public String getShortcutCourseTypeCd() {
		return shortcutCourseTypeCd;
	}

	public void setShortcutCourseTypeCd(String shortcutCourseTypeCd) {
		this.shortcutCourseTypeCd = shortcutCourseTypeCd;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

}
