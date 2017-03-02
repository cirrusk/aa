/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.MenuService;
import com._4csoft.aof.infra.service.RmiCacheService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.vo.MenuVO;
import com._4csoft.aof.ui.infra.vo.UIMenuVO;
import com._4csoft.aof.ui.infra.vo.condition.UIMenuCondition;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIMenuController.java
 * @Title : 그룹관리
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : 시스템관리 > 그룹관리 메뉴
 */
@Controller
public class UIMenuController extends BaseController {

	@Resource (name = "MenuService")
	private MenuService menuService;

	@Resource (name = "RmiCacheService")
	private RmiCacheService rmiCacheService;

	/**
	 * 메뉴 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIMenuCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/menu/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIMenuCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=2");

		mav.addObject("paginate", menuService.getListMenu(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/menu/listMenu");
		return mav;
	}

	/**
	 * 메뉴 목록 팝업 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIMenuCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/menu/list/popup.do")
	public ModelAndView listPopup(HttpServletRequest req, HttpServletResponse res, UIMenuCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", menuService.getListMenu(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/menu/listMenuPopup");
		return mav;
	}

	/**
	 * 메뉴 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIMenuVO
	 * @param UIMenuCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/menu/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIMenuVO menu, UIMenuCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", menuService.getDetailMenu(menu));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/menu/detailMenu");
		return mav;
	}

	/**
	 * 메뉴 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIMenuCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/menu/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIMenuCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);

		mav.setViewName("/infra/menu/createMenu");
		return mav;
	}

	/**
	 * 메뉴 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIMenuVO
	 * @param UIMenuCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/menu/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIMenuVO menu, UIMenuCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", menuService.getDetailMenu(menu));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/menu/editMenu");
		return mav;
	}

	/**
	 * 메뉴 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIMenuVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/menu/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIMenuVO menu) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, menu);

		menuService.insertMenu(menu);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 메뉴 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIMenuVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/menu/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIMenuVO menu) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, menu);

		menuService.updateMenu(menu);

		rmiCacheService.rmiRemoveCache("cacheRolegroupMenu", ""); // 원격 캐쉬 삭제

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 메뉴 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIMenuVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/menu/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIMenuVO menu) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, menu);

		menuService.deleteMenu(menu);

		rmiCacheService.rmiRemoveCache("cacheRolegroupMenu", ""); // 원격 캐쉬 삭제

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 메뉴 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIMenuVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/menu/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIMenuVO menu) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, menu);

		List<MenuVO> menus = new ArrayList<MenuVO>();
		for (String index : menu.getCheckkeys()) {
			UIMenuVO o = new UIMenuVO();
			o.setMenuSeq(menu.getMenuSeqs()[Integer.parseInt(index)]);
			o.copyAudit(menu);

			menus.add(o);
		}

		if (menus.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", menuService.deletelistMenu(menus));

			rmiCacheService.rmiRemoveCache("cacheRolegroupMenu", ""); // 원격 캐쉬 삭제
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 메뉴아이디 중복 검사
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView (json)
	 * @throws Exception
	 */
	@RequestMapping ("/menu/duplicate.do")
	public ModelAndView duplicate(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		boolean duplicated = true;
		String menuId = HttpUtil.getParameter(req, "menuId", "");
		if (menuService.countByMenuId(menuId) > 0) {
			duplicated = true;
		} else {
			duplicated = false;
		}
		mav.addObject("duplicated", duplicated);

		mav.setViewName("jsonView");
		return mav;
	}

}
