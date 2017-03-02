package amway.com.academy.manager.trainingFee.util.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.manager.common.commoncode.service.ManageCodeService;
import amway.com.academy.manager.trainingFee.util.service.TrainingFeeUtilService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;


/**
 * @author KR620225
 * 교육비_시스템 로그
 */
@RequestMapping("/manager/trainingFee/util")
@Controller
public class TrainingFeeUtilController {
	
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeeUtilController.class);
	
	/*
	 * Service
	 */
	@Autowired
	TrainingFeeUtilService trainingFeeUtilService;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/**
	 * SMS 발송이력
	 * @param model
	 * @param request
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSMSLog.do")
	public ModelAndView trainingFeeSMSLog(ModelMap model, HttpServletRequest request, ModelAndView mav) throws Exception{
		return mav;
	}
	
	/**
	 * SMS 발송이력 - 조회
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSMSLog.do")
    public ModelAndView selectSMSLog(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeUtilService.selectSMSLogListCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeUtilService.selectSMSLogList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 시스템로그
	 * @param model
	 * @param request
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSystemLog.do")
	public ModelAndView trainingFeeSystemLog(ModelMap model, HttpServletRequest request, ModelAndView mav) throws Exception{
		return mav;
	}
	
	/**
	 * 시스템로그 - 조회
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSystemLog.do")
    public ModelAndView selectSystemLog(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeUtilService.selectSystemLogListCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeUtilService.selectSystemLogList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
}
