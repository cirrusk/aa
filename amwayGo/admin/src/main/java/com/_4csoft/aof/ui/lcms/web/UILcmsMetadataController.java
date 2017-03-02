/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.lcms.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.lcms.service.LcmsMetadataService;
import com._4csoft.aof.lcms.vo.LcmsMetadataVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.lcms.vo.UILcmsMetadataVO;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.lcms.web
 * @File : UILcmsMetadataController.java
 * @Title : 메타데이터
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UILcmsMetadataController extends BaseController {

	@Resource (name = "LcmsMetadataService")
	private LcmsMetadataService metadataService;

	/**
	 * 메타데이타 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/metadata/{referenceType}/edit/popup.do")
	public ModelAndView listAjax(HttpServletRequest req, HttpServletResponse res, @PathVariable ("referenceType") String referenceType) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		Long referenceSeq = HttpUtil.getParameter(req, "referenceSeq", 0L);
		mav.addObject("listMetadata", metadataService.getListByReference(referenceType, referenceSeq));

		mav.addObject("referenceSeq", referenceSeq);
		mav.addObject("referenceType", referenceType);
		mav.setViewName("/lcms/metadata/editMetadataPopup");

		return mav;
	}

	/**
	 * 메타데이타 다중 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/lcms/metadata/updatelist.do")
	public ModelAndView updatelist(HttpServletRequest req, HttpServletResponse res, UILcmsMetadataVO metadata) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, metadata);

		List<LcmsMetadataVO> voList = new ArrayList<LcmsMetadataVO>();
		for (int i = 0; i < metadata.getMetadataElementSeqs().length; i++) {
			UILcmsMetadataVO o = new UILcmsMetadataVO();

			o.setMetadataElementSeq(metadata.getMetadataElementSeqs()[i]);
			o.setMetadataSeq(metadata.getMetadataSeqs()[i]);
			o.setMetadataValue(metadata.getMetadataValues()[i]);
			o.setReferenceSeq(metadata.getReferenceSeq());
			o.setReferenceType(metadata.getReferenceType());

			o.copyAudit(metadata);

			voList.add(o);
		}

		if (voList.size() > 0) {
			mav.addObject("result", metadataService.savelistMetadata(voList));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}

}
