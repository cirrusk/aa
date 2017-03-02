/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.RmiCacheService;
import com._4csoft.aof.infra.service.RolegroupMemberService;
import com._4csoft.aof.infra.service.RolegroupMenuService;
import com._4csoft.aof.infra.service.RolegroupService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.FileUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.vo.RolegroupMemberVO;
import com._4csoft.aof.infra.vo.RolegroupMenuVO;
import com._4csoft.aof.infra.vo.RolegroupVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupMemberVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupMenuVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupVO;
import com._4csoft.aof.ui.infra.vo.condition.UIRolegroupCondition;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIRolegroupController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIRolegroupController extends BaseController {

	@Resource (name = "RolegroupService")
	private RolegroupService rolegroupService;

	@Resource (name = "RolegroupMemberService")
	private RolegroupMemberService rolegroupMemberService;

	@Resource (name = "RolegroupMenuService")
	private RolegroupMenuService rolegroupMenuService;

	@Resource (name = "RmiCacheService")
	private RmiCacheService rmiCacheService;

	/**
	 * 롤그룹 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIRolegroupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		condition.setSrchGroupOrder(getCurrentGroupOrder(req));

		mav.addObject("paginate", rolegroupService.getListRolegroup(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/rolegroup/listRolegroup");
		return mav;
	}

	/**
	 * 롤그룹 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupVO
	 * @param UIRolegroupCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIRolegroupVO rolegroup, UIRolegroupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", rolegroupService.getDetailRolegroup(rolegroup));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/rolegroup/detailRolegroup");
		return mav;
	}

	/**
	 * 롤그룹 신규등록 화면 accessFtpDirs : ftp 디렉토리에 sub디렉토리가 있으면 셋팅된다.
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIRolegroupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);

		List<String> listDir = new ArrayList<String>();
		String path = Constants.UPLOAD_PATH_LCMS + Constants.DIR_FTP;
		List<File> dirs = FileUtil.listDirectory(path);
		if (dirs != null) {
			FileUtil.sortByName(dirs);
			for (File directory : dirs) {
				listDir.add(directory.getName());
			}
		}
		mav.addObject("accessFtpDirs", listDir);

		UIRolegroupCondition subCondition = new UIRolegroupCondition();

		subCondition.setSrchGroupOrder(getCurrentGroupOrder(req));

		subCondition.setCurrentPage(0);
		subCondition.setOrderby(4);
		Paginate<ResultSet> paginate = rolegroupService.getListRolegroup(subCondition);
		mav.addObject("subRolegroupList", paginate.getItemList());

		mav.setViewName("/infra/rolegroup/createRolegroup");
		return mav;
	}

	/**
	 * 롤그룹 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupVO
	 * @param UIRolegroupCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIRolegroupVO rolegroup, UIRolegroupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", rolegroupService.getDetailRolegroup(rolegroup));
		mav.addObject("condition", condition);

		List<String> listDir = new ArrayList<String>();
		String path = Constants.UPLOAD_PATH_LCMS + Constants.DIR_FTP;
		List<File> dirs = FileUtil.listDirectory(path);
		if (dirs != null) {
			FileUtil.sortByName(dirs);
			for (File directory : dirs) {
				listDir.add(directory.getName());
			}
		}
		mav.addObject("accessFtpDirs", listDir);

		mav.setViewName("/infra/rolegroup/editRolegroup");
		return mav;
	}

	/**
	 * 롤그룹 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIRolegroupVO rolegroup) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, rolegroup);

		rolegroupService.insertRolegroup(rolegroup);

		rmiCacheService.rmiRemoveCache("cacheRolegroupAccess", ""); // 원격 캐쉬 삭제

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 롤그룹 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIRolegroupVO rolegroup) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, rolegroup);

		rolegroupService.updateRolegroup(rolegroup);

		rmiCacheService.rmiRemoveCache("cacheRolegroupAccess", ""); // 원격 캐쉬 삭제

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 롤그룹 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIRolegroupVO rolegroup) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, rolegroup);

		rolegroupService.deleteRolegroup(rolegroup);

		rmiCacheService.rmiRemoveCache("cacheRolegroupAccess", ""); // 원격 캐쉬 삭제

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 롤그룹 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIRolegroupVO rolegroup) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, rolegroup);

		List<RolegroupVO> rolegroups = new ArrayList<RolegroupVO>();
		for (String index : rolegroup.getCheckkeys()) {
			UIRolegroupVO o = new UIRolegroupVO();
			o.setRolegroupSeq(rolegroup.getRolegroupSeqs()[Integer.parseInt(index)]);
			o.copyAudit(rolegroup);

			rolegroups.add(o);
		}

		if (rolegroups.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", rolegroupService.deletelistRolegroup(rolegroups));
		}

		rmiCacheService.rmiRemoveCache("cacheRolegroupAccess", ""); // 원격 캐쉬 삭제

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 롤그룹멤버 목록 Ajax 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/member/list/ajax.do")
	public ModelAndView listMember(HttpServletRequest req, HttpServletResponse res, UIRolegroupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", rolegroupMemberService.getListRolegroupMember(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/rolegroup/listRolegroupMemberAjax");
		return mav;
	}

	/**
	 * 롤그룹멤버 다중 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupMemberVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/member/insertlist.do")
	public ModelAndView insertlist(HttpServletRequest req, HttpServletResponse res, UIRolegroupMemberVO rolegroupMember) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, rolegroupMember);

		List<RolegroupMemberVO> rolegroupMembers = new ArrayList<RolegroupMemberVO>();
		for (Long memberSeq : rolegroupMember.getMemberSeqs()) {
			UIRolegroupMemberVO o = new UIRolegroupMemberVO();
			o.setRolegroupSeq(rolegroupMember.getRolegroupSeq());
			o.setMemberSeq(memberSeq);
			o.copyAudit(rolegroupMember);

			rolegroupMembers.add(o);
		}

		if (rolegroupMembers.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", rolegroupMemberService.insertlistRolegroupMember(rolegroupMembers));
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 롤그룹멤버 다중 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupMemberVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/member/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIRolegroupMemberVO rolegroupMember) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, rolegroupMember);

		List<RolegroupMemberVO> rolegroupMembers = new ArrayList<RolegroupMemberVO>();
		for (String index : rolegroupMember.getCheckkeys()) {
			UIRolegroupMemberVO o = new UIRolegroupMemberVO();
			o.setRolegroupSeq(rolegroupMember.getRolegroupSeqs()[Integer.parseInt(index)]);
			o.setMemberSeq(rolegroupMember.getMemberSeqs()[Integer.parseInt(index)]);
			o.copyAudit(rolegroupMember);

			rolegroupMembers.add(o);
		}

		if (rolegroupMembers.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", rolegroupMemberService.deletelistRolegroupMember(rolegroupMembers));
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 롤그룹메뉴 목록 Ajax 화면
	 * 
	 * @param req
	 * @param res
	 * @param rolegroupMenu
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/menu/list/ajax.do")
	public ModelAndView listMenu(HttpServletRequest req, HttpServletResponse res, UIRolegroupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req);

		mav.addObject("appRolegroupSeq", condition.getSrchRolegroupSeq());

		mav.addObject("list", rolegroupMenuService.getListInParent(condition.getSrchGroupOrder(), condition.getSrchRolegroupSeq()));

		mav.setViewName("/infra/rolegroup/listRolegroupMenuAjax");
		return mav;
	}

	/**
	 * 롤그룹메뉴 다중 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIRolegroupMenuVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/rolegroup/menu/updatelist.do")
	public ModelAndView insertlist(HttpServletRequest req, HttpServletResponse res, UIRolegroupMenuVO rolegroupMenu) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, rolegroupMenu);

		List<RolegroupMenuVO> rolegroupMenus = new ArrayList<RolegroupMenuVO>();
		for (int index = 0; index < rolegroupMenu.getMenuSeqs().length; index++) {
			UIRolegroupMenuVO o = new UIRolegroupMenuVO();
			o.setRolegroupSeq(rolegroupMenu.getRolegroupSeqs()[index]);
			o.setMenuSeq(rolegroupMenu.getMenuSeqs()[index]);
			o.setMandatoryYn(rolegroupMenu.getMandatoryYns()[index]);
			o.setCrud(rolegroupMenu.getCruds()[index]);
			o.copyAudit(rolegroupMenu);

			String oldCrud = rolegroupMenu.getOldCruds()[index];
			String oldMandatoryYns = rolegroupMenu.getOldMandatoryYns()[index];

			if (oldCrud.equals(o.getCrud())) {
				if (!oldMandatoryYns.equals(o.getMandatoryYn())) { // 추가로 필수여부 변경시 처리함.
					rolegroupMenus.add(o);
				}
			} else {// 변경되었으면 처리함.
				rolegroupMenus.add(o);
			}
		}

		if (rolegroupMenus.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", rolegroupMenuService.savelistRolegroupMenu(rolegroupMenus));
		}

		rmiCacheService.rmiRemoveCache("cacheRolegroupMenu", ""); // 원격 캐쉬 삭제

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 현재 권한의 cs_group_order(순서) 값을 계산해서 가지고 옵니다. 예 : 001001
	 * 
	 * @param req
	 * @return String
	 */
	public String getCurrentGroupOrder(HttpServletRequest req) {

		String groupOrder = "";

		UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);
		Long currentRolegroupSeq = ssMember.getCurrentRolegroupSeq();
		if (currentRolegroupSeq != 1L) {// 시스템관리그룹은 모두다 사용가능
			for (RolegroupVO rg : ssMember.getRoleGroups()) {
				if (rg.getRolegroupSeq().equals(currentRolegroupSeq)) {
					groupOrder = rg.getGroupOrder();
					break;
				}
			}
		}
		return groupOrder;
	}

}
