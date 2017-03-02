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
import com._4csoft.aof.cdms.service.CdmsStudioWorkService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.Errors;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.Paginate;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioVO;
import com._4csoft.aof.ui.cdms.vo.UICdmsStudioWorkVO;
import com._4csoft.aof.ui.cdms.vo.condition.UICdmsStudioCondition;
import com._4csoft.aof.ui.cdms.vo.condition.UICdmsStudioWorkCondition;
import com._4csoft.aof.ui.cdms.vo.resultset.UICdmsStudioWorkRS;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.vo.UIMessageReceiveVO;
import com._4csoft.aof.ui.infra.vo.UIMessageSendVO;
import com._4csoft.aof.ui.infra.web.BaseController;

import egovframework.rte.fdl.cmmn.exception.EgovBizException;

/**
 * @Studio : aof5-demo-admin
 * @Package : com._4csoft.aof.ui.cdms.web
 * @File : UICdmsStudioWorkController.java
 * @Title : CDMS 스튜디오 작업
 * @date : 2013. 9. 5.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UICdmsStudioWorkController extends BaseController {

	@Resource (name = "CdmsStudioWorkService")
	private CdmsStudioWorkService studioWorkService;

	@Resource (name = "CdmsStudioService")
	private CdmsStudioService studioService;

	@Resource (name = "CdmsStudioMemberService")
	private CdmsStudioMemberService studioMemberService;

	@Resource (name = "CdmsStudioTimeService")
	private CdmsStudioTimeService studioTimeService;

	/**
	 * 스튜디오 작업 메인 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/work/main.do")
	public ModelAndView main(HttpServletRequest req, HttpServletResponse res, UICdmsStudioCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("listStudio", studioService.getList(condition));

		mav.setViewName("/cdms/studioWork/mainStudioWork");

		return mav;
	}

	/**
	 * 스튜디오 작업 달력 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/work/calendar/ajax.do")
	public ModelAndView calendar(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String viewType = HttpUtil.getParameter(req, "viewType", "week");
		Long studioSeq = HttpUtil.getParameter(req, "studioSeq", 0L);
		if ("week".equals(viewType)) {
			if (StringUtil.isNotEmpty(studioSeq)) {
				mav.addObject("listStudioTime", studioTimeService.getList(studioSeq));
			}
		}
		if (StringUtil.isNotEmpty(studioSeq)) {
			UICdmsStudioVO studio = new UICdmsStudioVO();
			studio.setStudioSeq(studioSeq);
			mav.addObject("detailStudio", studioService.getDetail(studio));
		}
		mav.setViewName("/cdms/studioWork/calendarStudioWork");

		return mav;

	}

	/**
	 * 스튜디오 작업 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @return ModelAndView - jsonView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/work/list/json.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UICdmsStudioWorkCondition condition = new UICdmsStudioWorkCondition();
		condition.setSrchStudioSeq(HttpUtil.getParameter(req, "srchStudioSeq", 0L));
		condition.setSrchStartDate(HttpUtil.getParameter(req, "srchStartDate", ""));
		condition.setSrchEndDate(HttpUtil.getParameter(req, "srchEndDate", ""));
		condition.setCurrentPage(0); // 전체
		condition.setOrderby(0); // cs_start_dtime ASC

		List<UICdmsStudioWorkRS> listStudioWork = new ArrayList<UICdmsStudioWorkRS>();
		Paginate<ResultSet> paginate = studioWorkService.getList(condition);
		if (paginate != null) {
			List<ResultSet> listItem = paginate.getItemList();
			if (listItem != null) {
				for (int index = 0; index < listItem.size(); index++) {
					listStudioWork.add((UICdmsStudioWorkRS)listItem.get(index));
				}
			}
		}
		mav.addObject("listStudioWork", listStudioWork);
		mav.setViewName("jsonView");

		return mav;
	}

	/**
	 * 스튜디오 작업 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioWorkVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/cdms/studio/work/detail.do", "/cdms/studio/work/detail/popup.do" })
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UICdmsStudioWorkVO studioWork) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UICdmsStudioWorkRS studioWorkRS = (UICdmsStudioWorkRS)studioWorkService.getDetail(studioWork);
		if (studioWorkRS != null) {
			Long studioSeq = studioWorkRS.getStudioWork().getStudioSeq();
			UICdmsStudioVO studio = new UICdmsStudioVO();
			studio.setStudioSeq(studioSeq);
			mav.addObject("detailStudio", studioService.getDetail(studio));
			mav.addObject("detailStudioWork", studioWorkRS);
		}
		mav.setViewName("/cdms/studioWork/detailStudioWork");
		return mav;
	}

	/**
	 * 스튜디오 작업 신규등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param studio
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/cdms/studio/work/create.do", "/cdms/studio/work/create/popup.do" })
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UICdmsStudioVO studio) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detailStudio", studioService.getDetail(studio));

		String workDate = HttpUtil.getParameter(req, "workDate", "");

		if (StringUtil.isNotEmpty(workDate)) {
			UICdmsStudioWorkCondition condition = new UICdmsStudioWorkCondition();
			condition.setSrchStudioSeq(studio.getStudioSeq());
			condition.setSrchStartDate(workDate + "000000");
			condition.setSrchEndDate(workDate + "235959");
			condition.setCurrentPage(0); // 전체
			condition.setOrderby(0); // cs_start_dtime ASC

			mav.addObject("paginateStudioWorkReserved", studioWorkService.getList(condition));
		}
		mav.addObject("listStudioTime", studioTimeService.getList(studio.getStudioSeq()));

		mav.setViewName("/cdms/studioWork/createStudioWork");
		return mav;
	}

	/**
	 * 스튜디오 작업 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioWorkVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = { "/cdms/studio/work/edit.do", "/cdms/studio/work/edit/popup.do" })
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UICdmsStudioWorkVO studioWork) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UICdmsStudioWorkRS studioWorkRS = (UICdmsStudioWorkRS)studioWorkService.getDetail(studioWork);
		if (studioWorkRS != null) {
			Long studioSeq = studioWorkRS.getStudioWork().getStudioSeq();
			UICdmsStudioVO studio = new UICdmsStudioVO();
			studio.setStudioSeq(studioSeq);
			mav.addObject("detailStudio", studioService.getDetail(studio));
			mav.addObject("detailStudioWork", studioWorkRS);
		}

		mav.setViewName("/cdms/studioWork/editStudioWork");
		return mav;
	}

	/**
	 * 스튜디오 작업 신규등록 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioWorkVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/work/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UICdmsStudioWorkVO studioWork, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, studioWork);

		int result = 1;
		try {
			studioWorkService.insertStudioWork(studioWork, attach);
		} catch (Exception e) {
			if (e instanceof EgovBizException) {
				EgovBizException egov = (EgovBizException)e;
				if (egov.getMessageKey().equals(Errors.DATA_EXIST.desc)) {
					result = 0;
				} else {
					throw e;
				}
			} else {
				throw e;
			}
		}
		mav.addObject("result", "{\"success\":\"" + result + "\"}");
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 스튜디오 작업 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioWorkVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/work/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UICdmsStudioWorkVO studioWork, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, studioWork);

		studioWorkService.updateStudioWork(studioWork, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 스튜디오 작업 취소 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioWorkVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/work/cancel/update.do")
	public ModelAndView updateCancel(HttpServletRequest req, HttpServletResponse res, UICdmsStudioWorkVO studioWork) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, studioWork);

		Long ssMemberSeq = SessionUtil.getMember(req).getMemberSeq();
		studioWork.setCancelMemberSeq(ssMemberSeq);
		String chargeYn = HttpUtil.getParameter(req, "chargeYn", "N");
		String description = HttpUtil.getParameter(req, "sendMemo", "");
		Long messageReceiveMemberSeq = HttpUtil.getParameter(req, "memoReceiveMemberSeq", 0L);
		if ("Y".equals(chargeYn) && StringUtil.isNotEmpty(description) && StringUtil.isNotEmpty(messageReceiveMemberSeq)) {
			UIMessageSendVO messageSend = new UIMessageSendVO();

			messageSend.setSendMemberSeq(ssMemberSeq);
			messageSend.setMessageTitle("쪽지");
			messageSend.setDescription(description);
			messageSend.setSendCount(1L);
			messageSend.setReferenceSeq(0L);
			// 메세지 예약발송구분
			messageSend.setSendScheduleCd("MESSAGE_SCHEDULE_TYPE::001");
			messageSend.setMessageTypeCd("MESSAGE_TYPE::MEMO");
			messageSend.copyAudit(studioWork);

			UIMessageReceiveVO messageReceive = new UIMessageReceiveVO();
			messageReceive.setReceiveMemberSeq(messageReceiveMemberSeq);
			messageReceive.setReceiveTypeCd("MESSAGE_RECEIVE_TYPE::002");
			messageReceive.copyAudit(studioWork);

			studioWorkService.updateCancelStudioWork(studioWork, messageSend, messageReceive);
		} else {
			studioWorkService.updateCancelStudioWork(studioWork, null, null);
		}
		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 스튜디오 작업 삭제 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioWorkVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/work/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UICdmsStudioWorkVO studioWork) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, studioWork);

		studioWorkService.deleteStudioWork(studioWork);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 결과정보관리 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/work/result/list.do")
	public ModelAndView listResult(HttpServletRequest req, HttpServletResponse res, UICdmsStudioWorkCondition condition, UICdmsStudioCondition stCondition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		if (StringUtil.isNotEmpty(condition.getSrchStartDate())) {
			condition.setSrchStartDate(DateUtil.convertStartDate(condition.getSrchStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}
		if (StringUtil.isNotEmpty(condition.getSrchEndDate())) {
			condition.setSrchEndDate(DateUtil.convertEndDate(condition.getSrchEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}
		mav.addObject("paginate", studioWorkService.getList(condition));
		mav.addObject("condition", condition);
		mav.addObject("listStudio", studioService.getList(stCondition));

		mav.setViewName("/cdms/studioWork/listStudioWorkResult");
		return mav;
	}

	/**
	 * 스튜디오 작업 결과 상세정보 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioWorkVO
	 * @param UICdmsStudioWorkCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/work/result/detail.do")
	public ModelAndView detailResult(HttpServletRequest req, HttpServletResponse res, UICdmsStudioWorkVO studioWork, UICdmsStudioWorkCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UICdmsStudioWorkRS studioWorkRS = (UICdmsStudioWorkRS)studioWorkService.getDetail(studioWork);
		if (studioWorkRS != null) {
			Long studioSeq = studioWorkRS.getStudioWork().getStudioSeq();
			UICdmsStudioVO studio = new UICdmsStudioVO();
			studio.setStudioSeq(studioSeq);
			mav.addObject("detailStudio", studioService.getDetail(studio));
			mav.addObject("detailStudioWork", studioWorkRS);
		}
		
		if (StringUtil.isNotEmpty(condition.getSrchStartDate())) {
			condition.setSrchStartDate(DateUtil.convertStartDate(condition.getSrchStartDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}
		if (StringUtil.isNotEmpty(condition.getSrchEndDate())) {
			condition.setSrchEndDate(DateUtil.convertEndDate(condition.getSrchEndDate(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME,
					Constants.FORMAT_TIMEZONE));
		}
		mav.addObject("condition", condition);
		mav.setViewName("/cdms/studioWork/detailStudioWorkResult");
		return mav;
	}

	/**
	 * 스튜디오 작업 촬영결과 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioWorkVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/work/result/edit.do")
	public ModelAndView editResult(HttpServletRequest req, HttpServletResponse res, UICdmsStudioWorkVO studioWork) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		UICdmsStudioWorkRS studioWorkRS = (UICdmsStudioWorkRS)studioWorkService.getDetail(studioWork);
		if (studioWorkRS != null) {
			Long studioSeq = studioWorkRS.getStudioWork().getStudioSeq();
			UICdmsStudioVO studio = new UICdmsStudioVO();
			studio.setStudioSeq(studioSeq);
			mav.addObject("detailStudio", studioService.getDetail(studio));
			mav.addObject("detailStudioWork", studioWorkRS);
		}

		mav.setViewName("/cdms/studioWork/editStudioWorkResult");
		return mav;
	}

	/**
	 * 스튜디오 작업 결과 수정 처리
	 * 
	 * @param req
	 * @param res
	 * @param UICdmsStudioWorkVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/cdms/studio/work/result/update.do")
	public ModelAndView updateResult(HttpServletRequest req, HttpServletResponse res, UICdmsStudioWorkVO studioWork, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, studioWork);

		Long ssMemberSeq = SessionUtil.getMember(req).getMemberSeq();
		studioWork.setResultMemberSeq(ssMemberSeq);
		studioWorkService.updateResultStudioWork(studioWork, attach);

		mav.setViewName("/common/save");
		return mav;
	}

}
