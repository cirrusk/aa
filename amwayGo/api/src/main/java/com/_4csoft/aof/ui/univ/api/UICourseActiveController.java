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
import com._4csoft.aof.infra.service.AttachService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.AttachVO;
import com._4csoft.aof.infra.vo.base.AttachReferenceVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.board.dto.SystemBoardDTO;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;
import com._4csoft.aof.ui.infra.service.UIAgreementService;
import com._4csoft.aof.ui.infra.vo.condition.UIAgreementCondition;
import com._4csoft.aof.ui.infra.vo.resultset.UIAgreementRS;
import com._4csoft.aof.ui.univ.dto.CourseActiveDTO;
import com._4csoft.aof.ui.univ.dto.MyCourseLecturerDTO;
import com._4csoft.aof.ui.univ.support.UIUnivCourseActiveAttachReference;
import com._4csoft.aof.ui.univ.support.UnivCourseActiveAttachReference;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveLecturerCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveLecturerRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveRS;
import com._4csoft.aof.univ.service.UnivCourseActiveLecturerService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.api
 * @File : UICourseActiveController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 26.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICourseActiveController extends UIBaseController {

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "UnivCourseActiveLecturerService")
	private UnivCourseActiveLecturerService courseActiveLecturerService;
	@Resource (name = "UIUnivCourseActiveAttachReference")
	protected UIUnivCourseActiveAttachReference courseActiveAttachReference;
	@Resource (name = "AttachService")
	private AttachService attachService;

	@Resource (name = "ehcache")
	protected Ehcache ehCache;

	protected final String cacheActiveBoard = "cacheActiveBoard";

	@Resource (name = "BoardMapper")
	private BoardMapper boardMapper;
	
	@Resource (name = "UIAgreementService")
	private UIAgreementService agreementService;

	/**
	 * 개설과목목록
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/courseactive/list")
	public ModelAndView listNonDegree(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		final String CD_CATEGORY_TYPE_DEGREE = codes.get("CD.CATEGORY_TYPE.DEGREE");
		final String CD_CATEGORY_TYPE_MOOC = codes.get("CD.CATEGORY_TYPE.MOOC");
		final String CD_CATEGORY_TYPE_NONDEGREE = codes.get("CD.CATEGORY_TYPE.NONDEGREE");
		final String CD_CATEGORY_TYPE_OCW = codes.get("CD.CATEGORY_TYPE.OCW");
		String resultCode = UIApiConstant._SUCCESS_CODE;
		checkSession(req);
		UIUnivCourseActiveCondition condition = new UIUnivCourseActiveCondition();

		// 합반 과정은 학습기간이 교육전이라도 목록에 표지되지 않는다.
		// App 에서만 기능이 존재한다.
		condition.setSrchCombinedClassYn("Y");

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		String srchType = HttpUtil.getParameter(req, "srchType");

		if (!"01".equals(srchType) || "01".equals(srchType))

			try {
				if ("01".equals(srchType)) {
					if (StringUtil.isNotEmpty(req.getParameter("courseMasterSeq"))) {
						condition.setSrchCourseMasterSeq(Long.parseLong(req.getParameter("courseMasterSeq")));
					}
				} else {
					condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq()); // 교강사 검색
					condition.setSrchCompetitionYn(req.getParameter("srchCompetitionYn"));
				}
				condition.setSrchYear(HttpUtil.getParameter(req, "year"));
				condition.setSrchCategoryTypeCd(req.getParameter("categoryTypeCd"));
				condition.setCurrentPage(Integer.parseInt(req.getParameter("currentPage")));
				condition.setPerPage(Integer.parseInt(req.getParameter("perPage")));
				condition.setSrchWord(req.getParameter("srchWord"));
				//condition.setOrderby(4);
				condition.setSrchCourseActiveStatusCd("COURSE_ACTIVE_STATUS::OPEN");
				condition.setSrchApplyType(req.getParameter("applyType"));

				if ("degree".equals(condition.getSrchCategoryTypeCd())) {
					condition.setSrchCategoryTypeCd(CD_CATEGORY_TYPE_DEGREE);
				} else {
					if ("nondegree".equals(condition.getSrchCategoryTypeCd())) {
						condition.setSrchCategoryTypeCd(CD_CATEGORY_TYPE_NONDEGREE);
					} else if ("mook".equals(condition.getSrchCategoryTypeCd())) {
						condition.setSrchCategoryTypeCd(CD_CATEGORY_TYPE_MOOC);
					} else if ("ocw".equals(condition.getSrchCategoryTypeCd())) {
						condition.setSrchCategoryTypeCd(CD_CATEGORY_TYPE_OCW);
					}
				}

			} catch (Exception e) {
				throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
			}

		Paginate<ResultSet> paginate = courseActiveService.getListCourseActive(condition);

		List<CourseActiveDTO> items = new ArrayList<CourseActiveDTO>();
		int totalRowCount = 0;
		if (paginate != null && paginate.getItemList() != null && paginate.getItemList().size() > 0) {

			totalRowCount = paginate.getTotalCount();
			for (ResultSet rs : paginate.getItemList()) {
				UIUnivCourseActiveRS courseActiveRS = (UIUnivCourseActiveRS)rs;

				CourseActiveDTO dto = new CourseActiveDTO();
				BeanUtils.copyProperties(dto, courseActiveRS.getCourseActive());
				dto.setCategorySeq(courseActiveRS.getCourseActive().getCategoryOrganizationSeq());
				dto.setCourseTitle(courseActiveRS.getCourseMaster().getCourseTitle());

				dto.setCategoryTypeCd(courseActiveRS.getCategory().getCategoryTypeCd());
				dto.setCategoryType(getCodeName(courseActiveRS.getCategory().getCategoryTypeCd()));
				dto.setCourseTypeCd(courseActiveRS.getCourseActive().getCourseTypeCd());
				dto.setCourseType(getCodeName(dto.getCourseTypeCd()));

				String urlPath = config.getString(Constants.CONFIG_SYSTEM_DOMAIN) + config.getString("upload.context.image");
				String timetable1 = courseActiveRS.getCourseActive().getTimetable1();
				if (StringUtil.isNotEmpty(timetable1)) {
					dto.setTimetable1(urlPath + timetable1);
				}

				String timetable2 = courseActiveRS.getCourseActive().getTimetable2();
				if (StringUtil.isNotEmpty(timetable2)) {
					dto.setTimetable2(urlPath + timetable2);
				}

				String timetable3 = courseActiveRS.getCourseActive().getTimetable3();
				if (StringUtil.isNotEmpty(timetable3)) {
					dto.setTimetable3(urlPath + timetable3);
				}

				String timetable4 = courseActiveRS.getCourseActive().getTimetable4();
				if (StringUtil.isNotEmpty(timetable4)) {
					dto.setTimetable4(urlPath + timetable4);
				}

				String timetable5 = courseActiveRS.getCourseActive().getTimetable5();
				if (StringUtil.isNotEmpty(timetable5)) {
					dto.setTimetable5(urlPath + timetable5);
				}

				String timetable6 = courseActiveRS.getCourseActive().getTimetable6();
				if (StringUtil.isNotEmpty(timetable6)) {
					dto.setTimetable6(urlPath + timetable6);
				}

				dto.setdDay(courseActiveRS.getCourseActive().getdDay());
				dto.setHrPractice(courseActiveRS.getLecturer().getHrPractice());
				dto.setExternelPractice(courseActiveRS.getLecturer().getExternelPractice());
				dto.setPanelDiscussion(courseActiveRS.getLecturer().getPanelDiscussion());
				String thumNail = courseActiveRS.getCourseActive().getThumNail();
				if (StringUtil.isNotEmpty(thumNail)) {
					dto.setThumNail(urlPath + thumNail);
				}
				dto.setApplyType(courseActiveRS.getCourseActive().getApplyType());

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
						letDto.setMotto(lecturerRS.getMember().getMotto());
						letDto.setPhoneMobile(lecturerRS.getMember().getPhoneMobile());
						letDto.setMemberId(lecturerRS.getMember().getMemberId());

						letDto.setPhoto(urlPath + lecturerRS.getMember().getPhoto());
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
				List<ResultSet> boardListRs = boardMapper.getListByReference("course", courseActiveRS.getCourseActive().getCourseActiveSeq());

				if (boardListRs != null && !boardListRs.isEmpty()) {
					for (int j = 0; j < boardListRs.size(); j++) {
						UIBoardRS boardRs = (UIBoardRS)boardListRs.get(j);

						SystemBoardDTO dtoBoard = new SystemBoardDTO();
						BeanUtils.copyProperties(dtoBoard, boardRs.getBoard());

						boardList.add(dtoBoard);
					}
				}

				dto.setBoardList(boardList);

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
	 * 개설과목 상세
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveSeq
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/courseactive/{courseActiveSeq}/detail")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, @PathVariable ("courseActiveSeq") Long courseActiveSeq) throws Exception {
		ModelAndView mav = new ModelAndView();

		String resultCode = UIApiConstant._SUCCESS_CODE;

		UIUnivCourseActiveVO courseActive = new UIUnivCourseActiveVO();

		if (StringUtil.isEmpty(courseActiveSeq)) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		} else {
			courseActive.setCourseActiveSeq(courseActiveSeq);
		}

		UIUnivCourseActiveRS detailRs = (UIUnivCourseActiveRS)courseActiveService.getDetailCourseActive(courseActive);

		CourseActiveDTO dto = new CourseActiveDTO();
		if (detailRs != null) {
			BeanUtils.copyProperties(dto, detailRs.getCourseActive());
			dto.setCategoryString(detailRs.getCategory().getCategoryString());
		}

		if (detailRs.getCourseActive().getAttachList() != null && !detailRs.getCourseActive().getAttachList().isEmpty()) {

			AttachVO attach = detailRs.getCourseActive().getAttachList().get(0);
			dto.setTimeTableUrl("/api/attach/file/response/" + attach.getAttachSeq() + "/" + StringUtil.encrypt(attach.getRealName(), Constants.ENCODING_KEY)
					+ "/" + attach.getSaveName());
		}
		mav.addObject("item", dto);
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");

		return mav;
	}
}
