/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.api;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;
import com._4csoft.aof.ui.univ.dto.ExamDTO;
import com._4csoft.aof.ui.univ.dto.ExamExampleDTO;
import com._4csoft.aof.ui.univ.dto.ExamListDTO;
import com._4csoft.aof.ui.univ.dto.courseQuizAnswerDTO;
import com._4csoft.aof.ui.univ.dto.courseQuizAnswerDetailDTO;
import com._4csoft.aof.ui.univ.dto.courseQuizShortAnswerDetailDTO;
import com._4csoft.aof.ui.univ.service.UIUnivCourseQuizAnswerService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseExamVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseQuizAnswerVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseExamCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseQuizAnswerCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseExamExampleRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseExamItemRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseExamRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseQuizAnswerRS;
import com._4csoft.aof.univ.mapper.UnivCourseExamExampleMapper;
import com._4csoft.aof.univ.service.UnivCourseExamItemService;
import com._4csoft.aof.univ.service.UnivCourseExamService;

/**
 * @Project : lgaca-api
 * @Package : com._4csoft.aof.ui.univ.api
 * @File : UICourseExamController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 27.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICourseExamController extends UIBaseController {

	@Resource (name = "UnivCourseExamService")
	private UnivCourseExamService courseExamService;

	@Resource (name = "UnivCourseExamItemService")
	private UnivCourseExamItemService courseExamItemService;

	@Resource (name = "UIUnivCourseQuizAnswerService")
	private UIUnivCourseQuizAnswerService courseQuizAnswerService;

	@Resource (name = "UnivCourseExamExampleMapper")
	private UnivCourseExamExampleMapper courseExamExampleMapper;

	/**
	 * 시험문제 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/exam/list")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		checkSession(req);
		String resultCode = UIApiConstant._SUCCESS_CODE;
		UIUnivCourseExamCondition condition = new UIUnivCourseExamCondition();
		try {
			condition.setSrchCourseMasterSeq(Long.parseLong(req.getParameter("courseMasterSeq")));
			condition.setSrchUseYn("Y");

			condition.setSrchKey(HttpUtil.getParameter(req, "srchKey"));
			condition.setSrchWord(HttpUtil.getParameter(req, "srchWord"));

		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
		}

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		Paginate<ResultSet> paginate = courseExamService.getList(condition);

		List<ExamListDTO> items = new ArrayList<ExamListDTO>();
		int totalRowCount = 0;
		if (paginate != null && paginate.getItemList() != null && paginate.getItemList().size() > 0) {
			totalRowCount = paginate.getTotalCount();

			for (ResultSet rs : paginate.getItemList()) {
				UIUnivCourseExamRS courseExamRS = (UIUnivCourseExamRS)rs;

				ExamListDTO dto = new ExamListDTO();

				BeanUtils.copyProperties(dto, courseExamRS.getCourseExamItem());

				dto.setExamSeq(courseExamRS.getCourseExam().getExamSeq());
				dto.setCourseMasterSeq(courseExamRS.getCourseExam().getCourseMasterSeq());

				if (StringUtil.isNotEmpty(dto.getExamItemDifficultyCd())) {
					dto.setExamItemDifficulty(getCodeName(dto.getExamItemDifficultyCd()));
				}

				if (StringUtil.isNotEmpty(dto.getExamItemTypeCd())) {
					dto.setExamItemType(getCodeName(dto.getExamItemTypeCd()));
				}

				// 문항 추가 시작
				List<ResultSet> exampleRSList = courseExamExampleMapper.getList(courseExamRS.getCourseExamItem().getExamItemSeq());

				List<ExamExampleDTO> lisExamExample = new ArrayList<ExamExampleDTO>();
				for (ResultSet exampleRS : exampleRSList) {

					UIUnivCourseExamExampleRS courseExamExampleRS = (UIUnivCourseExamExampleRS)exampleRS;
					ExamExampleDTO examDto = new ExamExampleDTO();

					BeanUtils.copyProperties(examDto, courseExamExampleRS.getCourseExamExample());
					lisExamExample.add(examDto);
				}

				dto.setLisExamExample(lisExamExample);
				// 문항 추가 종료

				items.add(dto);
			}

		}

		mav.addObject("items", items);
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.addObject("totalRowCount", totalRowCount);
		mav.addObject("currentPage", condition.getCurrentPage());
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 시험문제 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/exam/{examSeq}/detail")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, @PathVariable ("examSeq") Long examSeq) throws Exception {
		ModelAndView mav = new ModelAndView();
		UIUnivCourseExamVO courseExam = new UIUnivCourseExamVO();

		checkSession(req);
		String resultCode = UIApiConstant._SUCCESS_CODE;

		try {
			courseExam.setExamSeq(examSeq);
		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
		}

		checkSession(req);

		ResultSet rs = courseExamService.getDetail(courseExam);

		ExamDTO item = new ExamDTO();
		List<ExamExampleDTO> lisExamExample = new ArrayList<ExamExampleDTO>();
		if (rs != null) {
			UIUnivCourseExamRS courseExamRS = (UIUnivCourseExamRS)rs;

			if (courseExamRS.getListCourseExamItem() != null && courseExamRS.getListCourseExamItem().size() > 0) {
				for (ResultSet listrs : courseExamRS.getListCourseExamItem()) {

					UIUnivCourseExamItemRS itemRs = (UIUnivCourseExamItemRS)listrs;

					BeanUtils.copyProperties(item, itemRs.getCourseExamItem());

					if (itemRs.getListCourseExamExample() != null && itemRs.getListCourseExamExample().size() > 0) {
						for (ResultSet exampleRS : itemRs.getListCourseExamExample()) {
							UIUnivCourseExamExampleRS courseExamExampleRS = (UIUnivCourseExamExampleRS)exampleRS;
							ExamExampleDTO dto = new ExamExampleDTO();

							BeanUtils.copyProperties(dto, courseExamExampleRS.getCourseExamExample());
							lisExamExample.add(dto);
						}
					}

				}
			}
			item.setExamSeq(courseExamRS.getCourseExam().getExamSeq());
			item.setCourseMasterSeq(courseExamRS.getCourseExam().getCourseMasterSeq());

			if (StringUtil.isNotEmpty(item.getExamItemDifficultyCd())) {
				item.setExamItemDifficulty(getCodeName(item.getExamItemDifficultyCd()));
			}

			if (StringUtil.isNotEmpty(item.getExamItemTypeCd())) {
				item.setExamItemType(getCodeName(item.getExamItemTypeCd()));
			}
			if (StringUtil.isNotEmpty(item.getExamItemAlignCd())) {
				item.setExamItemAlign(getCodeName(item.getExamItemAlignCd()));
			}

		}

		item.setLisExamExample(lisExamExample);

		mav.addObject("item", item);
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 시험문제 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/exam/answer/insert")
	public ModelAndView insertAnsert(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		UIUnivCourseQuizAnswerVO univCourseQuizAnswerVO = new UIUnivCourseQuizAnswerVO();
		checkSession(req);
		String resultCode = UIApiConstant._SUCCESS_CODE;

		requiredSession(req, univCourseQuizAnswerVO);
		try {
			univCourseQuizAnswerVO.setCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
			univCourseQuizAnswerVO.setCourseApplySeq(Long.parseLong(req.getParameter("courseApplySeq")));
			univCourseQuizAnswerVO.setMemberSeq(univCourseQuizAnswerVO.getRegMemberSeq());
			univCourseQuizAnswerVO.setExamItemSeq(Long.parseLong(req.getParameter("examItemSeq")));
			univCourseQuizAnswerVO.setShortAnswer(HttpUtil.getParameter(req, "shortAnswer"));
			univCourseQuizAnswerVO.setQuizDtime(HttpUtil.getParameter(req, "quizDtime"));
			univCourseQuizAnswerVO.setCourseActiveProfSeq(Long.parseLong(req.getParameter("courseActiveProfSeq")));
			if (StringUtil.isEmpty(univCourseQuizAnswerVO.getShortAnswer())) {
				univCourseQuizAnswerVO.setExamExampleSeq((Long.parseLong(req.getParameter("examExampleSeq"))));
			}
		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}

		if (StringUtil.isEmpty(univCourseQuizAnswerVO.getQuizDtime())) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}
		univCourseQuizAnswerVO.setClassificationCode(HttpUtil.getParameter(req, "classificationCode"));
		courseQuizAnswerService.insertCourseQuizAnswer(univCourseQuizAnswerVO);

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;

	}
	
	
	/**
	 * 퀴즈 결과 목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/quiz/answer/list.do")
	public ModelAndView answerList(HttpServletRequest req, HttpServletResponse res, UIUnivCourseQuizAnswerCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		String resultCode = UIApiConstant._SUCCESS_CODE;
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		Long courseActiveSeq = HttpUtil.getParameter(req, "courseActiveSeq", 0L);
		Long memberSeq = HttpUtil.getParameter(req, "memberSeq", 0L);
		condition.setSrchCourseActiveSeq(courseActiveSeq);
		if(memberSeq > 0){
			condition.setSrchMemberSeq(memberSeq);
		}
		 
		Paginate<ResultSet> paginate =  courseQuizAnswerService.getListQuiz(condition);
		List<courseQuizAnswerDTO> item = new ArrayList<courseQuizAnswerDTO>();
		int totalRowCount = 0;
		if (paginate != null && paginate.getItemList() != null && paginate.getItemList().size() > 0) {
			totalRowCount = paginate.getTotalCount();
			for (ResultSet rs : paginate.getItemList()) {
				UIUnivCourseQuizAnswerRS courseQuizAnswerRS = (UIUnivCourseQuizAnswerRS) rs;
				courseQuizAnswerDTO dto = new courseQuizAnswerDTO();
				dto.setExamItemSeq(courseQuizAnswerRS.getCourseQuizAnswer().getExamItemSeq());
				dto.setExamItemTitle(courseQuizAnswerRS.getCourseExamItem().getExamItemTitle());
				dto.setExamItemTypeCd(courseQuizAnswerRS.getCourseExamItem().getExamItemTypeCd());
				dto.setCourseActiveProfSeq(courseQuizAnswerRS.getCourseQuizAnswer().getCourseActiveProfSeq());
				dto.setMemberName(courseQuizAnswerRS.getMember().getMemberName());
				dto.setCourseActiveSeq(courseQuizAnswerRS.getCourseQuizAnswer().getCourseActiveSeq());
				dto.setQuizDtime(courseQuizAnswerRS.getCourseQuizAnswer().getQuizDtime());
				dto.setClassificationCode(courseQuizAnswerRS.getCourseQuizAnswer().getClassificationCode());
				item.add(dto);
			}
		}
		
		mav.addObject("items", item);
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.addObject("totalRowCount", totalRowCount);
		mav.addObject("currentPage", condition.getCurrentPage());
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	
	
	/**
	 * 퀴즈 결과 디테일
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/quiz/answer/detail.do")
	public ModelAndView answerDetail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseQuizAnswerVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		String resultCode = UIApiConstant._SUCCESS_CODE;
		
		Long courseActiveSeq = HttpUtil.getParameter(req, "courseActiveSeq", 0L);
		Long examItemSeq = HttpUtil.getParameter(req, "examItemSeq", 0L);
		Long courseActiveProfSeq = HttpUtil.getParameter(req, "courseActiveProfSeq", 0L);
		
		vo.setCourseActiveSeq(courseActiveSeq);
		vo.setExamItemSeq(examItemSeq);
		vo.setCourseActiveProfSeq(courseActiveProfSeq);
		
		List<ResultSet> quizAnswerList = courseQuizAnswerService.getListQuizAnswer(vo);
		List<courseQuizAnswerDetailDTO> item = new ArrayList<courseQuizAnswerDetailDTO>();
		if (quizAnswerList != null) {
			for (int i=0; i < quizAnswerList.size(); i++) {
				UIUnivCourseQuizAnswerRS rs = (UIUnivCourseQuizAnswerRS) quizAnswerList.get(i);
				courseQuizAnswerDetailDTO dto = new courseQuizAnswerDetailDTO();
				dto.setExamItemSeq(rs.getCourseExamItem().getExamItemSeq());
				dto.setExamSeq(rs.getCourseExamItem().getExamSeq());
				dto.setExamExampleSeq(rs.getCourseExamExample().getExamExampleSeq());
				dto.setSortOrder(rs.getCourseExamExample().getSortOrder());
				dto.setExamItemExampleTitle(rs.getCourseExamExample().getExamItemExampleTitle());
				dto.setAnswerCount(rs.getCourseQuizAnswer().getAnswerCount());
				dto.setMemberCount(rs.getCourseQuizAnswer().getMemberCount());
				
				item.add(dto);
			}
		}
		
		mav.addObject("items", item);
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	
	/**
	 * 퀴즈 결과 디테일(주관식)
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/quiz/shortAnswer/detail.do")
	public ModelAndView shortAnswerDetail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseQuizAnswerVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		requiredSession(req);
		String resultCode = UIApiConstant._SUCCESS_CODE;
		
		Long courseActiveSeq = HttpUtil.getParameter(req, "courseActiveSeq", 0L);
		Long examItemSeq = HttpUtil.getParameter(req, "examItemSeq", 0L);
		Long courseActiveProfSeq = HttpUtil.getParameter(req, "courseActiveProfSeq", 0L);
		
		vo.setCourseActiveSeq(courseActiveSeq);
		vo.setExamItemSeq(examItemSeq);
		vo.setCourseActiveProfSeq(courseActiveProfSeq);
		
		List<ResultSet> quizAnswerList = courseQuizAnswerService.getListQuizShortAnswer(vo);
		List<courseQuizShortAnswerDetailDTO> item = new ArrayList<courseQuizShortAnswerDetailDTO>();
		if (quizAnswerList != null) {
			for (int i=0; i < quizAnswerList.size(); i++) {
				UIUnivCourseQuizAnswerRS rs = (UIUnivCourseQuizAnswerRS) quizAnswerList.get(i);
				courseQuizShortAnswerDetailDTO dto = new courseQuizShortAnswerDetailDTO();
				dto.setMemberSeq(rs.getMember().getMemberSeq());
				dto.setMemberName(rs.getMember().getMemberName());
				dto.setShortAnswer(rs.getCourseQuizAnswer().getShortAnswer());
				item.add(dto);
			}
		}
		
		mav.addObject("items", item);
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		
		return mav;
	}
}
