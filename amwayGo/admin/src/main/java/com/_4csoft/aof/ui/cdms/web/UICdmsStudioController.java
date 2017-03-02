/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.cdms.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.cdms.service.CdmsStudioMemberService;
import com._4csoft.aof.cdms.service.CdmsStudioService;
import com._4csoft.aof.cdms.service.CdmsStudioTimeService;
import com._4csoft.aof.cdms.vo.CdmsStudioMemberVO;
import com._4csoft.aof.cdms.vo.CdmsStudioTimeVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioMemberVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioTimeVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioVO;
import com._4csoft.aof.ui.cdms.vo.condition.UICdmsStudioCondition;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Studio : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.cdms.web
 * @File : UICdmsStudioController.java
 * @Title : CDMS 스튜디오
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICdmsStudioController extends BaseController {

	@Resource (name = "CdmsStudioService")
	private CdmsStudioService studioService;

	@Resource (name = "CdmsStudioMemberService")
	private CdmsStudioMemberService studioMemberService;

	@Resource (name = "CdmsStudioTimeService")
	private CdmsStudioTimeService studioTimeService;

	/**
	 * 스튜디오 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UICdmsStudioCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("listStudio", studioService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/cdms/studio/listStudio");

		return mav;
	}

	/**
	 * 스튜디오 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UICdmsStudioVO studio, UICdmsStudioCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detailStudio", studioService.getDetail(studio));
		mav.addObject("listStudioTime", studioTimeService.getList(studio.getStudioSeq()));
		
		mav.addObject("condition", condition);

		mav.setViewName("/cdms/studio/detailStudio");
		return mav;
	}

	/**
	 * 스튜디오 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("listDefaultTime", studioTimeService.getList(-1L));

		mav.setViewName("/cdms/studio/createStudio");
		return mav;
	}

	/**
	 * 스튜디오 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UICdmsStudioVO studio, UICdmsStudioCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detailStudio", studioService.getDetail(studio));
		mav.addObject("listStudioTime", studioTimeService.getList(studio.getStudioSeq()));

		mav.addObject("condition", condition);
		
		mav.setViewName("/cdms/studio/editStudio");
		return mav;
	}

	/**
	 * 스튜디오 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param studio
	 * @param section
	 * @param output
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UICdmsStudioVO studio, UICdmsStudioMemberVO studioMember,
			UICdmsStudioTimeVO studioTime) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, studio);

		List<CdmsStudioMemberVO> studioMembers = new ArrayList<CdmsStudioMemberVO>();
		if (studioMember.getMemberSeqs() != null) {
			for (int index = 0; index < studioMember.getMemberSeqs().length; index++) {
				UICdmsStudioMemberVO o = new UICdmsStudioMemberVO();
				o.setMemberSeq(studioMember.getMemberSeqs()[index]);
				o.copyAudit(studio);

				studioMembers.add(o);
			}
		}
		List<CdmsStudioTimeVO> studioTimes = new ArrayList<CdmsStudioTimeVO>();
		if (studioTime.getSortOrders() != null) {
			for (int index = 0; index < studioTime.getSortOrders().length; index++) {
				UICdmsStudioTimeVO o = new UICdmsStudioTimeVO();
				o.setSortOrder(studioTime.getSortOrders()[index]);
				o.setStartTime(studioTime.getStartTimes()[index]);
				o.setEndTime(studioTime.getEndTimes()[index]);
				o.copyAudit(studio);

				studioTimes.add(o);
			}
		}

		int result = studioService.insertStudio(studio, studioMembers, studioTimes);

		mav.addObject("result", "{\"success\":\"" + result + "\", \"studioSeq\":\"" + studio.getStudioSeq() + "\"}");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 스튜디오 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UICdmsStudioVO studio, UICdmsStudioMemberVO studioMember) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, studio);

		List<CdmsStudioMemberVO> studioMembers = new ArrayList<CdmsStudioMemberVO>();
		if (studioMember.getMemberSeqs() != null) {
			for (int index = 0; index < studioMember.getMemberSeqs().length; index++) {
				UICdmsStudioMemberVO o = new UICdmsStudioMemberVO();
				if (studioMember.getMemberSeqs()[index].equals(studioMember.getOldMemberSeqs()[index]) == false) {
					o.setMemberSeq(studioMember.getMemberSeqs()[index]);
					o.copyAudit(studio);

					studioMembers.add(o);
				}
			}
		}

		List<CdmsStudioMemberVO> deleteMembers = new ArrayList<CdmsStudioMemberVO>();
		if (studioMember.getDeleteMemberSeqs() != null) {
			for (int index = 0; index < studioMember.getDeleteMemberSeqs().length; index++) {
				UICdmsStudioMemberVO o = new UICdmsStudioMemberVO();
				o.setMemberSeq(studioMember.getDeleteMemberSeqs()[index]);
				o.copyAudit(studio);

				deleteMembers.add(o);
			}
		}

		int result = studioService.updateStudio(studio, studioMembers, deleteMembers);

		mav.addObject("result", "{\"success\":\"" + result + "\", \"studioSeq\":\"" + studio.getStudioSeq() + "\"}");

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 스튜디오 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UICdmsStudioVO studio) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, studio);

		studioService.deleteStudio(studio);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 스튜디오 시간 수정
	 * 
	 * @param req
	 * @param res
	 * @param studioTime
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/time/update.do")
	public ModelAndView updateTime(HttpServletRequest req, HttpServletResponse res, UICdmsStudioTimeVO studioTime) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, studioTime);

		List<CdmsStudioTimeVO> studioTimes = new ArrayList<CdmsStudioTimeVO>();
		if (studioTime.getSortOrders() != null) {
			for (int index = 0; index < studioTime.getSortOrders().length; index++) {
				UICdmsStudioTimeVO o = new UICdmsStudioTimeVO();
				o.setStudioSeq(studioTime.getStudioSeq());
				o.setStudioTimeSeq(studioTime.getStudioTimeSeqs()[index]);
				o.setSortOrder(studioTime.getSortOrders()[index]);
				o.setStartTime(studioTime.getStartTimes()[index]);
				o.setEndTime(studioTime.getEndTimes()[index]);
				o.copyAudit(studioTime);

				studioTimes.add(o);
			}
		}

		List<CdmsStudioTimeVO> deleteTimes = new ArrayList<CdmsStudioTimeVO>();
		if (studioTime.getDeleteStudioTimeSeqs() != null) {
			for (int index = 0; index < studioTime.getDeleteStudioTimeSeqs().length; index++) {
				UICdmsStudioTimeVO o = new UICdmsStudioTimeVO();
				o.setStudioTimeSeq(studioTime.getDeleteStudioTimeSeqs()[index]);
				o.copyAudit(studioTime);

				deleteTimes.add(o);
			}
		}

		int result = studioTimeService.saveStudioTime(studioTimes, deleteTimes);

		mav.addObject("result", "{\"success\":\"" + result + "\", \"studioSeq\":\"" + studioTime.getStudioSeq() + "\"}");

		mav.setViewName("/common/save");
		return mav;
	}
}
