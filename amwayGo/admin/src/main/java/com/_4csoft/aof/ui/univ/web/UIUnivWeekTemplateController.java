/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivWeekTemplateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivYearTermVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivWeekTemplateCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivWeekTemplateRS;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivWeekTemplateService;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivCourseActiveElementVO;
import com._4csoft.aof.univ.vo.UnivWeekTemplateVO;
import com._4csoft.aof.univ.vo.UnivYearTermVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UnivListWeekTemplateController.java
 * @Title : 주차템플릿 컨트롤러
 * @date : 2014. 2. 19.
 * @author : 김현우
 * @descrption : 주차템플릿 컨트롤러
 */
@Controller
public class UIUnivWeekTemplateController extends BaseController {

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	@Resource (name = "UnivWeekTemplateService")
	private UnivWeekTemplateService univWeekTemplateService;

	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService univCourseActiveElementService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService univCourseActiveService;

	/**
	 * 주차템플릿 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/week/template/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivWeekTemplateCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=0", "perPage=0", "orderby=0");

		// 시스템에 설정된 년도학기
		MemberVO ssMember = SessionUtil.getMember(req);

		UIUnivYearTermVO yearTermVO = new UIUnivYearTermVO();
		if (StringUtil.isEmpty(condition.getSrchYearTerm())) {
			if (ssMember.getExtendData().get("systemYearTerm") == null) { // 현재 년도의 1학기로 셋팅한다.
				String defaultTerm = "10";
				String yearTerm = DateUtil.getTodayYear() + defaultTerm;
				yearTermVO.setYearTerm(yearTerm);
				condition.setSrchYearTerm(yearTerm);
			} else {
				UnivYearTermVO univYearTermVO = (UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm");
				yearTermVO.setYearTerm(univYearTermVO.getYearTerm());
				condition.setSrchYearTerm(univYearTermVO.getYearTerm());
			}

		} else {
			yearTermVO.setYearTerm(condition.getSrchYearTerm());
		}

		mav.addObject("detail", univYearTermService.getDetailYearTerm(yearTermVO));
		mav.addObject("paginate", univWeekTemplateService.getListWeekTemplate(condition));
		mav.addObject("yearTerms", univYearTermService.getListYearTermAll());
		mav.addObject("condition", condition);

		mav.setViewName("/univ/weektemplate/listWeekTemplate");
		return mav;
	}

	/**
	 * 주차템플릿 계산 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/week/template/calculationlist.do")
	public ModelAndView calculationlist(HttpServletRequest req, HttpServletResponse res, UIUnivWeekTemplateCondition condition) throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String yearTerm = condition.getSrchYearTerm();
		UIUnivYearTermVO yearTermVO = new UIUnivYearTermVO();
		yearTermVO.setYearTerm(yearTerm);

		mav.addObject("detail", univYearTermService.getDetailYearTerm(yearTermVO));
		mav.addObject("yearTerms", univYearTermService.getListYearTermAll());

		Date studyStartDate = DateUtil.getFormatDate(
				DateUtil.convertStartDate(condition.getStudyStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE),
				"yyyyMMddHHmm");
		int weekCount = condition.getWeekCount().intValue();
		int dayCount = condition.getDayCount().intValue();

		List<ResultSet> univWeekTemplateRSs = new ArrayList<ResultSet>();
		UIUnivWeekTemplateRS result = null;
		UIUnivWeekTemplateVO vo = null;

		for (int i = 0; i < weekCount; i++) {
			if (i != 0) {
				studyStartDate = DateUtil.addDays(studyStartDate, 1);
			}
			result = new UIUnivWeekTemplateRS();
			vo = new UIUnivWeekTemplateVO();

			vo.setYearTerm(yearTerm);
			vo.setWeekSeq(Long.parseLong(Integer.toString((i + 1))));

			// [1] 주차 시작일 셋팅
			vo.setStartDtime(DateUtil.getFormatString(studyStartDate, "yyyyMMddHHmm"));

			// [2] 증가일 계산
			studyStartDate = DateUtil.addDays(studyStartDate, dayCount);

			// [3] 주차 종료일 셋팅
			vo.setEndDtime(DateUtil.getFormatString(studyStartDate, "yyyyMMddHHmm"));

			result.setUnivWeekTemplate(vo);
			univWeekTemplateRSs.add(result);

		}

		Paginate<ResultSet> paginate = new Paginate<ResultSet>();
		if (weekCount > 0) {
			paginate.adjustPage(weekCount, condition);
			paginate.paginated(univWeekTemplateRSs, weekCount, condition);
		}

		mav.addObject("paginate", paginate);

		mav.addObject("condition", condition);

		mav.setViewName("/univ/weektemplate/listWeekTemplate");
		return mav;
	}

	/**
	 * 주차템플릿 다중 등록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/week/template/insertlist.do")
	public ModelAndView insertlist(HttpServletRequest req, HttpServletResponse res, UIUnivWeekTemplateVO univWeekTemplate) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univWeekTemplate);

		List<UnivWeekTemplateVO> weekTemplates = new ArrayList<UnivWeekTemplateVO>();

		if (univWeekTemplate.getStartDtimes() != null) {
			for (int index = 0; index < univWeekTemplate.getStartDtimes().length; index++) {
				UIUnivWeekTemplateVO o = new UIUnivWeekTemplateVO();
				o.setYearTerm(univWeekTemplate.getYearTerm());
				o.setWeekSeq(index + 1L);
				o.setStartDtime(DateUtil.convertStartDate(univWeekTemplate.getStartDtimes()[index], Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
				o.setEndDtime(DateUtil.convertStartDate(univWeekTemplate.getEndDtimes()[index], Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
				o.copyAudit(univWeekTemplate);
				weekTemplates.add(o);
			}
		}

		/*
		 * 주자 등록은 리스트에 아무것도 없더라도 서비스 로직에 들어값니다. 리스트에 값이 없는 경우는 전체 삭제에 해당 됩니다.
		 */
		univWeekTemplateService.insertlistWeekTemplate(weekTemplates, univWeekTemplate.getYearTerm());

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목일괄적용
	 * 
	 * @param req
	 * @param res
	 * @param univWeekTemplate
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/week/template/active/all/update.do")
	public ModelAndView updateAllActiveElement(HttpServletRequest req, HttpServletResponse res, UIUnivWeekTemplateVO univWeekTemplate) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univWeekTemplate);

		List<UnivCourseActiveElementVO> activeElements = new ArrayList<UnivCourseActiveElementVO>();

		// 변경된 템플릿 저장 먼저후 일괄적용
		this.insertlist(req, res, univWeekTemplate);

		int totalCountActive = 0;
		int updateCountActive = 0;

		if (univWeekTemplate.getStartDtimes() != null) {
			for (int index = 0; index < univWeekTemplate.getStartDtimes().length; index++) {
				UnivCourseActiveElementVO o = new UnivCourseActiveElementVO();
				o.setYearTerm(univWeekTemplate.getYearTerm());
				o.setSortOrder(index + 1L);
				o.setStartDtime(DateUtil.convertStartDate(univWeekTemplate.getStartDtimes()[index], Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
				o.setEndDtime(DateUtil.convertStartDate(univWeekTemplate.getEndDtimes()[index], Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
						Constants.FORMAT_TIMEZONE));
				o.setWeekCount(Long.parseLong(Integer.toString(univWeekTemplate.getStartDtimes().length)));
				o.copyAudit(univWeekTemplate);
				activeElements.add(o);
			}

			UIUnivCourseActiveCondition condition = new UIUnivCourseActiveCondition();
			condition.setSrchCategoryTypeCd("CATEGORY_TYPE::DEGREE");
			condition.setSrchYearTerm(univWeekTemplate.getYearTerm());

			totalCountActive = univCourseActiveService.countListCourseActive(condition);
		}

		if (!activeElements.isEmpty()) {
			updateCountActive = univCourseActiveElementService.updateAllActiveElementByStartEndDate(activeElements);
		}

		mav.addObject("result", totalCountActive + "," + updateCountActive + ",");
		mav.setViewName("/common/save");
		return mav;
	}
}
