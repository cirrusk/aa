/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.web.UnivBaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamPaperVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseExamPaperRS;
import com._4csoft.aof.univ.service.UnivCourseApplyElementService;
import com._4csoft.aof.univ.service.UnivCourseApplyService;
import com._4csoft.aof.univ.service.UnivCourseExamAnswerService;
import com._4csoft.aof.univ.service.UnivCourseExamPaperService;
import com._4csoft.aof.univ.vo.UnivCourseExamAnswerVO;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseExamPaperAnswerController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 28.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseExamPaperAnswerController extends UnivBaseController {

	@Resource (name = "UnivCourseExamAnswerService")
	protected UnivCourseExamAnswerService courseExamAnswerService;

	@Resource (name = "UnivCourseApplyElementService")
	protected UnivCourseApplyElementService courseApplyElementService;

	@Resource (name = "UnivCourseExamPaperService")
	protected UnivCourseExamPaperService courseExamPaperService;

	@Resource (name = "UnivCourseApplyService")
	protected UnivCourseApplyService courseApplyService;

	/**
	 * 개설과목 시험지 응시 등록
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/exampaper/answer/update.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseExamAnswerVO courseExamAnswer,
			UIUnivCourseExamPaperVO courseExamPaper, UIUnivCourseApplyElementVO courseApplyElement, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseExamAnswer, courseExamPaper, courseApplyElement);
		courseApplyElement.setIp(courseApplyElement.getUpdIp());

		List<UnivCourseExamAnswerVO> courseExamAnswers = new ArrayList<UnivCourseExamAnswerVO>();
		for (int index = 0; index < courseExamAnswer.getExamAnswerSeqs().length; index++) {
			String info = null;
			String attachUploadInfo = null;
			String attachDeleteInfo = null;

			UIUnivCourseExamAnswerVO o = new UIUnivCourseExamAnswerVO();

			// 첨부파일 정보 저장 하기 위한 변환 및 값 세팅
			if (StringUtil.isNotEmpty(courseExamAnswer.getAttachUploadInfos()[index])) {
				info = courseExamAnswer.getAttachUploadInfos()[index];
				attachUploadInfo = info.replace("|", String.valueOf((char)0x01));
			}
			if (StringUtil.isNotEmpty(courseExamAnswer.getAttachDeleteInfos()[index])) {
				attachDeleteInfo = courseExamAnswer.getAttachDeleteInfos()[index];
			}

			o.copyAudit(courseExamAnswer);
			o.setExamItemTypeCd(courseExamAnswer.getExamItemTypeCds()[index]);
			o.setExamAnswerSeq(courseExamAnswer.getExamAnswerSeqs()[index]);
			o.setCorrectAnswer(courseExamAnswer.getCorrectAnswers()[index]);
			o.setSimilarAnswer(courseExamAnswer.getSimilarAnswers()[index]);
			o.setChoiceAnswer(courseExamAnswer.getChoiceAnswers()[index]);
			o.setShortAnswer(courseExamAnswer.getShortAnswers()[index]);
			o.setEssayAnswer(courseExamAnswer.getEssayAnswers()[index]);
			o.setExamItemScore(courseExamAnswer.getExamItemScores()[index]);
			o.setAttachUploadInfo(attachUploadInfo);
			o.setAttachDeleteInfo(attachDeleteInfo);

			courseExamAnswers.add(o);
		}

		if (courseExamAnswers.size() > 0) {
			UIUnivCourseExamPaperRS detail = (UIUnivCourseExamPaperRS)courseExamPaperService.getDetail(courseExamPaper);
			mav.addObject("result", courseExamAnswerService.updateListCourseExamAnswer(courseExamAnswers, detail.getCourseExamPaper(), courseApplyElement, courseActiveExamPaper));
		} else {
			mav.addObject("result", 0);
		}

		mav.setViewName("/common/save");
		return mav;
	}
}
