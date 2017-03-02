package amway.com.academy.trainingFee.trainingFeeSpend.web;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.spring.web.servlet.view.JsonView;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.file.service.FileUpLoadService;
import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.trainingFee.common.service.TrainingFeeCommonService;
import amway.com.academy.trainingFee.trainingFeeSpend.service.TrainingFeeSpendService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.web.JSONView;


/**
 * 지출증빙
 * @author KR620208
 *
 */
@Controller
@RequestMapping("/mobile/trainingFee")
public class TrainingFeeSpendMobileController {

	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeeSpendController.class);
	
	@Autowired
	TrainingFeeSpendService trainingFeeSpendService;
	
	/** 파일업로드 */
	@Autowired
	FileUpLoadService fileUpLoadService;
	
	@Autowired
	private TrainingFeeCommonService trainingFeeCommonService;
	
	// adobe analytics
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	/**
	 * 지출증빙
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSpend.do")
	public ModelAndView trainingFeeSpend(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/mobile/trainingFee/trainingFeeSpend");
		DecimalFormat money = new DecimalFormat("#,##0");
		
		Map<String, Object> fiscalYearMap = new HashMap<String, Object>();
		Map<String, Object> tempMap = new HashMap<String, Object>();
		Map<String, String> temp1Map = new HashMap<String, String>();
		
		int lenNum = 1;
		
		if( requestBox.get("givemonth").length() == lenNum ) {
			requestBox.put("givemonth", "0"+requestBox.get("givemonth"));
		}
		
		fiscalYearMap = trainingFeeSpendService.selectTrFeeFiscalYear(requestBox);
		requestBox.put("depaboNo", requestBox.getSession("abono"));
		requestBox.put("trfee"      , fiscalYearMap.get("trfee"));
		requestBox.put("trfeetype"  , fiscalYearMap.get("trfeetype"));
		requestBox.put("spendstatus", fiscalYearMap.get("spendstatus"));
		requestBox.put("planstatus", fiscalYearMap.get("planstatus"));
		requestBox.put("fiscalyear",  fiscalYearMap.get("fiscalyear"));
		requestBox.put("processstatus", fiscalYearMap.get("processstatus"));
		requestBox.put("targetcnt", fiscalYearMap.get("targetcnt"));
		
		/**
		 * 일반 지출 교육일자 - 년도, 월, 일은 선택 가능한 일자로 셋팅
		 */
		String okdata[] = requestBox.get("okdata").split(",");
		
		tempMap.put("tmpMonth", okdata[0]);
		model.addAttribute("planUseMon" , trainingFeeSpendService.selectPlanUseMon(tempMap));
		
		/**
		 * 등록된 사전계획서 리스트 가져오기
		 */
		List<Map<String, String>> spendList = trainingFeeSpendService.selectTrFeeSpendList(requestBox);
		List<Map<String, String>> planList = trainingFeeSpendService.selectTrFeePlanList(requestBox);
		model.addAttribute("spendList", spendList);
		model.addAttribute("planList", planList); // selectbox
		
		if( "U".equals( requestBox.get("mode")) ) {
			model.addAttribute("dataSpend"    , trainingFeeSpendService.selectTrFeeSpend(requestBox));
			model.addAttribute("dataSpendItem", trainingFeeSpendService.selectTrFeeSpendItem(requestBox));
		}
		
		int sizeNum = 0;
		
		if(spendList.size() > sizeNum) {
			temp1Map = spendList.get(spendList.size()-1);
			Long spendAmount = Long.parseLong(requestBox.get("trfee")) - Long.parseLong(temp1Map.get("spendamount").replaceAll(",", ""));
			
			requestBox.put("diffSpendAmount", spendAmount);
			requestBox.put("diffSpendAmountTxt", money.format(spendAmount));
		} else {
			Long spendAmount = Long.parseLong(requestBox.get("trfee"));
			
			requestBox.put("diffSpendAmount", spendAmount);
			requestBox.put("diffSpendAmountTxt", money.format(spendAmount));
		}
		
		String editYN[] = requestBox.get("okdata").split(",");
		String edit     = "N";
		
		for(int i=0;i<editYN.length;i++) {
			int editmm   = Integer.parseInt(editYN[i].substring(1,7));
			int giveyymm = Integer.parseInt(requestBox.get("giveyear")+""+requestBox.get("givemonth"));
			
			if( editmm==giveyymm ) {
				edit = "Y";
			}
		}
		
		requestBox.put("editYn", edit);		
		
		model.addAttribute("scrData", requestBox);
		//adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "mobile");
		return mav;
	}
	
	/**
	 * 지출증빙 수정
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSpendUpdate.do")
	public ModelAndView trainingFeeSpendUpdate(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView("/mobile/trainingFee/trainingFeeSpendUpdate");
		
		if( "U".equals(requestBox.get("rmode")) ) {
			/**
			 * 등록된 사전계획서 리스트 가져오기
			 */
			model.addAttribute("dataSpend"    , trainingFeeSpendService.selectTrFeeSpend(requestBox));
			model.addAttribute("dataSpendItem", trainingFeeSpendService.selectTrFeeSpendItem(requestBox));
			model.addAttribute("planList", trainingFeeSpendService.selectTrFeePlanList(requestBox)); // selectbox
		} else if( "I".equals(requestBox.get("rmode")) ) {
			model.addAttribute("planList", trainingFeeSpendService.selectTrFeePlanList(requestBox)); // selectbox
		} else if( "S".equals(requestBox.get("rmode")) ) {
			model.addAttribute("dataSpend"    , trainingFeeSpendService.selectTrFeeSpend(requestBox));
			model.addAttribute("dataSpendItem", trainingFeeSpendService.selectTrFeeSpendItem(requestBox));
		}
		
		
		model.addAttribute("scrData", requestBox);
		
		return mav;
	}
	
	/**
	 * 지출증빙 등록_일반 지출
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveTrainingFeeSpend.do")
	public ModelAndView saveTrainingFeeSpend(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView(new JsonView());
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int result = 0;
		String sMsgText = "";
		
		requestBox.put("systemtype", "2");
		
		if( "I".equals(requestBox.get("mode")) ) {
			requestBox.put("eventid", "I");
			requestBox.put("systemtext", "[지출증빙] 교육비 지출증빙 등록");
			result = trainingFeeSpendService.inserTrainingFeeSpend(requestBox);
			sMsgText = "지출증빙 내역을 입력 완료 했습니다.";
		} else if( "U".equals(requestBox.get("mode")) ) {
			requestBox.put("eventid", "U");
			requestBox.put("systemtext", "[지출증빙] 교육비 지출증빙 수정");
			result = trainingFeeSpendService.updateTrainingFeeSpend(requestBox);
			sMsgText = "지출증빙 내역 수정 완료 했습니다.";
		} else if( "D".equals(requestBox.get("mode")) ) {
			requestBox.put("eventid", "D");
			requestBox.put("systemtext", "[지출증비] 교육비 지출증빙 삭제");
			result = trainingFeeSpendService.deleteTrainingFeeSpend(requestBox);
			sMsgText = "지출증빙 내역을 삭제 완료 했습니다.";
		}
		
		trainingFeeCommonService.inserTrfeeSystemProcessLog(requestBox);
		
		resultMap.put("errCode", result);
		resultMap.put("errMsg" , sMsgText);
		
		mav.addObject("result", resultMap);
		return mav;
		
	}
	
	/**
	 * 지출증빙 파일업로드 - 각 항목별 업로드 처리를 해야 함 공통 사용 못함.
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fileUpLoadSpend.do")
	public ModelAndView fileUpLoadSpend(ModelMap model, HttpServletRequest request, final MultipartHttpServletRequest multiRequest, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView(new JsonView());
		
		Map<String, Object> rtn = new HashMap<String,Object>();
		
		requestBox.put("userId", requestBox.getSession("abono")); // 사용자 정보는 세션에서 가져 온다.
		requestBox.put("work", "TRFEE");
		
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
				
		// filekey로 구분을 먼저 한다.
		if (!files.isEmpty()) {
			rtn = fileUpLoadService.getInsertTrFeeSpendFile(files, requestBox);
		}
		
		mav.addObject("result", rtn);
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
	@RequestMapping(value = "/saveTrainingFeeSpendConfirm.do")
	public ModelAndView saveTrainingFeeSpendConfirm(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView(new JSONView());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int result = 0;
		
		result = trainingFeeSpendService.updateTrainingFeeSpendConfirm(requestBox);
		
		resultMap.put("errCode", result);
		resultMap.put("errMsg", "");
		
		rtnMap.put("result", resultMap);
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
		
	}
	
}
