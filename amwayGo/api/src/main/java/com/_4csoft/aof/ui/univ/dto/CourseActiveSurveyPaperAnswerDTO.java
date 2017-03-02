package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;
import java.util.List;

/**
 * 설문 응답 DTO
 * 
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.dto
 * @File : CourseActiveSurveyPaperAnswerDTO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 25.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class CourseActiveSurveyPaperAnswerDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	private List<CourseActiveSurveyPaperAnswerItemDTO> listItemAnswer;

	public List<CourseActiveSurveyPaperAnswerItemDTO> getListItemAnswer() {
		return listItemAnswer;
	}

	public void setListItemAnswer(List<CourseActiveSurveyPaperAnswerItemDTO> listItemAnswer) {
		this.listItemAnswer = listItemAnswer;
	}

}
