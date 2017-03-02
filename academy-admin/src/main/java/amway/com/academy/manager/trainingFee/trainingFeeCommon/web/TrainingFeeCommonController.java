package amway.com.academy.manager.trainingFee.trainingFeeCommon.web;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.main.web.MainController;
import amway.com.academy.manager.trainingFee.trainingFeeCommon.service.TrainingFeeCommonService;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.web.JSONView;

@Controller
@RequestMapping("/manager/trainingFee/trainingFeeCommon")
public class TrainingFeeCommonController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(MainController.class);
	
	@Autowired
	TrainingFeeCommonService trainingFeeCommonService;
	
	/**
	 *  메뉴 리스트 Ajax
	 * @param RequestBox requestBox
	 * @param ModelAndView mav
	 * @return ModelAndView
	 * @throws Exception
	 */
    @RequestMapping(value = "/trainingFeeTargetInfoListAjax.do")
    public ModelAndView trainingFeeTargetInfoListAjax(ModelMap model, RequestBox requestBox, ModelAndView mav) throws Exception {
    	Map<String, Object> rtnMap = new HashMap<String, Object>();

		// 메뉴 리스트(트리)
		rtnMap.put("targetInfo",  trainingFeeCommonService.selectTargetInfoList(requestBox) );
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
}