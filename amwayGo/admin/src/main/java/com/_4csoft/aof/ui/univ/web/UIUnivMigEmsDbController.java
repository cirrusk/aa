/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.BatchService;
import com._4csoft.aof.infra.service.RmiCacheService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.ui.infra.scheduler.SettingScheduler;
import com._4csoft.aof.ui.infra.vo.UIBatchVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivMigEmsDbVO;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivMigEmsDbRS;
import com._4csoft.aof.univ.service.UnivMigEmsDbService;
import com._4csoft.aof.univ.service.UnivYearTermService;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivMigEmsDbController.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2014. 2. 18.
 * @author : 이한구
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivMigEmsDbController extends BaseController {

	@Resource (name = "UnivMigEmsDbService")
	private UnivMigEmsDbService univMigEmsDbService;

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;
	
	@Resource (name = "BatchService")
	private BatchService batchService;
	
	@Resource (name = "UISettingScheduler")
	private SettingScheduler settingScheduler;

	@Resource (name = "RmiCacheService")
	private RmiCacheService rmiCacheService;
	
	/**
	 * 학사시스템 동기화 정보 상세
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/migemsdb/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIUnivMigEmsDbVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UIUnivMigEmsDbRS detailUnivMigEmsDb = (UIUnivMigEmsDbRS)univMigEmsDbService.getDetail();

		mav.addObject("detail", detailUnivMigEmsDb);
		mav.addObject("yearTerms", univYearTermService.getListYearTermAll());

		mav.setViewName("/univ/migemsdb/detailMigEmsDb");

		return mav;
	}

	/**
	 * 학사시스템 동기화 정보 수정
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/migemsdb/udpate.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivMigEmsDbVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		vo.setStartDtime(DateUtil.convertStartDate(vo.getStartDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		vo.setEndDtime(DateUtil.convertEndDate(vo.getEndDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));

		univMigEmsDbService.updateMigEmsDb(vo);
		// 교강사 테이블에서 교수를 연동시 데이터 입력할 때 같이 넣어야 한다
		
		// 배치 데이터 변경
		UIBatchVO batch = new UIBatchVO();
		batch.setBatchId(config.getString(Constants.CONFIG_MIGRATION_JOB));
		batch.setEditYn("Y");
		
		if("Y".equals(vo.getDemonStatusYn())){
			batch.setBatchStatusCd("BATCH_STATUS::RUN");
		}else{
			batch.setBatchStatusCd("BATCH_STATUS::STOP");
		}
		
		// 마이그레이션 스케줄 설정 변경
		StringBuffer migSchedule = new StringBuffer();
		String codeValue = vo.getBatchScheduleCd().split("::")[1].toLowerCase();
		
		migSchedule.append(config.getString(Constants.CONFIG_MIGRATION_JOB));
		migSchedule.append("=");
		migSchedule.append(codeValue);
		migSchedule.append("=");
		
		if("cron".equals(codeValue)){
			migSchedule.append(vo.getBatchHour());
			migSchedule.append(" ");
			migSchedule.append(vo.getBatchMin());
			migSchedule.append(" ");
			migSchedule.append("* * * ?");
		}else{
			migSchedule.append(vo.getBatchMin());
		}

		batch.setBatchSchedule(migSchedule.toString());
		
		// 배치 상태 변경 수행
		batchService.updateByBatchId(batch);
		
		// 스케줄러 적용
		settingScheduler.run();
					
		// 원격 캐쉬 삭제
		rmiCacheService.rmiRemoveCache("cacheSetting", config.getString(Constants.CONFIG_MIGRATION_CODE));

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 즉시 연동
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@Async
	@RequestMapping ("/univ/migemsdb/synchronize.do")
	public ModelAndView synchronize(HttpServletRequest req, HttpServletResponse res, UIUnivMigEmsDbVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		vo.setStartDtime(DateUtil.convertStartDate(vo.getStartDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		vo.setEndDtime(DateUtil.convertEndDate(vo.getEndDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));

		univMigEmsDbService.updateMigEmsDb(vo);

		// 프로시져 호출
		univMigEmsDbService.saveCallSynchronize(vo);
		// 리턴 값이 필요할 때 사용
		mav.addObject("result", vo.getReturnValue());

		mav.setViewName("/common/save");
		return mav;
	}
}
