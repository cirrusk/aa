package com._4csoft.aof.ui.infra.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.infra.service.MessageTemplateService;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.ui.infra.vo.UIMessageTemplateVO;
import com._4csoft.aof.ui.infra.vo.condition.UIMessageTemplateCondition;

/**
 * @Project : aof5-univ-admin
 * @Package : com._4csoft.aof.ui.infra.web
 * @File : UIMessageTemplateController.java
 * @Title : 메일,SMS 템플릿관리
 * @date : 2014. 2. 21.
 * @author : 장용기
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Controller
public class UIMessageTemplateController extends BaseController {
	@Resource (name = "MessageTemplateService")
	private MessageTemplateService messageTemplateService;
	
	/**
	 * 메일,SMS 템플릿관리 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param String
	 * @param UIMessageTemplateCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/template/{templateType}/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, @PathVariable ("templateType") String templateType, UIMessageTemplateCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();
		
		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		String viewName = "/infra/template/listTemplate" + StringUtil.capitalize(templateType);

		condition.setSrchTemplateType(templateType);
		mav.addObject("paginate", messageTemplateService.getList(condition));
		mav.addObject("condition", condition);
		mav.setViewName(viewName);
		
		return mav;
	}
	
	/**
	 * 메일,SMS 템플릿관리 등록 화면
	 * 
	 * @param req
	 * @param res
	 * @param String
	 * @param UIMessageTemplateCondition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/template/{templateType}/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, @PathVariable ("templateType") String templateType, UIMessageTemplateCondition condition)
			throws Exception {
		ModelAndView mav = new ModelAndView();
		
		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		String viewName = "/infra/template/createTemplate" + StringUtil.capitalize(templateType);

		mav.addObject("condition", condition);
		mav.setViewName(viewName);
		
		return mav;
	}
	
	/**
	 * 메일,SMS 템플릿관리 등록
	 * 
	 * @param req
	 * @param res
	 * @param String
	 * @param UIMessageTemplateVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/template/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIMessageTemplateVO template) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, template);
	
		emptyValue(template, "basicUseYn=N");
	
		messageTemplateService.insertMessageTemplate(template);

		mav.setViewName("/common/save");
		return mav;
	}
	
	
	/**
	 * 메일,SMS 템플릿관리 상세화면
	 * 
	 * @param req
	 * @param res
	 * @param String
	 * @param UIMessageTemplateCondition
	 * @param UIMessageTemplateVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/template/{templateType}/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, @PathVariable ("templateType") String templateType, UIMessageTemplateCondition condition,
			UIMessageTemplateVO template) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String viewName = "/infra/template/detailTemplate" + StringUtil.capitalize(templateType);
		
		mav.addObject("detail", messageTemplateService.getDetail(template));
		mav.addObject("condition", condition);
		
		mav.setViewName(viewName);

		return mav;
	}
	
	/**
	 * 메일,SMS 템플릿관리 수정화면
	 * 
	 * @param req
	 * @param res
	 * @param String
	 * @param UIMessageTemplateCondition
	 * @param UIMessageTemplateVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/template/{templateType}/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, @PathVariable ("templateType") String templateType, UIMessageTemplateCondition condition,
			UIMessageTemplateVO template) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		String viewName = "/infra/template/editTemplate" + StringUtil.capitalize(templateType);
		
		mav.addObject("detail", messageTemplateService.getDetail(template));
		mav.addObject("condition", condition);
		
		mav.setViewName(viewName);

		return mav;
	}
	
	/**
	 * 메일,SMS 템플릿관리 수정
	 * 
	 * @param req
	 * @param res
	 * @param UIMessageTemplateVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/template/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIMessageTemplateVO template) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, template);
		
		emptyValue(template, "basicUseYn=N");
		
		messageTemplateService.updateMessageTemplate(template);

		mav.setViewName("/common/save");
		return mav;
	}
	
	/**
	 * 메일,SMS 템플릿관리 삭제
	 * 
	 * @param req
	 * @param res
	 * @param UIMessageTemplateVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/template/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIMessageTemplateVO template) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, template);

		messageTemplateService.deleteMessageTemplate(template);

		mav.setViewName("/common/save");
		return mav;
	}
		
}
