package com._4csoft.aof.ui.univ.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.util.SessionUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseActiveVO;
import com._4csoft.aof.ui.univ.vo.UIUnivGradeLevelVO;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivGradeLevelCondition;
import com._4csoft.aof.univ.service.UnivCourseActiveService;
import com._4csoft.aof.univ.service.UnivGradeLevelService;
import com._4csoft.aof.univ.service.UnivYearTermService;
import com._4csoft.aof.univ.vo.UnivGradeLevelVO;
import com._4csoft.aof.univ.vo.UnivYearTermVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UnivGradeLevelController.java
 * @Title : 성적등급관리
 * @date : 2014. 2. 20
 * @author : 장용기
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIUnivGradeLevelController extends BaseController {

	@Resource (name = "UnivYearTermService")
	private UnivYearTermService univYearTermService;

	@Resource (name = "UnivGradeLevelService")
	private UnivGradeLevelService univGradeLevelService;

	@Resource (name = "UnivCourseActiveService")
	private UnivCourseActiveService univCourseActiveService;

	/**
	 * 성적등급관리 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/gradelevel/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivGradeLevelCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=0", "perPage=0", "orderby=0");

		// 시스템에 설정된 년도학기
		MemberVO ssMember = SessionUtil.getMember(req);
		if (StringUtil.isEmpty(condition.getSrchYearTerm())) {
			UnivYearTermVO univYearTermVO = (UnivYearTermVO)ssMember.getExtendData().get("systemYearTerm");
			condition.setSrchYearTerm(univYearTermVO.getYearTerm());
		}

		if (!"".equals(condition.getSrchYearTerm()) && condition.getSrchYearTerm() != null) {
			mav.addObject("paginate", univGradeLevelService.getList(condition));
		}
		// 검색 조건의 년도학기
		mav.addObject("yearTerms", univYearTermService.getListYearTermAll());
		mav.addObject("condition", condition);

		mav.setViewName("/univ/gradeLevel/listGradeLevel");
		return mav;
	}

	/**
	 * 성적등급관리 등록
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivGradeLevelVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/gradelevel/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIUnivGradeLevelVO gradeLevel) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, gradeLevel);

		// 성적등급, 평점, 절대평가, 상대평가 값 중복체크 후 등록
		int result = 0;
		UIUnivGradeLevelVO vo = (UIUnivGradeLevelVO)univGradeLevelService.countGradeLevelByYearTerm(gradeLevel);

		if (vo == null) {
			result = univGradeLevelService.insert(gradeLevel);
		} else {
			if (vo.getGradeLevelCount() + vo.getRatingScoreCount() + vo.getEvalAbsoluteScoreCount() + vo.getEvalRelativeScoreCount() > 0) {
				result = 0;
			} else {
				result = univGradeLevelService.insert(gradeLevel);
			}
		}

		mav.addObject("result", result);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 성적등급관리 수정
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivGradeLevelVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/gradelevel/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIUnivGradeLevelVO gradeLevel) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, gradeLevel);
		List<UnivGradeLevelVO> list = new ArrayList<UnivGradeLevelVO>();

		int result = 0;
		long count = 0;
		if (gradeLevel.getGradeLevelCds().length > 0) {
			for (int i = 0; i < gradeLevel.getGradeLevelCds().length; i++) {
				UIUnivGradeLevelVO o = new UIUnivGradeLevelVO();
				o.setYearTerm(gradeLevel.getYearTerms()[i]);
				o.setGradeLevelCd(gradeLevel.getGradeLevelCds()[i]);
				o.setRatingScore(gradeLevel.getRatingScores()[i]);
				o.setEvelRelativeScore(gradeLevel.getEvelRelativeScores()[i]);
				o.setEvalAbsoluteScore(gradeLevel.getEvalAbsoluteScores()[i]);
				o.copyAudit(gradeLevel);
				list.add(o);

				// 평점, 절대평가, 상대평가 중복값 비교
				for (int j = i + 1; j < gradeLevel.getGradeLevelCds().length; j++) {
					if (gradeLevel.getRatingScores()[i] != null && gradeLevel.getRatingScores()[i].equals(gradeLevel.getRatingScores()[j])) {
						count = 1;
						break;
					}
					if (gradeLevel.getEvalAbsoluteScores()[i] != null && gradeLevel.getEvalAbsoluteScores()[i].equals(gradeLevel.getEvalAbsoluteScores()[j])) {
						count = 2;
						break;
					}
					if (gradeLevel.getEvelRelativeScores()[i] != null && gradeLevel.getEvelRelativeScores()[i].equals(gradeLevel.getEvelRelativeScores()[j])) {
						count = 3;
						break;
					}
				}

				if (count > 0) {
					break;
				}
			}
			if (count == 0) {
				result = univGradeLevelService.savelistGradeLevel(list);
			}
		}
		mav.addObject("result", result);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 성적등급관리 이전학기 복사 저장
	 * 
	 * @param req
	 * @param res
	 * @param UIUnivGradeLevelVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/univ/gradelevel/copy/insert.do")
	public ModelAndView insertCopy(HttpServletRequest req, HttpServletResponse res, UIUnivGradeLevelVO vo) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, vo);

		// 전년도 이전학기 값 구하기
		int beforeYear = (Integer.parseInt(vo.getYearTerm().substring(0, 4))) - 1;
		String beforeYearTerm = Integer.toString(beforeYear) + vo.getYearTerm().substring(4, 6);
		vo.setBeforeYearTerm(beforeYearTerm);

		// 복사대상 체크
		UIUnivGradeLevelCondition condition = new UIUnivGradeLevelCondition();
		condition.setSrchYearTerm(beforeYearTerm);
		int result = 0;
		if (univGradeLevelService.countList(condition) > 0) {
			result = univGradeLevelService.insertCopyGradeLevel(vo);
		}

		mav.addObject("result", result);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 성적등급관리 팝업 화면
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/gradelevel/popup.do")
	public ModelAndView listPopUp(HttpServletRequest req, HttpServletResponse res, UIUnivGradeLevelCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=0", "perPage=0", "orderby=0");

		if (!"".equals(condition.getSrchYearTerm()) && condition.getSrchYearTerm() != null) {
			mav.addObject("paginate", univGradeLevelService.getList(condition));
		}

		// 개설과목 정보
		UIUnivCourseActiveVO courseActive = new UIUnivCourseActiveVO();
		courseActive.setCourseActiveSeq(condition.getSrchCourseActiveSeq());
		mav.addObject("getDetail", univCourseActiveService.getDetailCourseActive(courseActive));

		mav.setViewName("/univ/gradeLevel/listGradeLevelPopup");
		return mav;
	}

}
