/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.mapper.UXCompetitionMapper;
import com._4csoft.aof.ui.infra.service.UXCompetitionService;
import com._4csoft.aof.ui.infra.vo.UXCompetitionVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.infra.service.impl
 * @File : UIMemberServiceImpl.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 31.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UXCompetitionService")
public class UXCompetitionServiceImpl implements UXCompetitionService {

	@Resource (name = "UXCompetitionMapper")
	private UXCompetitionMapper competitionMapper;

	public ResultSet getListCompetition() throws Exception {
		return competitionMapper.getListCompetition();
	}
	
	public int update(UXCompetitionVO vo) throws Exception {
		int success = 0;
		success = competitionMapper.update(vo);
		return success;
	}
	
}
