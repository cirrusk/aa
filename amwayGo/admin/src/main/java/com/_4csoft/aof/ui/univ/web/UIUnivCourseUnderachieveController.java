package com._4csoft.aof.ui.univ.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.HttpUtil;
import com._4csoft.aof.ui.infra.web.BaseController;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyCondition;
import com._4csoft.aof.univ.service.UnivCourseApplyService;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.web
 * @File : UIUnivCourseUnderachieveController.java
 * @Title : 학습 부진자 조회
 * @date : 2014. 3. 19.
 * @author : 장용기
 * @descrption : 학습 부진자 조회
 */
@Controller
public class UIUnivCourseUnderachieveController extends BaseController {

	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyService univCourseApplyService;
	
	/**
	 * 학습부진자 조회 목록
	 * 
	 * @param req
	 * @param res
	 * @param condition
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ("/univ/course/apply/underachieve/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIUnivCourseApplyCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");
		
		// 부진자 조회 검색
		condition.setSrchCourseActiveSeq(HttpUtil.getParameter(req, "shortcutCourseActiveSeq", 0L));
		condition.setSrchCourseTypeCd(HttpUtil.getParameter(req, "shortcutCourseTypeCd"));
		
		mav.addObject("paginate", univCourseApplyService.getListCourseApplyUnderachieve(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/univ/courseUnderachieve/listUnderachieve");
		return mav;
	}

}
