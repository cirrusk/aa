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

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.api.UIBaseController;
import com._4csoft.aof.ui.univ.dto.CourseHomeWorkDTO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseHomeworkVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseHomeworkRS;
import com._4csoft.aof.univ.service.UnivCourseHomeworkService;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.univ.api
 * @File : UICourseHomeworkController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 20.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICourseHomeworkController extends UIBaseController {
	@Resource (name = "UnivCourseHomeworkService")
	private UnivCourseHomeworkService courseHomeworkService;

	/**
	 * 과제 템플릿 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/course/active/homework/list")
	public ModelAndView listHomework(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;
		checkSession(req);

		UIUnivCourseHomeworkVO homework = new UIUnivCourseHomeworkVO();

		homework.setCourseActiveSeq(Long.parseLong(req.getParameter("courseActiveSeq")));

		List<CourseHomeWorkDTO> items = new ArrayList<CourseHomeWorkDTO>();
		List<ResultSet> rslist = courseHomeworkService.getListHomework(homework);

		for (ResultSet rs : rslist) {
			UIUnivCourseHomeworkRS courseHomeworkRS = (UIUnivCourseHomeworkRS)rs;
			CourseHomeWorkDTO dto = new CourseHomeWorkDTO();
			BeanUtils.copyProperties(dto, courseHomeworkRS.getCourseHomework());
			items.add(dto);
		}

		mav.addObject("items", items);

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}
}
