/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.lcms.service.LcmsDailyProgressService;
import com._4csoft.aof.lcms.service.LcmsLearnerDatamodelService;
import com._4csoft.aof.lcms.vo.LcmsLearnerDatamodelVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.lcms.vo.UILcmsDailyProgressVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsLearnerDatamodelVO;
import com._4csoft.aof.ui.lcms.vo.condition.UILcmsLearnerDatamodelCondition;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.lcms.web
 * @File : UILearnerDatamodelController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UILcmsLearnerDatamodelController extends BaseController {

	@Resource (name = "LcmsLearnerDatamodelService")
	private LcmsLearnerDatamodelService learnerDatamodelService;

	@Resource (name = "LcmsDailyProgressService")
	private LcmsDailyProgressService dailyProgressService;

	/**
	 * 학습자 데이타모델 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsLearnerDatamodelCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/learner/datamodel/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UILcmsLearnerDatamodelCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		if ("Y".equals(condition.getSrchYn())) {
			if (StringUtil.isNotEmpty(condition.getSrchStartUpdDate())) {
				condition.setSrchStartUpdDate(DateUtil.convertStartDate(condition.getSrchStartUpdDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
			}
			if (StringUtil.isNotEmpty(condition.getSrchEndUpdDate())) {
				condition.setSrchEndUpdDate(DateUtil.convertEndDate(condition.getSrchEndUpdDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
			}
			mav.addObject("paginate", learnerDatamodelService.getList(condition));
		}
		mav.addObject("condition", condition);

		mav.setViewName("/lcms/learnerDatamodel/listLearnerDatamodel");
		return mav;
	}

	/**
	 * 학습자 데이타모델 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsLearnerDatamodelVO
	 * @param UILcmsLearnerDatamodelCondition
	 * @param UILcmsDailyProgressVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/learner/datamodel/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UILcmsLearnerDatamodelVO learnerDatamodel,
			UILcmsLearnerDatamodelCondition condition, UILcmsDailyProgressVO dailyProgress) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", learnerDatamodelService.getDetail(learnerDatamodel));
		mav.addObject("dailyProgressList", dailyProgressService.getList(dailyProgress));
		mav.addObject("condition", condition);

		mav.setViewName("/lcms/learnerDatamodel/detailLearnerDatamodel");
		return mav;
	}

	/**
	 * 학습자 데이타모델 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsLearnerDatamodelVO
	 * @param UILcmsLearnerDatamodelCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/learner/datamodel/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UILcmsLearnerDatamodelVO learnerDatamodel,
			UILcmsLearnerDatamodelCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", learnerDatamodelService.getDetail(learnerDatamodel));
		mav.addObject("condition", condition);

		mav.setViewName("/lcms/learnerDatamodel/editLearnerDatamodel");
		return mav;
	}

	/**
	 * 학습자 데이타모델 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsLearnerDatamodelVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/learner/datamodel/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UILcmsLearnerDatamodelVO learnerDatamodel) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, learnerDatamodel);

		learnerDatamodelService.updateLearnerDatamodel(learnerDatamodel, null);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 학습자 데이타모델 다중 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsLearnerDatamodelVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/learner/datamodel/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UILcmsLearnerDatamodelVO learnerDatamodel) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, learnerDatamodel);

		List<LcmsLearnerDatamodelVO> learnerDatamodels = new ArrayList<LcmsLearnerDatamodelVO>();
		for (String index : learnerDatamodel.getCheckkeys()) {
			UILcmsLearnerDatamodelVO o = new UILcmsLearnerDatamodelVO();
			o.setDatamodelSeq(learnerDatamodel.getDatamodelSeqs()[Integer.parseInt(index)]);
			o.setAttempt(learnerDatamodel.getAttempts()[Integer.parseInt(index)]);
			o.setSessionTime(learnerDatamodel.getSessionTimes()[Integer.parseInt(index)]);
			o.setProgressMeasure(learnerDatamodel.getProgressMeasures()[Integer.parseInt(index)]);
			o.setCompletionStatus(learnerDatamodel.getCompletionStatuses()[Integer.parseInt(index)]);
			if (StringUtil.isNotEmpty(learnerDatamodel.getAdminUpdateYn())) {
				o.setAdminUpdateYn(learnerDatamodel.getAdminUpdateYn());
			}
			if ("incomplete".equals(learnerDatamodel.getOldCompletionStatuses()[Integer.parseInt(index)])
					&& "completed".equals(learnerDatamodel.getOldCompletionStatuses()[Integer.parseInt(index)])) {
				o.setCompletionDtime("Y");
			}
			o.copyAudit(learnerDatamodel);

			learnerDatamodels.add(o);
		}

		if (learnerDatamodels.size() > 0) {
			mav.addObject("result", learnerDatamodelService.updatelistLearnerDatamodel(learnerDatamodels));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}
}
