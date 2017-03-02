/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.support;

import org.springframework.stereotype.Component;

import com._4csoft.aof.infra.vo.base.AttachReferenceVO;
import com._4csoft.aof.univ.support.UnivAttachReference;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.support
 * @File : UIUnivAttachReference.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Component ("UIUnivAttachReference")
public class UIUnivAttachReference implements UnivAttachReference {

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.univ.support.UnivAttachReference#getAttachReferenceBbs(com._4csoft.aof.univ.support.UnivAttachReference.AttachType,
	 * java.lang.String)
	 */
	public AttachReferenceVO getAttachReferenceBbs(AttachType type, String boardTypeCd) {
		String boardType = boardTypeCd.replaceFirst("BOARD_TYPE::", "").toLowerCase();

		switch (type) {
		case COURSE_ACTIVE_BBS :
			return new AttachReferenceVO("course-" + boardType, "cs_course_active_bbs", "course/bbs/" + boardType);
		case COURSE_TEAM_PROJECT_BBS :
			return new AttachReferenceVO("course-" + boardType, "cs_course_teamproject_bbs", "course/bbs/" + boardType);
		case COURSE_DISCUSS_BBS :
			return new AttachReferenceVO("course-" + boardType, "cs_course_discuss_bbs", "course/bbs/" + boardType);
		default :
			return null;
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.univ.support.validator.UnivAttachReference#getAttachReference(com._4csoft.aof.univ.support.validator.UnivAttachReference.AttachType)
	 */
	public AttachReferenceVO getAttachReference(AttachType type) {
		switch (type) {
		case COURSE_DISCUSS :
			return new AttachReferenceVO("discuss", "cs_course_discuss", "discuss");
		case COURSE_DISCUSS_TEMPLATE :
			return new AttachReferenceVO("discuss-template", "cs_course_discuss_template", "template/discuss");
		case COURSE_HOMEWORK :
			return new AttachReferenceVO("homework", "cs_course_homework", "homework");
		case COURSE_HOMEWORK_TEMPLATE :
			return new AttachReferenceVO("homework-template", "cs_course_homework_template", "template/homework");
		case COURSE_HOMEWORK_ANSWER :
			return new AttachReferenceVO("homework-answer", "cs_course_homework_answer", "homeworkanswer");
		case COURSE_TEAM_PROJECT :
			return new AttachReferenceVO("teamproject", "cs_course_teamproject", "teamproject");
		case COURSE_TEAM_PROJECT_TEMPLATE :
			return new AttachReferenceVO("teamproject-template", "cs_course_teamproject_template", "template/teamproject");
		case COURSE_EXAM_PAPER_ANSWER :
			return new AttachReferenceVO("exampaper-answer", "cs_course_exam_answer", "exampaperanswer");
		case COURSE_ACTIVE_ITEM :
			return new AttachReferenceVO("organization-item", "cs_course_active_organization_item", "organization/item");
		case COURSE_EXAM_PAPER_TARGET :
			return new AttachReferenceVO("exampaper-answer-offline", "cs_course_active_exam_paper_target", "exampaperanswer/target");
		default :
			return null;
		}
	}

}
