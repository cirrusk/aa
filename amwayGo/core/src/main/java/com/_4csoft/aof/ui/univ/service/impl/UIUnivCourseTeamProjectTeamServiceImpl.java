/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.mapper.UIUnivCourseApplyMapper;
import com._4csoft.aof.ui.univ.service.UIUnivCourseTeamProjectTeamService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTeamVO;
import com._4csoft.aof.univ.mapper.UnivCourseApplyMapper;
import com._4csoft.aof.univ.mapper.UnivCourseTeamProjectMemberMapper;
import com._4csoft.aof.univ.mapper.UnivCourseTeamProjectTeamMapper;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectMemberVO;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectTeamVO;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.univ.service.impl
 * @File : UnivCourseTeamProjectTeamServiceImpl.java
 * @Title : 개설과목 팀프로젝트 팀
 * @date : 2014. 2. 27.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UIUnivCourseTeamProjectTeamService")
public class UIUnivCourseTeamProjectTeamServiceImpl extends AbstractServiceImpl implements UIUnivCourseTeamProjectTeamService {

	@Resource (name = "UnivCourseApplyMapper")
	private UnivCourseApplyMapper univCourseApplyMapper;
	
	@Resource (name = "UIUnivCourseApplyMapper")
	private UIUnivCourseApplyMapper UIunivCourseApplyMapper;

	@Resource (name = "UnivCourseTeamProjectTeamMapper")
	private UnivCourseTeamProjectTeamMapper univCourseTeamProjectTeamMapper;

	@Resource (name = "UnivCourseTeamProjectMemberMapper")
	private UnivCourseTeamProjectMemberMapper univCourseTeamProjectMemberMapper;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService#insertRandomCourseTeamProjectTeam(com._4csoft.aof.univ.vo.UnivCourseTeamProjectTeamVO)
	 */
	public int insertRandomCourseTeamProjectTeam(UnivCourseTeamProjectTeamVO vo) throws Exception {

		int success = 0;
		// 요청한 팀생성 수
		Long projectTeamCount = vo.getProjectTeamCount();

		// 개설과목을 수강한 수강생을 가져온다.
		List<Long> applyMembers = univCourseApplyMapper.getListCourseActiveSeq(vo.getCourseActiveSeq());

		// 배정 가능한 팀원수
		Long ableTeamCount = applyMembers.size() / projectTeamCount;

		Long courseTeamSeq = 0L; // 프로젝트팀 일련번호
		Long sortOrder = 0L;// 생성된 팀수(= 순서)
		int alphabetChar = 1;
		List<Long> courseTeamSeqs = new ArrayList<Long>();

		for (int i = 0; i < applyMembers.size(); i++) {
			if (i == 0 || ((ableTeamCount * sortOrder) == i && sortOrder < projectTeamCount)) {
				// 팀 생성
				UnivCourseTeamProjectTeamVO courseTeamProjectTeam = new UnivCourseTeamProjectTeamVO();
				courseTeamProjectTeam.setCourseTeamProjectSeq(vo.getCourseTeamProjectSeq());
				courseTeamProjectTeam.setSortOrder(sortOrder + 1);
				courseTeamProjectTeam.setTeamTitle((alphabetChar + sortOrder) + "");
				courseTeamProjectTeam.copyAudit(vo);
				success += univCourseTeamProjectTeamMapper.insert(courseTeamProjectTeam);
				courseTeamSeq = courseTeamProjectTeam.getCourseTeamSeq();

				// 팀 인원수를 업데이트하기 위해 셋팅
				courseTeamSeqs.add(courseTeamSeq);

				// 팀장 저장
				UnivCourseTeamProjectMemberVO courseTeamProjectMember = new UnivCourseTeamProjectMemberVO();
				courseTeamProjectMember.setCourseTeamSeq(courseTeamSeq);
				courseTeamProjectMember.setChiefYn("Y");
				courseTeamProjectMember.setTeamMemberSeq(applyMembers.get(i));
				courseTeamProjectMember.copyAudit(vo);

				univCourseTeamProjectMemberMapper.insert(courseTeamProjectMember);
				sortOrder = sortOrder + 1; // 생성된 팀수+1(= 순서)

			} else {
				// 팀원 저장
				UnivCourseTeamProjectMemberVO courseTeamProjectMember = new UnivCourseTeamProjectMemberVO();
				courseTeamProjectMember.setCourseTeamSeq(courseTeamSeq);
				courseTeamProjectMember.setChiefYn("N");
				courseTeamProjectMember.setTeamMemberSeq(applyMembers.get(i));
				courseTeamProjectMember.copyAudit(vo);

				univCourseTeamProjectMemberMapper.insert(courseTeamProjectMember);

			}
		}

		// 인원수 업데이트
		for (Long tempCourseTeamSeq : courseTeamSeqs) {
			UnivCourseTeamProjectTeamVO o = new UnivCourseTeamProjectTeamVO();
			o.setCourseTeamSeq(tempCourseTeamSeq);
			o.copyAudit(vo);

			univCourseTeamProjectTeamMapper.updateMemberCountByCourseTeamSeq(o);
		}

		return success;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService#insertManualCourseTeamProjectTeam(com._4csoft.aof.univ.vo.UnivCourseTeamProjectTeamVO)
	 */
	public int insertManualCourseTeamProjectTeam(UnivCourseTeamProjectTeamVO vo) throws Exception {

		int success = 0;
		// 요청한 팀생성 수
		Long projectTeamCount = vo.getProjectTeamCount();

		Long sortOrder = 0L;// 생성된 팀수(= 순서)
		int alphabetChar = 1;

		for (int i = 0; i < projectTeamCount; i++) {
			// 팀 생성
			UnivCourseTeamProjectTeamVO courseTeamProjectTeam = new UnivCourseTeamProjectTeamVO();
			courseTeamProjectTeam.setCourseTeamProjectSeq(vo.getCourseTeamProjectSeq());
			courseTeamProjectTeam.setTeamTitle((alphabetChar + sortOrder) + "");

			sortOrder = sortOrder + 1; // 생성된 팀수+1(= 순서)
			courseTeamProjectTeam.setSortOrder(sortOrder);

			courseTeamProjectTeam.copyAudit(vo);

			success += univCourseTeamProjectTeamMapper.insert(courseTeamProjectTeam);
		}

		return success;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService#insert(com._4csoft.aof.univ.vo.UnivCourseTeamProjectTeamVO)
	 */
	public int insert(UnivCourseTeamProjectTeamVO vo) throws Exception {
		return univCourseTeamProjectTeamMapper.insert(vo);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService#update(com._4csoft.aof.univ.vo.UnivCourseTeamProjectTeamVO)
	 */
	public int update(UnivCourseTeamProjectTeamVO vo) throws Exception {
		return univCourseTeamProjectTeamMapper.update(vo);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService#delete(com._4csoft.aof.univ.vo.UnivCourseTeamProjectTeamVO)
	 */
	public int delete(UnivCourseTeamProjectTeamVO vo) throws Exception {
		return univCourseTeamProjectTeamMapper.delete(vo);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService#getDetail(java.lang.Long)
	 */
	public ResultSet getDetail(Long courseTeam) throws Exception {
		return univCourseTeamProjectTeamMapper.getDetail(courseTeam);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService#getListAllCourseTeamProjectTeam(java.lang.Long)
	 */
	public List<ResultSet> getListAllCourseTeamProjectTeam(Long courseTeamProjectSeq) throws Exception {
		return univCourseTeamProjectTeamMapper.getListAllCourseTeamProjectTeam(courseTeamProjectSeq);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService#insertlistCopingProjectTeam(java.util.List)
	 */
	public int insertlistCopingProjectTeam(List<UnivCourseTeamProjectTeamVO> voList) throws Exception {

		int success = 0;
		for (UnivCourseTeamProjectTeamVO vo : voList) {
			univCourseTeamProjectTeamMapper.insert(vo);
			Long targetCourseTeamSeq = vo.getCourseTeamSeq();

			UnivCourseTeamProjectMemberVO teamMember = new UnivCourseTeamProjectMemberVO();
			teamMember.setTargetCourseTeamSeq(targetCourseTeamSeq);
			teamMember.setSourceCourseTeamSeq(vo.getSourceCourseTeamSeq());

			teamMember.copyAudit(vo);
			univCourseTeamProjectMemberMapper.copyTeamMember(teamMember);

			success++;
		}

		return success;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService#getListAllCourseProjectTeamByUser(com._4csoft.aof.univ.vo.UnivCourseTeamProjectTeamVO)
	 */
	public List<ResultSet> getListTeamProjectResult(UnivCourseTeamProjectTeamVO vo) throws Exception {
		return univCourseTeamProjectTeamMapper.getListTeamProjectResult(vo);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com._4csoft.aof.univ.service.UnivCourseTeamProjectTeamService#getDetailCourseTeamProjectTeamByUser(com._4csoft.aof.univ.vo.UnivCourseTeamProjectTeamVO)
	 */
	public ResultSet getDetailCourseTeamProjectTeamByUser(UnivCourseTeamProjectTeamVO vo) throws Exception {
		return univCourseTeamProjectTeamMapper.getDetailUser(vo);
	}
	
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.ui.infra.service.UIMemberService#insertlistMember(java.util.List, com._4csoft.aof.ui.infra.vo.UIRolegroupMemberVO,
	 * com._4csoft.aof.ui.infra.vo.UIMemberAdminVO)
	 */
	public int insertlistMember(List<UnivCourseTeamProjectMemberVO> voList, UIUnivCourseTeamProjectTeamVO vo) throws Exception {
		int success = 0;
		// 요청한 팀생성 수
		Long projectTeamCount = vo.getProjectTeamCount();
		// 개설과목을 수강한 수강생을 가져온다.
		List<Long> applyMembers = univCourseApplyMapper.getListCourseActiveSeq(vo.getCourseActiveSeq());
		String[] applyMembersId = UIunivCourseApplyMapper.getListCourseActiveId(vo.getCourseActiveSeq());
		
		// 배정 가능한 팀원수
		//Long ableTeamCount = projectTeamCount;
		Long courseTeamSeq = 0L; // 프로젝트팀 일련번호
		Long sortOrder = 0L;// 생성된 팀수(= 순서)
		int alphabetChar = 1;
		List<Long> courseTeamSeqs = new ArrayList<Long>();

		for (int i = 0; i < projectTeamCount; i++) {
				Long teamTitle = alphabetChar + sortOrder;
				// 팀 생성
				UnivCourseTeamProjectTeamVO courseTeamProjectTeam = new UnivCourseTeamProjectTeamVO();
				courseTeamProjectTeam.setCourseTeamProjectSeq(vo.getCourseTeamProjectSeq());
				courseTeamProjectTeam.setSortOrder(sortOrder + 1);
				courseTeamProjectTeam.setTeamTitle((alphabetChar + sortOrder) + "");
				courseTeamProjectTeam.copyAudit(vo);
				success += univCourseTeamProjectTeamMapper.insert(courseTeamProjectTeam);
				courseTeamSeq = courseTeamProjectTeam.getCourseTeamSeq();
				// 팀 인원수를 업데이트하기 위해 셋팅
				courseTeamSeqs.add(courseTeamSeq);
			for(UnivCourseTeamProjectMemberVO teamSeq : voList){
				if(teamSeq.getCourseApplySeq().equals((Long)teamTitle)){
					if("Y".equals(teamSeq.getChiefYn())){
					// 팀장 저장
						UnivCourseTeamProjectMemberVO courseTeamProjectMember = new UnivCourseTeamProjectMemberVO();
						courseTeamProjectMember.setCourseTeamSeq(courseTeamSeq);
						courseTeamProjectMember.setChiefYn("Y");
						courseTeamProjectMember.setTeamMemberSeq(applyMembers.get(i));
						courseTeamProjectMember.copyAudit(vo);	
						for(int j=0; j < applyMembersId.length; j++){
							if(teamSeq.getTeamMemberName().equals(applyMembersId[j]) && "Y".equals(teamSeq.getChiefYn())){
								univCourseTeamProjectMemberMapper.insert(courseTeamProjectMember);
							}
						}
					}else{
					// 팀원 저장
						UnivCourseTeamProjectMemberVO courseTeamProjectMember = new UnivCourseTeamProjectMemberVO();
						courseTeamProjectMember.setCourseTeamSeq(courseTeamSeq);
						courseTeamProjectMember.setChiefYn("N");
						courseTeamProjectMember.setTeamMemberSeq(applyMembers.get(i));
						courseTeamProjectMember.copyAudit(vo);
						for(int j=0; j < applyMembersId.length; j++){
							if(teamSeq.getTeamMemberName().equals(applyMembersId[j])&& "N".equals(teamSeq.getChiefYn())){
								univCourseTeamProjectMemberMapper.insert(courseTeamProjectMember);
							}
						}
					}
				}
			}
			sortOrder = sortOrder + 1; // 생성된 팀수+1(= 순서)
		}
		// 인원수 업데이트
		for (Long tempCourseTeamSeq : courseTeamSeqs) {
			UnivCourseTeamProjectTeamVO o = new UnivCourseTeamProjectTeamVO();
			o.setCourseTeamSeq(tempCourseTeamSeq);
			o.copyAudit(vo);

			univCourseTeamProjectTeamMapper.updateMemberCountByCourseTeamSeq(o);
		}
		return success;
	}
}
