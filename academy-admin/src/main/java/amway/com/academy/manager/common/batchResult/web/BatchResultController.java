package amway.com.academy.manager.common.batchResult.web;

import amway.com.academy.manager.common.batchResult.service.BatchResultService;
import amway.com.academy.manager.common.main.web.MainController;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.common.web.CommonController;
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

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/manager/common/batchResult")
public class BatchResultController extends CommonController {
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(MainController.class);
	
	@Autowired
	private BatchResultService batchResultService;
	
	/**
	 * 배치결과로그 리스트
	 * @param requestBox
	 * @param  mav
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/batchResultList.do")
    public ModelAndView batchResultList(ModelMap model,RequestBox requestBox, ModelAndView mav) throws Exception {
		model.addAttribute("batchname",batchResultService.batchResultNameList(requestBox));
        return mav;
    }

	/**
	 *   배치결과로그 리스트 AJAX
	 * //@param RequestBox requestBox
	 * //@param ModelAndView mav
	 *   @return ModelAndView
	 *   @throws Exception
	 */
	@RequestMapping(value = "/batchResultListAjax.do")
	public ModelAndView batchResultListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();

		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(batchResultService.batchResultListCount(requestBox));

		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);

		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",batchResultService.batchResultList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}

}