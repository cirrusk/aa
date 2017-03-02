/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.core.session.SessionInformation;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJacksonJsonView;

import com._4csoft.aof.board.service.BbsService;
import com._4csoft.aof.board.service.BoardService;
import com._4csoft.aof.infra.service.MemberService;
import com._4csoft.aof.infra.service.RolegroupMemberService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.security.SessionRegistry;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.RolegroupVO;
import com._4csoft.aof.ui.board.vo.condition.UIBbsCondition;
import com._4csoft.aof.ui.board.vo.resultset.UIBoardRS;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.resultset.UIMemberRS;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveBbsCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveLecturerCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveBbsService;
import com._4csoft.aof.univ.service.UnivCourseActiveLecturerService;
import com._4csoft.aof.univ.service.UnivYearTermService;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UICommonController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 2.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICommonController extends BaseController { 
	protected final Log log = LogFactory.getLog(getClass());

	@Resource (name = "sessionRegistry")
	private SessionRegistry sessionRegistry;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	@Resource (name = "RolegroupMemberService")
	RolegroupMemberService rolegroupMemberService;

	@Resource (name = "MemberService")
	private MemberService memberService;

	@Resource (name = "BbsService")
	private BbsService bbsService;

	@Resource (name = "BoardService")
	private BoardService boardService;

	@Resource (name = "UnivCourseActiveBbsService")
	private UnivCourseActiveBbsService univCourseActiveBbsService;

	@Resource (name = "UnivCourseActiveLecturerService")
	private UnivCourseActiveLecturerService univCourseActiveLecturerService;

	/**
	 * 로그인 후 로드되는 첫 페이지
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/common/greeting.do")
	public ModelAndView greeting(HttpServletRequest req, HttpServletResponse res, UIBbsCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String boardType = "";
		String viewName = "";
		UIBoardRS detailBoard = null;

		// 나의정보
		UIMemberVO member = new UIMemberVO();
		member.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		UIMemberRS rs = (UIMemberRS)memberService.getDetail(member);
		mav.addObject("detail", rs);

		// 달력
		mav.addObject("srchYearMonth", DateUtil.getToday("yyyyMM"));
		mav.addObject("referenceType", "personal");

		if ("ADM".equals(SessionUtil.getMember(req).getCurrentRoleCfString())) {
			// 사이트 Q&A
			boardType = "qna";
			detailBoard = (UIBoardRS)boardService.getDetailByReference("system", -1L, "BOARD_TYPE::" + boardType.toUpperCase());
			if (detailBoard != null) {
				condition.setSrchBoardSeq(detailBoard.getBoard().getBoardSeq());
				mav.addObject("qna", bbsService.getMyPageList(condition));
			}
			// 사이트공지사항
			boardType = "notice";
			detailBoard = (UIBoardRS)boardService.getDetailByReference("system", -1L, "BOARD_TYPE::" + boardType.toUpperCase());
			if (detailBoard != null) {
				condition.setSrchBoardSeq(detailBoard.getBoard().getBoardSeq());
				mav.addObject("notice", bbsService.getMyPageList(condition));
			}
			viewName = "/infra/common/greeting";
		} else {
			// 나의할일
			UIUnivCourseActiveLecturerCondition lecturerCondition = new UIUnivCourseActiveLecturerCondition();
			lecturerCondition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());
			lecturerCondition.setSrchRoleGroupSeq(SessionUtil.getMember(req).getCurrentRolegroupSeq());
			mav.addObject("mywork", univCourseActiveLecturerService.getListCourseActiveMyWork(lecturerCondition));

			// 과목QNA
			UIUnivCourseActiveBbsCondition bbsCondition = new UIUnivCourseActiveBbsCondition();
			bbsCondition.setSrchMemberSeq(SessionUtil.getMember(req).getMemberSeq());

			bbsCondition.setSrchBoardTypeCd("BOARD_TYPE::QNA");
			mav.addObject("qna", univCourseActiveBbsService.getMyPageList(bbsCondition));

			// 과목공지사항
			bbsCondition.setSrchBoardTypeCd("BOARD_TYPE::NOTICE");
			mav.addObject("notice", univCourseActiveBbsService.getMyPageList(bbsCondition));

			viewName = "/infra/common/greetingProf";
		}

		// 교직원게시판
		boardType = "staff";
		detailBoard = (UIBoardRS)boardService.getDetailByReference("system", -1L, "BOARD_TYPE::" + boardType.toUpperCase());
		if (detailBoard != null) {

			condition.setSrchBoardSeq(detailBoard.getBoard().getBoardSeq());
			// 교직원게시판일 경우 대상자가 현재 롤그룹과 일치하는 것만 검색한다.
			condition.setSrchTargetRolegroup("BBS_TARGET_ROLEGROUP::" + SessionUtil.getMember(req).getCurrentRoleCfString());
			mav.addObject("staff", bbsService.getMyPageList(condition));
		}

		// 비밀번호 변경날짜 확인
		String header = req.getHeader("referer");

		if (StringUtil.isEmpty(header) || header.indexOf("jsp") > -1) {
			String passwordUpdDtime = rs.getMember().getPasswordUpdDtime();
			String planPasswordUpdDtime = rs.getMember().getPlanPasswordUpdDtime();

			if (StringUtil.isNotEmpty(planPasswordUpdDtime)) {
				passwordUpdDtime = planPasswordUpdDtime;
			} else {
				if (StringUtil.isEmpty(passwordUpdDtime)) {
					passwordUpdDtime = rs.getMember().getRegDtime();
				}
			}

			if (DateUtil.getToday().after(DateUtil.getFormatDate(passwordUpdDtime, Constants.FORMAT_DBDATETIME))) {
				member.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
				mav.addObject("member", member);
				mav.addObject("updateType", "modify");
				viewName = "/infra/member/editPassword";
			}
		}

		mav.setViewName(viewName);

		return mav;
	}

	/**
	 * 현재 롤그룹 바꾸기
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView (json)
	 * @throws Exception
	 */
	@RequestMapping ("/common/access/change.do")
	public ModelAndView changeAccess(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		Long jRolegroup = HttpUtil.getParameter(req, Constants.J_ROLEGROUP, 0L);
		String roleCfString = HttpUtil.getParameter(req, Constants.J_ROLECFSTRING);
		if (StringUtil.isNotEmpty(jRolegroup)) {
			UIMemberVO ssMember = (UIMemberVO)SessionUtil.getMember(req);

			ssMember.setCurrentRolegroupSeq(jRolegroup);
			ssMember.setCurrentRoleCfString(roleCfString);

			// 롤그룹의 권한에 따라 시스템에 설정된 년도학기를 셋팅한다.
			/** TODO : 코드 */
			ssMember.getExtendData().put("systemYearTerm", univYearTermService.getSystemYearTerm(roleCfString));

			SessionUtil.updateSessionMember(req, sessionRegistry);

			mav.addObject("change", true);
		} else {
			mav.addObject("change", false);
		}

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * sso를 수행하기 위한 signature를 요청한다
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView (json)
	 * @throws Exception
	 */
	@RequestMapping ("/common/access/signature.do")
	public ModelAndView signatureAccess(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		long now = (new Date()).getTime();
		String signature = "";
		String password = "";
		String extendData = HttpUtil.getParameter(req, "j_extendData", "");
		String memberId = HttpUtil.getParameter(req, "memberId", "");
		try {
			signature = StringUtil.encrypt(String.valueOf(now), Constants.ENCODING_KEY);
			password = StringUtil.encrypt(Constants.ENCODING_KEY + "@" + now, Constants.ENCODING_KEY);
			extendData = StringUtil.encrypt(extendData, Constants.ENCODING_KEY);
		} catch (Exception e) {
			signature = "";
		}
		boolean admin = false;
		for (RolegroupVO roleGroup : ((UIMemberVO)SessionUtil.getMember(req)).getRoleGroups()) {
			if ("ROLE::ADM".equals(roleGroup.getRoleCd())) {
				admin = true;
			}
		}
		if (admin == true) {
			mav.addObject("signature", memberId + Constants.SEPARATOR + signature + Constants.SEPARATOR + password + Constants.SEPARATOR + extendData);
			mav.addObject("password", password);
		}
		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 현재 접속자 목록 페이지
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/common/active/member/list.do")
	public ModelAndView listActiveMember(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/infra/common/listActiveMember");
		return mav;
	}

	/**
	 * 현재 접속자 목록 데이타
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView (json)
	 * @throws Exception
	 */
	@RequestMapping ("/common/active/member.do")
	public ModelAndView activeMember(HttpServletRequest req, HttpServletResponse res) throws Exception {
		String callback = HttpUtil.getParameter(req, "callback");
		List<Object> activeMember = new ArrayList<Object>();

		for (Object principal : sessionRegistry.getAllPrincipals()) {
			for (SessionInformation session : sessionRegistry.getAllSessions(principal, false)) {
				if (session.isExpired() == false && activeMember.contains(principal) == false) {
					activeMember.add(principal);
				}
			}
		}
		if (StringUtil.isEmpty(callback)) {
			ModelAndView mav = new ModelAndView();
			if (activeMember != null) {
				mav.addObject("activeMember", activeMember);
			}
			mav.setViewName("jsonView");
			return mav;
		} else {
			MappingJacksonJsonView jsonView = new MappingJacksonJsonView();
			Map<String, Object> model = new HashMap<String, Object>();
			try {
				res.setContentType("application/javascript");
				res.getOutputStream().write(new String(callback + "(").getBytes());
				if (activeMember != null) {
					model.put("activeMember", activeMember);
					jsonView.render(model, req, res);
				}
				res.getOutputStream().write(String.valueOf(");").getBytes());
			} catch (Exception e) {
			}
			return null;
		}

	}

	/**
	 * 현재 시스템 사용현황 페이지
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/common/system/status/list.do")
	public ModelAndView listSystemStatus(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/infra/common/listSystemStatus");
		return mav;
	}

	/**
	 * 로그 분석 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/common/log/list.do")
	public ModelAndView listLog(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/infra/common/listLog");
		return mav;
	}

	/**
	 * sso를 수행하기 위한 signature를 요청한다
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView (json)
	 * @throws Exception
	 */
	@RequestMapping ("/common/access/ssologin.do")
	public ModelAndView ssoLogin(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		// aof5 받는쪽
		String getData = HttpUtil.getParameter(req, "sendData");
		String decodeData = StringUtil.decrypt(getData, Constants.ENCODING_KEY);

		if (decodeData.indexOf(Constants.SEPARATOR) > -1) {
			String[] token = decodeData.split(Constants.SEPARATOR);

			// roleGroup 세팅 : 여러 롤그룹권한중에 처음권한으로 세팅
			List<RolegroupVO> list = rolegroupMemberService.getListByMemberId(StringUtil.decrypt(token[0], Constants.ENCODING_KEY));
			if (list != null) {
				mav.addObject("rolegroup", list.get(0).getRolegroupSeq());
				mav.addObject("roleCfString", list.get(0).getCfString());
			}

			mav.addObject("memberid", StringUtil.decrypt(token[0], Constants.ENCODING_KEY));
			mav.addObject("signature", StringUtil.decrypt(token[0], Constants.ENCODING_KEY) + Constants.SEPARATOR + token[1] + Constants.SEPARATOR + token[2]
					+ Constants.SEPARATOR + token[3]);
			mav.addObject("password", token[2]);
		}

		mav.setViewName("/common/ssoLogin");
		return mav;
	}

}
