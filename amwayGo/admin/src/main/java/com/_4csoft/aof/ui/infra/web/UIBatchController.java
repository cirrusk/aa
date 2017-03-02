/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.BatchHistoryService;
import com._4csoft.aof.infra.service.BatchService;
import com._4csoft.aof.infra.service.RmiCacheService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.ui.infra.scheduler.SettingScheduler;
import com._4csoft.aof.ui.infra.vo.UIBatchVO;
import com._4csoft.aof.ui.infra.web.BaseController;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIBatchController.java
 * @Title : 배치 관리 컨트롤러
 * @date : 2014. 06. 09.
 * @author : 류정희
 * @descrption : 배치 관리 컨트롤러
 */
@Controller
public class UIBatchController extends BaseController {
	
	@Resource (name = "BatchService")
	private BatchService batchService;
	
	@Resource (name = "BatchHistoryService")
	private BatchHistoryService batchHistoryService;
	
	@Resource (name = "UISettingScheduler")
	private SettingScheduler settingScheduler;

	@Resource (name = "RmiCacheService")
	private RmiCacheService rmiCacheService;
	
	/**
	 * 배치 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/infra/batch/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIBatchVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		requiredSession(req);

		mav.addObject("batchList", batchService.getList(vo));

		mav.setViewName("/infra/batch/listBatch");
		
		return mav;
	}
	
	/**
	 * 배치 상세 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/infra/batch/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIBatchVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		requiredSession(req);

		mav.addObject("batchDetail", batchService.getDetail(vo));

		mav.setViewName("/infra/batch/detailBatch");
		
		return mav;
	}
	
	/**
	 * 배치 정보 수정
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/infra/batch/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIBatchVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		requiredSession(req, vo);

		batchService.update(vo);
		
		// 스케줄러 적용
		settingScheduler.run();

		// 원격 캐쉬 삭제
		rmiCacheService.rmiRemoveCache("cacheSetting", config.getString(Constants.CONFIG_MIGRATION_CODE));

		mav.setViewName("/common/save");
		
		return mav;
	}

}
