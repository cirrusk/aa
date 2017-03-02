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

import com._4csoft.aof.infra.service.MemberService;
import com._4csoft.aof.infra.service.RolegroupMemberService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.exception.AofException;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.MailUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.condition.UIMemberCondition;
import com._4csoft.aof.ui.infra.vo.resultset.UIMemberRS;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseApplyService;
import com._4csoft.aof.univ.service.UnivYearTermService;

/**
 * @Project : aof5-demo-www
 * @Package : com._4csoft.aof.ui.infra.controller
 * @File : UICommonController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2012. 9. 25.
 * @author :
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIMemberController extends BaseController {

	@Resource (name = "MemberService")
	private MemberService memberService;

	@Resource (name = "RolegroupMemberService")
	private RolegroupMemberService rolegroupMemberService;

	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyService courseApplyService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	@Resource (name = "UIMailUtil")
	private MailUtil mailUtil;

	private final String REPLACE_EQUAL = "@"; // String encrypt 할 때 = 을 대체 하는 문자

	/**
	 * 약관동의화면 이동
	 *
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/member/terms/popup.do")
	public ModelAndView goTerms(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("/infra/member/terms");
		return mav;
	}

	/**
	 * 회원가입 화면
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws AofException
	 */
	@RequestMapping ("/member/create/popup.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("/infra/member/createMember");
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
	 * 멤버 신규등록 처리
	 *
	 * @param req
	 * @param res
	 * @param UIMemberVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIMemberVO member) throws Exception {
		ModelAndView mav = new ModelAndView();

		emptyValue(member, "regMemberSeq=1", "updMemberSeq=1");
		emptyValue(member, "regIp=" + HttpUtil.getRemoteAddr(req), "updIp=" + HttpUtil.getRemoteAddr(req));

		String passwordUpdDtime = DateUtil.getToday(Constants.FORMAT_DBDATETIME);
		String planPasswordUpdDtime = DateUtil.getFormatString(DateUtil.addDate(DateUtil.getFormatDate(passwordUpdDtime, Constants.FORMAT_DBDATETIME), 90),
				Constants.FORMAT_DBDATETIME);
		member.setPlanPasswordUpdDtime(planPasswordUpdDtime);

		memberService.insertMember(member, null, null);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 비번찾기화면으로 이동
	 *
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/member/find/password/popup.do")
	public ModelAndView goPassword(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("/infra/member/findPassword");
		return mav;
	}

	/**
	 * 비밀번호찾기 메일발송 Email 보내기
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws AofException
	 */
	@RequestMapping ("/member/find/password/sendmail.do")
	public ModelAndView findPsSendMail(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		boolean success = false;

		String email = HttpUtil.getParameter(req, "email", "");
		String message = HttpUtil.getParameter(req, "message", "");
		String link = HttpUtil.getParameter(req, "link", "");
		UIMemberVO member = (UIMemberVO)memberService.getDetailByEmail(email);

		if (member != null) {
			long now = (new Date()).getTime();
			String signature = StringUtil.encrypt(String.valueOf(now + Constants.SEPARATOR + member.getMemberId()), Constants.ENCODING_KEY);
			link += "&signature=" + signature;

			message = message.replaceAll("#LINK#", link);
			success = mailUtil.send(member.getEmail(), member.getMemberName(), Constants.SYSTEM_NAME, "Password", message, "html", null);

		} else {
			mav.addObject("found", false);
			success = false;
		}
		mav.addObject("success", success);
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 비밀번호찾기의 비밀번호 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws AofException
	 */
	@RequestMapping ("/member/reset/password/popup.do")
	public ModelAndView sendfindmail(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		String signature = HttpUtil.getParameter(req, "signature", "");
		signature = StringUtil.decrypt(signature, Constants.ENCODING_KEY);
		if (StringUtil.isNotEmpty(signature)) {
			String[] token = signature.split(Constants.SEPARATOR);
			if (token.length == 2) {
				long now = (new Date()).getTime();
				Long requestTime = Long.parseLong(token[0]);

				if (now - requestTime.longValue() < 60 * 5 * 1000) {
					mav.addObject("detail", memberService.getDetailByMemberId(token[1]));
				} else {
					mav.addObject("timeOver", "Y");
				}
			} else {
				mav.addObject("invalid", "Y");
			}
		} else {
			mav.addObject("invalid", "Y");
		}
		mav.setViewName("/infra/member/resetPassword");
		return mav;
	}

	/**
	 * 비밀번호찾기의 비밀번호 수정
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/member/password/update.do")
	public ModelAndView resetPassword(HttpServletRequest req, HttpServletResponse res, UIMemberVO member) throws Exception {
		ModelAndView mav = new ModelAndView();

		boolean success = false;

		String signature = HttpUtil.getParameter(req, "signature", "");
		signature = StringUtil.decrypt(signature.replaceAll(REPLACE_EQUAL, "="), Constants.ENCODING_KEY);

		if (StringUtil.isNotEmpty(signature)) {
			String[] token = signature.split(Constants.SEPARATOR);
			if (token.length == 2) {
				long now = (new Date()).getTime();
				Long requestTime = Long.parseLong(token[0]);

				if (now - requestTime.longValue() < 60 * 5 * 1000) {

					emptyValue(member, "updMemberSeq=" + member.getMemberSeq());
					emptyValue(member, "updIp=" + HttpUtil.getRemoteAddr(req));

					UIMemberRS detail = (UIMemberRS)memberService.getDetail(member);

					String passwordUpdDtime;
					if (detail.getMember().getPasswordUpdDtime() != null && !"".equals(detail.getMember().getPasswordUpdDtime())) {
						passwordUpdDtime = detail.getMember().getPasswordUpdDtime();
					} else {
						passwordUpdDtime = DateUtil.getToday(Constants.FORMAT_DBDATETIME);
					}
					String planPasswordUpdDtime = DateUtil.getFormatString(
							DateUtil.addDate(DateUtil.getFormatDate(passwordUpdDtime, Constants.FORMAT_DBDATETIME), 90), Constants.FORMAT_DBDATETIME);

					member.setPlanPasswordUpdDtime(planPasswordUpdDtime);
					member.setMemberId(detail.getMember().getMemberId());

					memberService.updatePassword(member);
					success = true;
				} else {
					mav.addObject("timeOver", "Y");
				}
			} else {
				mav.addObject("invalid", "Y");
			}
		} else {
			mav.addObject("invalid", "Y");
		}
		mav.addObject("success", success);
		mav.setViewName("jsonView");
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
	 * 멤버 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param member
	 * @param condition
	 * @return
	 * @throws AofException
	 */
	@RequestMapping ("/usr/member/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIMemberVO member) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req, member);

		member.setMemberSeq(member.getRegMemberSeq());
		ResultSet detail = memberService.getDetail(member);
		mav.addObject("detail", detail);

		String viewName = "/mypage/member/editMember";
		// 연동일이 없으면 외부학습자 페이지
		if (((UIMemberRS)detail).getMember().getMigMemberId() == null) {
			viewName = "/mypage/member/editMemberExternal";
		}

		mav.setViewName(viewName);
		return mav;
	}

	/**
	 * 멤버 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param member
	 * @return
	 * @throws AofException
	 */
	@RequestMapping ("/usr/member/update.do")
	public ModelAndView updatePwd(HttpServletRequest req, HttpServletResponse res, UIMemberVO member) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, member);

		if (req.getParameter("updateType") != null && "modify".equals(req.getParameter("updateType"))) {
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
		}

		memberService.updateMember(member, null, null);

		mav.setViewName("/common/save");
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
	@RequestMapping ("/usr/member/password/popup.do")
	public ModelAndView editPassword(HttpServletRequest req, HttpServletResponse res, UIMemberVO member) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("member", member);
		mav.setViewName("/mypage/member/editPasswordPopup");

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
	@RequestMapping ("/usr/member/password/update.do")
	public ModelAndView updatePassword(HttpServletRequest req, HttpServletResponse res, UIMemberVO member) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, member);

		member.setMemberSeq(member.getRegMemberSeq());
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

		memberService.updatePassword(member);

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
			UIMemberCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		String viewName = "/infra/member/listMemberMemoPopup";
		if ("/member/memo/list/popup.do".equals(req.getServletPath())) {
			mav.addObject("choice", "add");
			mav.addObject("srchType", "individual");
		} else {
			if (!"all".equals(memberType)) {
				condition.setSrchMemberType(memberType.toUpperCase());
				mav.addObject("memberType", memberType);
			}
			viewName = "/infra/member/listMemberPopup";
			mav.addObject("condition", condition);
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
}
