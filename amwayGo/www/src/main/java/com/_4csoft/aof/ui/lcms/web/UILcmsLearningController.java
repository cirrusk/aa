/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.LogUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.CodeVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.lcms.service.LcmsDailyProgressService;
import com._4csoft.aof.lcms.service.LcmsItemService;
import com._4csoft.aof.lcms.service.LcmsLearnerDatamodelDataService;
import com._4csoft.aof.lcms.service.LcmsLearnerDatamodelService;
import com._4csoft.aof.lcms.service.LcmsOrganizationService;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.lcms.vo.UILcmsDailyProgressVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsItemVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsLearnerDatamodelVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsOrganizationVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsSimpleLearningVO;
import com._4csoft.aof.ui.lcms.vo.condition.UILcmsLearnerDatamodelDataCondition;
import com._4csoft.aof.ui.lcms.vo.resultset.UILcmsDailyProgressRS;
import com._4csoft.aof.ui.lcms.vo.resultset.UILcmsItemRS;
import com._4csoft.aof.ui.lcms.vo.resultset.UILcmsLearnerDatamodelDataRS;
import com._4csoft.aof.ui.lcms.vo.resultset.UILcmsLearnerDatamodelRS;
import com._4csoft.aof.ui.lcms.vo.resultset.UILcmsOrganizationRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveElementRS;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseApplyAttendService;
import com._4csoft.aof.univ.vo.UnivCourseActiveElementVO;
import com._4csoft.aof.univ.vo.UnivCourseApplyAttendVO;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.lcms.web
 * @File : UILearningController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UILcmsLearningController extends BaseController {
	protected final LogUtil logger = new LogUtil("LEARNING_LOGGER");

	protected final String sessionLearingToken = "sessionLearingToken";

	@Resource (name = "LcmsOrganizationService")
	private LcmsOrganizationService organizationService;

	@Resource (name = "LcmsItemService")
	private LcmsItemService itemService;

	@Resource (name = "LcmsLearnerDatamodelService")
	private LcmsLearnerDatamodelService learnerDatamodelService;

	@Resource (name = "LcmsLearnerDatamodelDataService")
	private LcmsLearnerDatamodelDataService learnerDatamodelDataService;

	@Resource (name = "LcmsDailyProgressService")
	private LcmsDailyProgressService dailyProgressService;

	@Resource (name = "UnivCourseApplyAttendService")
	private UnivCourseApplyAttendService applyAttendService;

	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService elementService;

	@Resource (name = "CodeService")
	private CodeService codeService;

	// @Resource (name = "CourseActiveService")
	// private CourseActiveService courseActiveService;

	/**
	 * 학습창
	 * 
	 * @param req
	 * @param res
	 * @param learning
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/learning/simple/popup.do")
	public ModelAndView simpleLearning(HttpServletRequest req, HttpServletResponse res, UILcmsSimpleLearningVO learning) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {
			requiredSession(req);

			UILcmsOrganizationVO organization = new UILcmsOrganizationVO();
			organization.setOrganizationSeq(learning.getOrganizationSeq());
			UILcmsOrganizationRS organizationRS = (UILcmsOrganizationRS)organizationService.getDetail(organization);
			if (organizationRS != null) {
				learning.setOrganizationTitle(organizationRS.getOrganization().getTitle());
				learning.setContentTypeCd(organizationRS.getOrganization().getContentsTypeCd());
				if (StringUtil.isNotEmpty(organizationRS.getOrganization().getWidth())) {
					learning.setWidth(String.valueOf(organizationRS.getOrganization().getWidth()));
				}
				if (StringUtil.isNotEmpty(organizationRS.getOrganization().getHeight())) {
					learning.setHeight(String.valueOf(organizationRS.getOrganization().getHeight()));
				}
			}

			UILcmsItemVO item = new UILcmsItemVO();
			item.setItemSeq(learning.getItemSeq());
			UILcmsItemRS itemRS = (UILcmsItemRS)itemService.getDetail(item);
			if (itemRS != null) {
				learning.setItemTitle(itemRS.getItem().getTitle());
				if (itemRS.getItem().getIdentifier().equals(learning.getItemIdentifier())) {
					StringBuffer href = new StringBuffer();
					if (StringUtil.isNotEmpty(itemRS.getItemResource().getBase())) {
						href.append(itemRS.getItemResource().getBase());
					}
					if (StringUtil.isNotEmpty(itemRS.getItemResource().getHref())) {
						href.append(itemRS.getItemResource().getHref());
					}
					learning.setItemToLaunch(href.toString());

				} else {
					logger.trace(req, "[Popup][INVALID_PARAMETER][" + HttpUtil.getRequestParametersToString(req) + "]");
					throw new AofException(Errors.INVALID_PARAMETER.desc);
				}
			}
			String accessToken = StringUtil.getRandomUUID();
			SessionUtil.setAttribute(req, sessionLearingToken, accessToken);
			learning.setAccessToken(accessToken);
			learning.setStartTime(System.currentTimeMillis());
			learning.setCompletionType(itemRS.getItem().getCompletionType());

			mav.addObject("learning", learning);

			// 학습 데이터 유효성 체크
			String checkResult = learnerDatamodelService.checkElementStydy(learning.getApplyId(), learning.getOrganizationSeq(), learning.getItemSeq());
			if (checkResult == null) {
				checkResult = "N";
			}

			mav.addObject("checkResult", checkResult);

			mav.setViewName("/lcms/learning/simpleLearningPopup");
			logger.trace(req, "[Popup][TRUE][" + HttpUtil.getRequestParametersToString(req) + "]");
		} catch (Exception e) {
			logger.trace(req, "[Popup][FALSE][" + HttpUtil.getRequestParametersToString(req) + "]");
			throw new AofException(Errors.ETC.desc);
		}
		return mav;

	}

	/**
	 * 학습창
	 * 
	 * @param req
	 * @param res
	 * @param learning
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/learning/simple/ocw/popup.do")
	public ModelAndView simpleOcwLearning(HttpServletRequest req, HttpServletResponse res, UILcmsSimpleLearningVO learning) throws Exception {
		ModelAndView mav = new ModelAndView();

		try {

			UILcmsOrganizationVO organization = new UILcmsOrganizationVO();
			organization.setOrganizationSeq(learning.getOrganizationSeq());
			UILcmsOrganizationRS organizationRS = (UILcmsOrganizationRS)organizationService.getDetail(organization);
			if (organizationRS != null) {
				learning.setOrganizationTitle(organizationRS.getOrganization().getTitle());
				learning.setContentTypeCd(organizationRS.getOrganization().getContentsTypeCd());
				if (StringUtil.isNotEmpty(organizationRS.getOrganization().getWidth())) {
					learning.setWidth(String.valueOf(organizationRS.getOrganization().getWidth()));
				}
				if (StringUtil.isNotEmpty(organizationRS.getOrganization().getHeight())) {
					learning.setHeight(String.valueOf(organizationRS.getOrganization().getHeight()));
				}
			}

			UILcmsItemVO item = new UILcmsItemVO();
			item.setItemSeq(learning.getItemSeq());
			UILcmsItemRS itemRS = (UILcmsItemRS)itemService.getDetail(item);
			if (itemRS != null) {
				learning.setItemTitle(itemRS.getItem().getTitle());
				if (itemRS.getItem().getIdentifier().equals(learning.getItemIdentifier())) {
					StringBuffer href = new StringBuffer();
					if (StringUtil.isNotEmpty(itemRS.getItemResource().getBase())) {
						href.append(itemRS.getItemResource().getBase());
					}
					if (StringUtil.isNotEmpty(itemRS.getItemResource().getHref())) {
						href.append(itemRS.getItemResource().getHref());
					}
					learning.setItemToLaunch(href.toString());

				} else {
					logger.trace(req, "[Popup][INVALID_PARAMETER][" + HttpUtil.getRequestParametersToString(req) + "]");
					throw new AofException(Errors.INVALID_PARAMETER.desc);
				}
			}
			String accessToken = StringUtil.getRandomUUID();
			SessionUtil.setAttribute(req, sessionLearingToken, accessToken);
			learning.setAccessToken(accessToken);
			learning.setStartTime(System.currentTimeMillis());
			learning.setCompletionType(itemRS.getItem().getCompletionType());

			mav.addObject("learning", learning);

			mav.addObject("checkResult", "Y");

			mav.addObject("ocwYn", "Y");

			mav.setViewName("/lcms/learning/simpleLearningPopup");
			logger.trace(req, "[Popup][TRUE][" + HttpUtil.getRequestParametersToString(req) + "]");
		} catch (Exception e) {
			logger.trace(req, "[Popup][FALSE][" + HttpUtil.getRequestParametersToString(req) + "]");
			throw new AofException(Errors.ETC.desc);
		}
		return mav;

	}

	/**
	 * 학습창 Initialize
	 * 
	 * @param req
	 * @param res
	 * @param learning
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/learning/api/simple/initialize.do")
	public ModelAndView simpleInitialize(HttpServletRequest req, HttpServletResponse res, UILcmsSimpleLearningVO learning) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("jsonView");
		boolean result = false;

		if (SessionUtil.isValid(req)) {
			String sessionAccessToken = (String)SessionUtil.getAttribute(req, sessionLearingToken);
			if (StringUtil.isEmpty(sessionAccessToken) || learning.getAccessToken().equals(sessionAccessToken) == false) {
				logger.trace(req, "[Initialize][INVALID_PARAMETER][" + HttpUtil.getRequestParametersToString(req) + "]");
				throw new AofException(Errors.INVALID_PARAMETER.desc);
			}
			HashMap<String, String> dataModel = new HashMap<String, String>();

			UILcmsItemVO item = new UILcmsItemVO();
			item.setItemSeq(learning.getItemSeq());
			UILcmsItemRS itemRS = (UILcmsItemRS)itemService.getDetail(item);
			if (itemRS != null) {
				dataModel.put("cmi.launch_data", itemRS.getItem().getDataFromLms());
				dataModel.put("cmi.scaled_passing_score", itemRS.getItem().getMinNormalizedMeasure());
				dataModel.put("cmi.time_limit_action", itemRS.getItem().getTimeLimitAction());
				dataModel.put("cmi.completion_threshold", itemRS.getItem().getCompletionThreshold());
				dataModel.put("cmi.max_time_allowed", itemRS.getItem().getAttemptDurationLimit());
			}

			String learnerId = "-1";
			String learnerName = "guest";
			Long courseActiveSeq = -1L;
			Long courseApplySeq = -1L;
			if (StringUtil.isNotEmpty(learning.getCourseId()) && "preview".equalsIgnoreCase(learning.getCourseId()) == false
					&& "resume".equalsIgnoreCase(learning.getCourseId()) == false) {
				courseActiveSeq = Long.parseLong(learning.getCourseId());
				courseApplySeq = Long.parseLong(learning.getApplyId());
				learnerId = SessionUtil.getMember(req).getMemberSeq().toString();
				learnerName = SessionUtil.getMember(req).getMemberName();
			}
			dataModel.put("cmi.learner_id", learnerId);
			dataModel.put("cmi.learner_name", learnerName);

			Long organizationSeq = learning.getOrganizationSeq();
			Long itemSeq = learning.getItemSeq();

			UILcmsLearnerDatamodelVO findLearnerDatamodel = new UILcmsLearnerDatamodelVO();
			findLearnerDatamodel.setLearnerId(learnerId);
			findLearnerDatamodel.setCourseActiveSeq(courseActiveSeq);
			findLearnerDatamodel.setCourseApplySeq(courseApplySeq);
			findLearnerDatamodel.setOrganizationSeq(organizationSeq);
			findLearnerDatamodel.setItemSeq(itemSeq);
			UILcmsLearnerDatamodelRS detail = (UILcmsLearnerDatamodelRS)learnerDatamodelService.getDetail(findLearnerDatamodel);
			UILcmsLearnerDatamodelVO learnerDatamodel = null;

			if (detail != null) {
				learnerDatamodel = detail.getLearnerDatamodel();
			}
			if (learnerDatamodel == null) {
				learnerDatamodel = new UILcmsLearnerDatamodelVO();
			}
			requiredSession(req, learnerDatamodel);

			if (StringUtil.isNotEmpty(learnerDatamodel.getAttempt())) {
				dataModel.put("cmi.attempt", learnerDatamodel.getAttempt());
			} else {
				dataModel.put("cmi.attempt", "0");
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getProgressMeasure())) {
				dataModel.put("cmi.progress_measure", learnerDatamodel.getProgressMeasure());
				dataModel.put("etc.start_progress_measure", learnerDatamodel.getProgressMeasure());
			} else {
				dataModel.put("cmi.progress_measure", "0.0");
				dataModel.put("etc.start_progress_measure", "0.0");
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getCompletionStatus())) {
				dataModel.put("cmi.completion_status", learnerDatamodel.getCompletionStatus());
				dataModel.put("etc.start_completion_status", learnerDatamodel.getCompletionStatus());
			} else {
				dataModel.put("cmi.completion_status", "incomplete");
				dataModel.put("etc.start_completion_status", "incomplete");
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getScoreScaled())) {
				dataModel.put("cmi.score_scaled", learnerDatamodel.getScoreScaled());
			} else {
				dataModel.put("cmi.score_scaled", "0");
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getSuccessStatus())) {
				dataModel.put("cmi.success_status", learnerDatamodel.getSuccessStatus());
			} else {
				dataModel.put("cmi.success_status", "failed");
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getLocation())) {
				dataModel.put("cmi.location", learnerDatamodel.getLocation());
			} else {
				dataModel.put("cmi.location", "");
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getSessionTime())) {
				dataModel.put("cmi.session_time", learnerDatamodel.getSessionTime());
				dataModel.put("cmi.saved_session_time", learnerDatamodel.getSessionTime());
			} else {
				dataModel.put("cmi.session_time", "0");
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getSuspendData())) {
				dataModel.put("cmi.suspend_data", learnerDatamodel.getSuspendData());
			} else {
				dataModel.put("cmi.suspend_data", "");
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getCredit())) {
				dataModel.put("cmi.credit", learnerDatamodel.getCredit());
			} else {
				dataModel.put("cmi.credit", "credit");
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getEntry())) {
				dataModel.put("cmi.entry", learnerDatamodel.getEntry());
			} else {
				dataModel.put("cmi.entry", "");
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getObjective())) {
				String[] objectives = learnerDatamodel.getObjective().split(Constants.SEPARATOR);
				for (String objective : objectives) {
					String[] pair = objective.split("=");
					if (pair.length == 2) {
						dataModel.put(pair[0], pair[1]);
					}
				}
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getInteraction())) {
				String[] interactions = learnerDatamodel.getInteraction().split(Constants.SEPARATOR);
				for (String interaction : interactions) {
					String[] pair = interaction.split("=");
					if (pair.length == 2) {
						dataModel.put(pair[0], pair[1]);
					}
				}
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getCommentFromLearner())) {
				String[] comments = learnerDatamodel.getCommentFromLearner().split(Constants.SEPARATOR);
				for (String comment : comments) {
					String[] pair = comment.split("=");
					if (pair.length == 2) {
						dataModel.put(pair[0], pair[1]);
					}
				}
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getAdlData())) {
				String[] adls = learnerDatamodel.getAdlData().split(Constants.SEPARATOR);
				for (String adldata : adls) {
					String[] pair = adldata.split("=");
					if (pair.length == 2) {
						dataModel.put(pair[0], pair[1]);
					}
				}
			}
			if (StringUtil.isNotEmpty(learnerDatamodel.getEtc())) {
				String[] etcs = learnerDatamodel.getEtc().split(Constants.SEPARATOR);
				for (String etc : etcs) {
					String[] pair = etc.split("=");
					if (pair.length == 2) {
						dataModel.put(pair[0], pair[1]);
					}
				}
			}

			String dailyStudyDate = DateUtil.convertStartDate(DateUtil.getToday(Constants.FORMAT_DATE), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE);
			UILcmsDailyProgressVO findDailyProgress = new UILcmsDailyProgressVO();
			findDailyProgress.setLearnerId(learnerId);
			findDailyProgress.setCourseActiveSeq(courseActiveSeq);
			findDailyProgress.setCourseApplySeq(courseApplySeq);
			findDailyProgress.setOrganizationSeq(organizationSeq);
			findDailyProgress.setItemSeq(itemSeq);
			findDailyProgress.setStudyDate(dailyStudyDate);
			UILcmsDailyProgressRS detailDailyProgress = (UILcmsDailyProgressRS)dailyProgressService.getDetail(findDailyProgress);

			// 데이타가 존재하지 않으면 새로 넣고 다시 읽어온다.
			if (detailDailyProgress == null) {
				findDailyProgress.copyAudit(learnerDatamodel);

				dailyProgressService.insertDailyProgress(findDailyProgress);
				detailDailyProgress = (UILcmsDailyProgressRS)dailyProgressService.getDetail(findDailyProgress);
			}

			if (detailDailyProgress != null) {
				UILcmsDailyProgressVO dailyProgress = detailDailyProgress.getDailyProgress();

				if (StringUtil.isNotEmpty(dailyProgress.getDailyProgressSeq())) {
					dataModel.put("etc.daily_progress_seq", String.valueOf(dailyProgress.getDailyProgressSeq()));
				}
				if (StringUtil.isNotEmpty(dailyProgress.getProgressMeasure())) {
					dataModel.put("etc.daily_progress_measure", dailyProgress.getProgressMeasure());
				} else {
					dataModel.put("etc.daily_progress_measure", "0.0");
				}
				if (StringUtil.isNotEmpty(dailyProgress.getSessionTime())) {
					dataModel.put("etc.daily_session_time", dailyProgress.getSessionTime());
				} else {
					dataModel.put("etc.daily_session_time", "0");
				}
				if (StringUtil.isNotEmpty(dailyProgress.getAttempt())) {
					dataModel.put("etc.daily_attempt", dailyProgress.getAttempt());
				} else {
					dataModel.put("etc.daily_attempt", "0");
				}
				dataModel.put("etc.daily_study_date", dailyStudyDate);

				mav.addObject("dataModel", dataModel);

				result = true;
			}
		}

		if (result == true) {
			mav.addObject("result", "true");
			logger.trace(req, "[Initialize][TRUE][" + HttpUtil.getRequestParametersToString(req) + "]");
		} else {
			mav.addObject("result", "false");
			logger.trace(req, "[Initialize][FALSE][" + HttpUtil.getRequestParametersToString(req) + "]");
		}
		return mav;
	}

	/**
	 * 학습창 Initialize
	 * 
	 * @param req
	 * @param res
	 * @param learning
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/learning/api/simple/ocw/initialize.do")
	public ModelAndView simpleOcwInitialize(HttpServletRequest req, HttpServletResponse res, UILcmsSimpleLearningVO learning) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("jsonView");
		boolean result = false;

		String sessionAccessToken = (String)SessionUtil.getAttribute(req, sessionLearingToken);
		if (StringUtil.isEmpty(sessionAccessToken) || learning.getAccessToken().equals(sessionAccessToken) == false) {
			logger.trace(req, "[Initialize][INVALID_PARAMETER][" + HttpUtil.getRequestParametersToString(req) + "]");
			throw new AofException(Errors.INVALID_PARAMETER.desc);
		}
		HashMap<String, String> dataModel = new HashMap<String, String>();

		UILcmsItemVO item = new UILcmsItemVO();
		item.setItemSeq(learning.getItemSeq());
		UILcmsItemRS itemRS = (UILcmsItemRS)itemService.getDetail(item);
		if (itemRS != null) {
			dataModel.put("cmi.launch_data", itemRS.getItem().getDataFromLms());
			dataModel.put("cmi.scaled_passing_score", itemRS.getItem().getMinNormalizedMeasure());
			dataModel.put("cmi.time_limit_action", itemRS.getItem().getTimeLimitAction());
			dataModel.put("cmi.completion_threshold", itemRS.getItem().getCompletionThreshold());
			dataModel.put("cmi.max_time_allowed", itemRS.getItem().getAttemptDurationLimit());

			result = true;
		}

		if (result == true) {
			mav.addObject("result", "true");
			logger.trace(req, "[Initialize][TRUE][" + HttpUtil.getRequestParametersToString(req) + "]");
		} else {
			mav.addObject("result", "false");
			logger.trace(req, "[Initialize][FALSE][" + HttpUtil.getRequestParametersToString(req) + "]");
		}
		return mav;
	}

	/**
	 * 학습창 Terminate
	 * 
	 * @param req
	 * @param res
	 * @param learning
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/learning/api/simple/terminate.do")
	public ModelAndView simpleTerminate(HttpServletRequest req, HttpServletResponse res, UILcmsSimpleLearningVO learning) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("jsonView");

		if (SessionUtil.isValid(req)) {
			String sessionAccessToken = (String)SessionUtil.getAttribute(req, sessionLearingToken);
			if (StringUtil.isEmpty(sessionAccessToken) || learning.getAccessToken().equals(sessionAccessToken) == false) {
				logger.trace(req, "[Terminate][PARAMETER_INVALID][" + HttpUtil.getRequestParametersToString(req) + "]");
				throw new AofException(Errors.INVALID_PARAMETER.desc);
			}

			String learnerId = HttpUtil.getParameter(req, "cmi.learner_id", "");
			Long courseActiveSeq = -1L;
			Long courseApplySeq = -1L;
			if (StringUtil.isEmpty(learning.getCourseId()) || "preview".equalsIgnoreCase(learning.getCourseId())
					|| "resume".equalsIgnoreCase(learning.getCourseId())) {
				courseActiveSeq = -1L;
				courseApplySeq = -1L;
			} else {
				courseActiveSeq = Long.parseLong(learning.getCourseId());
				courseApplySeq = Long.parseLong(learning.getApplyId());
			}
			Long organizationSeq = learning.getOrganizationSeq();
			Long itemSeq = learning.getItemSeq();

			UILcmsLearnerDatamodelVO learnerDatamodel = new UILcmsLearnerDatamodelVO();
			learnerDatamodel.setLearnerId(learnerId);
			learnerDatamodel.setCourseActiveSeq(courseActiveSeq);
			learnerDatamodel.setCourseApplySeq(courseApplySeq);
			learnerDatamodel.setOrganizationSeq(organizationSeq);
			learnerDatamodel.setItemSeq(itemSeq);

			UILcmsDailyProgressVO dailyProgress = new UILcmsDailyProgressVO();
			dailyProgress.setLearnerId(learnerId);
			dailyProgress.setCourseActiveSeq(courseActiveSeq);
			dailyProgress.setCourseApplySeq(courseApplySeq);
			dailyProgress.setOrganizationSeq(organizationSeq);
			dailyProgress.setItemSeq(itemSeq);

			requiredSession(req, learnerDatamodel, dailyProgress);

			setDatamodel(learnerDatamodel, dailyProgress, learning, req);

			if (StringUtil.isNotEmpty(learning.getCourseId()) && "preview".equalsIgnoreCase(learning.getCourseId()) == false
					&& "resume".equalsIgnoreCase(learning.getCourseId()) == false) {

				int count = learnerDatamodelService.getCount(learnerDatamodel);
				if (count > 0) {
					// update
					learnerDatamodelService.updateLearnerDatamodel(learnerDatamodel, dailyProgress);
				} else {
					// insert
					learnerDatamodelService.insertLearnerDatamodel(learnerDatamodel, dailyProgress);
				}

				// 출석여부 체크 및 업데이트
				this.saveCourseApplyAttend(req, res, learnerDatamodel);

			}
			SessionUtil.removeAttribute(req, sessionLearingToken); // commit 과 terminate의 차이점.
			mav.addObject("result", "true");
			logger.trace(req, "[Terminate][TRUE][" + HttpUtil.getRequestParametersToString(req) + "]");
		} else {
			mav.addObject("result", "false");
			logger.trace(req, "[Terminate][FALSE][" + HttpUtil.getRequestParametersToString(req) + "]");
		}
		return mav;
	}

	/**
	 * 학습창 Commit
	 * 
	 * @param req
	 * @param res
	 * @param learning
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/learning/api/simple/commit.do")
	public ModelAndView simpleCommit(HttpServletRequest req, HttpServletResponse res, UILcmsSimpleLearningVO learning) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("jsonView");

		if (SessionUtil.isValid(req)) {
			String sessionAccessToken = (String)SessionUtil.getAttribute(req, sessionLearingToken);
			if (StringUtil.isEmpty(sessionAccessToken) || learning.getAccessToken().equals(sessionAccessToken) == false) {
				logger.trace(req, "[Commit][PARAMETER_INVALID][" + HttpUtil.getRequestParametersToString(req) + "]");
				throw new AofException(Errors.INVALID_PARAMETER.desc);
			}

			String learnerId = HttpUtil.getParameter(req, "cmi.learner_id", "");
			Long courseActiveSeq = -1L;
			Long courseApplySeq = -1L;
			if (StringUtil.isEmpty(learning.getCourseId()) || "preview".equalsIgnoreCase(learning.getCourseId())
					|| "resume".equalsIgnoreCase(learning.getCourseId())) {
				courseActiveSeq = -1L;
				courseApplySeq = -1L;
			} else {
				courseActiveSeq = Long.parseLong(learning.getCourseId());
				courseApplySeq = Long.parseLong(learning.getApplyId());
			}
			Long organizationSeq = learning.getOrganizationSeq();
			Long itemSeq = learning.getItemSeq();

			UILcmsLearnerDatamodelVO learnerDatamodel = new UILcmsLearnerDatamodelVO();
			learnerDatamodel.setLearnerId(learnerId);
			learnerDatamodel.setCourseActiveSeq(courseActiveSeq);
			learnerDatamodel.setCourseApplySeq(courseApplySeq);
			learnerDatamodel.setOrganizationSeq(organizationSeq);
			learnerDatamodel.setItemSeq(itemSeq);

			UILcmsDailyProgressVO dailyProgress = new UILcmsDailyProgressVO();
			dailyProgress.setLearnerId(learnerId);
			dailyProgress.setCourseActiveSeq(courseActiveSeq);
			dailyProgress.setCourseApplySeq(courseApplySeq);
			dailyProgress.setOrganizationSeq(organizationSeq);
			dailyProgress.setItemSeq(itemSeq);

			requiredSession(req, learnerDatamodel, dailyProgress);

			setDatamodel(learnerDatamodel, dailyProgress, learning, req);

			if (StringUtil.isNotEmpty(learning.getCourseId()) && "preview".equalsIgnoreCase(learning.getCourseId()) == false
					&& "resume".equalsIgnoreCase(learning.getCourseId()) == false) {
				int count = learnerDatamodelService.getCount(learnerDatamodel);
				if (count > 0) {
					// update
					learnerDatamodelService.updateLearnerDatamodel(learnerDatamodel, dailyProgress);
				} else {
					// insert
					learnerDatamodelService.insertLearnerDatamodel(learnerDatamodel, dailyProgress);
				}

				// 출석여부 체크 및 업데이트
				this.saveCourseApplyAttend(req, res, learnerDatamodel);
			}
			mav.addObject("result", "true");
			logger.trace(req, "[Commit][TRUE][" + HttpUtil.getRequestParametersToString(req) + "]");
		} else {
			mav.addObject("result", "false");
			logger.trace(req, "[Commit][FALSE][" + HttpUtil.getRequestParametersToString(req) + "]");
		}
		return mav;
	}

	/**
	 * 학습창에서 정상종료 되지 않은 경우 restore
	 * 
	 * @param req
	 * @param res
	 * @param learning
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/learning/api/simple/restore.do")
	public ModelAndView simpleRestore(HttpServletRequest req, HttpServletResponse res, UILcmsSimpleLearningVO learning) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("jsonView");

		if (SessionUtil.isValid(req)) {
			String learnerId = HttpUtil.getParameter(req, "cmi.learner_id", "");
			String restore = "0";
			String reason = "";
			if (learnerId.equals(SessionUtil.getMember(req).getMemberSeq().toString())) {
				Long courseActiveSeq = -1L;
				Long courseApplySeq = -1L;
				if (StringUtil.isEmpty(learning.getCourseId()) || "preview".equalsIgnoreCase(learning.getCourseId())
						|| "resume".equalsIgnoreCase(learning.getCourseId())) {
					courseActiveSeq = -1L;
					courseApplySeq = -1L;
				} else {
					courseActiveSeq = Long.parseLong(learning.getCourseId());
					courseApplySeq = Long.parseLong(learning.getApplyId());
				}
				Long organizationSeq = learning.getOrganizationSeq();
				Long itemSeq = learning.getItemSeq();

				UILcmsLearnerDatamodelVO learnerDatamodel = new UILcmsLearnerDatamodelVO();
				learnerDatamodel.setLearnerId(learnerId);
				learnerDatamodel.setCourseActiveSeq(courseActiveSeq);
				learnerDatamodel.setCourseApplySeq(courseApplySeq);
				learnerDatamodel.setOrganizationSeq(organizationSeq);
				learnerDatamodel.setItemSeq(itemSeq);

				UILcmsDailyProgressVO dailyProgress = new UILcmsDailyProgressVO();
				dailyProgress.setLearnerId(learnerId);
				dailyProgress.setCourseActiveSeq(courseActiveSeq);
				dailyProgress.setCourseApplySeq(courseApplySeq);
				dailyProgress.setOrganizationSeq(organizationSeq);
				dailyProgress.setItemSeq(itemSeq);

				requiredSession(req, learnerDatamodel, dailyProgress);

				setDatamodel(learnerDatamodel, dailyProgress, learning, req);

				if (StringUtil.isNotEmpty(learning.getCourseId()) && "preview".equalsIgnoreCase(learning.getCourseId()) == false
						&& "resume".equalsIgnoreCase(learning.getCourseId()) == false) {
					UILcmsLearnerDatamodelRS detail = (UILcmsLearnerDatamodelRS)learnerDatamodelService.getDetail(learnerDatamodel);
					if (detail != null) {
						int attempt = HttpUtil.getParameter(req, "cmi.attempt", 0);
						int savedAttempt = StringUtil.isEmpty(detail.getLearnerDatamodel().getAttempt()) ? 0 : Integer.parseInt(detail.getLearnerDatamodel()
								.getAttempt());
						if (attempt + 1 >= savedAttempt) {
							// update
							learnerDatamodelService.updateLearnerDatamodel(learnerDatamodel, dailyProgress);
							restore = "1";
							reason = "update";
						} else {
							restore = "0";
							reason = "attempt[" + attempt + ":" + savedAttempt + "]";
						}
					} else {
						// insert
						learnerDatamodelService.insertLearnerDatamodel(learnerDatamodel, dailyProgress);
						restore = "1";
						reason = "insert";
					}
				}
			} else {
				restore = "0";
				reason = "learnerId[" + learnerId + ":" + SessionUtil.getMember(req).getMemberSeq() + "]";
			}
			mav.addObject("restore", restore);
			mav.addObject("result", "true");
			logger.trace(req, "[Restore][TRUE:" + restore + ":" + reason + "][" + HttpUtil.getRequestParametersToString(req) + "]");
		} else {
			mav.addObject("result", "false");
			mav.addObject("restore", "0");
			logger.trace(req, "[Restore][FALSE][" + HttpUtil.getRequestParametersToString(req) + "]");
		}
		return mav;
	}

	/**
	 * 저장하기위한 dataModel 데이타 만들기
	 * 
	 * @param learnerDatamodel
	 * @param dailyProgress
	 * @param learning
	 * @param req
	 */
	protected void setDatamodel(UILcmsLearnerDatamodelVO learnerDatamodel, UILcmsDailyProgressVO dailyProgress, UILcmsSimpleLearningVO learning,
			HttpServletRequest req) {
		int attempt = HttpUtil.getParameter(req, "cmi.attempt", 0);
		// long sessionTime = parseSessionTime(HttpUtil.getParameter(req, "cmi.session_time", ""));
		long sessionTime = HttpUtil.getParameter(req, "cmi.saved_session_time", 0L);
		long startTime = learning.getStartTime();
		long attemptSessionTime = System.currentTimeMillis() - startTime;
		sessionTime += attemptSessionTime;
		learnerDatamodel.setAttempt(String.valueOf(attempt + 1));
		learnerDatamodel.setSessionTime(String.valueOf(sessionTime));
		learnerDatamodel.setProgressMeasure(HttpUtil.getParameter(req, "cmi.progress_measure", "0.0"));
		learnerDatamodel.setScoreScaled(HttpUtil.getParameter(req, "cmi.score_scaled", "0"));
		learnerDatamodel.setCompletionStatus(HttpUtil.getParameter(req, "cmi.completion_status", "incomplete"));
		learnerDatamodel.setSuccessStatus(HttpUtil.getParameter(req, "cmi.success_status", "failed"));

		double completionThreshold = Double.parseDouble(HttpUtil.getParameter(req, "cmi.completion_threshold", "0.0"));
		double movieMaxTime = Double.parseDouble(HttpUtil.getParameter(req, "etc.movie_max_time", "0.0")); // 비표준 동영상일 경우.

		// TODO: 코드사용
		if ("COMPLETION_TYPE::PROGRESS".equals(learning.getCompletionType())) { // 표준: 진도율 기준
			double progressMeasure = Double.parseDouble(learnerDatamodel.getProgressMeasure());
			if (completionThreshold == 0 || progressMeasure == 1 || (completionThreshold > 0 && progressMeasure >= completionThreshold)) {
				learnerDatamodel.setCompletionStatus("completed");
			}

			double scoreScaled = Double.parseDouble(learnerDatamodel.getScoreScaled());
			double scaledPassingScore = Double.parseDouble(HttpUtil.getParameter(req, "cmi.scaled_passing_score", "0.0"));
			if (scoreScaled == 1 || (scaledPassingScore > 0 && scoreScaled >= scaledPassingScore)) {
				learnerDatamodel.setSuccessStatus("passed");
			}

		} else { // 비표준: 시간 기준
			if (movieMaxTime > 0) { // 비표준 동영상일 경우.
				if (movieMaxTime >= completionThreshold) { // 동영상 시간은 초 단위로 온다.
					learnerDatamodel.setCompletionStatus("completed");
				}
				double progressMeasure = movieMaxTime / completionThreshold;
				learnerDatamodel.setProgressMeasure(String.valueOf(Math.min(1, progressMeasure)));
			} else {
				if (sessionTime >= completionThreshold * 1000) {
					learnerDatamodel.setCompletionStatus("completed");
				}
				double progressMeasure = sessionTime / (completionThreshold * 1000);
				learnerDatamodel.setProgressMeasure(String.valueOf(Math.min(1, progressMeasure)));
			}
		}

		String prevComletionStatus = HttpUtil.getParameter(req, "etc.start_completion_status", "incomplete");
		if ("incomplete".equals(prevComletionStatus) && "completed".equals(learnerDatamodel.getCompletionStatus())) {
			// completionStatus 가 incomplete 에서 completed 변경되면.
			learnerDatamodel.setCompletionDtime("Y"); // query 에서, Y 이면 FN_NOW_TO_CHAR() 을 기록한다.
		}

		learnerDatamodel.setLocation(HttpUtil.getParameter(req, "cmi.location", ""));
		learnerDatamodel.setSuspendData(HttpUtil.getParameter(req, "cmi.suspend_data", ""));
		learnerDatamodel.setCredit(HttpUtil.getParameter(req, "cmi.credit", "credit"));
		learnerDatamodel.setEntry(HttpUtil.getParameter(req, "cmi.entry", ""));

		StringBuffer objectives = new StringBuffer();
		StringBuffer interactions = new StringBuffer();
		StringBuffer comments = new StringBuffer();
		StringBuffer adls = new StringBuffer();
		StringBuffer etcs = new StringBuffer();
		String[] etcExcepts = { "cmi.attempt", "cmi.progress_measure", "cmi.completion_status", "cmi.score_scaled", "cmi.success_status", "cmi.location",
				"cmi.session_time", "cmi.saved_session_time", "cmi.suspend_data", "cmi.credit", "cmi.entry", "cmi.launch_data", "cmi.time_limit_action",
				"cmi.learner_id", "cmi.completion_threshold", "cmi.learner_name", "cmi.exit", "cmi.scaled_passing_score", "cmi.max_time_allowed",
				"organizationSeq", "itemSeq", "accessToken", "startTime", "contentTypeCd", "completionType", "courseId", "applyId", "etc.daily_progress_seq",
				"etc.daily_progress_measure", "etc.daily_session_time", "etc.daily_attempt", "etc.daily_study_date", "etc.start_progress_measure",
				"etc.start_completion_status" };

		List<String> listEtcExcepts = (List<String>)Arrays.asList(etcExcepts);
		Enumeration<?> paramNames = req.getParameterNames();
		while (paramNames.hasMoreElements()) {
			String paramName = (String)paramNames.nextElement();
			String[] paramValues = req.getParameterValues(paramName);
			String paramValue = "";
			if (paramValues.length == 1) {
				paramValue = paramValues[0];
			} else if (paramValues.length > 1) {
				for (int i = 0; i < paramValues.length; i++) {
					if (i > 0) {
						paramValue += ",";
					}
					paramValue += paramValues[i];
				}
			}
			if (paramName.startsWith("cmi.objectives.")) {
				if (objectives.length() > 0) {
					objectives.append(Constants.SEPARATOR);
				}
				objectives.append(paramName + "=" + paramValue);
			} else if (paramName.startsWith("cmi.interactions.")) {
				if (interactions.length() > 0) {
					interactions.append(Constants.SEPARATOR);
				}
				interactions.append(paramName + "=" + paramValue);
			} else if (paramName.startsWith("cmi.comment_from_learner.")) {
				if (comments.length() > 0) {
					comments.append(Constants.SEPARATOR);
				}
				comments.append(paramName + "=" + paramValue);
			} else if (paramName.startsWith("adl.")) {
				if (adls.length() > 0) {
					adls.append(Constants.SEPARATOR);
				}
				adls.append(paramName + "=" + paramValue);
			} else {
				if (listEtcExcepts.contains(paramName) == false) {
					if (etcs.length() > 0) {
						etcs.append(Constants.SEPARATOR);
					}
					etcs.append(paramName + "=" + paramValue);
				}
			}
		}
		learnerDatamodel.setObjective(objectives.toString());
		learnerDatamodel.setInteraction(interactions.toString());
		learnerDatamodel.setCommentFromLearner(comments.toString());
		learnerDatamodel.setAdlData(adls.toString());
		learnerDatamodel.setEtc(etcs.toString());

		String startProgressMeasure = HttpUtil.getParameter(req, "etc.start_progress_measure", "0.0");
		String dailyProgressMeasure = HttpUtil.getParameter(req, "etc.daily_progress_measure", "0.0");
		String dailySessionTime = HttpUtil.getParameter(req, "etc.daily_session_time", "0");
		String dailyAttempt = HttpUtil.getParameter(req, "etc.daily_attempt", "0");
		String dailyStudyDate = HttpUtil.getParameter(req, "etc.daily_study_date", "");

		Double progress = Double.parseDouble(learnerDatamodel.getProgressMeasure()) - Double.parseDouble(startProgressMeasure);
		progress += Double.parseDouble(dailyProgressMeasure);

		dailyProgress.setDailyProgressSeq(HttpUtil.getParameter(req, "etc.daily_progress_seq", 0L));
		dailyProgress.setProgressMeasure(String.valueOf(progress));
		dailyProgress.setSessionTime(String.valueOf(Integer.parseInt(dailySessionTime) + attemptSessionTime));
		dailyProgress.setAttempt(String.valueOf(Integer.parseInt(dailyAttempt) + 1));
		dailyProgress.setStudyDate(dailyStudyDate);

	}

	/**
	 * 다른 사람의 cmi data 가져오기. (comment_from_learner)
	 * 
	 * @param req
	 * @param res
	 * @param learning
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/learning/api/simple/get/others/data.do")
	public ModelAndView getOthersData(HttpServletRequest req, HttpServletResponse res, UILcmsSimpleLearningVO learning) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("jsonView");

		if (SessionUtil.isValid(req)) {
			String learnerId = HttpUtil.getParameter(req, "cmi.learner_id", "");
			String dataName = HttpUtil.getParameter(req, "dataName", "");
			Long courseActiveSeq = -1L;
			Long courseApplySeq = -1L;
			if (StringUtil.isEmpty(learning.getCourseId()) || "preview".equalsIgnoreCase(learning.getCourseId())
					|| "resume".equalsIgnoreCase(learning.getCourseId())) {
				courseActiveSeq = -1L;
				courseApplySeq = -1L;
			} else {
				courseActiveSeq = Long.parseLong(learning.getCourseId());
				courseApplySeq = Long.parseLong(learning.getApplyId());
			}
			Long organizationSeq = learning.getOrganizationSeq();
			Long itemSeq = learning.getItemSeq();

			if (StringUtil.isNotEmpty(learnerId) && StringUtil.isNotEmpty(courseActiveSeq) && StringUtil.isNotEmpty(courseApplySeq)
					&& StringUtil.isNotEmpty(organizationSeq) && StringUtil.isNotEmpty(itemSeq) && StringUtil.isNotEmpty(dataName)) {

				UILcmsLearnerDatamodelDataCondition condition = new UILcmsLearnerDatamodelDataCondition();
				condition.setSrchLearnerId(learnerId);
				condition.setSrchCourseActiveSeq(courseActiveSeq);
				condition.setSrchCourseApplySeq(courseApplySeq);
				condition.setSrchOrganizationSeq(organizationSeq);
				condition.setSrchItemSeq(itemSeq);
				condition.setSrchDataName(dataName);
				List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
				Paginate<ResultSet> paginate = learnerDatamodelDataService.getList(condition);
				for (int index = 0; index < paginate.getItemList().size(); index++) {
					UILcmsLearnerDatamodelDataRS rs = (UILcmsLearnerDatamodelDataRS)paginate.getItemList().get(index);
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("learnerId", rs.getLearnerDatamodelData().getLearnerId());
					map.put("learnerName", rs.getLearnerDatamodelData().getLearnerName());
					map.put("dataName", rs.getLearnerDatamodelData().getDataName());
					map.put("dataValue", rs.getLearnerDatamodelData().getDataValue());
					map.put("updDtime", rs.getLearnerDatamodelData().getUpdDtime());
					list.add(map);
				}

				mav.addObject("data", list);
			}
			mav.addObject("result", "true");
			logger.trace(req, "[OthersData][TRUE][" + HttpUtil.getRequestParametersToString(req) + "]");
		} else {
			mav.addObject("result", "false");
			logger.trace(req, "[OthersData][FALSE][" + HttpUtil.getRequestParametersToString(req) + "]");
		}
		return mav;
	}

	/**
	 * 맛보기
	 * 
	 * @param req
	 * @param res
	 * @param learning
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/learning/simple/sample/popup.do")
	public ModelAndView simpleSampleView(HttpServletRequest req, HttpServletResponse res, UILcmsSimpleLearningVO learning) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/lcms/learning/simpleLearningSamplePopup");

		// try {
		// if (StringUtil.isEmpty(learning.getCourseId())) {
		// return mav;
		// }
		// Long courseActiveSeq = Long.parseLong(learning.getCourseId());
		// HashMap<String, Long> map = (HashMap<String, Long>)courseActiveService.getSampleInfo(courseActiveSeq);
		//
		// if (map == null) {
		// return mav;
		// }
		// learning.setOrganizationSeq(Long.parseLong("" + map.get("organizationSeq")));
		// learning.setItemSeq(Long.parseLong("" + map.get("itemSeq")));
		//
		// UIOrganizationVO organization = new UIOrganizationVO();
		// organization.setOrganizationSeq(learning.getOrganizationSeq());
		// UIOrganizationRS organizationRS = (UIOrganizationRS)organizationService.getDetail(organization);
		// if (organizationRS != null) {
		// learning.setOrganizationTitle(organizationRS.getOrganization().getTitle());
		// learning.setContentTypeCd(organizationRS.getOrganization().getContentsTypeCd());
		// if (StringUtil.isNotEmpty(organizationRS.getOrganization().getWidth())) {
		// learning.setWidth(String.valueOf(organizationRS.getOrganization().getWidth()));
		// }
		// if (StringUtil.isNotEmpty(organizationRS.getOrganization().getHeight())) {
		// learning.setHeight(String.valueOf(organizationRS.getOrganization().getHeight()));
		// }
		// }
		//
		// UIItemVO item = new UIItemVO();
		// item.setItemSeq(learning.getItemSeq());
		// UIItemRS itemRS = (UIItemRS)itemService.getDetail(item);
		// if (itemRS != null) {
		// learning.setItemTitle(itemRS.getItem().getTitle());
		// learning.setKeyword(itemRS.getItem().getKeyword());
		// StringBuffer href = new StringBuffer();
		// if (StringUtil.isNotEmpty(itemRS.getItemResource().getBase())) {
		// href.append(itemRS.getItemResource().getBase());
		// }
		// if (StringUtil.isNotEmpty(itemRS.getItemResource().getHref())) {
		// href.append(itemRS.getItemResource().getHref());
		// }
		// learning.setItemToLaunch(href.toString());
		// }
		// String accessToken = StringUtil.getRandomUUID();
		// SessionUtil.setAttribute(req, sessionLearingToken, accessToken);
		// learning.setAccessToken(accessToken);
		// learning.setStartTime(System.currentTimeMillis());
		//
		// learning.setCourseId("preview");
		// mav.addObject("learning", learning);
		//
		// } catch (Exception e) {
		// throw e;
		// }
		return mav;

	}

	/**
	 * parse 세션 타임
	 * 
	 * @param sessionTime
	 * @return long
	 */
	public long parseSessionTime(String sessionTime) {
		if (StringUtil.isEmpty(sessionTime)) {
			return 0;
		}

		long time = 0;
		try {
			time = Long.parseLong(sessionTime);
		} catch (Exception e) {
			long h = 0;
			long m = 0;
			long s = 0;
			String surfix = "PT0H121M2S";
			Pattern pattern = Pattern.compile("T(\\d+)H");
			Matcher matcher = pattern.matcher(surfix);
			if (matcher.find()) {
				h = Long.parseLong(matcher.group(1));
			}

			pattern = Pattern.compile("H(\\d+)M");
			matcher = pattern.matcher(surfix);
			if (matcher.find()) {
				m = Long.parseLong(matcher.group(1));
			}

			pattern = Pattern.compile("M(\\d+)S");
			matcher = pattern.matcher(surfix);
			if (matcher.find()) {
				s = Long.parseLong(matcher.group(1));
			}

			time = h * (60 * 60) + m * (60) + s;
		}
		return time;
	}

	/**
	 * 관리자의 학습창 로그 콘솔
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/learning/simple/log.do")
	public ModelAndView simpleLearning(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("/lcms/learning/simpleLearningLog");
		return mav;
	}

	/**
	 * 외부 검색
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/learning/external/search.do")
	public ModelAndView searchExternal(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req);

		String site = HttpUtil.getParameter(req, "site", "YouTube");

		mav.setViewName("/lcms/learning/searchExternal" + site);

		return mav;
	}

	/**
	 * 출석여부 테이블인 cs_course_apply_attend 테이블에 출석, 지각, 결석에 대한 부분 처리
	 * 
	 * @param req
	 * @param res
	 * @param learnerDatamodel
	 * @throws Exception
	 */
	public void saveCourseApplyAttend(HttpServletRequest req, HttpServletResponse res, UILcmsLearnerDatamodelVO learnerDatamodel) throws Exception {
		UnivCourseApplyAttendVO applyAttend = new UnivCourseApplyAttendVO();
		applyAttend.setCourseApplySeq(learnerDatamodel.getCourseApplySeq());
		applyAttend.setReferenceSeq(learnerDatamodel.getOrganizationSeq());
		applyAttend.setLessonSeq(learnerDatamodel.getItemSeq());
		applyAttend.copyAudit(learnerDatamodel);

		UnivCourseApplyAttendVO applyAttendResult = applyAttendService.getDetailByLcmsCourseApplyAttend(applyAttend);

		// 출석인정 진도율 값 코드에서 가져오기
		List<CodeVO> attendProgressValueList = codeService.getListCodeCache("ATTEND_PROGRESS");
		CodeVO codeVO = null;
		Double attendProgressValue = 0.0;

		for (int i = 0; i < attendProgressValueList.size(); i++) {
			codeVO = attendProgressValueList.get(0);
			if ("ATTEND_PROGRESS::VALUE".equals(codeVO.getCode())) {
				attendProgressValue = Double.parseDouble(codeVO.getCodeName());
			}
		}

		if (applyAttendResult == null) {// 등록
			// 최초 등록시 activeElementSeq 값을 우선 가져온다.
			UnivCourseActiveElementVO element = new UnivCourseActiveElementVO();
			element.setCourseActiveSeq(learnerDatamodel.getCourseActiveSeq());
			element.setReferenceSeq(learnerDatamodel.getOrganizationSeq());
			// TODO: 코드사용
			element.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
			element.setCourseWeekTypeCd("COURSE_WEEK_TYPE::LECTURE");

			UIUnivCourseActiveElementRS elementResult = (UIUnivCourseActiveElementRS)elementService.getDetailElementType(element);
			applyAttend.setActiveElementSeq(elementResult.getElement().getActiveElementSeq());
			applyAttend.setOnoffCd("ONOFF_TYPE::ON");
			applyAttend.setCourseActiveSeq(learnerDatamodel.getCourseActiveSeq());

			// 출석 여부 체크
			if ((Double.parseDouble(learnerDatamodel.getProgressMeasure()) * 100) >= attendProgressValue) {
				applyAttend.setAttendTypeCd("ATTEND_TYPE::001");
			} else {
				applyAttend.setAttendTypeCd("ATTEND_TYPE::003");
			}

			applyAttendService.insertCourseApplyAttend(applyAttend);
		} else {// 수정
			applyAttendResult.copyAudit(learnerDatamodel);

			// 출석 여부 체크
			if ((Double.parseDouble(learnerDatamodel.getProgressMeasure()) * 100) >= attendProgressValue) {
				applyAttendResult.setAttendTypeCd("ATTEND_TYPE::001");
			} else {
				if (!applyAttendResult.getAttendTypeCd().equals("ATTEND_TYPE::001")) {// 출석상태에서 내려가지 않게 체크
					applyAttendResult.setAttendTypeCd("ATTEND_TYPE::003");
				}
			}

			applyAttendService.updateCourseApplyAttend(applyAttendResult);
		}
	}
}
