package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.univ.vo.UnivCourseApplyElementVO;

/**
 * 
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseApplyElementVO.java
 * @Title : 학습자 수강요소
 * @date : 2014. 3. 24.
 * @author : 김현우
 * @descrption : 학습자 수강요소
 */
public class UIUnivCourseApplyElementVO extends UnivCourseApplyElementVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 중간고사 제출 수 */
	private Long midexamCount;

	/** 기말고사 제출 수 */
	private Long finalexamCount;

	/** 과제 제출 수 */
	private Long homeworkCount;

	/** 퀴즈 제출 수 */
	private Long quizCount;

	/** 팀프로젝트 제출 수 */
	private Long teamprojectCount;

	/** 응시자 수 */
	private Long takeCount;

	/** 재첨완료 수 */
	private Long scoreCount;

	/** 시험 제출 수 */
	private Long examCount;
	
	/** 응시자 리스트 */
	private List<UnivCourseApplyElementVO> takeList;

	public Long getMidexamCount() {
		return midexamCount;
	}

	public void setMidexamCount(Long midexamCount) {
		this.midexamCount = midexamCount;
	}

	public Long getFinalexamCount() {
		return finalexamCount;
	}

	public void setFinalexamCount(Long finalexamCount) {
		this.finalexamCount = finalexamCount;
	}

	public Long getHomeworkCount() {
		return homeworkCount;
	}

	public void setHomeworkCount(Long homeworkCount) {
		this.homeworkCount = homeworkCount;
	}

	public Long getQuizCount() {
		return quizCount;
	}

	public void setQuizCount(Long quizCount) {
		this.quizCount = quizCount;
	}

	public Long getTeamprojectCount() {
		return teamprojectCount;
	}

	public void setTeamprojectCount(Long teamprojectCount) {
		this.teamprojectCount = teamprojectCount;
	}

	public Long getTakeCount() {
		return takeCount;
	}

	public void setTakeCount(Long takeCount) {
		this.takeCount = takeCount;
	}

	public Long getScoreCount() {
		return scoreCount;
	}

	public void setScoreCount(Long scoreCount) {
		this.scoreCount = scoreCount;
	}

	public Long getExamCount() {
		return examCount;
	}

	public void setExamCount(Long examCount) {
		this.examCount = examCount;
	}

	public List<UnivCourseApplyElementVO> getTakeList() {
		return takeList;
	}

	public void setTakeList(List<UnivCourseApplyElementVO> takeList) {
		this.takeList = takeList;
	}

}
