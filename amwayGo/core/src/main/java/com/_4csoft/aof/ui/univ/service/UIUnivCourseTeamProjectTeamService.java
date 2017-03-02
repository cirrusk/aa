/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service;

import java.util.List;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTeamVO;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectMemberVO;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectTeamVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.univ.service
 * @File : UnivCourseTeamProjectTeamService.java
 * @Title : 개설과목 팀프로젝트 팀
 * @date : 2014. 2. 27.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public interface UIUnivCourseTeamProjectTeamService {

	/**
	 * 랜덤하게 팀프로젝트 팀 구성
	 * 
	 * @param vo
	 * @return int
	 * @throws Exception
	 */
	int insertRandomCourseTeamProjectTeam(UnivCourseTeamProjectTeamVO vo) throws Exception;

	/**
	 * 팀프로젝트 팀 등록
	 * 
	 * @param vo
	 * @return int
	 * @throws Exception
	 */
	int insert(UnivCourseTeamProjectTeamVO vo) throws Exception;

	/**
	 * 팀프로젝트 팀 수정
	 * 
	 * @param vo
	 * @return int
	 * @throws Exception
	 */
	int update(UnivCourseTeamProjectTeamVO vo) throws Exception;

	/**
	 * 팀프로젝트 팀 삭제
	 * 
	 * @param vo
	 * @return int
	 * @throws Exception
	 */
	int delete(UnivCourseTeamProjectTeamVO vo) throws Exception;

	/**
	 * 팀프로젝트 팀 상세정보
	 * 
	 * @param courseTeamSeq
	 * @return ResultSet
	 * @throws Exception
	 */
	ResultSet getDetail(Long courseTeamSeq) throws Exception;

	/**
	 * 팀프로젝트의 모든 팀 목록
	 * 
	 * @param courseTeamProjectSeq
	 * @return List<ResultSet>
	 * @throws Exception
	 */
	List<ResultSet> getListAllCourseTeamProjectTeam(Long courseTeamProjectSeq) throws Exception;

	/**
	 * 팀프로젝트의 팀 복사
	 * 
	 * @param voList
	 * @return int
	 * @throws Exception
	 */
	int insertlistCopingProjectTeam(List<UnivCourseTeamProjectTeamVO> voList) throws Exception;

	/**
	 * 프로젝트 팀 결과목록
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	List<ResultSet> getListTeamProjectResult(UnivCourseTeamProjectTeamVO vo) throws Exception;

	/**
	 * 학습자의 프로젝팀 상세 정보
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	ResultSet getDetailCourseTeamProjectTeamByUser(UnivCourseTeamProjectTeamVO vo) throws Exception;

	/**
	 * 수동 팀프로젝트 팀 구성
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	int insertManualCourseTeamProjectTeam(UnivCourseTeamProjectTeamVO vo) throws Exception;
	
	/**
	 * 팀원 일괄등록
	 * 
	 * @param voList
	 * @param team 
	 * @param rolegroupMember
	 * @param memberAdmin
	 * @return
	 * @throws Exception
	 */
	public int insertlistMember(List<UnivCourseTeamProjectMemberVO> voList, UIUnivCourseTeamProjectTeamVO team) throws Exception;
}
