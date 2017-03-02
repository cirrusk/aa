/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.api;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.MemberService;
import com._4csoft.aof.infra.service.RolegroupMemberService;
import com._4csoft.aof.ui.infra.service.UIAgreementService;
import com._4csoft.aof.ui.infra.service.UIMemberService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.security.PasswordEncoder;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.RolegroupVO;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.support.util.StaticEncEngine;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.dto.MemberDTO;
import com._4csoft.aof.ui.infra.dto.RolegroupDTO;
import com._4csoft.aof.ui.infra.exception.ApiServiceExcepion;
import com._4csoft.aof.ui.infra.vo.UICodeVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.infra.vo.condition.UIAgreementCondition;
import com._4csoft.aof.ui.infra.vo.resultset.UIMemberRS;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.infra.api
 * @File : UIMemberController.java
 * @Title : 회원관리
 * @date : 2015. 3. 18.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIMemberController extends UIBaseController {
	@Resource (name = "MemberService")
	private MemberService memberService;

	@Resource (name = "UIPasswordEncoder")
	protected PasswordEncoder passwordEncoder;

	@Resource (name = "RolegroupMemberService")
	protected RolegroupMemberService rolegroupMemberService;
	
	@Resource (name = "UIAgreementService")
	protected UIAgreementService agreementService;
	
	@Resource (name = "UIMemberService")
	protected UIMemberService UImemberservice;

	/**
	 * 회원 상세 정보
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/member/all/detail")
	public ModelAndView detailMember(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;

		checkSession(req);

		UIMemberVO member = new UIMemberVO();

		member.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());

		MemberDTO item = new MemberDTO();
		List<RolegroupDTO> roles = new ArrayList<RolegroupDTO>();
		/** 회원 검색 */
		if (StringUtil.isNotEmpty(req.getParameter("memberSeq"))) {
			member.setMemberSeq(Long.parseLong(req.getParameter("memberSeq")));
		}

		ResultSet detail = memberService.getDetail(member);

		String accessToken = HttpUtil.getParameter(req, "accessToken");
		//String enckey = accessToken.substring(0, 31);
		String enckey = "aaaaaaaaaaaaaaaaaaaaaa";

		StaticEncEngine instance = StaticEncEngine.getInstance(enckey);

		// String imgPath =
		String imgURL = config.getString("domain.www") + config.getString("upload.context.image");
		if (detail != null) {

			UIMemberRS rs = (UIMemberRS)detail;
			BeanUtils.copyProperties(item, rs.getMember());
			item.setMemberStatus(getCodeName(rs.getMember().getMemberStatusCd()));
			item.setSex(getCodeName(rs.getMember().getSexCd()));
			rs.getMember().getCompanyName();

			if (!StringUtil.isEmpty(item.getPhoto())) {
				item.setPhoto(imgURL + item.getPhoto());
			}
			if (!StringUtil.isEmpty(item.getMemberName())) {
				// 암호화 연동의 이슈로 임시로 암호화를 해제
				// 추후 이슈해결할 경우 재 암호화 해야한다.
				// jcseo
				// item.setMemberName(instance.setEnc(item.getMemberName()));
				item.setMemberName(item.getMemberName());
			}

			if (!StringUtil.isEmpty(item.getNickname())) {
				//item.setNickname(instance.setEnc(item.getNickname()));
				item.setNickname(item.getNickname());

			}
			if (!StringUtil.isEmpty(item.getEmail())) {
				item.setEmail(instance.setEnc(item.getEmail()));
			}

			if (!StringUtil.isEmpty(item.getPhoneMobile())) {
				// 암호화 연동의 이슈로 임시로 암호화를 해제
				// 추후 이슈해결할 경우 재 암호화 해야한다.
				// jcseo
				// item.setPhoneMobile(instance.setEnc(item.getPhoneMobile()));
				item.setPhoneMobile(item.getPhoneMobile());

			}
			if (rs.getCategory() != null) {
				item.setCategoryString(rs.getCategory().getCategoryString());
			}
			if (!StringUtil.isEmpty(item.getCategoryString())) {
				int beginIndex = rs.getCategory().getCategoryString().lastIndexOf("::");
				item.setCategoryName(rs.getCategory().getCategoryString().substring(beginIndex).replace("::", ""));
			}
			if (rs.getAdmin() != null) {
				item.setJobTypeCd(rs.getAdmin().getJobTypeCd());
				item.setJobType(getCodeName(item.getJobTypeCd()));
				item.setCdmsTaskTypeCd(rs.getAdmin().getCdmsTaskTypeCd());
				item.setCdmsTaskType(getCodeName(item.getCdmsTaskTypeCd()));
				item.setProfTypeCd(rs.getAdmin().getProfTypeCd());
				item.setProfType(getCodeName(rs.getAdmin().getProfTypeCd()));
			}
			item.setStudentStatusCd(rs.getMember().getStudentStatusCd());
			item.setStudentStatus(getCodeName(rs.getMember().getStudentStatusCd()));
			if (StringUtil.isNotEmpty(item.getPosition())) {
				item.setPositionName(getCodeName(item.getPosition()));
			}
			List<RolegroupVO> roleList = rolegroupMemberService.getListByMemberId(item.getMemberId());
			for (RolegroupVO roleVO : roleList) {
				RolegroupDTO dto = new RolegroupDTO();
				BeanUtils.copyProperties(dto, roleVO);
				roles.add(dto);
			}

		}

		mav.addObject("item", item);
		mav.addObject("roles", roles);
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));

		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 멤버 비밀번호 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/member/password/update")
	public ModelAndView updatePassword(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;

		checkSession(req);

		String j_password = HttpUtil.getParameter(req, "j_password");
		// String enckey = j_password.substring(0, 31);
		//
		// j_password = j_password.substring(31, j_password.length());
		//
		// StaticEncEngine instance = StaticEncEngine.getInstance(enckey);

		if (StringUtil.isEmpty(j_password)) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
		}

		UIMemberVO member = new UIMemberVO();

		try {
			// password 체크
			// member.setPassword(instance.getEnc(j_password));
			member.setPassword(j_password);
		} catch (Exception e) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
		}

		if (StringUtil.isEmpty(member.getPassword())) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
		}
		member.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
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

		memberService.updatePassword(member);

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));

		mav.setViewName("jsonView");
		return mav;
	}
	
	/**
	 * 회원 닉네임 변경
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/member/nickname/update")
	public ModelAndView updateNickname(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;

		checkSession(req);
		String banWord[] = {"운영자","운영","운영본부","관리자","담당자","직원","admin",
				"administrator","어드민","암웨이","Amway","한국암웨이","AKL","AmwayKorea","교육부",
				"교육담당자","Training","Trainer","영업부","Sales","코디네이터","SalesCoordinator","Coordinator",
				"마케팅","Marketing","MKT","뉴트리라이트","Nutrilite","아티스트리","Artistry","암웨이홈","AmwayHome"};

		String j_nickname = HttpUtil.getParameter(req, "j_nickname");

		
		if (StringUtil.isEmpty(j_nickname)) {
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}else{
			char chrInput;
			int check = 0;
			byte[] bytes = j_nickname.getBytes("ms949");
			
			//설정된 금칙어가 있는지 확인
			for(int i=0; i < banWord.length; i++){
				if(banWord[i].equals(j_nickname)){
					System.out.println("금칙어입니다. " + banWord[i] + " / " + j_nickname);
					resultCode = UIApiConstant._INVALID_DATA_CODE;
					throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
				}
			}
			
			//길이가 16바이트 초과인지 확인
			if(bytes.length > 16){
				resultCode = UIApiConstant._INVALID_DATA_CODE;
				throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
			}
			
			//숫자로만 설정하였는지 확인
			for (int i = 0; i < j_nickname.length(); i++) {
				chrInput = j_nickname.charAt(i); // 입력받은 텍스트에서 문자 하나하나 가져와서 체크
				if(chrInput < '0' || chrInput > '9') {
					check = check + 1;
	            }
			}
			if(check <= 0){
				resultCode = UIApiConstant._INVALID_DATA_CODE;
				throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
			}
			
		}

		UIMemberVO member = new UIMemberVO();
		try {
			member.setNickname(j_nickname);
		} catch (Exception e) {
			resultCode = UIApiConstant._INVALID_DATA_REQUIRED;
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_REQUIRED, getErorrMessage(UIApiConstant._INVALID_DATA_REQUIRED));
		}
		
		member.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		member.setMemberName(SessionUtil.getMember(req).getMemberName());
		requiredSession(req, member);
		
		//본인이름으로 설정하였는지 확인
		int CntNameNick = UImemberservice.countNameCheckNickname(member);
		if(CntNameNick > 0){
			resultCode = UIApiConstant._INVALID_DATA_CODE;
			throw new ApiServiceExcepion(UIApiConstant._INVALID_DATA_CODE, getErorrMessage(UIApiConstant._INVALID_DATA_CODE));
		}
		
		//닉네임 중복인지 확인
		int CntNick = UImemberservice.countNickname(member);
		if(CntNick == 0){
			UImemberservice.updateNickname(member);
		}else{
			resultCode = UIApiConstant._SYSTEM_ERROR;
			throw new ApiServiceExcepion(UIApiConstant._SYSTEM_ERROR, getErorrMessage(UIApiConstant._SYSTEM_ERROR));
		}
		
		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));

		mav.setViewName("jsonView");
		return mav;
	}

	/**
	 * 변경할 암호 암호화
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/member/password/enc")
	public ModelAndView passwordEnc(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;

		checkSession(req);

		String accessToken = HttpUtil.getParameter(req, "accessToken");
		String enckey = accessToken.substring(0, 31);

		StaticEncEngine instance = StaticEncEngine.getInstance(enckey);

		String j_password = HttpUtil.getParameter(req, "j_password");

		mav.addObject("j_password", enckey + instance.setEnc(j_password));

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));

		mav.setViewName("jsonView");
		return mav;
	}
	
	
	/**
	 * 개인정보 동의
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/member/agreement")
	public ModelAndView updateAgreement(HttpServletRequest req, HttpServletResponse res) throws Exception {
		final String CD_ERROR_TYPE_3000 = codes.get("CD.ERROR_TYPE.3000");
		ModelAndView mav = new ModelAndView();
		String resultCode = UIApiConstant._SUCCESS_CODE;
		UIAgreementCondition condition = new UIAgreementCondition();
		UICodeVO vo = new UICodeVO();
		
		checkSession(req);
		
		String agreeSeq1 = req.getParameter("srchAgreeSeq1");
		String agreeSeq2 = req.getParameter("srchAgreeSeq2");
		String agreeSeq3 = req.getParameter("srchAgreeSeq3");
		String applyCheck1 = req.getParameter("applyCheck1");
		String applyCheck2 = req.getParameter("applyCheck2");
		String applyCheck3 = req.getParameter("applyCheck3");
		
		try {
			condition.setSrchCourseActiveSeq(Long.valueOf(req.getParameter("courseActiveSeq")));
			if(!"null".equals(agreeSeq1)){
				condition.setSrchAgreeSeq1(agreeSeq1);
				condition.setSrchApplyCheck1(applyCheck1);
			}
			if(!"null".equals(agreeSeq2)){
				condition.setSrchAgreeSeq2(agreeSeq2);
				condition.setSrchApplyCheck2(applyCheck2);
			}
			if(!"null".equals(agreeSeq3)){
				condition.setSrchAgreeSeq3(agreeSeq3);
				condition.setSrchApplyCheck3(applyCheck3);
			}
			condition.setAgreementMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		} catch (Exception e) {
			vo = getCode(CD_ERROR_TYPE_3000);
			resultCode = vo.getCode();
		}
		
		UIMemberVO member = new UIMemberVO();

		requiredSession(req, member);

		member.setMemberSeq(SessionUtil.getMember(req).getMemberSeq());
		member.setAgreementYn("Y");

		agreementService.insertAgreeApply(condition);

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));

		mav.setViewName("jsonView");
		return mav;
	}

}
