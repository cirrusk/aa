/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.support;

import org.springframework.stereotype.Component;

import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.support.validator.Validator;
import com._4csoft.aof.infra.vo.base.ValidateType;
import com._4csoft.aof.ui.univ.vo.UIUnivCategoryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBbsVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActivePlanVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyAccessHistoryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussBbsVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussTemplateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkTemplateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectBbsVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectMutualevalVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTemplateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectVO;
import com._4csoft.aof.ui.univ.vo.UIUnivMigEmsDbVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyExampleVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivWeekTemplateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivYearTermVO;
import com._4csoft.aof.univ.support.validator.UnivValidator;
import com._4csoft.aof.univ.vo.UnivCategoryVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveBbsVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveElementVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveEvaluateVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveExamPaperTargetVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveExamPaperVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveLecturerMenuVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveLecturerVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveOrganizationItemVO;
import com._4csoft.aof.univ.vo.UnivCourseActivePlanVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveSurveyAnswerVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveSurveyPaperAnswerVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveSurveyVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveVO;
import com._4csoft.aof.univ.vo.UnivCourseApplyAccessHistoryVO;
import com._4csoft.aof.univ.vo.UnivCourseApplyAttendVO;
import com._4csoft.aof.univ.vo.UnivCourseApplyElementVO;
import com._4csoft.aof.univ.vo.UnivCourseApplyVO;
import com._4csoft.aof.univ.vo.UnivCourseAttendEvaluateVO;
import com._4csoft.aof.univ.vo.UnivCourseDiscussBbsVO;
import com._4csoft.aof.univ.vo.UnivCourseDiscussTemplateVO;
import com._4csoft.aof.univ.vo.UnivCourseDiscussVO;
import com._4csoft.aof.univ.vo.UnivCourseExamAnswerVO;
import com._4csoft.aof.univ.vo.UnivCourseExamExampleVO;
import com._4csoft.aof.univ.vo.UnivCourseExamItemVO;
import com._4csoft.aof.univ.vo.UnivCourseExamPaperElementVO;
import com._4csoft.aof.univ.vo.UnivCourseExamPaperVO;
import com._4csoft.aof.univ.vo.UnivCourseExamVO;
import com._4csoft.aof.univ.vo.UnivCourseHomeworkAnswerVO;
import com._4csoft.aof.univ.vo.UnivCourseHomeworkTargetVO;
import com._4csoft.aof.univ.vo.UnivCourseHomeworkTemplateVO;
import com._4csoft.aof.univ.vo.UnivCourseHomeworkVO;
import com._4csoft.aof.univ.vo.UnivCourseMasterVO;
import com._4csoft.aof.univ.vo.UnivCoursePostEvaluateVO;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectBbsVO;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectMemberVO;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectMutualevalVO;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectTemplateVO;
import com._4csoft.aof.univ.vo.UnivCourseTeamProjectVO;
import com._4csoft.aof.univ.vo.UnivGradeLevelVO;
import com._4csoft.aof.univ.vo.UnivMigEmsDbVO;
import com._4csoft.aof.univ.vo.UnivOcwCommentAgreeVO;
import com._4csoft.aof.univ.vo.UnivOcwCommentVO;
import com._4csoft.aof.univ.vo.UnivOcwContentsOrganizationVO;
import com._4csoft.aof.univ.vo.UnivOcwCourseVO;
import com._4csoft.aof.univ.vo.UnivOcwEvaluateVO;
import com._4csoft.aof.univ.vo.UnivSurveyExampleVO;
import com._4csoft.aof.univ.vo.UnivSurveyPaperElementVO;
import com._4csoft.aof.univ.vo.UnivSurveyPaperVO;
import com._4csoft.aof.univ.vo.UnivSurveySubjectVO;
import com._4csoft.aof.univ.vo.UnivSurveyVO;
import com._4csoft.aof.univ.vo.UnivWeekTemplateVO;
import com._4csoft.aof.univ.vo.UnivYearTermVO;

/**
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.univ.support
 * @File : UIUnivValidator.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Component ("UIUnivValidator")
public class UIUnivValidator extends Validator implements UnivValidator {

	public void validate(UnivGradeLevelVO vo, ValidateType validateType) throws Exception {
		// TODO Auto-generated method stub

	}

	public void validate(UnivYearTermVO vo, ValidateType validateType) throws Exception {
		UIUnivYearTermVO uiUnivYearTermVO = (UIUnivYearTermVO)vo;
		validateAudit(uiUnivYearTermVO, validateType);

		if (ValidateType.delete == validateType) {
			validate("yearTerm", uiUnivYearTermVO.getYearTerm(), DataValidator.REQUIRED);
			return;
		}

		if (ValidateType.update == validateType) {
			validate("yearTerm", uiUnivYearTermVO.getYearTerm(), DataValidator.REQUIRED);
		}

		if (ValidateType.detail == validateType) {
			validate("yearTerm", uiUnivYearTermVO.getYearTerm(), DataValidator.REQUIRED);
		}

		if (ValidateType.insert == validateType) {
			validate("yearTermName", uiUnivYearTermVO.getYearTermName(), DataValidator.REQUIRED);
			validate("studyStartDate", uiUnivYearTermVO.getStudyStartDate(), DataValidator.REQUIRED);
			validate("studyEndDate", uiUnivYearTermVO.getStudyEndDate(), DataValidator.REQUIRED);
			validate("openAdminDate", uiUnivYearTermVO.getOpenAdminDate(), DataValidator.REQUIRED);
			validate("openProfDate", uiUnivYearTermVO.getOpenProfDate(), DataValidator.REQUIRED);
			validate("openStudentDate", uiUnivYearTermVO.getOpenStudentDate(), DataValidator.REQUIRED);
		}

		validate("yearTermName", uiUnivYearTermVO.getYearTermName(), CompareValidator.MAX_LENGTH, 300);
		validate("studyStartDate", uiUnivYearTermVO.getStudyStartDate(), CompareValidator.MAX_LENGTH, 14);
		validate("studyEndDate", uiUnivYearTermVO.getStudyEndDate(), CompareValidator.MAX_LENGTH, 14);
		validate("openAdminDate", uiUnivYearTermVO.getOpenAdminDate(), CompareValidator.MAX_LENGTH, 14);
		validate("openProfDate", uiUnivYearTermVO.getOpenProfDate(), CompareValidator.MAX_LENGTH, 14);
		validate("openStudentDate", uiUnivYearTermVO.getOpenStudentDate(), CompareValidator.MAX_LENGTH, 14);
	}

	public void validate(UnivCourseActiveElementVO vo, ValidateType validateType) throws Exception {
		// TODO Auto-generated method stub

	}

	public void validate(UnivCourseActiveEvaluateVO vo, ValidateType validateType) throws Exception {
		// TODO Auto-generated method stub

	}

	public void validate(UnivCourseActiveLecturerVO vo, ValidateType validateType) throws Exception {

		if (ValidateType.insert == validateType) {
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("profMemberSeq", vo.getProfMemberSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.delete == validateType) {
			validate("courseActiveProfSeq", vo.getCourseActiveProfSeq().toString(), DataValidator.REQUIRED);
			return;
		}

		if (ValidateType.update == validateType) {
			validate("courseActiveProfSeq", vo.getCourseActiveProfSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.detail == validateType) {
			validate("courseActiveProfSeq", vo.getCourseActiveProfSeq().toString(), DataValidator.REQUIRED);
		}

		validate("activeLecturerTypeCd", vo.getActiveLecturerTypeCd(), CompareValidator.MAX_LENGTH, 50);
	}

	public void validate(UnivCourseActiveLecturerMenuVO vo, ValidateType validateType) throws Exception {
		if (ValidateType.insert == validateType) {
			validate("courseActiveProfSeq", vo.getCourseActiveProfSeq().toString(), DataValidator.REQUIRED);
			validate("menuSeq", vo.getMenuSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.delete == validateType) {
			validate("courseActiveProfSeq", vo.getCourseActiveProfSeq().toString(), DataValidator.REQUIRED);
			validate("menuSeq", vo.getMenuSeq().toString(), DataValidator.REQUIRED);
			return;
		}

		if (ValidateType.update == validateType) {
			validate("courseActiveProfSeq", vo.getCourseActiveProfSeq().toString(), DataValidator.REQUIRED);
			validate("menuSeq", vo.getMenuSeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivCourseActiveVO vo, ValidateType validateType) throws Exception {
		UIUnivCourseActiveVO courseActive = (UIUnivCourseActiveVO)vo;

		if (ValidateType.delete == validateType) {
			validate("courseActiveSeq", courseActive.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			return;
		}

		if (ValidateType.update == validateType) {
			validate("courseActiveSeq", courseActive.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.detail == validateType) {
			validate("courseActiveSeq", courseActive.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
		}

		validate("courseActiveTitle", courseActive.getCourseActiveTitle(), CompareValidator.MAX_LENGTH, 300);
	}

	public void validate(UnivCourseApplyElementVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("activeElementSeq", vo.getActiveElementSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.update == validateType) {
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("activeElementSeq", vo.getActiveElementSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.delete == validateType) {
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("activeElementSeq", vo.getActiveElementSeq().toString(), DataValidator.REQUIRED);
			return;
		}

	}

	public void validate(UnivCourseApplyVO vo, ValidateType validateType) throws Exception {

		UIUnivCourseApplyVO courseApply = (UIUnivCourseApplyVO)vo;
		validateAudit(courseApply, validateType);

		if (ValidateType.delete == validateType) {
			validate("courseApplySeq", courseApply.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			return;
		}

		if (ValidateType.update == validateType) {
			// validate("courseApplySeq", courseApply.getCourseApplySeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.detail == validateType) {
			validate("courseApplySeq", courseApply.getCourseApplySeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.insert == validateType) {
			validate("courseActiveSeq", courseApply.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseMasterSeq", courseApply.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
			validate("courseStatusCd", courseApply.getApplyStatusCd(), DataValidator.REQUIRED);
		}

		validate("courseTitle", courseApply.getYearTerm(), CompareValidator.MAX_LENGTH, 15);
		validate("courseStatusCd", courseApply.getApplyStatusCd(), CompareValidator.MAX_LENGTH, 50);
		validate("applyStatusDtime", courseApply.getApplyStatusDtime(), CompareValidator.MAX_LENGTH, 14);
		validate("studyStartDate", courseApply.getStudyStartDate(), CompareValidator.MAX_LENGTH, 14);
		validate("studyEndDate", courseApply.getStudyEndDate(), CompareValidator.MAX_LENGTH, 14);
		validate("resumeEndDate", courseApply.getResumeEndDate(), CompareValidator.MAX_LENGTH, 14);
		validate("completionYn", courseApply.getCompletionYn(), CompareValidator.MAX_LENGTH, 1);
	}

	public void validate(UnivCourseMasterVO vo, ValidateType validateType) throws Exception {
		UnivCourseMasterVO courseMaster = (UIUnivCourseMasterVO)vo;
		validateAudit(courseMaster, validateType);

		if (ValidateType.delete == validateType) {
			validate("courseMasterSeq", courseMaster.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
			return;
		}

		if (ValidateType.update == validateType) {
			validate("courseMasterSeq", courseMaster.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.detail == validateType) {
			validate("courseMasterSeq", courseMaster.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.insert == validateType) {
			validate("categoryOrganizationSeq", courseMaster.getCategoryOrganizationSeq().toString(), DataValidator.REQUIRED);
			validate("courseTitle", courseMaster.getCourseTitle(), DataValidator.REQUIRED);
			validate("introduction", courseMaster.getIntroduction(), DataValidator.REQUIRED);
			validate("courseStatusCd", courseMaster.getCourseStatusCd(), DataValidator.REQUIRED);
		}

		validate("courseTitle", courseMaster.getCourseTitle(), CompareValidator.MAX_LENGTH, 600);
		validate("courseStatusCd", courseMaster.getCourseStatusCd(), CompareValidator.MAX_LENGTH, 50);
		validate("completeDivisionCd", courseMaster.getCompleteDivisionCd(), CompareValidator.MAX_LENGTH, 50);
	}

	public void validate(UnivCoursePostEvaluateVO vo, ValidateType validateType) throws Exception {
		// TODO Auto-generated method stub

	}

	public void validate(UnivCourseActiveBbsVO voBbs, ValidateType validateType) throws Exception {
		UIUnivCourseActiveBbsVO vo = (UIUnivCourseActiveBbsVO)voBbs;
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
		validate("copyYn", vo.getCopyYn(), CompareValidator.FIX_LENGTH, 1);
		validate("evaluateYn", vo.getEvaluateYn(), CompareValidator.FIX_LENGTH, 1);
	}

	public void validate(UnivCourseExamPaperVO vo, ValidateType validateType) throws Exception {
		// TODO Auto-generated method stub

	}

	public void validate(UnivSurveyPaperVO vo, ValidateType validateType) throws Exception {
		UIUnivSurveyPaperVO univSurveyPaper = (UIUnivSurveyPaperVO)vo;
		validateAudit(univSurveyPaper, validateType);

		if (ValidateType.delete == validateType) {
			validate("surveyPaperSeq", vo.getSurveyPaperSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("surveyPaperSeq", vo.getSurveyPaperSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("title", vo.getSurveyPaperTitle(), DataValidator.REQUIRED);
			validate("surveyTypeCd", vo.getSurveyPaperTypeCd(), DataValidator.REQUIRED);

		}
		validate("title", vo.getSurveyPaperTitle(), CompareValidator.MAX_LENGTH, 200);
		validate("surveyPaperTypeCd", vo.getSurveyPaperTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("useYn", vo.getUseYn(), CompareValidator.FIX_LENGTH, 1);

	}

	public void validate(UnivSurveyPaperElementVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("surveyPaperSeq", vo.getSurveyPaperSeq().toString(), DataValidator.REQUIRED);
			validate("surveySeq", vo.getSurveySeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("surveyPaperSeq", vo.getSurveyPaperSeq().toString(), DataValidator.REQUIRED);
			validate("surveySeq", vo.getSurveySeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("surveyPaperSeq", vo.getSurveyPaperSeq().toString(), DataValidator.REQUIRED);
			validate("surveySeq", vo.getSurveySeq().toString(), DataValidator.REQUIRED);
			validate("sortOrder", vo.getSortOrder().toString(), DataValidator.REQUIRED);
		}

	}

	public void validate(UnivCourseDiscussVO discussVo, ValidateType validateType) throws Exception {
		UIUnivCourseDiscussVO vo = (UIUnivCourseDiscussVO)discussVo;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("discussSeq", vo.getDiscussSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("discussSeq", vo.getDiscussSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.detail == validateType) {
			validate("discussSeq", vo.getDiscussSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			// validate("courseMasterSeq", vo.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
			validate("profMemberSeq", vo.getProfMemberSeq().toString(), DataValidator.REQUIRED);
			validate("discussTitle", vo.getDiscussTitle(), CompareValidator.MAX_LENGTH, 500);
		}
	}

	public void validate(UnivCourseHomeworkVO vo, ValidateType validateType) throws Exception {
		// TODO Auto-generated method stub

	}

	public void validate(UnivCourseExamVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("discussSeq", vo.getExamSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("discussSeq", vo.getExamSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("courseMasterSeq", vo.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivCourseExamItemVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("examItemSeq", vo.getExamItemSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("examItemSeq", vo.getExamItemSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("examSeq", vo.getExamSeq().toString(), DataValidator.REQUIRED);
			validate("examItemTitle", vo.getExamItemTitle(), DataValidator.REQUIRED);
			validate("examItemTypeCd", vo.getExamItemTypeCd(), DataValidator.REQUIRED);
			validate("examItemDifficultyCd", vo.getExamItemDifficultyCd(), DataValidator.REQUIRED);
		}
		validate("examItemTitle", vo.getExamItemTitle(), CompareValidator.MAX_LENGTH, 1000);
		validate("examItemTypeCd", vo.getExamItemTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("examItemDifficultyCd", vo.getExamItemDifficultyCd(), CompareValidator.MAX_LENGTH, 50);
		validate("examItemAlignCd", vo.getExamItemAlignCd(), CompareValidator.MAX_LENGTH, 50);
		validate("sortOrder", vo.getSortOrder().toString(), DataValidator.REQUIRED);
		validate("comment", vo.getComment(), CompareValidator.MAX_LENGTH, 1000);
		validate("correctAnswer", vo.getCorrectAnswer(), CompareValidator.MAX_LENGTH, 1000);
		validate("similarAnswer", vo.getSimilarAnswer(), CompareValidator.MAX_LENGTH, 1000);
		validate("examFileTypeCd", vo.getExamFileTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("filePath", vo.getFilePath(), CompareValidator.MAX_LENGTH, 200);
		validate("filePathType", vo.getFilePathType(), CompareValidator.MAX_LENGTH, 50);

	}

	public void validate(UnivCourseExamExampleVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("examExampleSeq", vo.getExamExampleSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("examExampleSeq", vo.getExamExampleSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("examExampleSeq", vo.getExamItemSeq().toString(), DataValidator.REQUIRED);
			validate("examItemExampleTitle", vo.getExamItemExampleTitle(), DataValidator.REQUIRED);
			validate("correctYn", vo.getCorrectYn(), DataValidator.REQUIRED);
			validate("sortOrder", vo.getSortOrder().toString(), DataValidator.REQUIRED);
		}
		validate("examItemExampleTitle", vo.getExamItemExampleTitle(), CompareValidator.MAX_LENGTH, 1000);
		validate("correctYn", vo.getCorrectYn(), CompareValidator.FIX_LENGTH, 1);
		validate("examFileTypeCd", vo.getExamFileTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("filePath", vo.getFilePath(), CompareValidator.MAX_LENGTH, 200);
		validate("filePathType", vo.getFilePathType(), CompareValidator.MAX_LENGTH, 50);
	}

	public void validate(UnivSurveyVO vo, ValidateType validateType) throws Exception {
		UIUnivSurveyVO univSurvey = (UIUnivSurveyVO)vo;
		validateAudit(univSurvey, validateType);

		if (ValidateType.delete == validateType) {
			validate("surveySeq", vo.getSurveySeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("surveySeq", vo.getSurveySeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("title", vo.getSurveyTitle(), DataValidator.REQUIRED);
			validate("surveyTypeCd", vo.getSurveyTypeCd(), DataValidator.REQUIRED);
			validate("surveyItemTypeCd", vo.getSurveyItemTypeCd(), DataValidator.REQUIRED);
		}
		validate("title", vo.getSurveyTitle(), CompareValidator.MAX_LENGTH, 1000);
		validate("surveyTypeCd", vo.getSurveyTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("surveyItemTypeCd", vo.getSurveyItemTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("useYn", vo.getUseYn(), CompareValidator.FIX_LENGTH, 1);

	}

	public void validate(UnivSurveyExampleVO vo, ValidateType validateType) throws Exception {
		UIUnivSurveyExampleVO univSurveyExample = (UIUnivSurveyExampleVO)vo;
		validateAudit(univSurveyExample, validateType);

		if (ValidateType.delete == validateType) {
			validate("surveyExampleSeq", vo.getSurveyExampleSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("surveyExampleSeq", vo.getSurveyExampleSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("surveySeq", vo.getSurveySeq().toString(), DataValidator.REQUIRED);
			validate("title", vo.getSurveyExampleTitle(), DataValidator.REQUIRED);
			validate("sortOrder", vo.getSortOrder().toString(), DataValidator.REQUIRED);
			validate("measureScore", vo.getMeasureScore().toString(), DataValidator.REQUIRED);
		}
		validate("title", vo.getSurveyExampleTitle(), CompareValidator.MAX_LENGTH, 200);

	}

	public void validate(UnivCourseExamPaperElementVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("examPaperSeq", vo.getExamPaperSeq().toString(), DataValidator.REQUIRED);
			validate("examSeq", vo.getExamSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("examPaperSeq", vo.getExamPaperSeq().toString(), DataValidator.REQUIRED);
			validate("examSeq", vo.getExamSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("examPaperSeq", vo.getExamPaperSeq().toString(), DataValidator.REQUIRED);
			validate("examSeq", vo.getExamSeq().toString(), DataValidator.REQUIRED);
			validate("paperNumber", vo.getPaperNumber().toString(), DataValidator.REQUIRED);
			validate("sortOrder", vo.getSortOrder().toString(), DataValidator.REQUIRED);
		}

	}

	public void validate(UnivCategoryVO voCategory, ValidateType validateType) throws Exception {
		UIUnivCategoryVO vo = (UIUnivCategoryVO)voCategory;
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
		validate("migCategorySeq", vo.getMigCategorySeq(), CompareValidator.MAX_LENGTH, 255);
	}

	public void validate(UnivMigEmsDbVO voUnivMigEmsDb, ValidateType validateType) throws Exception {
		UIUnivMigEmsDbVO vo = (UIUnivMigEmsDbVO)voUnivMigEmsDb;
		validateAudit(vo, validateType);

		if (ValidateType.update == validateType) {
			validate("migEmsSeq", vo.getMigEmsSeq().toString(), DataValidator.REQUIRED);
			validate("yearTerm", vo.getYearTerm(), DataValidator.REQUIRED);
		}
		validate("migEmsInfoItem", vo.getMigInfoItem(), CompareValidator.MAX_LENGTH, 255);
		validate("demonStatusYn", vo.getDemonStatusYn(), CompareValidator.MAX_LENGTH, 1);
	}

	public void validate(UnivWeekTemplateVO voUnivWeekTemplate, ValidateType validateType) throws Exception {
		UIUnivWeekTemplateVO vo = (UIUnivWeekTemplateVO)voUnivWeekTemplate;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("yearTerm", vo.getYearTerm(), DataValidator.REQUIRED);
			validate("weekSeq", vo.getWeekSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("yearTerm", vo.getYearTerm(), DataValidator.REQUIRED);
			validate("weekSeq", vo.getWeekSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.detail == validateType) {
			validate("yearTerm", vo.getYearTerm(), DataValidator.REQUIRED);
			validate("weekSeq", vo.getWeekSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("yearTerm", vo.getYearTerm(), DataValidator.REQUIRED);
			validate("weekSeq", vo.getWeekSeq().toString(), DataValidator.REQUIRED);
			validate("startDtime", vo.getStartDtime(), DataValidator.REQUIRED);
			validate("endDtime", vo.getEndDtime(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivCourseHomeworkTemplateVO voUnivCourseHomeworkTemplate, ValidateType validateType) throws Exception {
		UIUnivCourseHomeworkTemplateVO vo = (UIUnivCourseHomeworkTemplateVO)voUnivCourseHomeworkTemplate;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("templateSeq", vo.getTemplateSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("templateSeq", vo.getTemplateSeq().toString(), DataValidator.REQUIRED);
			validate("courseMasterSeq", vo.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
			validate("profMemberSeq", vo.getProfMemberSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.detail == validateType) {
			validate("templateSeq", vo.getTemplateSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("courseMasterSeq", vo.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
			validate("profMemberSeq", vo.getProfMemberSeq().toString(), DataValidator.REQUIRED);
			validate("templateTitle", vo.getTemplateTitle(), CompareValidator.MAX_LENGTH, 500);
			validate("openYn", vo.getOpenYn(), CompareValidator.MAX_LENGTH, 1);
			validate("useYn", vo.getUseYn(), CompareValidator.MAX_LENGTH, 1);
		}

	}

	public void validate(UnivCourseDiscussTemplateVO voUnivCourseDiscussTemplate, ValidateType validateType) throws Exception {
		UIUnivCourseDiscussTemplateVO vo = (UIUnivCourseDiscussTemplateVO)voUnivCourseDiscussTemplate;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("templateSeq", vo.getTemplateSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("templateSeq", vo.getTemplateSeq().toString(), DataValidator.REQUIRED);
			validate("courseMasterSeq", vo.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
			validate("profMemberSeq", vo.getProfMemberSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.detail == validateType) {
			validate("templateSeq", vo.getTemplateSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("courseMasterSeq", vo.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
			validate("profMemberSeq", vo.getProfMemberSeq().toString(), DataValidator.REQUIRED);
			validate("templateTitle", vo.getTemplateTitle(), CompareValidator.MAX_LENGTH, 500);
			validate("openYn", vo.getOpenYn(), CompareValidator.MAX_LENGTH, 1);
			validate("useYn", vo.getUseYn(), CompareValidator.MAX_LENGTH, 1);
		}

	}

	public void validate(UnivCourseTeamProjectTemplateVO voUnivCourseTeamProjectTemplate, ValidateType validateType) throws Exception {
		UIUnivCourseTeamProjectTemplateVO vo = (UIUnivCourseTeamProjectTemplateVO)voUnivCourseTeamProjectTemplate;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("templateSeq", vo.getTemplateSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("templateSeq", vo.getTemplateSeq().toString(), DataValidator.REQUIRED);
			validate("courseMasterSeq", vo.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
			validate("profMemberSeq", vo.getProfMemberSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.detail == validateType) {
			validate("templateSeq", vo.getTemplateSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("courseMasterSeq", vo.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
			validate("profMemberSeq", vo.getProfMemberSeq().toString(), DataValidator.REQUIRED);
			validate("templateTitle", vo.getTemplateTitle(), CompareValidator.MAX_LENGTH, 500);
			validate("openYn", vo.getOpenYn(), CompareValidator.MAX_LENGTH, 1);
			validate("useYn", vo.getUseYn(), CompareValidator.MAX_LENGTH, 1);
		}

	}

	public void validate(UnivCourseTeamProjectVO vo, ValidateType validateType) throws Exception {

		UIUnivCourseTeamProjectVO courseTeamProject = (UIUnivCourseTeamProjectVO)vo;
		validateAudit(courseTeamProject, validateType);

		if (ValidateType.delete == validateType) {
			validate("courseTeamProjectSeq", courseTeamProject.getCourseTeamProjectSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("courseTeamProjectSeq", courseTeamProject.getCourseTeamProjectSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.detail == validateType) {
			validate("courseTeamProjectSeq", courseTeamProject.getCourseTeamProjectSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("teamProjectTitle", courseTeamProject.getTeamProjectTitle(), DataValidator.REQUIRED);
			validate("courseActiveSeq", courseTeamProject.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			// validate("rateHomework", courseTeamProject.getRateHomework().toString(), DataValidator.REQUIRED);
			// validate("rateRelation", courseTeamProject.getRateRelation().toString(), DataValidator.REQUIRED);
			// validate("startDtime", courseTeamProject.getStartDtime(), DataValidator.REQUIRED);
			// validate("endDtime", courseTeamProject.getEndDtime(), DataValidator.REQUIRED);
			// validate("homeworkStartDtime", courseTeamProject.getHomeworkStartDtime(), DataValidator.REQUIRED);
			// validate("homeworkEndDtime", courseTeamProject.getHomeworkEndDtime(), DataValidator.REQUIRED);
			validate("openYn", courseTeamProject.getOpenYn(), CompareValidator.MAX_LENGTH, 1);
		}

		validate("teamProjectTitle", courseTeamProject.getTeamProjectTitle(), CompareValidator.MAX_LENGTH, 300);
		// validate("startDtime", courseTeamProject.getStartDtime(), CompareValidator.MAX_LENGTH, 14);
		// validate("endDtime", courseTeamProject.getEndDtime(), CompareValidator.MAX_LENGTH, 14);
		// validate("homeworkStartDtime", courseTeamProject.getHomeworkStartDtime(), CompareValidator.MAX_LENGTH, 14);
		// validate("homeworkEndDtime", courseTeamProject.getHomeworkEndDtime(), CompareValidator.MAX_LENGTH, 14);
		validate("openYn", courseTeamProject.getOpenYn(), CompareValidator.MAX_LENGTH, 1);
	}

	public void validate(UnivCourseTeamProjectMemberVO courseTeamProjectMember, ValidateType validateType) throws Exception {
		UIUnivCourseTeamProjectMemberVO vo = (UIUnivCourseTeamProjectMemberVO)courseTeamProjectMember;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("courseTeamSeq", vo.getCourseTeamSeq().toString(), DataValidator.REQUIRED);
			validate("teamMemberSeq", vo.getTeamMemberSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("courseTeamSeq", vo.getCourseTeamSeq().toString(), DataValidator.REQUIRED);
			validate("teamMemberSeq", vo.getTeamMemberSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("courseTeamSeq", vo.getCourseTeamSeq().toString(), DataValidator.REQUIRED);
			validate("teamMemberSeq", vo.getTeamMemberSeq().toString(), DataValidator.REQUIRED);

			validate("chiefYn", vo.getChiefYn(), CompareValidator.MAX_LENGTH, 1);
		}
	}

	public void validate(UnivCourseActivePlanVO courseActivePlan, ValidateType validateType) throws Exception {
		UIUnivCourseActivePlanVO vo = (UIUnivCourseActivePlanVO)courseActivePlan;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.detail == validateType) {
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivCourseAttendEvaluateVO courseAttendEvaluate, ValidateType validateType) throws Exception {
		validateAudit(courseAttendEvaluate, validateType);

		if (ValidateType.delete == validateType) {
			validate("courseActiveSeq", courseAttendEvaluate.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("courseActiveSeq", courseAttendEvaluate.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("attendTypeCd", courseAttendEvaluate.getAttendTypeCd(), DataValidator.REQUIRED);
			validate("onoffCd", courseAttendEvaluate.getOnoffCd(), DataValidator.REQUIRED);
		}
		if (ValidateType.detail == validateType) {
			validate("courseActiveSeq", courseAttendEvaluate.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("attendTypeCd", courseAttendEvaluate.getAttendTypeCd(), DataValidator.REQUIRED);
			validate("onoffCd", courseAttendEvaluate.getOnoffCd(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("attendTypeCd", courseAttendEvaluate.getAttendTypeCd(), DataValidator.REQUIRED);
			validate("onoffCd", courseAttendEvaluate.getOnoffCd(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivCourseHomeworkTargetVO courseHomeworkTarget, ValidateType validateType) throws Exception {
		UnivCourseHomeworkTargetVO vo = (UnivCourseHomeworkTargetVO)courseHomeworkTarget;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("homeworkSeq", vo.getHomeworkSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("homeworkSeq", vo.getHomeworkSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.detail == validateType) {
			validate("homeworkSeq", vo.getHomeworkSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("homeworkSeq", vo.getHomeworkSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivCourseActiveExamPaperVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("examPaperSeq", vo.getExamPaperSeq().toString(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseMasterSeq", vo.getCourseMasterSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.update == validateType) {
			validate("examPaperSeq", vo.getExamPaperSeq().toString(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseActiveExamPaperSeq", vo.getCourseActiveExamPaperSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.update == validateType) {
			validate("courseActiveExamPaperSeq", vo.getCourseActiveExamPaperSeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivCourseActiveExamPaperTargetVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("courseActiveExamPaperSeq", vo.getCourseActiveExamPaperSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.update == validateType) {
			validate("courseActiveExamPaperSeq", vo.getCourseActiveExamPaperSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.delete == validateType) {
			validate("courseActiveExamPaperSeq", vo.getCourseActiveExamPaperSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
		}

	}

	public void validate(UnivCourseApplyAttendVO vo, ValidateType savetype) throws Exception {
		validateAudit(vo, savetype);

		if (ValidateType.insert == savetype) {
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("lessonSeq", vo.getLessonSeq().toString(), DataValidator.REQUIRED);
			validate("activeElementSeq", vo.getActiveElementSeq().toString(), DataValidator.REQUIRED);
			validate("onoffCd", vo.getOnoffCd().toString(), DataValidator.REQUIRED);
			validate("attendTypeCd", vo.getAttendTypeCd().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.delete == savetype) {
			validate("courseApplyAttendSeq", vo.getCourseApplyAttendSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.detail == savetype) {
			validate("courseApplyAttendSeq", vo.getCourseApplyAttendSeq().toString(), DataValidator.REQUIRED);
		}

	}

	public void validate(UnivCourseTeamProjectMutualevalVO courseTeamProjectMutualeval, ValidateType validateType) throws Exception {

		UIUnivCourseTeamProjectMutualevalVO vo = (UIUnivCourseTeamProjectMutualevalVO)courseTeamProjectMutualeval;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("courseTeamSeq", vo.getCourseTeamSeq().toString(), DataValidator.REQUIRED);
			validate("teamMemberSeq", vo.getTeamMemberSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("mutualMemberSeq", vo.getMutualMemberSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("courseTeamSeq", vo.getCourseTeamSeq().toString(), DataValidator.REQUIRED);
			validate("teamMemberSeq", vo.getTeamMemberSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("mutualMemberSeq", vo.getMutualMemberSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("courseTeamSeq", vo.getCourseTeamSeq().toString(), DataValidator.REQUIRED);
			validate("teamMemberSeq", vo.getTeamMemberSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("mutualMemberSeq", vo.getMutualMemberSeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivCourseHomeworkAnswerVO courseHomeworkAnswer, ValidateType validateType) throws Exception {

		// TeamProject Validate
		if (StringUtil.isNotEmpty(courseHomeworkAnswer.getCourseTeamSeq())) {
			UIUnivCourseHomeworkAnswerVO vo = (UIUnivCourseHomeworkAnswerVO)courseHomeworkAnswer;
			validateAudit(vo, validateType);

			if (ValidateType.delete == validateType) {
				validate("homeworkAnswerSeq", vo.getCourseTeamSeq().toString(), DataValidator.REQUIRED);
				return;
			}
			if (ValidateType.update == validateType) {
				validate("homeworkAnswerSeq", vo.getCourseTeamSeq().toString(), DataValidator.REQUIRED);
			}
			if (ValidateType.insert == validateType) {
				validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			}

			// HomeWork Validate
		} else {
			validateAudit(courseHomeworkAnswer, validateType);

			if (ValidateType.delete == validateType) {
				validate("homeworkAnswerSeq", courseHomeworkAnswer.getHomeworkAnswerSeq().toString(), DataValidator.REQUIRED);
				return;
			}
			if (ValidateType.update == validateType) {
				validate("homeworkAnswerSeq", courseHomeworkAnswer.getHomeworkAnswerSeq().toString(), DataValidator.REQUIRED);
			}
			if (ValidateType.detail == validateType) {
				validate("homeworkAnswerSeq", courseHomeworkAnswer.getHomeworkAnswerSeq().toString(), DataValidator.REQUIRED);
			}
			if (ValidateType.insert == validateType) {
				validate("courseActiveSeq", courseHomeworkAnswer.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
				validate("homeworkSeq", courseHomeworkAnswer.getHomeworkSeq().toString(), DataValidator.REQUIRED);
				validate("courseApplySeq", courseHomeworkAnswer.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			}
		}
	}

	public void validate(UnivCourseActiveSurveyVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("courseActiveSurveySeq", vo.getCourseActiveSurveySeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("courseActiveSurveySeq", vo.getCourseActiveSurveySeq().toString(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("surveyPaperSeq", vo.getSurveyPaperSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("surveyPaperSeq", vo.getSurveyPaperSeq().toString(), DataValidator.REQUIRED);
		}

	}

	public void validate(UnivCourseTeamProjectBbsVO voBbs, ValidateType validateType) throws Exception {
		UIUnivCourseTeamProjectBbsVO vo = (UIUnivCourseTeamProjectBbsVO)voBbs;
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
		validate("copyYn", vo.getCopyYn(), CompareValidator.FIX_LENGTH, 1);
		validate("evaluateYn", vo.getEvaluateYn(), CompareValidator.FIX_LENGTH, 1);
	}

	public void validate(UnivCourseDiscussBbsVO voBbs, ValidateType validateType) throws Exception {
		UIUnivCourseDiscussBbsVO vo = (UIUnivCourseDiscussBbsVO)voBbs;
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
		validate("copyYn", vo.getCopyYn(), CompareValidator.FIX_LENGTH, 1);
		validate("evaluateYn", vo.getEvaluateYn(), CompareValidator.FIX_LENGTH, 1);
	}

	public void validate(UnivCourseActiveSurveyPaperAnswerVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("courseActiveSurveySeq", vo.getCourseActiveSurveySeq().toString(), DataValidator.REQUIRED);
			validate("surveyPaperSeq", vo.getSurveyPaperSeq().toString(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
		}

	}

	public void validate(UnivCourseActiveSurveyAnswerVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("surveyPaperAnswerSeq", vo.getSurveyPaperAnswerSeq().toString(), DataValidator.REQUIRED);
			validate("surveySeq", vo.getSurveySeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivCourseExamAnswerVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("courseActiveExamPaperSeq", vo.getCourseActiveExamPaperSeq().toString(), DataValidator.REQUIRED);
			validate("examSeq", vo.getExamSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.update == validateType) {
			validate("examAnswerSeq", vo.getExamAnswerSeq().toString(), DataValidator.REQUIRED);
		}

		validate("choiceAnswer", vo.getChoiceAnswer(), CompareValidator.MAX_LENGTH, 1000);
		validate("shortAnswer", vo.getShortAnswer(), CompareValidator.MAX_LENGTH, 1000);

	}

	public void validate(UnivCourseApplyAccessHistoryVO history, ValidateType validateType) throws Exception {

		UIUnivCourseApplyAccessHistoryVO vo = (UIUnivCourseApplyAccessHistoryVO)history;
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("courseApplySeq", vo.getCourseApplySeq().toString(), DataValidator.REQUIRED);
			validate("sessionId", vo.getSessionId(), DataValidator.REQUIRED);
			validate("site", vo.getSite(), DataValidator.REQUIRED);
			validate("rolegroupSeq", vo.getRolegroupSeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivCourseActiveOrganizationItemVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("courseActiveElementSeq", vo.getCourseActiveElementSeq().toString(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("organizationSeq", vo.getOrganizationSeq().toString(), DataValidator.REQUIRED);
			validate("itemSeq", vo.getItemSeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivSurveySubjectVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("surveyPaperSeq", vo.getSurveyPaperSeq().toString(), DataValidator.REQUIRED);
			validate("surveyPaperTypeCd", vo.getSurveyPaperTypeCd(), DataValidator.REQUIRED);
			validate("surveySubjectTypeCd", vo.getSurveySubjectTypeCd(), DataValidator.REQUIRED);
		}

		if (ValidateType.update == validateType) {
			validate("surveySubjectSeq", vo.getSurveySubjectSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.delete == validateType) {
			validate("surveySubjectSeq", vo.getSurveySubjectSeq().toString(), DataValidator.REQUIRED);
		}

		validate("surveyTitle", vo.getSurveyTitle(), CompareValidator.MAX_LENGTH, 300);

	}

	public void validate(UnivOcwCommentVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("commentTypeCd", vo.getCommentTypeCd().toString(), DataValidator.REQUIRED);
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.update == validateType) {
			validate("ocwCommentSeq", vo.getOcwCommentSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.delete == validateType) {
			validate("ocwCommentSeq", vo.getOcwCommentSeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivOcwCommentAgreeVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("ocwCommentSeq", vo.getOcwCommentSeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.update == validateType) {
			validate("ocwCommentSeq", vo.getOcwCommentSeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.delete == validateType) {
			validate("ocwCommentSeq", vo.getOcwCommentSeq().toString(), DataValidator.REQUIRED);
			validate("memberSeq", vo.getMemberSeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivOcwCourseVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.update == validateType) {
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("ocwCoursActiveSeq", vo.getOcwCourseActiveSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.delete == validateType) {
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
			validate("ocwCoursActiveSeq", vo.getOcwCourseActiveSeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivOcwEvaluateVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("ocwCoursActiveSeq", vo.getOcwCourseActiveSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.update == validateType) {
			validate("ocwEvalSeq", vo.getOcwEvalSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.delete == validateType) {
			validate("ocwEvalSeq", vo.getOcwEvalSeq().toString(), DataValidator.REQUIRED);
		}
	}

	public void validate(UnivOcwContentsOrganizationVO vo, ValidateType validateType) throws Exception {
		validateAudit(vo, validateType);

		if (ValidateType.insert == validateType) {
			validate("courseActiveSeq", vo.getCourseActiveSeq().toString(), DataValidator.REQUIRED);
		}

		if (ValidateType.update == validateType) {
			validate("ocwOrganizaionSeq", vo.getOcwOrganizaionSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.delete == validateType) {
			validate("ocwCoursActiveSeq", vo.getOcwOrganizaionSeq().toString(), DataValidator.REQUIRED);
		}
	}
}
