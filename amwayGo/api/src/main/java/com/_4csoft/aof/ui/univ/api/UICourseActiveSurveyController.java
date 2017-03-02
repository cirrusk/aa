/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.api;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;
import com._4csoft.aof.ui.univ.dto.CourseActiveSurveyDTO;
import com._4csoft.aof.ui.univ.dto.CourseActiveSurveyPaperAnswerDTO;
import com._4csoft.aof.ui.univ.dto.CourseActiveSurveyPaperAnswerItemDTO;
import com._4csoft.aof.ui.univ.dto.SurveyDTO;
import com._4csoft.aof.ui.univ.dto.SurveyExampleDTO;
import com._4csoft.aof.ui.univ.service.UIUnivCourseActiveSurveyPaperAnswerService;
import com._4csoft.aof.ui.univ.service.UIUnivCourseActiveSurveyService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyPaperAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivSurveyPaperElementVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveSurveyRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivSurveyExampleRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivSurveyPaperElementRS;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseActiveSurveyPaperAnswerService;
import com._4csoft.aof.univ.service.UnivSurveyPaperElementService;
import com._4csoft.aof.univ.vo.UnivCourseActiveSurveyAnswerVO;
import com.google.gson.Gson;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.api
 * @File : UICourseActiveSurveyController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 24.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICourseActiveSurveyController extends UIBaseController {

	@Resource (name = "UIUnivCourseActiveSurveyService")
	private UIUnivCourseActiveSurveyService courseActiveSurveyService;

	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService univCourseActiveEvaluateService;

	@Resource (name = "UnivSurveyPaperElementService")
	private UnivSurveyPaperElementService surveyPaperElementService;

	@Resource (name = "UnivCourseActiveSurveyPaperAnswerService")
	private UnivCourseActiveSurveyPaperAnswerService courseActiveSurveyPaperAnswerService;
	
	@Resource (name = "UIUnivCourseActiveSurveyPaperAnswerService")
	private UIUnivCourseActiveSurveyPaperAnswerService uiCourseActiveSurveyPaperAnswerService;
	

	/**
	 * 개설과목 설문 목록
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSurvey
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/survey/list")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;
		checkSession(req);

		UIUnivCourseActiveSurveyVO courseActiveSurvey = new UIUnivCourseActiveSurveyVO();

		// 설문지 구분용 값
		courseActiveSurvey.setSurveySubjectTypeCd("SURVEY_SUBJECT_TYPE::COURSE");

		String courseTypeCd = HttpUtil.getParameter(req, "courseTypeCd");
		if (StringUtil.isEmpty(courseTypeCd)) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}

		String courseType = getCodeName(courseTypeCd);
		if (StringUtil.isEmpty(courseType)) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
		}

		courseActiveSurvey.setCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
		courseActiveSurvey.setCourseApplySeq(Long.parseLong(req.getParameter("courseApplySeq")));
		courseActiveSurvey.setCourseTypeCd(courseTypeCd);

		List<CourseActiveSurveyDTO> items = new ArrayList<CourseActiveSurveyDTO>();
		List<ResultSet> rslist = null;
		if (StringUtil.isEmpty(courseActiveSurvey.getCourseApplySeq())) {
			rslist = courseActiveSurveyService.getList(courseActiveSurvey);
		} else {
			rslist = courseActiveSurveyService.getListForClassroom(courseActiveSurvey);
		}

		for (ResultSet rs : rslist) {
			UIUnivCourseActiveSurveyRS courseActiveSurveyRS = (UIUnivCourseActiveSurveyRS)rs;
			CourseActiveSurveyDTO dto = new CourseActiveSurveyDTO();
			BeanUtils.copyProperties(dto, courseActiveSurveyRS.getCourseActiveSurvey());
			dto.setSurveyPaperTitle(courseActiveSurveyRS.getSurveyPaper().getSurveyPaperTitle());
			dto.setSurveyTitle(courseActiveSurveyRS.getSurveySubject().getSurveyTitle());
			dto.setStartDtime(courseActiveSurveyRS.getSurveySubject().getStartDtime());
			dto.setEndDtime(courseActiveSurveyRS.getSurveySubject().getEndDtime());
			dto.setUseYn(courseActiveSurveyRS.getSurveySubject().getUseYn());
			dto.setStatusYn(courseActiveSurveyRS.getSurveySubject().getStatusCd());

			if (StringUtil.isNotEmpty(courseActiveSurveyRS.getCourseActiveSurvey().getSendDtime())) {
				dto.setSurveyYn("Y");
			} else {
				dto.setSurveyYn("N");
			}

			items.add(dto);

		}
		mav.addObject("items", items);

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 개설과목 설문지
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/classroom/surveypaper/detail")
	public ModelAndView detailSurvey(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;
		checkSession(req);
		Long courseActiveSurveySeq = Long.parseLong(req.getParameter("courseActiveSurveySeq"));
		Long courseApplySeq = Long.parseLong(req.getParameter("courseApplySeq"));

		UIUnivCourseActiveSurveyVO courseActiveSurvey = new UIUnivCourseActiveSurveyVO();
		courseActiveSurvey.setCourseActiveSurveySeq(courseActiveSurveySeq);
		courseActiveSurvey.setCourseApplySeq(courseApplySeq);

		UIUnivCourseActiveSurveyRS detail = (UIUnivCourseActiveSurveyRS)courseActiveSurveyService.getDetailSurvey(courseActiveSurvey);
		CourseActiveSurveyDTO dto = new CourseActiveSurveyDTO();
		List<SurveyDTO> items = new ArrayList<SurveyDTO>();

		if (detail != null) {

			BeanUtils.copyProperties(dto, detail.getCourseActiveSurvey());
			dto.setSurveyPaperTitle(detail.getSurveySubject().getSurveyTitle());
			dto.setStartDtime(detail.getSurveySubject().getStartDtime());
			dto.setEndDtime(detail.getSurveySubject().getEndDtime());
			dto.setUseYn(detail.getSurveySubject().getUseYn());
			dto.setSurveyYn(detail.getSurveyPaperAnswer().getSurveyYn());
			dto.setStatusYn(detail.getSurveySubject().getStatusCd());

			UIUnivSurveyPaperElementVO elementVO = new UIUnivSurveyPaperElementVO();
			elementVO.setSurveyPaperSeq(detail.getCourseActiveSurvey().getSurveyPaperSeq());
			List<ResultSet> list = surveyPaperElementService.getList(elementVO);

			for (ResultSet rs : list) {
				UIUnivSurveyPaperElementRS surveyExampleRS = (UIUnivSurveyPaperElementRS)rs;
				SurveyDTO survey = new SurveyDTO();
				BeanUtils.copyProperties(survey, surveyExampleRS.getUnivSurvey());

				survey.setSurveyItemType(getCodeName(survey.getSurveyItemTypeCd()));
				survey.setSurveyType(getCodeName(survey.getSurveyTypeCd()));

				List<SurveyExampleDTO> examples = new ArrayList<SurveyExampleDTO>();
				for (UIUnivSurveyExampleRS example : surveyExampleRS.getListSurveyExample()) {
					SurveyExampleDTO exDto = new SurveyExampleDTO();
					BeanUtils.copyProperties(exDto, example.getUnivSurveyExample());
					examples.add(exDto);
				}
				survey.setExamples(examples);
				items.add(survey);
			}

		}

		mav.addObject("items", items);
		mav.addObject("courseActiveSeq", Long.parseLong(req.getParameter("courseActiveSeq")));
		mav.addObject("courseApplySeq", Long.parseLong(req.getParameter("courseApplySeq")));
		mav.addObject("courseActiveSurveySeq", courseActiveSurveySeq);

		mav.addObject("item", dto);

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");

		return mav;

	}

	/**
	 * 설문 응답
	 * 
	 * @param req
	 * @param res
	 * @param courseActive
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/classroom/surveypaper/insert")
	public ModelAndView insertsurvey(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;
		checkSession(req);
		Gson gson = new Gson();

		CourseActiveSurveyPaperAnswerDTO result = new CourseActiveSurveyPaperAnswerDTO();
		UIUnivCourseActiveSurveyPaperAnswerVO vo = new UIUnivCourseActiveSurveyPaperAnswerVO();
		try {
			String surveyResult = HttpUtil.getParameter(req, "surveyResult");
			surveyResult = URLDecoder.decode(surveyResult, "UTF-8");
			
			result = gson.fromJson(surveyResult, CourseActiveSurveyPaperAnswerDTO.class);
			
			vo.setCourseActiveSurveySeq(Long.parseLong(req.getParameter("courseActiveSurveySeq")));
			vo.setCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
			vo.setSurveyPaperSeq(Long.parseLong(req.getParameter("surveyPaperSeq")));
			vo.setCourseApplySeq(Long.parseLong(req.getParameter("courseApplySeq")));
		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
		}

		requiredSession(req, vo);

		Long courseActiveSurveySeq = Long.parseLong(req.getParameter("courseActiveSurveySeq"));

		UIUnivCourseActiveSurveyRS detail = (UIUnivCourseActiveSurveyRS)courseActiveSurveyService.getDetail(courseActiveSurveySeq);

		if (detail == null) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}

		// 이미등록됨
		if (courseActiveSurveyPaperAnswerService.countOverSurveyAnswer(vo) > 0) {
			//throw new ApiServiceExcepion(UIApiConstant._DATA_EXIST, getErorrMessage(UIApiConstant._DATA_EXIST));
			//과부화 테스트를 위한 설문등록전 삭제로직
			uiCourseActiveSurveyPaperAnswerService.delete(vo);
		}

		List<UnivCourseActiveSurveyAnswerVO> voList = new ArrayList<UnivCourseActiveSurveyAnswerVO>();

		if (result != null && result.getListItemAnswer() != null) {
			for (CourseActiveSurveyPaperAnswerItemDTO itemDto : result.getListItemAnswer()) {
				UIUnivCourseActiveSurveyAnswerVO o = new UIUnivCourseActiveSurveyAnswerVO();
				o.copyAudit(vo);
				o.setSurveySeq(itemDto.getSurveySeq());
				o.setMemberSeq(vo.getRegMemberSeq());
				o.setEssayAnswer(itemDto.getEssayAnswer());
				o.setSurveyItemTypeCd(itemDto.getSurveyItemTypeCd());
				o.setSurveyAnswer1Yn("N");
				o.setSurveyAnswer2Yn("N");
				o.setSurveyAnswer3Yn("N");
				o.setSurveyAnswer4Yn("N");
				o.setSurveyAnswer5Yn("N");
				o.setSurveyAnswer6Yn("N");
				o.setSurveyAnswer7Yn("N");
				o.setSurveyAnswer8Yn("N");
				o.setSurveyAnswer9Yn("N");
				o.setSurveyAnswer10Yn("N");
				o.setSurveyAnswer11Yn("N");
				o.setSurveyAnswer12Yn("N");
				o.setSurveyAnswer13Yn("N");
				o.setSurveyAnswer14Yn("N");
				o.setSurveyAnswer15Yn("N");
				o.setSurveyAnswer16Yn("N");
				o.setSurveyAnswer17Yn("N");
				o.setSurveyAnswer18Yn("N");
				o.setSurveyAnswer19Yn("N");
				o.setSurveyAnswer20Yn("N");
				
				if (itemDto.getSurveyAnswer() != null) {
					if ("1".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer1Yn("Y");
					}
					if ("2".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer2Yn("Y");
					}
					if ("3".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer3Yn("Y");
					}
					if ("4".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer4Yn("Y");
					}
					if ("5".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer5Yn("Y");
					}
					if ("6".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer6Yn("Y");
					}
					if ("7".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer7Yn("Y");
					}
					if ("8".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer8Yn("Y");
					}
					if ("9".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer9Yn("Y");
					}
					if ("10".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer10Yn("Y");
					}
					if ("11".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer11Yn("Y");
					}
					if ("12".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer12Yn("Y");
					}
					if ("13".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer13Yn("Y");
					}
					if ("14".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer14Yn("Y");
					}
					if ("15".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer15Yn("Y");
					}
					if ("16".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer16Yn("Y");
					}
					if ("17".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer17Yn("Y");
					}
					if ("18".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer18Yn("Y");
					}
					if ("19".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer19Yn("Y");
					}
					if ("20".equals(itemDto.getSurveyAnswer())) {
						o.setSurveyAnswer20Yn("Y");
					}
				}
				voList.add(o);

			}

		}
		if (voList.size() > 0) {
			mav.addObject("result", courseActiveSurveyPaperAnswerService.insertSurveyAnswer(vo, voList));
		} else {
			mav.addObject("result", 0);
		}
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");

		return mav;

	}
}
