package amway.com.academy.manager.trainingFee.proof.web;

import java.sql.SQLException;
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
import amway.com.academy.manager.trainingFee.proof.service.TrainingFeeCheckListService;
import amway.com.academy.manager.trainingFee.trainingFeeCommon.service.TrainingFeeCommonService;
import framework.com.cmm.common.vo.PageVO;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.PagingUtil;
import framework.com.cmm.web.JSONView;


/**
 * @author KR620225
 * 교육비_체크리스트 컨트롤러
 */
@Controller
@RequestMapping("/manager/trainingFee/proof")
public class TrainingFeeCheckListController {
	
	/** 검색조건  Service */
	@Autowired
	TrainingFeeCommonService trainingFeeCommonService;
	@Autowired
	TrainingFeeCheckListService trainingFeeCheckService;
	
	@Autowired
	ManageCodeService manageCodeService;
	
	/** log */
	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(TrainingFeeCheckListController.class);

	/**
	 * 교육비 체크리스트_페이지 호출
	 * @param model
	 * @param request
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trainingFeeCheckList.do")
	public ModelAndView trainingFeeCheckList(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{
		/************ 공통 검색조건 ***************/
		model.addAttribute("searchBR", trainingFeeCommonService.selectBRList(requestBox)); //br
		model.addAttribute("searchGrpCd", trainingFeeCommonService.selectGrpCdList(requestBox)); //운영그릅
		model.addAttribute("searchCode", trainingFeeCommonService.selectCodeList(requestBox)); //code
		model.addAttribute("searchLOA", trainingFeeCommonService.selectLOAList(requestBox)); //loa
		model.addAttribute("searchDept", trainingFeeCommonService.selectDeptList(requestBox)); //dept
		model.addAttribute("searchCPin" , trainingFeeCommonService.selectCPinList(requestBox));
		
		return mav;
	}
	
	/**
	 * 체크리스트 - 조회
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCheckList.do")
	public ModelAndView selectCheckList(ModelMap model, HttpServletRequest request, ModelAndView mav, RequestBox requestBox ) throws Exception{
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
		pageVO.setTotalCount(trainingFeeCheckService.selectTrainingFeeCheckListCount(requestBox));

    	requestBox.putAll(pageVO.toMapData());
    	PagingUtil.defaultParmSetting(requestBox);
		
		// 리스트
    	rtnMap.putAll(pageVO.toMapData());
		rtnMap.put("dataList",  trainingFeeCheckService.selectTrainingFeeCheckList(requestBox));

		mav.setView(new JSONView());
		mav.addObject("JSON_OBJECT",  rtnMap);
		return mav;
	}
	
	/**
	 * 업로드 처리유무
	 * @param model
	 * @param request
	 * @param mav
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateAs400UploadFalg.do")
	public ModelAndView updateAs400UploadFalg(ModelMap model, HttpServletRequest request,ModelAndView mav,RequestBox requestBox) throws SQLException{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		int result = 0;
		
		try{
			
			result = trainingFeeCheckService.updateAs400UploadFalg(requestBox);
			
			resultMap.put("errCode", result);
			resultMap.put("errMsg", "");			
			
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
