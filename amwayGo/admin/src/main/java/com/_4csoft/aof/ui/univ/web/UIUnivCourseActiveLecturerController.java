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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveLecturerMenuVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveLecturerVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveLecturerCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveLecturerMenuService;
import com._4csoft.aof.univ.service.UnivCourseActiveLecturerService;
import com._4csoft.aof.univ.vo.UnivCourseActiveLecturerMenuVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveLecturerVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveLecturerController.java
 * @Title : 개설과목 교강사 권한 부분 컨트롤러
 * @date : 2014. 2. 26.
 * @author : 김현우
 * @descrption : 개설과목 교강사 권한 부분 컨트롤러
 */
@Controller
public class UIUnivCourseActiveLecturerController extends BaseController {

	@Resource (name = "UnivCourseActiveLecturerService")
	private UnivCourseActiveLecturerService univCourseActiveLecturerService;

	@Resource (name = "UnivCourseActiveLecturerMenuService")
	private UnivCourseActiveLecturerMenuService univCourseActiveLecturerMenuService;

	/**
	 * 개설과목 교강사권한관리 상단 탭 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/lecturer/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/univ/courseActiveLecturer/listCourseActiveLecturer");
		return mav;
	}

	/**
	 * 개설과목 탭안에 나오는 교강사 리스트
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/lecturer/list/iframe.do")
	public ModelAndView listframe(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveLecturerCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		// 교강사가 등록되어있지 않을 경우 선임과 강사를 등록할수 없다.
		UIUnivCourseActiveLecturerCondition lecturerCondition = new UIUnivCourseActiveLecturerCondition();
		lecturerCondition.setSrchCourseActiveSeq(condition.getSrchCourseActiveSeq());
		lecturerCondition.setSrchActiveLecturerTypeCd(codes.get("CD.ACTIVE_LECTURER_TYPE.PROF"));
		mav.addObject("profCount", univCourseActiveLecturerService.countListCourseActiveLecturer(lecturerCondition));

		mav.addObject("paginate", univCourseActiveLecturerService.getListCourseActiveLecturer(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseActiveLecturer/listCourseActiveLectureriframe");
		return mav;
	}

	/**
	 * 교강사 추가
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveLecturer
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/lecturer/insertlist.do")
	public ModelAndView insertlist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveLecturerVO courseActiveLecturer) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveLecturer);

		List<UnivCourseActiveLecturerVO> courseActiveLecturers = new ArrayList<UnivCourseActiveLecturerVO>();

		for (int index = 0; index < courseActiveLecturer.getMemberSeqs().length; index++) {
			UnivCourseActiveLecturerVO o = new UnivCourseActiveLecturerVO();
			o.setCourseActiveSeq(courseActiveLecturer.getCourseActiveSeq());
			o.setMemberSeq(courseActiveLecturer.getMemberSeqs()[index]);
			o.setUseYn("Y");
			o.setActiveLecturerTypeCd(courseActiveLecturer.getActiveLecturerTypeCd());
			o.setShortcutCourseTypeCd(courseActiveLecturer.getShortcutCourseTypeCd());
			o.copyAudit(courseActiveLecturer);

			if (courseActiveLecturer.getActiveLecturerTypeCd().equals("ACTIVE_LECTURER_TYPE::PROF")) {
				o.setProfMemberSeq(o.getMemberSeq());
			} else {
				if (SessionUtil.getMember(req).getCurrentRolegroupSeq() > 1) {
					// 교강사 일경우는 자신의 일련번호를 지정한다.
					o.setProfMemberSeq(o.getRegMemberSeq());
				} else {
					// 관리자 그룹일 경우 담당 교수자를 지정한다.
					o.setProfMemberSeq(courseActiveLecturer.getProfMemberSeqs()[index]);
				}
			}

			courseActiveLecturers.add(o);
		}

		if (courseActiveLecturers.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univCourseActiveLecturerService.insertlistCourseActiveLecturer(courseActiveLecturers));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 교강사 삭제
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveLecturer
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/lecturer/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveLecturerVO courseActiveLecturer) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveLecturer);

		List<UnivCourseActiveLecturerVO> courseActiveLecturers = new ArrayList<UnivCourseActiveLecturerVO>();

		for (String index : courseActiveLecturer.getCheckkeys()) {
			UnivCourseActiveLecturerVO o = new UnivCourseActiveLecturerVO();
			o.setCourseActiveProfSeq(courseActiveLecturer.getCourseActiveProfSeqs()[Integer.parseInt(index)]);
			o.setCourseActiveSeq(courseActiveLecturer.getCourseActiveSeq());
			o.setMemberSeq(courseActiveLecturer.getMemberSeqs()[Integer.parseInt(index)]);
			o.setActiveLecturerTypeCd(courseActiveLecturer.getActiveLecturerTypeCd());
			o.copyAudit(courseActiveLecturer);

			courseActiveLecturers.add(o);
		}

		if (courseActiveLecturers.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univCourseActiveLecturerService.deletelistCourseActiveLecturer(courseActiveLecturers));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 교강사 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param univCourseHomeworkTemplate
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/lecturer/detail/iframe.do")
	public ModelAndView detailMember(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveLecturerVO univCourseActiveLecturer,
			UIUnivCourseActiveLecturerCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", univCourseActiveLecturerService.getDetailCourseActiveLecturer(univCourseActiveLecturer));

		UnivCourseActiveLecturerMenuVO vo = new UnivCourseActiveLecturerMenuVO();
		vo.setActiveLecturerTypeCd(condition.getSrchActiveLecturerTypeCd());
		vo.setCourseActiveProfSeq(univCourseActiveLecturer.getCourseActiveProfSeq());
		vo.setShortcutCourseTypeCd(condition.getShortcutCourseTypeCd());

		mav.addObject("list", univCourseActiveLecturerMenuService.getListCourseActiveLecturerMenu(vo));

		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseActiveLecturer/detailCourseActiveLectureriframe");
		return mav;
	}

	/**
	 * 교강사 상세정보의 메뉴권한 설정 수정
	 * 
	 * @param req
	 * @param res
	 * @param courseActiveLecturerMenu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/lecturer/menu/updatelist.do")
	public ModelAndView insertlist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveLecturerMenuVO courseActiveLecturerMenu) throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req, courseActiveLecturerMenu);

		List<UnivCourseActiveLecturerMenuVO> lecturerMenus = new ArrayList<UnivCourseActiveLecturerMenuVO>();
		for (int index = 0; index < courseActiveLecturerMenu.getMenuSeqs().length; index++) {
			UIUnivCourseActiveLecturerMenuVO o = new UIUnivCourseActiveLecturerMenuVO();
			o.setCourseActiveSeq(courseActiveLecturerMenu.getCourseActiveSeq());
			o.setCourseActiveProfSeq(courseActiveLecturerMenu.getCourseActiveProfSeq());
			o.setMenuSeq(courseActiveLecturerMenu.getMenuSeqs()[index]);
			o.setCrud(courseActiveLecturerMenu.getCruds()[index]);
			o.copyAudit(courseActiveLecturerMenu);

			String oldCrud = courseActiveLecturerMenu.getOldCruds()[index];

			if (!oldCrud.equals(o.getCrud())) { // 변경되었으면 처리함.
				lecturerMenus.add(o);
			}
		}

		if (lecturerMenus.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", univCourseActiveLecturerMenuService.savelistCourseActiveLecturerMenu(lecturerMenus));
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 개설과목 교강사 나의할일 리스트
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/mypage/course/active/lecturer/mywork/list.do")
	public ModelAndView listMyWork(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveLecturerCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		condition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		condition.setSrchRoleGroupSeq(SessionUtil.getMember(req).getCurrentRolegroupSeq());

		mav.addObject("paginate", univCourseActiveLecturerService.getListCourseActiveMyWork(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseActiveLecturer/listCourseActiveLecturerMyWork");
		return mav;
	}

}
