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

import net.sf.ehcache.Ehcache;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.mapper.BoardMapper;
import com._4csoft.aof.board.service.BbsService;
import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.board.service.CommentService;
import com._4csoft.aof.board.vo.BoardVO;
import com._4csoft.aof.infra.mapper.AttachMapper;
import com._4csoft.aof.infra.mapper.CodeMapper;
import com._4csoft.aof.infra.service.AttachService;
import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.infra.support.Codes;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.AttachVO;
import com._4csoft.aof.infra.vo.CodeVO;
import com._4csoft.aof.infra.vo.base.AttachReferenceVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.board.dto.CommentDTO;
import com._4csoft.aof.ui.board.dto.HelpdeskBbsDTO;
import com._4csoft.aof.ui.board.dto.SystemBoardCategoryDTO;
import com._4csoft.aof.ui.board.dto.SystemBoardDTO;
import com._4csoft.aof.ui.board.vo.UIBbsVO;
import com._4csoft.aof.ui.board.vo.UIBoardVO;
import com._4csoft.aof.ui.board.vo.condition.UICommentCondition;
import com._4csoft.aof.ui.board.vo.resultset.UIBbsRS;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.board.vo.resultset.UICommentRS;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;
import com._4csoft.aof.ui.infra.service.UIAgreementService;
import com._4csoft.aof.ui.infra.service.UXCompetitionService;
import com._4csoft.aof.ui.infra.support.util.UIDateUtil;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UICodeVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.condition.UIAgreementCondition;
import com._4csoft.aof.ui.infra.vo.resultset.UIAgreementRS;
import com._4csoft.aof.ui.infra.vo.resultset.UICodeRS;
import com._4csoft.aof.ui.infra.vo.resultset.UXCompetitionRS;
import com._4csoft.aof.ui.lcms.vo.resultset.UILcmsLearnerDatamodelRS;
import com._4csoft.aof.ui.univ.dto.AttachDTO;
import com._4csoft.aof.ui.univ.dto.CourseActiveElementDTO;
import com._4csoft.aof.ui.univ.dto.LearnerDatamodelDTO;
import com._4csoft.aof.ui.univ.dto.MainAttendDTO;
import com._4csoft.aof.ui.univ.dto.MainInfoDTO;
import com._4csoft.aof.ui.univ.dto.MainNoticeDTO;
import com._4csoft.aof.ui.univ.dto.MainOfflineDTO;
import com._4csoft.aof.ui.univ.dto.MainOnlineDTO;
import com._4csoft.aof.ui.univ.dto.MainProgressDTO;
import com._4csoft.aof.ui.univ.dto.MainReferenceTypeDTO;
import com._4csoft.aof.ui.univ.dto.MyCourseDTO;
import com._4csoft.aof.ui.univ.dto.MyCourseLecturerDTO;
import com._4csoft.aof.ui.univ.dto.OrganizationDTO;
import com._4csoft.aof.ui.univ.dto.ReferenceTypeDTO;
import com._4csoft.aof.ui.univ.dto.YearDTO;
import com._4csoft.aof.ui.univ.dto.YearSetDTO;
import com._4csoft.aof.ui.univ.dto.YearTermDTO;
import com._4csoft.aof.ui.univ.dto.YearTermSetDTO;
import com._4csoft.aof.ui.univ.service.UIUnivCourseActiveBbsService;
import com._4csoft.aof.ui.univ.service.UIUnivCourseActiveElementService;
import com._4csoft.aof.ui.univ.support.UIUnivCourseActiveAttachReference;
import com._4csoft.aof.ui.univ.support.UnivCourseActiveAttachReference;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveBbsVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveExamPaperVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveSurveyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseDiscussVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectVO;
import com._4csoft.aof.ui.univ.vo.UIUnivYearTermVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveBbsCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveLecturerCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveBbsRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveElementRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveExamPaperRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveLecturerRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveSurveyRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseApplyAttendRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseApplyRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseDiscussRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseHomeworkRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseTeamProjectRS;
import com._4csoft.aof.univ.service.UnivCourseActiveBbsService;
import com._4csoft.aof.univ.service.UnivCourseActiveExamPaperService;
import com._4csoft.aof.univ.service.UnivCourseActiveLecturerService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseActiveSurveyService;
import com._4csoft.aof.univ.service.UnivCourseApplyAttendService;
import com._4csoft.aof.univ.service.UnivCourseApplyService;
import com._4csoft.aof.univ.service.UnivCourseDiscussService;
import com._4csoft.aof.univ.service.UnivCourseHomeworkService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectService;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivCourseActiveVO;
import com._4csoft.aof.univ.vo.UnivYearTermVO;

import egovframework.com.cmm.EgovMessageSource;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.api
 * @File : UIClassroomController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 18.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIClassroomController extends UIBaseController {
	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyService courseApplyService;

	@Resource (name = "CodeService")
	private CodeService codeService;

	@Resource (name = "UIUnivCourseActiveElementService")
	private UIUnivCourseActiveElementService elementService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "egovMessageSource")
	EgovMessageSource messageSource;

	@Resource (name = "UnivCourseDiscussService")
	private UnivCourseDiscussService discussService;

	@Resource (name = "UnivCourseHomeworkService")
	private UnivCourseHomeworkService homeworkService;

	@Resource (name = "UnivCourseTeamProjectService")
	private UnivCourseTeamProjectService courseTeamProjectService;

	@Resource (name = "UnivCourseActiveExamPaperService")
	private UnivCourseActiveExamPaperService courseActiveExamPaperService;

	@Resource (name = "UnivCourseActiveSurveyService")
	private UnivCourseActiveSurveyService courseActiveSurveyService;

	@Resource (name = "BoardMapper")
	private BoardMapper boardMapper;

	@Resource (name = "CodeMapper")
	private CodeMapper codeMapper;

	@Resource (name = "UIUnivCourseActiveBbsService")
	private UIUnivCourseActiveBbsService courseBbsService;

	@Resource (name = "BbsService")
	private BbsService bbsService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	@Resource (name = "UnivCourseActiveBbsService")
	private UnivCourseActiveBbsService courseActiveBbsService;

	@Resource (name = "UnivCourseApplyAttendService")
	private UnivCourseApplyAttendService applyAttendService;

	@Resource (name = "CommentService")
	private CommentService commentService;

	private Codes codes = Codes.getInstance();

	@Resource (name = "AttachService")
	private AttachService attachService;

	@Resource (name = "AttachMapper")
	private AttachMapper attachMapper;

	@Resource (name = "UXCompetitionService")
	private UXCompetitionService competitionService;

	@Resource (name = "UnivCourseActiveLecturerService")
	private UnivCourseActiveLecturerService courseActiveLecturerService;

	@Resource (name = "UIUnivCourseActiveAttachReference")
	protected UIUnivCourseActiveAttachReference courseActiveAttachReference;

	@Resource (name = "ehcache")
	protected Ehcache ehCache;
	
	@Resource (name = "UIAgreementService")
	private UIAgreementService agreementService;

	protected final String cacheActiveBoard = "cacheActiveBoard";

	/**
	 * 연도학기 코드목록
	 * 
	 * @param req
	 * @param res
	 * @return json
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/yearTerm/list")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");
		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();

		// 세션체크
		requiredSession(req);

		YearTermDTO dto = new YearTermDTO();
		YearDTO dto1 = new YearDTO();
		// 데이터 세팅

		// 학위 년도학기 가져오기
		UIUnivYearTermVO yearTermVO = (UIUnivYearTermVO)univYearTermService.getSystemYearTerm(SessionUtil.getMember(req).getCurrentRoleCfString());
		dto.setNowYearTerm(yearTermVO.getYearTerm());

		List<YearTermSetDTO> itemList = new ArrayList<YearTermSetDTO>();
		List<UnivYearTermVO> list = univYearTermService.getListYearTermAll();
		for (int i = 0; i < list.size(); i++) {
			UIUnivYearTermVO yearVO = (UIUnivYearTermVO)list.get(i);
			YearTermSetDTO yeatTermDto = new YearTermSetDTO();
			yeatTermDto.setYearTerm(list.get(i).getYearTerm());
			yeatTermDto.setYearTermName(list.get(i).getYearTermName());
			yeatTermDto.setYearTermDate(UIDateUtil.getFormatString(list.get(i).getStudyStartDate(), "yyyy.MM.dd") + "~"
					+ UIDateUtil.getFormatString(list.get(i).getStudyEndDate(), "yyyy.MM.dd"));
			yeatTermDto.setCompetitionYn(yearVO.getCompetitionYn());
			itemList.add(yeatTermDto);
		}
		dto.setCodeList(itemList);

		// 비학위 년도 가져오기
		dto1.setNowYearTerm(Integer.toString(DateUtil.getTodayYear()));
		List<YearSetDTO> itemList1 = new ArrayList<YearSetDTO>();
		List<String> list1 = univYearTermService.getListYearAll();
		for (int i = 0; i < list1.size(); i++) {
			YearSetDTO yearDto = new YearSetDTO();
			yearDto.setYearTerm(list1.get(i).toString());
			yearDto.setYearTermName(list1.get(i) + messageSource.getMessage("필드:개설과목:년도"));

			itemList1.add(yearDto);
		}
		dto1.setCodeList(itemList1);

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);
		mav.addObject("degreeYearTerm", dto);
		mav.addObject("nondegreeYearTerm", dto1);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 수강과정 목록
	 * 
	 * @param req
	 * @param res
	 * @return json
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/apply/list")
	public ModelAndView listMyCourse(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		// final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");
		final String CD_CATEGORY_TYPE_DEGREE = codes.get("CD.CATEGORY_TYPE.DEGREE");
		final String CD_CATEGORY_TYPE_MOOC = codes.get("CD.CATEGORY_TYPE.MOOC");
		final String CD_CATEGORY_TYPE_NONDEGREE = codes.get("CD.CATEGORY_TYPE.NONDEGREE");
		final String CD_CATEGORY_TYPE_OCW = codes.get("CD.CATEGORY_TYPE.OCW");

		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();

		// 세션체크
		try {
			requiredSession(req);
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_1000);
			resultCode = vo.getCode();
			resultMessage = vo.getCodeName();
		}

		// 필수데이터 체크
		UIUnivCourseApplyCondition condition = new UIUnivCourseApplyCondition();
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		if ("0".equals(resultCode)) {
			try {
				condition.setSrchCategoryTypeCd(req.getParameter("categoryTypeCd"));
				condition.setSrchApplyType(req.getParameter("applyType"));
				condition.setSrchYearTerm(req.getParameter("yearTerm"));
				condition.setSrchCompetitionYn(req.getParameter("srchCompetitionYn"));
				condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		List<MyCourseDTO> courseList = new ArrayList<MyCourseDTO>();
		if ("0".equals(resultCode)) {
			// 데이터 세팅
			if ("degree".equals(condition.getSrchCategoryTypeCd())) {
				condition.setSrchCategoryTypeCd(CD_CATEGORY_TYPE_DEGREE);
			} else {
				condition.setSrchYear(req.getParameter("yearTerm"));
				if ("nondegree".equals(condition.getSrchCategoryTypeCd())) {
					condition.setSrchCategoryTypeCd(CD_CATEGORY_TYPE_NONDEGREE);
				} else if ("mook".equals(condition.getSrchCategoryTypeCd())) {
					condition.setSrchCategoryTypeCd(CD_CATEGORY_TYPE_MOOC);
				} else if ("ocw".equals(condition.getSrchCategoryTypeCd())) {
					condition.setSrchCategoryTypeCd(CD_CATEGORY_TYPE_OCW);
				}

			}

			Paginate<ResultSet> paginate = courseApplyService.getListMyCourse(condition);
			if (paginate != null) {
				List<ResultSet> listItem = paginate.getItemList();
				if (listItem != null) {
					for (int i = 0; i < listItem.size(); i++) {
						UIUnivCourseApplyRS rs = (UIUnivCourseApplyRS)listItem.get(i);
						MyCourseDTO dto = new MyCourseDTO();

						dto.setApplyType(rs.getActive().getApplyType());
						dto.setCourseActiveTitle(rs.getActive().getCourseActiveTitle());
						dto.setCourseMasterSeq(rs.getApply().getCourseMasterSeq());
						dto.setCourseTitle(rs.getCourseMaster().getCourseTitle());
						dto.setCourseActiveSeq(rs.getApply().getCourseActiveSeq());
						dto.setCourseApplySeq(rs.getApply().getCourseApplySeq());
						dto.setCancelYn("N");
						if ("APPLY_STATUS::001".equals(rs.getApply().getApplyStatusCd())) {
							dto.setCancelYn("Y");
						}
						dto.setStudyStartDate(rs.getActive().getStudyStartDate());
						dto.setStudyEndDate(rs.getActive().getStudyEndDate());
						dto.setResumeEndDate(rs.getActive().getResumeEndDate());
						dto.setCourseAgreementYn(rs.getActive().getCourseAgreementYn());
						dto.setResumeYn("N");
						if (UIDateUtil.getTodayCompareDate(rs.getApply().getResumeEndDate())) {
							dto.setResumeYn("Y");
						}
						dto.setAvgProgressMeasure(rs.getApply().getAvgProgressMeasure());
						dto.setCategorySeq(rs.getCategory().getCategorySeq());
						dto.setCategoryString(rs.getCategory().getCategoryString());
						dto.setCategoryTypeCd(rs.getCategory().getCategoryTypeCd());

						dto.setCategoryType(getCodeName(rs.getCategory().getCategoryTypeCd()));
						dto.setCourseTypeCd(rs.getActive().getCourseTypeCd());
						dto.setCourseType(getCodeName(dto.getCourseTypeCd()));
						dto.setWorkDay1(rs.getActive().getWorkDay1());
						dto.setWorkDay2(rs.getActive().getWorkDay2());
						dto.setFullDay(rs.getActive().getFullDay());
						dto.setdDay(rs.getActive().getdDay());
						dto.setTeamBbsNewCnt(rs.getBbs().getTeamBbsNewCnt());
						dto.setHrPractice(rs.getApply().getHrPractice());
						dto.setExternelPractice(rs.getApply().getExternelPractice());
						dto.setPanelDiscussion(rs.getApply().getPanelDiscussion());
						String urlPath = config.getString(Constants.CONFIG_SYSTEM_DOMAIN) + config.getString("upload.context.image");

						String timetable1 = rs.getActive().getTimetable1();
						if (StringUtil.isNotEmpty(timetable1)) {
							dto.setTimetable1(urlPath + timetable1);
						}

						String timetable2 = rs.getActive().getTimetable2();
						if (StringUtil.isNotEmpty(timetable2)) {
							dto.setTimetable2(urlPath + timetable2);
						}

						String timetable3 = rs.getActive().getTimetable3();
						if (StringUtil.isNotEmpty(timetable3)) {
							dto.setTimetable3(urlPath + timetable3);
						}

						String timetable4 = rs.getActive().getTimetable4();
						if (StringUtil.isNotEmpty(timetable4)) {
							dto.setTimetable4(urlPath + timetable4);
						}

						String timetable5 = rs.getActive().getTimetable5();
						if (StringUtil.isNotEmpty(timetable5)) {
							dto.setTimetable5(urlPath + timetable5);
						}

						String timetable6 = rs.getActive().getTimetable6();
						if (StringUtil.isNotEmpty(timetable6)) {
							dto.setTimetable6(urlPath + timetable6);
						}
						
						String thumNail = rs.getActive().getThumNail();
						if (StringUtil.isNotEmpty(thumNail)) {
							dto.setThumNail(urlPath + thumNail);
						}

						UIUnivCourseActiveLecturerCondition lecturerCondition = new UIUnivCourseActiveLecturerCondition();
						lecturerCondition.setSrchCourseActiveSeq(dto.getCourseActiveSeq());
						Paginate<ResultSet> lecturePage = courseActiveLecturerService.getListCourseActiveLecturer(lecturerCondition);

						List<MyCourseLecturerDTO> lecturerList = new ArrayList<MyCourseLecturerDTO>();
						if (lecturePage != null && lecturePage.getItemList() != null && lecturePage.getItemList().size() > 0) {
							for (ResultSet leRs : lecturePage.getItemList()) {
								UIUnivCourseActiveLecturerRS lecturerRS = (UIUnivCourseActiveLecturerRS)leRs;
								MyCourseLecturerDTO letDto = new MyCourseLecturerDTO();
								BeanUtils.copyProperties(letDto, lecturerRS.getUnivCourseActiveLecturer());
								letDto.setActiveLecturerType(getCodeName(letDto.getActiveLecturerTypeCd()));
								letDto.setPhoto(urlPath + lecturerRS.getMember().getPhoto());
								letDto.setMemberId(lecturerRS.getMember().getMemberId());
								letDto.setMotto(lecturerRS.getMember().getMotto());
								letDto.setPhoneMobile(lecturerRS.getMember().getPhoneMobile());
								letDto.setPosition(lecturerRS.getMember().getPosition());
								if (StringUtil.isNotEmpty(letDto.getPosition())) {
									letDto.setPositionName(getCodeName(letDto.getPosition()));
								}
								lecturerList.add(letDto);
							}
						}
						dto.setLecturerList(lecturerList);
						AttachVO attch = new AttachVO();
						attch.setReferenceSeq(dto.getCourseActiveSeq());
						AttachReferenceVO voReference = courseActiveAttachReference
								.getAttachReference(UnivCourseActiveAttachReference.UIAttachType.COURSE_ACTIVE_TIME_TABLE);
						attch.setReferenceTablename(voReference.getReferenceTablename());
						attch.setReference(voReference.getReference());
						List<AttachVO> attachList = attachService.getList(attch);

						if (attachList != null && attachList.size() > 0) {
							for (AttachVO attVO : attachList) {
								if (attVO.getReference().equals(voReference.getReference())) {
									dto.setTimeTableUrl("/api/attach/file/response/" + attVO.getAttachSeq() + "/"
											+ StringUtil.encrypt(attVO.getRealName(), Constants.ENCODING_KEY) + "/" + attVO.getSaveName());
								}
							}

						}
						
						UIAgreementCondition agreeCondition = new UIAgreementCondition();
						agreeCondition.setSrchCourseActiveSeq(dto.getCourseActiveSeq());
						UIAgreementCondition getActiveAgreeSeq = agreementService.getActiveAgreeSeq(agreeCondition);
						if(getActiveAgreeSeq != null && (!getActiveAgreeSeq.equals(""))){
							agreeCondition.setSrchAgreeSeq1(getActiveAgreeSeq.getSrchAgreeSeq1());
							agreeCondition.setSrchAgreeSeq2(getActiveAgreeSeq.getSrchAgreeSeq2());
							agreeCondition.setSrchAgreeSeq3(getActiveAgreeSeq.getSrchAgreeSeq3());
							agreeCondition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
						}
						List<ResultSet> agreeListRs = agreementService.getClause(agreeCondition);
						
						List<UIAgreementCondition> agreeList = new ArrayList<UIAgreementCondition>();
						if (agreeListRs != null && !agreeListRs.isEmpty()) {
							for (int j = 0; j < agreeListRs.size(); j++) {
								UIAgreementRS agreeRs = (UIAgreementRS)agreeListRs.get(j);
								
								UIAgreementCondition agreeDto = new UIAgreementCondition();
								BeanUtils.copyProperties(agreeDto, agreeRs.getAgreement());
								
								agreeList.add(agreeDto);
							}
						}
						dto.setAgreeList(agreeList);
						
						List<SystemBoardDTO> boardList = new ArrayList<SystemBoardDTO>();
						List<ResultSet> boardListRs = boardMapper.getListByReference("course", rs.getApply().getCourseActiveSeq());

						if (boardListRs != null && !boardListRs.isEmpty()) {
							for (int j = 0; j < boardListRs.size(); j++) {
								UIBoardRS boardRs = (UIBoardRS)boardListRs.get(j);

								SystemBoardDTO dtoBoard = new SystemBoardDTO();
								BeanUtils.copyProperties(dtoBoard, boardRs.getBoard());

								boardList.add(dtoBoard);
							}
						}

						dto.setBoardList(boardList);
						courseList.add(dto);
					}
				}
			}
		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);
		mav.addObject("totalRowCount", courseList.size());
		mav.addObject("courseList", courseList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 수강취소
	 * 
	 * @param req
	 * @param res
	 * @return json
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/apply/update")
	public ModelAndView updateApply(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");
		final String CD_APPLY_STATUS_003 = codes.get("CD.APPLY_STATUS.003");

		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();

		// 세션체크
		try {
			requiredSession(req);
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_1000);
			resultCode = vo.getCode();
			resultMessage = vo.getCodeName();
		}

		// 필수데이터 체크
		UIUnivCourseApplyVO courseApply = new UIUnivCourseApplyVO();
		if ("0".equals(resultCode)) {
			try {
				courseApply.setCourseApplySeq(Long.parseLong(req.getParameter("courseApplySeq")));
				courseApply.setApplyStatusCd(CD_APPLY_STATUS_003);
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		if ("0".equals(resultCode)) {
			// 데이터 세팅
			try {
				courseApplyService.updateCourseApply(courseApply);
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_9000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 온라인 학습 목록(주차목록)
	 * 
	 * @param req
	 * @param res
	 * @return json
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/element/organization/list")
	public ModelAndView listOrganization(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");
		final String CD_COURSE_ELEMENT_TYPE_ORGANIZATION = codes.get("CD.COURSE_ELEMENT_TYPE.ORGANIZATION");
		final String CD_COURSE_WEEK_TYPE_LECTURE = codes.get("CD.COURSE_WEEK_TYPE.LECTURE");

		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();

		// 세션체크
		try {
			requiredSession(req);
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_1000);
			resultCode = vo.getCode();
			resultMessage = vo.getCodeName();
		}

		// 필수데이터 체크
		UIUnivCourseActiveElementVO activeElement = new UIUnivCourseActiveElementVO();
		if ("0".equals(resultCode)) {
			try {
				activeElement.setCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
				activeElement.setCourseApplySeq(Long.parseLong(req.getParameter("courseApplySeq")));
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		List<OrganizationDTO> weekList = new ArrayList<OrganizationDTO>();
		if ("0".equals(resultCode)) {
			// 데이터 세팅
			try {
				UnivCourseActiveVO activeVo = new UnivCourseActiveVO();
				activeVo.setCourseActiveSeq(activeElement.getCourseActiveSeq());
				UIUnivCourseActiveRS detail = (UIUnivCourseActiveRS)courseActiveService.getDetailCourseActive(activeVo);

				activeElement.setCourseTypeCd(detail.getCourseActive().getCourseTypeCd());
				activeElement.setReferenceTypeCd(CD_COURSE_ELEMENT_TYPE_ORGANIZATION);
				activeElement.setCourseWeekTypeCd(CD_COURSE_WEEK_TYPE_LECTURE);

				List<ResultSet> list = elementService.getListResultDatamodel(activeElement);
				if (list != null) {
					for (int i = 0; i < list.size(); i++) {
						UIUnivCourseActiveElementRS rs = (UIUnivCourseActiveElementRS)list.get(i);

						OrganizationDTO dto = new OrganizationDTO();
						dto.setSortOrder(rs.getElement().getSortOrder());
						dto.setActiveElementTitle(rs.getElement().getActiveElementTitle());
						dto.setStartDtime(UIDateUtil.getFormatString(rs.getElement().getStartDtime(), "yyyy.MM.dd"));
						dto.setEndDtime(UIDateUtil.getFormatString(rs.getElement().getEndDtime(), "yyyy.MM.dd"));

						List<LearnerDatamodelDTO> itemList = new ArrayList<LearnerDatamodelDTO>();
						if (rs.getItemResultList() != null) {
							for (int j = 0; j < rs.getItemResultList().size(); j++) {
								UILcmsLearnerDatamodelRS lcmsRs = rs.getItemResultList().get(j);
								LearnerDatamodelDTO subDto = new LearnerDatamodelDTO();
								Double ProgressMeasure = 0.0;
								String SesstionTime = "";

								subDto.setItemSeq(lcmsRs.getItem().getItemSeq());
								subDto.setTitle(lcmsRs.getItem().getTitle());
								subDto.setAttempt(lcmsRs.getLearnerDatamodel().getAttempt());
								if (lcmsRs.getLearnerDatamodel().getSessionTime() != null && !"".equals(lcmsRs.getLearnerDatamodel().getSessionTime())) {
									int hh = Integer.parseInt(lcmsRs.getLearnerDatamodel().getSessionTime()) / (60 * 60 * 1000);
									int mm = Integer.parseInt(lcmsRs.getLearnerDatamodel().getSessionTime()) % (60 * 60 * 1000) / (60 * 1000);
									int ss = Integer.parseInt(lcmsRs.getLearnerDatamodel().getSessionTime()) % (60 * 1000) / 1000;

									SesstionTime = Integer.toString(hh) + messageSource.getMessage("글:시") + Integer.toString(mm)
											+ messageSource.getMessage("글:분") + Integer.toString(ss) + messageSource.getMessage("글:초");
								}
								subDto.setSessionTime(SesstionTime);
								if (lcmsRs.getLearnerDatamodel().getProgressMeasure() != null && !"".equals(lcmsRs.getLearnerDatamodel().getProgressMeasure())) {
									ProgressMeasure = Double.parseDouble(lcmsRs.getLearnerDatamodel().getProgressMeasure()) * 100;
								}
								subDto.setProgressMeasure(Double.toString(ProgressMeasure));
								subDto.setAttendTypeCd(lcmsRs.getAttend().getAttendTypeCd());
								subDto.setFileName("");
								subDto.setFileUrl("");
								if (lcmsRs.getActiveItem().getAttachList() != null) {
									for (int k = 0; k < lcmsRs.getActiveItem().getAttachList().size(); k++) {
										AttachVO attVO = lcmsRs.getActiveItem().getAttachList().get(k);
										subDto.setFileName(attVO.getRealName());
										subDto.setFileUrl(Constants.UPLOAD_PATH_FILE + attVO.getSavePath() + "/" + attVO.getSaveName());
									}
								}
								subDto.setMobileYn("");
								subDto.setAndroidUrl("");
								subDto.setIosUrl("");

								itemList.add(subDto);
							}
						}
						dto.setItemList(itemList);

						weekList.add(dto);
					}
				}
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_9000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);
		mav.addObject("totalRowCount", weekList.size());
		mav.addObject("weekList", weekList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 유형별 학습 리스트
	 * 
	 * @param req
	 * @param res
	 * @return json
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/element/list")
	public ModelAndView listEvalutaion(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");

		final String CD_COURSE_ELEMENT_TYPE_DISCUSS = codes.get("CD.COURSE_ELEMENT_TYPE.DISCUSS");
		final String CD_COURSE_ELEMENT_TYPE_HOMEWORK = codes.get("CD.COURSE_ELEMENT_TYPE.HOMEWORK");
		final String CD_COURSE_ELEMENT_TYPE_TEAMPROJECT = codes.get("CD.COURSE_ELEMENT_TYPE.TEAMPROJECT");
		final String CD_COURSE_ELEMENT_TYPE_QUIZ = codes.get("CD.COURSE_ELEMENT_TYPE.QUIZ");
		final String CD_COURSE_ELEMENT_TYPE_SURVEY = codes.get("CD.COURSE_ELEMENT_TYPE.SURVEY");
		final String CD_COURSE_ELEMENT_TYPE_EXAM = codes.get("CD.COURSE_ELEMENT_TYPE.EXAM");
		final String CD_MIDDLE_FINAL_TYPE_QUIZ = codes.get("CD.MIDDLE_FINAL_TYPE.QUIZ");
		final String CD_SURVEY_SUBJECT_TYPE_COURSE = codes.get("CD.SURVEY_SUBJECT_TYPE.COURSE");
		final String CD_MIDDLE_FINAL_TYPE_EXAM = codes.get("CD.MIDDLE_FINAL_TYPE.EXAM");
		final String CD_MIDDLE_FINAL_TYPE_MIDDLE = codes.get("CD.MIDDLE_FINAL_TYPE.MIDDLE");
		final String CD_BASIC_SUPPLEMENT_BASIC = codes.get("CD.BASIC_SUPPLEMENT.BASIC");
		final String CD_CATEGORY_TYPE_DEGREE = codes.get("CD.CATEGORY_TYPE.DEGREE");

		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();

		// 세션체크
		try {
			requiredSession(req);
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_1000);
			resultCode = vo.getCode();
			resultMessage = vo.getCodeName();
		}

		// 필수데이터 체크

		Long courseActiveSeq = 0L;
		Long courseApplySeq = 0L;
		String courseType = "";
		if ("0".equals(resultCode)) {
			try {
				courseActiveSeq = Long.parseLong(req.getParameter("courseActiveSeq"));
				courseApplySeq = Long.parseLong(req.getParameter("courseApplySeq"));
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		List<CourseActiveElementDTO> elementList = new ArrayList<CourseActiveElementDTO>();
		if ("0".equals(resultCode)) {
			// 데이터 세팅
			try {
				UnivCourseActiveVO activeVo = new UnivCourseActiveVO();
				activeVo.setCourseActiveSeq(courseActiveSeq);
				UIUnivCourseActiveRS detail = (UIUnivCourseActiveRS)courseActiveService.getDetailCourseActive(activeVo);
				courseType = detail.getCourseActive().getCourseTypeCd();

				UIUnivCourseActiveElementVO activeElement = new UIUnivCourseActiveElementVO();
				activeElement.setCourseActiveSeq(courseActiveSeq);
				activeElement.setCourseApplySeq(courseApplySeq);
				List<UIUnivCourseActiveElementVO> list = elementService.getListElementCount(activeElement);
				if (list != null) {
					for (int i = 0; i < list.size(); i++) {
						CourseActiveElementDTO dto = new CourseActiveElementDTO();
						String referenceTypeName = "";

						List<CodeVO> listCode = codeService.getListCodeCache("COURSE_ELEMENT_TYPE");
						for (CodeVO code : listCode) {
							if (code.getCode().equals(list.get(i).getReferenceTypeCd())) {
								referenceTypeName = code.getCodeName();
							}
						}

						dto.setReferenceTypeName(referenceTypeName);
						dto.setReferenceTypeCd(list.get(i).getReferenceTypeCd());
						dto.setTotalCount(list.get(i).getTotalItemCnt());

						// 토론
						if (CD_COURSE_ELEMENT_TYPE_DISCUSS.equals(list.get(i).getReferenceTypeCd())) {
							UIUnivCourseDiscussVO discuss = new UIUnivCourseDiscussVO();
							discuss.setCourseActiveSeq(courseActiveSeq);
							discuss.setCourseApplySeq(courseApplySeq);
							discuss.setCourseTypeCd(courseType);

							List<ResultSet> discussList = discussService.getListAllCourseDiscussByUser(discuss);
							List<ReferenceTypeDTO> ItemList = new ArrayList<ReferenceTypeDTO>();
							if (discussList != null) {
								for (int j = 0; j < discussList.size(); j++) {
									UIUnivCourseDiscussRS disRs = (UIUnivCourseDiscussRS)discussList.get(j);
									ReferenceTypeDTO d = new ReferenceTypeDTO();

									d.setTypeSeq(disRs.getDiscuss().getDiscussSeq());
									d.setTitle(disRs.getDiscuss().getDiscussTitle());
									d.setStartDtime(UIDateUtil.getFormatString(disRs.getDiscuss().getStartDtime(), "yyyy년 MM월 dd일 HH시 mm분"));
									d.setEndDtime(UIDateUtil.getFormatString(disRs.getDiscuss().getEndDtime(), "yyyy년 MM월 dd일 HH시 mm분"));
									String status = messageSource.getMessage("글:토론:진행중");
									if ("2".equals(disRs.getDiscuss().getDiscussStatus())) {
										status = messageSource.getMessage("글:토론:대기");
									} else if ("3".equals(disRs.getDiscuss().getDiscussStatus())) {
										status = messageSource.getMessage("글:토론:종료");
									}
									d.setStatus(status);
									d.setBbsCount(disRs.getDiscuss().getBbsCount());
									d.setBbsMemberCount(disRs.getDiscuss().getBbsMemberCount());

									ItemList.add(d);
								}
								dto.setReferenceTypeList(ItemList);
							}
						}
						// 과제
						if (CD_COURSE_ELEMENT_TYPE_HOMEWORK.equals(list.get(i).getReferenceTypeCd())) {
							UIUnivCourseHomeworkVO homework = new UIUnivCourseHomeworkVO();
							homework.setCourseActiveSeq(courseActiveSeq);
							homework.setCourseApplySeq(courseApplySeq);
							homework.setCourseTypeCd(courseType);

							List<ResultSet> homeworkList = homeworkService.getListHomeworkUsr(homework);
							List<ReferenceTypeDTO> ItemList = new ArrayList<ReferenceTypeDTO>();
							if (homeworkList != null) {
								for (int j = 0; j < homeworkList.size(); j++) {
									UIUnivCourseHomeworkRS homeRs = (UIUnivCourseHomeworkRS)homeworkList.get(j);
									ReferenceTypeDTO d = new ReferenceTypeDTO();

									d.setTypeSeq(homeRs.getCourseHomework().getHomeworkSeq());
									d.setTitle(homeRs.getCourseHomework().getHomeworkTitle());
									d.setStartDtime(UIDateUtil.getFormatString(homeRs.getCourseHomework().getStartDtime(), "yyyy.MM.dd"));
									d.setEndDtime(UIDateUtil.getFormatString(homeRs.getCourseHomework().getEndDtime(), "yyyy.MM.dd"));
									String kindTypeCd = "";
									List<CodeVO> listCodeCache = codeService.getListCodeCache("BASIC_SUPPLEMENT");
									for (CodeVO code : listCodeCache) {
										if (code.getCode().equals(homeRs.getCourseHomework().getBasicSupplementCd())) {
											kindTypeCd = code.getCodeName();
										}
									}
									d.setKindTypeCd(kindTypeCd);

									String status = messageSource.getMessage("필드:과제응답:진행중");
									if ("2".equals(homeRs.getCourseHomework().getHomeworkStatus())) {
										status = messageSource.getMessage("필드:과제응답:대기");
									} else if ("3".equals(homeRs.getCourseHomework().getHomeworkStatus())) {
										status = messageSource.getMessage("필드:과제응답:종료");
									}
									d.setStatus(status);

									String process = messageSource.getMessage("필드:과제응답:미제출");
									if (!"0".equals(homeRs.getAnswer().getSendDtime()) && "0".equals(homeRs.getAnswer().getSendDtime())) {
										process = messageSource.getMessage("필드:과제응답:제출");
									} else if (UIDateUtil.getTodayCompareDate(homeRs.getCourseHomework().getEndDtime())
											&& !"0".equals(homeRs.getAnswer().getSendDtime()) && "0".equals(homeRs.getAnswer().getSendDtime())) {
										process = messageSource.getMessage("필드:과제응답:채점중");
									} else if (UIDateUtil.getTodayCompareDate(homeRs.getCourseHomework().getEndDtime())
											&& !"0".equals(homeRs.getAnswer().getSendDtime()) && !"0".equals(homeRs.getAnswer().getSendDtime())) {
										process = messageSource.getMessage("필드:과제응답:제출완료");
									}
									d.setProcess(process);
									d.setStartDtimeSec(UIDateUtil.getFormatString(homeRs.getCourseHomework().getStart2Dtime(), "yyyy.MM.dd"));
									d.setEndDtimeSec(UIDateUtil.getFormatString(homeRs.getCourseHomework().getEnd2Dtime(), "yyyy.MM.dd"));

									ItemList.add(d);
								}
								dto.setReferenceTypeList(ItemList);
							}
						}

						// 팀프로젝트
						if (CD_COURSE_ELEMENT_TYPE_TEAMPROJECT.equals(list.get(i).getReferenceTypeCd())) {
							UIUnivCourseTeamProjectVO teamProject = new UIUnivCourseTeamProjectVO();
							teamProject.setCourseActiveSeq(courseActiveSeq);
							teamProject.setRegMemberSeq(SessionUtil.getMember(req).getMemberSeq());

							List<ResultSet> teamList = courseTeamProjectService.getListAllCourseTeamProjectByUser(teamProject);
							List<ReferenceTypeDTO> ItemList = new ArrayList<ReferenceTypeDTO>();
							if (teamList != null) {
								for (int j = 0; j < teamList.size(); j++) {
									UIUnivCourseTeamProjectRS teamRS = (UIUnivCourseTeamProjectRS)teamList.get(j);
									ReferenceTypeDTO d = new ReferenceTypeDTO();

									d.setTypeSeq(teamRS.getCourseTeamProject().getCourseTeamProjectSeq());
									d.setTitle(teamRS.getCourseTeamProject().getTeamProjectTitle());
									d.setStartDtime(UIDateUtil.getFormatString(teamRS.getCourseTeamProject().getStartDtime(), "yyyy.MM.dd"));
									d.setEndDtime(UIDateUtil.getFormatString(teamRS.getCourseTeamProject().getEndDtime(), "yyyy.MM.dd"));

									List<CodeVO> listCodeCache = codeService.getListCodeCache("TEAM_PROJECT_STATUS");
									String status = "";
									for (CodeVO code : listCodeCache) {
										if (code.getCode().equals(teamRS.getCourseTeamProject().getTeamProjectStatusCd())) {
											status = code.getCodeName();
										}
									}
									d.setStatus(status);
									d.setStartDtimeSec(UIDateUtil.getFormatString(teamRS.getCourseTeamProject().getHomeworkStartDtime(), "yyyy.MM.dd"));
									d.setEndDtimeSec(UIDateUtil.getFormatString(teamRS.getCourseTeamProject().getHomeworkEndDtime(), "yyyy.MM.dd"));

									String process = messageSource.getMessage("필드:팀프로젝트:미참여");
									if (teamRS.getCourseActiveBbs().getBbsCount() > 0) {
										process = messageSource.getMessage("필드:팀프로젝트:참여");
									}
									d.setProcess(process);

									String processSec = messageSource.getMessage("필드:팀프로젝트:미제출");
									if (teamRS.getCourseHomeworkAnswer().getHomeworkCount() > 0) {
										processSec = messageSource.getMessage("필드:팀프로젝트:제출");
									}
									d.setProcessSec(processSec);

									ItemList.add(d);
								}
								dto.setReferenceTypeList(ItemList);
							}
						}

						// 퀴즈
						if (CD_COURSE_ELEMENT_TYPE_QUIZ.equals(list.get(i).getReferenceTypeCd())) {
							UIUnivCourseActiveExamPaperVO examPaper = new UIUnivCourseActiveExamPaperVO();
							examPaper.setCourseActiveSeq(courseActiveSeq);
							examPaper.setCourseApplySeq(courseApplySeq);
							examPaper.setMiddleFinalTypeCd(CD_MIDDLE_FINAL_TYPE_QUIZ);
							examPaper.setReferenceTypeCd(CD_COURSE_ELEMENT_TYPE_QUIZ);
							examPaper.setCourseTypeCd(courseType);

							List<ResultSet> quizList = courseActiveExamPaperService.getQuizByApplyMember(examPaper);
							List<ReferenceTypeDTO> ItemList = new ArrayList<ReferenceTypeDTO>();
							if (quizList != null) {
								for (int j = 0; j < quizList.size(); j++) {
									UIUnivCourseActiveExamPaperRS quizRS = (UIUnivCourseActiveExamPaperRS)quizList.get(j);
									ReferenceTypeDTO d = new ReferenceTypeDTO();

									d.setTypeSeq(quizRS.getCourseActiveExamPaper().getCourseActiveExamPaperSeq());
									d.setTitle(quizRS.getCourseActiveExamPaper().getExamPaperTitle());
									d.setStartDtime(UIDateUtil.getFormatString(quizRS.getCourseActiveExamPaper().getStartDtime(), "yyyy.MM.dd"));
									d.setEndDtime(UIDateUtil.getFormatString(quizRS.getCourseActiveExamPaper().getEndDtime(), "yyyy.MM.dd"));

									String status = messageSource.getMessage("글:퀴즈:진행전");
									if (!UIDateUtil.getTodayCompareDate(quizRS.getCourseActiveExamPaper().getStartDtime())) {
										status = messageSource.getMessage("글:퀴즈:진행중");
									}
									if (!UIDateUtil.getTodayCompareDate(quizRS.getCourseActiveExamPaper().getEndDtime())) {
										status = messageSource.getMessage("글:퀴즈:종료");
									}
									d.setStatus(status);

									String process = messageSource.getMessage("필드:퀴즈:미응시");
									if (quizRS.getCourseActiveExamPaper().getCompleteCount() > 0) {
										process = messageSource.getMessage("필드:퀴즈:응시");
									}
									d.setProcess(process);
									d.setLimitTime(quizRS.getCourseActiveExamPaper().getExamTime());

									ItemList.add(d);
								}
								dto.setReferenceTypeList(ItemList);
							}
						}

						// 설문
						if (CD_COURSE_ELEMENT_TYPE_SURVEY.equals(list.get(i).getReferenceTypeCd())) {
							UIUnivCourseActiveSurveyVO survey = new UIUnivCourseActiveSurveyVO();
							survey.setCourseActiveSeq(courseActiveSeq);
							survey.setCourseApplySeq(courseApplySeq);
							survey.setCourseTypeCd(courseType);
							survey.setSurveySubjectTypeCd(CD_SURVEY_SUBJECT_TYPE_COURSE);

							List<ResultSet> surveyList = courseActiveSurveyService.getListForClassroom(survey);
							List<ReferenceTypeDTO> ItemList = new ArrayList<ReferenceTypeDTO>();
							if (surveyList != null) {
								for (int j = 0; j < surveyList.size(); j++) {
									UIUnivCourseActiveSurveyRS surveyRS = (UIUnivCourseActiveSurveyRS)surveyList.get(j);
									ReferenceTypeDTO d = new ReferenceTypeDTO();

									d.setTypeSeq(surveyRS.getCourseActiveSurvey().getSurveyPaperSeq());
									d.setTitle(surveyRS.getSurveyPaper().getSurveyPaperTitle());

									String kindTypeCd = "";
									List<CodeVO> listCodeCache = codeService.getListCodeCache("SURVEY_PAPER_TYPE");
									for (CodeVO code : listCodeCache) {
										if (code.getCode().equals(surveyRS.getSurveyPaper().getSurveyPaperTypeCd())) {
											kindTypeCd = code.getCodeName();
										}
									}
									d.setKindTypeCd(kindTypeCd);
									d.setStartDtime(UIDateUtil.getFormatString(surveyRS.getSurveySubject().getStartDtime(), "yyyy.MM.dd"));
									d.setEndDtime(UIDateUtil.getFormatString(surveyRS.getSurveySubject().getEndDtime(), "yyyy.MM.dd"));

									String status = messageSource.getMessage("글:설문:진행전");
									if (!UIDateUtil.getTodayCompareDate(surveyRS.getSurveySubject().getStartDtime())) {
										status = messageSource.getMessage("글:설문:진행중");
									}
									if (!UIDateUtil.getTodayCompareDate(surveyRS.getSurveySubject().getEndDtime())) {
										status = messageSource.getMessage("글:설문:종료");
									}
									d.setStatus(status);
									String process = messageSource.getMessage("필드:설문:미참여");
									if (surveyRS.getCourseActiveSurvey().getCompleteCount() > 0) {
										process = messageSource.getMessage("필드:설문:참여");
									}
									d.setProcess(process);
									d.setSendDtime(UIDateUtil.getFormatString(surveyRS.getCourseActiveSurvey().getSendDtime(), "yyyy.MM.dd"));

									ItemList.add(d);
								}
								dto.setReferenceTypeList(ItemList);
							}
						}

						// 시험
						if (CD_COURSE_ELEMENT_TYPE_EXAM.equals(list.get(i).getReferenceTypeCd())) {
							if (CD_CATEGORY_TYPE_DEGREE.equals(detail.getCategory().getCategoryTypeCd())) {
								UIUnivCourseActiveExamPaperVO examPaper = new UIUnivCourseActiveExamPaperVO();
								examPaper.setCourseActiveSeq(courseActiveSeq);
								examPaper.setCourseApplySeq(courseApplySeq);

								List<ResultSet> examList = courseActiveExamPaperService.getExamPaperByApplyMember(examPaper);
								List<ReferenceTypeDTO> ItemList = new ArrayList<ReferenceTypeDTO>();
								if (examList != null) {
									for (int j = 0; j < examList.size(); j++) {
										UIUnivCourseActiveExamPaperRS examRS = (UIUnivCourseActiveExamPaperRS)examList.get(j);
										ReferenceTypeDTO d = new ReferenceTypeDTO();

										if ("HOMEWORK".equals(examRS.getCourseHomework().getReferenceType())) {
											d.setTypeSeq(examRS.getCourseHomework().getHomeworkSeq());
											d.setTitle(examRS.getCourseHomework().getHomeworkTitle());
										} else {
											d.setTypeSeq(examRS.getCourseActiveExamPaper().getExamPaperSeq());
											d.setTitle(examRS.getCourseActiveExamPaper().getExamPaperTitle());
										}

										String kindTypeCd = "";
										if (CD_MIDDLE_FINAL_TYPE_MIDDLE.equals(examRS.getCourseActiveExamPaper().getMiddleFinalTypeCd())) {
											if (CD_BASIC_SUPPLEMENT_BASIC.equals(examRS.getCourseActiveExamPaper().getBasicSupplementCd())) {
												if ("EXAM".equals(examRS.getCourseHomework().getReferenceType())) {
													kindTypeCd = messageSource.getMessage("필드:시험:중간고사");
												} else {
													kindTypeCd = messageSource.getMessage("필드:과제:중간고사대체과제");
												}
											} else {
												if ("EXAM".equals(examRS.getCourseHomework().getReferenceType())) {
													kindTypeCd = messageSource.getMessage("필드:시험:중간고사보충시험");
												} else {
													kindTypeCd = messageSource.getMessage("필드:과제:중간고사보충과제");
												}
											}
										} else {
											if (CD_BASIC_SUPPLEMENT_BASIC.equals(examRS.getCourseActiveExamPaper().getBasicSupplementCd())) {
												if ("EXAM".equals(examRS.getCourseHomework().getReferenceType())) {
													kindTypeCd = messageSource.getMessage("필드:시험:기말고사");
												} else {
													kindTypeCd = messageSource.getMessage("필드:과제:기말고사대체과제");
												}
											} else {
												if ("EXAM".equals(examRS.getCourseHomework().getReferenceType())) {
													kindTypeCd = messageSource.getMessage("필드:시험:기말고사보충시험");
												} else {
													kindTypeCd = messageSource.getMessage("필드:과제:기말고사보충과제");
												}
											}
										}
										d.setKindTypeCd(kindTypeCd);

										d.setStartDtime(UIDateUtil.getFormatString(examRS.getCourseActiveExamPaper().getStartDtime(), "yyyy년 MM월 dd일 HH시 mm분"));
										d.setEndDtime(UIDateUtil.getFormatString(examRS.getCourseActiveExamPaper().getEndDtime(), "yyyy년 MM월 dd일 HH시 mm분"));

										String status = messageSource.getMessage("글:시험:진행전");
										if (!UIDateUtil.getTodayCompareDate(examRS.getCourseActiveExamPaper().getStartDtime())) {
											status = messageSource.getMessage("글:시험:진행중");
										}
										if (!UIDateUtil.getTodayCompareDate(examRS.getCourseActiveExamPaper().getEndDtime())) {
											status = messageSource.getMessage("글:시험:종료");
										}
										d.setStatus(status);

										String process = messageSource.getMessage("필드:시험:미응시");
										if (examRS.getCourseActiveExamPaper().getCompleteCount() > 0) {
											process = messageSource.getMessage("필드:시험:응시");
										}
										d.setProcess(process);
										d.setLimitTime(examRS.getCourseActiveExamPaper().getExamTime());

										ItemList.add(d);
									}
									dto.setReferenceTypeList(ItemList);
								}
							} else {
								UIUnivCourseActiveExamPaperVO examPaper = new UIUnivCourseActiveExamPaperVO();
								examPaper.setCourseActiveSeq(courseActiveSeq);
								examPaper.setCourseApplySeq(courseApplySeq);
								examPaper.setMiddleFinalTypeCd(CD_MIDDLE_FINAL_TYPE_EXAM);
								examPaper.setReferenceTypeCd(CD_COURSE_ELEMENT_TYPE_EXAM);
								examPaper.setCourseTypeCd(courseType);

								List<ResultSet> examList = courseActiveExamPaperService.getQuizByApplyMember(examPaper);
								List<ReferenceTypeDTO> ItemList = new ArrayList<ReferenceTypeDTO>();
								if (examList != null) {
									for (int j = 0; j < examList.size(); j++) {
										UIUnivCourseActiveExamPaperRS examRS = (UIUnivCourseActiveExamPaperRS)examList.get(j);
										ReferenceTypeDTO d = new ReferenceTypeDTO();

										d.setTypeSeq(examRS.getCourseActiveExamPaper().getCourseActiveExamPaperSeq());
										d.setTitle(examRS.getCourseActiveExamPaper().getExamPaperTitle());
										d.setStartDtime(UIDateUtil.getFormatString(examRS.getCourseActiveExamPaper().getStartDtime(), "yyyy년 MM월 dd일 HH시 mm분"));
										d.setEndDtime(UIDateUtil.getFormatString(examRS.getCourseActiveExamPaper().getEndDtime(), "yyyy년 MM월 dd일 HH시 mm분"));

										String status = messageSource.getMessage("글:시험:진행전");
										if (!UIDateUtil.getTodayCompareDate(examRS.getCourseActiveExamPaper().getStartDtime())) {
											status = messageSource.getMessage("글:시험:진행중");
										}
										if (!UIDateUtil.getTodayCompareDate(examRS.getCourseActiveExamPaper().getEndDtime())) {
											status = messageSource.getMessage("글:시험:종료");
										}
										d.setStatus(status);

										String process = messageSource.getMessage("필드:시험:미응시");
										if (examRS.getCourseActiveExamPaper().getCompleteCount() > 0) {
											process = messageSource.getMessage("필드:시험:응시");
										}
										d.setProcess(process);
										d.setLimitTime(examRS.getCourseActiveExamPaper().getExamTime());

										ItemList.add(d);
									}
									dto.setReferenceTypeList(ItemList);
								}
							}

						}

						elementList.add(dto);
					}
				}
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_9000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);
		mav.addObject("elementList", elementList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 과정게시판 목록
	 * 
	 * @param req
	 * @param res
	 * @return json
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/board/list")
	public ModelAndView listCourseActiveBoard(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");

		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();

		// 세션체크
		try {
			requiredSession(req);
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_1000);
			resultCode = vo.getCode();
			resultMessage = vo.getCodeName();
		}

		// 필수데이터 체크
		Long courseActiveSeq = 0L;
		if ("0".equals(resultCode)) {
			try {
				courseActiveSeq = Long.parseLong(req.getParameter("courseActiveSeq"));
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		// 데이터세팅
		if ("0".equals(resultCode)) {
			try {
				List<ResultSet> listItem = boardMapper.getListByReference("course", courseActiveSeq);

				List<SystemBoardDTO> boardList = new ArrayList<SystemBoardDTO>();
				if (listItem != null && !listItem.isEmpty()) {
					for (int i = 0; i < listItem.size(); i++) {
						UIBoardRS rs = (UIBoardRS)listItem.get(i);

						SystemBoardDTO dto = new SystemBoardDTO();
						BeanUtils.copyProperties(dto, rs.getBoard());

						boardList.add(dto);
					}
				}

				mav.addObject("totalRowCount", boardList.size());
				mav.addObject("boardList", boardList);
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_9000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 과정게시판 게시판 글 목록
	 * 
	 * @param req
	 * @param res
	 * @return jsonView
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/board/page/list")
	public ModelAndView listBbs(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		String imgURL = config.getString("domain.www") + config.getString("upload.context.image");

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();

		// 세션체크
		try {
			requiredSession(req);
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_1000);
			resultCode = vo.getCode();
			resultMessage = vo.getCodeName();
		}

		// 필수데이터 체크
		UIUnivCourseActiveBbsCondition condition = new UIUnivCourseActiveBbsCondition();
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0", "srchBeforeAfter=after");
		if ("0".equals(resultCode)) {
			try {
				condition.setSrchBoardSeq(Long.parseLong(req.getParameter("srchBoardSeq")));
				condition.setCurrentPage(Integer.parseInt(req.getParameter("currentPage")));
				condition.setPerPage(Integer.parseInt(req.getParameter("perPage")));
				condition.setSrchWord(req.getParameter("srchWord"));
				condition.setSrchKey(req.getParameter("srchKey"));
				condition.setSrchCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
				condition.setSrchClassificationCode(req.getParameter("srchClassificationCode"));
				condition.setSrchBbsSeq(req.getParameter("srchBbsSeq"));
				condition.setSrchBeforeAfter(req.getParameter("srchBeforeAfter"));
				condition.setSrchSearchYn(req.getParameter("commSecretYn"));
				condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
				// 최신 데이터
				if (!StringUtil.isEmpty(HttpUtil.getParameter(req, "srchRecentDay")) && !"0".equals(HttpUtil.getParameter(req, "srchRecentDay"))) {
					condition.setSrchRecentDay(Long.parseLong(req.getParameter("srchRecentDay")));

				}

			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}

			if ("".equals(condition.getSrchKey())) {
				condition.setSrchKey("mobile");
			}
		}

		List<HelpdeskBbsDTO> bbsList = new ArrayList<HelpdeskBbsDTO>();
		BoardVO boardVO = new BoardVO();
		int totalRowCount = 0;
		if ("0".equals(resultCode)) {
			// 게시판 정보
			boardVO = boardMapper.getDetailVO(condition.getSrchBoardSeq());
			condition.setSrchBoardTypeCd(boardVO.getBoardTypeCd());
			// 게시글 목록
			Paginate<ResultSet> paginate = courseBbsService.getList(condition);

			// 데이터 세팅
			if (paginate != null) {
				List<ResultSet> listItem = paginate.getItemList();
				if (listItem != null) {
					for (int i = 0; i < listItem.size(); i++) {
						UIUnivCourseActiveBbsRS rs = (UIUnivCourseActiveBbsRS)listItem.get(i);
						HelpdeskBbsDTO dto = new HelpdeskBbsDTO();
						BeanUtils.copyProperties(dto, rs.getBbs());

						List<AttachDTO> attList = new ArrayList<AttachDTO>();
						if (rs.getBbs().getAttachList() != null) {
							for (int j = 0; j < rs.getBbs().getAttachList().size(); j++) {
								UIAttachVO attVO = (UIAttachVO)rs.getBbs().getAttachList().get(j);
								AttachDTO attDTO = new AttachDTO();
								attDTO.setFileSize(attVO.getFileSize());
								attDTO.setFileType(attVO.getFileType());
								attDTO.setFileName(attVO.getRealName());
								String fileUrl = config.getString("upload.context.file");
								// attDTO.setFileUrl(fileUrl +
								// attVO.getSavePath() + "/" +
								// attVO.getSaveName());
								attDTO.setFileUrl("/api/attach/file/response/" + attVO.getAttachSeq() + "/"
										+ StringUtil.encrypt(attVO.getRealName(), Constants.ENCODING_KEY) + "/" + attVO.getSaveName());

								attList.add(attDTO);
							}

						}
						dto.setAttachList(attList);
						dto.setRegMemberPhoto(imgURL + dto.getRegMemberPhoto());
						List<CodeVO> listCode = codeService.getListCodeCache("POSITION");
						for (CodeVO code : listCode) {
							if (code.getCode().equals(dto.getPosition())) {
								dto.setPosition(code.getCodeName());
							}
						}
						
						dto.setArticleUrl("/api/course/active/board/page/detail/" + dto.getBbsSeq());
						bbsList.add(dto);
					}
				}
			}
			totalRowCount = paginate.getTotalCount();

		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);
		mav.addObject("totalRowCount", totalRowCount);
		mav.addObject("currentPage", condition.getCurrentPage());
		mav.addObject("boardTypeCd", boardVO.getBoardTypeCd());
		mav.addObject("bbsList", bbsList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 게시글 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIBbsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/board/page/delete")
	public ModelAndView deleteBbs(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;

		UIBbsVO bbs = new UIBbsVO();
		requiredSession(req, bbs);

		bbs.setBbsSeq(Long.parseLong(req.getParameter("bbsSeq")));
		bbs.setBoardSeq(Long.parseLong(req.getParameter("boardSeq")));

		ResultSet rs = bbsService.getDetail(bbs);
		if (rs == null) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
		}

		UIBbsRS bbsRS = (UIBbsRS)rs;
		if (!bbsRS.getBbs().getRegMemberSeq().equals(bbs.getRegMemberSeq())) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_ACCESS_DENIED, getErorrMessage(UIApiConstant._INVALID_ACCESS_DENIED));
		}

		try {
			bbsService.deleteBbs(bbs);
		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 게시글 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/board/page/insert")
	public ModelAndView insertBbs(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		checkSession(req);

		String resultCode = UIApiConstant._SUCCESS_CODE;

		UIUnivCourseActiveBbsVO bbs = new UIUnivCourseActiveBbsVO();

		requiredSession(req, bbs);

		bbs.setBoardSeq((Long.parseLong(req.getParameter("boardSeq"))));
		bbs.setCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));
		bbs.setDescription(HttpUtil.getParameter(req, "description"));
		bbs.setBbsTitle(HttpUtil.getParameter(req, "bbsTitle"));
		bbs.setDownloadYn(HttpUtil.getParameter(req, "downloadYn"));
		bbs.setSecretYn(HttpUtil.getParameter(req, "secretYn"));
		bbs.setClassificationCode(HttpUtil.getParameter(req, "classificationCode"));
		
		//모바일 내용을 제목에 삽입하는부분
		String str = HttpUtil.getParameter(req, "description");
		str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>","");
		str.replaceAll("&nbsp;", " ");
		
		if(str.getBytes("ms949").length > 100){
			str = str.substring(0, 50);
		}
		bbs.setBbsTitle(str);
		
		if (StringUtil.isEmpty(bbs.getDownloadYn())) {
			bbs.setDownloadYn("N");
		}

		if (StringUtil.isEmpty(bbs.getSecretYn())) {
			bbs.setSecretYn("N");
		}
		bbs.setBoardTypeCd(HttpUtil.getParameter(req, "boardTypeCd"));

		if (req.getParameter("groupLevel") == null) {
			bbs.setGroupLevel(1L);
		} else {
			bbs.setGroupLevel(Long.parseLong(req.getParameter("groupLevel")));
		}
		if (!StringUtil.isEmpty(req.getParameter("parentSeq"))) {
			bbs.setParentSeq((Long.parseLong(req.getParameter("parentSeq"))));
		} else {
			bbs.setParentSeq(0L);
		}

		bbs.setPushYn(HttpUtil.getParameter(req, "pushYn"));

		emptyValue(bbs, "alwaysTopYn=N", "secretYn=N", "copyYn=N", "evaluateYn=Y", "htmlYn=N", "popupYn=N", "multiRegYn=N", "pushYn=N");

		courseBbsService.insertBbs(bbs, fileAttach(req));

		mav.addObject("resultCode", resultCode);
		mav.addObject("boardSeq", bbs.getBbsSeq());
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 과정게시판 게시판 글 상세
	 * 
	 * @param req
	 * @param res
	 * @return jsonView
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/board/page/detail/{courseActiveSeq}/{bbsSeq}")
	public ModelAndView detailBbs(HttpServletRequest req, HttpServletResponse res, @PathVariable ("courseActiveSeq") Long courseActiveSeq,
			@PathVariable ("bbsSeq") Long bbsSeq) throws Exception {
		ModelAndView mav = new ModelAndView();

		String resultCode = UIApiConstant._SUCCESS_CODE;
		// String imgPath =
		String imgURL = config.getString("domain.www") + config.getString("upload.context.image");
		UIUnivCourseActiveBbsVO vo = new UIUnivCourseActiveBbsVO();
		vo.setBbsSeq(bbsSeq);
		vo.setCourseActiveSeq(courseActiveSeq);
		// 클릭수 업데이트
		bbsService.updateBbsViewCount(vo);

		ResultSet rs = courseBbsService.getDetail(vo);
		if (rs == null) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}

		UIUnivCourseActiveBbsRS bbsRS = (UIUnivCourseActiveBbsRS)rs;

		HelpdeskBbsDTO dto = new HelpdeskBbsDTO();
		BeanUtils.copyProperties(dto, bbsRS.getBbs());

		List<AttachDTO> attList = new ArrayList<AttachDTO>();

		for (int j = 0; j < bbsRS.getBbs().getAttachList().size(); j++) {
			UIAttachVO attVO = (UIAttachVO)bbsRS.getBbs().getAttachList().get(j);
			AttachDTO attDTO = new AttachDTO();
			attDTO.setFileSize(attVO.getFileSize());
			attDTO.setFileType(attVO.getFileType());
			attDTO.setFileName(attVO.getRealName());
			// String fileUrl = config.getString("upload.context.file");
			attDTO.setFileUrl("/api/attach/file/response/" + attVO.getAttachSeq() + "/" + StringUtil.encrypt(attVO.getRealName(), Constants.ENCODING_KEY) + "/"
					+ attVO.getSaveName());

			attList.add(attDTO);
		}
		if (!StringUtil.isEmpty(dto.getRegMemberPhoto())) {
			dto.setRegMemberPhoto(imgURL + dto.getRegMemberPhoto());
		}

		dto.setAttachList(attList);

		UICommentCondition commentCondition = new UICommentCondition();
		commentCondition.setSrchBbsSeq(vo.getBbsSeq());
		commentCondition.setSrchCourseActiveSeq(courseActiveSeq);
		Paginate<ResultSet> commentList = commentService.getList(commentCondition);

		List<CommentDTO> items = new ArrayList<CommentDTO>();
		
		if (commentList != null && commentList.getItemList() != null) {
			for (ResultSet comRs : commentList.getItemList()) {
				UICommentRS commentRS = (UICommentRS)comRs;
				CommentDTO cdto = new CommentDTO();
				BeanUtils.copyProperties(cdto, commentRS.getComment());

				if (!StringUtil.isEmpty(cdto.getRegMemberPhoto())) {
					cdto.setRegMemberPhoto(imgURL + cdto.getRegMemberPhoto());
				}

				if (StringUtil.isNotEmpty(commentRS.getComment().getActiveLecturerTypeCd())) {
					cdto.setProfYn("Y");
					cdto.setActiveLecturerTypeCd(commentRS.getComment().getActiveLecturerTypeCd());
					cdto.setActiveLecturerType(getCodeName(cdto.getActiveLecturerTypeCd()));
				} else {
					cdto.setProfYn("N");
				}
				List<AttachDTO> attachList = new ArrayList<AttachDTO>();
				
				if (null != commentRS.getComment().getAttachList()) {
					for (int j = 0; j < commentRS.getComment().getAttachList().size(); j++) {
						AttachDTO attDTO = new AttachDTO();
						attDTO.setFileSize(commentRS.getComment().getAttachList().get(j).getFileSize());
						attDTO.setFileType(commentRS.getComment().getAttachList().get(j).getFileType());
						attDTO.setFileName(commentRS.getComment().getAttachList().get(j).getRealName());
						String fileUrl = config.getString("upload.context.file");
						// attDTO.setFileUrl(fileUrl +
						// attVO.getSavePath() + "/" +
						// attVO.getSaveName());
						attDTO.setFileUrl("/api/attach/file/response/" + commentRS.getComment().getAttachList().get(j).getAttachSeq() + "/"
								+ StringUtil.encrypt(commentRS.getComment().getAttachList().get(j).getRealName(), Constants.ENCODING_KEY) + "/" + commentRS.getComment().getAttachList().get(j).getSaveName());

						attachList.add(attDTO);
					}
					
				}
				cdto.setCommPhoto(attachList);
				items.add(cdto);
			}
		}

		mav.addObject("item", dto);
		mav.addObject("items", items);
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 과정 카테고리 목록
	 * 
	 * @param req
	 * @param res
	 * @return jsonView
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/board/page/category/list")
	public ModelAndView listCourseActiveAgreement(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");
		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();
		List<SystemBoardCategoryDTO> codeList = new ArrayList<SystemBoardCategoryDTO>();

		// 세션체크
		try {
			requiredSession(req);
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_1000);
			resultCode = vo.getCode();
			resultMessage = vo.getCodeName();
		}

		Long boardSeq = 0L;
		if ("0".equals(resultCode)) {
			try {
				boardSeq = Long.parseLong(req.getParameter("srchBoardSeq"));
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		if ("0".equals(resultCode)) {
			// 데이터 세팅
			try {
				UIBoardVO baordVO = (UIBoardVO)boardMapper.getDetailVO(boardSeq);
				UICodeRS rs = (UICodeRS)codeMapper.getDetail("", baordVO.getBoardTypeCd());

				List<CodeVO> listItem = codeMapper.getListCode(rs.getCode().getCodeNameEx3());
				if (listItem != null) {
					for (int i = 0; i < listItem.size(); i++) {
						UICodeVO codeVO = (UICodeVO)listItem.get(i);
						SystemBoardCategoryDTO dto = new SystemBoardCategoryDTO();

						dto.setCategoryCode(codeVO.getCode());
						dto.setCategoryName(codeVO.getCodeName());

						codeList.add(dto);
					}
				}

			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_9000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);
		mav.addObject("totalRowCount", codeList.size());
		mav.addObject("cateList", codeList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 과정 강의실 홈
	 * 
	 * @param req
	 * @param res
	 * @return json
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/home")
	public ModelAndView main(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");

		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();

		// 세션체크
		try {
			requiredSession(req);
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_1000);
			resultCode = vo.getCode();
			resultMessage = vo.getCodeName();
		}

		// 필수데이터 체크
		Long courseActiveSeq = 0L;
		Long courseApplySeq = 0L;
		String courseType = "";
		if ("0".equals(resultCode)) {
			try {
				courseActiveSeq = Long.parseLong(req.getParameter("courseActiveSeq"));
				courseApplySeq = Long.parseLong(req.getParameter("courseApplySeq"));
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}

		// 데이터세팅
		MainInfoDTO info = new MainInfoDTO();
		MainProgressDTO progress = new MainProgressDTO();
		MainAttendDTO attend = new MainAttendDTO();
		MainOnlineDTO online = new MainOnlineDTO();
		MainOfflineDTO offline = new MainOfflineDTO();
		List<MainReferenceTypeDTO> evalutaionList = new ArrayList<MainReferenceTypeDTO>();
		List<MainNoticeDTO> noticeList = new ArrayList<MainNoticeDTO>();
		if ("0".equals(resultCode)) {
			try {
				UIUnivCourseActiveRS rs = (UIUnivCourseActiveRS)courseActiveService.getDetailCourseActiveByClassroom(courseActiveSeq);
				courseType = rs.getCourseActive().getCourseTypeCd();

				// 강의정보
				List<CodeVO> listCode = codeService.getListCodeCache("COMPLETE_DIVISION");
				String completeDivisionName = "";
				for (CodeVO code : listCode) {
					if (code.getCode().equals(rs.getCourseMaster().getCompleteDivisionCd())) {
						completeDivisionName = code.getCodeName();
					}
				}
				info.setCompleteDivisionName(completeDivisionName);
				info.setCompleteDivisionPoint(rs.getCourseMaster().getCompleteDivisionPoint());
				String profName = "";
				if (rs.getLecturerList() != null) {
					for (int i = 0; i < rs.getLecturerList().size(); i++) {
						UIUnivCourseActiveLecturerRS lecturer = (UIUnivCourseActiveLecturerRS)rs.getLecturerList().get(i);
						if (i > 0) {
							profName += ",";
						}
						profName += lecturer.getUnivCourseActiveLecturer().getProfMemberName();
					}
				}
				info.setProfName(profName);

				UIUnivCourseActiveElementVO activeElement = new UIUnivCourseActiveElementVO();
				activeElement.setCourseActiveSeq(courseActiveSeq);
				activeElement.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
				activeElement.setCourseApplySeq(courseApplySeq);
				activeElement.setCourseTypeCd(courseType);

				// 평균진도율
				UIUnivCourseActiveElementRS progressRS = (UIUnivCourseActiveElementRS)elementService.getTotalResultDatamodelGroup(activeElement);
				progress.setAveragePercent(progressRS.getElement().getTotalProgressMeasure());
				progress.setAveragePoint(progressRS.getElement().getTotalAttendMeasure());
				progress.setAverageMaxPoint(progressRS.getElement().getTotalItemCnt());

				UIUnivCourseActiveElementRS progressApplyRS = (UIUnivCourseActiveElementRS)elementService.getTotalResultDatamodelGroupApply(activeElement);
				progress.setMyPercent(progressApplyRS.getElement().getTotalProgressMeasure());
				progress.setMyPoint(progressApplyRS.getElement().getTotalAttendMeasure());
				progress.setMyMaxPoint(progressApplyRS.getElement().getTotalItemCnt());

				// 출결사항
				attend.setAttend(progressApplyRS.getElement().getAttendTypeAttendCnt());
				attend.setAbsence(progressApplyRS.getElement().getAttendTypeAbsenceCnt());
				attend.setPerception(progressApplyRS.getElement().getAttendTypePerceptionCnt());

				// 공지사항
				final String boardType = "notice";
				UIUnivCourseActiveBbsCondition condition = new UIUnivCourseActiveBbsCondition();
				emptyValue(condition, "currentPage=1", "perPage=4", "orderby=0");

				condition.setSrchBoardTypeCd("BOARD_TYPE::" + boardType.toUpperCase());
				condition.setSrchCourseActiveSeq(courseActiveSeq);

				UIBoardRS detailBoard = (UIBoardRS)boardService.getDetailByReference("course", courseActiveSeq, "BOARD_TYPE::" + boardType.toUpperCase());

				if (detailBoard != null) {
					Long boardSeq = detailBoard.getBoard().getBoardSeq();

					condition.setSrchBoardSeq(boardSeq);
					List<ResultSet> topList = courseActiveBbsService.getListCourseAlwaysTop(condition);
					if (topList != null) {
						for (int i = 0; i < topList.size(); i++) {
							UIUnivCourseActiveBbsRS bbsRs = (UIUnivCourseActiveBbsRS)topList.get(i);
							MainNoticeDTO notice = new MainNoticeDTO();

							notice.setTitle(bbsRs.getBbs().getBbsTitle());
							notice.setDetailUrl("");

							noticeList.add(notice);
						}
					}

					condition.setSrchAlwaysTopYn("N");
					Paginate<ResultSet> paginate = courseActiveBbsService.getList(condition);
					if (paginate != null) {
						List<ResultSet> courseNoticeList = paginate.getItemList();
						if (courseNoticeList != null) {
							for (int i = 0; i < courseNoticeList.size(); i++) {
								UIUnivCourseActiveBbsRS bbsRs = (UIUnivCourseActiveBbsRS)courseNoticeList.get(i);
								MainNoticeDTO notice = new MainNoticeDTO();

								notice.setTitle(bbsRs.getBbs().getBbsTitle());
								notice.setDetailUrl("/api/course/active/board/page/detail/" + bbsRs.getBbs().getBbsSeq());

								noticeList.add(notice);
							}
						}
					}

				}

				// 온라인 강의정보
				online.setTotalWeek(elementService.countList(activeElement));
				online.setTotalLecture(elementService.getOnlineItemCount(courseActiveSeq));
				online.setTotalStudyCount(progressApplyRS.getElement().getAttemptTotal());

				// 오프라인 강의정보
				offline.setTotalLectureCount(applyAttendService.countSumOfflineLessonCount(courseActiveSeq));
				UIUnivCourseApplyAttendRS offlineRS = (UIUnivCourseApplyAttendRS)applyAttendService.getDetailTotalByOffApplyAttend(courseApplySeq);
				offline.setAbsence(offlineRS.getApplyAttend().getAttendTypeAbsenceCnt());
				offline.setAttend(offlineRS.getApplyAttend().getAttendTypeAttendCnt());
				offline.setPerception(offlineRS.getApplyAttend().getAttendTypePerceptionCnt());

				// 유형별 리스트
				List<UIUnivCourseActiveElementVO> list = elementService.getListElementCount(activeElement);
				if (list != null) {
					for (int i = 0; i < list.size(); i++) {
						MainReferenceTypeDTO dto = new MainReferenceTypeDTO();
						String referenceTypeName = "";

						List<CodeVO> listCodeCache = codeService.getListCodeCache("COURSE_ELEMENT_TYPE");
						for (CodeVO code : listCodeCache) {
							if (code.getCode().equals(list.get(i).getReferenceTypeCd())) {
								referenceTypeName = code.getCodeName();
							}
						}

						dto.setReferenceTypeName(referenceTypeName);
						dto.setTotalCount(list.get(i).getTotalItemCnt());

						evalutaionList.add(dto);
					}
				}

			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_9000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
				e.printStackTrace();
			}
		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);

		mav.addObject("info", info);
		mav.addObject("progress", progress);
		mav.addObject("attandance", attend);

		mav.addObject("noticeList", noticeList);
		mav.addObject("online", online);
		mav.addObject("offline", offline);
		mav.addObject("evalutaionList", evalutaionList);

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 연도학기 코드목록
	 * 
	 * @param req
	 * @param res
	 * @return json
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/competition/list")
	public ModelAndView competition(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");

		UICodeVO vo = new UICodeVO();
		
		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);
		UXCompetitionRS rs = (UXCompetitionRS)competitionService.getListCompetition();
		mav.addObject("competition", rs.getCompetition());

		mav.setViewName("jsonView");

		return mav;
	}
	
	
	/**
	 * 과정의 약관내용 가져오기
	 * 
	 * @param req
	 * @param res
	 * @return jsonView
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/clause")
	public ModelAndView listCourseActiveCategory(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_0 = codes.get("CD.ERROR_TYPE.0");
		final String CD_ERROR_TYPE_1000 = codes.get("CD.ERROR_TYPE.1000");
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		final String CD_ERROR_TYPE_9000 = codes.get("CD.ERROR_TYPE.9000");
		ModelAndView mav = new ModelAndView();
		UICodeVO vo = new UICodeVO();

		vo = getCode(CD_ERROR_TYPE_0);
		String resultCode = vo.getCode();
		String resultMessage = vo.getCodeName();

		// 세션체크
		try {
			requiredSession(req);
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_1000);
			resultCode = vo.getCode();
			resultMessage = vo.getCodeName();
		}

		Long activeSeq = 0L;
		if ("0".equals(resultCode)) {
			try {
				activeSeq = Long.parseLong(req.getParameter("srchCourseActiveSeq"));
			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_3000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
		}
		
		UIAgreementCondition agreeCondition = new UIAgreementCondition();
		List<MyCourseDTO> courseList = new ArrayList<MyCourseDTO>();
		
		agreeCondition.setSrchCourseActiveSeq(activeSeq);
		UIAgreementCondition agreeSeq = agreementService.getActiveAgreeSeq(agreeCondition);
		agreeCondition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		if(!"null".equals(agreeSeq.getSrchAgreeSeq1())){
			agreeCondition.setSrchAgreeSeq1(agreeSeq.getSrchAgreeSeq1());
		}
		if(!"null".equals(agreeSeq.getSrchAgreeSeq2())){
			agreeCondition.setSrchAgreeSeq2(agreeSeq.getSrchAgreeSeq2());
		}
		if(!"null".equals(agreeSeq.getSrchAgreeSeq3())){
			agreeCondition.setSrchAgreeSeq3(agreeSeq.getSrchAgreeSeq3());
		}
		
		if ("0".equals(resultCode)) {
			// 데이터 세팅
			
			MyCourseDTO dto = new MyCourseDTO();
			try {
				List<ResultSet> agreeListRs = agreementService.getClause(agreeCondition);
				
				List<UIAgreementCondition> agreeList = new ArrayList<UIAgreementCondition>();
				if (agreeListRs != null && !agreeListRs.isEmpty()) {
					for (int j = 0; j < agreeListRs.size(); j++) {
						UIAgreementRS agreeRs = (UIAgreementRS)agreeListRs.get(j);
						
						UIAgreementCondition agreeDto = new UIAgreementCondition();
						BeanUtils.copyProperties(agreeDto, agreeRs.getAgreement());
						
						agreeList.add(agreeDto);
					}
				}
				dto.setAgreeList(agreeList);

			} catch (Exception e) {
				vo = getCode(CD_ERROR_TYPE_9000);
				resultCode = vo.getCode();
				resultMessage = vo.getCodeName();
			}
			
			courseList.add(dto);
		}

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", resultMessage);
		mav.addObject("totalRowCount", courseList.size());
		mav.addObject("clauseList", courseList);

		mav.setViewName("jsonView");

		return mav;
	}
	
	


}
