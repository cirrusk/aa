/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jxls.reader.XLSDataReadException;
import net.sf.jxls.reader.XLSReadStatus;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.infra.support.Codes;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.parser.ExcelParser;
import com._4csoft.aof.infra.support.util.AttachUtil;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.support.view.ExcelDownloadView;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyAttendVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCoursePostEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivYearTermVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyAttendCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivGradeLevelCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveEvaluateRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseApplyAttendRS;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseApplyAttendService;
import com._4csoft.aof.univ.service.UnivCourseApplyElementService;
import com._4csoft.aof.univ.service.UnivCourseApplyService;
import com._4csoft.aof.univ.service.UnivCoursePostEvaluateService;
import com._4csoft.aof.univ.service.UnivGradeLevelService;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivCourseActiveVO;
import com._4csoft.aof.univ.vo.UnivCourseApplyElementVO;
import com._4csoft.aof.univ.vo.UnivCourseApplyVO;
import com._4csoft.aof.univ.vo.UnivYearTermVO;

import egovframework.com.cmm.EgovMessageSource;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseApplyController.java
 * @Title : 과목 수강
 * @date : 2014. 3. 11.
 * @author : 장용기
 * @supporter : 서진철
 * @descrption :
 */

@Controller
public class UIUnivCourseApplyController extends BaseController {

	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyService univCourseApplyService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService univCourseActiveService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	@Resource (name = "UnivCourseApplyElementService")
	private UnivCourseApplyElementService univCourseApplyElementService;

	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService univCourseActiveEvaluateService;

	@Resource (name = "UnivCoursePostEvaluateService")
	private UnivCoursePostEvaluateService univCoursePostEvaluateService;

	@Resource (name = "UnivGradeLevelService")
	private UnivGradeLevelService univGradeLevelService;

	@Resource (name = "egovMessageSource")
	EgovMessageSource messageSource;

	@Resource (name = "CodeService")
	private CodeService codeService;

	@Resource (name = "UnivCourseApplyAttendService")
	private UnivCourseApplyAttendService univCourseApplyAttendService;

	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService univCourseActiveElementService;

	@Resource (name = "AttachUtil")
	private AttachUtil attachUtil;

	private final String JXLS_PATH = "univ/jxls/";

	private final String JXLS_DOWNLOAD_PATH = JXLS_PATH + "download/";

	private final String JXLS_UPLOAD_PATH = JXLS_PATH + "upload/";

	private Codes codes = Codes.getInstance();

	/**
	 * 년도 학기 조건을 셋팅한다.
	 * 
	 * @param req
	 * @param condition
	 */
	protected void setDefaultYearTerm(HttpServletRequest req, UIUnivCourseApplyCondition condition) {
		// 관리자 이외 사용자는 담당 과목만 볼수 있다.
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		// 시스템에 설정된 년도학기
		if (StringUtil.isEmpty(condition.getSrchYearTerm())) {
			if (ssMember.getExtendData().get("systemYearTerm") == null) {
				// 현재 년도의 1학기로 셋팅한다.
				String defaultTerm = "10";
				String yearTerm = DateUtil.getTodayYear() + defaultTerm;
				condition.setSrchYearTerm(yearTerm);
			} else {
				UnivYearTermVO univYearTermVO = (UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm");
				condition.setSrchYearTerm(univYearTermVO.getYearTerm());
			}
		}
	}

	/**
	 * 수강생의 개설과목의 학습기간은 수강 승인을 시점으로 하여 결정된다.
	 * 
	 * 학위<br/>
	 * - 학기 과정 : 개설 과목의 학습일 기준<br/>
	 * 
	 * 비학위<br/>
	 * - 상시제 : 수강 승인 시점을 기준으로 학습기간 X일을 기준<br/>
	 * ex) 수강승인은 2014년 10월 1일이고 학습기간이 30일 경우 -> 학습기간은 2014년 10월 1일 ~ 2014년 10월 31일<br/>
	 * 
	 * - 기수제 : 개설 과목의 학습일 기준<br/>
	 * 
	 * @throws Exception
	 * 
	 */
	public void setCourseActive(UnivCourseApplyVO courseApply, UnivCourseActiveVO courseActive) throws Exception {

		if (courseActive.getCourseTypeCd() != null && courseActive.getCourseTypeCd().equals("COURSE_TYPE::ALWAYS")) {
			// 일수 계산 자동 수강승인 과정일시 일수가 계산되며 자동수강승인이 아닐때는 수강승인 상태로 변경될때 계산된다.
			if ("APPLY_TYPE::AUTO".equals(courseActive.getApplyTypeCd())) {
				Long studyDay = courseActive.getStudyDay();
				Long resumeDay = courseActive.getResumeDay();

				if (StringUtil.isEmpty(resumeDay)) {
					resumeDay = 0L;
				}

				Date studyStartDate = DateUtil.getFormatDate(DateUtil.getToday(Constants.FORMAT_DATETIME), Constants.FORMAT_DATETIME);
				String studyEndDate = DateUtil.getFormatString(DateUtil.addDate(studyStartDate, studyDay.intValue()), Constants.FORMAT_DBDATETIME_END);
				String resumeEndDate = DateUtil.getFormatString(DateUtil.addDate(studyStartDate, (studyDay.intValue() + resumeDay.intValue())),
						Constants.FORMAT_DBDATETIME_END);

				courseApply.setStudyStartDate(DateUtil.getFormatString(studyStartDate, Constants.FORMAT_DBDATETIME_START));
				courseApply.setStudyEndDate(studyEndDate);
				courseApply.setResumeEndDate(resumeEndDate);
			}
		} else {
			courseApply.setStudyStartDate(courseActive.getStudyStartDate());
			courseApply.setStudyEndDate(courseActive.getStudyEndDate());
			courseApply.setResumeEndDate(courseActive.getResumeEndDate());
		}

		courseApply.setCourseMasterSeq(courseActive.getCourseMasterSeq());
		courseApply.setYearTerm(courseActive.getYearTerm());
		courseApply.setDivision(courseActive.getDivision());

		// if ("APPLY_TYPE::AUTO".equals(courseActive.getApplyTypeCd())) {
		// // 승인
		// courseApply.setApplyStatusCd("APPLY_STATUS::002");
		// } else {
		// // 대기
		// courseApply.setApplyStatusCd("APPLY_STATUS::001");
		// }
		// 설정에 상관없이 수강 승인으로 수정 (인화원 요청)
		courseApply.setApplyStatusCd("APPLY_STATUS::002");
		// 인화원은 수강상태를 일반으로 고정시킨다.
		courseApply.setApplyKindCd("APPLY_KIND_TYPE::001");

	}

	/**
	 * 수강신청 조회 목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/list.do")
	public ModelAndView listDegree(HttpServletRequest req, HttpServletResponse res, UIUnivYearTermVO yearTerm, UIUnivCourseActiveVO courseActive,
			UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 개설과목 셋팅
		courseActive.copyShortcut();
		condition.setSrchCourseActiveSeq(courseActive.getCourseActiveSeq());
		// 년도 학기 셋팅
		setDefaultYearTerm(req, condition);

		// 검색 조건의 년도학기
		mav.addObject("yearTerms", univYearTermService.getListYearTermAll());
		mav.addObject("paginate", univCourseApplyService.getListCourseApply(condition));

		yearTerm.setYearTerm(condition.getSrchYearTerm());
		mav.addObject("yearTermDeatil", univYearTermService.getDetailYearTerm(yearTerm));

		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseApply/listCourseApply");
		return mav;
	}

	/**
	 * 수강신청 다중 등록
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/insertlist.do")
	public ModelAndView insertlist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO courseApply) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseApply);

		// 개설과목 정보 가져온후 학습관련 일을 set
		List<UnivCourseApplyVO> voList = new ArrayList<UnivCourseApplyVO>();

		UIUnivCourseActiveVO courseActive = null;

		boolean isFirst = true;
		for (String index : courseApply.getCheckkeys()) {
			UIUnivCourseApplyVO o = new UIUnivCourseApplyVO();
			Long courseActiveSeq = courseApply.getCourseActiveSeqs()[Integer.parseInt(index)];

			if (isFirst) {
				courseActive = ((UIUnivCourseActiveRS)univCourseActiveService.getDetailCourseActive(new UnivCourseActiveVO(courseActiveSeq))).getCourseActive();

				isFirst = false;
			}

			// 수강 및 과정 정보 셋팅
			setCourseActive(o, courseActive);

			o.setCourseActiveSeq(courseActiveSeq);
			o.setMemberSeq(courseApply.getMemberSeqs()[Integer.parseInt(index)]);
			o.setApplyKindCd(courseApply.getApplyKindCds()[Integer.parseInt(index)]);

			o.copyAudit(courseApply);

			voList.add(o);
		}

		univCourseApplyService.insertlistCourseApply(voList);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 수강상태 수정
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/status/update.do")
	public ModelAndView upateApplyStatus(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);
		vo.copyShortcut();

		univCourseApplyService.updateStatusCd(vo);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 수강상태 다중 수정
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/status/updatelist.do")
	public ModelAndView upatelistApplyStatus(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		// 개설과목 셋팅
		vo.copyShortcut();

		// 개설과목 정보 가져온후 학습관련 일을 set
		List<UnivCourseApplyVO> voList = new ArrayList<UnivCourseApplyVO>();

		for (String index : vo.getCheckkeys()) {
			UIUnivCourseApplyVO o = new UIUnivCourseApplyVO();
			o.setCourseActiveSeq(vo.getCourseActiveSeqs()[Integer.parseInt(index)]);
			o.setCourseApplySeq(vo.getCourseApplySeqs()[Integer.parseInt(index)]);
			o.setApplyStatusCd(vo.getApplyStatusCd());
			o.setCourseTypeCd(vo.getCourseTypeCd());
			o.copyAudit(vo);

			voList.add(o);
		}

		univCourseApplyService.updatelistStatusCd(voList);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 수강생 다중 삭제(학기 시작이후 삭제 불가능)
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/deletelist.do")
	public ModelAndView deletelistApplyStatus(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		// 개설과목 셋팅
		vo.copyShortcut();

		List<UnivCourseApplyVO> voList = new ArrayList<UnivCourseApplyVO>();

		for (String index : vo.getCheckkeys()) {
			UIUnivCourseApplyVO o = new UIUnivCourseApplyVO();
			o.setCourseApplySeq(vo.getCourseApplySeqs()[Integer.parseInt(index)]);
			o.setCourseActiveSeq(vo.getCourseActiveSeqs()[Integer.parseInt(index)]);
			o.copyAudit(vo);

			voList.add(o);
		}

		univCourseApplyService.deletelistCourseApply(voList);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 수강하지 않는 학생 목록 팝업
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/member/popup.do")
	public ModelAndView listWithoutCourseApplyPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO vo,
			UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", univCourseApplyService.getListWithoutCourseApply(condition));
		mav.addObject("condition", condition);
		mav.addObject("courseApply", vo);

		mav.setViewName("/univ/courseApply/listCourseApplyPopup");
		return mav;
	}

	/**
	 * 성적관리
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/completion/list.do")
	public ModelAndView listCompletion(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 개설과목 셋팅
		courseActive.copyShortcut();
		condition.setSrchCourseActiveSeq(courseActive.getCourseActiveSeq());

		UIUnivCourseActiveRS rs = new UIUnivCourseActiveRS();
		rs = (UIUnivCourseActiveRS)univCourseActiveService.getDetailCourseActive(courseActive);
		condition.setSrchCategoryTypeCd(rs.getCategory().getCategoryTypeCd());
		// 개설과목 정보
		mav.addObject("getDetail", rs);

		if ("CATEGORY_TYPE::DEGREE".equals(rs.getCategory().getCategoryTypeCd())) {
			// 년도 학기 셋팅
			setDefaultYearTerm(req, condition);

			// 성적등급
			UIUnivGradeLevelCondition gradeLevelCondition = new UIUnivGradeLevelCondition();
			gradeLevelCondition.setSrchYearTerm(condition.getSrchYearTerm());
			mav.addObject("listGradeLevel", univGradeLevelService.getList(gradeLevelCondition));

			mav.setViewName("/univ/courseApply/listCourseApplyCompletion");
		} else {
			if ("COURSE_TYPE::ALWAYS".equals(rs.getCourseActive().getCourseTypeCd())) {
				emptyValue(condition, "srchCompleteYn=N");
			}
			condition.setCurrentPage(1);
			mav.setViewName("/univ/courseApply/listCourseApplyCompletionNonDegree");
		}

		// 평가기준
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(courseActive.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		// 참여 평가기준
		UIUnivCoursePostEvaluateVO coursePostEvaluate = new UIUnivCoursePostEvaluateVO();
		coursePostEvaluate.setCourseActiveSeq(courseActive.getCourseActiveSeq());
		coursePostEvaluate.setPostType("board");
		mav.addObject("listBoardEvaluate", univCoursePostEvaluateService.getList(coursePostEvaluate));

		// 수강생 리스트
		condition.setSrchApplyStatusCd("APPLY_STATUS::002");
		mav.addObject("paginate", univCourseApplyService.getListCourseApply(condition));

		mav.addObject("condition", condition);

		return mav;
	}

	/**
	 * 총점산출 하기
	 * 
	 * @param req
	 * @param res
	 * @param courseApply
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/completion/{categoryType}/evaluate.do")
	public ModelAndView evaluateScore(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO courseApply,
			UnivCourseApplyElementVO courseApplyElement, @PathVariable ("categoryType") String categoryType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseApply, courseApplyElement);

		// 평가기준
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(courseApply.getCourseActiveSeq());
		List<ResultSet> list = univCourseActiveEvaluateService.getList(courseActiveEvaluate);

		for (int i = 0; i < list.size(); i++) {
			UIUnivCourseActiveEvaluateRS rs = (UIUnivCourseActiveEvaluateRS)list.get(i);
			// 평가점수
			if ("degree".equals(categoryType)) {
				if ("COURSE_ELEMENT_TYPE::MIDEXAM".equals(rs.getEvaluate().getEvaluateTypeCd()) && rs.getEvaluate().getScore() > 0) {
					mav.addObject("resultScoreMidExam",
							univCourseApplyElementService.getSumScore(courseApply.getCourseApplySeq(), "COURSE_ELEMENT_TYPE::MIDEXAM"));
				}
				if ("COURSE_ELEMENT_TYPE::FINALEXAM".equals(rs.getEvaluate().getEvaluateTypeCd()) && rs.getEvaluate().getScore() > 0) {
					mav.addObject("resultScoreFinalExam",
							univCourseApplyElementService.getSumScore(courseApply.getCourseApplySeq(), "COURSE_ELEMENT_TYPE::FINALEXAM"));
				}
			} else {
				if ("COURSE_ELEMENT_TYPE::EXAM".equals(rs.getEvaluate().getEvaluateTypeCd()) && rs.getEvaluate().getScore() > 0) {
					mav.addObject("resultScoreExam", univCourseApplyElementService.getSumScore(courseApply.getCourseApplySeq(), "COURSE_ELEMENT_TYPE::EXAM"));
				}
			}
			if ("COURSE_ELEMENT_TYPE::ONLINE".equals(rs.getEvaluate().getEvaluateTypeCd()) && rs.getEvaluate().getScore() > 0) {
				mav.addObject("resultOnline", univCourseApplyService.getSumOnlineAttendScore(courseApply));
			}
			if ("COURSE_ELEMENT_TYPE::TEAMPROJECT".equals(rs.getEvaluate().getEvaluateTypeCd()) && rs.getEvaluate().getScore() > 0) {
				// 수강생별 프로젝트 점수를 계산한다.
				courseApplyElement.setCourseApplySeq(courseApply.getCourseApplySeq());
				univCourseApplyElementService.insertTeamprojectEvaluateScore(courseApplyElement);

				mav.addObject("resultScoreTeamproject",
						univCourseApplyElementService.getSumScore(courseApply.getCourseApplySeq(), "COURSE_ELEMENT_TYPE::TEAMPROJECT"));
			}
			if ("COURSE_ELEMENT_TYPE::ORGANIZATION".equals(rs.getEvaluate().getEvaluateTypeCd()) && rs.getEvaluate().getScore() > 0) {
				mav.addObject("resultProgress", univCourseApplyService.getDetailResultDatamodel(courseApply));
			}
			if ("COURSE_ELEMENT_TYPE::HOMEWORK".equals(rs.getEvaluate().getEvaluateTypeCd()) && rs.getEvaluate().getScore() > 0) {

				mav.addObject("resultScoreHomework",
						univCourseApplyElementService.getSumScore(courseApply.getCourseApplySeq(), "COURSE_ELEMENT_TYPE::HOMEWORK"));
			}
			if ("COURSE_ELEMENT_TYPE::DISCUSS".equals(rs.getEvaluate().getEvaluateTypeCd()) && rs.getEvaluate().getScore() > 0) {
				mav.addObject("resultScoreDiscuss", univCourseApplyElementService.getSumScore(courseApply.getCourseApplySeq(), "COURSE_ELEMENT_TYPE::DISCUSS"));
			}
			if ("COURSE_ELEMENT_TYPE::QUIZ".equals(rs.getEvaluate().getEvaluateTypeCd()) && rs.getEvaluate().getScore() > 0) {
				mav.addObject("resultScoreQuiz", univCourseApplyElementService.getSumScore(courseApply.getCourseApplySeq(), "COURSE_ELEMENT_TYPE::QUIZ"));
			}
			if ("COURSE_ELEMENT_TYPE::JOIN".equals(rs.getEvaluate().getEvaluateTypeCd()) && rs.getEvaluate().getScore() > 0) {
				mav.addObject("resultJoin", univCourseApplyService.getDetailResultJoin(courseApply));
			}
			if ("COURSE_ELEMENT_TYPE::OFFLINE".equals(rs.getEvaluate().getEvaluateTypeCd()) && rs.getEvaluate().getScore() > 0) {
				mav.addObject("resultOffline", univCourseApplyService.getSumOfflineAttendScore(courseApply));
			}

		}

		mav.addObject("courseApply", courseApply);

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 총점산출 저장
	 * 
	 * @param req
	 * @param res
	 * @param courseApply
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/completion/{categoryType}/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO courseApply,
			@PathVariable ("categoryType") String categoryType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseApply);

		List<UnivCourseApplyVO> voList = new ArrayList<UnivCourseApplyVO>();
		if (courseApply.getCheckkeys() != null) {
			for (String index : courseApply.getCheckkeys()) {
				UIUnivCourseApplyVO o = new UIUnivCourseApplyVO();
				o.setCourseApplySeq(courseApply.getCourseApplySeqs()[Integer.parseInt(index)]);

				if ("degree".equals(categoryType)) {
					// 중간고사 점수
					if (courseApply.getMiddleExamScores() != null) {
						o.setMiddleExamScore(courseApply.getMiddleExamScores()[Integer.parseInt(index)]);
					}
					// 기말고사 점수
					if (courseApply.getFinalExamScores() != null) {
						o.setFinalExamScore(courseApply.getFinalExamScores()[Integer.parseInt(index)]);
					}
					// 환산학점
					if (courseApply.getGradeLevelCds() != null) {
						o.setGradeLevelCd(courseApply.getGradeLevelCds()[Integer.parseInt(index)]);
					}
					// 순위
					if (courseApply.getRankings() != null) {
						o.setRanking(courseApply.getRankings()[Integer.parseInt(index)]);
					}
				} else {
					// 시험점수
					if (courseApply.getExamScores() != null) {
						o.setExamScore(courseApply.getExamScores()[Integer.parseInt(index)]);
					}
					// 수료여부
					if (courseApply.getCompletionYns() != null) {
						o.setCompletionYn(courseApply.getCompletionYns()[Integer.parseInt(index)]);
					}
				}
				// 온라인출석 점수
				if (courseApply.getOnAttendScores() != null) {
					o.setOnAttendScore(courseApply.getOnAttendScores()[Integer.parseInt(index)]);
				}
				// 팀프로젝트 점수
				if (courseApply.getTeamprojectScores() != null) {
					o.setTeamprojectScore(courseApply.getTeamprojectScores()[Integer.parseInt(index)]);
				}
				// 진도점수
				if (courseApply.getProgressScores() != null) {
					o.setProgressScore(courseApply.getProgressScores()[Integer.parseInt(index)]);
				}
				// 과제 점수
				if (courseApply.getHomeworkScores() != null) {
					o.setHomeworkScore(courseApply.getHomeworkScores()[Integer.parseInt(index)]);
				}
				// 토론 점수
				if (courseApply.getDiscussScores() != null) {
					o.setDiscussScore(courseApply.getDiscussScores()[Integer.parseInt(index)]);
				}
				// 퀴즈 점수
				if (courseApply.getQuizScores() != null) {
					o.setQuizScore(courseApply.getQuizScores()[Integer.parseInt(index)]);
				}
				// 참여 점수
				if (courseApply.getJoinScores() != null) {
					o.setJoinScore(courseApply.getJoinScores()[Integer.parseInt(index)]);
				}
				// 오프라인 출석 점수
				if (courseApply.getOffAttendScores() != null) {
					o.setOffAttendScore(courseApply.getOffAttendScores()[Integer.parseInt(index)]);
				}
				// 획득 점수
				if (courseApply.getTakeScores() != null) {
					o.setTakeScore(courseApply.getTakeScores()[Integer.parseInt(index)]);
				}
				// 가산점
				if (courseApply.getAddScores() != null) {
					o.setAddScore(courseApply.getAddScores()[Integer.parseInt(index)]);
				}
				// 최종점수
				if (courseApply.getFinalScores() != null) {
					o.setFinalScore(courseApply.getFinalScores()[Integer.parseInt(index)]);
				}

				o.setGradeMakeDtime("now");
				o.copyAudit(courseApply);
				voList.add(o);
			}
		}
		if (voList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univCourseApplyService.updatelistCourseApply(voList));
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 성적관리 개인별 세부성적 보기
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/completion/{categoryType}/popup.do")
	public ModelAndView detailCompletionPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO courseApply,
			@PathVariable ("categoryType") String categoryType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseApply);
		// 평가기준
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(courseApply.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		// 수강자정보
		mav.addObject("detail", univCourseApplyService.getDetail(courseApply));

		// 세부성적
		mav.addObject("detailList", univCourseApplyService.getListMemberCompletion(courseApply));

		// 항목별 세부성적 : 온라인출석
		UIUnivCourseActiveElementVO activeElement = new UIUnivCourseActiveElementVO();
		activeElement.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		activeElement.setCourseWeekTypeCd("COURSE_WEEK_TYPE::LECTURE");
		activeElement.setCourseActiveSeq(courseApply.getCourseActiveSeq());
		activeElement.setCourseApplySeq(courseApply.getCourseApplySeq());
		mav.addObject("itemList", univCourseActiveElementService.getListResultDatamodel(activeElement));

		UIUnivCourseApplyAttendCondition attendCondition = new UIUnivCourseApplyAttendCondition();
		attendCondition.setSrchCourseActiveSeq(courseApply.getCourseActiveSeq());
		attendCondition.setSrchCourseApplySeq(courseApply.getCourseApplySeq());
		attendCondition.setCourseTypeCd(courseApply.getShortcutCourseTypeCd());
		mav.addObject("detailOnline", univCourseApplyAttendService.getListByOnlineApplyCourseApplyAttend(attendCondition));

		// 항목별 세부성적
		UIUnivCourseApplyElementVO applyElement = new UIUnivCourseApplyElementVO();
		applyElement.setCourseActiveSeq(courseApply.getCourseActiveSeq());
		applyElement.setCourseApplySeq(courseApply.getCourseApplySeq());
		mav.addObject("applyElementList", univCourseApplyElementService.getListMemberElement(applyElement));

		// 항목별 세부성적 : 오프라인출석
		activeElement.setCourseWeekTypeCd("");
		mav.addObject("listElement", univCourseActiveElementService.getList(activeElement));

		UIUnivCourseApplyAttendVO attendVO = new UIUnivCourseApplyAttendVO();
		attendVO.setCourseActiveSeq(courseApply.getCourseActiveSeq());
		attendVO.setCourseApplySeq(courseApply.getCourseApplySeq());
		List<ResultSet> listApplyAttend = univCourseApplyAttendService.getDetailByOffApplyAttend(attendVO);
		HashMap<String, String> hashMap = new HashMap<String, String>();
		for (int i = 0; listApplyAttend.size() > i; i++) {
			UIUnivCourseApplyAttendRS rs = (UIUnivCourseApplyAttendRS)listApplyAttend.get(i);
			hashMap.put(rs.getApplyAttend().getActiveElementSeq() + "_" + rs.getApplyAttend().getLessonSeq(), rs.getApplyAttend().getAttendTypeCd());
		}
		mav.addObject("applyAttendHash", hashMap);
		mav.addObject("totalAttendCount", listApplyAttend.size());
		mav.addObject("detailOffline", univCourseApplyAttendService.getListByOfflineApplyAttendScore(attendCondition));

		if ("degree".equals(categoryType)) {
			mav.setViewName("/univ/courseApply/detailCourseApplyCompletionPopup");
		} else {
			mav.setViewName("/univ/courseApply/detailCourseApplyCompletionNonDegreePopup");
		}

		return mav;
	}

	/**
	 * 성적관리목록을 excel로 다운로드 한다.
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/completion/excel.do")
	public ModelAndView excelListCompletion(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive,
			UIUnivCourseApplyCondition condition) throws Exception {

		requiredSession(req);

		ModelAndView mav = new ModelAndView();

		condition.setCurrentPage(0);
		emptyValue(condition, "currentPage=0", "orderby=0");

		// 개설과목 셋팅
		courseActive.copyShortcut();
		condition.setSrchCourseActiveSeq(courseActive.getCourseActiveSeq());
		// 년도 학기 셋팅
		setDefaultYearTerm(req, condition);
		condition.setSrchApplyStatusCd("APPLY_STATUS::002");
		Paginate<ResultSet> paginate = univCourseApplyService.getListCourseApply(condition);

		mav.setViewName("excelView");
		mav.addObject("codes", codeService);
		mav.addObject("list", paginate.getItemList());
		mav.addObject(ExcelDownloadView.TEMPLATE_FILE_NAME, JXLS_DOWNLOAD_PATH + "completionDegreeTemplate");
		mav.addObject(ExcelDownloadView.DOWNLOAD_FILE_NAME, "completionDegree_" + DateUtil.getToday("yyyyMMdd"));

		return mav;
	}

	/**
	 * 성적관리목록을 excel로 다운로드 한다.
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/completion/nondegree/excel.do")
	public ModelAndView excelListCompletionNon(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive,
			UIUnivCourseApplyCondition condition) throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		condition.setCurrentPage(0);
		emptyValue(condition, "currentPage=0", "orderby=0");

		// 운영과정 셋팅
		courseActive.copyShortcut();
		condition.setSrchCourseActiveSeq(courseActive.getCourseActiveSeq());
		condition.setSrchApplyStatusCd("APPLY_STATUS::002");
		Paginate<ResultSet> paginate = univCourseApplyService.getListCourseApply(condition);

		mav.setViewName("excelView");
		mav.addObject("codes", codeService);
		mav.addObject("list", paginate.getItemList());
		mav.addObject(ExcelDownloadView.TEMPLATE_FILE_NAME, JXLS_DOWNLOAD_PATH + "completionNonDegreeTemplate");
		mav.addObject(ExcelDownloadView.DOWNLOAD_FILE_NAME, "completionNonDegree_" + DateUtil.getToday("yyyyMMdd"));

		return mav;
	}

	/**
	 * 수료증 발급 팝업
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/certificate/popup.do")
	public ModelAndView getDetailCertificatePopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive,
			UIUnivCourseApplyVO courseApply) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 개설과목 셋팅
		courseActive.copyShortcut();
		mav.addObject("getDetail", univCourseActiveService.getDetailCourseActive(courseActive));

		mav.addObject("getDetailApply", univCourseApplyService.getDetail(courseApply));

		mav.setViewName("/univ/courseApply/getDetailCertificatePopup");
		return mav;
	}

	/**
	 * 성적처리 성적 확정 수정
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = { "/univ/course/apply/complete/updatelist.do", "/univ/course/apply/complete/update.do" })
	public ModelAndView upatelistApplyGradeStatus(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO vo, UIUnivCourseActiveVO activeVO)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo, activeVO);

		if ("/univ/course/apply/complete/updatelist.do".equals(req.getServletPath())) {
			// 개설과목 정보 가져온후 학습관련 일을 set
			List<UnivCourseApplyVO> voList = new ArrayList<UnivCourseApplyVO>();

			for (String index : vo.getCheckkeys()) {
				UIUnivCourseApplyVO o = new UIUnivCourseApplyVO();
				o.setCourseActiveSeq(vo.getCourseActiveSeqs()[Integer.parseInt(index)]);
				o.setCourseApplySeq(vo.getCourseApplySeqs()[Integer.parseInt(index)]);
				o.setGradeCompleteYn("Y");
				o.copyAudit(vo);

				voList.add(o);
			}
			univCourseApplyService.updatelistCourseApply(voList);
		} else {
			univCourseApplyService.updatelistCourseApply(vo, activeVO);
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 자동 분반 나누기
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/random/division/update.do")
	public ModelAndView upateRandomDivision(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyVO courseApply)
			throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseApply);

		UIUnivCourseActiveRS detailCourseActive = (UIUnivCourseActiveRS)univCourseActiveService.getDetailCourseActive(courseActive);
		Long divisionCount = detailCourseActive.getCourseActive().getDivisionCount();

		// 튜터를 등록하지 않으면 분반을 나눌수 없다.
		if (StringUtil.isNotEmpty(divisionCount) && divisionCount > 0) {
			courseApply.setDivisionCount(divisionCount);
			mav.addObject("result", univCourseApplyService.updateRandomDivision(courseApply));
		} else {
			mav.addObject("result", 0);
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 분반 수정
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/division/update.do")
	public ModelAndView upateDivision(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO vo) throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		univCourseApplyService.updateDivision(vo);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 분반 초기화
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/init/division/update.do")
	public ModelAndView upateInitDivision(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO vo) throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		univCourseApplyService.updateInitDivision(vo);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 수강생 일괄등록 엑셀 업로드
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/member/upload/popup.do")
	public ModelAndView uploadExcelApplyPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("courseApply", vo);

		mav.setViewName("/univ/courseApply/excelUploadPopup");
		return mav;
	}

	/**
	 * 수강신청 목록 엑셀 업로드
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/attach/excel/save.do")
	public ModelAndView uploadExcelApply(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyVO vo, UIAttachVO attach) throws Exception {
		requiredSession(req, vo);

		ModelAndView mav = new ModelAndView();
		mav.setViewName("/common/save");

		File saveFile = null;
		try {
			attachUtil.copyToBean(attach);
			saveFile = new File(Constants.UPLOAD_PATH_FILE + attach.getSavePath() + "/" + attach.getSaveName());

			List<UnivCourseApplyVO> courseApplys = new ArrayList<UnivCourseApplyVO>();
			Map<String, Object> rowDataes = new HashMap<String, Object>();
			rowDataes.put("courseApplys", courseApplys);

			ExcelParser excelParse = new ExcelParser();
			XLSReadStatus readStatus = excelParse.parse(rowDataes, saveFile, JXLS_UPLOAD_PATH + "courseApplyTemplate-jxls-config");

			if (readStatus.isStatusOK()) {
				boolean isFirst = true;
				UIUnivCourseActiveVO detailCourseActive = null;
				for (UnivCourseApplyVO courseApply : courseApplys) {
					if (isFirst) {
						UnivCourseActiveVO courseActive = new UnivCourseActiveVO();
						courseActive.setCourseActiveSeq(courseApply.getCourseActiveSeq());
						detailCourseActive = ((UIUnivCourseActiveRS)univCourseActiveService.getDetailCourseActive(courseActive)).getCourseActive();

						isFirst = false;
					}

					// 수강생의 운영과정의 학습기간 및 수강자동승인 여부은 수강 승인을 시점으로 하여 결정된다.
					setCourseActive(courseApply, detailCourseActive);

					courseApply.copyAudit(vo);
				}

				univCourseApplyService.insertlistBatchCourseApply(courseApplys);

				mav.addObject("result", "{\"success\":1}");
			} else {
				mav.addObject("result", "{\"success\":0}");
			}
		} catch (XLSDataReadException xlsException) {
			if (saveFile != null && saveFile.exists()) {
				saveFile.delete();
			}
			log.error(xlsException);

			mav.addObject("result", "{\"success\":0,\"error\": \"" + xlsException.getCellName() + "\",\"message\": \"" + xlsException.getMessage() + "\"}");

			return mav;
		} finally {
			if (saveFile != null && saveFile.exists()) {
				saveFile.delete();
			}
		}
		return mav;
	}

	/**
	 * 수강신청 목록 엑셀 다운로드
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/excel.do")
	public ModelAndView downloadExcelApply(HttpServletRequest req, UIUnivCourseActiveVO courseActive, UIUnivCourseApplyCondition condition) throws Exception {

		requiredSession(req);

		ModelAndView mav = new ModelAndView();

		// 공통코드
		final String CD_APPLY_STATUS_002 = codes.get("CD.APPLY_STATUS.002");

		emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=5");

		// 운영과정 셋팅
		condition.setSrchCourseActiveSeq(courseActive.getCourseActiveSeq());

		if (StringUtil.isEmpty(condition.getSrchApplyStatusCd())) {
			condition.setSrchApplyStatusCd(CD_APPLY_STATUS_002);
		}

		mav.setViewName("excelView");
		mav.addObject("codes", codeService);
		mav.addObject("list", univCourseApplyService.getListCourseApply(condition).getItemList());
		mav.addObject(ExcelDownloadView.TEMPLATE_FILE_NAME, JXLS_DOWNLOAD_PATH + "courseApplyTemplate");
		mav.addObject(ExcelDownloadView.DOWNLOAD_FILE_NAME, "수강생_" + DateUtil.getToday("yyyyMMdd"));

		return mav;
	}

	/**
	 * 일괄 수강신청 업로드용도의 엑셀 템플릿 다운로드
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/template/excel.do")
	public ModelAndView downloadExcelApplyTemplate(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO courseActive,
			UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		// 공통코드
		final String CD_APPLY_STATUS = codes.get("CD.APPLY_STATUS");

		requiredSession(req);

		mav.addObject("courseActiveSeq", courseActive.getCourseActiveSeq());
		mav.addObject("list", codeService.getListCode(CD_APPLY_STATUS));
		mav.addObject(ExcelDownloadView.TEMPLATE_FILE_NAME, JXLS_UPLOAD_PATH + "courseApplyTemplate");
		mav.addObject(ExcelDownloadView.DOWNLOAD_FILE_NAME, "수강신청_템플릿_" + DateUtil.getToday("yyyyMMdd"));

		mav.setViewName("excelView");

		return mav;
	}

}
