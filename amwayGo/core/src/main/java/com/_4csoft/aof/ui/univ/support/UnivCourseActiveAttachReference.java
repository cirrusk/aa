/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.support;

import com._4csoft.aof.infra.vo.base.AttachReferenceVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.support
 * @File : UnivCourseActiveAttachReference.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 27.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UnivCourseActiveAttachReference {
	enum UIAttachType {
		COURSE_ACTIVE_TIME_TABLE
	}

	/**
	 * 첨부파일 정보
	 * 
	 * @return AttachReferenceVO
	 */
	public AttachReferenceVO getAttachReference(UIAttachType type);

}
