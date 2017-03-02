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

import com._4csoft.aof.infra.service.RmiCacheService;
import com._4csoft.aof.infra.service.SettingService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.ConfigUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.ui.infra.scheduler.SettingScheduler;
import com._4csoft.aof.ui.infra.vo.UISettingVO;
import com._4csoft.aof.ui.infra.vo.resultset.UISettingRS;

/**
 * @Project : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UISettingController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UISettingController extends BaseController {

	@Resource (name = "SettingService")
	private SettingService settingService;

	@Resource (name = "UISettingScheduler")
	private SettingScheduler settingScheduler;

	@Resource (name = "RmiCacheService")
	private RmiCacheService rmiCacheService;
	
	protected ConfigUtil config = ConfigUtil.getInstance();
	
	/**
	 * 설정 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/setting/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/infra/setting/listSetting");
		return mav;
	}

	/**
	 * 설정 수정화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/setting/edit/ajax.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// parameters
		String settingTypeCd = HttpUtil.getParameter(req, "settingTypeCd", "");

		UISettingVO setting = new UISettingVO();
		setting.setSettingTypeCd(settingTypeCd);
		
		UISettingRS settingDateil = (UISettingRS)settingService.getDetail(setting);
		
		if(settingDateil != null && config.getString(Constants.CONFIG_MIGRATION_CODE).equals(settingTypeCd)){
			if(settingDateil.getSetting() != null){
				String[] settingList = settingDateil.getSetting().getSettingValue().split("\n");
				StringBuffer migSetting = new StringBuffer();
				StringBuffer etcSetting = new StringBuffer();
				
				for(String settingJob : settingList){
					if(settingJob.contains(config.getString(Constants.CONFIG_MIGRATION_JOB))){
						migSetting.append(settingJob);
						migSetting.append("\n");
					}else{
						etcSetting.append(settingJob);
						etcSetting.append("\n");
					}
				}
				settingDateil.getSetting().setSettingValue(etcSetting.toString());
				
				mav.addObject("migJob", migSetting.toString());
			}
		}

		mav.addObject("settingTypeCd", settingTypeCd);
		mav.addObject("detail", settingDateil);

		mav.setViewName("/infra/setting/editSettingAjax");
		return mav;
	}

	/**
	 * 설정 신규등록/수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UISettingVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/setting/save.do")
	public ModelAndView save(HttpServletRequest req, HttpServletResponse res, UISettingVO setting) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, setting);

		settingService.saveSetting(setting);

		if (config.getString(Constants.CONFIG_MIGRATION_CODE).equals(setting.getSettingTypeCd())) {
			settingScheduler.run();
		}
		
		rmiCacheService.rmiRemoveCache("cacheSetting", setting.getSettingTypeCd()); // 원격 캐쉬 삭제
		
		mav.setViewName("/common/save");
		return mav;
	}

}
