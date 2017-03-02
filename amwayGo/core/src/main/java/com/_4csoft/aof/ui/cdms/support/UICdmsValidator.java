/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.support;

import org.springframework.stereotype.Component;

import com._4csoft.aof.cdms.support.validator.CdmsValidator;
import com._4csoft.aof.cdms.vo.CdmsBbsVO;
import com._4csoft.aof.cdms.vo.CdmsChargeVO;
import com._4csoft.aof.cdms.vo.CdmsCommentVO;
import com._4csoft.aof.cdms.vo.CdmsModuleVO;
import com._4csoft.aof.cdms.vo.CdmsOutputVO;
import com._4csoft.aof.cdms.vo.CdmsProjectCompanyVO;
import com._4csoft.aof.cdms.vo.CdmsProjectGroupVO;
import com._4csoft.aof.cdms.vo.CdmsProjectMemberVO;
import com._4csoft.aof.cdms.vo.CdmsProjectVO;
import com._4csoft.aof.cdms.vo.CdmsSectionVO;
import com._4csoft.aof.cdms.vo.CdmsStudioMemberVO;
import com._4csoft.aof.cdms.vo.CdmsStudioTimeVO;
import com._4csoft.aof.cdms.vo.CdmsStudioVO;
import com._4csoft.aof.cdms.vo.CdmsStudioWorkVO;
import com._4csoft.aof.infra.support.validator.Validator;
import com._4csoft.aof.infra.vo.base.ValidateType;
import com._4csoft.aof.ui.cdms.vo.UICdmsBbsVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsChargeVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsCommentVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsModuleVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsOutputVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectCompanyVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectGroupVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectMemberVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsProjectVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsSectionVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioMemberVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioTimeVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioWorkVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.cdms.support
 * @File : UICdmsValidator.java
 * @Title : CDMS Validator
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Component ("UICdmsValidator")
public class UICdmsValidator extends Validator implements CdmsValidator {

	/**
	 * @param CdmsChargeVO
	 * @param validateType
	 * @throws Exception
	 */

	public void validate(CdmsChargeVO voCdmsCharge, ValidateType validateType) throws Exception {
		UICdmsChargeVO vo = (UICdmsChargeVO)voCdmsCharge;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			return;
		}
		if (ValidateType.update == validateType) {
		}
		if (ValidateType.insert == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
			validate("sectionIndex", vo.getSectionIndex().toString(), DataValidator.REQUIRED);
			validate("outputIndex", vo.getOutputIndex().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
			validate("memberCdmsTypeCd", vo.getMemberCdmsTypeCd(), DataValidator.REQUIRED);
		}
		validate("memberCdmsTypeCd", vo.getMemberCdmsTypeCd(), CompareValidator.MAX_LENGTH, 50);
	}

	/**
	 * @param CdmsCommentVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CdmsCommentVO voCdmsComment, ValidateType validateType) throws Exception {
		UICdmsCommentVO vo = (UICdmsCommentVO)voCdmsComment;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("commentSeq", vo.getCommentSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("commentSeq", vo.getCommentSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
			validate("sectionIndex", vo.getSectionIndex().toString(), DataValidator.REQUIRED);
			validate("outputIndex", vo.getOutputIndex().toString(), DataValidator.REQUIRED);
			validate("description", vo.getDescription(), DataValidator.REQUIRED);
			validate("ip", vo.getIp(), DataValidator.REQUIRED);
			validate("autoYn", vo.getAutoYn(), DataValidator.REQUIRED);
		}
		validate("outputStatusCd", vo.getOutputStatusCd(), CompareValidator.MAX_LENGTH, 50);
		validate("ip", vo.getIp(), CompareValidator.MAX_LENGTH, 50);
		validate("autoYn", vo.getAutoYn(), CompareValidator.FIX_LENGTH, 1);
	}

	/**
	 * @param CdmsModuleVO
	 * @param validateType
	 * @throws Exception
	 */

	public void validate(CdmsModuleVO voCdmsModule, ValidateType validateType) throws Exception {
		UICdmsModuleVO vo = (UICdmsModuleVO)voCdmsModule;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
			validate("sectionIndex", vo.getSectionIndex().toString(), DataValidator.REQUIRED);
			validate("outputIndex", vo.getOutputIndex().toString(), DataValidator.REQUIRED);
			validate("moduleIndex", vo.getModuleIndex().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
			validate("sectionIndex", vo.getSectionIndex().toString(), DataValidator.REQUIRED);
			validate("outputIndex", vo.getOutputIndex().toString(), DataValidator.REQUIRED);
			validate("moduleIndex", vo.getModuleIndex().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
			validate("sectionIndex", vo.getSectionIndex().toString(), DataValidator.REQUIRED);
			validate("outputIndex", vo.getOutputIndex().toString(), DataValidator.REQUIRED);
		}
		validate("outputStatusCd", vo.getOutputStatusCd(), CompareValidator.MAX_LENGTH, 50);
		validate("completeYn", vo.getCompleteYn(), CompareValidator.FIX_LENGTH, 1);
	}

	/**
	 * @param CdmsOutputVO
	 * @param validateType
	 * @throws Exception
	 */

	public void validate(CdmsOutputVO voCdmsOutput, ValidateType validateType) throws Exception {
		UICdmsOutputVO vo = (UICdmsOutputVO)voCdmsOutput;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
			validate("sectionIndex", vo.getSectionIndex().toString(), DataValidator.REQUIRED);
			validate("outputIndex", vo.getOutputIndex().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
			validate("sectionIndex", vo.getSectionIndex().toString(), DataValidator.REQUIRED);
			validate("outputIndex", vo.getOutputIndex().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
			validate("sectionIndex", vo.getSectionIndex().toString(), DataValidator.REQUIRED);
		}
		validate("outputCd", vo.getOutputCd(), CompareValidator.MAX_LENGTH, 50);
		validate("outputName", vo.getOutputName(), CompareValidator.MAX_LENGTH, 100);
		validate("outputStatusCd", vo.getOutputStatusCd(), CompareValidator.MAX_LENGTH, 50);
		validate("endDate", vo.getEndDate(), CompareValidator.FIX_LENGTH, 14);
		validate("moduleYn", vo.getModuleYn(), CompareValidator.FIX_LENGTH, 1);
		validate("completeYn", vo.getCompleteYn(), CompareValidator.FIX_LENGTH, 1);
	}

	/**
	 * @param CdmsProjectCompanyVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CdmsProjectCompanyVO voCdmsProjectCompany, ValidateType validateType) throws Exception {
		UICdmsProjectCompanyVO vo = (UICdmsProjectCompanyVO)voCdmsProjectCompany;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("companySeq", vo.getCompanySeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("companySeq", vo.getCompanySeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("companySeq", vo.getCompanySeq().toString(), DataValidator.REQUIRED);
		}
		validate("companyTypeCd", vo.getCompanyTypeCd(), CompareValidator.MAX_LENGTH, 50);
	}

	/**
	 * @param CdmsProjectMemberVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CdmsProjectMemberVO voCdmsProjectMember, ValidateType validateType) throws Exception {
		UICdmsProjectMemberVO vo = (UICdmsProjectMemberVO)voCdmsProjectMember;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
		}
		if (ValidateType.insert == validateType) {
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
		validate("memberCdmsTypeCd", vo.getMemberCdmsTypeCd(), CompareValidator.MAX_LENGTH, 50);
	}

	/**
	 * @param CdmsProjectVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CdmsProjectVO voCdmsProject, ValidateType validateType) throws Exception {
		UICdmsProjectVO vo = (UICdmsProjectVO)voCdmsProject;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("projectName", vo.getProjectName(), DataValidator.REQUIRED);
			validate("projectTypeCd", vo.getProjectTypeCd(), DataValidator.REQUIRED);
		}
		validate("projectName", vo.getProjectName(), CompareValidator.MAX_LENGTH, 100);
		validate("projectTypeCd", vo.getProjectTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("year", vo.getYear(), CompareValidator.FIX_LENGTH, 4);
		validate("startDate", vo.getStartDate(), CompareValidator.FIX_LENGTH, 14);
		validate("endDate", vo.getEndDate(), CompareValidator.FIX_LENGTH, 14);
		validate("completeYn", vo.getCompleteYn(), CompareValidator.FIX_LENGTH, 1);
	}

	/**
	 * @param CdmsProjectVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CdmsProjectGroupVO voCdmsProjectGroup, ValidateType validateType) throws Exception {
		UICdmsProjectGroupVO vo = (UICdmsProjectGroupVO)voCdmsProjectGroup;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("projectGroupSeq", vo.getProjectGroupSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("projectGroupSeq", vo.getProjectGroupSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("groupName", vo.getGroupName(), DataValidator.REQUIRED);
		}
		validate("groupName", vo.getGroupName(), CompareValidator.MAX_LENGTH, 100);
	}

	/**
	 * @param CdmsSectionVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CdmsSectionVO voCdmsSection, ValidateType validateType) throws Exception {
		UICdmsSectionVO vo = (UICdmsSectionVO)voCdmsSection;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
			validate("sectionIndex", vo.getSectionIndex().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
			validate("sectionIndex", vo.getSectionIndex().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("projectSeq", vo.getProjectSeq().toString(), DataValidator.REQUIRED);
		}
		validate("sectionName", vo.getSectionName(), CompareValidator.MAX_LENGTH, 100);
	}

	/**
	 * @param CdmsStudioVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CdmsStudioVO voCdmsStudio, ValidateType validateType) throws Exception {
		UICdmsStudioVO vo = (UICdmsStudioVO)voCdmsStudio;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("studioSeq", vo.getStudioSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("studioSeq", vo.getStudioSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("studioName", vo.getStudioName(), DataValidator.REQUIRED);
			validate("weekDay", vo.getWeekDay(), DataValidator.REQUIRED);
		}
		validate("studioName", vo.getStudioName(), CompareValidator.MAX_LENGTH, 100);
		validate("weekDay", vo.getWeekDay(), CompareValidator.MAX_LENGTH, 50);
		validate("useYn", vo.getUseYn(), CompareValidator.FIX_LENGTH, 1);
	}

	/**
	 * @param CdmsStudioMemberVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CdmsStudioMemberVO voCdmsStudioMember, ValidateType validateType) throws Exception {
		UICdmsStudioMemberVO vo = (UICdmsStudioMemberVO)voCdmsStudioMember;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("studioSeq", vo.getStudioSeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
		}
		if (ValidateType.insert == validateType) {
			validate("studioSeq", vo.getStudioSeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
	}

	/**
	 * @param CdmsStudioTimeVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CdmsStudioTimeVO voCdmsStudioTime, ValidateType validateType) throws Exception {
		UICdmsStudioTimeVO vo = (UICdmsStudioTimeVO)voCdmsStudioTime;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("studioTimeSeq", vo.getStudioTimeSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("studioTimeSeq", vo.getStudioTimeSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("studioSeq", vo.getStudioSeq().toString(), DataValidator.REQUIRED);
			validate("startTime", vo.getStartTime(), DataValidator.REQUIRED);
			validate("endTime", vo.getEndTime(), DataValidator.REQUIRED);
		}
		validate("startTime", vo.getStartTime(), CompareValidator.FIX_LENGTH, 4);
		validate("endTime", vo.getEndTime(), CompareValidator.FIX_LENGTH, 4);
	}

	/**
	 * @param CdmsStudioWorkVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CdmsStudioWorkVO voCdmsStudioWork, ValidateType validateType) throws Exception {
		UICdmsStudioWorkVO vo = (UICdmsStudioWorkVO)voCdmsStudioWork;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("workSeq", vo.getWorkSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("workSeq", vo.getWorkSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("studioSeq", vo.getStudioSeq().toString(), DataValidator.REQUIRED);
			validate("shootingCd", vo.getShootingCd(), DataValidator.REQUIRED);
			validate("startDtime", vo.getStartDtime(), DataValidator.REQUIRED);
			validate("endDtime", vo.getEndDtime(), DataValidator.REQUIRED);
		}
		validate("shootingCd", vo.getShootingCd(), CompareValidator.MAX_LENGTH, 50);
		validate("startDtime", vo.getStartDtime(), CompareValidator.FIX_LENGTH, 14);
		validate("endDtime", vo.getEndDtime(), CompareValidator.FIX_LENGTH, 14);
		validate("studioCancelTypeCd", vo.getStudioCancelTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("memo", vo.getMemo(), CompareValidator.MAX_LENGTH, 1000);
		validate("resultMemo", vo.getResultMemo(), CompareValidator.MAX_LENGTH, 1000);
		validate("cancelMemo", vo.getCancelMemo(), CompareValidator.MAX_LENGTH, 1000);
		validate("completeYn", vo.getCompleteYn(), CompareValidator.FIX_LENGTH, 1);
	}

	/**
	 * @param CdmsBbsVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CdmsBbsVO voCdmsBbs, ValidateType validateType) throws Exception {
		UICdmsBbsVO vo = (UICdmsBbsVO)voCdmsBbs;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("bbsSeq", vo.getBbsSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("bbsSeq", vo.getBbsSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("boardSeq", vo.getBoardSeq().toString(), DataValidator.REQUIRED);
			validate("bbsTitle", vo.getBbsTitle(), DataValidator.REQUIRED);
			validate("description", vo.getDescription(), DataValidator.REQUIRED);
		}

		validate("bbsTitle", vo.getBbsTitle(), CompareValidator.MAX_LENGTH, 200);
		validate("bbsTypeCd", vo.getBbsTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("alwaysTopYn", vo.getAlwaysTopYn(), CompareValidator.FIX_LENGTH, 1);
		validate("htmlYn", vo.getHtmlYn(), CompareValidator.FIX_LENGTH, 1);
		validate("secretYn", vo.getSecretYn(), CompareValidator.FIX_LENGTH, 1);
	}

}
