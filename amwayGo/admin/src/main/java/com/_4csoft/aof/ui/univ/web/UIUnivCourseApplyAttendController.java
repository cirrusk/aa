/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.univ.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.view.ExcelDownloadView;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.lcms.service.LcmsDailyProgressService;
import com._4csoft.aof.lcms.service.LcmsLearnerDatamodelService;
import com._4csoft.aof.lcms.vo.LcmsLearnerDatamodelVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.lcms.vo.UILcmsDailyProgressVO;
import com._4csoft.aof.ui.lcms.vo.UILcmsLearnerDatamodelVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveElementVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseApplyAttendVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseAttendEvaluateVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyAttendCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseApplyAttendRS;
import com._4csoft.aof.univ.service.UnivCourseActiveElementService;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivCourseApplyAttendService;
import com._4csoft.aof.univ.service.UnivCourseAttendEvaluateService;
import com._4csoft.aof.univ.vo.UnivCourseApplyAttendVO;

import egovframework.com.cmm.EgovMessageSource;

/**
 * 
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseApplyAttendController.java
 * @Title : 수강생 출석 컨트롤러
 * @date : 2014. 3. 13.
 * @author : 김현우
 * @descrption : 수강생 출석 컨트롤러
 */
@Controller
public class UIUnivCourseApplyAttendController extends BaseController {

	@Resource (name = "UnivCourseApplyAttendService")
	private UnivCourseApplyAttendService applyAttendService;

	@Resource (name = "UnivCourseActiveElementService")
	private UnivCourseActiveElementService elementService;

	@Resource (name = "UnivCourseAttendEvaluateService")
	private UnivCourseAttendEvaluateService univCourseAttendEvaluateService;

	@Resource (name = "LcmsLearnerDatamodelService")
	private LcmsLearnerDatamodelService learnerDatamodelService;

	@Resource (name = "LcmsDailyProgressService")
	private LcmsDailyProgressService dailyProgressService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService courseActiveService;

	@Resource (name = "egovMessageSource")
	EgovMessageSource messageSource;

	private final String JXLS_PATH = "univ/jxls/";

	private final String JXLS_DOWNLOAD_PATH = JXLS_PATH + "download/";

	/**
	 * 온라인 수업/출석 결과 프레임 부모 호출 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/online/attend/result/list.do")
	public ModelAndView listOnline(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyAttendCondition condition,
			UIUnivCourseApplyAttendVO applyAttend) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.setViewName("/univ/courseApplyAttend/online/listApplyAttendOn");
		return mav;
	}

	/**
	 * 온라인 수업/출석 결과 학습자별 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/online/attend/result/apply/list/iframe.do")
	public ModelAndView listOnlineApply(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyAttendCondition condition,
			UIUnivCourseApplyAttendVO applyAttend) throws Exception {
		ModelAndView mav = new ModelAndView();

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		requiredSession(req);

		mav.addObject("paginate", applyAttendService.getListByOnlineApplyCourseApplyAttend(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseApplyAttend/online/listApplyAttendOnApply");
		return mav;
	}

	/**
	 * 온라인 수업/출석 결과 학습자별 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/online/attend/result/apply/detail/popup.do")
	public ModelAndView detailOnlineApplyPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveElementVO activeElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		activeElement.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		activeElement.setCourseWeekTypeCd("COURSE_WEEK_TYPE::LECTURE");
		// 주차
		mav.addObject("itemList", elementService.getListResultDatamodel(activeElement));
		mav.addObject("activeElement", activeElement);

		mav.setViewName("/univ/courseApplyAttend/online/detailApplyAttendOnApplyPopup");
		return mav;
	}

	/**
	 * 온라인 수업/출석 결과 주차별 팝업
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/online/attend/result/week/detail/popup.do")
	public ModelAndView detailOnlineWeekPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveElementVO activeElement,
			UILcmsDailyProgressVO dailyProgress) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		activeElement.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		activeElement.setCourseWeekTypeCd("COURSE_WEEK_TYPE::LECTURE");
		// 주차
		mav.addObject("itemList", elementService.getListResultDatamodel(activeElement));
		mav.addObject("dailyProgressList", dailyProgressService.getList(dailyProgress));
		mav.addObject("activeElement", activeElement);

		mav.setViewName("/univ/courseApplyAttend/online/detailApplyAttendOnWeekPopup");
		return mav;
	}

	/**
	 * 온라인 수업/출석 결과 주차별 상세 화면
	 * 
	 * @param req
	 * @param res
	 * @param activeElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/online/attend/result/week/list/iframe.do")
	public ModelAndView listOnlineWeek(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveElementVO activeElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		activeElement.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		activeElement.setCourseWeekTypeCd("COURSE_WEEK_TYPE::LECTURE");

		// 주차
		mav.addObject("itemList", elementService.getListWeekResultDatamodel(activeElement));
		mav.addObject("activeElement", activeElement);

		mav.setViewName("/univ/courseApplyAttend/online/listApplyAttendOnWeek");

		return mav;
	}

	/**
	 * 온라인 수업/출석 결과 주차별 상세 화면
	 * 
	 * @param req
	 * @param res
	 * @param activeElement
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/online/attend/result/week/detail/iframe.do")
	public ModelAndView detailOnlineWeek(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyAttendCondition condition,
			UIUnivCourseActiveElementVO activeElement) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		requiredSession(req);

		mav.addObject("applyCnt", applyAttendService.countByMemberCountCourseApplyAttend(condition.getSrchCourseActiveSeq()));
		mav.addObject("detail", elementService.getDetail(activeElement));
		mav.addObject("paginate", applyAttendService.getListByOnlineApplyCourseApplyAttend(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseApplyAttend/online/detailApplyAttendOnWeek");

		return mav;
	}

	/**
	 * 관리자에서 학습자 진도율 수정 (개설과목관리 > 온라인 수업/출석 결과 에서 사용)
	 * 
	 * @param req
	 * @param res
	 * @param datamodel
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/online/attend/result/updatelist.do")
	public ModelAndView updatelistOnline(HttpServletRequest req, HttpServletResponse res, UILcmsLearnerDatamodelVO datamodel,
			UIUnivCourseApplyAttendVO applyAttend) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req, datamodel);
		requiredSession(req, applyAttend);

		// [1] 진도율 업데이트
		List<LcmsLearnerDatamodelVO> listDatamodel = new ArrayList<LcmsLearnerDatamodelVO>();

		for (int index = 0; index < datamodel.getProgressMeasures().length; index++) {
			UILcmsLearnerDatamodelVO o = new UILcmsLearnerDatamodelVO();
			o.setCourseActiveSeq(datamodel.getCourseActiveSeq());
			o.setCourseApplySeq(datamodel.getCourseApplySeq());
			o.setLearnerId(datamodel.getLearnerId());
			o.setProgressMeasure((Double.parseDouble(datamodel.getProgressMeasures()[index]) / 100) + "");
			o.setOrganizationSeq(datamodel.getOrganizationSeqs()[index]);

			o.setItemSeq(datamodel.getItemSeqs()[index]);
			o.copyAudit(datamodel);

			String oldProgressMeasure = datamodel.getOldProgressMeasures()[index];
			String progressMeasure = datamodel.getProgressMeasures()[index];

			if (!oldProgressMeasure.equals(progressMeasure)) { // 변경되었으면 처리함.
				listDatamodel.add(o);
			}
		}

		if (!listDatamodel.isEmpty()) {
			learnerDatamodelService.savelistLearnerDatamodel(listDatamodel);
		}

		// [2] 출석 업데이트
		List<UnivCourseApplyAttendVO> listApplyAttend = new ArrayList<UnivCourseApplyAttendVO>();

		for (int index = 0; index < applyAttend.getAttendTypeCds().length; index++) {
			UnivCourseApplyAttendVO o = new UnivCourseApplyAttendVO();
			o.setCourseActiveSeq(applyAttend.getCourseActiveSeq());
			o.setCourseApplySeq(applyAttend.getCourseApplySeq());
			o.setReferenceSeq(datamodel.getOrganizationSeqs()[index]);
			o.setLessonSeq(datamodel.getItemSeqs()[index]);
			o.setActiveElementSeq(applyAttend.getActiveElementSeqs()[index]);
			o.setAttendTypeCd(applyAttend.getAttendTypeCds()[index]);
			o.setOnoffCd("ONOFF_TYPE::ON");
			o.copyAudit(datamodel);

			String oldAttendTypeCd = applyAttend.getOldAttendTypeCds()[index];
			String attendTypeCd = applyAttend.getAttendTypeCds()[index];

			if (!oldAttendTypeCd.equals(attendTypeCd)) { // 변경되었으면 처리함.
				listApplyAttend.add(o);
			}
		}

		if (!listApplyAttend.isEmpty()) {
			applyAttendService.savelistByOnlineCourseApplyAttend(listApplyAttend);
		}

		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 오프라인 수업/출석 결과 프레임 부모 호출 화면
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/offline/attend/result/list.do")
	public ModelAndView listOffline(HttpServletRequest req, HttpServletResponse res, UIUnivCourseAttendEvaluateVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		vo.setCourseActiveSeq(vo.getShortcutCourseActiveSeq());
		vo.setOnoffCd("ONOFF_TYPE::OFF");

		UIUnivCourseActiveElementVO element = new UIUnivCourseActiveElementVO();
		element.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		element.setCourseActiveSeq(vo.getShortcutCourseActiveSeq());
		mav.addObject("listElement", elementService.getList(element));

		mav.addObject("list", univCourseAttendEvaluateService.getListCourseAttendEvaluate(vo));

		mav.setViewName("/univ/courseApplyAttend/offline/listApplyAttendOff");
		return mav;
	}

	/**
	 * 오프라인 출석 평가기준 수정
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/offline/attend/result/edit.do")
	public ModelAndView editOffline(HttpServletRequest req, HttpServletResponse res, UIUnivCourseAttendEvaluateVO evaluateVo,
			UIUnivCourseActiveElementVO elementVo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		evaluateVo.setCourseActiveSeq(evaluateVo.getShortcutCourseActiveSeq());
		evaluateVo.setOnoffCd("ONOFF_TYPE::OFF");

		elementVo.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");

		mav.addObject("listElement", elementService.getOfflineElementList(elementVo));

		mav.addObject("list", univCourseAttendEvaluateService.getListCourseAttendEvaluate(evaluateVo));

		mav.setViewName("/univ/courseApplyAttend/offline/editAttendEvaluateOff");
		return mav;
	}

	/**
	 * 오프라인 출석결과 출석부입력 리스트
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/offline/attend/result/regist/list/iframe.do")
	public ModelAndView listOfflineAttend(HttpServletRequest req, HttpServletResponse res, UIUnivCourseAttendEvaluateVO vo,
			UIUnivCourseActiveElementVO elementVo, UIUnivCourseApplyAttendCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		vo.setCourseActiveSeq(vo.getShortcutCourseActiveSeq());
		vo.setOnoffCd("ONOFF_TYPE::OFF");
		condition.setSrchCourseActiveSeq(vo.getShortcutCourseActiveSeq());

		// 주차정보 조회
		UIUnivCourseActiveElementVO element = new UIUnivCourseActiveElementVO();
		element.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		element.setCourseActiveSeq(vo.getShortcutCourseActiveSeq());
		if (elementVo.getSortOrder() == null) {
			element.setSortOrder(3l);
		} else {
			element.setSortOrder(elementVo.getSortOrder());
		}

		// 오프라인 출석 수강생 정보조회
		mav.addObject("applyMember", applyAttendService.getListByOfflineApplyMember(condition));
		mav.addObject("listElement", elementService.getList(element));

		// 수강생 출석정보 조회
		List<ResultSet> listApplyAttend = applyAttendService.getListByOfflineApplyAttend(element);
		HashMap<String, String> hashMap = new HashMap<String, String>();
		for (int i = 0; listApplyAttend.size() > i; i++) {
			UIUnivCourseApplyAttendRS rs = (UIUnivCourseApplyAttendRS)listApplyAttend.get(i);
			hashMap.put(rs.getApplyAttend().getActiveElementSeq() + "_" + rs.getApplyAttend().getLessonSeq() + "_" + rs.getApplyAttend().getCourseApplySeq(),
					rs.getApplyAttend().getAttendTypeCd());
		}
		mav.addObject("applyAttend", applyAttendService.getListByOfflineApplyAttend(element));
		mav.addObject("applyAttendHash", hashMap);
		mav.addObject("sortOrderNum", elementVo.getSortOrder() == null ? "3" : String.valueOf(elementVo.getSortOrder()));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseApplyAttend/offline/listApplyAttendOffApply");

		return mav;
	}

	/**
	 * 오프라인 출석입력 팝업창
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param elementVo
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/offline/attend/result/regist/create/popup.do")
	public ModelAndView createOfflineAttend(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyAttendCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req);

		mav.addObject("itemList", applyAttendService.getListCourseApplyOfflineAttend(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseApplyAttend/offline/createApplyAttendOffApplyPopup");

		return mav;
	}

	/**
	 * 오프라인 출석입력
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @param elementVo
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/offline/attend/result/regist/update.do")
	public ModelAndView updateOfflineAttend(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyAttendCondition condition,
			UIUnivCourseApplyAttendVO attendVo) throws Exception {
		ModelAndView mav = new ModelAndView();
		requiredSession(req, attendVo);

		List<UnivCourseApplyAttendVO> voList = new ArrayList<UnivCourseApplyAttendVO>();

		for (int index = 0; index < attendVo.getCourseApplySeqs().length; index++) {
			UIUnivCourseApplyAttendVO vo = new UIUnivCourseApplyAttendVO();
			vo.setCourseApplyAttendSeq(attendVo.getCourseApplyAttendSeqs()[index]);
			vo.setLessonSeq(attendVo.getLessonSeq());
			vo.setCourseApplySeq(attendVo.getCourseApplySeqs()[index]);
			vo.setActiveElementSeq(attendVo.getActiveElementSeq());
			vo.setAttendTypeCd(attendVo.getAttendTypeCdList().get(index));
			vo.setOnoffCd(attendVo.getOnoffCd());
			vo.setCourseActiveSeq(attendVo.getCourseActiveSeq());
			vo.copyAudit(attendVo);
			voList.add(vo);
		}

		if (voList.isEmpty()) {
			mav.addObject("result", 0);
		} else {
			mav.addObject("result", applyAttendService.savelistByOfflineCourseApplyAttend(voList));
		}

		mav.setViewName("/common/save");

		return mav;
	}

	/**
	 * 오프라인 출석부 excel 다운로드 한다.
	 * 
	 * @param req
	 * @param res
	 * @param UIMemberCondition
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/offline/attend/result/regist/excel.do")
	public ModelAndView excel(HttpServletRequest req, HttpServletResponse res, UIUnivCourseActiveElementVO elementVo, UIUnivCourseApplyAttendCondition condition)
			throws Exception {

		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		// 주차정보 조회
		UIUnivCourseActiveElementVO element = new UIUnivCourseActiveElementVO();
		element.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		element.setCourseActiveSeq(condition.getSrchCourseActiveSeq());
		element.setSortOrder(elementVo.getSortOrder());

		List<ResultSet> elementList = elementService.getList(element);

		// 개설과목명 조회
		UIUnivCourseActiveVO activeVo = new UIUnivCourseActiveVO();
		activeVo.setCourseActiveSeq(condition.getSrchCourseActiveSeq());

		ResultSet courseActive = courseActiveService.getDetailCourseActive(activeVo);

		// 수강생정보 조회
		List<ResultSet> applyAttendList = applyAttendService.getListByOfflineApplyMember(condition);

		mav.setViewName("excelView");
		mav.addObject("courseActive", courseActive);
		mav.addObject("list", applyAttendList);
		mav.addObject("elementList", elementList);

		mav.addObject(ExcelDownloadView.TEMPLATE_FILE_NAME, JXLS_DOWNLOAD_PATH + "offlineAttendTemplate");
		mav.addObject(ExcelDownloadView.DOWNLOAD_FILE_NAME, "offlineAttendTemplate_" + DateUtil.getToday("yyyyMMdd"));

		return mav;
	}

	/**
	 * 오프라인 출석결과 점수
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/offline/attend/result/Score/list/iframe.do")
	public ModelAndView listOfflineApplyAttendScore(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyAttendCondition condition)
			throws Exception {

		ModelAndView mav = new ModelAndView();
		requiredSession(req);

		mav.addObject("itemList", applyAttendService.getListByOfflineApplyAttendScore(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseApplyAttend/offline/listApplyAttendOffScore");

		return mav;
	}

	/**
	 * 오프라인 수업 출석현황 상세팝업
	 * 
	 * @param req
	 * @param res
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/active/offline/attend/result/Score/detail/popup.do")
	public ModelAndView detailOfflineApplyAttendPopup(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyAttendVO attendVo,
			UIUnivCourseApplyAttendCondition condition) throws Exception {

		ModelAndView mav = new ModelAndView();
		requiredSession(req);

		// 주차정보 조회
		UIUnivCourseActiveElementVO element = new UIUnivCourseActiveElementVO();
		element.setReferenceTypeCd("COURSE_ELEMENT_TYPE::ORGANIZATION");
		element.setCourseActiveSeq(attendVo.getCourseActiveSeq());

		mav.addObject("listElement", elementService.getList(element));

		// 수강생 출석정보 조회
		List<ResultSet> listApplyAttend = applyAttendService.getDetailByOffApplyAttend(attendVo);
		HashMap<String, String> hashMap = new HashMap<String, String>();
		for (int i = 0; listApplyAttend.size() > i; i++) {
			UIUnivCourseApplyAttendRS rs = (UIUnivCourseApplyAttendRS)listApplyAttend.get(i);
			hashMap.put(rs.getApplyAttend().getActiveElementSeq() + "_" + rs.getApplyAttend().getLessonSeq(), rs.getApplyAttend().getAttendTypeCd());
		}

		mav.addObject("applyAttendHash", hashMap);
		mav.addObject("totalAttendCount", listApplyAttend.size());
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseApplyAttend/offline/detailApplyAttendOffPopup");

		return mav;
	}
}
