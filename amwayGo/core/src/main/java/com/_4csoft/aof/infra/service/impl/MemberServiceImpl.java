/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.infra.service.impl;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.defaults.DefaultSqlSessionFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.mapper.CompanyMapper;
import com._4csoft.aof.infra.mapper.CompanyMemberMapper;
import com._4csoft.aof.infra.mapper.MemberAdminMapper;
import com._4csoft.aof.infra.mapper.MemberMapper;
import com._4csoft.aof.infra.mapper.RolegroupMemberMapper;
import com._4csoft.aof.infra.service.MemberService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.InfraAttachReference;
import com._4csoft.aof.infra.support.InfraAttachReference.AttachType;
import com._4csoft.aof.infra.support.security.PasswordEncoder;
import com._4csoft.aof.infra.support.util.AttachUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.support.validator.InfraValidator;
import com._4csoft.aof.infra.vo.CompanyMemberVO;
import com._4csoft.aof.infra.vo.MemberAdminVO;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.infra.vo.RolegroupMemberVO;
import com._4csoft.aof.infra.vo.RolegroupVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.infra.vo.base.SearchConditionVO;
import com._4csoft.aof.infra.vo.base.ValidateType;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;

/**
 * @Project : aof5-infra
 * @Package : com._4csoft.aof.infra.service.impl
 * @File : MemberServiceImpl.java
 * @Title : Member Service Implements
 * @date : 2013. 4. 18.
 * @author : 김종규
 * @descrption : 메뉴 관리
 */
@Service ("MemberService")
public class MemberServiceImpl extends AbstractServiceImpl implements MemberService, UserDetailsService {

	@Resource (name = "MemberMapper")
	private MemberMapper memberMapper;

	@Resource (name = "MemberAdminMapper")
	private MemberAdminMapper memberAdminMapper;

	@Resource (name = "RolegroupMemberMapper")
	private RolegroupMemberMapper rolegroupMemberMapper;

	@Resource (name = "CompanyMapper")
	private CompanyMapper companyMapper;

	@Resource (name = "CompanyMemberMapper")
	private CompanyMemberMapper companyMemberMapper;

	@Resource (name = "UIPasswordEncoder")
	protected PasswordEncoder passwordEncoder;

	@Resource (name = "UIInfraValidator")
	protected InfraValidator validator;

	@Resource (name = "UIInfraAttachReference")
	protected InfraAttachReference attachReference;
	
	@Resource (name = "AttachUtil")
	private AttachUtil attachUtil;

	@Resource (name = "sqlSession")
	private DefaultSqlSessionFactory sqlSessionFactoryBean;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#insertMember(com._4csoft.aof.infra.vo.MemberVO, com._4csoft.aof.infra.vo.MemberAdminVO)
	 */
	public int insertMember(MemberVO vo, MemberAdminVO voMemberAdmin, CompanyMemberVO voCompanyMember) throws Exception {
		int success = 0;

		validator.validate(vo, ValidateType.insert);

		if (StringUtil.isNotEmpty(vo.getMemberId())) {
			if (memberMapper.countByMemberId(vo.getMemberId(), null) > 0) {
				throw processException(Errors.DATA_EXIST.desc, new String[] { "memberId" });
			}
		}
		if (StringUtil.isNotEmpty(vo.getNickname())) {
			if (memberMapper.countByNickname(vo.getNickname(), null) > 0 && !"운영자".equals(vo.getNickname())) {
				throw processException(Errors.DATA_EXIST.desc, new String[] { "nickname" });
			}
		}

		String salt = passwordEncoder.isUseSalt() ? passwordEncoder.encodePassword("admin", "") : "";
		vo.setPassword(passwordEncoder.encodePassword("111111", salt) + salt);

		String tempPath = vo.getPhoto();
		vo.setPhoto(attachUtil.getSavePath(tempPath, "/" + attachReference.getAttachReference(AttachType.MEMBER).getSavePath())); // 임시경로를 실제저장 경로로 변경하여 저장

		// 데이터 저장
		success = memberMapper.insert(vo);

		// 임시경로에서 실제저장 경로로 파일 이동.
		attachUtil.movePhoto(tempPath, vo.getPhoto(), true);

		// joiningRolegroupSeq 가 값이 있으면 rolegroup에 포함시킨다
		if (StringUtil.isNotEmpty(vo.getJoiningRolegroupSeq())) {
			RolegroupMemberVO voMember = new RolegroupMemberVO();

			voMember.setRolegroupSeq(vo.getJoiningRolegroupSeq());
			voMember.setMemberSeq(vo.getMemberSeq());
			voMember.copyAudit(vo);

			// 먼저 삭제하고
			rolegroupMemberMapper.delete(voMember);

			// 등록한다.
			validator.validate(vo, ValidateType.insert);
			rolegroupMemberMapper.insert(voMember);
		}

		// 관리자
		if (voMemberAdmin != null) {
			voMemberAdmin.setMemberSeq(vo.getMemberSeq());
			voMemberAdmin.copyAudit(vo);
			validator.validate(voMemberAdmin, ValidateType.insert);
			memberAdminMapper.insert(voMemberAdmin);
		}

		// 기업회원추가
		if (voCompanyMember != null) {
			voCompanyMember.setMemberSeq(vo.getMemberSeq());
			voCompanyMember.copyAudit(vo);
			validator.validate(voCompanyMember, ValidateType.insert);
			companyMemberMapper.insert(voCompanyMember);

			// 소속인원
			companyMapper.updateMemberCount(voCompanyMember.getCompanySeq());
		}

		return success;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#insertlistMember(java.util.List, com._4csoft.aof.infra.vo.RolegroupMemberVO,
	 * com._4csoft.aof.infra.vo.MemberAdminVO)
	 */
	public int insertlistMember(List<MemberVO> voList, RolegroupMemberVO rolegroupMember, MemberAdminVO memberAdmin) throws Exception {
		int success = 0;

		if (voList != null) {

			for (MemberVO member : voList) {

				member.copyAudit(rolegroupMember);

				// 데이타 유효성 검사
				validator.validate(member, ValidateType.insert);

				int existenceCount = memberMapper.countByMemberId(member.getMemberId(), null);

				// 중복 검사
				if (existenceCount > 0) {
					continue;
				}

				String salt = passwordEncoder.isUseSalt() ? passwordEncoder.encodePassword(member.getMemberId(), "") : "";
				member.setPassword(passwordEncoder.encodePassword(member.getPassword(), salt) + salt);

				// 데이타 저장
				memberMapper.insert(member);

				// 롤그룹 멤버 저장
				rolegroupMember.setMemberSeq(member.getMemberSeq());
				rolegroupMember.setRolegroupSeq(member.getJoiningRolegroupSeq());

				validator.validate(rolegroupMember, ValidateType.insert);
				rolegroupMemberMapper.insert(rolegroupMember);

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

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#updateMember(com._4csoft.aof.infra.vo.MemberVO, com._4csoft.aof.infra.vo.MemberAdminVO)
	 */
	public int updateMember(MemberVO vo, MemberAdminVO voMemberAdmin, CompanyMemberVO voCompanyMember) throws Exception {
		int success = 0;
		validator.validate(vo, ValidateType.update);

		if (StringUtil.isNotEmpty(vo.getMemberId())) {
			if (memberMapper.countByMemberId(vo.getMemberId(), vo.getMemberSeq()) > 0) {
				throw processException(Errors.DATA_EXIST.desc, new String[] { "memberId" });
			}
		}
		if (StringUtil.isNotEmpty(vo.getNickname())) {
			if (memberMapper.countByNickname(vo.getNickname(), vo.getMemberSeq()) > 0) {
				throw processException(Errors.DATA_EXIST.desc, new String[] { "nickname" });
			}
		}

		String tempPath = vo.getPhoto();
		vo.setPhoto(attachUtil.getSavePath(tempPath, "/" + attachReference.getAttachReference(AttachType.MEMBER).getSavePath())); // 임시경로를 실제저장 경로로 변경하여 저장
		// 데이터 저장
		success = memberMapper.update(vo);
		// 임시경로에서 실제저장 경로로 파일 이동.
		attachUtil.movePhoto(tempPath, vo.getPhoto(), true);

		// 관리자
		if (voMemberAdmin != null) {
			if (memberAdminMapper.countByMemberSeq(voMemberAdmin.getMemberSeq()) > 0) {
				validator.validate(voMemberAdmin, ValidateType.update);
				memberAdminMapper.update(voMemberAdmin);
			} else {
				validator.validate(voMemberAdmin, ValidateType.insert);
				memberAdminMapper.insert(voMemberAdmin);
			}
		}

		// 기업회원추가
		if (voCompanyMember != null) {
			companyMemberMapper.drop(voCompanyMember);
			voCompanyMember.copyAudit(vo);
			companyMapper.updateMemberCount(voCompanyMember.getCompanySeqOld());

			validator.validate(voCompanyMember, ValidateType.insert);
			companyMemberMapper.insert(voCompanyMember);
			companyMapper.updateMemberCount(voCompanyMember.getCompanySeq());
		}

		return success;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#updatePassword(com._4csoft.aof.infra.vo.MemberVO)
	 */
	public int updatePassword(MemberVO vo) throws Exception {
		int success = 0;
		if (StringUtil.isEmpty(vo.getMemberSeq())) {
			throw processException(Errors.DATA_REQUIRED.desc, new String[] { "memberSeq" });
		}
		if (StringUtil.isEmpty(vo.getPassword())) {
			throw processException(Errors.DATA_REQUIRED.desc, new String[] { "password" });
		}

		String salt = passwordEncoder.isUseSalt() ? passwordEncoder.encodePassword(vo.getMemberId(), "") : "";
		vo.setPassword(passwordEncoder.encodePassword(vo.getPassword(), salt) + salt);

		success = memberMapper.updatePassword(vo);
		return success;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#deleteMember(com._4csoft.aof.infra.vo.MemberVO)
	 */
	public int deleteMember(MemberVO vo) throws Exception {
		int success = 0;

		// 회원 삭제
		validator.validate(vo, ValidateType.delete);
		success = memberMapper.delete(vo);

		// 회원관리자 테이블 삭제
		MemberAdminVO voMemberAdmin = new MemberAdminVO();
		voMemberAdmin.setMemberSeq(vo.getMemberSeq());
		voMemberAdmin.copyAudit(vo);
		memberAdminMapper.delete(voMemberAdmin);

		// 롤그룹멤버 삭제
		RolegroupMemberVO voMember = new RolegroupMemberVO();
		voMember.setMemberSeq(vo.getMemberSeq());
		voMember.copyAudit(vo);
		rolegroupMemberMapper.dropAllByMember(voMember);

		// CDMS 소속회원 테이블 삭제
		List<CompanyMemberVO> list = companyMemberMapper.getListByMemberSeq(vo.getMemberSeq());

		CompanyMemberVO voCompanyMember = new CompanyMemberVO();
		voCompanyMember.setMemberSeq(vo.getMemberSeq());
		companyMemberMapper.drop(voCompanyMember);

		if (list != null) {
			for (CompanyMemberVO companyMember : list) {
				companyMapper.updateMemberCount(companyMember.getCompanySeq());
			}
		}

		return success;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#deletelistMember(java.util.List)
	 */
	public int deletelistMember(List<MemberVO> voList) throws Exception {
		int success = 0;
		if (voList != null) {
			for (MemberVO vo : voList) {
				// 회원 삭제
				validator.validate(vo, ValidateType.delete);
				success += memberMapper.delete(vo);

				// 회원관리자 테이블 삭제
				MemberAdminVO voMemberAdmin = new MemberAdminVO();
				voMemberAdmin.setMemberSeq(vo.getMemberSeq());
				voMemberAdmin.copyAudit(vo);
				memberAdminMapper.delete(voMemberAdmin);

				// 롤그룹멤버 삭제
				RolegroupMemberVO voMember = new RolegroupMemberVO();
				voMember.setMemberSeq(vo.getMemberSeq());
				voMember.copyAudit(vo);
				rolegroupMemberMapper.dropAllByMember(voMember);

				// CDMS 소속회원 테이블 삭제
				List<CompanyMemberVO> list = companyMemberMapper.getListByMemberSeq(vo.getMemberSeq());

				CompanyMemberVO voCompanyMember = new CompanyMemberVO();
				voCompanyMember.setMemberSeq(vo.getMemberSeq());
				companyMemberMapper.drop(voCompanyMember);

				if (list != null) {
					for (CompanyMemberVO companyMember : list) {
						companyMapper.updateMemberCount(companyMember.getCompanySeq());
					}
				}
			}
		}
		return success;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#getDetail(com._4csoft.aof.infra.vo.MemberVO)
	 */
	public ResultSet getDetail(MemberVO vo) throws Exception {
		if (StringUtil.isEmpty(vo.getMemberSeq())) {
			throw processException(Errors.DATA_REQUIRED.desc, new String[] { "memberSeq" });
		}
		return memberMapper.getDetail(vo.getMemberSeq());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#getDetailByMemberId(java.lang.String)
	 */
	public MemberVO getDetailByMemberId(String memberId) throws Exception {
		if (StringUtil.isEmpty(memberId)) {
			throw processException(Errors.DATA_REQUIRED.desc, new String[] { "memberId" });
		}

		return memberMapper.getDetailByMemberId(memberId);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#getDetailByEmail(java.lang.String)
	 */
	public MemberVO getDetailByEmail(String email) throws Exception {
		if (StringUtil.isEmpty(email)) {
			throw processException(Errors.DATA_REQUIRED.desc, new String[] { "email" });
		}

		return memberMapper.getDetailByEmail(email);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#getList(com._4csoft.aof.infra.vo.SearchConditionVO)
	 */
	public Paginate<ResultSet> getList(SearchConditionVO conditionVO) throws Exception {
		int totalCount = memberMapper.countList(conditionVO);
		Paginate<ResultSet> paginate = new Paginate<ResultSet>();
		if (totalCount > 0) {
			paginate.adjustPage(totalCount, conditionVO);
			paginate.paginated(memberMapper.getList(conditionVO), totalCount, conditionVO);
		}
		return paginate;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#countList(com._4csoft.aof.infra.vo.SearchConditionVO)
	 */
	public int countList(SearchConditionVO conditionVO) throws Exception {

		return memberMapper.countList(conditionVO);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#getListAdmin(com._4csoft.aof.infra.vo.base.SearchConditionVO)
	 */
	public Paginate<ResultSet> getListAdmin(SearchConditionVO conditionVO) throws Exception {
		int totalCount = memberAdminMapper.countList(conditionVO);
		Paginate<ResultSet> paginate = new Paginate<ResultSet>();
		if (totalCount > 0) {
			paginate.adjustPage(totalCount, conditionVO);
			paginate.paginated(memberAdminMapper.getList(conditionVO), totalCount, conditionVO);
		}
		return paginate;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#countListAdmin(com._4csoft.aof.infra.vo.base.SearchConditionVO)
	 */
	public int countListAdmin(SearchConditionVO conditionVO) throws Exception {

		return memberAdminMapper.countList(conditionVO);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#countMemberId(java.lang.String, java.lang.Long)
	 */
	public int countMemberId(String memberId, Long memberSeq) throws Exception {
		if (StringUtil.isEmpty(memberId)) {
			throw processException(Errors.DATA_REQUIRED.desc, new String[] { "memberId" });
		}

		return memberMapper.countByMemberId(memberId, memberSeq);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#countNickname(java.lang.String, java.lang.Long)
	 */
	public int countNickname(String nickname, Long memberSeq) throws Exception {
		if (StringUtil.isEmpty(nickname)) {
			throw processException(Errors.DATA_REQUIRED.desc, new String[] { "nickname" });
		}

		return memberMapper.countByNickname(nickname, memberSeq);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#getListStatistics(com._4csoft.aof.infra.vo.SearchConditionVO)
	 */
	public List<ResultSet> getListStatistics(SearchConditionVO conditionVO) throws Exception {

		return memberMapper.getListStatistics(conditionVO);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#getDetailStatistics()
	 */
	public ResultSet getDetailStatistics() throws Exception {

		return memberMapper.getDetailStatistics();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.security.core.userdetails.UserDetailsService#loadUserByUsername(java.lang.String)
	 */
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException, DataAccessException {
		try {
			String memberId = username;
			String signedPass = "";
			String extendData = "";
			if (memberId.indexOf(Constants.SEPARATOR) > -1) {
				String[] token = memberId.split(Constants.SEPARATOR);
				// 0: memberId, 1:signature, 2:password@signature, 3:extendData
				if (token.length >= 3) {
					memberId = token[0];
					String signature = StringUtil.decrypt(token[1], Constants.ENCODING_KEY);
					String password = StringUtil.decrypt(token[2], Constants.ENCODING_KEY);
					if (StringUtil.isNotEmpty(signature)) {
						try {
							long sign = Long.parseLong(signature);
							if ((new Date()).getTime() - sign < 10 * 1000) {
								String[] pair = password.split("@");
								if (pair.length == 2 && Long.parseLong(pair[1]) == sign) {
									signedPass = token[2];
								}
							}
						} catch (Exception e) {
							log.debug("parseLong exception - " + e.getMessage());
						}
					}
				}
				if (token.length > 3) {
					extendData = StringUtil.decrypt(token[3], Constants.ENCODING_KEY);
				}
			}
			MemberVO member = memberMapper.getDetailByMemberId(memberId);
			
			if (member == null) {
				throw new UsernameNotFoundException("Invalid user credentials");
			} else {
				if (passwordEncoder.isUseSalt()) {
					int len = member.getPassword().length() / 2;
					member.setSalt(member.getPassword().substring(len));
					member.setPassword(member.getPassword().substring(0, len));
				} else {
					member.setSalt("");
				}
				if (StringUtil.isNotEmpty(signedPass)) {
					member.setSalt("");
					member.setPassword(passwordEncoder.encodePassword(signedPass, ""));
				}
				
				member.setAdmin(memberAdminMapper.getDetailByMemberSeq(member.getMemberSeq()));
				member.getExtendData().put("extendData", extendData);

				List<RolegroupVO> rolegroupList = rolegroupMemberMapper.getListByMemberId(memberId);
				if (rolegroupList == null) {
					System.out.println("================================> rolegroupList is NULL");
					throw new UsernameNotFoundException("Invalid user credentials");
				} else {
					member.setRoleGroups(rolegroupList);
				}
			}
			System.out.println("비밀번호 : " + member.getPassword());
			return (UserDetails)member;
		} catch (Exception e) {
			System.out.println("================================> Invalid user credentials 출력");
			log.error(StringUtil.errorToString(e));
			throw new UsernameNotFoundException("Invalid user credentials");
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#getListAddressGroupPopup(com._4csoft.aof.infra.vo.SearchConditionVO)
	 */
	public Paginate<ResultSet> getListAddressGroup(SearchConditionVO conditionVO) throws Exception {
		int totalCount = memberMapper.countListAddressGroup(conditionVO);
		Paginate<ResultSet> paginate = new Paginate<ResultSet>();
		if (totalCount > 0) {
			paginate.adjustPage(totalCount, conditionVO);
			paginate.paginated(memberMapper.getListAddressGroup(conditionVO), totalCount, conditionVO);
		}
		return paginate;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.service.MemberService#getListMemoPopup(com._4csoft.aof.infra.vo.SearchConditionVO)
	 */
	public Paginate<ResultSet> getListExtend(SearchConditionVO conditionVO) throws Exception {
		int totalCount = memberMapper.countListExtend(conditionVO);
		Paginate<ResultSet> paginate = new Paginate<ResultSet>();
		if (totalCount > 0) {
			paginate.adjustPage(totalCount, conditionVO);
			paginate.paginated(memberMapper.getListExtend(conditionVO), totalCount, conditionVO);
		}
		return paginate;
	}

}
