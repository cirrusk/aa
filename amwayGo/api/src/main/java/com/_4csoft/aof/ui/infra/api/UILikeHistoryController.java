/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.api;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.LikeHistoryService;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.ui.infra.UIApiConstant;
import com._4csoft.aof.ui.infra.vo.UILikeHistoryVO;

/**
 * @Project : aof5-univ-ui-api
 * @Package : com._4csoft.aof.ui.infra.api
 * @File : UILikeHistoryController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 23.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UILikeHistoryController extends UIBaseController {

	@Resource (name = "LikeHistoryService")
	private LikeHistoryService likeHistoryService;

	/**
	 * 신규 좋아요 등록
	 * 
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/api/like/history/insert")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		String resultCode = UIApiConstant._SUCCESS_CODE;
		UILikeHistoryVO like = new UILikeHistoryVO();
		checkSession(req);

		requiredSession(req, like);

		String reference = HttpUtil.getParameter(req, "reference").toUpperCase();

		final String referenceTablename = references.get(reference + ".TABLE.NAME");
		final String referenceKeyColumnName = references.get(reference + ".TABLE.SEQ");
		final String referenceSumColumnName = references.get(reference + ".TABLE.SUM");

		like.setReferenceSeq(Long.parseLong(req.getParameter("referenceSeq")));
		like.setReferenceTablename(referenceTablename);
		like.setReferenceSumColumnName(referenceSumColumnName);
		like.setReferenceKeyColumnName(referenceKeyColumnName);
		like.setMemberSeq(like.getRegMemberSeq());
		// 최종 중복 횟수 1
		like.setMaxInsertCount(1);
		likeHistoryService.insert(like);

		mav.addObject("resultCode", resultCode);
		mav.addObject("resultMessage", getErorrMessage(resultCode));
		mav.setViewName("jsonView");
		return mav;
	}
}
