package amway.com.academy.manager.common.noteSet.web;

import javax.servlet.http.HttpServletRequest;

import amway.com.academy.manager.common.noteSet.service.NoteSetService;
import amway.com.academy.manager.common.util.PropertiesReader;
import amway.com.academy.manager.common.util.SessionUtil;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;
import org.apache.ibatis.transaction.TransactionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import framework.com.cmm.lib.RequestBox;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/manager/common/noteSet")
public class NoteSetController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(NoteSetController.class);

	@Autowired
	NoteSetService noteSetService;

	/**
	 *  쪽지설정 리스트
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/noteSetList.do")
    public ModelAndView noteSetList(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{

		return mav;
    }

	/**
	 *  쪽지설정 리스트(AJAX)
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/noteSetListAjax.do")
	public ModelAndView noteSetListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(noteSetService.noteSetListCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.putAll(pageVO.toMapData());
        rtnMap.put("dataList",noteSetService.noteSetList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}

	/**
	 * 쪽지설정 팝업
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/noteSetPop.do")
	public ModelAndView noteSetPop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		DataBox popDetail = noteSetService.noteSetPop(requestBox);
		model.addAttribute("codeDetail", popDetail);
		model.addAttribute("layerMode", requestBox);

		return mav;
	}

	/**
	 * 쪽지설정 등록
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/noteSetInsert.do")
	public ModelAndView noteSetInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));

		try {
			noteSetService.noteSetInsert(requestBox);

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( TransactionException e ) {
			e.printStackTrace();
			String msg = ppt.getProperties("errors.system");
			resultMap.put("errMsg", msg);
		}

		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}

	/**
	 * 쪽지설정 수정
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/noteSetUpdate.do")
	public ModelAndView systemCodeUpdate(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();
		requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));

		try {
			noteSetService.noteSetUpdate(requestBox);

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( TransactionException e ) {
			e.printStackTrace();
			String msg = ppt.getProperties("errors.system");
			resultMap.put("errMsg", msg);
		}

		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}

	/**
	 * 쪽지설정 삭제
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/noteSetDelete.do")
	public ModelAndView noteSetDelete(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		try {
			noteSetService.noteSetDelete(requestBox);

			resultMap.put("errCode", "0");
			resultMap.put("errMsg", "");
		} catch ( TransactionException e ) {
			e.printStackTrace();
			String msg = ppt.getProperties("errors.system");
			resultMap.put("errMsg", msg);
		}

		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}

}