package amway.com.academy.trainingFee.trainingFeeSpend.web;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.spring.web.servlet.view.JsonView;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import amway.com.academy.common.file.service.FileUpLoadService;
import amway.com.academy.common.util.CommomCodeUtil;
import amway.com.academy.trainingFee.common.service.TrainingFeeCommonService;
import amway.com.academy.trainingFee.trainingFeePlan.service.TrainingFeePlanService;
import amway.com.academy.trainingFee.trainingFeeSpend.service.TrainingFeeSpendService;

import com.fasterxml.jackson.databind.ObjectMapper;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.web.JSONView;


/**
 * 지출증빙
 * @author KR620208
 *
 */
@Controller
@RequestMapping("/trainingFee")
public class TrainingFeeSpendController {

	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeeSpendController.class);
	
	@Autowired
	TrainingFeeSpendService trainingFeeSpendService;
	
	@Autowired
	TrainingFeePlanService trainingFeePlanService;
	
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
		ModelAndView mav = new ModelAndView("/trainingFee/trainingFeeSpend");
		DecimalFormat money = new DecimalFormat("#,##0");
		
		Map<String, Object> fiscalYearMap = new HashMap<String, Object>();
		Map<String, Object> tempMap = new HashMap<String, Object>();
		Map<String, String> temp1Map = new HashMap<String, String>();
		
		int num = 1;
		int sizeNum = 0;
		
		if( requestBox.get("givemonth").length() == num ) {
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
			if( "0".equals( requestBox.get("sortnum")) ) {
				// rent 정보 가져 오기
				model.addAttribute("dataRent"    , trainingFeePlanService.selectTrFeeRentList(requestBox));
				model.addAttribute("dataRentFile"  , trainingFeePlanService.selectTrFeeRentFileList(requestBox));
			} else if( !"".equals( requestBox.get("sortnum")) && !"0".equals( requestBox.get("sortnum")) ) {
				// plan 정보 가져 오기
				model.addAttribute("dataSpend"    , trainingFeeSpendService.selectTrFeeSpend(requestBox));
				model.addAttribute("dataSpendItem", trainingFeeSpendService.selectTrFeeSpendItem(requestBox));
			}			
		}		
		
		if(spendList.size() > sizeNum) {
			temp1Map = spendList.get(spendList.size()-1);
			Long spendAmount = Long.parseLong(requestBox.get("trfee")) - Long.parseLong(temp1Map.get("spendamount").replaceAll(",", ""));
			Long spendAmountTxt = Long.parseLong(temp1Map.get("spendamount").replaceAll(",", "")) - Long.parseLong(requestBox.get("trfee"));
			
			requestBox.put("diffSpendAmount", spendAmount);
			requestBox.put("diffSpendAmountTxt", money.format(spendAmountTxt));
		} else {
			Long spendAmount = Long.parseLong(requestBox.get("trfee"));
			
			requestBox.put("diffSpendAmount", spendAmount);
			requestBox.put("diffSpendAmountTxt", money.format(spendAmount));
		}
		
		model.addAttribute("scrData", requestBox);
		//adobe analytics
		DataBox analBox = commonCodeUtil.getAnalyticsTag(request, requestBox, "PC");
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
		
		requestBox.put("systemtype", "1");
		
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
	 * 파일 업로드에 필요한 파일키 생성
	 * @param model
	 * @param request
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fileUpLoadFileKey.do")
	public ModelAndView fileUpLoadFileKey(ModelMap model, HttpServletRequest request, RequestBox requestBox) throws Exception{
		ModelAndView mav = new ModelAndView(new JsonView());
		Map<String, Object> resultMap = new HashMap<String, Object>();
		 
		resultMap.put("fileKey",fileUpLoadService.selectFileKey(requestBox));
		
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
	@ResponseBody
	@RequestMapping(value = "/fileUpLoadSpend.do")
	public void fileUpLoadSpend(ModelMap model, HttpServletRequest request, HttpServletResponse response, final MultipartHttpServletRequest multiRequest, RequestBox requestBox) throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		requestBox.put("userId", requestBox.getSession("abono")); // 사용자 정보는 세션에서 가져 온다.
		requestBox.put("work", "TRFEE");
		
		final Map<String, MultipartFile> files = multiRequest.getFileMap();
		Iterator<Map.Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		Map.Entry<String, MultipartFile> entry = itr.next();
		MultipartFile file = entry.getValue();
		int maxSize = 10*1024*1024;
		String rtn = "";
		
		try {
			String orginFileName = file.getOriginalFilename();
			int index = orginFileName.lastIndexOf(".");
	        
	        String fileExt = orginFileName.substring(index + 1);
	        
	        if( fileExt.equals("jpg")||fileExt.equals("jpeg")||fileExt.equals("png")||fileExt.equals("xls")||fileExt.equals("xlsx")||fileExt.equals("doc")||fileExt.equals("docx") 
	        		||fileExt.equals("ppt")||fileExt.equals("pptx")||fileExt.equals("hwp")||fileExt.equals("zip")||fileExt.equals("gif")) {
	        	if(file.getSize()>maxSize) {
					// 오류 처리 - 허용 용량 초과
	        		LOGGER.info(" =============================== 오류 처리 - 허용 용량 초과 ");
					throw new IOException();
				} else {
					if (!files.isEmpty()) {
						rtn = fileUpLoadService.getInsertTrFeeSpendFileKey(files, requestBox);
						resultMap.put("fileKey", rtn);
					}
				}
				
//				ObjectMapper mapper = new ObjectMapper();
//				
//				response.setContentType("text/plain; charset=UTF-8");
//				
//				response.setStatus(200);
//				
//				response.getWriter().write(mapper.writeValueAsString(resultMap));
	        } else {
	        	// 오류 처리 - 허용 하지 않는 파일
	        	LOGGER.info(" =============================== 오류 처리 - 허용 하지 않는 파일 ");
				throw new IOException();
	        }
		} catch (IOException e) {
			e.printStackTrace();
		}
		
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
