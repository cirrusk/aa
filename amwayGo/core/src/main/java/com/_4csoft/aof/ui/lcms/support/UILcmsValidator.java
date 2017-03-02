/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.support;

import org.springframework.stereotype.Component;

import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.support.validator.Validator;
import com._4csoft.aof.infra.vo.base.ValidateType;
import com._4csoft.aof.lcms.support.validator.LcmsValidator;
import com._4csoft.aof.lcms.vo.LcmsContentsOrganizationVO;
import com._4csoft.aof.lcms.vo.LcmsContentsVO;
import com._4csoft.aof.lcms.vo.LcmsDailyProgressVO;
import com._4csoft.aof.lcms.vo.LcmsItemResourceVO;
import com._4csoft.aof.lcms.vo.LcmsItemResourceVersionVO;
import com._4csoft.aof.lcms.vo.LcmsItemVO;
import com._4csoft.aof.lcms.vo.LcmsLearnerDatamodelDataVO;
import com._4csoft.aof.lcms.vo.LcmsLearnerDatamodelVO;
import com._4csoft.aof.lcms.vo.LcmsMetadataElementVO;
import com._4csoft.aof.lcms.vo.LcmsMetadataVO;
import com._4csoft.aof.lcms.vo.LcmsOrganizationVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsContentsVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsDailyProgressVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsItemResourceVersionVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsLearnerDatamodelDataVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsLearnerDatamodelVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.lcms.support
 * @File : UILcmsValidator.java
 * @Title : Lcms Validator
 * @date : 2014. 1. 28.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Component ("UILcmsValidator")
public class UILcmsValidator extends Validator implements LcmsValidator {

	/**
	 * @param organization
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(LcmsOrganizationVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("title", vo.getTitle(), DataValidator.REQUIRED);
			validate("contentsTypeCd", vo.getContentsTypeCd(), DataValidator.REQUIRED);
		}
		validate("title", vo.getTitle(), CompareValidator.MAX_LENGTH, 200);
		validate("identifier", vo.getIdentifier(), CompareValidator.MAX_LENGTH, 255);
		validate("contentsTypeCd", vo.getContentsTypeCd(), CompareValidator.MAX_LENGTH, 50);
	}

	/**
	 * @param item
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(LcmsItemVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("itemSeq", vo.getItemSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("itemSeq", vo.getItemSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
			validate("title", vo.getTitle(), DataValidator.REQUIRED);
		}
		validate("title", vo.getTitle(), CompareValidator.MAX_LENGTH, 200);
		validate("identifier", vo.getIdentifier(), CompareValidator.MAX_LENGTH, 255);
		validate("parameters", vo.getParameters(), CompareValidator.MAX_LENGTH, 4000);
		validate("dataFromLms", vo.getDataFromLms(), CompareValidator.MAX_LENGTH, 1000);
		validate("timeLimitAction", vo.getTimeLimitAction(), CompareValidator.MAX_LENGTH, 255);
		validate("minNormalizedMeasure", vo.getMinNormalizedMeasure(), CompareValidator.MAX_LENGTH, 50);
		validate("attemptDurationLimit", vo.getAttemptDurationLimit(), CompareValidator.MAX_LENGTH, 255);
		validate("completionThreshold", vo.getCompletionThreshold(), CompareValidator.MAX_LENGTH, 255);
	}

	/**
	 * @param itemResource
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(LcmsItemResourceVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("resourceSeq", vo.getResourceSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("resourceSeq", vo.getResourceSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("itemSeq", vo.getItemSeq().toString(), DataValidator.REQUIRED);
			validate("scormType", vo.getScormType(), DataValidator.REQUIRED);
			validate("resourceType", vo.getResourceType(), DataValidator.REQUIRED);
		}
		validate("identifier", vo.getIdentifier(), CompareValidator.MAX_LENGTH, 255);
		validate("scormType", vo.getScormType(), CompareValidator.MAX_LENGTH, 100);
		validate("resourceType", vo.getResourceType(), CompareValidator.MAX_LENGTH, 4000);
		validate("base", vo.getBase(), CompareValidator.MAX_LENGTH, 2000);
		validate("href", vo.getHref(), CompareValidator.MAX_LENGTH, 2000);
	}

	/**
	 * @param itemResourceVersion
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(LcmsItemResourceVersionVO voItemResourceVersion, ValidateType validateType) throws Exception {
		UILcmsItemResourceVersionVO vo = (UILcmsItemResourceVersionVO)voItemResourceVersion;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("versionSeq", vo.getVersionSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("versionSeq", vo.getVersionSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("resourceSeq", vo.getResourceSeq().toString(), DataValidator.REQUIRED);
			validate("hrefOriginal", vo.getHrefOriginal(), DataValidator.REQUIRED);
			validate("hrefBackup", vo.getHrefBackup(), DataValidator.REQUIRED);
			validate("version", vo.getVersion(), DataValidator.REQUIRED);
		}
		validate("hrefOriginal", vo.getHrefOriginal(), CompareValidator.MAX_LENGTH, 2000);
		validate("hrefBackup", vo.getHrefBackup(), CompareValidator.MAX_LENGTH, 2000);
		validate("version", vo.getVersion(), CompareValidator.MAX_LENGTH, 10);
		validate("description", vo.getDescription(), CompareValidator.MAX_LENGTH, 1000);
	}

	/**
	 * 
	 * @param metadata
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(LcmsMetadataVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("metadataSeq", vo.getMetadataSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("metadataSeq", vo.getMetadataSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("metadataValue", vo.getMetadataValue(), DataValidator.REQUIRED);
			validate("referenceType", vo.getReferenceType(), DataValidator.REQUIRED);
			validate("referenceSeq", vo.getReferenceSeq().toString(), DataValidator.REQUIRED);
			validate("metadataElementSeq", vo.getMetadataElementSeq().toString(), DataValidator.REQUIRED);
		}
		validate("metadataValue", vo.getMetadataValue(), CompareValidator.MAX_LENGTH, 900);
		validate("referenceType", vo.getReferenceType(), CompareValidator.MAX_LENGTH, 50);
	}

	/**
	 * 
	 * @param metadataElement
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(LcmsMetadataElementVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("metadataElementSeq", vo.getMetadataElementSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("metadataElementSeq", vo.getMetadataElementSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("metadataName", vo.getMetadataName(), DataValidator.REQUIRED);
			validate("metadataPath", vo.getMetadataPath(), DataValidator.REQUIRED);
			validate("readonlyYn", vo.getReadonlyYn(), DataValidator.REQUIRED);
		}
		validate("metadataName", vo.getMetadataName(), CompareValidator.MAX_LENGTH, 100);
		validate("metadataPath", vo.getMetadataPath(), CompareValidator.MAX_LENGTH, 900);
		validate("readonlyYn", vo.getReadonlyYn(), CompareValidator.FIX_LENGTH, 1);
	}

	/**
	 * @param contents
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(LcmsContentsVO voContents, ValidateType validateType) throws Exception {
		UILcmsContentsVO vo = (UILcmsContentsVO)voContents;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("contentsSeq", vo.getContentsSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("contentsSeq", vo.getContentsSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("title", vo.getTitle(), DataValidator.REQUIRED);
			validate("categorySeq", vo.getCategorySeq().toString(), DataValidator.REQUIRED);
			validate("statusCd", vo.getStatusCd(), DataValidator.REQUIRED);
		}
		validate("title", vo.getTitle(), CompareValidator.MAX_LENGTH, 200);
		validate("description", vo.getDescription(), CompareValidator.MAX_LENGTH, 1000);
		validate("statusCd", vo.getStatusCd(), CompareValidator.MAX_LENGTH, 50);
	}

	/**
	 * @param contentsOrganization
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(LcmsContentsOrganizationVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("contentsSeq", vo.getContentsSeq().toString(), DataValidator.REQUIRED);
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("contentsSeq", vo.getContentsSeq().toString(), DataValidator.REQUIRED);
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("contentsSeq", vo.getContentsSeq().toString(), DataValidator.REQUIRED);
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
		}
	}

	/**
	 * @param leanerDatamodel
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(LcmsLearnerDatamodelVO voLearnerDatamodel, ValidateType validateType) throws Exception {
		UILcmsLearnerDatamodelVO vo = (UILcmsLearnerDatamodelVO)voLearnerDatamodel;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("datamodelSeq", vo.getDatamodelSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			if (StringUtil.isEmpty(vo.getDatamodelSeq())) {
				validate("learnerId", vo.getLearnerId(), DataValidator.REQUIRED);
				validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
				validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
				validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
				validate("itemSeq", vo.getItemSeq().toString(), DataValidator.REQUIRED);
			}
		}
		if (ValidateType.insert == validateType) {
			validate("learnerId", vo.getLearnerId(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
			validate("itemSeq", vo.getItemSeq().toString(), DataValidator.REQUIRED);
		}
		validate("attempt", vo.getAttempt(), CompareValidator.MAX_LENGTH, 100);
		validate("progressMeasure", vo.getProgressMeasure(), CompareValidator.MAX_LENGTH, 100);
		validate("completionStatus", vo.getCompletionStatus(), CompareValidator.MAX_LENGTH, 100);
		validate("completionDtime", vo.getCompletionDtime(), CompareValidator.MAX_LENGTH, 14);
		validate("scoreScaled", vo.getScoreScaled(), CompareValidator.MAX_LENGTH, 100);
		validate("successStatus", vo.getSuccessStatus(), CompareValidator.MAX_LENGTH, 100);
		validate("location", vo.getLocation(), CompareValidator.MAX_LENGTH, 100);
		validate("sessionTime", vo.getSessionTime(), CompareValidator.MAX_LENGTH, 100);
		validate("suspendData", vo.getSuspendData(), CompareValidator.MAX_LENGTH, 100);
		validate("credit", vo.getCredit(), CompareValidator.MAX_LENGTH, 100);
		validate("entry", vo.getEntry(), CompareValidator.MAX_LENGTH, 100);
	}

	/**
	 * @param dailyProgress
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(LcmsDailyProgressVO voDailyProgress, ValidateType validateType) throws Exception {
		UILcmsDailyProgressVO vo = (UILcmsDailyProgressVO)voDailyProgress;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("dailyProgressSeq", vo.getDailyProgressSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("learnerId", vo.getLearnerId(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
			validate("itemSeq", vo.getItemSeq().toString(), DataValidator.REQUIRED);
			validate("studyDate", vo.getStudyDate(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("learnerId", vo.getLearnerId(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
			validate("itemSeq", vo.getItemSeq().toString(), DataValidator.REQUIRED);
			validate("studyDate", vo.getStudyDate(), DataValidator.REQUIRED);
		}
		validate("attempt", vo.getAttempt(), CompareValidator.MAX_LENGTH, 100);
		validate("progressMeasure", vo.getProgressMeasure(), CompareValidator.MAX_LENGTH, 100);
		validate("sessionTime", vo.getSessionTime(), CompareValidator.MAX_LENGTH, 100);
		validate("studyDate", vo.getStudyDate(), CompareValidator.MAX_LENGTH, 14);
	}

	/**
	 * @param leanerDatamodelData
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(LcmsLearnerDatamodelDataVO voLearnerDatamodelData, ValidateType validateType) throws Exception {
		UILcmsLearnerDatamodelDataVO vo = (UILcmsLearnerDatamodelDataVO)voLearnerDatamodelData;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("learnerId", vo.getLearnerId(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
			validate("itemSeq", vo.getItemSeq().toString(), DataValidator.REQUIRED);
			validate("dataName", vo.getDataName(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("learnerId", vo.getLearnerId(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
			validate("itemSeq", vo.getItemSeq().toString(), DataValidator.REQUIRED);
			validate("dataName", vo.getDataName(), DataValidator.REQUIRED);
			validate("dataValue", vo.getDataValue(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("learnerId", vo.getLearnerId(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
			validate("itemSeq", vo.getItemSeq().toString(), DataValidator.REQUIRED);
			validate("dataName", vo.getDataName(), DataValidator.REQUIRED);
			validate("dataValue", vo.getDataValue(), DataValidator.REQUIRED);
		}
	}

}
