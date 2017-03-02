/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseMasterCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseMasterRS;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseMasterService;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivCourseActiveVO;
import com._4csoft.aof.univ.vo.UnivCourseMasterVO;

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
public class UIUnivCourseMasterController extends BaseController {

	@Resource (name = "UnivCourseMasterService")
	private UnivCourseMasterService courseMasterService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	/**
	 * 학위 교과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseMasterCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/list.do")
	public ModelAndView listMasterDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		/** TODO : 코드 */
		if (StringUtil.isEmpty(condition.getSrchCategoryTypeCd())) {
			final String degreeType = "CATEGORY_TYPE::DEGREE"; // 학위
			condition.setSrchCategoryTypeCd(degreeType);
		}

		mav.addObject("paginate", courseMasterService.getListCourseMaster(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/coursemaster/listCourseMaster");
		return mav;
	}

	/**
	 * 비학위 교과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseMasterCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/non/list.do")
	public ModelAndView listNonMasterDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		/* TODO : 코드 */
		if (StringUtil.isEmpty(condition.getSrchCategoryTypeCd())) {
			final String degreeType = "CATEGORY_TYPE::NONDEGREE"; // 비학위
			condition.setSrchCategoryTypeCd(degreeType);
		}

		mav.addObject("paginate", courseMasterService.getListCourseMaster(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/coursemaster/listCourseMaster");
		return mav;
	}

	/**
	 * 비학위 교과목 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseMasterCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/mooc/list.do")
	public ModelAndView listMoocMasterDegree(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		/* TODO : 코드 */
		if (StringUtil.isEmpty(condition.getSrchCategoryTypeCd())) {
			final String degreeType = "CATEGORY_TYPE::MOOC"; // 비학위
			condition.setSrchCategoryTypeCd(degreeType);
		}

		mav.addObject("paginate", courseMasterService.getListCourseMaster(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/coursemaster/listCourseMaster");
		return mav;
	}

	/**
	 * 교과목 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseMaster
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterVO vo, UIUnivCourseMasterCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", courseMasterService.getDetailCourseMaster(vo));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/coursemaster/detailCourseMaster");
		return mav;
	}

	/**
	 * 교과목 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param courseMaster
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterVO vo, UIUnivCourseMasterCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", courseMasterService.getDetailCourseMaster(vo));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/coursemaster/editCourseMaster");
		return mav;
	}

	/**
	 * 교과목 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		courseMasterService.deleteCourseMaster(vo);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 교과목 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		List<UnivCourseMasterVO> courseMasters = new ArrayList<UnivCourseMasterVO>();
		for (String index : vo.getCheckkeys()) {
			UIUnivCourseMasterVO o = new UIUnivCourseMasterVO();
			o.setCourseMasterSeq(vo.getCourseMasterSeqs()[Integer.parseInt(index)]);
			o.copyAudit(vo);

			courseMasters.add(o);
		}

		if (courseMasters.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", courseMasterService.deletelistCourseMaster(courseMasters));
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 비학위 교과목 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		courseMasterService.insertCourseMaster(vo);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 비학위 교과목 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		courseMasterService.updateCourseMaster(vo);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 비학위 교과목 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterVO vo, UIUnivCourseMasterCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("condition", condition);

		mav.setViewName("/univ/coursemaster/createCourseMaster");
		return mav;
	}

	/**
	 * 교과목 목록 팝업화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseMasterCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/popup.do")
	public ModelAndView listCourseMasterPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// ocw 추가로 인해 교과목 마스터 검색 팝업에서는 ocw 마스터는 안나오도록 처리
		condition.setSrchNotInCategoryTypeCd("CATEGORY_TYPE::OCW");

		mav.addObject("paginate", courseMasterService.getListCourseMaster(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/coursemaster/listCourseMasterPopup");
		return mav;
	}

	/**
	 * 교과목 이름 like 검색
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/like/title/list/json.do")
	public ModelAndView listCourseMasterJson(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIUnivCourseMasterCondition condition = new UIUnivCourseMasterCondition();
		emptyValue(condition, "currentPage=0", "orderby=0");
		condition.setSrchWord(HttpUtil.getParameter(req, "srchWord", ""));

		Paginate<ResultSet> paginate = courseMasterService.getListCourseMaster(condition);

		if (paginate != null) {
			List<ResultSet> listItem = paginate.getItemList();
			if (listItem != null) {
				List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
				for (int index = 0; index < listItem.size(); index++) {
					UIUnivCourseMasterRS rs = (UIUnivCourseMasterRS)listItem.get(index);
					HashMap<String, Object> map = new HashMap<String, Object>();
					map.put("courseMasterSeq", rs.getCourseMaster().getCourseMasterSeq());
					map.put("courseTitle", rs.getCourseMaster().getCourseTitle());

					list.add(map);
				}
				mav.addObject("list", list);
			}
		}

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 개설과목 생성 팝업
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/copy/popup.do")
	public ModelAndView createCopyCourseActivePopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseMasterVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		List<UnivCourseActiveVO> voList = new ArrayList<UnivCourseActiveVO>();
		for (String index : vo.getCheckkeys()) {
			UIUnivCourseActiveVO o = new UIUnivCourseActiveVO();
			o.setCourseMasterSeq(vo.getCourseMasterSeqs()[Integer.parseInt(index)]);

			voList.add(o);
		}
		mav.addObject("itemList", voList);
		mav.addObject("years", univYearTermService.getListYearAll());

		mav.setViewName("/univ/coursemaster/createCourseMasterPopup");

		return mav;
	}

	/**
	 * 비학위의 개설 과목 생성(상시제,기수제)
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/coursemaster/copy/insert.do")
	public ModelAndView insertCopyCourseActivePopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		List<UnivCourseActiveVO> voList = new ArrayList<UnivCourseActiveVO>();
		for (int i = 0; i < vo.getCourseMasterSeqs().length; i++) {

			UIUnivCourseActiveVO o = new UIUnivCourseActiveVO();
			o.setCourseMasterSeq(vo.getCourseMasterSeqs()[i]);

			// 오픈 시작일 & 수상신청 시작기간
			if (StringUtil.isNotEmpty(vo.getOpenStartDate())) {
				o.setOpenStartDate(DateUtil.convertStartDate(vo.getOpenStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
				o.setApplyStartDate(DateUtil.convertStartDate(vo.getOpenStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));

			}
			// 오픈 종료일 & 수상신청 종료기간
			if (StringUtil.isNotEmpty(vo.getOpenEndDate())) {
				o.setOpenEndDate(DateUtil.convertEndDate(vo.getOpenEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
				o.setApplyEndDate(DateUtil.convertEndDate(vo.getOpenEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
			}
			
			// 정보 폐기 기간 시작일
			if (StringUtil.isNotEmpty(vo.getExpireStartDate())) {
				o.setExpireStartDate(DateUtil.convertStartDate(vo.getExpireStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
			}
			// 정보 폐기 기간 마지막일
			if (StringUtil.isNotEmpty(vo.getExpireEndDate())) {
				o.setExpireEndDate(DateUtil.convertEndDate(vo.getExpireEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
			}

			if (vo.getCourseTypeCd().equals("COURSE_TYPE::ALWAYS")) {// 상시제
				o.setStudyDay(vo.getStudyDay());
				o.setCancelDay(vo.getCancelDay());
				o.setResumeDay(vo.getResumeDay());
			} else {// 기수제

				// 마스터에서 생성되는 개설과정은 1기부터 시작한다.
				o.setPeriodNumber("1");

				// 수강신청 시작기간
				if (StringUtil.isNotEmpty(vo.getApplyStartDate())) {
					o.setApplyStartDate(DateUtil.convertStartDate(vo.getApplyStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
							Constants.FORMAT_TIMEZONE));
				}
				// 수강신청 종료기간
				if (StringUtil.isNotEmpty(vo.getApplyEndDate())) {
					o.setApplyEndDate(DateUtil.convertEndDate(vo.getApplyEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
							Constants.FORMAT_TIMEZONE));
				}

				// 수강 취소 시작기간
				if (StringUtil.isNotEmpty(vo.getCancelStartDate())) {
					o.setCancelStartDate(DateUtil.convertStartDate(vo.getCancelStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
							Constants.FORMAT_TIMEZONE));
				}
				// 수강 취소 종료기간
				if (StringUtil.isNotEmpty(vo.getCancelEndDate())) {
					o.setCancelEndDate(DateUtil.convertEndDate(vo.getCancelEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
							Constants.FORMAT_TIMEZONE));
				}

				// 학습 시작기간
				if (StringUtil.isNotEmpty(vo.getStudyStartDate())) {
					o.setStudyStartDate(DateUtil.convertStartDate(vo.getStudyStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
							Constants.FORMAT_TIMEZONE));
				}
				// 학습 종료기간
				if (StringUtil.isNotEmpty(vo.getStudyEndDate())) {
					o.setStudyEndDate(DateUtil.convertEndDate(vo.getStudyEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
							Constants.FORMAT_TIMEZONE));
				}

				// 복습 종료일
				if (StringUtil.isNotEmpty(vo.getResumeEndDate())) {
					o.setResumeEndDate(DateUtil.convertEndDate(vo.getResumeEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
							Constants.FORMAT_TIMEZONE));
				}

				o.setResumeDay(DateUtil.diffDate(vo.getStudyEndDate(), vo.getResumeEndDate(), "yyyy-MM-dd"));
				o.setStudyDay(DateUtil.diffDate(vo.getStudyStartDate(), vo.getStudyEndDate(), "yyyy-MM-dd"));
				o.setCancelDay(DateUtil.diffDate(vo.getCancelStartDate(), vo.getCancelEndDate(), "yyyy-MM-dd"));
			}
			o.setYear(vo.getYear());
			o.setCourseActiveStatusCd("COURSE_ACTIVE_STATUS::INACTIVE");// 대기 상태
			o.setEvaluateMethodTypeCd(vo.getEvaluateMethodTypeCd());
			o.setApplyTypeCd(vo.getApplyTypeCd());
			if (vo.getLimitProgressTypeCd().equals("LIMIT_PROGRESS_TYPE::SEQUENCE")) {
				o.setSequenceYn("Y");
			} else {
				o.setSequenceYn("N");
			}
			o.setLimitProgressTypeCd(vo.getLimitProgressTypeCd());
			o.setCompleteDivisionCd(vo.getCompleteDivisionCd());
			o.setCourseTypeCd(vo.getCourseTypeCd());
			o.setWeekCount(vo.getWeekCount());
			o.setGradeCompleteYn("N");
			o.setCompetitionYn(vo.getCompetitionYn());
			o.copyAudit(vo);

			voList.add(o);
		}

		courseActiveService.insertlistCourseActive(voList);

		mav.setViewName("/common/save");
		return mav;
	}
}
