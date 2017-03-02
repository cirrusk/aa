/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.session.service;

import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.session.vo.condition.UISessionCondition;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.session.service
 * @File    : UISessionService.java
 * @Title   : {간단한 프로그램의 명칭을 기록}
 * @date    : 2015. 8. 17.
 * @author  : 조성훈
 * @descrption :
 * {상세한 프로그램의 용도를 기록}
 */
public interface UISessionService {
	
	/**
	 * Session 상세정보
	 * 
	 * @param classificationCode
	 * @param sessionCode
	 * @return ResultSet
	 */
	ResultSet getDetail(UISessionCondition conditionVO);
	
	
	/**
	 * Session 목록
	 * 
	 * @param conditionVO
	 * @return
	 * @throws Exception
	 */
	Paginate<ResultSet> getList(UISessionCondition conditionVO) throws Exception;

}
