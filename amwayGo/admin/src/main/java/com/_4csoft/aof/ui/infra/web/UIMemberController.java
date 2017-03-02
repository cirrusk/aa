/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jxls.reader.XLSDataReadException;
import net.sf.jxls.reader.XLSReadStatus;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.CategoryService;
import com._4csoft.aof.infra.service.CodeService;
import com._4csoft.aof.infra.service.RolegroupMemberService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.parser.ExcelParser;
import com._4csoft.aof.infra.support.security.PasswordEncoder;
import com._4csoft.aof.infra.support.util.AttachUtil;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.support.view.ExcelDownloadView;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.service.UIAgreementService;
import com._4csoft.aof.ui.infra.service.UIMemberService;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UICompanyMemberVO;
import com._4csoft.aof.ui.infra.vo.UIMemberAdminVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.UIRolegroupMemberVO;
import com._4csoft.aof.ui.infra.vo.condition.UIMemberCondition;
import com._4csoft.aof.ui.infra.vo.resultset.UIMemberAdminRS;
import com._4csoft.aof.ui.infra.vo.resultset.UIMemberRS;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveLecturerCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveLecturerService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseApplyService;

import egovframework.com.cmm.EgovMessageSource;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIMemberController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 2.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIMemberController extends BaseController {

	@Resource (name = "UIMemberService")
	private UIMemberService memberService;

	@Resource (name = "RolegroupMemberService")
	private RolegroupMemberService rolegroupMemberService;

	@Resource (name = "CategoryService")
	private CategoryService categoryService;

	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyService courseApplyService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "UnivCourseActiveLecturerService")
	private UnivCourseActiveLecturerService univCourseActiveLecturerService;

	@Resource (name = "egovMessageSource")
	EgovMessageSource messageSource;

	@Resource (name = "CodeService")
	private CodeService codeService;

	@Resource (name = "UIPasswordEncoder")
	protected PasswordEncoder passwordEncoder;

	@Resource (name = "AttachUtil")
	private AttachUtil attachUtil;
	
	@Resource (name = "UIAgreementService")
	private UIAgreementService agreeMentService;

	private final String JXLS_PATH = "infra/jxls/";

	private final String JXLS_UPLOAD_PATH = JXLS_PATH + "upload/";

	private final String JXLS_DOWNLOAD_PATH = JXLS_PATH + "download/";

	/**
	 * 멤버 목록 화면, 멤버 목록 팝업 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/{memberType}/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("memberType") String memberType, UIMemberCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		Paginate<ResultSet> paginate = null;
		String viewName = "/infra/member/listMember" + StringUtil.capitalize(memberType);

		condition.setSrchMemberType(memberType);
		if ("admin".equals(memberType)) {
			paginate = memberService.getListAdmin(condition);

		} else if ("prof".equals(memberType)) {
			paginate = memberService.getListAdmin(condition);

		} else if ("user".equals(memberType)) {
			paginate = memberService.getList(condition);

		} else if ("cdms".equals(memberType)) {
			paginate = memberService.getListAdmin(condition);

		} else if ("all".equals(memberType)) { // 권한 상관 없이 전체 검색에 사용
			paginate = memberService.getList(condition);

		}

		mav.addObject("memberType", memberType);
		mav.addObject("paginate", paginate);
		mav.addObject("condition", condition);
		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 멤버 상세정보 화면, 멤버 상세정보 Ajax 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberVO
	 * @param UIMemberCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/member/{memberType}/detail.do", "/member/{memberType}/detail/ajax.do", "/member/{memberType}/detail/iframe.do" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, @PathVariable ("memberType") String memberType, UIMemberVO member,
			UIMemberCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		ResultSet detail = null;
		String viewName = "/infra/member/detailMember" + StringUtil.capitalize(memberType);
		detail = memberService.getDetail(member);

		if (detail != null) {
			String memberId = ((UIMemberRS)detail).getMember().getMemberId();
			mav.addObject("listRolegroup", rolegroupMemberService.getListByMemberId(memberId));
		}

		if (req.getServletPath().endsWith("ajax.do")) {
			viewName = "/infra/member/detailMemberAjax";
		}

		if (req.getServletPath().endsWith("iframe.do")) {
			mav.addObject("decorator", "iframe");
		}

		mav.addObject("detail", detail);
		mav.addObject("condition", condition);
		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 멤버 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/{memberType}/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, @PathVariable ("memberType") String memberType, UIMemberCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String viewName = "/infra/member/createMember" + StringUtil.capitalize(memberType);

		mav.addObject("condition", condition);
		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 멤버 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberVO
	 * @param UIMemberCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/{memberType}/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, @PathVariable ("memberType") String memberType, UIMemberVO member,
			UIMemberCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		ResultSet detail = null;
		String viewName = "/infra/member/editMember" + StringUtil.capitalize(memberType);
		if ("admin".equals(memberType)) {
			detail = memberService.getDetail(member);

		} else if ("prof".equals(memberType)) {
			detail = memberService.getDetail(member);

		} else if ("user".equals(memberType)) {
			detail = memberService.getDetail(member);

		} else if ("cdms".equals(memberType)) {
			detail = memberService.getDetail(member);

		}

		if (detail != null) {
			String memberId = ((UIMemberRS)detail).getMember().getMemberId();
			mav.addObject("listRolegroup", rolegroupMemberService.getListByMemberId(memberId));
		}

		mav.addObject("detail", detail);
		mav.addObject("condition", condition);
		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 멤버 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/{memberType}/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, @PathVariable ("memberType") String memberType, UIMemberVO member)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, member);

		String passwordUpdDtime = DateUtil.getToday(Constants.FORMAT_DBDATETIME);
		String planPasswordUpdDtime = DateUtil.getFormatString(DateUtil.addDate(DateUtil.getFormatDate(passwordUpdDtime, Constants.FORMAT_DBDATETIME), 90),
				Constants.FORMAT_DBDATETIME);
		member.setPlanPasswordUpdDtime(planPasswordUpdDtime);

		if ("admin".equals(memberType) || "prof".equals(memberType) || "cdms".equals(memberType)) {
			UIMemberAdminVO memberAdmin = new UIMemberAdminVO();
			requiredSession(req, memberAdmin);
			memberAdmin.setJobTypeCd(HttpUtil.getParameter(req, "jobTypeCd"));
			memberAdmin.setProfTypeCd(HttpUtil.getParameter(req, "profTypeCd"));
			memberAdmin.setCdmsTaskTypeCd(HttpUtil.getParameter(req, "cdmsTaskTypeCd"));

			UICompanyMemberVO companyMember = null;
			if ("cdms".equals(memberType)) {
				companyMember = new UICompanyMemberVO();
				companyMember.setCompanySeq(Long.parseLong(HttpUtil.getParameter(req, "companySeq")));
			}

			memberService.insertMember(member, memberAdmin, companyMember);

		} else if ("user".equals(memberType)) {

			member.setBirthday(HttpUtil.getParameter(req, "year") + HttpUtil.getParameter(req, "month") + HttpUtil.getParameter(req, "day"));
			memberService.insertMember(member, null, null);

		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 멤버 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/{memberType}/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, @PathVariable ("memberType") String memberType, UIMemberVO member)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, member);

		if (req.getParameter("updateType") != null && "modify".equals(req.getParameter("updateType"))) {

			String passwordUpdDtime = DateUtil.getToday(Constants.FORMAT_DBDATETIME);

			String planPasswordUpdDtime = DateUtil.getFormatString(DateUtil.addDate(DateUtil.getFormatDate(passwordUpdDtime, Constants.FORMAT_DBDATETIME), 90),
					Constants.FORMAT_DBDATETIME);
			member.setPlanPasswordUpdDtime(planPasswordUpdDtime);
		}

		if ("admin".equals(memberType) || "prof".equals(memberType) || "cdms".equals(memberType)) {
			UIMemberAdminVO memberAdmin = new UIMemberAdminVO();
			requiredSession(req, memberAdmin);
			memberAdmin.setMemberSeq(member.getMemberSeq());
			memberAdmin.setJobTypeCd(HttpUtil.getParameter(req, "jobTypeCd"));
			memberAdmin.setProfTypeCd(HttpUtil.getParameter(req, "profTypeCd"));
			memberAdmin.setCdmsTaskTypeCd(HttpUtil.getParameter(req, "cdmsTaskTypeCd"));

			UICompanyMemberVO companyMember = null;
			if ("cdms".equals(memberType)) {
				companyMember = new UICompanyMemberVO();
				companyMember.setMemberSeq(member.getMemberSeq());
				companyMember.setCompanySeq(Long.parseLong(HttpUtil.getParameter(req, "companySeq")));
				companyMember.setCompanySeqOld(Long.parseLong(HttpUtil.getParameter(req, "companySeqOld")));
			}

			memberService.updateMember(member, memberAdmin, companyMember);

		} else if ("user".equals(memberType)) {
			memberService.updateMember(member, null, null);

		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 멤버 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIMemberVO member) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, member);

		memberService.deleteMember(member);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 멤버 멀티 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIMemberVO member) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, member);

		List<MemberVO> members = new ArrayList<MemberVO>();
		for (String index : member.getCheckkeys()) {
			UIMemberVO o = new UIMemberVO();
			o.setMemberSeq(member.getMemberSeqs()[Integer.parseInt(index)]);
			o.copyAudit(member);

			members.add(o);
		}

		if (members.size() > 0) {
			mav.addObject("result", memberService.deletelistMember(members));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 멤버(memberId, nickname) 중복 검사 json
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView (json)
	 * @throws Exception
	 */
	@RequestMapping ("/member/duplicate.do")
	public ModelAndView duplicate(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		Long memberSeq = HttpUtil.getParameter(req, "memberSeq", 0L);
		String memberId = HttpUtil.getParameter(req, "memberId", "");
		String nickname = HttpUtil.getParameter(req, "nickname", "");

		boolean duplicated = true;
		if (StringUtil.isNotEmpty(memberId)) {
			if (memberService.countMemberId(memberId, memberSeq) > 0) {
				duplicated = true;
			} else {
				duplicated = false;
			}
		} else if (StringUtil.isNotEmpty(nickname)) {
			if (memberService.countNickname(nickname, memberSeq) > 0) {
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
	 * 회원정보를 excel로 다운로드 한다.
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberCondition
	 * @throws Exception
	 */
	@RequestMapping ("/member/{memberType}/excel.do")
	public ModelAndView excel(HttpServletRequest req, HttpServletResponse res, UIMemberCondition condition) throws Exception {
		requiredSession(req);
		ModelAndView mav = new ModelAndView();

		emptyValue(condition, "currentPage=0", "orderby=0");
		Paginate<ResultSet> paginate = memberService.getList(condition);

		mav.setViewName("excelView");
		mav.addObject("list", paginate.getItemList());
		mav.addObject(ExcelDownloadView.TEMPLATE_FILE_NAME, JXLS_DOWNLOAD_PATH + "memberTemplate");
		mav.addObject(ExcelDownloadView.DOWNLOAD_FILE_NAME, "member_" + DateUtil.getToday("yyyyMMdd"));

		return mav;
	}

	/**
	 * 멤버 비밀번호 수정
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/member/password/popup.do", "/mypage/member/password.do" })
	public ModelAndView editPassword(HttpServletRequest req, HttpServletResponse res, UIMemberVO member) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("member", member);

		if ("/member/password/popup.do".equals(req.getServletPath())) {
			mav.setViewName("/infra/member/editPasswordPopup");
		} else {
			member.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
			mav.addObject("detail", memberService.getDetail(member));

			mav.setViewName("/infra/member/editPassword");
		}

		return mav;
	}

	/**
	 * 멤버 비밀번호 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/member/password/update.do", "/mypage/password/update.do" })
	public ModelAndView updatePassword(HttpServletRequest req, HttpServletResponse res, UIMemberVO member) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, member);

		UIMemberRS detail = (UIMemberRS)memberService.getDetail(member);

		String passwordUpdDtime;
		if (detail.getMember().getPasswordUpdDtime() != null && !"".equals(detail.getMember().getPasswordUpdDtime())) {
			passwordUpdDtime = detail.getMember().getPasswordUpdDtime();
		} else {
			passwordUpdDtime = DateUtil.getToday(Constants.FORMAT_DBDATETIME);
		}
		String planPasswordUpdDtime = DateUtil.getFormatString(DateUtil.addDate(DateUtil.getFormatDate(passwordUpdDtime, Constants.FORMAT_DBDATETIME), 90),
				Constants.FORMAT_DBDATETIME);

		member.setPlanPasswordUpdDtime(planPasswordUpdDtime);
		member.setMemberId(detail.getMember().getMemberId());

		// 마이페이지 비밀번호
		if ("/mypage/password/update.do".equals(req.getServletPath())) {
			int result = 0;
			String salt = passwordEncoder.isUseSalt() ? passwordEncoder.encodePassword(member.getMemberId(), "") : "";
			String nowPassword = passwordEncoder.encodePassword(HttpUtil.getParameter(req, "nowPassword"), salt) + salt;
			if (nowPassword.equals(detail.getMember().getPassword())) {
				result = memberService.updatePassword(member);
			}

			mav.addObject("result", result);
		} else {
			memberService.updatePassword(member);
		}

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 멤버 상세정보 화면 하위 개설과목 이력 정보 iframe 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/detail/course/active/list/iframe.do")
	public ModelAndView listCourseActive(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", courseActiveService.getListCourseActive(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/member/listMemberCourseActiveIframe");

		return mav;
	}

	/**
	 * 멤버 상세정보 화면 하위 회원수강 이력 정보 iframe 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/detail/course/apply/list/iframe.do")
	public ModelAndView listCourseApply(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", courseApplyService.getListMyCourse(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/member/listMemberCourseApplyIframe");

		return mav;
	}

	/**
	 * 마이페이지 멤버 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberVO
	 * @param UIMemberCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/mypage/member/edit.do")
	public ModelAndView editMyPage(HttpServletRequest req, HttpServletResponse res, UIMemberCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String memberType = "admin";
		if (SessionUtil.getMember(req).getAdmin() != null) {
			if (SessionUtil.getMember(req).getAdmin().getProfTypeCd() != null && !"".equals(SessionUtil.getMember(req).getAdmin().getProfTypeCd())) {
				memberType = "prof";
			}
		} else {
			memberType = "user";
		}

		UIMemberVO member = new UIMemberVO();
		member.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());

		ResultSet detail = null;
		String viewName = "/infra/member/editMemberMyPage" + StringUtil.capitalize(memberType);
		detail = memberService.getDetail(member);

		if (detail != null) {
			String memberId = ((UIMemberRS)detail).getMember().getMemberId();
			mav.addObject("listRolegroup", rolegroupMemberService.getListByMemberId(memberId));
		}

		mav.addObject("detail", detail);
		mav.addObject("condition", condition);
		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 팝업 회원 목록 (주소록 그룹원추가 사용)
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/addressGroupMember/popup.do")
	public ModelAndView listMemberAddressGroupPopup(HttpServletRequest req, HttpServletResponse res, UIMemberCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", memberService.getListAddressGroup(condition));
		mav.addObject("condition", condition);
		mav.setViewName("/infra/member/listMemberAddressGroupPopup");

		return mav;
	}

	/**
	 * 회원 팝업 그룹관리, 메모, SMS, 이메일 목록
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/{memberType}/list/popup.do")
	public ModelAndView listMemberPopup(HttpServletRequest req, HttpServletResponse res, @PathVariable ("memberType") String memberType,
			UIMemberCondition condition, UIUnivCourseActiveLecturerCondition lecturerCondition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		//emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		String viewName = "/infra/member/listMemberMemoPopup";
		if ("/member/memo/list/popup.do".equals(req.getServletPath())) {
			mav.addObject("choice", "add");
			mav.addObject("srchType", "individual");
		} else {
			if (!"all".equals(memberType)) {
				condition.setSrchMemberType(memberType.toUpperCase());
			}

			if (SessionUtil.getMember(req).getCurrentRolegroupSeq().equals(1L) && StringUtil.isNotEmpty(lecturerCondition.getSrchActiveLecturerTypeCd())) {
				// 개설과목관리> 개설과목 상세정보 > 교강사권한관리 메뉴에서 조교, 튜터 추가시
				// 관리자일 경우 조교,튜터를 지정해서 등록해야한다.
				//emptyValue(lecturerCondition, "currentPage=0", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
				lecturerCondition.setSrchCourseActiveSeq(condition.getSrchNotInCourseActiveSeq());
				mav.addObject("profList", univCourseActiveLecturerService.getListCourseActiveLecturer(lecturerCondition));
			}

			viewName = "/infra/member/listMemberPopup";
			mav.addObject("condition", condition);
			mav.addObject("memberType", memberType);
			mav.addObject("paginate", memberService.getListExtend(condition));
		}

		mav.setViewName(viewName);

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
	@RequestMapping ("/member/memo/list/Iframe.do")
	public ModelAndView listMemberIframe(HttpServletRequest req, HttpServletResponse res, UIMemberCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", memberService.getListExtend(condition));
		mav.addObject("condition", condition);
		mav.setViewName("/infra/member/listMemberMemoIframe");

		return mav;
	}

	/**
	 * 교강사 이름 like 검색
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/prof/like/name/list/json.do")
	public ModelAndView listJson(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		UIMemberCondition condition = new UIMemberCondition();
		emptyValue(condition, "currentPage=0", "orderby=0");
		condition.setSrchKey("memberName");
		condition.setSrchWord(HttpUtil.getParameter(req, "srchWord", ""));

		if (!HttpUtil.getParameter(req, "srchCourseActiveSeq", "").equals("")) {
			condition.setSrchCourseActiveSeq(Long.parseLong(HttpUtil.getParameter(req, "srchCourseActiveSeq", "")));
		}

		if (!HttpUtil.getParameter(req, "srchActiveLecturerType", "").equals("")) {
			condition.setSrchActiveLecturerType(HttpUtil.getParameter(req, "srchActiveLecturerType", ""));
		}

		if (!HttpUtil.getParameter(req, "srchAssistMemberSeq", "").equals("")) {
			condition.setSrchAssistMemberSeq(Long.parseLong(HttpUtil.getParameter(req, "srchAssistMemberSeq", "")));
		}

		condition.setSrchMemberType("prof");
		Paginate<ResultSet> paginate = memberService.getListAdmin(condition);

		if (paginate != null) {
			List<ResultSet> listItem = paginate.getItemList();
			if (listItem != null) {
				List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
				for (int index = 0; index < listItem.size(); index++) {
					UIMemberAdminRS rs = (UIMemberAdminRS)listItem.get(index);
					HashMap<String, Object> map = new HashMap<String, Object>();
					map.put("memberSeq", rs.getMember().getMemberSeq());
					map.put("memberName", rs.getMember().getMemberName());
					map.put("categoryName", "");
					map.put("profTypeCd", rs.getAdmin().getProfTypeCd());

					list.add(map);
				}
				mav.addObject("list", list);
			}
		}
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 회원 상세 팝업
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/detail/popup.do")
	public ModelAndView detailMebmerPopup(HttpServletRequest req, HttpServletResponse res, UIMemberVO member) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req, member);

		mav.addObject("detail", memberService.getDetail(member));

		mav.setViewName("/infra/member/detailMemberPopup");

		return mav;
	}
	
	/**
	 * 약관동의 팝업
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/Agreement/popup.do")
	public ModelAndView detailAgreementPopup(HttpServletRequest req, HttpServletResponse res, UIMemberVO member,
			UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req, member);
		
		condition.setSrchMemberSeq(member.getMemberSeq());

		mav.addObject("detail", agreeMentService.getCallAgree(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/infra/member/agreementMemberPopup");

		return mav;
	}

	/**
	 * 회원 업로드용도의 엑셀 템플릿 다운로드
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/member/{memberType}/template/excel.do")
	public ModelAndView downloadExcelMemberTemplate(HttpServletRequest req, HttpServletResponse res, @PathVariable ("memberType") String memberType)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 공통코드
		final String CD_SEX = codes.get("CD.SEX");
		final String CD_COUNTRY = codes.get("CD.COUNTRY");
		final String CD_MEMBER_STATUS = codes.get("CD.MEMBER_STATUS");

		mav.addObject("sexes", codeService.getListCode(CD_SEX));
		mav.addObject("countries", codeService.getListCode(CD_COUNTRY));
		mav.addObject("memberStatuses", codeService.getListCode(CD_MEMBER_STATUS));

		if ("prof".equals(memberType)) {// 교강사
			final String CD_PROF_TYPE = codes.get("CD.PROF_TYPE");

			mav.addObject("profTypes", codeService.getListCode(CD_PROF_TYPE));
			mav.addObject(ExcelDownloadView.TEMPLATE_FILE_NAME, JXLS_UPLOAD_PATH + "profTemplate");

		} else if ("user".equals(memberType)) {// 학습자
			final String CD_POSITION = codes.get("CD.POSITION");

			mav.addObject("positions", codeService.getListCode(CD_POSITION));
			mav.addObject(ExcelDownloadView.TEMPLATE_FILE_NAME, JXLS_UPLOAD_PATH + "userTemplate");

		}

		mav.addObject(ExcelDownloadView.DOWNLOAD_FILE_NAME, "회원_템플릿_" + DateUtil.getToday("yyyyMMdd"));

		mav.setViewName("excelView");

		return mav;
	}

	/**
	 * 회원 일괄등록 엑셀 업로드
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/member/{memberType}/upload/popup.do")
	public ModelAndView uploadExcelApplyPopup(HttpServletRequest req, HttpServletResponse res, @PathVariable ("memberType") String memberType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("memberType", memberType);

		mav.setViewName("/infra/member/excelUploadPopup");
		return mav;
	}

	/**
	 * 회원 엑셀 업로드
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/member/{memberType}/attach/excel/save.do")
	public ModelAndView uploadExcelApply(HttpServletRequest req, HttpServletResponse res, @PathVariable ("memberType") String memberType, UIMemberVO vo,
			UIAttachVO attach) throws Exception {
		requiredSession(req, vo);

		ModelAndView mav = new ModelAndView();
		mav.setViewName("/common/save");

		File saveFile = null;
		try {
			attachUtil.copyToBean(attach);
			saveFile = new File(Constants.UPLOAD_PATH_FILE + attach.getSavePath() + "/" + attach.getSaveName());

			List<UIMemberVO> members = new ArrayList<UIMemberVO>();
			Map<String, Object> rowDataes = new HashMap<String, Object>();
			rowDataes.put("members", members);

			ExcelParser excelParse = new ExcelParser();

			UIMemberAdminVO memberAdmin = null;
			XLSReadStatus readStatus = null;
			if ("prof".equals(memberType)) {// 교강사
				memberAdmin = new UIMemberAdminVO();
				memberAdmin.copyAudit(vo);

				readStatus = excelParse.parse(rowDataes, saveFile, JXLS_UPLOAD_PATH + "profTemplate-jxls-config");

			} else if ("user".equals(memberType)) {// 학습자
				readStatus = excelParse.parse(rowDataes, saveFile, JXLS_UPLOAD_PATH + "userTemplate-jxls-config");
			}

			if (readStatus.isStatusOK()) {

				UIRolegroupMemberVO rolegroupMember = new UIRolegroupMemberVO();
				rolegroupMember.copyAudit(vo);

				int successCount = memberService.insertlistMember(members, rolegroupMember, memberAdmin);

				mav.addObject("result", "{\"success\":" + successCount + "}");
			} else {
				mav.addObject("result", "{\"success\":-1}");
			}
		} catch (XLSDataReadException xlsException) {
			if (saveFile != null && saveFile.exists()) {
				saveFile.delete();
			}
			xlsException.printStackTrace();
			log.error(xlsException);

			mav.addObject("result", "{\"success\":-1,\"error\": \"" + xlsException.getCellName() + "\",\"message\": \"" + xlsException.getMessage() + "\"}");

			return mav;
		} finally {
			if (saveFile != null && saveFile.exists()) {
				saveFile.delete();
			}
		}
		return mav;
	}
}
