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
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkTargetVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkTemplateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseHomeworkCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveElementRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseHomeworkRS;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseActiveExamPaperTargetService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkTargetService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkTemplateService;
import com._4csoft.aof.univ.vo.UnivCourseActiveElementVO;
import com._4csoft.aof.univ.vo.UnivCourseHomeworkTargetVO;
import com._4csoft.aof.univ.vo.UnivCourseHomeworkVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseHomeworkController.java
 * @Title : 과제 템플릿 컨트롤러
 * @date : 2014. 2. 20.
 * @author : 김현우
 * @descrption : 과제 템플릿 컨트롤러
 */
@Controller
public class UIUnivCourseHomeworkController extends BaseController {

	@Resource (name = "UnivCourseHomeworkService")
	private UnivCourseHomeworkService courseHomeworkService;

	@Resource (name = "UnivCourseHomeworkTargetService")
	private UnivCourseHomeworkTargetService courseHomeworkTargetService;

	@Resource (name = "UnivCourseActiveExamPaperTargetService")
	private UnivCourseActiveExamPaperTargetService courseActiveExamPaperTargetService;

	@Resource (name = "UnivCourseHomeworkTemplateService")
	private UnivCourseHomeworkTemplateService courseHomeworkTemplateService;

	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService courseActiveElementService;

	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService univCourseActiveEvaluateService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	/**
	 * 과제 템플릿 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		homework.copyShortcut();

		mav.addObject("itemList", courseHomeworkService.getListHomework(homework));
		mav.addObject("homework", homework);

		// 평가비율
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(homework.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		mav.setViewName("/univ/courseActiveElement/homework/listHomework");
		return mav;
	}

	/**
	 * 과제 등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseHomework
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework, UIUnivCourseActiveVO courseActive,
			UIUnivCourseHomeworkTemplateVO template) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		homework.copyShortcut();

		// 현재 해당 개설과목의 수강생이 몇명인지 카운트 해온다.
		mav.addObject("applyCount", courseHomeworkService.countByMemberCountHomework(homework.getCourseActiveSeq()));

		// 보충
		if (homework.getBasicSupplementCd().equals("BASIC_SUPPLEMENT::SUPPLEMENT")) {
			// 미제출자가 몇명인지 가져온다. 0점 처리된 사람도 미제출자와 동일하게 봄

			if ("EXAM".equals(homework.getReferenceType())) {
				UIUnivCourseActiveExamPaperVO examPaper = new UIUnivCourseActiveExamPaperVO();
				examPaper.setReferenceSeq(homework.getReferenceSeq());
				examPaper.setCourseActiveSeq(homework.getCourseActiveSeq());
				examPaper.setLimitScore(0L);
				mav.addObject("nonSubmitCount", courseActiveExamPaperTargetService.countByScoreTargetExamPaperTarget(examPaper));
			} else {
				homework.setLimitScore(0L);
				mav.addObject("nonSubmitCount", courseHomeworkTargetService.countByScoreTargetHomeworkTarget(homework));
			}
		}

		// 탬플릿
		if (StringUtil.isNotEmpty(template.getTemplateSeq())) {
			mav.addObject("homeworkTemplate", courseHomeworkTemplateService.getDetailCourseHomeworkTemplate(template));
		}

		// masterSeq 알아오기위해 조회
		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));
		mav.addObject("homework", homework);

		mav.setViewName("/univ/courseActiveElement/homework/createHomework");

		return mav;
	}

	/**
	 * 시험지 대체과제 및 대체보충과제 등록 화면 해당 URL에서 examType 값을 사용하기 위해 메소드 따로 지정함.
	 * 
	 * @param req
	 * @param res
	 * @param examType
	 * @param homework
	 * @param courseActive
	 * @param template
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/homework/create.do")
	public ModelAndView createExam(HttpServletRequest req, HttpServletResponse res, @PathVariable ("examType") String examType,
			UIUnivCourseHomeworkVO homework, UIUnivCourseActiveVO courseActive, UIUnivCourseHomeworkTemplateVO template) throws Exception {

		ModelAndView mav = this.create(req, res, homework, courseActive, template);

		if ("BASIC_SUPPLEMENT::BASIC".equals(homework.getBasicSupplementCd())) {
			UIUnivCourseActiveElementVO elementVO = new UIUnivCourseActiveElementVO();
			elementVO.setCourseActiveSeq(courseActive.getCourseActiveSeq());
			elementVO.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
			if ("middle".equals(examType)) {
				elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::MIDHOMEWORK");
			} else {
				elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::FINALHOMEWORK");
			}

			mav.addObject("elementList", courseActiveElementService.getList(elementVO));
		}

		mav.setViewName("/univ/courseActiveElement/homework/createExamHomework");
		mav.addObject("examType", examType);
		return mav;
	}

	/**
	 * 과제 템플릿 신규등록
	 * 
	 * @param req
	 * @param res
	 * @param univCourseHomework
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, homework);
		emptyValue(homework, "limitScore=0");

		courseHomeworkService.insertHomework(homework, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 과제 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param univCourseHomework
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivCourseHomeworkRS rs = (UIUnivCourseHomeworkRS)courseHomeworkService.getDetailHomework(homework);

		mav.addObject("detail", rs);
		mav.addObject("homework", homework);

		mav.setViewName("/univ/courseActiveElement/homework/detailHomework");
		return mav;
	}

	/**
	 * 시험지 대체과제 상세
	 * 
	 * @param req
	 * @param res
	 * @param examType
	 * @param homework
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/homework/detail.do")
	public ModelAndView detailExam(HttpServletRequest req, HttpServletResponse res, @PathVariable ("examType") String examType, UIUnivCourseHomeworkVO homework)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		homework.copyShortcut();

		UIUnivCourseHomeworkRS rs = (UIUnivCourseHomeworkRS)courseHomeworkService.getDetailHomework(homework);

		mav.addObject("detail", rs);
		mav.addObject("homework", homework);

		if ("BASIC_SUPPLEMENT::BASIC".equals(rs.getCourseHomework().getBasicSupplementCd())) {
			UIUnivCourseActiveElementVO elementVO = new UIUnivCourseActiveElementVO();
			elementVO.setCourseActiveSeq(homework.getCourseActiveSeq());
			elementVO.setReferenceSeq(rs.getCourseHomework().getHomeworkSeq());
			elementVO.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
			if ("middle".equals(examType)) {
				elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::MIDHOMEWORK");
			} else {
				elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::FINALHOMEWORK");
			}

			mav.addObject("elementList", courseActiveElementService.getList(elementVO));
		}

		mav.setViewName("/univ/courseActiveElement/homework/detailExamHomework");
		mav.addObject("examType", examType);
		return mav;
	}

	/**
	 * 과제 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param univCourseHomework
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework, UIUnivCourseActiveVO courseActive,
			UIUnivCourseHomeworkTemplateVO template) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", courseHomeworkService.getDetailHomework(homework));

		// 탬플릿
		if (StringUtil.isNotEmpty(template.getTemplateSeq())) {
			mav.addObject("homeworkTemplate", courseHomeworkTemplateService.getDetailCourseHomeworkTemplate(template));
		}

		// masterSeq 알아오기위해 조회
		mav.addObject("courseActive", courseActiveService.getDetailCourseActive(courseActive));

		// 현재 해당 개설과목의 수강생이 몇명인지 카운트 해온다.
		mav.addObject("targetCount", courseHomeworkService.countByMemberCountHomework(homework.getCourseActiveSeq()));
		mav.addObject("homework", homework);

		mav.setViewName("/univ/courseActiveElement/homework/editHomework");
		return mav;
	}

	/**
	 * 시험지 대체과제 수정
	 * 
	 * @param req
	 * @param res
	 * @param examType
	 * @param homework
	 * @param courseActive
	 * @param template
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/{examType}/homework/edit.do")
	public ModelAndView editExam(HttpServletRequest req, HttpServletResponse res, @PathVariable ("examType") String examType, UIUnivCourseHomeworkVO homework,
			UIUnivCourseActiveVO courseActive, UIUnivCourseHomeworkTemplateVO template) throws Exception {

		ModelAndView mav = this.edit(req, res, homework, courseActive, template);

		if ("BASIC_SUPPLEMENT::BASIC".equals(homework.getBasicSupplementCd())) {
			UIUnivCourseActiveElementVO elementVO = new UIUnivCourseActiveElementVO();
			elementVO.setCourseActiveSeq(courseActive.getCourseActiveSeq());
			elementVO.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
			if ("middle".equals(examType)) {
				elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::MIDHOMEWORK");
			} else {
				elementVO.setCourseWeekTypeCd("COURSE_WEEK_TYPE::FINALHOMEWORK");
			}

			mav.addObject("elementList", courseActiveElementService.getList(elementVO));
		}

		mav.setViewName("/univ/courseActiveElement/homework/editExamHomework");
		mav.addObject("examType", examType);
		return mav;
	}

	/**
	 * 과제 템플릿 수정
	 * 
	 * @param req
	 * @param res
	 * @param univCourseHomework
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO vo, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);
		vo.copyShortcut();

		courseHomeworkService.updateHomework(vo, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 과제 삭제
	 * 
	 * @param req
	 * @param res
	 * @param univCourseHomework
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		vo.copyShortcut();
		courseHomeworkService.deleteHomework(vo);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 과제 다중 삭제
	 * 
	 * @param req
	 * @param res
	 * @param univCourseHomework
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, homework);

		List<UnivCourseHomeworkVO> attendList = new ArrayList<UnivCourseHomeworkVO>();
		homework.copyShortcut();
		for (String index : homework.getCheckkeys()) {
			UnivCourseHomeworkVO o = new UnivCourseHomeworkVO();
			o.setHomeworkSeq(homework.getHomeworkSeqs()[Integer.parseInt(index)]);
			o.setCourseActiveSeq(homework.getCourseActiveSeq());
			o.setBasicSupplementCd(homework.getBasicSupplementCds()[Integer.parseInt(index)]);
			o.setReferenceSeq(homework.getReferenceSeqs()[Integer.parseInt(index)]);
			o.setReplaceYn("N");
			o.copyAudit(homework);
			attendList.add(o);
		}
		if (attendList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseHomeworkService.deletelistHomework(attendList));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 과제 평가비율 수정
	 * 
	 * @param req
	 * @param res
	 * @param homework
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/rate/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, homework);
		homework.copyShortcut();

		List<UnivCourseHomeworkVO> attendList = new ArrayList<UnivCourseHomeworkVO>();

		for (int index = 0; index < homework.getRateHomeworkSeqs().length; index++) {
			UnivCourseHomeworkVO o = new UnivCourseHomeworkVO();
			o.setCourseActiveSeq(homework.getCourseActiveSeq());
			o.setHomeworkSeq(homework.getRateHomeworkSeqs()[index]);
			o.setRate(homework.getRates()[index]);
			o.setSupplementSeq(homework.getSupplementSeqs()[index]);
			o.copyAudit(homework);
			attendList.add(o);
		}

		if (attendList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseHomeworkService.updatelistHomework(attendList));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 보충 과제에 대상자 수 가져오기
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/target/count.do")
	public ModelAndView count(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.addObject("result", courseHomeworkTargetService.countListHomeworkTarget(homework.getHomeworkSeq()));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 보충 과제에 XX점 이하 대상자수 가져올때 사용된다.
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/target/score/count.do")
	public ModelAndView countTarget(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.addObject("result", courseHomeworkTargetService.countByScoreTargetHomeworkTarget(homework));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 보충 과제에 XX점 이하 대상자 가져오면서 데이터 다시 인서트 한다. 수정화면에서 사용됩니다.
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/target/score/updatecount.do")
	public ModelAndView updateCountTarget(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, homework);
		mav.addObject("result", courseHomeworkTargetService.updateCountByScoreTargetHomeworkTarget(homework));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 대상자 팝업
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/target/popup.do")
	public ModelAndView editHomeworkTargetMember(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		if ("EXAM".equals(condition.getReferenceType())) { // 일반이 시험일때
			// 비 대상자
			mav.addObject("listNonTarget", courseHomeworkTargetService.getListNonTargetExam(condition));
			// 대상자
			mav.addObject("listTarget", courseHomeworkTargetService.getListTargetExam(condition));
		} else {
			// 비 대상자
			mav.addObject("listNonTarget", courseHomeworkTargetService.getListNonTarget(condition));
			// 대상자
			mav.addObject("listTarget", courseHomeworkTargetService.getListTarget(condition));
		}
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseActiveElement/homework/editHomeworkTargetPopup");
		return mav;
	}

	/**
	 * 보충 대상자 추가
	 * 
	 * @param req
	 * @param res
	 * @param target
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/target/insertlist.do")
	public ModelAndView insertlistTarget(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework, UIUnivCourseHomeworkTargetVO target)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, target);

		List<UnivCourseHomeworkTargetVO> attendList = new ArrayList<UnivCourseHomeworkTargetVO>();

		for (int index = 0; index < target.getNonTargetApplyCheckkeys().length; index++) {
			UnivCourseHomeworkTargetVO o = new UnivCourseHomeworkTargetVO();
			o.setHomeworkSeq(target.getHomeworkSeq());
			o.setCourseApplySeq(target.getNonTargetApplyCheckkeys()[index]);
			o.copyAudit(target);
			attendList.add(o);
		}

		if (attendList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			// 수강요소 정보 가져오기
			UnivCourseActiveElementVO element = new UnivCourseActiveElementVO();
			element.setCourseActiveSeq(homework.getCourseActiveSeq());
			element.setReferenceSeq(homework.getReferenceSeq());
			// TODO: 코드사용
			element.setReferenceTypeCd("COURSE_ELEMENT_TYPE::HOMEWORK");

			UIUnivCourseActiveElementRS result = (UIUnivCourseActiveElementRS)courseActiveElementService.getDetailElementType(element);

			mav.addObject("result", courseHomeworkTargetService.insertlistCourseHomeworkTarget(attendList, result.getElement()));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 보충 대상자 제외
	 * 
	 * @param req
	 * @param res
	 * @param target
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/homework/target/deletelist.do")
	public ModelAndView deletelistTarget(HttpServletRequest req, HttpServletResponse res, UIUnivCourseHomeworkVO homework, UIUnivCourseHomeworkTargetVO target)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, target);

		List<UnivCourseHomeworkTargetVO> attendList = new ArrayList<UnivCourseHomeworkTargetVO>();

		for (int index = 0; index < target.getTargetApplyCheckkeys().length; index++) {
			UnivCourseHomeworkTargetVO o = new UnivCourseHomeworkTargetVO();
			o.setHomeworkSeq(target.getHomeworkSeq());
			o.setCourseApplySeq(target.getTargetApplyCheckkeys()[index]);
			o.copyAudit(target);
			attendList.add(o);
		}

		if (attendList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			// 수강요소 정보 가져오기
			UnivCourseActiveElementVO element = new UnivCourseActiveElementVO();
			element.setCourseActiveSeq(homework.getCourseActiveSeq());
			element.setReferenceSeq(homework.getReferenceSeq());
			// TODO: 코드사용
			element.setReferenceTypeCd("COURSE_ELEMENT_TYPE::HOMEWORK");

			UIUnivCourseActiveElementRS result = (UIUnivCourseActiveElementRS)courseActiveElementService.getDetailElementType(element);

			mav.addObject("result", courseHomeworkTargetService.deletelistCourseHomeworkTarget(attendList, result.getElement()));
		}

		mav.setViewName("/common/save");
		return mav;
	}

}
