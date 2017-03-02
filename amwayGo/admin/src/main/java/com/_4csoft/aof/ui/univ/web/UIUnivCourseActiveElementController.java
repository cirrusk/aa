/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Codes;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.lcms.service.LcmsContentsOrganizationService;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.lcms.vo.UILcmsContentsOrganizationVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveEvaluateVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveOrganizationItemVO;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseActiveEvaluateService;
import com._4csoft.aof.univ.vo.UnivCourseActiveElementVO;
import com._4csoft.aof.univ.vo.UnivCourseActiveOrganizationItemVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseActiveElementController.java
 * @Title : 교과목 구성정보
 * @date : 2014. 2. 27.
 * @author : 장용기
 * @descrption :
 * 
 */

@Controller
public class UIUnivCourseActiveElementController extends BaseController {
	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService elementService;

	@Resource (name = "LcmsContentsOrganizationService")
	private LcmsContentsOrganizationService organizationService;

	@Resource (name = "UnivCourseActiveEvaluateService")
	private UnivCourseActiveEvaluateService univCourseActiveEvaluateService;

	private Codes codes = Codes.getInstance();

	/**
	 * 주차 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseActiveElementVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/univ/course/active/oraganization/list.do", "/univ/course/active/oraganization/mapping/list.do" })
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveElementVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();
		final String CD_COURSE_ELEMENT_TYPE_ORGANIZATION = codes.get("CD.COURSE_ELEMENT_TYPE.ORGANIZATION");

		requiredSession(req);
		vo.copyShortcut();

		vo.setReferenceTypeCd(CD_COURSE_ELEMENT_TYPE_ORGANIZATION);
		if ("/univ/course/active/oraganization/list.do".equals(req.getServletPath())) {
			mav.addObject("list", elementService.getList(vo));

		} else {
			UILcmsContentsOrganizationVO org = new UILcmsContentsOrganizationVO();
			org.setContentsSeq(vo.getContentsSeq());

			if (elementService.countList(vo) > organizationService.getListBrowseContents(org).size()) {
				mav.addObject("list", elementService.getGroupElementMappingList(vo));
			} else {
				mav.addObject("list", elementService.getGroupMappingList(vo));
			}
		}

		// 평가기준
		UIUnivCourseActiveEvaluateVO courseActiveEvaluate = new UIUnivCourseActiveEvaluateVO();
		courseActiveEvaluate.setCourseActiveSeq(vo.getCourseActiveSeq());
		mav.addObject("listActiveEvaluate", univCourseActiveEvaluateService.getList(courseActiveEvaluate));

		mav.setViewName("/univ/courseActiveElement/courseActiveElement/editCourseActiveOraganization");

		return mav;
	}

	/**
	 * 주차 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseActiveElementVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/element/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveElementVO vo, UIUnivCourseActiveOrganizationItemVO itemVO)
			throws Exception {
		ModelAndView mav = new ModelAndView();
		final String CD_COURSE_TYPE_ALWAYS = codes.get("CD.COURSE_TYPE.ALWAYS");

		requiredSession(req, vo, itemVO);

		List<UnivCourseActiveElementVO> courseActiveElements = new ArrayList<UnivCourseActiveElementVO>();
		for (int i = 0; i < vo.getCourseActiveSeqs().length; i++) {
			UIUnivCourseActiveElementVO o = new UIUnivCourseActiveElementVO();
			o.setActiveElementSeq(vo.getActiveElementSeqs()[i]);
			o.setCourseActiveSeq(vo.getCourseActiveSeqs()[i]);
			o.setReferenceSeq(vo.getReferenceSeqs()[i]);
			o.setOldReferenceSeq(vo.getOldReferenceSeqs()[i]);
			o.setReferenceTypeCd(vo.getReferenceTypeCds()[i]);
			o.setActiveElementTitle(vo.getActiveElementTitles()[i]);
			if (CD_COURSE_TYPE_ALWAYS.equals(HttpUtil.getParameter(req, "shortcutCourseTypeCd"))) {
				if (vo.getStartDays()[i] != null) {
					o.setStartDay(vo.getStartDays()[i]);
				}
				if (vo.getEndDays()[i] != null) {
					o.setEndDay(vo.getEndDays()[i]);
				}
			} else {
				// if (!"".equals(vo.getStartDtimes()[i]) && vo.getStartDtimes()[i] != null) {
				// o.setStartDtime(DateUtil.convertStartDate(vo.getStartDtimes()[i], Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
				// Constants.FORMAT_TIMEZONE));
				// }
				// if (!"".equals(vo.getEndDtimes()[i]) && vo.getEndDtimes()[i] != null) {
				// o.setEndDtime(DateUtil.convertStartDate(vo.getEndDtimes()[i], Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
				// Constants.FORMAT_TIMEZONE));
				// }
			}
			o.setSortOrder(vo.getSortOrders()[i]);
			o.setCourseWeekTypeCd(vo.getCourseWeekTypeCds()[i]);
			if (vo.getLectureNames() != null) {
				o.setLectureName(vo.getLectureNames()[i]);
			}

			o.copyAudit(vo);
			courseActiveElements.add(o);
		}

		List<UnivCourseActiveOrganizationItemVO> courseActiveOrganizaionItems = new ArrayList<UnivCourseActiveOrganizationItemVO>();
		if (itemVO.getOrganizationItemSeqs() != null) {
			for (int i = 0; i < itemVO.getOrganizationItemSeqs().length; i++) {
				UIUnivCourseActiveOrganizationItemVO o = new UIUnivCourseActiveOrganizationItemVO();
				// 첨부파일 정보 저장 하기 위한 변환 및 값 세팅
				String info = null;
				String attachUploadInfo = null;
				String attachDeleteInfo = null;
				if (StringUtil.isNotEmpty(itemVO.getAttachUploadInfos()[i])) {
					info = itemVO.getAttachUploadInfos()[i];
					attachUploadInfo = info.replace("|", String.valueOf((char)0x01));
				}
				if (StringUtil.isNotEmpty(itemVO.getAttachDeleteInfos()[i])) {
					attachDeleteInfo = itemVO.getAttachDeleteInfos()[i];
				}

				o.setOrganizationItemSeq(itemVO.getOrganizationItemSeqs()[i]);
				o.setCourseActiveSeq(itemVO.getActiveSeqs()[i]);
				o.setCourseActiveElementSeq(itemVO.getElementSeqs()[i]);
				o.setOrganizationSeq(itemVO.getOrganizationSeqs()[i]);
				o.setItemSeq(itemVO.getItemSeqs()[i]);
				o.copyAudit(itemVO);
				o.setAttachUploadInfo(attachUploadInfo);
				o.setAttachDeleteInfo(attachDeleteInfo);

				courseActiveOrganizaionItems.add(o);
			}
		}
		elementService.savelistCourseActiveElement(courseActiveElements, courseActiveOrganizaionItems);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 주차 멀티 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivCourseActiveElementVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/element/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveElementVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		List<UnivCourseActiveElementVO> list = new ArrayList<UnivCourseActiveElementVO>();
		for (String index : vo.getCheckkeys()) {
			UIUnivCourseActiveElementVO o = new UIUnivCourseActiveElementVO();
			o.setActiveElementSeq(vo.getActiveElementSeqs()[Integer.parseInt(index)]);
			o.setReferenceSeq(vo.getReferenceSeqs()[Integer.parseInt(index)]);
			o.setReferenceTypeCd(vo.getReferenceTypeCds()[Integer.parseInt(index)]);
			o.setCourseWeekTypeCd(vo.getCourseWeekTypeCds()[Integer.parseInt(index)]);
			o.copyAudit(vo);

			list.add(o);
		}

		if (list.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", elementService.deletelistCourseActiveElement(list));
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView (json)
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/element/browse/contents/list.do")
	public ModelAndView listBrowseContents(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UILcmsContentsOrganizationVO vo = new UILcmsContentsOrganizationVO();
		vo.setContentsSeq(HttpUtil.getParameter(req, "contentsSeq", 0L));

		mav.addObject("list", organizationService.getListBrowseContents(vo));
		mav.setViewName("jsonView");
		return mav;
	}

}
