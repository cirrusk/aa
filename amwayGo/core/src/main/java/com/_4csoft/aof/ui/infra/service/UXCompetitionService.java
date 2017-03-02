/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.service;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UXCompetitionVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.infra.service
 * @File : UIMemberService.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 31.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UXCompetitionService {

	/**
	 * 대회여부 목록
	 * 
	 * @param voList
	 * @return
	 * @throws Exception
	 */
	ResultSet getListCompetition() throws Exception;
	
	int update(UXCompetitionVO vo) throws Exception;
}
