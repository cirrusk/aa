/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.CategoryService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.lcms.service.LcmsContentsOrganizationService;
import com._4csoft.aof.lcms.service.LcmsContentsService;
import com._4csoft.aof.lcms.vo.LcmsContentsOrganizationVO;
import com._4csoft.aof.lcms.vo.LcmsContentsVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.lcms.vo.UILcmsContentsOrganizationVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsContentsVO;
import com._4csoft.aof.ui.lcms.vo.condition.UILcmsContentsCondition;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.lcms.web
 * @File : UIContentsController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UILcmsContentsController extends BaseController {

	@Resource (name = "LcmsContentsService")
	private LcmsContentsService contentsService;

	@Resource (name = "LcmsContentsOrganizationService")
	private LcmsContentsOrganizationService contentsOrganizationService;

	@Resource (name = "CategoryService")
	private CategoryService categoryService;

	/**
	 * 콘텐츠 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param ModelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UILcmsContentsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		if ("ADM".equals(ssMember.getCurrentRoleCfString()) == false) { // 관리자 그룹은 전체, 다른 그룹은 자신이 등록한 것 또는 소유자인 것만.
			// 조교, 튜터는 자신이 등록한거 아니면 자신을 자신이 담당하고있는 강사
			if ("ASSIST".equals(ssMember.getCurrentRoleCfString()) || "TUTOR".equals(ssMember.getCurrentRoleCfString())) {
				condition.setSrchAssistMemberSeq(ssMember.getMemberSeq());
			} else {// 교강사 권한일시
				condition.setSrchMemberSeq(ssMember.getMemberSeq());
			}
		}
		mav.addObject("paginate", contentsService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/lcms/contents/listContents");

		return mav;
	}

	/**
	 * 콘텐츠 목록 팝업 화면
	 * 
	 * @param req
	 * @param res
	 * @param ModelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/list/popup.do")
	public ModelAndView listPopup(HttpServletRequest req, HttpServletResponse res, UILcmsContentsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

		emptyValue(condition, "currentPage=1", "perPage=5", "orderby=0");

		if ("ADM".equals(ssMember.getCurrentRoleCfString()) == false) { // 관리자 그룹은 전체, 다른 그룹은 자신이 등록한 것 또는 소유자인 것만.
			condition.setSrchMemberSeq(ssMember.getMemberSeq());
		}
		condition.setSrchStatusCd("CONTENTS_STATUS_TYPE::ACTIVE"); // 활성

		mav.addObject("paginate", contentsService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/lcms/contents/listContentsPopup");

		return mav;
	}

	/**
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/organization/list/json.do")
	public ModelAndView listJson(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		Long contentsSeq = HttpUtil.getParameter(req, "contentsSeq", 0L);

		UILcmsContentsOrganizationVO vo = new UILcmsContentsOrganizationVO();
		vo.setContentsSeq(contentsSeq);

		mav.addObject("list", contentsOrganizationService.getList(vo));

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 콘텐츠 Popup 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/list/iframe.do")
	public ModelAndView listIframe(HttpServletRequest req, HttpServletResponse res, UILcmsContentsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=5", "orderby=0");

		mav.addObject("paginate", contentsService.getListWithOrganization(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/lcms/contents/listContentsIframe");

		return mav;
	}

	/**
	 * 콘텐츠 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsVO
	 * @param UILcmsContentsCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UILcmsContentsVO contents, UILcmsContentsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", contentsService.getDetail(contents));
		mav.addObject("condition", condition);

		// contents 목록
		UILcmsContentsOrganizationVO contentsOrganization = new UILcmsContentsOrganizationVO();
		contentsOrganization.setContentsSeq(contents.getContentsSeq());
		mav.addObject("contentsList", contentsOrganizationService.getList(contentsOrganization));

		mav.setViewName("/lcms/contents/detailContents");
		return mav;
	}

	/**
	 * 콘텐츠 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UILcmsContentsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);

		mav.setViewName("/lcms/contents/createContents");
		return mav;
	}

	/**
	 * 콘텐츠 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsVO
	 * @param UILcmsContentsCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UILcmsContentsVO contents, UILcmsContentsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", contentsService.getDetail(contents));
		mav.addObject("condition", condition);

		mav.setViewName("/lcms/contents/editContents");
		return mav;
	}

	/**
	 * 콘텐츠 수정 화면(소유자변경)
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/member/edit/popup.do")
	public ModelAndView editPopup(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/lcms/contents/editMemberPopup");
		return mav;
	}

	/**
	 * 콘텐츠 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UILcmsContentsVO contents) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, contents);

		contentsService.insertContents(contents);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 콘텐츠 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UILcmsContentsVO contents) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, contents);

		contentsService.updateContents(contents);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 콘텐츠 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UILcmsContentsVO contents) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, contents);

		contentsService.deleteContents(contents);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 콘텐츠 다중 수정 처리(소유자변경)
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UILcmsContentsVO contents) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, contents);

		List<LcmsContentsVO> voList = new ArrayList<LcmsContentsVO>();
		for (String index : contents.getCheckkeys()) {
			UILcmsContentsVO o = new UILcmsContentsVO();
			o.setContentsSeq(contents.getContentsSeqs()[Integer.parseInt(index)]);
			o.setMemberSeq(contents.getMemberSeq());
			o.copyAudit(contents);
			voList.add(o);
		}

		if (voList.size() > 0) {
			mav.addObject("result", contentsService.updatelistContentsMemberSeq(voList));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 콘텐츠 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UILcmsContentsVO contents) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, contents);

		List<LcmsContentsVO> voList = new ArrayList<LcmsContentsVO>();
		for (String index : contents.getCheckkeys()) {
			UILcmsContentsVO o = new UILcmsContentsVO();
			o.setContentsSeq(contents.getContentsSeqs()[Integer.parseInt(index)]);
			o.setCategorySeq(contents.getCategorySeqs()[Integer.parseInt(index)]);
			o.copyAudit(contents);
			voList.add(o);
		}

		if (voList.size() > 0) {
			mav.addObject("result", contentsService.deletelistContents(voList));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 콘텐츠요소 순서변경 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsOrganizationVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/organization/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UILcmsContentsOrganizationVO contentsOrganization) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, contentsOrganization);

		List<LcmsContentsOrganizationVO> contentsOrganizations = new ArrayList<LcmsContentsOrganizationVO>();
		for (int i = 0; i < contentsOrganization.getContentsSeqs().length; i++) {
			UILcmsContentsOrganizationVO o = new UILcmsContentsOrganizationVO();
			o.setContentsSeq(contentsOrganization.getContentsSeqs()[i]);
			o.setOrganizationSeq(contentsOrganization.getOrganizationSeqs()[i]);
			o.setSortOrder(contentsOrganization.getSortOrders()[i]);
			o.copyAudit(contentsOrganization);
			contentsOrganizations.add(o);
		}

		if (contentsOrganizations.size() > 0) {
			mav.addObject("result", contentsOrganizationService.updatelistContentsOrganization(contentsOrganizations));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 콘텐츠요소 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsOrganizationVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/organization/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UILcmsContentsOrganizationVO contentsOrganization) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, contentsOrganization);

		List<LcmsContentsOrganizationVO> contentsOrganizations = new ArrayList<LcmsContentsOrganizationVO>();
		for (String index : contentsOrganization.getCheckkeys()) {
			UILcmsContentsOrganizationVO o = new UILcmsContentsOrganizationVO();
			o.setContentsSeq(contentsOrganization.getContentsSeqs()[Integer.parseInt(index)]);
			o.setOrganizationSeq(contentsOrganization.getOrganizationSeqs()[Integer.parseInt(index)]);
			o.copyAudit(contentsOrganization);
			contentsOrganizations.add(o);
		}

		if (contentsOrganizations.size() > 0) {
			mav.addObject("result", contentsOrganizationService.deletelistContentsOrganization(contentsOrganizations));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 콘텐츠요소 추가 처리
	 * 
	 * @param req
	 * @param res
	 * @param UILcmsContentsOrganizationVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/contents/organization/insertlist.do")
	public ModelAndView insertlist(HttpServletRequest req, HttpServletResponse res, UILcmsContentsOrganizationVO contentsOrganization) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, contentsOrganization);

		List<LcmsContentsOrganizationVO> contentsOrganizations = new ArrayList<LcmsContentsOrganizationVO>();
		for (String index : contentsOrganization.getCheckkeys()) {
			UILcmsContentsOrganizationVO o = new UILcmsContentsOrganizationVO();
			o.setContentsSeq(contentsOrganization.getContentsSeqs()[Integer.parseInt(index)]);
			o.setOrganizationSeq(contentsOrganization.getOrganizationSeqs()[Integer.parseInt(index)]);
			o.copyAudit(contentsOrganization);
			contentsOrganizations.add(o);
		}

		if (contentsOrganizations.size() > 0) {
			mav.addObject("result", contentsOrganizationService.insertlistContentsOrganization(contentsOrganizations));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}
}
