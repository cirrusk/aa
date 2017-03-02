package com._4csoft.aof.ui.board.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com._4csoft.aof.board.service.PopupService;
import com._4csoft.aof.board.vo.PopupVO;
import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.ui.board.vo.UIPopupVO;
import com._4csoft.aof.ui.board.vo.condition.UIPopupCondition;
import com._4csoft.aof.ui.infra.vo.UIAttachVO;
import com._4csoft.aof.ui.infra.web.BaseController;

@Controller
public class UIPopupController extends BaseController {

	@Resource (name = "PopupService")
	private PopupService popupService;

	/**
	 * 팝업 목록 화면
	 * 
	 * @param req
	 * @param res
	 * @param popup
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/popup/list.do")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse res, UIPopupVO popup, UIPopupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);
		emptyValue(condition, "currentPage=1", "perPage=" + Constants.DEFAULT_PERPAGE, "orderby=0");

		mav.addObject("paginate", popupService.getList(condition));
		mav.addObject("condition", condition);

		mav.setViewName("/board/popup/listPopup");
		return mav;
	}

	/**
	 * 팝업 상세 화면
	 * 
	 * @param req
	 * @param res
	 * @param popup
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/popup/detail.do")
	public ModelAndView detail(HttpServletRequest req, HttpServletResponse res, UIPopupVO popup, UIPopupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", popupService.getDetail(popup));
		mav.addObject("condition", condition);

		mav.setViewName("/board/popup/detailPopup");
		return mav;
	}

	/**
	 * 팝업 등록화면
	 * 
	 * @param req
	 * @param res
	 * @param popup
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/popup/create.do")
	public ModelAndView create(HttpServletRequest req, HttpServletResponse res, UIPopupVO popup, UIPopupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("condition", condition);

		mav.setViewName("/board/popup/createPopup");
		return mav;
	}

	/**
	 * 팝업 수정 화면
	 * 
	 * @param req
	 * @param res
	 * @param popup
	 * @param condition
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/popup/edit.do")
	public ModelAndView edit(HttpServletRequest req, HttpServletResponse res, UIPopupVO popup, UIPopupCondition condition) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req);

		mav.addObject("detail", popupService.getDetail(popup));
		mav.addObject("condition", condition);

		mav.setViewName("/board/popup/editPopup");
		return mav;
	}

	/**
	 * 팝업 신규 등록
	 * 
	 * @param req
	 * @param res
	 * @param popup
	 * @param attach
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/popup/insert.do")
	public ModelAndView insert(HttpServletRequest req, HttpServletResponse res, UIPopupVO popup, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, popup);

		popup.setStartDtime(DateUtil.convertStartDate(popup.getStartDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		popup.setEndDtime(DateUtil.convertEndDate(popup.getEndDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));

		popupService.insertPopup(popup, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 팝업 수정
	 * 
	 * @param req
	 * @param res
	 * @param popup
	 * @param attach
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/popup/update.do")
	public ModelAndView update(HttpServletRequest req, HttpServletResponse res, UIPopupVO popup, UIAttachVO attach) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, popup);

		popup.setStartDtime(DateUtil.convertStartDate(popup.getStartDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));
		popup.setEndDtime(DateUtil.convertEndDate(popup.getEndDtime(), Constants.FORMAT_DATE, Constants.FORMAT_DBDATETIME, Constants.FORMAT_TIMEZONE));

		popupService.updatePopup(popup, attach);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 팝업 삭제
	 * 
	 * @param req
	 * @param res
	 * @param popup
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/popup/delete.do")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse res, UIPopupVO popup) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, popup);

		popupService.deletePopup(popup);

		mav.setViewName("/common/save");
		return mav;
	}

	/**
	 * 팝업 멀티 삭제
	 * 
	 * @param req
	 * @param res
	 * @param popup
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping ("/popup/deletelist.do")
	public ModelAndView deletelist(HttpServletRequest req, HttpServletResponse res, UIPopupVO popup) throws Exception {
		ModelAndView mav = new ModelAndView();

		requiredSession(req, popup);

		List<PopupVO> popups = new ArrayList<PopupVO>();
		for (String index : popup.getCheckkeys()) {
			UIPopupVO o = new UIPopupVO();
			o.setPopupSeq(popup.getPopupSeqs()[Integer.parseInt(index)]);
			o.copyAudit(popup);
			popups.add(o);
		}
		if (popups.size() > 0) {
			mav.addObject("result", popupService.deletelist(popups));
		} else {
			mav.addObject("result", 0);
		}
		mav.setViewName("/common/save");
		return mav;
	}
}
