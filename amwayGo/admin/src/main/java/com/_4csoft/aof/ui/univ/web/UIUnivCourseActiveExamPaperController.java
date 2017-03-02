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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperTargetVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveExamPaperTargetCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveExamPaperRS;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseActiveExamPaperService;
import com._4csoft.aof.univ.service.UnivCourseActiveExamPaperTargetService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkService;
import com._4csoft.aof.univ.vo.UnivCourseActiveExamPaperTargetVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveExamPaperVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveExamPaperController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 7.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */

@Controller
public class UIUnivCourseActiveExamPaperController extends BaseController {

	@Resource (name = "UnivCourseActiveExamPaperService")
	private UnivCourseActiveExamPaperService courseActiveExamPaperService;

	@Resource (name = "UnivCourseActiveExamPaperTargetService")
	private UnivCourseActiveExamPaperTargetService courseActiveExamPaperTargetService;

	@Resource (name = "UnivCourseHomeworkService")
	private UnivCourseHomeworkService courseHomeworkService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService courseActiveElementService;

	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService univCourseActiveEvaluateService;

	/**
	 * 개설과목 시험지 목록
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/exampaper/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("examType") String examType,
			UIUnivCourseActiveExamPaperVO courseActiveExamPaper, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();
		homework.copyShortcut();
		homework.setReplaceYn("Y");

		if ("middle".equals(examType)) {
			/** TODO : 코드 */
			courseActiveExamPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::MIDDLE");
			homework.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::MIDDLE");
		} else if ("final".equals(examType)) {
			/** TODO : 코드 */
			courseActiveExamPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::FINAL");
			homework.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::FINAL");
		}

		// 삭제시 사용할 주차맵핑정보 가져온다
		UIUnivCourseActiveElementVO elementVO = new UIUnivCourseActiveElementVO();
		elementVO.setCourseActiveSeq(courseActiveExamPaper.getCourseActiveSeq());
		elementVO.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		if ("middle".equals(examType)) {
			elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::MIDEXAM");
		} else {
			elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::FINALEXAM");
		}

		mav.addObject("elementList", courseActiveElementService.getList(elementVO));

		mav.addObject("examPaperList", courseActiveExamPaperService.getList(courseActiveExamPaper));
		mav.addObject("homeworkList", courseHomeworkService.getListHomework(homework));
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.addObject("examType", examType);

		// 평가비율
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(courseActiveExamPaper.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		mav.setViewName("/univ/courseActiveElement/examPaper/listCourseActiveExamPaper");

		return mav;
	}

	/**
	 * 개설과목 시험지 상세보기
	 * 
	 * @param req
	 * @param res
	 * @param examType
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/exampaper/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, @PathVariable ("examType") String examType,
			UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		UIUnivCourseActiveExamPaperRS rs = (UIUnivCourseActiveExamPaperRS)courseActiveExamPaperService.getDetail(courseActiveExamPaper);

		// 주차맵핑정보
		if (StringUtil.isNotEmpty(rs.getCourseActiveExamPaper().getBasicSupplementCd())
				&& "BASIC_SUPPLEMENT::BASIC".equals(rs.getCourseActiveExamPaper().getBasicSupplementCd())) {

			UIUnivCourseActiveElementVO elementVO = new UIUnivCourseActiveElementVO();
			elementVO.setCourseActiveSeq(rs.getCourseActiveExamPaper().getCourseActiveSeq());
			elementVO.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
			if ("middle".equals(examType)) {
				elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::MIDEXAM");
			} else {
				elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::FINALEXAM");
			}

			mav.addObject("elementList", courseActiveElementService.getList(elementVO));
		}

		mav.addObject("detail", rs);
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.addObject("examType", examType);
		mav.setViewName("/univ/courseActiveElement/examPaper/detailCourseActiveExamPaper");

		return mav;
	}

	/**
	 * 개설과목 시험지 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param examType
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/exampaper/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, @PathVariable ("examType") String examType,
			UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		UIUnivCourseActiveExamPaperRS rs = (UIUnivCourseActiveExamPaperRS)courseActiveExamPaperService.getDetail(courseActiveExamPaper);

		// 주차맵핑정보
		if (StringUtil.isNotEmpty(rs.getCourseActiveExamPaper().getBasicSupplementCd())
				&& "BASIC_SUPPLEMENT::BASIC".equals(rs.getCourseActiveExamPaper().getBasicSupplementCd())) {

			UIUnivCourseActiveElementVO elementVO = new UIUnivCourseActiveElementVO();
			elementVO.setCourseActiveSeq(rs.getCourseActiveExamPaper().getCourseActiveSeq());
			elementVO.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
			if ("middle".equals(examType)) {
				elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::MIDEXAM");
			} else {
				elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::FINALEXAM");
			}

			mav.addObject("elementList", courseActiveElementService.getList(elementVO));
		}

		mav.addObject("detail", rs);
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.addObject("targetCount", courseActiveExamPaperService.getMemberCountFromSummary(courseActiveExamPaper.getCourseActiveSeq()));
		mav.addObject("examType", examType);
		mav.setViewName("/univ/courseActiveElement/examPaper/editCourseActiveExamPaper");

		return mav;
	}

	/**
	 * 개설과목 시험지 등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param examType
	 * @param courseActiveExamPaper
	 * @param courseActive
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/exampaper/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, @PathVariable ("examType") String examType,
			UIUnivCourseActiveExamPaperVO courseActiveExamPaper, UIUnivCourseActiveVO courseActive) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		// 보충일 경우 미제출자를 가져오고 일반일 경우 주차맵핑정보를 가져온다
		if (StringUtil.isNotEmpty(courseActiveExamPaper.getBasicSupplementCd())
				&& "BASIC_SUPPLEMENT::SUPPLEMENT".equals(courseActiveExamPaper.getBasicSupplementCd())) {
			UIUnivCourseActiveExamPaperVO examPaper = new UIUnivCourseActiveExamPaperVO();
			examPaper.setReferenceSeq(courseActiveExamPaper.getReferenceSeq());
			examPaper.setCourseActiveSeq(courseActiveExamPaper.getCourseActiveSeq());
			examPaper.setLimitScore(0L);

			mav.addObject("nonSubmitCount", courseActiveExamPaperTargetService.countByScoreTargetExamPaperTarget(examPaper));
		} else {
			UIUnivCourseActiveElementVO elementVO = new UIUnivCourseActiveElementVO();
			elementVO.setCourseActiveSeq(courseActive.getCourseActiveSeq());
			elementVO.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
			if ("middle".equals(examType)) {
				elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::MIDEXAM");
			} else {
				elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::FINALEXAM");
			}

			mav.addObject("elementList", courseActiveElementService.getList(elementVO));
		}

		// 현재 개설과목의 수강생 수
		mav.addObject("applyCount", courseActiveExamPaperService.getMemberCountFromSummary(courseActive.getCourseActiveSeq()));
		// 개설과목 상세 조회 - masterSeq
		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.addObject("examType", examType);
		mav.setViewName("/univ/courseActiveElement/examPaper/createCourseActiveExamPaper");

		return mav;
	}

	/**
	 * 개설과목 시험지 등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/exampaper/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);
		emptyValue(courseActiveExamPaper, "limitScore=0");

		courseActiveExamPaperService.insert(courseActiveExamPaper);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 시험지 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/exampaper/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		courseActiveExamPaperService.update(courseActiveExamPaper);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 시험지 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/exampaper/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		courseActiveExamPaperService.delete(courseActiveExamPaper);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 다중삭제 - 현재는 하나씩 밖에 지워지지 않음 시험이 한개가 아닐 시 프로세스 변경 필요
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		courseActiveExamPaperService.delete(courseActiveExamPaper);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 보충 시험에 XX점 이하 대상자 가져오면서 데이터 다시 인서트 한다. 수정화면에서 사용됩니다.
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/target/score/updatecount.do")
	public ModelAndView updateCountTarget(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		mav.addObject("result", courseActiveExamPaperTargetService.updateCountByScoreTarget(courseActiveExamPaper));
		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 보충 시험에 XX점 이하 대상자수 가져올때 사용된다.
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/exampaper/target/score/count.do")
	public ModelAndView countTarget(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.addObject("result", courseActiveExamPaperTargetService.countByScoreTargetExamPaperTarget(courseActiveExamPaper));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 대상자 팝업
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/target/popup.do")
	public ModelAndView editHomeworkTargetMember(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperTargetCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 비 대상자
		mav.addObject("listNonTarget", courseActiveExamPaperTargetService.getListNonTarget(condition));
		// 대상자
		mav.addObject("listTarget", courseActiveExamPaperTargetService.getListTarget(condition));
		mav.addObject("condition", condition);
		mav.setViewName("/univ/courseActiveElement/examPaper/editCourseActiveExamPaperTargetPopup");

		return mav;
	}

	/**
	 * 비대상자 대상자로 다중 등록
	 * 
	 * @param req
	 * @param res
	 * @param target
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/target/insertlist.do")
	public ModelAndView insertlistTarget(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperTargetVO target) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, target);

		List<UnivCourseActiveExamPaperTargetVO> attendList = new ArrayList<UnivCourseActiveExamPaperTargetVO>();

		for (int index = 0; index < target.getNonTargetApplyCheckkeys().length; index++) {
			UnivCourseActiveExamPaperTargetVO o = new UnivCourseActiveExamPaperTargetVO();
			o.setCourseActiveExamPaperSeq(target.getCourseActiveExamPaperSeq());
			o.setCourseApplySeq(target.getNonTargetApplyCheckkeys()[index]);
			o.copyAudit(target);
			attendList.add(o);
		}

		if (attendList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseActiveExamPaperTargetService.insertList(attendList));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 대상자를 비대상자로 다중 수정
	 * 
	 * @param req
	 * @param res
	 * @param target
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/target/deletelist.do")
	public ModelAndView deletelistTarget(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperTargetVO target) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, target);

		List<UnivCourseActiveExamPaperTargetVO> attendList = new ArrayList<UnivCourseActiveExamPaperTargetVO>();

		for (int index = 0; index < target.getTargetApplyCheckkeys().length; index++) {
			UnivCourseActiveExamPaperTargetVO o = new UnivCourseActiveExamPaperTargetVO();
			o.setCourseActiveExamPaperSeq(target.getCourseActiveExamPaperSeq());
			o.setCourseApplySeq(target.getTargetApplyCheckkeys()[index]);
			o.copyAudit(target);
			attendList.add(o);
		}

		if (attendList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseActiveExamPaperTargetService.deleteList(attendList));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 비학위 개설과목 시험 목록
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/list.do")
	public ModelAndView listNonDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		/** TODO : 코드 */
		courseActiveExamPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::EXAM");

		mav.addObject("examList", courseActiveExamPaperService.getList(courseActiveExamPaper));
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.setViewName("/univ/courseActiveElement/examPaper/nonDegree/listCourseActiveExamPaper");

		// 평가비율
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(courseActiveExamPaper.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		return mav;
	}

	/**
	 * 비학위 개설과목 시험 상세보기
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/detail.do")
	public ModelAndView detailNonDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		UIUnivCourseActiveExamPaperRS rs = (UIUnivCourseActiveExamPaperRS)courseActiveExamPaperService.getDetail(courseActiveExamPaper);

		mav.addObject("detail", rs);
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.setViewName("/univ/courseActiveElement/examPaper/nonDegree/detailCourseActiveExamPaper");

		return mav;
	}

	/**
	 * 비학위 개설과목 시험 수정화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/edit.do")
	public ModelAndView editNonDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper,
			UIUnivCourseActiveVO courseActive) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		UIUnivCourseActiveExamPaperRS rs = (UIUnivCourseActiveExamPaperRS)courseActiveExamPaperService.getDetail(courseActiveExamPaper);

		mav.addObject("detail", rs);
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));
		mav.setViewName("/univ/courseActiveElement/examPaper/nonDegree/editCourseActiveExamPaper");

		return mav;
	}

	/**
	 * 비학위 개설과목 시험 등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @param courseActive
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/create.do")
	public ModelAndView createNonDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper,
			UIUnivCourseActiveVO courseActive) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		courseActiveExamPaper.copyShortcut();

		// 개설과목 상세 조회 - masterSeq
		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));
		mav.addObject("courseActiveExamPaper", courseActiveExamPaper);
		mav.setViewName("/univ/courseActiveElement/examPaper/nonDegree/createCourseActiveExamPaper");

		return mav;
	}

	/**
	 * 비학위 개설과목 시험 등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/insert.do")
	public ModelAndView insertNonDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		courseActiveExamPaperService.insertQuiz(courseActiveExamPaper, "EXAM");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 비학위 개설과목 시험 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/update.do")
	public ModelAndView updateNonDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		courseActiveExamPaperService.updateQuiz(courseActiveExamPaper, "EXAM");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 비학위 개설과목 시험 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/delete.do")
	public ModelAndView deleteNonDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		courseActiveExamPaperService.deleteQuiz(courseActiveExamPaper, "EXAM");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 비학위 개설과목 시험 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/deletelist.do")
	public ModelAndView deleteListNonDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		List<UnivCourseActiveExamPaperVO> voList = new ArrayList<UnivCourseActiveExamPaperVO>();
		for (String index : courseActiveExamPaper.getCheckkeys()) {
			UnivCourseActiveExamPaperVO o = new UnivCourseActiveExamPaperVO();
			o.setCourseActiveExamPaperSeq(courseActiveExamPaper.getCourseActiveExamPaperSeqs()[Integer.parseInt(index)]);
			o.setExamPaperSeq(courseActiveExamPaper.getExamPaperSeqs()[Integer.parseInt(index)]);
			o.setCourseActiveSeq(courseActiveExamPaper.getCourseActiveSeq());
			o.copyAudit(courseActiveExamPaper);

			voList.add(o);
		}

		if (voList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseActiveExamPaperService.deletelistQuiz(voList, "EXAM"));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 비학위 개설과목 시험 비율 수정
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveExamPaper
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/exampaper/rate/update.do")
	public ModelAndView updaterate(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveExamPaperVO courseActiveExamPaper) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveExamPaper);

		List<UnivCourseActiveExamPaperVO> voList = new ArrayList<UnivCourseActiveExamPaperVO>();

		for (int index = 0; index < courseActiveExamPaper.getCourseActiveExamPaperSeqs().length; index++) {
			UnivCourseActiveExamPaperVO o = new UnivCourseActiveExamPaperVO();
			o.setCourseActiveExamPaperSeq(courseActiveExamPaper.getCourseActiveExamPaperSeqs()[index]);
			o.setCourseActiveSeq(courseActiveExamPaper.getCourseActiveSeq());
			o.setMiddleFinalTypeCd(courseActiveExamPaper.getMiddleFinalTypeCds()[index]);
			o.setRate(courseActiveExamPaper.getRates()[index]);
			o.copyAudit(courseActiveExamPaper);
			voList.add(o);
		}

		if (voList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseActiveExamPaperService.updateRate(voList));
		}

		mav.setViewName("/common/save");
		return mav;
	}
}
