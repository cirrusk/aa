package amway.com.academy.manager.common.targetRule.web;

import amway.com.academy.manager.common.targetRule.service.TargetRuleService;
import amway.com.academy.manager.common.util.PropertiesReader;
import amway.com.academy.manager.common.util.SessionUtil;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;
import java.io.IOException;

@Controller
@RequestMapping("/manager/common/targetRule")
public class TargetRuleController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TargetRuleController.class);

	@Autowired
	TargetRuleService targetRuleService;


	/**
	 *  대상자조건설정 페이지호출
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetRuleList.do")
	public ModelAndView targetRuleList(RequestBox requestBox, ModelAndView mav) throws Exception {
		return mav;
	}

	/**
	 *  대상자조건설정 페이지호출
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetRuleListAjax.do")
	public ModelAndView targetRuleListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(targetRuleService.targetRuleCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",targetRuleService.targetRuleList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}


	/**
	 *   대상자조건 설정 팝업
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/targetRulePop.do")
	public ModelAndView targetRulePop(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {

		DataBox targetDetail = targetRuleService.targetRulePop(requestBox);
		model.addAttribute("targetDetail", targetDetail);
		model.addAttribute("layerMode", requestBox);

		return mav;
	}

	/**
	 *   대상자조건 설정 팝업
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/targetRuleCode.do")
	public ModelAndView targetRuleCode(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		rtnMap.put("listCode", targetRuleService.targetRuleCode(requestBox)); //코드분류 리스트

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);

		return mav;
	}

	/**
	 * 대상자조건 설정 등록
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetRuleInsert.do")
	public ModelAndView targetRuleInsert(ModelMap model,HttpServletRequest request,ModelAndView mav,RequestBox requestBox)throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		PropertiesReader ppt = new PropertiesReader();

		int result = 0;
		try {
			requestBox.put("sessionAccount", requestBox.getSession( SessionUtil.sessionAdno ));
			result = targetRuleService.targetRuleInsert(requestBox);

			resultMap.put("errCode", result);
			resultMap.put("errMsg", "");
		} catch ( IOException e ) {
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