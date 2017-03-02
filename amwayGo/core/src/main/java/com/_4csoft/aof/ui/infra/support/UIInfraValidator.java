/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.support;

import org.springframework.stereotype.Component;

import com._4csoft.aof.infra.support.validator.InfraValidator;
import com._4csoft.aof.infra.support.validator.Validator;
import com._4csoft.aof.infra.vo.CategoryVO;
import com._4csoft.aof.infra.vo.CodeVO;
import com._4csoft.aof.infra.vo.CompanyMemberVO;
import com._4csoft.aof.infra.vo.CompanyVO;
import com._4csoft.aof.infra.vo.LikeHistoryVO;
import com._4csoft.aof.infra.vo.LoginHistoryVO;
import com._4csoft.aof.infra.vo.LoginStatusVO;
import com._4csoft.aof.infra.vo.MemberAccessHistoryVO;
import com._4csoft.aof.infra.vo.MemberAdminVO;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.infra.vo.MenuVO;
import com._4csoft.aof.infra.vo.MessageAddressGroupVO;
import com._4csoft.aof.infra.vo.MessageAddressVO;
import com._4csoft.aof.infra.vo.MessageReceiveVO;
import com._4csoft.aof.infra.vo.MessageSendVO;
import com._4csoft.aof.infra.vo.MessageTemplateVO;
import com._4csoft.aof.infra.vo.PushMessageTargetVO;
import com._4csoft.aof.infra.vo.RolegroupMemberVO;
import com._4csoft.aof.infra.vo.RolegroupMenuVO;
import com._4csoft.aof.infra.vo.RolegroupVO;
import com._4csoft.aof.infra.vo.ScheduleVO;
import com._4csoft.aof.infra.vo.SettingVO;
import com._4csoft.aof.infra.vo.base.ValidateType;
import com._4csoft.aof.ui.infra.vo.UICategoryVO;
import com._4csoft.aof.ui.infra.vo.UICodeVO;
import com._4csoft.aof.ui.infra.vo.UICompanyMemberVO;
import com._4csoft.aof.ui.infra.vo.UICompanyVO;
import com._4csoft.aof.ui.infra.vo.UILoginHistoryVO;
import com._4csoft.aof.ui.infra.vo.UILoginStatusVO;
import com._4csoft.aof.ui.infra.vo.UIMemberAccessHistoryVO;
import com._4csoft.aof.ui.infra.vo.UIMemberAdminVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.UIMenuVO;
import com._4csoft.aof.ui.infra.vo.UIMessageAddressGroupVO;
import com._4csoft.aof.ui.infra.vo.UIMessageAddressVO;
import com._4csoft.aof.ui.infra.vo.UIMessageReceiveVO;
import com._4csoft.aof.ui.infra.vo.UIMessageSendVO;
import com._4csoft.aof.ui.infra.vo.UIMessageTemplateVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupMemberVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupMenuVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupVO;
import com._4csoft.aof.ui.infra.vo.UIScheduleVO;
import com._4csoft.aof.ui.infra.vo.UISettingVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.support
 * @File : UIInfraValidator.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Component ("UIInfraValidator")
public class UIInfraValidator extends Validator implements InfraValidator {

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.CodeVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(CodeVO voCode, ValidateType validateType) throws Exception {
		UICodeVO vo = (UICodeVO)voCode;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("code", vo.getCode(), DataValidator.REQUIRED);
			validate("codeGroup", vo.getCodeGroup(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("code", vo.getCode(), DataValidator.REQUIRED);
			validate("codeGroup", vo.getCodeGroup(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("code", vo.getCode(), DataValidator.REQUIRED);
			validate("codeGroup", vo.getCodeGroup(), DataValidator.REQUIRED);
			validate("codeName", vo.getCodeName(), DataValidator.REQUIRED);
		}
		validate("code", vo.getCode(), DataValidator.NO_SPACE);
		validate("code", vo.getCode(), CompareValidator.MAX_LENGTH, 50);
		validate("codeGroup", vo.getCodeGroup(), DataValidator.NO_SPACE);
		validate("codeGroup", vo.getCodeGroup(), CompareValidator.MAX_LENGTH, 50);
		validate("codeName", vo.getCodeName(), CompareValidator.MAX_LENGTH, 100);
		validate("codeNameEx1", vo.getCodeNameEx1(), CompareValidator.MAX_LENGTH, 100);
		validate("codeNameEx2", vo.getCodeNameEx2(), CompareValidator.MAX_LENGTH, 100);
		validate("codeNameEx3", vo.getCodeNameEx3(), CompareValidator.MAX_LENGTH, 100);
		validate("description", vo.getDescription(), CompareValidator.MAX_LENGTH, 1000);
		validate("useYn", vo.getUseYn(), CompareValidator.FIX_LENGTH, 1);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.LoginHistoryVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(LoginHistoryVO voLoginHistory, ValidateType validateType) throws Exception {
		UILoginHistoryVO vo = (UILoginHistoryVO)voLoginHistory;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("loginHistorySeq", vo.getSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("loginSeq", vo.getSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("rolegroupSeq", vo.getRolegroupSeq().toString(), DataValidator.REQUIRED);
			validate("userAgent", vo.getUserAgent(), DataValidator.REQUIRED);
		}
		validate("site", vo.getSite(), CompareValidator.MAX_LENGTH, 100);
		validate("device", vo.getDevice(), CompareValidator.MAX_LENGTH, 100);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.LikeHistoryVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(LikeHistoryVO paramVo, ValidateType validateType) throws Exception {
		LikeHistoryVO vo = (LikeHistoryVO)paramVo;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("referenceSumColumnName", vo.getReferenceSumColumnName().toString(), DataValidator.REQUIRED);
			validate("referenceSeq", vo.getReferenceSeq().toString(), DataValidator.REQUIRED);
			validate("referenceTablename", vo.getReferenceTablename().toString(), DataValidator.REQUIRED);
			validate("likeHistorySeq", vo.getLikeHistorySeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.insert == validateType) {
			validate("referenceSumColumnName", vo.getReferenceSumColumnName().toString(), DataValidator.REQUIRED);
			validate("referenceSeq", vo.getReferenceSeq().toString(), DataValidator.REQUIRED);
			validate("referenceTablename", vo.getReferenceTablename().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.LoginStatusVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(LoginStatusVO voLoginStatus, ValidateType validateType) throws Exception {
		UILoginStatusVO vo = (UILoginStatusVO)voLoginStatus;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			return;
		}
		if (ValidateType.update == validateType) {
		}
		if (ValidateType.insert == validateType) {

		}
		validate("site", vo.getSite(), CompareValidator.MAX_LENGTH, 100);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.MemberVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(MemberVO voMember, ValidateType validateType) throws Exception {
		UIMemberVO vo = (UIMemberVO)voMember;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("memberId", vo.getMemberId(), DataValidator.REQUIRED);
			validate("memberName", vo.getMemberName(), DataValidator.REQUIRED);
			validate("password", vo.getPassword(), DataValidator.REQUIRED);
			validate("memberStatusCd", vo.getMemberStatusCd(), DataValidator.REQUIRED);
		}
		validate("memberId", vo.getMemberId(), DataValidator.NO_SPACE);
		validate("memberId", vo.getMemberId(), CompareValidator.MAX_LENGTH, 30);
		validate("memberId", vo.getMemberId(), CompareValidator.MIN_LENGTH, 5);
		validate("memberName", vo.getMemberName(), CompareValidator.MAX_LENGTH, 30);
		validate("password", vo.getPassword(), CompareValidator.MAX_LENGTH, 300);
		validate("password", vo.getPassword(), CompareValidator.MIN_LENGTH, 6);
		validate("memberStatusCd", vo.getMemberStatusCd(), CompareValidator.MAX_LENGTH, 50);
		validate("nickname", vo.getNickname(), CompareValidator.MAX_LENGTH, 30);
		validate("email", vo.getEmail(), CompareValidator.MAX_LENGTH, 500);
		validate("photo", vo.getPhoto(), CompareValidator.MAX_LENGTH, 500);
		validate("phoneMobile", vo.getPhoneMobile(), CompareValidator.MAX_LENGTH, 20);
		validate("phoneHome", vo.getPhoneHome(), CompareValidator.MAX_LENGTH, 20);
		validate("zipcode", vo.getZipcode(), CompareValidator.MAX_LENGTH, 10);
		validate("address", vo.getAddress(), CompareValidator.MAX_LENGTH, 200);
		validate("addressDetail", vo.getAddressDetail(), CompareValidator.MAX_LENGTH, 200);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.MemberAdminVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(MemberAdminVO voMemberAdmin, ValidateType validateType) throws Exception {
		UIMemberAdminVO vo = (UIMemberAdminVO)voMemberAdmin;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.CompanyVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(CompanyVO voCompany, ValidateType validateType) throws Exception {
		UICompanyVO vo = (UICompanyVO)voCompany;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("companySeq", vo.getCompanySeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("companySeq", vo.getCompanySeq().toString(), DataValidator.REQUIRED);
			validate("companyName", vo.getCompanyName(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("companyName", vo.getCompanyName(), DataValidator.REQUIRED);
		}
		validate("businessNumber", vo.getBusinessNumber(), CompareValidator.MAX_LENGTH, 20);
		validate("businessNumber", vo.getBusinessNumber(), DataValidator.NUMBER);
		validate("companyName", vo.getCompanyName(), CompareValidator.MAX_LENGTH, 100);
		validate("phoneOffice", vo.getPhoneOffice(), CompareValidator.MAX_LENGTH, 20);
		validate("phoneOffice", vo.getPhoneOffice(), DataValidator.NUMBER);
		validate("phoneFax", vo.getPhoneFax(), CompareValidator.MAX_LENGTH, 20);
		validate("phoneFax", vo.getPhoneFax(), DataValidator.NUMBER);
		validate("zipcode", vo.getZipcode(), CompareValidator.MAX_LENGTH, 10);
		validate("zipcode", vo.getZipcode(), DataValidator.NUMBER);
		validate("address", vo.getAddress(), CompareValidator.MAX_LENGTH, 200);
		validate("addressDetail", vo.getAddressDetail(), CompareValidator.MAX_LENGTH, 200);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.CompanyMemberVO,
	 * com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(CompanyMemberVO voCompanyMember, ValidateType validateType) throws Exception {
		UICompanyMemberVO vo = (UICompanyMemberVO)voCompanyMember;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("companySeq", vo.getCompanySeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("companySeq", vo.getCompanySeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("companySeq", vo.getCompanySeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.MenuVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(MenuVO voMenu, ValidateType validateType) throws Exception {
		UIMenuVO vo = (UIMenuVO)voMenu;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("menuSeq", vo.getMenuSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("menuSeq", vo.getMenuSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("menuId", vo.getMenuId(), DataValidator.REQUIRED);
			validate("menuName", vo.getMenuName(), DataValidator.REQUIRED);
			validate("displayYn", vo.getDisplayYn(), DataValidator.REQUIRED);
		}
		validate("menuId", vo.getMenuId(), DataValidator.NO_SPACE);
		validate("menuId", vo.getMenuId(), CompareValidator.MAX_LENGTH, 20);
		validate("menuName", vo.getMenuName(), CompareValidator.MAX_LENGTH, 30);
		validate("url", vo.getUrl(), CompareValidator.MAX_LENGTH, 200);
		validate("urlTarget", vo.getUrlTarget(), CompareValidator.MAX_LENGTH, 50);
		validate("dependent", vo.getDependent(), CompareValidator.MAX_LENGTH, 50);
		validate("description", vo.getDescription(), CompareValidator.MAX_LENGTH, 1000);
		validate("displayYn", vo.getDisplayYn(), CompareValidator.MAX_LENGTH, 1);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.RolegroupMemberVO,
	 * com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(RolegroupMemberVO voRolegroupMember, ValidateType validateType) throws Exception {
		UIRolegroupMemberVO vo = (UIRolegroupMemberVO)voRolegroupMember;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("rolegroupSeq", vo.getRolegroupSeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("rolegroupSeq", vo.getRolegroupSeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("rolegroupSeq", vo.getRolegroupSeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.RolegroupMenuVO,
	 * com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(RolegroupMenuVO voRolegroupMenu, ValidateType validateType) throws Exception {
		UIRolegroupMenuVO vo = (UIRolegroupMenuVO)voRolegroupMenu;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("rolegroupSeq", vo.getRolegroupSeq().toString(), DataValidator.REQUIRED);
			validate("menuSeq", vo.getMenuSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("rolegroupSeq", vo.getRolegroupSeq().toString(), DataValidator.REQUIRED);
			validate("menuSeq", vo.getMenuSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("rolegroupSeq", vo.getRolegroupSeq().toString(), DataValidator.REQUIRED);
			validate("menuSeq", vo.getMenuSeq().toString(), DataValidator.REQUIRED);
		}
		validate("crud", vo.getCrud(), CompareValidator.MAX_LENGTH, 50);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.RolegroupVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(RolegroupVO voRolegroup, ValidateType validateType) throws Exception {
		UIRolegroupVO vo = (UIRolegroupVO)voRolegroup;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("rolegroupSeq", vo.getRolegroupSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("rolegroupSeq", vo.getRolegroupSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("parentSeq", vo.getParentSeq().toString(), DataValidator.REQUIRED);
			validate("rolegroupName", vo.getRolegroupName(), DataValidator.REQUIRED);
			validate("roleCd", vo.getRoleCd(), DataValidator.REQUIRED);
		}
		validate("rolegroupName", vo.getRolegroupName(), CompareValidator.MAX_LENGTH, 100);
		validate("roleCd", vo.getRoleCd(), CompareValidator.MAX_LENGTH, 50);
		validate("accessFtpDir", vo.getAccessFtpDir(), CompareValidator.MAX_LENGTH, 4000);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.CategoryVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(CategoryVO voCategory, ValidateType validateType) throws Exception {
		UICategoryVO vo = (UICategoryVO)voCategory;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("categorySeq", vo.getCategorySeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("categorySeq", vo.getCategorySeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("categoryName", vo.getCategoryName(), DataValidator.REQUIRED);
			validate("categoryTypeCd", vo.getCategoryTypeCd(), DataValidator.REQUIRED);
			validate("parentSeq", vo.getParentSeq().toString(), DataValidator.REQUIRED);
		}
		validate("categoryName", vo.getCategoryName(), CompareValidator.MAX_LENGTH, 100);
		validate("categoryTypeCd", vo.getCategoryTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("sortOrder", vo.getSortOrder(), DataValidator.NUMBER);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.SettingVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(SettingVO voSetting, ValidateType validateType) throws Exception {
		UISettingVO vo = (UISettingVO)voSetting;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("settingTypeCd", vo.getSettingTypeCd(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("settingTypeCd", vo.getSettingTypeCd(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("settingTypeCd", vo.getSettingTypeCd(), DataValidator.REQUIRED);
		}
		validate("settingTypeCd", vo.getSettingTypeCd(), CompareValidator.MAX_LENGTH, 50);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.ScheduleVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(ScheduleVO voSchedule, ValidateType validateType) throws Exception {
		UIScheduleVO vo = (UIScheduleVO)voSchedule;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("scheduleSeq", vo.getScheduleSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("scheduleSeq", vo.getScheduleSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("scheduleTitle", vo.getScheduleTitle(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
			validate("startDtime", vo.getStartDtime(), DataValidator.REQUIRED);
			validate("endDtime", vo.getEndDtime(), DataValidator.REQUIRED);
			validate("repeatYn", vo.getRepeatYn(), DataValidator.REQUIRED);
		}
		validate("scheduleTitle", vo.getScheduleTitle(), CompareValidator.MAX_LENGTH, 30);
		validate("startDtime", vo.getStartDtime(), CompareValidator.FIX_LENGTH, 14);
		validate("endDtime", vo.getEndDtime(), CompareValidator.FIX_LENGTH, 14);
		validate("repeatYn", vo.getRepeatYn(), CompareValidator.FIX_LENGTH, 1);
		validate("repeatTypeCd", vo.getRepeatTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("repeatWeek", vo.getRepeatWeek(), CompareValidator.MAX_LENGTH, 50);
		validate("repeatEndDate", vo.getRepeatEndDate(), CompareValidator.FIX_LENGTH, 14);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.MessageSendVO, com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(MessageSendVO voMessageSend, ValidateType validateType) throws Exception {
		UIMessageSendVO vo = (UIMessageSendVO)voMessageSend;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("messageSendSeq", vo.getMessageSendSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			return;
		}
		if (ValidateType.detail == validateType) {
			validate("messageSendSeq", vo.getMessageSendSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.insert == validateType) {
			validate("sendMemberSeq", vo.getSendMemberSeq().toString(), DataValidator.REQUIRED);
			validate("description", vo.getDescription(), DataValidator.REQUIRED);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.MessageReceiveVO,
	 * com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(MessageReceiveVO voMessageReceive, ValidateType validateType) throws Exception {
		UIMessageReceiveVO vo = (UIMessageReceiveVO)voMessageReceive;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("messageReceiveSeq", vo.getMessageReceiveSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			return;
		}
		if (ValidateType.detail == validateType) {
			validate("messageReceiveSeq", vo.getMessageReceiveSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.insert == validateType) {
			validate("messageSendSeq", vo.getMessageSendSeq().toString(), DataValidator.REQUIRED);
			validate("receiveMemberSeq", vo.getReceiveMemberSeq().toString(), DataValidator.REQUIRED);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.MessageAddressVO,
	 * com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(MessageAddressVO voMessageAddress, ValidateType validateType) throws Exception {
		UIMessageAddressVO vo = (UIMessageAddressVO)voMessageAddress;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("addressGroupSeq", vo.getAddressGroupSeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			return;
		}
		if (ValidateType.insert == validateType) {
			validate("addressGroupSeq", vo.getAddressGroupSeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.MessageAddressGroupVO,
	 * com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(MessageAddressGroupVO voMessageAddressGroup, ValidateType validateType) throws Exception {
		UIMessageAddressGroupVO vo = (UIMessageAddressGroupVO)voMessageAddressGroup;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("addressGroupSeq", vo.getAddressGroupSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("addressGroupSeq", vo.getAddressGroupSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("groupName", vo.getGroupName(), DataValidator.REQUIRED);
		}
		validate("groupName", vo.getGroupName(), CompareValidator.MAX_LENGTH, 200);
	}

	public void validate(MessageTemplateVO messageTemplateVO, ValidateType validateType) throws Exception {
		UIMessageTemplateVO vo = (UIMessageTemplateVO)messageTemplateVO;
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("templateTypeCd", vo.getTemplateTypeCd(), DataValidator.REQUIRED);
		}
		if (ValidateType.update == validateType) {
			validate("addressGroupSeq", vo.getTemplateSeq().toString(), DataValidator.REQUIRED);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.MemberAccessHistoryVO,
	 * com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(MemberAccessHistoryVO voMemberAccessHistory, ValidateType validateType) throws Exception {
		UIMemberAccessHistoryVO vo = (UIMemberAccessHistoryVO)voMemberAccessHistory;
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com._4csoft.aof.infra.support.validator.InfraValidator#validate(com._4csoft.aof.infra.vo.PushMessageTargetVO,
	 * com._4csoft.aof.infra.vo.base.ValidateType)
	 */
	public void validate(PushMessageTargetVO vo, ValidateType validateType) throws Exception {
		if (ValidateType.insert == validateType) {
			validate("deviceId", vo.getDeviceId(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("pushMessageTargetSeq", vo.getPushMessageTargetSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("pushMessageTargetSeq", vo.getPushMessageTargetSeq().toString(), DataValidator.REQUIRED);
		}
	}

}
