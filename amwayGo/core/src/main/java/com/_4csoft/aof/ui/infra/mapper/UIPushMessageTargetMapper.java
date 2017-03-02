/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.mapper;

import com._4csoft.aof.infra.mapper.PushMessageTargetMapper;
import com._4csoft.aof.ui.infra.vo.UIPushMessageTargetVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Project : lgaca-core
 * @Package : UIPushMessageTarget.sql.mssql
 * @File : UIPushMessageTargetMapper.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 25.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Mapper ("UIPushMessageTargetMapper")
public interface UIPushMessageTargetMapper extends PushMessageTargetMapper {
	/**
	 * 운영과목의 수강생 메시지 다중 저장
	 * 
	 * @param vo
	 * @return
	 */
	int insertlistMessageOfCourseApply(UIPushMessageTargetVO vo);

	/**
	 * 운영과목의 수강생 단말기정보 수
	 * 
	 * @param vo
	 * @return
	 */
	int countMessageOfCourseApply(UIPushMessageTargetVO vo);
	
	/**
	 * 맴버 다중 메세지 전송
	 * @param vo
	 * @return
	 */
	int insertPushSendMember(UIPushMessageTargetVO vo);
	
	/**
	 * 맴버 다중 메세지 전송 카운트
	 * @param vo
	 * @return
	 */
	int countPushSendMember(UIPushMessageTargetVO vo);
}
