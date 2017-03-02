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

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseTeamProjectTemplateVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseTeamProjectTemplateCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseMasterRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseTeamProjectTemplateRS;
import com._4csoft.aof.univ.service.UnivCourseActiveLecturerService;
import com._4csoft.aof.univ.service.UnivCourseMasterService;
import com._4csoft.aof.univ.service.UnivCourseTeamProjectTemplateService;
import com._4csoft.aof.univ.vo.UnivCourseActiveLecturerVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseTeamProjectTemplateController.java
 * @Title : 팀프로젝트 템플릿 컨트롤러
 * @date : 2014. 2. 20.
 * @author : 김현우
 * @descrption : 팀프로젝트 템플릿 컨트롤러
 */
@Controller
public class UIUnivCourseTeamProjectTemplateController extends BaseController {

	@Resource (name = "UnivCourseTeamProjectTemplateService")
	private UnivCourseTeamProjectTemplateService univCourseTeamProjectTemplateService;

	@Resource (name = "UnivCourseActiveLecturerService")
	private UnivCourseActiveLecturerService univCourseActiveLecturerService;

	@Resource (name = "UnivCourseMasterService")
	private UnivCourseMasterService univCourseMasterService;

	/**
	 * 팀프로젝트 템플릿 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/teamproject/template/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTemplateCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		String currentRoleCfString = ssMember.getCurrentRoleCfString();

		// TODO: PROF_TYPE 사용
		if ("PROF".equals(currentRoleCfString)) {// 교강사일시 검색조건 추가
			condition.setSrchProfSessionMemberSeq(ssMember.getMemberSeq());
			condition.setSrchProfMemberName(ssMember.getMemberName());
		} else if ("ASSIST".equals(currentRoleCfString) || "TUTOR".equals(currentRoleCfString)) {// 조교, 튜터일시
			condition.setSrchAssistMemberSeq(ssMember.getMemberSeq());
		}

		mav.addObject("paginate", univCourseTeamProjectTemplateService.getListCourseTeamProjectTemplate(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseTeamProjectTemplate/listCourseTeamProjectTemplate");
		return mav;
	}

	/**
	 * 팀프로젝트 템플릿 검색 팝업
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/teamproject/template/list/popup.do")
	public ModelAndView listPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTemplateCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0", "srchUseYn=Y");

		if (StringUtil.isEmpty(condition.getPopupFirstYn())) { // 최초검색시 값 셋팅

			UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
			String currentRoleCfString = ssMember.getCurrentRoleCfString();

			if (!"ADM".equals(currentRoleCfString) && !StringUtil.isEmpty(condition.getSrchCourseActiveSeq())) { // 관리자 롤그룹이 아닐시
				UnivCourseActiveLecturerVO vo = new UnivCourseActiveLecturerVO();
				vo.setCourseActiveSeq(condition.getSrchCourseActiveSeq());
				vo.setMemberSeq(ssMember.getMemberSeq());
				UnivCourseActiveLecturerVO lecVo = univCourseActiveLecturerService.getDetailCourseActiveLecturerByMember(vo);
				condition.setSrchProfSessionMemberSeq(lecVo.getProfMemberSeq());
				condition.setSrchProfMemberName(lecVo.getProfMemberName());
			}

			UIUnivCourseMasterVO masterVo = new UIUnivCourseMasterVO();
			masterVo.setCourseMasterSeq(condition.getSrchCourseMasterSeq());
			UIUnivCourseMasterRS rs = (UIUnivCourseMasterRS)univCourseMasterService.getDetailCourseMaster(masterVo);

			condition.setSrchCourseTitle(rs.getCourseMaster().getCourseTitle());
		}

		mav.addObject("paginate", univCourseTeamProjectTemplateService.getListCourseTeamProjectTemplate(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseTeamProjectTemplate/listCourseTeamProjectTemplatePopup");
		return mav;
	}

	/**
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/teamproject/template/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTemplateCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseTeamProjectTemplate/createCourseTeamProjectTemplate");
		return mav;
	}

	/**
	 * 팀프로젝트 템플릿 신규등록
	 * 
	 * @param req
	 * @param res
	 * @param univCourseTeamProjectTemplate
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/teamproject/template/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTemplateVO univCourseTeamProjectTemplate,
			UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univCourseTeamProjectTemplate);

		univCourseTeamProjectTemplateService.insertCourseTeamProjectTemplate(univCourseTeamProjectTemplate, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 팀프로젝트 템플릿 상세정보 화면 , 팝업
	 * 
	 * @param req
	 * @param res
	 * @param univCourseTeamProjectTemplate
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = { "/univ/course/teamproject/template/detail.do", "/univ/course/teamproject/template/detail/popup.do" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTemplateVO univCourseTeamProjectTemplate,
			UIUnivCourseTeamProjectTemplateCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivCourseTeamProjectTemplateRS rs = (UIUnivCourseTeamProjectTemplateRS)univCourseTeamProjectTemplateService
				.getDetailCourseTeamProjectTemplate(univCourseTeamProjectTemplate);

		mav.addObject("detail", rs);
		mav.addObject("condition", condition);

		String viewName = "";
		if (req.getServletPath().endsWith("popup.do")) {
			viewName = "/univ/courseTeamProjectTemplate/detailCourseTeamProjectTemplatePopup";
		} else {
			UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
			int count = univCourseActiveLecturerService.countCourseActiveLecturerByProfMember(rs.getTeamProjectTemplate().getProfMemberSeq(),
					ssMember.getMemberSeq());

			if (count > 0) {
				mav.addObject("delUpYn", "Y");
			} else {
				mav.addObject("delUpYn", "N");
			}

			viewName = "/univ/courseTeamProjectTemplate/detailCourseTeamProjectTemplate";
		}

		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 팀프로젝트 템플릿 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param univCourseTeamProjectTemplate
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/teamproject/template/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTemplateVO univCourseTeamProjectTemplate,
			UIUnivCourseTeamProjectTemplateCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", univCourseTeamProjectTemplateService.getDetailCourseTeamProjectTemplate(univCourseTeamProjectTemplate));

		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseTeamProjectTemplate/editCourseTeamProjectTemplate");
		return mav;
	}

	/**
	 * 팀프로젝트 템플릿 수정
	 * 
	 * @param req
	 * @param res
	 * @param univCourseTeamProjectTemplate
	 * @param attach
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/teamproject/template/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTemplateVO univCourseTeamProjectTemplate,
			UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univCourseTeamProjectTemplate);

		emptyValue(univCourseTeamProjectTemplate, "useYn=Y", "openYn=N");

		univCourseTeamProjectTemplateService.updateCourseTeamProjectTemplate(univCourseTeamProjectTemplate, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 팀프로젝트 템플릿 삭제
	 * 
	 * @param req
	 * @param res
	 * @param univCourseTeamProjectTemplate
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/teamproject/template/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIUnivCourseTeamProjectTemplateVO univCourseTeamProjectTemplate)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, univCourseTeamProjectTemplate);

		univCourseTeamProjectTemplateService.deleteCourseTeamProjectTemplate(univCourseTeamProjectTemplate);

		mav.setViewName("/common/save");
		return mav;
	}
}