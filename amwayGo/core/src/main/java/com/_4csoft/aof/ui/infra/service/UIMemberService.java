/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.service;

import java.util.List;

import com._4csoft.aof.infra.service.MemberService;
import com._4csoft.aof.ui.infra.vo.UIMemberAdminVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupMemberVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.infra.service
 * @File : UIMemberService.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 31.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UIMemberService extends MemberService {

	/**
	 * 회원 배치 등록
	 * 
	 * @param voList
	 * @param rolegroupMember
	 * @param memberAdmin
	 * @return
	 * @throws Exception
	 */
	public int insertlistMember(List<UIMemberVO> voList, UIRolegroupMemberVO rolegroupMember, UIMemberAdminVO memberAdmin) throws Exception;
	
	
	/**
	 * 닉네임 변경
	 * 
	 * @param memberVO
	 * @return
	 * @throws Exception
	 */
	public void updateNickname(UIMemberVO memberVO);
	
	/**
	 * 닉네임 체크
	 * 
	 * @param memberVO
	 * @return
	 * @throws Exception
	 */
	public int countNickname(UIMemberVO memberVO);
	
	/**
	 * 본인이름으로 닉네임 확인
	 * 
	 * @param memberVO
	 * @return
	 * @throws Exception
	 */
	public int countNameCheckNickname(UIMemberVO memberVO);
	
}
