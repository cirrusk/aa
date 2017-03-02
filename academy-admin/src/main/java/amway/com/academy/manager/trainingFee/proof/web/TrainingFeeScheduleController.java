package amway.com.academy.manager.trainingFee.proof.web;

import java.sql.SQLException;
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

import amway.com.academy.manager.trainingFee.proof.service.TrainingFeeScheduleService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;


/**
 * @author KR620225
 * 교육비_일정괸리
 */
@Controller
@RequestMapping("/manager/trainingFee/proof")
public class TrainingFeeScheduleController {
	
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeeScheduleController.class);
	
	@Autowired
	TrainingFeeScheduleService trainingFeePlanService;
	
	/**
	 * 일정관리 페이지 호출
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeSchedule.do")
	public ModelAndView trainingFeePlan(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		return mav;
	}

	
	/**
	 * 일정관리 리스트
	 * @param requestBox
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeScheduleList.do")
	public ModelAndView trainingFeeScheduleList(RequestBox requestBox, ModelAndView mav) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		//페이징
		PageVO pageVO = new PageVO(requestBox);
		pageVO.setTotalCount(12);
		
		requestBox.putAll(pageVO.toMapData());
		PagingUtil.defaultParmSetting(requestBox);
		
		//리스트
		rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",trainingFeePlanService.selectPlanList(requestBox));
		
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		
		return mav;
	}
	
	/**
	 * 일정관리 상세보기
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeScheduleInsert.do")
	public ModelAndView trainingFeePlanLearPop01(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox) throws Exception{
		
		DataBox trainingFeePlanDetail = trainingFeePlanService.trainingFeePlanDetail(requestBox);
		model.addAttribute("planDetail", trainingFeePlanDetail);
		model.addAttribute("layerMode", requestBox);
		
		return mav;
	}
	
	/**
	 * 일정관리 등록
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeePlanInsertAjax.do")
	public ModelAndView trainingFeePlanInsertAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws SQLException{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> smsMap = new HashMap<String, Object>();
		String msg = "";
		String cod = "0";
		String smssendflag = requestBox.get("smssendflag");
		String case1 = "N";
		String case2 = "N";
		int zeroNum = 0;
		
		try{
			// 중복일정 체크
			List<Map<String, Object>> valMap = trainingFeePlanService.selectTrFeeScheduleVal(requestBox);
			// 대상자 존재여부 체크
			List<Map<String, Object>> targetMap = trainingFeePlanService.selectTrFeeTargetVal(requestBox);
			
			if(valMap.size()==zeroNum) { case1 = "OK"; }
			if(targetMap.size()!=zeroNum) { case2 = "OK"; }
			
			if( "Y".equals(smssendflag) ) {
				if( case1.equals("OK") && case2.equals("OK") ) {
					/**
					 * SMS 발송 정상 처리 후 저장 프로세스
					 */
					smsMap.put("giveyear", requestBox.get("giveyear"));
					smsMap.put("givemonth", requestBox.get("givemonth"));
					smsMap.put("errCode", "");
					smsMap.put("errMsg", "");
					trainingFeePlanService.callSmsAllSend(smsMap);
					
					int rtnCode = (int) smsMap.get("errCode");
					
					if(rtnCode<0) {
						msg = "SMS 발송중 오류가 발생 하였습니다.";
						cod = "-1";
					} else {
						trainingFeePlanService.insertPlanAjax(requestBox);
						msg = "저장 완료 되었습니다.";
						cod = "0";
					}
					
				} else {
					if(valMap.size()>zeroNum) {
						Map<String, Object> getMap = valMap.get(0);
						msg = getMap.get("giveyear") + "년도 "+getMap.get("givemonth")+"월 일정과 중복 됩니다. \n 일자/시간 확인 후 다시 입력 해 주세요.";
					} else {
						msg = requestBox.get("giveyear") + "년도 "+requestBox.get("givemonth")+"월 교육비 지급 대상자가 존재 하지 않습니다.\n지급대상자를 먼저 업로드 후 일정을 입력 해 주세요.";
					}
					cod = "100";
				}
			} else {
				if( case1.equals("OK") ) {
					trainingFeePlanService.insertPlanAjax(requestBox);
					msg = "저장 완료 되었습니다.";
					cod = "0";
				} else {
					Map<String, Object> getMap = valMap.get(0);
					msg = getMap.get("giveyear") + "년도 "+getMap.get("givemonth")+"월 일정과 중복 됩니다. \n 일자/시간 확인 후 다시 입력 해 주세요.";
					cod = "100";
				}
			}
			
			resultMap.put("errCode", cod);
			resultMap.put("errMsg", msg);		
			
		} catch ( SQLException e )
		{
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}
	
	/**
	 * 일정관리 수정
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeePlanUpdateAjax.do")
	public ModelAndView trainingFeePlanUpdateAjax(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws SQLException{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		Map<String, Object> smsMap = new HashMap<String, Object>();
		Map<String, Object> rtnSmsMap = new HashMap<String, Object>();
		
		String msg = "";
		String cod = "0";
		String smssendflag = requestBox.get("smssendflag");
		String case1 = "N";
		String case2 = "N";
		int zeroNum = 0;
		
		try{
			// 중복일정 체크
			List<Map<String, Object>> valMap = trainingFeePlanService.selectTrFeeScheduleVal(requestBox);
			// 대상자 존재여부 체크
			List<Map<String, Object>> targetMap = trainingFeePlanService.selectTrFeeTargetVal(requestBox);
			
			if(valMap.size()==zeroNum) { case1 = "OK"; }
			if(targetMap.size()!=zeroNum) { case2 = "OK"; }
			
			if( "Y".equals(smssendflag) ) {
				if( case1.equals("OK") && case2.equals("OK") ) {
					/**
					 * SMS 발송 정상 처리 후 저장 프로세스
					 */
					smsMap.put("giveyear", requestBox.get("giveyear"));
					smsMap.put("givemonth", requestBox.get("givemonth"));
					smsMap.put("errCode", "");
					smsMap.put("errMsg", "");
					
					rtnSmsMap = trainingFeePlanService.callSmsAllSend(smsMap);
					
					int rtnCode = (int) rtnSmsMap.get("errCode");
					if(rtnCode<0) {
						msg = "SMS 발송중 오류가 발생 하였습니다.";
						cod = "-1";
					} else {
						trainingFeePlanService.trainingFeePlanUpdateAjax(requestBox);
						msg = "저장 완료 되었습니다.";
						cod = "0";
					}
					
				} else {
					if(valMap.size()>zeroNum) {
						Map<String, Object> getMap = valMap.get(0);
						msg = getMap.get("giveyear") + "년도 "+getMap.get("givemonth")+"월 일정과 중복 됩니다. \n 일자/시간 확인 후 다시 입력 해 주세요.";
					} else {
						msg = requestBox.get("giveyear") + "년도 "+requestBox.get("givemonth")+"월 교육비 지급 대상자가 존재 하지 않습니다.\n지급대상자를 먼저 업로드 후 일정을 입력 해 주세요.";
					}
					cod = "100";
				}
			} else {
				if( case1.equals("OK") ) {
					trainingFeePlanService.trainingFeePlanUpdateAjax(requestBox);
					msg = "저장 완료 되었습니다.";
					cod = "0";
				} else {
					Map<String, Object> getMap = valMap.get(0);
					msg = getMap.get("giveyear") + "년도 "+getMap.get("givemonth")+"월 일정과 중복 됩니다. \n 일자/시간 확인 후 다시 입력 해 주세요.";
					cod = "100";
				}
			}
						
			resultMap.put("errCode", cod);
			resultMap.put("errMsg", msg);			
			
		} catch ( SQLException e )
		{
			e.printStackTrace();
			resultMap.put("errCode", "-1");
			resultMap.put("errMsg", e.toString());
		}
		
		rtnMap.put("result", resultMap);
		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT", rtnMap);
		return mav;
	}
}
