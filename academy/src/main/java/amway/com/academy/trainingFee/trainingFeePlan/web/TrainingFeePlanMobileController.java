package amway.com.academy.trainingFee.trainingFeePlan.web;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.trainingFee.common.service.TrainingFeeCommonService;
import amway.com.academy.trainingFee.trainingFeePlan.service.TrainingFeePlanService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.web.JSONView;

@Controller
@RequestMapping("/mobile/trainingFee")
public class TrainingFeePlanMobileController {
	
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeePlanController.class);
	
	@Autowired
	TrainingFeePlanService trainingFeePlanService;

	@Autowired
	private TrainingFeeCommonService trainingFeeCommonService;
	
	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
		
	/**
	 * 사전계획서 등록 폼
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/trainingFeePlan.do")
	public ModelAndView trainingFeePlan(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/mobile/trainingFee/trainingFeePlan");
		DecimalFormat money = new DecimalFormat("#,##0");
		
		Map<String, Object> searchMap     = new HashMap<String, Object>();
		Map<String, Object> searchMap1    = new HashMap<String, Object>();
		Map<String, Object> fiscalYearMap = new HashMap<String, Object>();
		Map<String, String> temp1Map = new HashMap<String, String>();

		int lenNum = 1;
		int sizeNum = 0;
		
		if( requestBox.get("givemonth").length() == lenNum ) {
			requestBox.put("givemonth", "0"+requestBox.get("givemonth"));
		}
		
		fiscalYearMap = trainingFeePlanService.selectTrFeeFiscalYear(requestBox);
		requestBox.put("depaboNo", requestBox.getSession("abono"));
		requestBox.put("fiscalyear", fiscalYearMap.get("fiscalyear"));
		requestBox.put("trfee"     , fiscalYearMap.get("trfee"));
		requestBox.put("trfeetype", fiscalYearMap.get("trfeetype"));
		requestBox.put("planstatus", fiscalYearMap.get("planstatus"));
		requestBox.put("spendstatus", fiscalYearMap.get("spendstatus"));
		requestBox.put("rentstatus", fiscalYearMap.get("rentstatus"));
		requestBox.put("spendconfirmflag", fiscalYearMap.get("spendconfirmflag"));		
		requestBox.put("processstatus", fiscalYearMap.get("processstatus"));
		searchMap.put("fiscalyear",  fiscalYearMap.get("fiscalyear"));
		searchMap.put("schfiscalyear", fiscalYearMap.get("fiscalyear"));
		searchMap1.put("fiscalyear",  fiscalYearMap.get("minfiscalyear"));
		searchMap1.put("schfiscalyear", fiscalYearMap.get("fiscalyear"));
		
		/**
		 * 등록된 사전계획서 리스트 가져오기
		 */
		List<Map<String, String>> planList = trainingFeePlanService.selectTrFeePlanList(requestBox);
		model.addAttribute("planList", planList);
		if(planList.size() > sizeNum) {
			temp1Map = planList.get(planList.size()-1);
			Long spendAmount = Long.parseLong(requestBox.get("trfee")) - Long.parseLong(temp1Map.get("spendamount").replaceAll(",", ""));
			
			requestBox.put("diffSpendAmount", spendAmount);
			requestBox.put("diffSpendAmountTxt", money.format(spendAmount));
		} else {
			Long spendAmount = Long.parseLong(requestBox.get("trfee"));
			
			requestBox.put("diffSpendAmount", spendAmount);
			requestBox.put("diffSpendAmountTxt", money.format(spendAmount));
		}
		
		model.addAttribute("rentMaxMonth", trainingFeePlanService.selectTrFeeRentMonth(searchMap));
		model.addAttribute("rentMonth"   , trainingFeePlanService.selectTrFeeRentMonth(searchMap1));
		model.addAttribute("rentYear"    , trainingFeePlanService.selectTrFeeRentYear(requestBox));
		model.addAttribute("scrData", requestBox);
		//adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "mobile");
		return mav;
	}
	
	/**
	 * 사전계획서 수정
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeePlanUpdate.do")
	public ModelAndView trainingFeePlanUpdate(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/mobile/trainingFee/trainingFeePlanUpdate");
		Map<String, Object> searchMap     = new HashMap<String, Object>();
		Map<String, Object> searchMap1    = new HashMap<String, Object>();
		Map<String, Object> fiscalYearMap = new HashMap<String, Object>();
		
		fiscalYearMap = trainingFeePlanService.selectTrFeeFiscalYear(requestBox);
		
		searchMap.put("fiscalyear",  fiscalYearMap.get("fiscalyear"));
		searchMap.put("schfiscalyear", fiscalYearMap.get("fiscalyear"));
		searchMap1.put("fiscalyear",  fiscalYearMap.get("minfiscalyear"));
		searchMap1.put("schfiscalyear", fiscalYearMap.get("fiscalyear"));
		
		/**
		 * 수정 모드 및 조회 모드로 들어 왔을 경우
		 */
		if( "0".equals( requestBox.get("sortnum")) ) {
			// rent 정보 가져 오기
			model.addAttribute("dataRent"    , trainingFeePlanService.selectTrFeeRentList(requestBox));
			model.addAttribute("dataRentFile", trainingFeePlanService.selectTrFeeRentFileList(requestBox));
			
		} else if( !"".equals( requestBox.get("sortnum")) && !"0".equals( requestBox.get("sortnum")) ) {
			// plan 정보 가져 오기
			model.addAttribute("dataPlan"    , trainingFeePlanService.selectTrFeePlan(requestBox));
			model.addAttribute("dataPlanItem"    , trainingFeePlanService.selectTrFeePlanItem(requestBox));
		}
		
		model.addAttribute("rentMaxMonth", trainingFeePlanService.selectTrFeeRentMonth(searchMap));
		model.addAttribute("rentMonth"   , trainingFeePlanService.selectTrFeeRentMonth(searchMap1));
		model.addAttribute("rentYear"    , trainingFeePlanService.selectTrFeeRentYear(requestBox));
		model.addAttribute("scrData", requestBox);
		
		return mav;
	}
	
	@RequestMapping(value = "/trainingFeePlanInsert.do")
	public ModelAndView trainingFeePlanInsert(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/mobile/trainingFee/trainingFeePlanInsert");
		
		Map<String, Object> searchMap     = new HashMap<String, Object>();
		Map<String, Object> searchMap1    = new HashMap<String, Object>();
		Map<String, Object> fiscalYearMap = new HashMap<String, Object>();
		
		fiscalYearMap = trainingFeePlanService.selectTrFeeFiscalYear(requestBox);
		
		searchMap.put("fiscalyear",  fiscalYearMap.get("fiscalyear"));
		searchMap.put("schfiscalyear", fiscalYearMap.get("fiscalyear"));
		searchMap1.put("fiscalyear",  fiscalYearMap.get("minfiscalyear"));
		searchMap1.put("schfiscalyear", fiscalYearMap.get("fiscalyear"));
		
		/**
		 * 수정 모드 및 조회 모드로 들어 왔을 경우
		 */
		model.addAttribute("scrData", requestBox);
		model.addAttribute("rentMaxMonth", trainingFeePlanService.selectTrFeeRentMonth(searchMap));
		model.addAttribute("rentMonth"   , trainingFeePlanService.selectTrFeeRentMonth(searchMap1));
		model.addAttribute("rentYear"    , trainingFeePlanService.selectTrFeeRentYear(requestBox));
		
		return mav;
	}
	
	/**
	 * 임대차 년도 변경시 월을 변경한다.
	 * @param model
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTrFeeRentMonth.do")
	public ModelAndView selectTrFeeRentMonth(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		Map<String, Object> searchMap     = new HashMap<String, Object>();
		
		searchMap.put("fiscalyear"   , requestBox.get("fiscalyear"));
		searchMap.put("schfiscalyear", requestBox.get("schfiscalyear"));
		
		List<Map<String, String>> dataList = trainingFeePlanService.selectTrFeeRentMonth(searchMap);
		
		mav.addObject("dataList", dataList);
		
		return mav;		
	}
	
	@RequestMapping(value = "/selectTrFeePlanList.do")
	public ModelAndView selectTrFeePlanList(ModelMap model, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
//		Map<String, Object> rtnMap = new HashMap<String, Object>();

		List<Map<String, String>> planList = trainingFeePlanService.selectTrFeePlanList(requestBox);
				
		mav.addObject("planList", planList);
		return mav;
	}
	
	/**
	 * 사전 계획서 등록_일반 지출
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveTrainingFeePlan.do")
	public ModelAndView saveTrainingFeePlan(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int result = 0;
		String sMsgText = "";
		
		requestBox.put("systemtype", "2");
		
		if( "I".equals(requestBox.get("mode")) ) {
			requestBox.put("eventid", "I");
			requestBox.put("systemtext", "[사전계획서] 교육비 사전계획서 등록");
			result = trainingFeePlanService.inserTrainingFeePlan(requestBox);
			sMsgText = "사전계획서 내역 등록 완료 했습니다.";
		} else if( "U".equals(requestBox.get("mode")) ) {
			requestBox.put("eventid", "U");
			requestBox.put("systemtext", "[사전계획서] 교육비 사전계획서 수정");
			result = trainingFeePlanService.updateTrainingFeePlan(requestBox);
			sMsgText = "사전계획서 내역 수정 완료 했습니다.";
		} else if( "D".equals(requestBox.get("mode")) ) {
			requestBox.put("eventid", "D");
			requestBox.put("systemtext", "[사전계획서] 교육비 사전계획서 삭제");
			result = trainingFeePlanService.deleteTrainingFeePlan(requestBox);
			sMsgText = "사전계획서 내역을 삭제 완료 했습니다.";
		}
		
		trainingFeeCommonService.inserTrfeeSystemProcessLog(requestBox);
		
		resultMap.put("errCode", result);
		resultMap.put("errMsg" , sMsgText);
		
		rtnMap.put("result", resultMap);
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
		
	}
	
	/**
	 * 사전 계획서 완료
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveTrainingFeePlanConfirm.do")
	public ModelAndView saveTrainingFeePlanConfirm(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int result = 0;
		
		result = trainingFeePlanService.updateTrainingFeePlanConfirm(requestBox);
		
		resultMap.put("errCode", result);
		resultMap.put("errMsg", "");
		
		rtnMap.put("result", resultMap);
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
		
	}
	
}
