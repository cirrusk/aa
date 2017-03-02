/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service;

import com._4csoft.aof.infra.vo.AttachVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBbsVO;
import com._4csoft.aof.univ.service.UnivCourseActiveBbsService;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.board.service
 * @File : UIUnivCourseActiveBbsService.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 25.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UIUnivCourseActiveBbsService extends UnivCourseActiveBbsService {

	/** 기본 푸시일 경우 001~100번이하의 코드값 */
	/** 개인 푸시 메시지 구분 */
	final String PERSONAL_NOTICE = "001";

	/** 게시판일 경우 100~199번대의 코드값 */
	/** 공지사항 푸시 메시지 구분 */
	final String COURSE_ACTIVE_NOTICE = "100";

	/** 자료사례공유 푸시 메시지 구분 */
	final String COURSE_ACTIVE_SHARE_RESOURCE = "101";

	/** 자료실 푸시 메시지 구분 */
	final String COURSE_ACTIVE_RESOURCE = "102";

	/** 과제 푸시 메시지 구분 */
	final String COURSE_ACTIVE_HOMEWORK = "103";

	/**
	 * 게시물 통계
	 * 
	 * @param conditionVO
	 * @return
	 * @throws Exception
	 */
	Paginate<ResultSet> getListBbsStatistics(SearchConditionVO conditionVO) throws Exception;

	/**
	 * 
	 * @param vo
	 * @param voAttach
	 * @return
	 * @throws Exception
	 */
	public int insertBbs(UIUnivCourseActiveBbsVO vo, AttachVO voAttach) throws Exception;

}
