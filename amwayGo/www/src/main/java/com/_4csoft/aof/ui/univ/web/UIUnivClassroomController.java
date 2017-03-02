/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.UnivBaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyAccessHistoryVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectVO;
import com._4csoft.aof.ui.univ.vo.UIUnivYearTermVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveBbsCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveBbsService;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseActiveExamPaperService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseActiveSurveyService;
import com._4csoft.aof.univ.service.UnivCourseApplyAccessHistoryService;
import com._4csoft.aof.univ.service.UnivCourseApplyAttendService;
import com._4csoft.aof.univ.service.UnivCourseApplyService;
import com._4csoft.aof.univ.service.UnivCourseDiscussService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectService;
import com._4csoft.aof.univ.service.UnivYearTermService;

/**
 * @Project : aof5-univ-ui-www
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivClassroomController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 3. 3.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivClassroomController extends UnivBaseController {
 
	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService elementService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService activeService;

	@Resource (name = "UnivCourseApplyAttendService")
	private UnivCourseApplyAttendService applyAttendService;

	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyService applyService;

	@Resource (name = "UnivCourseDiscussService")
	private UnivCourseDiscussService discussService;

	@Resource (name = "UnivCourseHomeworkService")
	private UnivCourseHomeworkService homeworkService;

	@Resource (name = "UnivCourseActiveExamPaperService")
	private UnivCourseActiveExamPaperService courseActiveExamPaperService;

	@Resource (name = "UnivCourseActiveSurveyService")
	private UnivCourseActiveSurveyService courseActiveSurveyService;

	@Resource (name = "UnivCourseActiveBbsService")
	private UnivCourseActiveBbsService bbsService;

	@Resource (name = "UnivCourseTeamProjectService")
	private UnivCourseTeamProjectService courseTeamProjectService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService yearTermService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	@Resource (name = "UnivCourseApplyAccessHistoryService")
	protected UnivCourseApplyAccessHistoryService courseApplyAccessHistoryService;

	private final String BOARD_REFERENCE_TYPE = "course";

	/**
	 * 강의실 홈 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/usr/classroom/main.do")
	public ModelAndView main(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIUnivCourseTeamProjectVO teamProject) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, teamProject);
		setCourseActive(req, vo, teamProject);

		Long courseActiveSeq = vo.getCourseActiveSeq();
		Long courseApplySeq = Long.parseLong(HttpUtil.getParameter(req, "courseApplySeq"));

		// 강의실 정보 셋팅
		mav.addObject("courseActive", activeService.getDetailCourseActiveByClassroom(courseActiveSeq));

		// 과목이 상시제일시 오프라인 팀프로젝트 제외
		if (!"COURSE_TYPE::ALWAYS".equals(vo.getCourseTypeCd())) {
			// 오프라인 출석 정보
			mav.addObject("applyAttendOff", applyAttendService.getDetailTotalByOffApplyAttend(courseApplySeq));

			// 오프라인 출석 정보
			mav.addObject("offlineLessonCount", applyAttendService.countSumOfflineLessonCount(courseActiveSeq));

			// 팀프로젝트 정보
			mav.addObject("teamProject", courseTeamProjectService.getListAllCourseTeamProjectByUser(teamProject));
		}

		// 과정더보기 현재 수강중인 과목 셋팅
		this.setApplyList(mav, req, courseActiveSeq);

		// 진도율 셋팅
		this.setTotalProgress(mav, courseActiveSeq, courseApplySeq, vo.getCourseTypeCd());

		// 과제 목록 셋팅
		this.setHomeworkList(mav, courseActiveSeq, courseApplySeq, vo.getCourseTypeCd());

		// 시험 목록 세팅
		this.setExamPaperList(mav, courseActiveSeq, courseApplySeq);

		// 설문 목록 세팅
		this.setSurveyPaperList(mav, courseActiveSeq, courseApplySeq, vo.getCourseTypeCd());

		// 퀴즈 목록 세팅
		this.setQuizList(mav, courseActiveSeq, courseApplySeq, vo.getCourseTypeCd());

		// 토론 목록 셋팅
		this.setDiscussList(mav, courseActiveSeq, courseApplySeq, vo.getCourseTypeCd());

		// 공지사항 목록 셋팅
		this.setNoticeList(mav, courseActiveSeq, courseApplySeq);

		// 비학위시험 목록 셋팅
		this.setExamPaperNonDegreeList(mav, courseActiveSeq, courseApplySeq, vo.getCourseTypeCd());

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		UIUnivCourseApplyAccessHistoryVO history = new UIUnivCourseApplyAccessHistoryVO();
		history.setMemberSeq(ssMember.getMemberSeq());
		history.setCourseActiveSeq(vo.getCourseActiveSeq());
		history.setCourseApplySeq(courseApplySeq);
		history.setSessionId(SessionUtil.getSessionId(req));
		history.setSite(Constants.SYSTEM_DOMAIN);
		history.setUserAgent(ssMember.getUserAgent());
		history.setRolegroupSeq(ssMember.getCurrentRolegroupSeq());
		history.setDevice(StringUtil.detectDevice(history.getUserAgent()));
		history.setRegIp(req.getRemoteAddr());
		history.setUpdIp(req.getRemoteAddr());
		history.setRegMemberSeq(ssMember.getMemberSeq());
		history.setUpdMemberSeq(ssMember.getMemberSeq());

		// 강의실 접근 히스토리 저장
		courseApplyAccessHistoryService.insert(history);

		mav.setViewName("/univ/classroom/mainClassroom");
		return mav;
	}

	/**
	 * 과정더보기 리스트 용도 내가 현재 수강하고 있는 강의실 목록 가져오기
	 * 
	 * @param courseActiveSeq
	 * @param courseApplySeq
	 */
	public void setApplyList(ModelAndView mav, HttpServletRequest req, Long courseActiveSeq) throws Exception {

		UIUnivCourseApplyCondition condition = new UIUnivCourseApplyCondition();

		emptyValue(condition, "currentPage=0");

		condition.setSrchApplyType("ING"); // 수강중인과목
		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		// 현재년도학기 구하기
		UIUnivYearTermVO vo = (UIUnivYearTermVO)yearTermService.getSystemYearTerm(SessionUtil.getMember(req).getCurrentRoleCfString());
		condition.setSrchYearTerm(vo.getYearTerm());
		condition.setSrchNotInCourseActiveSeq(courseActiveSeq);

		// 년도학기 정보 가져오기
		mav.addObject("applyList", applyService.getListMyCourse(condition));
	}

	/**
	 * 강의실 메인 평균진도와 나의 진도값 ModelAndView에 셋팅
	 * 
	 * @param courseActiveSeq
	 * @param courseApplySeq
	 */
	public void setTotalProgress(ModelAndView mav, Long courseActiveSeq, Long courseApplySeq, String courseType) throws Exception {

		UIUnivCourseActiveElementVO activeElement = new UIUnivCourseActiveElementVO();
		activeElement.setCourseActiveSeq(courseActiveSeq);
		activeElement.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		activeElement.setCourseApplySeq(courseApplySeq);
		activeElement.setCourseTypeCd(courseType);

		// 총 주차수
		mav.addObject("weekTotalCount", elementService.countList(activeElement));

		// 평균 진도율
		mav.addObject("totalProgress", elementService.getTotalResultDatamodelGroup(activeElement));

		// 나의 진도율
		mav.addObject("applyTotalProgress", elementService.getTotalResultDatamodelGroupApply(activeElement));

		// 총 온라인 콘텐츠 강의 갯수
		mav.addObject("onlineItemCount", elementService.getOnlineItemCount(courseActiveSeq));

	}

	/**
	 * 강의실 토론목록 ModelAndView에 셋팅
	 * 
	 * @param courseActiveSeq
	 * @param courseApplySeq
	 */
	public void setDiscussList(ModelAndView mav, Long courseActiveSeq, Long courseApplySeq, String courseType) throws Exception {

		UIUnivCourseDiscussVO discuss = new UIUnivCourseDiscussVO();
		discuss.setCourseActiveSeq(courseActiveSeq);
		discuss.setCourseApplySeq(courseApplySeq);
		discuss.setCourseTypeCd(courseType);

		mav.addObject("discussList", discussService.getListAllCourseDiscussByUser(discuss));
	}

	/**
	 * 강의실 과제목록 ModelAndView에 셋팅
	 * 
	 * @param courseActiveSeq
	 * @param courseApplySeq
	 */
	public void setHomeworkList(ModelAndView mav, Long courseActiveSeq, Long courseApplySeq, String courseType) throws Exception {

		UIUnivCourseHomeworkVO homework = new UIUnivCourseHomeworkVO();
		homework.setCourseActiveSeq(courseActiveSeq);
		homework.setCourseApplySeq(courseApplySeq);
		homework.setCourseTypeCd(courseType);

		mav.addObject("homeworkList", homeworkService.getListHomeworkUsr(homework));
	}

	/**
	 * 강의실 공지사항 목록 ModelAndView에 셋팅
	 * 
	 * @param mav
	 * @param courseActiveSeq
	 * @param courseApplySeq
	 * @throws Exception
	 */
	public void setNoticeList(ModelAndView mav, Long courseActiveSeq, Long courseApplySeq) throws Exception {

		final String boardType = "notice";
		UIUnivCourseActiveBbsCondition condition = new UIUnivCourseActiveBbsCondition();
		emptyValue(condition, "currentPage=1", "perPage=4", "orderby=0");

		condition.setSrchBoardTypeCd("BOARD_TYPE::" + boardType.toUpperCase());
		condition.setSrchCourseActiveSeq(courseActiveSeq);

		if (StringUtil.isNotEmpty(courseActiveSeq)) {
			UIBoardRS detailBoard = getDetailBoard(courseActiveSeq, boardType);

			if (detailBoard != null) {
				Long boardSeq = detailBoard.getBoard().getBoardSeq();

				condition.setSrchBoardSeq(boardSeq);

				// 검색조건 값이 있으면 searchYn을 셋팅.
				if (StringUtil.isNotEmpty(condition.getSrchBbsTypeCd())) {
					condition.setSrchSearchYn("Y");
				}
				if (StringUtil.isNotEmpty(condition.getSrchWord())) {
					condition.setSrchSearchYn("Y");
				}
				if ("Y".equals(condition.getSrchSearchYn()) == false) {
					mav.addObject("alwaysTopList", bbsService.getListCourseAlwaysTop(condition));
					condition.setSrchAlwaysTopYn("N");
				}
				mav.addObject("paginate", bbsService.getList(condition));
				// 기본값으로 재 셋팅한다.
				condition.setPerPage(Constants.DEFAULT_PERPAGE);
			}
		}
	}

	/**
	 * 강의실 시험목록 ModelAndView에 셋팅
	 * 
	 * @param mav
	 * @param courseActiveSeq
	 * @param courseApplySeq
	 * @throws Exception
	 */
	public void setExamPaperList(ModelAndView mav, Long courseActiveSeq, Long courseApplySeq) throws Exception {

		UIUnivCourseActiveExamPaperVO examPaper = new UIUnivCourseActiveExamPaperVO();
		examPaper.setCourseActiveSeq(courseActiveSeq);
		examPaper.setCourseApplySeq(courseApplySeq);

		mav.addObject("examPaperList", courseActiveExamPaperService.getExamPaperByApplyMember(examPaper));
	}

	/**
	 * 강의실 설문목록 ModelAndView에 셋팅
	 * 
	 * @param mav
	 * @param courseActiveSeq
	 * @param courseApplySeq
	 * @throws Exception
	 */
	public void setSurveyPaperList(ModelAndView mav, Long courseActiveSeq, Long courseApplySeq, String courseType) throws Exception {

		UIUnivCourseActiveSurveyVO survey = new UIUnivCourseActiveSurveyVO();
		survey.setCourseActiveSeq(courseActiveSeq);
		survey.setCourseApplySeq(courseApplySeq);
		survey.setCourseTypeCd(courseType);

		// 설문지 구분용 값
		survey.setSurveySubjectTypeCd("SURVEY_SUBJECT_TYPE::COURSE");

		mav.addObject("surveyPaperList", courseActiveSurveyService.getListForClassroom(survey));
	}

	/**
	 * 강의실 퀴즈목록 ModelAndView에 셋팅
	 * 
	 * @param mav
	 * @param courseActiveSeq
	 * @param courseApplySeq
	 * @throws Exception
	 */
	public void setQuizList(ModelAndView mav, Long courseActiveSeq, Long courseApplySeq, String courseType) throws Exception {

		UIUnivCourseActiveExamPaperVO examPaper = new UIUnivCourseActiveExamPaperVO();
		examPaper.setCourseActiveSeq(courseActiveSeq);
		examPaper.setCourseApplySeq(courseApplySeq);
		examPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::QUIZ");
		examPaper.setReferenceTypeCd("COURSE_ELEMENT_TYPE::QUIZ");
		examPaper.setCourseTypeCd(courseType);

		mav.addObject("quizList", courseActiveExamPaperService.getQuizByApplyMember(examPaper));
	}

	/**
	 * 강의실 비학위시험목록 ModelAndView에 셋팅
	 * 
	 * @param mav
	 * @param courseActiveSeq
	 * @param courseApplySeq
	 * @throws Exception
	 */
	public void setExamPaperNonDegreeList(ModelAndView mav, Long courseActiveSeq, Long courseApplySeq, String courseType) throws Exception {

		UIUnivCourseActiveExamPaperVO examPaper = new UIUnivCourseActiveExamPaperVO();
		examPaper.setCourseActiveSeq(courseActiveSeq);
		examPaper.setCourseApplySeq(courseApplySeq);
		examPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::EXAM");
		examPaper.setReferenceTypeCd("COURSE_ELEMENT_TYPE::EXAM");
		examPaper.setCourseTypeCd(courseType);

		mav.addObject("examPaperNonDegreeList", courseActiveExamPaperService.getQuizByApplyMember(examPaper));
	}

	/**
	 * 게시판 상세정보
	 * 
	 * @param referenceSeq
	 * @param boardType
	 * @return UIBoardRS
	 * @throws Exception
	 */
	public UIBoardRS getDetailBoard(Long referenceSeq, String boardType) throws Exception {

		return (UIBoardRS)boardService.getDetailByReference(BOARD_REFERENCE_TYPE, referenceSeq, "BOARD_TYPE::" + boardType.toUpperCase());
	}
}
