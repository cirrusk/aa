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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.RmiCacheService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.UIUnivCategoryVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCategoryCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCategoryRS;
import com._4csoft.aof.univ.service.UnivCategoryService;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivCategoryVO;
import com._4csoft.aof.univ.vo.UnivYearTermVO;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UICategoryController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICategoryController extends BaseController {

	@Resource (name = "UnivCategoryService")
	private UnivCategoryService categoryService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	@Resource (name = "RmiCacheService")
	private RmiCacheService rmiCacheService;

	/**
	 * 분류 메인 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/category/main.do")
	public ModelAndView main(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/infra/category/mainCategory");
		return mav;
	}

	/**
	 * 분류 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/category/{categoryType}/list.do", "/category/{categoryType}/list/iframe.do", "/category/{categoryType}/list/popup.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("categoryType") String categoryType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIUnivCategoryVO category = new UIUnivCategoryVO();
		category.setCategoryTypeCd("CATEGORY_TYPE::" + categoryType.toUpperCase());

		String viewName = "/infra/category/listCategory";
		if (req.getServletPath().endsWith("/iframe.do")) {
			viewName += "Iframe";

			if ("CATEGORY_TYPE::DEGREE".equals(category.getCategoryTypeCd())) {
				// 시스템에 설정된 년도학기
				MemberVO ssMember = SessionUtil.getMember(req);
				if (ssMember.getExtendData().get("systemYearTerm") == null) {
					// 현재 년도의 1학기로 셋팅한다.
					String defaultTerm = "10";
					String yearTerm = DateUtil.getTodayYear() + defaultTerm;
					mav.addObject("systemYearTerm", yearTerm);
				} else {
					mav.addObject("systemYearTerm", ((UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm")).getYearTerm());
				}

				// 검색 조건의 년도학기
				mav.addObject("yearTerms", univYearTermService.getListYearTermAll());
			}
		} else if (req.getServletPath().endsWith("/popup.do")) {
			viewName += "Popup";
		}
		mav.addObject("detailRoot", categoryService.getDetailCategoryRoot(category.getCategoryTypeCd()));
		mav.addObject("category", category);
		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 분류 목록 ajax 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCategoryCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/category/list/ajax.do")
	public ModelAndView listdata(HttpServletRequest req, HttpServletResponse res, UIUnivCategoryCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "srchParentSeq=0", "srchGroupLevel=1");

		mav.addObject("listCategory", categoryService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/category/listCategoryAjax");
		return mav;
	}

	/**
	 * 분류 목록 ajax 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCategoryCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/category/list/json.do")
	public ModelAndView listdataJson(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIUnivCategoryCondition condition = new UIUnivCategoryCondition();
		condition.setSrchCategoryTypeCd(HttpUtil.getParameter(req, "srchCategoryTypeCd", ""));
		condition.setSrchParentSeq((HttpUtil.getParameter(req, "srchParentSeq", 0L)));

		if ("CATEGORY_TYPE::DEGREE".equals(condition.getSrchCategoryTypeCd())) {
			if (StringUtil.isNotEmpty(condition.getSrchParentSeq()) && StringUtil.isEmpty(condition.getSrchYearTerm())) {
				// 시스템에 설정된 년도학기
				MemberVO ssMember = SessionUtil.getMember(req);
				String yearTerm = "";
				if (ssMember.getExtendData().get("systemYearTerm") == null) {
					// 현재 년도의 1학기로 셋팅한다.
					String defaultTerm = "10";
					yearTerm = DateUtil.getTodayYear() + defaultTerm;
				} else {
					yearTerm = ((UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm")).getYearTerm();
				}
				condition.setSrchYearTerm(yearTerm);
			}
		}
		mav.addObject("list", categoryService.getList(condition));

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 분류 목록 ajax 화면 - 상위 분류 포함.
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCategoryCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/category/parent/list/json.do")
	public ModelAndView listdataParentJson(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		Long categorySeq = HttpUtil.getParameter(req, "categorySeq", 0L);
		String srchCategoryTypeCd = HttpUtil.getParameter(req, "srchCategoryTypeCd", "");

		mav.addObject("list", getListCategoryFamily(categorySeq, srchCategoryTypeCd));

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 자신의 상위 분류 포함 목록을 구한다
	 * 
	 * @param categorySeq
	 * @param categoryTypeCd
	 * @return List<ResultSet>
	 * @throws Exception
	 */
	public List<ResultSet> getListCategoryFamily(Long categorySeq, String categoryTypeCd) throws Exception {
		List<ResultSet> list = new ArrayList<ResultSet>();
		UIUnivCategoryVO category = new UIUnivCategoryVO();
		UIUnivCategoryCondition condition = new UIUnivCategoryCondition();

		category.setCategorySeq(categorySeq);
		UIUnivCategoryRS detail = (UIUnivCategoryRS)categoryService.getDetail(category);
		if (detail != null) {
			condition.setSrchParentSeq(detail.getCategory().getCategorySeq());
			condition.setSrchCategoryTypeCd(categoryTypeCd);
			list.addAll(categoryService.getList(condition));

			if (StringUtil.isNotEmpty(detail.getCategory().getParentSeq())) {
				list.addAll(getListCategoryFamily(detail.getCategory().getParentSeq(), categoryTypeCd));
			}
		}
		return list;
	}

	/**
	 * 분류 목록 ajax 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCategoryVO
	 * @param UIUnivCategoryCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/category/detail/ajax.do")
	public ModelAndView detaildata(HttpServletRequest req, HttpServletResponse res, UIUnivCategoryVO category, UIUnivCategoryCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivCategoryRS detail = null;
		if (StringUtil.isNotEmpty(category.getCategorySeq())) {
			detail = (UIUnivCategoryRS)categoryService.getDetail(category);
		}

		// 하위 목록
		if (detail != null) {
			mav.addObject("detail", detail);
			condition.setSrchParentSeq(detail.getCategory().getCategorySeq());
		} else {
			emptyValue(condition, "srchParentSeq=0");
		}
		mav.addObject("listCategory", categoryService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/category/detailCategoryAjax");
		return mav;
	}

	/**
	 * 분류 신규등록
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCategoryVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/category/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCategoryVO category) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, category);

		categoryService.insertCategory(category);

		rmiCacheService.rmiRemoveCache("cacheCategory", ""); // 원격 캐쉬 삭제

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 분류 순서변경 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCategoryVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/category/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UIUnivCategoryVO category) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, category);

		List<UnivCategoryVO> categorys = new ArrayList<UnivCategoryVO>();
		for (int i = 0; i < category.getCategorySeqs().length; i++) {
			UIUnivCategoryVO o = new UIUnivCategoryVO();
			o.setCategorySeq(category.getCategorySeqs()[i]);
			o.setCategoryName(category.getCategoryNames()[i]);
			o.setSortOrder(category.getSortOrders()[i]);
			o.setOldCategoryString(category.getOldCategoryStrings()[i]);
			o.setCategoryString(category.getCategoryStrings()[i]);
			o.copyAudit(category);
			categorys.add(o);
		}

		if (categorys.size() > 0) {
			mav.addObject("result", categoryService.updatelistCategory(categorys));
		} else {
			mav.addObject("result", 0);
		}

		rmiCacheService.rmiRemoveCache("cacheCategory", ""); // 원격 캐쉬 삭제

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 분류 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCategoryVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/category/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIUnivCategoryVO category) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, category);

		List<UnivCategoryVO> categorys = new ArrayList<UnivCategoryVO>();
		for (String index : category.getCheckkeys()) {
			UIUnivCategoryVO o = new UIUnivCategoryVO();
			o.setCategorySeq(category.getCategorySeqs()[Integer.parseInt(index)]);
			o.copyAudit(category);
			categorys.add(o);
		}

		if (categorys.size() > 0) {
			mav.addObject("result", categoryService.deletelistCategory(categorys));
		} else {
			mav.addObject("result", 0);
		}

		rmiCacheService.rmiRemoveCache("cacheCategory", ""); // 원격 캐쉬 삭제

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 팝업 메모,SMS, 이메일 회원 목록
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/category/member/list/iframe.do")
	public ModelAndView listCategoryIframe(HttpServletRequest req, HttpServletResponse res, UIUnivCategoryCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", categoryService.getCategoryListAll(condition));
		mav.addObject("condition", condition);
		mav.setViewName("/infra/category/listCategoryMemberIframe");

		return mav;
	}

	@RequestMapping ("/category/list/level/ajax.do")
	public ModelAndView listLeveldata(HttpServletRequest req, HttpServletResponse res, UIUnivCategoryCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "srchParentSeq=0", "srchGroupLevel=1");

		mav.addObject("listCategory", categoryService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/category/listCategoryAjax");
		return mav;
	}

}
