/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.support;

import org.springframework.stereotype.Component;

import com._4csoft.aof.infra.vo.base.AttachReferenceVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.support
 * @File : UIUnivCourseActiveAttachReference.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 27.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Component ("UIUnivCourseActiveAttachReference")
public class UIUnivCourseActiveAttachReference implements UnivCourseActiveAttachReference {

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.ui.univ.support.UnivCourseActiveAttachReference#getAttachReference(com._4csoft.aof.univ.support.UnivAttachReference.AttachType)
	 */
	public AttachReferenceVO getAttachReference(UIAttachType type) {
		switch (type) {
		case COURSE_ACTIVE_TIME_TABLE :
			return new AttachReferenceVO("timeTable", "cs_course_active", "courseactive/timetable");
		default :

			return null;
		}
	}
}
