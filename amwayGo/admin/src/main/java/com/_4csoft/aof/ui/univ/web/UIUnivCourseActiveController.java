/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.codec.Base64;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.AttachVO;
import com._4csoft.aof.infra.vo.CodeVO;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.service.UIUnivCourseActiveService;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActivePlanVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseAttendEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCoursePostEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseQuizAnswerVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCategoryCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveBbsCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveRS;
import com._4csoft.aof.univ.service.UnivCourseActiveBbsService;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseActiveExamPaperService;
import com._4csoft.aof.univ.service.UnivCourseActivePlanService;
import com._4csoft.aof.univ.service.UnivCourseActiveSurveyService;
import com._4csoft.aof.univ.service.UnivCourseAttendEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseDiscussService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkService;
import com._4csoft.aof.univ.service.UnivCoursePostEvaluateService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectService;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivCourseActiveVO;
import com._4csoft.aof.univ.vo.UnivYearTermVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseMasterController.java
 * @Title : 교과목 관리
 * @date : 2014. 2. 18.
 * @author : 서진철
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivCourseActiveController extends BaseController {

	@Resource (name = "UIUnivCourseActiveService")
	private UIUnivCourseActiveService courseActiveService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	@Resource (name = "CodeService")
	private CodeService codeService;

	@Resource (name = "UnivCourseActivePlanService")
	private UnivCourseActivePlanService courseActivePlanService;

	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService elementService;

	@Resource (name = "UnivCourseHomeworkService")
	private UnivCourseHomeworkService courseHomeworkService;

	@Resource (name = "UnivCourseDiscussService")
	private UnivCourseDiscussService univCourseDiscussService;

	@Resource (name = "UnivCourseActiveExamPaperService")
	private UnivCourseActiveExamPaperService courseActiveExamPaperService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	@Resource (name = "UnivCoursePostEvaluateService")
	private UnivCoursePostEvaluateService coursePostEvaluateService;

	@Resource (name = "UnivCourseAttendEvaluateService")
	private UnivCourseAttendEvaluateService courseAttendEvaluateService;

	@Resource (name = "UnivCourseActiveSurveyService")
	private UnivCourseActiveSurveyService courseActiveSurveyService;

	@Resource (name = "UnivCourseTeamProjectService")
	private UnivCourseTeamProjectService courseTeamProjectService;

	@Resource (name = "UnivCourseActiveBbsService")
	private UnivCourseActiveBbsService bbsService;

	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService courseActiveEvaluateService;

	private final String BOARD_REFERENCE_TYPE = "course";

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

	/**
	 * 학위 개설과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/list.do")
	public ModelAndView listDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 관리자 이외 사용자는 담당 과목만 볼수 있다.
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		if (!"ADM".equals(ssMember.getCurrentRoleCfString())) {
			condition.setSrchMemberSeq(ssMember.getMemberSeq());
		}

		// 시스템에 설정된 년도학기
		if (StringUtil.isEmpty(condition.getSrchYearTerm())) {
			if (ssMember.getExtendData().get("systemYearTerm") == null) {
				/** TODO: 코드 */
				// 현재 년도의 1학기로 셋팅한다.
				String defaultTerm = "10";
				String yearTerm = DateUtil.getTodayYear() + defaultTerm;
				condition.setSrchYearTerm(yearTerm);
			} else {
				UnivYearTermVO univYearTermVO = (UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm");
				condition.setSrchYearTerm(univYearTermVO.getYearTerm());
			}
		}

		// 학위 과목
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::DEGREE");

		// 검색 조건의 년도학기
		mav.addObject("yearTerms", univYearTermService.getListYearTermAll());
		mav.addObject("paginate", courseActiveService.getListCourseActive(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseActive/listCourseActive");
		return mav;
	}

	/**
	 * 학위 개설과목 목록 팝업화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/list/popup.do")
	public ModelAndView listDegreePopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=5", "orderby=0");

		/** TODO : 코드 */
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		// 시스템에 설정된 년도학기
		if (StringUtil.isEmpty(condition.getSrchYearTerm())) {
			if (ssMember.getExtendData().get("systemYearTerm") == null) {
				/** TODO: 코드 */
				// 현재 년도의 1학기로 셋팅한다.
				String defaultTerm = "10";
				String yearTerm = DateUtil.getTodayYear() + defaultTerm;
				condition.setSrchYearTerm(yearTerm);
			} else {
				UnivYearTermVO univYearTermVO = (UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm");
				condition.setSrchYearTerm(univYearTermVO.getYearTerm());
			}
		}

		// 학위 과목
		/** TODO : 코드 */
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::DEGREE");

		// 검색 조건의 년도학기
		mav.addObject("yearTerms", univYearTermService.getListYearTermAll());
		mav.addObject("paginate", courseActiveService.getListCourseActive(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseActive/listCourseActivePopup");
		return mav;
	}

	/**
	 * 비학위 개설과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/non/list.do")
	public ModelAndView listNonDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 관리자 이외 사용자는 담당 과목만 볼수 있다.
		/** TODO : 코드 */
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		if (!"ADM".equals(ssMember.getCurrentRoleCfString())) {
			condition.setSrchMemberSeq(ssMember.getMemberSeq());
		}

		// 시스템에 설정된 년도
		if (StringUtil.isEmpty(condition.getSrchYear())) {
			if (ssMember.getExtendData().get("systemYearTerm") == null) {
				// 현재 년도로 셋팅한다.
				condition.setSrchYear(String.valueOf(DateUtil.getTodayYear()));
			} else {
				UnivYearTermVO univYearTermVO = (UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm");
				condition.setSrchYear(univYearTermVO.getYear());
			}
		}

		// 비학위 과목
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::NONDEGREE");

		if (StringUtil.isEmpty(condition.getSrchCourseTypeCd())) {
			condition.setSrchCourseTypeCd("COURSE_TYPE::PERIOD");
		}

		if (StringUtil.isEmpty(condition.getSrchCourseActiveStatusCd())) {
			condition.setSrchCourseActiveStatusCd("ALL");
		}

		// 검색 조건의 년도
		mav.addObject("years", univYearTermService.getListYearAll());
		mav.addObject("paginate", courseActiveService.getListCourseActive(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseActive/listCourseActive");
		return mav;
	}

	/**
	 * 학위 개설과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIUnivCourseActiveCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		vo.copyShortcut();

		UIUnivCourseActiveRS detailRs = (UIUnivCourseActiveRS)courseActiveService.getDetailCourseActive(vo);
		System.out.println("1");
		if (detailRs.getCourseActive().getAttachList() != null && !detailRs.getCourseActive().getAttachList().isEmpty()) {
			System.out.println("2");
			AttachVO attach = detailRs.getCourseActive().getAttachList().get(0);

			if(!attach.getSavePath().isEmpty() && attach.getSavePath() != null){
				String bankImage = Constants.UPLOAD_PATH_FILE + attach.getSavePath() + "/" + attach.getSaveName();
				BufferedImage img = ImageIO.read(new File(bankImage));
	
				String imageType = attach.getRealName().split("[.]")[1];
				ByteArrayOutputStream bos = new ByteArrayOutputStream();
	
				try {
					System.out.println("3");
					ImageIO.write(img, imageType, bos);
					byte[] imageBytes = bos.toByteArray();
	
					byte[] bytesEncoded = Base64.encode(imageBytes);
					mav.addObject("timeTable", new String(bytesEncoded));
					mav.addObject("imagType", imageType);
	
					bos.close();
				} catch (IOException e) {
					System.out.println("4");
					e.printStackTrace();
				} finally {
					System.out.println("5");
					if (bos != null) {
						bos.close();
					}
	
				}
			}
		}
		mav.addObject("detail", detailRs);
		
		mav.addObject("condition", condition);
		System.out.println("6");
		mav.setViewName("/univ/courseActive/detailCourseActive");
		return mav;
	}

	/**
	 * 비학위 개설과목 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIUnivCourseActiveCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", courseActiveService.getDetailCourseActive(vo));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseActive/editCourseActive");
		return mav;
	}

	/**
	 * 비학위 개설과목 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		// 오픈 시작기간
		if (StringUtil.isNotEmpty(vo.getOpenStartDate())) {
			vo.setOpenStartDate(DateUtil.convertStartDate(vo.getOpenStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		}
		// 오픈 종료기간
		if (StringUtil.isNotEmpty(vo.getOpenEndDate())) {
			vo.setOpenEndDate(DateUtil.convertEndDate(vo.getOpenEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		}

		// 수강신청 시작기간
		if (StringUtil.isNotEmpty(vo.getApplyStartDate())) {
			vo.setApplyStartDate(DateUtil.convertStartDate(vo.getApplyStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}
		// 수강신청 종료기간
		if (StringUtil.isNotEmpty(vo.getApplyEndDate())) {
			vo.setApplyEndDate(DateUtil.convertEndDate(vo.getApplyEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		}

		// 수강 취소 시작기간
		if (StringUtil.isNotEmpty(vo.getCancelStartDate())) {
			vo.setCancelStartDate(DateUtil.convertStartDate(vo.getCancelStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}
		// 수강 취소 종료기간
		if (StringUtil.isNotEmpty(vo.getCancelEndDate())) {
			vo.setCancelEndDate(DateUtil.convertEndDate(vo.getCancelEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		}

		// 학습 시작기간
		if (StringUtil.isNotEmpty(vo.getStudyStartDate())) {
			vo.setStudyStartDate(DateUtil.convertStartDate(vo.getStudyStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}
		// 학습 종료기간
		if (StringUtil.isNotEmpty(vo.getStudyEndDate())) {
			vo.setStudyEndDate(DateUtil.convertEndDate(vo.getStudyEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		}

		// 복습 종료일
		if (StringUtil.isNotEmpty(vo.getResumeEndDate())) {
			vo.setResumeEndDate(DateUtil.convertEndDate(vo.getResumeEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		}

		courseActiveService.updateCourseActive(vo, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * Mooc 개설과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/mooc/list.do")
	public ModelAndView listMoocDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 관리자 이외 사용자는 담당 과목만 볼수 있다.
		/** TODO : 코드 */
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		if (!"ADM".equals(ssMember.getCurrentRoleCfString())) {
			condition.setSrchMemberSeq(ssMember.getMemberSeq());
		}

		// 시스템에 설정된 년도
		if (StringUtil.isEmpty(condition.getSrchYear())) {
			if (ssMember.getExtendData().get("systemYearTerm") == null) {
				/** TODO: 코드 */
				// 현재 년도로 셋팅한다.
				condition.setSrchYear(String.valueOf(DateUtil.getTodayYear()));
			} else {
				UnivYearTermVO univYearTermVO = (UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm");
				condition.setSrchYear(univYearTermVO.getYear());
			}
		}

		// Mook 과목
		condition.setSrchCategoryTypeCd("CATEGORY_TYPE::MOOC");

		if (StringUtil.isEmpty(condition.getSrchCourseTypeCd())) {
			condition.setSrchCourseTypeCd("COURSE_TYPE::PERIOD");
		}

		// 검색 조건의 년도
		mav.addObject("years", univYearTermService.getListYearAll());
		mav.addObject("paginate", courseActiveService.getListCourseActive(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseActive/listCourseActive");
		return mav;
	}

	/**
	 * 담당 개설과목 목록 Ajax
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/list/ajax.do")
	public ModelAndView getListChargeOfCourseActive(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		if (StringUtil.isNotEmpty(vo.getShortcutYearTerm()) && StringUtil.isNotEmpty(vo.getShortcutCourseActiveSeq())) {
			// 개설과목 목록 combo
			mav.addObject("comboListCourseActive",
					courseActiveService.getListChargeOfCourseActive(ssMember.getMemberSeq(), vo.getShortcutYearTerm(), vo.getShortcutCategoryTypeCd()));
		}

		mav.setViewName("/univ/include/commonCourseActiveAjax");
		return mav;
	}

	/**
	 * 교과목 구성정보 다중 복사 팝업화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/copylist/popup.do")
	public ModelAndView createCopyCourseListActive(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo,
			UIUnivCourseActiveCondition activeCondition, UIUnivCategoryCondition categoryCondition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		String year = vo.getYearTerm().substring(0, 4);
		String term = vo.getYearTerm().substring(4, 6);
		// 이전학기
		String beforeYearTerm = (Integer.parseInt(year) - 1) + term;

		List<UIUnivCourseActiveVO> voList = new ArrayList<UIUnivCourseActiveVO>();
		for (String index : vo.getCheckkeys()) {
			UIUnivCourseActiveVO o = new UIUnivCourseActiveVO();
			o.setCourseMasterSeq(vo.getCourseMasterSeqs()[Integer.parseInt(index)]);
			o.setCourseActiveSeq(vo.getCourseActiveSeqs()[Integer.parseInt(index)]);
			o.setYearTerm(vo.getYeatTerm());
			o.setCourseActiveTitle(vo.getCourseActiveTitles()[Integer.parseInt(index)]);

			// 이전 년도 학기
			o.setYear(year);
			o.setTerm(term);
			o.setBeforeYearTerm(beforeYearTerm);

			activeCondition.setSrchYearTerm(beforeYearTerm);
			activeCondition.setSrchCourseMasterSeq(o.getCourseMasterSeq());
			activeCondition.setSrchTargetCourseActiveSeq(o.getCourseActiveSeq());

			// 년도학기, 학과, 운영에 해당하는 따른 과목 정보
			o.setCourseActiveRS(courseActiveService.getDetailCopyTargetCourseActive(activeCondition));

			voList.add(o);
		}
		// 선택, 복사 정보
		mav.addObject("itemList", voList);

		List<CodeVO> listCodeCache = codeService.getListCodeCache("COURSE_ELEMENT_TYPE");
		List<CodeVO> codes = new ArrayList<CodeVO>();

		for (CodeVO code : listCodeCache) {
			// 구성정보 제외 항목 : 중간/기말,팀프로젝트,온라인출석
			if (!code.getCode().equals("COURSE_ELEMENT_TYPE::EXAM")) {
				CodeVO tempCode = new CodeVO();
				tempCode.setCode(code.getCode());
				tempCode.setCodeName(code.getCodeName());

				codes.add(tempCode);
			}
		}

		List<CodeVO> listBoardCodeCache = codeService.getListCodeCache("BOARD_TYPE");

		for (CodeVO code : listBoardCodeCache) {
			// 교직원 게시판, 성적이의신청, FAQ 게시판은 제외한다.
			if (!code.getCode().endsWith("STAFF") && !code.getCode().endsWith("APPEAL") && !code.getCode().endsWith("FAQ")
					&& !code.getCode().endsWith("BOARD_TYPE::OCWNOTICE") && !code.getCode().endsWith("BOARD_TYPE::OCWCONTACT")) {
				CodeVO tempCode = new CodeVO();
				tempCode.setCode(code.getCode());
				tempCode.setCodeName(code.getCodeName());

				codes.add(tempCode);
			}
		}

		// 구성정보 코드
		mav.addObject("elements", codes);

		mav.setViewName("/univ/courseActive/createCopyListElementPopup");
		return mav;
	}

	/**
	 * 교과목 구성정보 복사 팝업화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/copy/popup.do")
	public ModelAndView createCopyCourseActive(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo,
			UIUnivCourseActiveCondition activeCondition, UIUnivCategoryCondition categoryCondition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		mav.addObject("courseActive", vo);

		ResultSet rs = null;
		if (StringUtil.isEmpty(vo.getSourceCourseActiveSeq())) {
			// 상세 화면에서 복사버튼을 누를경우
			String year = vo.getYearTerm().substring(0, 4);
			String term = vo.getYearTerm().substring(4, 6);
			String beforeYearTerm = (Integer.parseInt(year) - 1) + term;

			// 이전 년도 학기
			vo.setYear(year);
			vo.setTerm(term);

			activeCondition.setSrchYearTerm(beforeYearTerm);
			activeCondition.setSrchCourseMasterSeq(vo.getCourseMasterSeq());
			activeCondition.setSrchTargetCourseActiveSeq(vo.getCourseActiveSeq());

			// 년도학기, 학과, 운영에 해당하는 따른 과목 정보
			rs = courseActiveService.getDetailCopyTargetCourseActive(activeCondition);
			mav.addObject("sourceCourseActive", rs);
		} else {
			// 개설과정 팝업에서 복사할 과정을 선택했을 경우
			String year = vo.getYearTerm().substring(0, 4);
			String term = vo.getYearTerm().substring(4, 6);

			// 이전 년도 학기
			vo.setYear(year);
			vo.setTerm(term);
			UIUnivCourseActiveVO courseActive = new UIUnivCourseActiveVO();
			courseActive.setCourseActiveSeq(vo.getSourceCourseActiveSeq());

			rs = courseActiveService.getDetailCourseActive(courseActive);
			mav.addObject("sourceCourseActive", rs);
		}

		// 강의계획서
		if (rs != null) {
			UIUnivCourseActiveVO sourceCourseActive = ((UIUnivCourseActiveRS)rs).getCourseActive();
			UIUnivCourseActivePlanVO plan = new UIUnivCourseActivePlanVO();
			plan.setCourseActiveSeq(sourceCourseActive.getCourseActiveSeq());
			mav.addObject("detailPlan", courseActivePlanService.getDetailCourseActivePlan(plan));
		}

		// 선택, 복사 정보
		mav.addObject("targetCourseActive", vo);

		List<CodeVO> listCodeCache = codeService.getListCodeCache("COURSE_ELEMENT_TYPE");
		List<CodeVO> codes = new ArrayList<CodeVO>();

		for (CodeVO code : listCodeCache) {
			// 구성정보 제외 항목 : 중간/기말,팀프로젝트,온라인출석
			if (!code.getCode().equals("COURSE_ELEMENT_TYPE::EXAM")) {
				CodeVO tempCode = new CodeVO();
				tempCode.setCode(code.getCode());
				tempCode.setCodeName(code.getCodeName());

				codes.add(tempCode);
			}
		}

		List<CodeVO> listBoardCodeCache = codeService.getListCodeCache("BOARD_TYPE");

		for (CodeVO code : listBoardCodeCache) {
			// 교직원 게시판, 성적이의신청, FAQ 게시판은 제외한다.
			if (!code.getCode().endsWith("STAFF") && !code.getCode().endsWith("APPEAL") && !code.getCode().endsWith("FAQ")
					&& !code.getCode().endsWith("BOARD_TYPE::OCWNOTICE") && !code.getCode().endsWith("BOARD_TYPE::OCWCONTACT")

			) {
				CodeVO tempCode = new CodeVO();
				tempCode.setCode(code.getCode());
				tempCode.setCodeName(code.getCodeName());

				codes.add(tempCode);
			}
		}

		// 구성정보 코드
		mav.addObject("elements", codes);
		mav.addObject("condition", categoryCondition);

		mav.setViewName("/univ/courseActive/createCopyElementPopup");
		return mav;
	}

	/**
	 * 개설과목 구성정보 복사
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/copy/save.do")
	public ModelAndView copyCourseActiveElement(HttpServletRequest req, UIUnivCourseActiveVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		List<UnivCourseActiveVO> voList = new ArrayList<UnivCourseActiveVO>();

		for (int j = 0; j < vo.getSourceCourseActiveSeqs().length; j++) {
			UnivCourseActiveVO o = new UnivCourseActiveVO();
			o.setSourceCourseActiveSeq(vo.getSourceCourseActiveSeqs()[j]);
			o.setTargetCourseActiveSeq(vo.getTargetCourseActiveSeqs()[j]);
			o.setCourseElementTypes(vo.getCourseElementTypes());
			o.copyAudit(vo);

			voList.add(o);
		}

		courseActiveService.saveCopyCourseActive(voList);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 신규 개설과목 생성
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param activeCondition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/copylist/non/popup.do")
	public ModelAndView createlistNondegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo, UIUnivCourseActiveCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		// 구성요소 코드
		List<CodeVO> listCodeCache = codeService.getListCodeCache("COURSE_ELEMENT_TYPE");
		List<CodeVO> codes = new ArrayList<CodeVO>();
		for (CodeVO code : listCodeCache) {
			// 구성정보 제외 항목 : 중간/기말,온라인출석
			if (!code.getCode().equals("COURSE_ELEMENT_TYPE::MIDEXAM") && !code.getCode().equals("COURSE_ELEMENT_TYPE::FINALEXAM")) {
				CodeVO tempCode = new CodeVO();
				tempCode.setCode(code.getCode());
				tempCode.setCodeName(code.getCodeName());

				// 상시제일 경우 팀프로젝트, 오프라인출석 제외
				if (condition.getSrchCourseTypeCd().equals("COURSE_TYPE::ALWAYS")
						&& (code.getCode().equals("COURSE_ELEMENT_TYPE::TEAMPROJECT") || code.getCode().equals("COURSE_ELEMENT_TYPE::OFFLINE"))) {
					continue;
				} else {
					codes.add(tempCode);
				}

			}
		}

		// 게시판 코드
		List<CodeVO> listBoardCodeCache = codeService.getListCodeCache("BOARD_TYPE");

		for (CodeVO code : listBoardCodeCache) {
			// 교직원 게시판, 성적이의신청, FAQ 게시판은 제외한다.
			if (!code.getCode().endsWith("STAFF") && !code.getCode().endsWith("APPEAL") && !code.getCode().endsWith("FAQ")
					&& !code.getCode().endsWith("BOARD_TYPE::OCWNOTICE") && !code.getCode().endsWith("BOARD_TYPE::OCWCONTACT")) {
				CodeVO tempCode = new CodeVO();
				tempCode.setCode(code.getCode());
				tempCode.setCodeName(code.getCodeName());

				codes.add(tempCode);
			}
		}
		// 구성정보 코드
		mav.addObject("elements", codes);

		List<UIUnivCourseActiveVO> voList = new ArrayList<UIUnivCourseActiveVO>();
		for (String index : vo.getCheckkeys()) {
			UIUnivCourseActiveVO o = new UIUnivCourseActiveVO();
			o.setCourseActiveSeq(vo.getCourseActiveSeqs()[Integer.parseInt(index)]);
			o.setCourseMasterSeq(vo.getCourseMasterSeqs()[Integer.parseInt(index)]);

			voList.add(o);
		}
		// 선택 정보
		mav.addObject("itemList", voList);

		// 검색 조건의 년도
		mav.addObject("years", univYearTermService.getListYearAll());

		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseActive/createCopyListNondegreePopup");
		return mav;
	}

	/**
	 * 신규 비학위 개설 과목 생성 및 구성정보 복사
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/copy/non/save.do")
	public ModelAndView saveNewNondegree(HttpServletRequest req, UIUnivCourseActiveVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		List<UnivCourseActiveVO> voList = new ArrayList<UnivCourseActiveVO>();

		for (int j = 0; j < vo.getSourceCourseActiveSeqs().length; j++) {
			UnivCourseActiveVO o = new UnivCourseActiveVO();
			o.setSourceCourseActiveSeq(vo.getSourceCourseActiveSeqs()[j]);
			o.setCourseMasterSeq(vo.getCourseMasterSeqs()[j]);
			o.setCourseElementTypes(vo.getCourseElementTypes());
			o.setPeriodNumber(vo.getPeriodNumber());
			o.setYear(vo.getYear());
			o.setCourseActiveTitle(vo.getCourseActiveTitle());
			o.setCourseTypeCd(vo.getCourseTypeCd());
			// 수강승인은 수동으로 기본값 셋팅
			o.setApplyTypeCd("APPLY_TYPE::MANUAL");

			// 오픈 시작기간
			if (StringUtil.isNotEmpty(vo.getOpenStartDate())) {
				o.setOpenStartDate(DateUtil.convertStartDate(vo.getOpenStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
			}
			// 오픈 종료기간
			if (StringUtil.isNotEmpty(vo.getOpenEndDate())) {
				o.setOpenEndDate(DateUtil.convertEndDate(vo.getOpenEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
			}

			// 수강신청 시작기간
			if (StringUtil.isNotEmpty(vo.getApplyStartDate())) {
				o.setApplyStartDate(DateUtil.convertStartDate(vo.getApplyStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
			}
			// 수강신청 종료기간
			if (StringUtil.isNotEmpty(vo.getApplyEndDate())) {
				o.setApplyEndDate(DateUtil.convertEndDate(vo.getApplyEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
			}

			// 수강 취소 시작기간
			if (StringUtil.isNotEmpty(vo.getCancelStartDate())) {
				o.setCancelStartDate(DateUtil.convertStartDate(vo.getCancelStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
			}
			// 수강 취소 종료기간
			if (StringUtil.isNotEmpty(vo.getCancelEndDate())) {
				o.setCancelEndDate(DateUtil.convertEndDate(vo.getCancelEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
			}

			// 학습 시작기간
			if (StringUtil.isNotEmpty(vo.getStudyStartDate())) {
				o.setStudyStartDate(DateUtil.convertStartDate(vo.getStudyStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
			}
			// 학습 종료기간
			if (StringUtil.isNotEmpty(vo.getStudyEndDate())) {
				o.setStudyEndDate(DateUtil.convertEndDate(vo.getStudyEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
			}

			// 복습 종료일
			if (StringUtil.isNotEmpty(vo.getResumeEndDate())) {
				o.setResumeEndDate(DateUtil.convertEndDate(vo.getResumeEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
			}

			o.copyAudit(vo);

			voList.add(o);
		}

		Long courseActiveSeq = courseActiveService.insertNondegreeCourseActive(voList);

		mav.addObject("result", courseActiveSeq);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 비학위의 신규 개설과목 생성
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param activeCondition
	 * @param categoryCondition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/courseactive/copy/non/popup.do")
	public ModelAndView createNondegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActivePlanVO plan, UIUnivCourseActiveVO vo,
			UIUnivCourseActiveCondition activeCondition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		// 구성요소 코드
		List<CodeVO> listCodeCache = codeService.getListCodeCache("COURSE_ELEMENT_TYPE");
		List<CodeVO> codes = new ArrayList<CodeVO>();
		for (CodeVO code : listCodeCache) {
			// 구성정보 제외 항목 : 중간/기말,팀프로젝트,온라인출석
			if (!code.getCode().equals("COURSE_ELEMENT_TYPE::MIDEXAM") && !code.getCode().equals("COURSE_ELEMENT_TYPE::FINALEXAM")) {
				CodeVO tempCode = new CodeVO();
				tempCode.setCode(code.getCode());
				tempCode.setCodeName(code.getCodeName());

				// 상시제일 경우 팀프로젝트, 오프라인출석 제외
				if (activeCondition.getSrchCourseTypeCd().equals("COURSE_TYPE::ALWAYS")
						&& (code.getCode().equals("COURSE_ELEMENT_TYPE::TEAMPROJECT") || code.getCode().equals("COURSE_ELEMENT_TYPE::OFFLINE"))) {
					continue;
				} else {
					codes.add(tempCode);
				}
			}
		}

		// 게시판 코드
		List<CodeVO> listBoardCodeCache = codeService.getListCodeCache("BOARD_TYPE");

		for (CodeVO code : listBoardCodeCache) {
			// 교직원 게시판, 성적이의신청, FAQ 게시판은 제외한다.
			if (!code.getCode().endsWith("STAFF") && !code.getCode().endsWith("APPEAL") && !code.getCode().endsWith("FAQ")
					&& !code.getCode().endsWith("BOARD_TYPE::OCWNOTICE") && !code.getCode().endsWith("BOARD_TYPE::OCWCONTACT")) {
				CodeVO tempCode = new CodeVO();
				tempCode.setCode(code.getCode());
				tempCode.setCodeName(code.getCodeName());

				codes.add(tempCode);
			}
		}
		// 구성정보 코드
		mav.addObject("elements", codes);

		// 선택된 개설과정 상세 정보
		mav.addObject("detailCourseActive", courseActiveService.getDetailCourseActive(vo));

		// 검색 조건의 년도
		mav.addObject("years", univYearTermService.getListYearAll());

		// 강의계획서
		mav.addObject("detailPlan", courseActivePlanService.getDetailCourseActivePlan(plan));

		mav.setViewName("/univ/courseActive/createCopyNondegreePopup");
		return mav;
	}

	/**
	 * 개설과목의 구성정보 상세
	 * 
	 * @param req
	 * @param plan
	 * @param vo
	 * @param element
	 * @param homework
	 * @param discuss
	 * @param examPaper
	 * @param postEvaluate
	 * @param evaluate
	 * @param attend
	 * @param courseActiveSurvey
	 * @param attendEvaluate
	 * @param teamProject
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = { "/univ/courseactive/element/ajax.do", "/univ/courseactive/element/popup.do" })
	public ModelAndView detailCourseActiveElement(HttpServletRequest req, UIUnivCourseActiveVO vo, UIUnivCourseActiveBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("courseActive", vo);

		String courseElementType = vo.getCourseElementType();
		if (courseElementType.startsWith("COURSE_ELEMENT_TYPE")) {
			if ("COURSE_ELEMENT_TYPE::PLAN".equals(courseElementType)) {
				// 강의계획서
				UIUnivCourseActivePlanVO plan = new UIUnivCourseActivePlanVO();
				plan.setCourseActiveSeq(vo.getCourseActiveSeq());
				mav.addObject("detailPlan", courseActivePlanService.getDetailCourseActivePlan(plan));

				mav.setViewName("/univ/courseActive/include/commonCourseActivePlan");
			} else if ("COURSE_ELEMENT_TYPE::EVALUATE".equals(courseElementType)) {
				// 평가기준
				UIUnivCourseActiveEvaluateVO evaluate = new UIUnivCourseActiveEvaluateVO();
				evaluate.setCourseActiveSeq(vo.getCourseActiveSeq());

				mav.addObject("list", courseActiveEvaluateService.getList(evaluate));
				mav.addObject("detail", courseActiveService.getDetailCourseActive(vo));

				mav.setViewName("/univ/courseActive/include/commonCourseActiveEvaluate");
			} else if ("COURSE_ELEMENT_TYPE::ORGANIZATION".equals(courseElementType)) {
				// 주차
				UIUnivCourseActiveElementVO element = new UIUnivCourseActiveElementVO();
				element.setCourseActiveSeq(vo.getCourseActiveSeq());
				element.setReferenceTypeCd(courseElementType);
				mav.addObject("list", elementService.getList(element));

				mav.setViewName("/univ/courseActive/include/commonCourseActiveOraganization");
			} else if ("COURSE_ELEMENT_TYPE::HOMEWORK".equals(courseElementType)) {
				// 과제
				UIUnivCourseHomeworkVO homework = new UIUnivCourseHomeworkVO();
				homework.setCourseActiveSeq(vo.getCourseActiveSeq());
				mav.addObject("itemList", courseHomeworkService.getListHomework(homework));

				mav.setViewName("/univ/courseActive/include/commonHomework");
			} else if ("COURSE_ELEMENT_TYPE::DISCUSS".equals(courseElementType)) {
				// 토론
				UIUnivCourseDiscussVO discuss = new UIUnivCourseDiscussVO();
				discuss.setCourseActiveSeq(vo.getCourseActiveSeq());
				mav.addObject("itemList", univCourseDiscussService.getListCourseDiscuss(discuss));

				mav.setViewName("/univ/courseActive/include/commonDiscuss");
			} else if ("COURSE_ELEMENT_TYPE::QUIZ".equals(courseElementType)) {
				// 퀴즈
				UIUnivCourseActiveExamPaperVO examPaper = new UIUnivCourseActiveExamPaperVO();
				examPaper.setCourseActiveSeq(vo.getCourseActiveSeq());

				mav.addObject("quizList", courseActiveExamPaperService.getList(examPaper));

				mav.setViewName("/univ/courseActive/include/commonCourseActiveQuiz");
			} else if ("COURSE_ELEMENT_TYPE::JOIN".equals(courseElementType)) {
				// 참여
				UIUnivCoursePostEvaluateVO postEvaluate = new UIUnivCoursePostEvaluateVO();
				postEvaluate.setCourseActiveSeq(vo.getCourseActiveSeq());
				mav.addObject("boardList", boardService.getListByReference("course", postEvaluate.getCourseActiveSeq()));

				postEvaluate.setPostType("board");
				mav.addObject("listBoardPostEvaluate", coursePostEvaluateService.getList(postEvaluate));

				mav.setViewName("/univ/courseActive/include/commonPostEvaluate");
			} else if ("COURSE_ELEMENT_TYPE::ONLINE".equals(courseElementType)) {
				// 온라인출석
				UIUnivCourseAttendEvaluateVO attendEvaluate = new UIUnivCourseAttendEvaluateVO();
				attendEvaluate.setCourseActiveSeq(vo.getCourseActiveSeq());
				attendEvaluate.setOnoffCd("ONOFF_TYPE::ON");
				mav.addObject("list", courseAttendEvaluateService.getListCourseAttendEvaluate(attendEvaluate));

				mav.setViewName("/univ/courseActive/include/commonoAttendEvaluateOn");
			} else if ("COURSE_ELEMENT_TYPE::OFFLINE".equals(courseElementType)) {
				// 오프라인출석
				UIUnivCourseActiveElementVO element = new UIUnivCourseActiveElementVO();
				element.setCourseActiveSeq(vo.getCourseActiveSeq());
				element.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
				mav.addObject("listElement", elementService.getOfflineElementList(element));

				UIUnivCourseAttendEvaluateVO evaluate = new UIUnivCourseAttendEvaluateVO();
				evaluate.setCourseActiveSeq(vo.getCourseActiveSeq());
				evaluate.setOnoffCd("ONOFF_TYPE::OFF");
				mav.addObject("list", courseAttendEvaluateService.getListCourseAttendEvaluate(evaluate));

				mav.setViewName("/univ/courseActive/include/commonAttendEvaluateOff");
			} else if ("COURSE_ELEMENT_TYPE::SURVEY".equals(courseElementType)) {
				// 설문
				UIUnivCourseActiveSurveyVO courseActiveSurvey = new UIUnivCourseActiveSurveyVO();
				courseActiveSurvey.setCourseActiveSeq(vo.getCourseActiveSeq());
				// 설문지 구분용 값
				courseActiveSurvey.setSurveySubjectTypeCd("SURVEY_SUBJECT_TYPE::COURSE");

				mav.addObject("surveyList", courseActiveSurveyService.getList(courseActiveSurvey));

				mav.setViewName("/univ/courseActive/include/commonCourseActiveSurvey");
			} else if ("COURSE_ELEMENT_TYPE::EXAM".equals(courseElementType)) {
				// 시험
				UIUnivCourseActiveExamPaperVO examPaper = new UIUnivCourseActiveExamPaperVO();
				examPaper.setCourseActiveSeq(vo.getCourseActiveSeq());
				examPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::EXAM");
				mav.addObject("examList", courseActiveExamPaperService.getList(examPaper));

				mav.setViewName("/univ/courseActive/include/commonCourseExam");
			} else if ("COURSE_ELEMENT_TYPE::MIDEXAM".equals(courseElementType) || "COURSE_ELEMENT_TYPE::FINALEXAM".equals(courseElementType)) {
				// 중간고사
				UIUnivCourseHomeworkVO homework = new UIUnivCourseHomeworkVO();
				homework.setCourseActiveSeq(vo.getCourseActiveSeq());
				homework.setReplaceYn("Y");

				UIUnivCourseActiveExamPaperVO examPaper = new UIUnivCourseActiveExamPaperVO();
				examPaper.setCourseActiveSeq(vo.getCourseActiveSeq());

				if (courseElementType.endsWith("MIDEXAM")) {
					/** TODO : 코드 */
					examPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::MIDDLE");
					homework.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::MIDDLE");
				} else {
					/** TODO : 코드 */
					examPaper.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::FINAL");
					homework.setMiddleFinalTypeCd("MIDDLE_FINAL_TYPE::FINAL");
				}

				mav.addObject("examPaperList", courseActiveExamPaperService.getList(examPaper));
				mav.addObject("homeworkList", courseHomeworkService.getListHomework(homework));

				mav.setViewName("/univ/courseActive/include/commonCourseActiveExamPaper");
			} else if ("COURSE_ELEMENT_TYPE::TEAMPROJECT".equals(courseElementType)) {
				// 팀프로젝트
				UIUnivCourseTeamProjectVO teamProject = new UIUnivCourseTeamProjectVO();
				teamProject.setCourseActiveSeq(vo.getCourseActiveSeq());
				mav.addObject("itemList", courseTeamProjectService.getListCourseTeamProject(teamProject));

				mav.setViewName("/univ/courseActive/include/commonTeamProject");
			}

		} else {
			// 공지사항, 자료실, Q&A,자유게시판, 1:1상담
			emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
			String boardType = courseElementType.split("::")[1].toUpperCase();
			condition.setSrchBoardTypeCd("BOARD_TYPE::" + boardType);
			condition.setSrchCourseActiveSeq(vo.getCourseActiveSeq());

			UIBoardRS detailBoard = getDetailBoard(vo.getCourseActiveSeq(), boardType);

			if (detailBoard != null) {
				Long boardSeq = detailBoard.getBoard().getBoardSeq();

				condition.setSrchBoardSeq(boardSeq);
				condition.setSrchCopyYn("Y");

				// 검색조건 값이 있으면 searchYn을 셋팅.
				if (StringUtil.isNotEmpty(condition.getSrchBbsTypeCd())) {
					condition.setSrchSearchYn("Y");
				}
				if (StringUtil.isNotEmpty(condition.getSrchWord())) {
					condition.setSrchSearchYn("Y");
				}
				if (!"Y".equals(condition.getSrchSearchYn())) {
					mav.addObject("alwaysTopList", bbsService.getListCourseAlwaysTop(condition));
					condition.setSrchAlwaysTopYn("N");
				}
				mav.addObject("paginate", bbsService.getList(condition));

				mav.addObject("condition", condition);
				mav.addObject("detailBoard", detailBoard);
				mav.addObject("boardType", boardType);
			}

			mav.setViewName("/univ/courseActive/include/commonCourseBbs");
		}

		return mav;
	}
	
	/**
	 * 대회시간표보기
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/session/list.do")
	public ModelAndView listSessionRoom(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		requiredSession(req);
		 
		//mav.addObject("itemList", courseQuizAnswerService.getListQuizAnswer(vo));
		mav.addObject("vo", vo);
		
		mav.setViewName("/univ/courseActive/listSession");
		return mav;
	}
	
	/**
	 * 대회시간표보기
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/session/detail.do")
	public ModelAndView detailSessionRoom(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		requiredSession(req);
		 
		//mav.addObject("itemList", courseQuizAnswerService.getListQuizAnswer(vo));
		mav.addObject("vo", vo);
		
		mav.setViewName("/univ/courseActive/detailSession");
		return mav;
	}
	
}
