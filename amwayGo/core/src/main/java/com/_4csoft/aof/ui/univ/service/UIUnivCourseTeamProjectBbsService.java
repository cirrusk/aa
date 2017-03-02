/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service;

import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectBbsVO;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectBbsService;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.univ.service
 * @File : UIUnivCourseTeamProjectBbsService.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 4. 20.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UIUnivCourseTeamProjectBbsService extends UnivCourseTeamProjectBbsService {
	/** 팀프로젝트 푸시 메시지 구분 */
	final String COURSE_ACTIVE_TEAMPROJECT = "104";

	/**
	 * 팀프로젝트 게시물 등록
	 */
	public int insertBbs(UIUnivCourseTeamProjectBbsVO vo, UIAttachVO voAttach) throws Exception;
}
