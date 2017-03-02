/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.ScheduleService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.UIScheduleVO;
import com._4csoft.aof.ui.infra.vo.condition.UIScheduleCondition;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIScheduleController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 6. 17.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIScheduleController extends BaseController {

	@Resource (name = "ScheduleService")
	private ScheduleService scheduleService;

	/**
	 * 일정 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/schedule/{referenceType}.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("referenceType") String referenceType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		referenceType = referenceType.toLowerCase();

		mav.addObject("srchYearMonth", DateUtil.getToday("yyyyMM"));
		mav.addObject("referenceType", referenceType);

		mav.setViewName("/infra/schedule/schedule");

		return mav;
	}

	/**
	 * 일정 목록
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView - json
	 * @throws Exception
	 */
	@RequestMapping ("/schedule/{referenceType}/list.do")
	public ModelAndView listdata(HttpServletRequest req, HttpServletResponse res, @PathVariable ("referenceType") String referenceType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		referenceType = referenceType.toLowerCase();

		String pattern = "yyyyMM";

		String srchYearMonth = HttpUtil.getParameter(req, "srchYearMonth", DateUtil.getToday(pattern));
		Date date = DateUtil.getFormatDate(srchYearMonth, pattern); // 기준달 첫일.
		Date prevMonth = DateUtil.addMonths(date, -1); // 이전달 첫일
		Date nextMonth = DateUtil.addMonths(date, 2); //
		nextMonth = DateUtil.addDays(nextMonth, -1); // 다음달 말일

		String prevMonthString = DateUtil.getFormatString(prevMonth, Constants.FORMAT_DATE);
		String nextMonthString = DateUtil.getFormatString(nextMonth, Constants.FORMAT_DATE);

		UIScheduleCondition condition = new UIScheduleCondition();
		condition.setSrchStartDtime(DateUtil.convertStartDate(prevMonthString, Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME));
		condition.setSrchEndDtime(DateUtil.convertEndDate(nextMonthString, Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME));

		condition.setSrchMemberSeq(-1L); // 시스템일정
		condition.setSrchRepeatYn("N"); // 시스템 일반
		mav.addObject("listSystemNormal", scheduleService.getList(condition));

		condition.setSrchRepeatYn("Y"); // 시스템 반복
		mav.addObject("listSystemRepeat", scheduleService.getList(condition));

		mav.addObject("referenceType", referenceType);

		// 개인일정
		if ("personal".equals(referenceType)) {
			condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq()); // 개인일정
			condition.setSrchRepeatYn("N"); // 개인 일반
			mav.addObject("listPersonalNormal", scheduleService.getList(condition));

			condition.setSrchRepeatYn("N"); // 개인 반복
			mav.addObject("listPersonalNormal", scheduleService.getList(condition));

		}
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 일정 생성 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIScheduleVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/schedule/{referenceType}/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, @PathVariable ("referenceType") String referenceType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		referenceType = referenceType.toLowerCase();

		mav.addObject("referenceType", referenceType);

		mav.setViewName("/infra/schedule/createSchedule");
		return mav;
	}

	/**
	 * 일정 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIScheduleVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/schedule/{referenceType}/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, @PathVariable ("referenceType") String referenceType, UIScheduleVO schedule)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		referenceType = referenceType.toLowerCase();

		mav.addObject("detail", scheduleService.getDetail(schedule));
		mav.addObject("referenceType", referenceType);

		mav.setViewName("/infra/schedule/editSchedule");
		return mav;
	}

	/**
	 * 일정 상세 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIScheduleVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/schedule/detail.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIScheduleVO schedule) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", scheduleService.getDetail(schedule));

		mav.setViewName("/infra/schedule/detailSchedule");
		return mav;
	}

	/**
	 * 일정 등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIScheduleVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/schedule/{referenceType}/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, @PathVariable ("referenceType") String referenceType, UIScheduleVO schedule)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, schedule);

		if ("system".equals(referenceType)) {
			schedule.setMemberSeq(-1L); // 시스템일정

		} else if ("personal".equals(referenceType)) {
			schedule.setMemberSeq(SessionUtil.getMember(req).getMemberSeq()); // 개인일정

		}
		// 달력에서 선택한 날짜(종료일) convert
		if (StringUtil.isNotEmpty(schedule.getRepeatEndDate())) {
			schedule.setRepeatEndDate(DateUtil.convertEndDate(schedule.getRepeatEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}

		scheduleService.insertSchedule(schedule);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 일정 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIScheduleVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/schedule/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIScheduleVO schedule) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, schedule);

		// 달력에서 선택한 날짜(종료일) convert
		if (StringUtil.isNotEmpty(schedule.getRepeatEndDate())) {
			schedule.setRepeatEndDate(DateUtil.convertEndDate(schedule.getRepeatEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}

		scheduleService.updateSchedule(schedule);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 일정 일자 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIScheduleVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/schedule/date/update.do")
	public ModelAndView updateDate(HttpServletRequest req, HttpServletResponse res, UIScheduleVO schedule) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, schedule);

		scheduleService.updateScheduleDate(schedule);

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 일정 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIScheduleVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/schedule/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIScheduleVO schedule) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, schedule);

		scheduleService.deleteSchedule(schedule);

		mav.setViewName("/common/save");
		return mav;
	}

}
