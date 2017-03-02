package amway.com.academy.manager.trainingFee.proof.web;

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
import amway.com.academy.manager.trainingFee.trainingFeeCommon.service.TrainingFeeCommonService;
import amway.com.academy.manager.trainingFee.proof.service.TrainingFeePlanService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;


/**
 * @author KR620225
 * 교육비_사전교육 계획서 컨트롤러
 */
@Controller
@RequestMapping("/manager/trainingFee/proof")
public class TrainingFeePlanConroller {
	
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeePlanConroller.class);
	
	/*
	 * Service
	 */
	@Autowired
	TrainingFeeCommonService trainingFeeCommonService;
	
	@Autowired
	TrainingFeePlanService trainingFeeSpendingService;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/**
	 * 사전교육계획서 page
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeePlan.do")
	public ModelAndView trainingFeeSpending(ModelMap model, 
			HttpServletRequest request, 
			ModelAndView mav,
			RequestBox requestBox
		) throws Exception{
		
		/************ 공통 검색조건 ***************/
		model.addAttribute("searchBR"   , trainingFeeCommonService.selectBRList(requestBox));
		model.addAttribute("searchGrpCd", trainingFeeCommonService.selectGrpCdList(requestBox)); //운영그룹
		model.addAttribute("searchCode" , trainingFeeCommonService.selectCodeList(requestBox));
		model.addAttribute("searchLOA"  , trainingFeeCommonService.selectLOAList(requestBox)); //LOA
		model.addAttribute("searchDept" , trainingFeeCommonService.selectDeptList(requestBox));//dept
		model.addAttribute("searchCPin" , trainingFeeCommonService.selectCPinList(requestBox));
		
		return mav;
	}
	
	/**
	 * 사전교육계획서 상세 page
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeePlanDetail.do")
	public ModelAndView trainingFeePlanDetail(ModelMap model, HttpServletRequest request, ModelAndView mav,	RequestBox requestBox) throws Exception{
		
		/************ 공통 검색조건 ***************/
//		model.addAttribute("searchTarget", trainingFeeCommonService.selectTargetInfoList(requestBox));
		
		return mav;
	}
	
	/**
	 * 사전교육계획서 list
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeePlanListAjax.do")
    public ModelAndView trainingFeePlanListAjax(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		int mon = Integer.parseInt(requestBox.get("searchGiveYear").substring(5, 7));
		int fiscalyear = Integer.parseInt(requestBox.get("searchGiveYear").substring(0, 4));
		String fiscalYear = fiscalyear+"";
		
		if( mon > 10 ) {
			fiscalYear = (fiscalyear + 1)+"";
		}
		
		requestBox.put("fiscalyear", fiscalYear);
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeSpendingService.selectTrainingFeeSpendingListCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeSpendingService.selectTrainingFeeSpendingList(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
    }
	
	/**
	 * 사전교육계획서 상세 list
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeePlanDetailList.do")
	public ModelAndView trainingFeePlanDetailList(RequestBox requestBox, ModelAndView mav) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		manageCodeService.selectCurrentAdNoHistory(requestBox);
		
		int mon = Integer.parseInt(requestBox.get("givemonth"));
		int fiscalyear = Integer.parseInt(requestBox.get("giveyear"));
		String fiscalYear = fiscalyear+"";
		
		if( mon > 10 ) {
			fiscalYear = (fiscalyear + 1)+"";
		}
		
		requestBox.put("fiscalyear", fiscalYear);
		
		PageVO pageVO = new PageVO(requestBox);		
		pageVO.setTotalCount(trainingFeeSpendingService.selectTrainingFeePlanDetailListCount(requestBox));
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeSpendingService.selectTrainingFeePlanDetailList(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
}
