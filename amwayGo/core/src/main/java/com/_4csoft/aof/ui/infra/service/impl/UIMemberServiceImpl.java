/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.mapper.MemberAdminMapper;
import com._4csoft.aof.infra.mapper.MemberMapper;
import com._4csoft.aof.infra.mapper.RolegroupMemberMapper;
import com._4csoft.aof.infra.service.impl.MemberServiceImpl;
import com._4csoft.aof.infra.support.util.ConfigUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.CompanyMemberVO;
import com._4csoft.aof.infra.vo.MemberAdminVO;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.infra.vo.base.ValidateType;
import com._4csoft.aof.ui.infra.mapper.UIMemberMapper;
import com._4csoft.aof.ui.infra.service.UIMemberService;
import com._4csoft.aof.ui.infra.vo.UIMemberAdminVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupMemberVO;

/**
 * @Project : lgaca-core
 * @Package : com._4csoft.aof.ui.infra.service.impl
 * @File : UIMemberServiceImpl.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 31.
 * @author : jcseo
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UIMemberService")
public class UIMemberServiceImpl extends MemberServiceImpl implements UIMemberService {

	@Resource (name = "RolegroupMemberMapper")
	private RolegroupMemberMapper rolegroupMemberMapper;

	@Resource (name = "MemberMapper")
	private MemberMapper memberMapper;
	
	@Resource (name = "UIMemberMapper")
	private UIMemberMapper UImemberMapper;

	@Resource (name = "MemberAdminMapper")
	private MemberAdminMapper memberAdminMapper;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.impl.MemberServiceImpl#insertMember(com._4csoft.aof.infra.vo.MemberVO, com._4csoft.aof.infra.vo.MemberAdminVO,
	 * com._4csoft.aof.infra.vo.CompanyMemberVO)
	 */
	public int insertMember(MemberVO vo, MemberAdminVO voMemberAdmin, CompanyMemberVO voCompanyMember) throws Exception {

		int success = super.insertMember(vo, voMemberAdmin, voCompanyMember);

		// 교강사도 학습자 롤 그룹에 추가한다.
		if (StringUtil.isNotEmpty(vo.getJoiningRolegroupSeq()) && vo.getJoiningRolegroupSeq().equals(3L)) {
			UIRolegroupMemberVO voMember = new UIRolegroupMemberVO();

			voMember.setRolegroupSeq(2L);
			voMember.setMemberSeq(vo.getMemberSeq());
			voMember.copyAudit(vo);

			// 먼저 삭제하고
			rolegroupMemberMapper.delete(voMember);

			// 등록한다.
			validator.validate(voMember, ValidateType.insert);
			rolegroupMemberMapper.insert(voMember);
		}

		return success;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.ui.infra.service.UIMemberService#insertlistMember(java.util.List, com._4csoft.aof.ui.infra.vo.UIRolegroupMemberVO,
	 * com._4csoft.aof.ui.infra.vo.UIMemberAdminVO)
	 */
	public int insertlistMember(List<UIMemberVO> voList, UIRolegroupMemberVO rolegroupMember, UIMemberAdminVO memberAdmin) throws Exception {
		int success = 0;

		if (voList != null) {

			for (UIMemberVO member : voList) {

				member.copyAudit(rolegroupMember);

				// 엑셀 업로드 일 경우 공백이 들어가서 제거해준다.
				member.setMemberId(member.getMemberId().replaceAll(" ", ""));

				// 데이타 유효성 검사
				validator.validate(member, ValidateType.insert);

				int existenceCount = memberMapper.countByMemberId(member.getMemberId(), null);

				// 중복 검사
				if (existenceCount > 0) {
					continue;
				}

				String salt = passwordEncoder.isUseSalt() ? passwordEncoder.encodePassword(member.getMemberId(), "") : "";
				member.setPassword(passwordEncoder.encodePassword(member.getPassword(), salt) + salt);

				// 인화원일 경우 학습자를 수강생으로 넣는다.
				if (memberAdmin != null) {
					member.setMemberEmsTypeCd("MEMBER_EMP_TYPE::001");
				}
				// "-" 을 ""(공백)으로 수정한다.
				if (StringUtil.isNotEmpty(member.getPhoneMobile())) {
					member.setPhoneMobile(member.getPhoneMobile().replaceAll("-", ""));
				}

				// 비학위 일련번호를 고정으로 들어간다.
				member.setCategoryOrganizationSeq(ConfigUtil.getInstance().getLong("category.nondegree.seq"));
				// 데이타 저장
				memberMapper.insert(member);

				// 롤그룹 멤버 저장
				rolegroupMember.setMemberSeq(member.getMemberSeq());
				rolegroupMember.setRolegroupSeq(member.getJoiningRolegroupSeq());

				validator.validate(rolegroupMember, ValidateType.insert);
				rolegroupMemberMapper.insert(rolegroupMember);

				// 교강사도 학습자 롤 그룹에 추가한다.
				if (StringUtil.isNotEmpty(member.getJoiningRolegroupSeq()) && member.getJoiningRolegroupSeq().equals(3L)) {
					UIRolegroupMemberVO voMember = new UIRolegroupMemberVO();

					voMember.setRolegroupSeq(2L);
					voMember.setMemberSeq(member.getMemberSeq());
					voMember.copyAudit(member);

					// 먼저 삭제하고
					rolegroupMemberMapper.delete(voMember);

					// 등록한다.
					validator.validate(voMember, ValidateType.insert);
					rolegroupMemberMapper.insert(voMember);
				}

				// 관리자, 교강사 일 경우
				if (memberAdmin != null) {
					memberAdmin.setMemberSeq(member.getMemberSeq());
					memberAdmin.setProfTypeCd(member.getProfTypeCd());
					memberAdmin.setJobTypeCd(member.getJobTypeCd());
					memberAdmin.setCdmsTaskTypeCd(member.getCdmsTaskTypeCd());

					validator.validate(memberAdmin, ValidateType.insert);
					// 관리자 정보 저장
					memberAdminMapper.insert(memberAdmin);
				}

				success = success + 1;
			}
		}

		return success;
	}
	
	
	public int countNickname(UIMemberVO memberVO){
		return UImemberMapper.countNickname(memberVO);
	}

	public void updateNickname(UIMemberVO memberVO) {
		UImemberMapper.updateNickname(memberVO);
	}
	
	public int countNameCheckNickname(UIMemberVO memberVO){
		return UImemberMapper.countNameCheckNickname(memberVO);
	}
	
}
