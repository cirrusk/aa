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

import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.infra.service.RmiCacheService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.vo.CodeVO;
import com._4csoft.aof.ui.infra.vo.UICodeVO;
import com._4csoft.aof.ui.infra.vo.condition.UICodeCondition;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UICodeController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 서진철
 * @descrption : 코드 관리
 */
@Controller
public class UICodeController extends BaseController {

	@Resource (name = "CodeService")
	private CodeService codeService;

	@Resource (name = "RmiCacheService")
	private RmiCacheService rmiCacheService;

	/**
	 * 코드그룹 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/list.do")
	public ModelAndView listCodegrup(HttpServletRequest req, HttpServletResponse res, UICodeCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", codeService.getListCodeGroup(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/code/listCodegroup");
		return mav;
	}

	/**
	 * 코드그룹 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param code
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UICodeVO code, UICodeCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", codeService.getDetail(code));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/code/detailCodegroup");
		return mav;
	}

	/**
	 * 하위코드의 등록 Ajax 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/create/popup.do")
	public ModelAndView createSubCode(HttpServletRequest req, HttpServletResponse res, UICodeCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);

		mav.setViewName("/infra/code/createSubCodePopup");
		return mav;
	}

	/**
	 * 하위코드의 수정 Ajax 화면
	 * 
	 * @param req
	 * @param res
	 * @param code
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/edit/popup.do")
	public ModelAndView editSubCode(HttpServletRequest req, HttpServletResponse res, UICodeVO code, UICodeCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", codeService.getDetail(code));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/code/editSubCodePopup");
		return mav;
	}

	/**
	 * 코드그룹 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param rolegroup
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/create.do")
	public ModelAndView createCodeGroup(HttpServletRequest req, HttpServletResponse res, UICodeCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);

		mav.setViewName("/infra/code/createCodegroup");
		return mav;
	}

	/**
	 * 코드그룹 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param rolegroup
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/edit.do")
	public ModelAndView editCodeGroup(HttpServletRequest req, HttpServletResponse res, UICodeVO code, UICodeCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", codeService.getDetail(code));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/code/editCodegroup");
		return mav;
	}

	/**
	 * 코드그룹 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param rolegroup
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/insert.do")
	public ModelAndView insertCode(HttpServletRequest req, HttpServletResponse res, UICodeVO code) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, code);
		// 코드그룹은 cs_code_group와 cs_code코드값이 같게 셋팅한다.
		code.setCodeGroup(code.getCode());

		try {
			int result = codeService.insertCode(code);
			if (result == Errors.DATA_EXIST.code) {
				mav.addObject("result", result);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 하위코드 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param rolegroup
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/sub/insert.do")
	public ModelAndView insertSubCode(HttpServletRequest req, HttpServletResponse res, UICodeVO code) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, code);

		try {
			int result = codeService.insertCode(code);
			if (result == Errors.DATA_EXIST.code) {
				mav.addObject("result", result);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 코드그룹 및 하위 코드 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param rolegroup
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/update.do")
	public ModelAndView updateCodeGroup(HttpServletRequest req, HttpServletResponse res, UICodeVO code) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, code);

		try {
			int result = codeService.updateCode(code);
			if (result == Errors.DATA_EXIST.code) {
				mav.addObject("result", result);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		rmiCacheService.rmiRemoveCache("cacheCode", code.getCodeGroup()); // 원격 코드 캐쉬 삭제

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 코드그룹의 하위코드 목록 Ajax 화면
	 * 
	 * @param req
	 * @param res
	 * @param code
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/sub/list/ajax.do")
	public ModelAndView listSubCode(HttpServletRequest req, HttpServletResponse res, UICodeVO code, UICodeCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("itemList", codeService.getListCode(condition.getSrchCodeGroup()));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/code/listSubCodeAjax");
		return mav;
	}

	/**
	 * 그룹 코드 단일 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param code
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UICodeVO code) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, code);

		mav.addObject("result", codeService.deleteCodeGroup(code));

		rmiCacheService.rmiRemoveCache("cacheCode", code.getCodeGroup()); // 원격 코드 캐쉬 삭제

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 그룹 코드 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param code
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UICodeVO code) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, code);

		List<CodeVO> codes = new ArrayList<CodeVO>();
		for (String index : code.getCheckkeys()) {
			UICodeVO o = new UICodeVO();
			o.setCodeGroup(code.getCodeGroups()[Integer.parseInt(index)]);
			o.copyAudit(code);

			codes.add(o);
		}

		if (codes.size() > 0) {
			mav.addObject("result", codeService.deletelistCodeGroup(codes));

			for (CodeVO vo : codes) { // 원격 코드 캐쉬 삭제
				rmiCacheService.rmiRemoveCache("cacheCode", vo.getCodeGroup());
			}
		} else {
			mav.addObject("result", 0);
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 하위 코드 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param code
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/sub/deletelist.do")
	public ModelAndView deleteSubList(HttpServletRequest req, HttpServletResponse res, UICodeVO code) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, code);

		List<CodeVO> codes = new ArrayList<CodeVO>();
		for (String index : code.getCheckkeys()) {
			UICodeVO o = new UICodeVO();
			o.setCodeGroup(code.getCodeGroups()[Integer.parseInt(index)]);
			o.setCode(code.getCodes()[Integer.parseInt(index)]);
			o.copyAudit(code);

			codes.add(o);
		}

		if (codes.size() > 0) {
			mav.addObject("result", codeService.deletelistCode(codes));

			for (CodeVO vo : codes) { // 원격 코드 캐쉬 삭제
				rmiCacheService.rmiRemoveCache("cacheCode", vo.getCodeGroup());
			}
		} else {
			mav.addObject("result", 0);
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 코드 중복 검사 json
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/duplicate.do")
	public ModelAndView duplicate(HttpServletRequest req, HttpServletResponse res, UICodeVO code) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		boolean duplicated = true;
		if (codeService.countCode(code) > 0) {
			duplicated = true;
		} else {
			if (codeService.countDeletedCode(code) > 0) {
				duplicated = true;
			} else {
				duplicated = false;
			}
		}

		mav.addObject("duplicated", duplicated);

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 정렬순서 수정 Ajax 화면
	 * 
	 * @param req
	 * @param res
	 * @param code
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/edit/sort/popup.do")
	public ModelAndView editSubCodeSortOrder(HttpServletRequest req, HttpServletResponse res, UICodeVO code, UICodeCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("itemList", codeService.getListCode(condition.getSrchCodeGroup()));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/code/editSubCodeSortOrderPopup");
		return mav;
	}

	/**
	 * 코드그룹 및 하위 코드 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param rolegroup
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/code/sortorder/update.do")
	public ModelAndView updateCodeSortOrder(HttpServletRequest req, HttpServletResponse res, UICodeVO code) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, code);

		List<CodeVO> codes = new ArrayList<CodeVO>();

		for (int i = 0; i < code.getSortOrders().length; i++) {
			UICodeVO o = new UICodeVO();
			o.setSortOrder(code.getSortOrders()[i]);
			o.setCodeGroup(code.getCodeGroups()[i]);
			o.setCode(code.getCodes()[i]);
			o.copyAudit(code);

			codes.add(o);
		}

		if (codes.size() > 0) {
			mav.addObject("result", codeService.updatelistCode(codes));

			for (CodeVO vo : codes) { // 원격 코드 캐쉬 삭제
				rmiCacheService.rmiRemoveCache("cacheCode", vo.getCodeGroup());
			}
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

}
